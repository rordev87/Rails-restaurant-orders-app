class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Entangled::Model
  entangle
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable ,
         :omniauthable 
       
        acts_as_followable
        acts_as_follower
        has_many :groups

        has_many :orders , :through => :order_user_joins
        #has_and_belongs_to_many :orders
        has_many :order_user_joins

        has_many :items
        has_many :notifications, :foreign_key => :user_id

        
  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0,20]
      end
  end


end
