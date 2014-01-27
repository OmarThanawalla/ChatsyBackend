class AddLikesToMessages < ActiveRecord::Migration
  
  def change
  	add_column "messages", "likes", :integer,  :default => 0  
  
  end
  
end
