attributes :email, :id, :name, :gender, :date_of_birth, :occupation, :school, :city, :state, :zip, :created_at, :age, :first_name, :featured

node(:avatar) { |user| {thumb: user.avatar.url(:thumb), medium: user.avatar.url(:medium)} }

unless locals[:with_games] == false
  node :games do |user|
    {
      :current => partial('game/item', :object => user.current_game),
      :completed => user.completed_games.map {|g| partial('game/item', :object => g)}
    }
  end
end
