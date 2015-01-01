class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :company, index: true
      t.string :ts_acount_id
      t.string :name
      t.string :email
      t.datetime :last_login_at
      t.string :oauth_token
      t.string :oauth_secret

      t.timestamps
    end
  end
end
