class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :conversation
	
	validates_presence_of :message_content, :user_id, :conversation_id
	
	#validates :Message_Content, :length => { :maximum => 160 }
	
end
