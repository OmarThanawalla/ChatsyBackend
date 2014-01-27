class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
	  t.integer "user_id", :null => false #the person who likes
	  t.integer "message_id", :null => false #the message that recieves likes
	  t.boolean "favors", :default => false
      t.timestamps
    end
  end
end
