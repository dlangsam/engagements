class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable, :omniauth_providers => [:facebook]

	 def self.new_with_session(params, session)
    	super.tap do |user|
     	 if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
       	 user.email = data["email"] if user.email.blank?
      	end
    	end
  	end
 	def self.from_omniauth(auth)
  		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    	user.email = auth.info.email
    	user.password = Devise.friendly_token[0,20]
    	user.first_name = auth.info.first_name 
    	user.last_name = auth.info.last_name 
    	user.oauth_token = auth.credentials.token
    	user.oauth_expires_at = Time.at(auth.credentials.expires_at)
     # assuming the user model has a name
    #user.image = auth.info.image # assuming the user model has an image
 	 end
	end

	def get_friends
		graph = Koala::Facebook::API.new(self.oauth_token)
		profile = graph.get_object("me")
		friends = graph.get_connections("me", "friends", api_version: 'v2.0')
	end

end
