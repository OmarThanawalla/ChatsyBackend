class AddUsername < ActiveRecord::Migration
  def up
  	add_column("users", "userName", :string)
  end

  def down
  	remove_column("users", "userName")
  end
end
