# == Schema Information
# Schema version: 20090218124612
#
# Table name: blogs
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime        
#  updated_at :datetime        
#  owner_id   :integer(4)      
#  owner_type :string(255)     
#

class Blog < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  has_many :posts, :order => "created_at DESC", :dependent => :destroy,
                   :class_name => "BlogPost"
end
