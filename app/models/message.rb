class Message < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :body
    
  def self.get
    find(:all, :limit => 50, :order => 'messages.id desc', :include => :user)
  end
  
  def self.more(id)
    find(:all, :limit => 100, :order => 'messages.id desc', :include => :user, :conditions => ['messages.id < ?', id])
  end
  
  def self.refresh(id, current_user)
    find(:all, :order => 'messages.id desc', :include => :user, :conditions => ['messages.id > ? and user_id != ?', id, current_user])
  end
  
  def to_s
    body
  end
end
