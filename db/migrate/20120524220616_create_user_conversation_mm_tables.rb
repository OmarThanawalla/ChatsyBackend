class CreateUserConversationMmTables < ActiveRecord::Migration
  def change
    create_table :user_conversation_mm_tables do |t|
	  t.integer "user_id"
	  t.integer "conversation_id"
      t.timestamps
    end
  end
end
