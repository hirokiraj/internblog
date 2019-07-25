class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :ratings
  has_many :posts, through: :ratings

  has_many :followed_followings, class_name: 'Following', foreign_key: 'followee_id'
  has_many :followed_users, through: :followed_followings, class_name: 'User', foreign_key: 'followee_id'

  has_many :follower_followings, class_name: 'Following', foreign_key: 'follower_id'
  has_many :followees, through: :follower_followings, class_name: 'User', foreign_key: 'follower_id'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
