class AddSaltColumn < ActiveRecord::Migration
  def up
  	add_column("users", "salt", :string, :limit => 225)
  end

  def down
  	remove_column("users", "salt")
  end
end
