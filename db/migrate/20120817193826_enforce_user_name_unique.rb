class EnforceUserNameUnique < ActiveRecord::Migration
  def up
  	add_index(:user_conversation_mm_tables, [:user_id, :conversation_id], :unique => true, :name => 'noRepeats')
  end

  def down
  	remove_index :user_conversation_mm_tables, :name => 'noRepeats'
  end
end
