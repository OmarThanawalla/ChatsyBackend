class EnforceEmailAndRelationshipsUnique < ActiveRecord::Migration
  def up
  	add_index(:followers, [:user_id, :follower_id], :unique => true, :name => 'FollowersProtection')
  	add_index(:follows, [:user_id, :follow_id], :unique => true, :name => 'FollowProtection')
  end

  def down
  	remove_index :followers, :name => 'FollowersProtection'
  	remove_index :follows, :name => 'FollowProtection'
  end
end
