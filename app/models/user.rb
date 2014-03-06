class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Single table inheritance based on gender.
  self.inheritance_column = :gender
  validates_inclusion_of :gender, :in => [:MaleUser, :FemaleUser], :allow_nil => true, :message => "Please select either male or female as your gender."

  validates :zip, numericality: { only_integer: true , greater_than: 10000}, allow_nil: true

  # TODO Don't say "Date of birth" in validation erorr
  validates :date_of_birth, :inclusion => {:in => Date.new(1900)..Time.now.years_ago(18).to_date, :message => 'You must be at least 18 to sign up!', :allow_nil => true}

  # TODO: Store avatars on S3 and remove public/system folder
  has_attached_file :avatar,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :default_url => "http://placekitten.com/300/300",
    :default_style => :thumb

  # Adds a unique, random token
  before_save :add_invite_token
  def add_invite_token
    if self.invite_token.nil?
      self.invite_token = loop do
        random_token = SecureRandom.urlsafe_base64(6, false).gsub /[^a-z0-9]/i, ''
        break random_token unless User.exists?(invite_token: random_token)
      end
    end
  end

  # Don't remove items from the bitfield list, it'll fuck up all the stored data.
  extend HasBitField
  has_bit_field :setup_progress, :has_seen_intro_screen, :setup_complete, :has_seen_game_explanation

  def gender
    read_attribute(:gender).to_sym if read_attribute(:gender)
  end

  def gender= (value)
    write_attribute(:gender, value.to_s)
  end

  def has_active_game?
    !current_game.nil?
  end

  def can_have_games?
    false
  end

  def profile_is_setup
    !date_of_birth.blank? and !occupation.nil? and !school.nil? and !location.empty?
  end

  def location
    {city: city, state: state, zip: zip}
  end

  def location_string
    "#{city}, #{state}" unless city.blank? or state.blank?
  end

  def current_game
    return nil unless can_have_games?
    games.where('has_ended=?', false).limit(1).first
  end

  def completed_games
    return [] unless can_have_games?
    games.where('has_ended=?', true)
  end

  def is_male
    gender == :MaleUser
  end

  def is_female
    gender == :FemaleUser
  end

  def age
    return nil if date_of_birth.nil?

    now = Time.now.utc.to_date
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end

  def first_name
    return nil if name.nil?
    p = / .+/
    name.gsub p, ''
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        gender_map = {
          "female" => "FemaleUser",
          "male" => "MaleUser"
        }
        user_attrs = {
          :name => auth.extra.raw_info.name,
          :provider => auth.provider,
          :uid => auth.uid,
          :email => auth.info.email,
          :password => Devise.friendly_token[0,20]
        }
        user_attrs[:date_of_birth] = DateTime.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y") unless auth.extra.raw_info.birthday.nil?
        user_attrs[:school] = auth.extra.raw_info.education[0]['school']['name'] unless auth.extra.raw_info.education.nil?
        user_attrs[:occupation] = auth.extra.raw_info.work[0]['position']['name'] unless auth.extra.raw_info.work.nil?
        user_attrs[:gender] = gender_map[auth.extra.raw_info.gender] unless auth.extra.raw_info.gender.nil?
        user_attrs[:avatar] = URI.parse(auth.info.image) unless auth.info.image.nil?
        user_attrs[:relationship_status] = auth.extra.raw_info.relationship_status unless auth.extra.raw_info.relationship_status.nil?

        if !auth.extra.raw_info.location.nil?
          user_city,user_state = auth.extra.raw_info.location['name'].split(',').map(&:strip)
          user_attrs[:city] = user_city
          user_attres[:state] = user_state
        end

        if !auth.extra.raw_info.interested_in.nil?
          if auth.extra.raw_info.interested_in.length == 2
            user_attrs[:interested_in_male] = true
            user_attrs[:interested_in_female] = true
          else
            if auth.extra.raw_info.interested_in[0] == "male"
              user_attrs[:interested_in_male] = true
            else
              user_attrs[:interested_in_female] = true
            end
          end
        end

        user = User.create(user_attrs)

      end
    end
  end

end

class UserWithGames < User
  def can_have_games?
    true
  end
end

class FemaleUser < UserWithGames
  has_many :games, inverse_of: :lady
end

class MaleUser < UserWithGames
  has_many :game_participations, foreign_key: :participant_id
  has_many :games, through: :game_participations

  scope :active, -> { joins{game_participations}.
                      where{
                        (game_participations.accepted_on    != nil) &
                        (game_participations.eliminated_on  == nil)
                      }
                    }

  scope :pending, -> { joins{game_participations}.
                      where{
                        (game_participations.accepted_on  == nil) &
                        (game_participations.expired_on   == nil) &
                        (game_participations.ignored_on   == nil)
                      }
                    }

  scope :ignored, -> { joins{game_participations}.
                      where{
                        (game_participations.ignored_on != nil)
                      }
                    }

  scope :accepted, -> { joins{game_participations}.
                      where{
                        (game_participations.accepted_on != nil)
                      }
                    }

  scope :eliminated, -> { joins{game_participations}.
                      where{
                        (game_participations.accepted_on    != nil) &
                        (game_participations.eliminated_on  != nil)
                      }
                    }

  def featured=(val)
    @featured = val
  end

  def featured
    @featured | false
  end
end
