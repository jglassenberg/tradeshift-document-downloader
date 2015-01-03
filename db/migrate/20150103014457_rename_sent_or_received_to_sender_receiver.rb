class RenameSentOrReceivedToSenderReceiver < ActiveRecord::Migration
  def change
    rename_column :documents, :sent_or_received, :sent_received
  end
end
