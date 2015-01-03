class RenameSentOrReceivedToSenderReceiver < ActiveRecord::Migration
  def change
    rename_column :documents, :sent_or_received, :sender_receiver
  end
end
