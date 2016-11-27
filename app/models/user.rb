class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      # user.username = auth.info.nickname
    end
  end
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new session["devise.user_attributes"] do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  
  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  # def self.find_for_facebook_oauth(response, signed_in_resource=nil)
  #   data = response['extra']['user_hash']
  #   access_token = response['credentials']['token']
  #   user = User.find_by_email(data["email"])
  #   # only log in confirmed users
  #   # that way users can't spoof accounts
  #   if user and user.confirmed?
  #     user.update_attribute('fb_access_token', access_token) 
  #     user
  #   end
  # end
  # def fb
  #   @graph = Koala::Facebook::API.new("@user.fb_access_token")
  # end

  # def self.koala(auth)
  #   access_token = auth['token']
  #   facebook = Koala::Facebook::API.new(access_token)
  #   facebook.get_object("me?fields=name,picture")
  # end

  # def facebook
  #   @facebook ||= Koala::Facebook::API.new(@user.fb_access_token)
  #   block_given? ? yield(@facebook) : @facebook
  # rescue Koala::Facebook::APIError => e
  #   logger.info e.to_s
  #   nil # or consider a custom null object
  # end

  # def friends_count
  #   facebook { |fb| fb.get_connection("me", "friends").size }
  # end

end
