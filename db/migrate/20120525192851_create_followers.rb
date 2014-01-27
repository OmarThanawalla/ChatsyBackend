class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
	  t.integer "user_id", :null => false
	  t.integer "follower_id", :null => false #points back to user_id 
	  t.boolean "Confirmed", :default => false #user must confirm follower
	  
      t.timestamps
    end
  end
end
