class NewTokens < ActiveRecord::Migration
  def up
  	add_column("users", "deviceTokens", :string, :default => "")
  end

  def down
  	 remove_column("users", "deviceTokens")
  end
end
