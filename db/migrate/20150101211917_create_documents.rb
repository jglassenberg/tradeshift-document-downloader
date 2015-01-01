class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :company, index: true
      t.string :ts_doc_id
      t.datetime :last_activity_at
      t.string :sender_name
      t.string :receiver_name
      t.string :type
      t.datetime :issue_date
      t.string :status
      t.decimal :amount_before_tax
      t.decimal :tax
      t.string :currency

      t.timestamps
    end
  end
end
