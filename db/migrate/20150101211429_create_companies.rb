class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.datetime :docs_last_updated_at
      t.string :ts_account_id
      t.string :name

      t.timestamps
    end
  end
end
