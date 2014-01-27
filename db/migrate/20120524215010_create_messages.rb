class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
	  t.text "message_content", :null => false
	  t.integer "user_id", :null => false #creator of message
	  t.integer "conversation_id", :null => false #a message belongs to a conversation
      t.timestamps
    end
  end
end
