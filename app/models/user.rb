class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable ,
         :omniauthable 
       
<<<<<<< HEAD
        acts_as_followable
        acts_as_follower
        has_many :groups
        has_many :orders , :through => :users_orders
        has_many :items
        has_many :sent_notifications ,:class_name => notifications ,:foreign_key => :sender_id
        has_many :recieved_notifications ,:class_name => notifications ,:foreign_key => :reciever_id
=======
>>>>>>> fbf350c8abd4b4e6cf1c839c62c094af2d63fa98
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
