class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
	  t.integer "user_id", :null => false
	  t.integer "follow_id", :null => false
	  t.boolean "Favorite", :default => false
      t.timestamps
    end
  end
end
