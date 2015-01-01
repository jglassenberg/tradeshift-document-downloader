class AddSentFlagToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :sent_or_received, :string
  end
end
