class AddProfilePictureColumn < ActiveRecord::Migration
  def up
  	add_attachment :users, :profilePic #table, column
  end

  def down
  	remove_attachment :users, :profilePic
  end
end
