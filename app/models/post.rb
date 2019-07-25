class Post < ApplicationRecord
  belongs_to :author
  has_many :ratings
  has_many :users, through: :ratings

  has_many :sections
  has_many :paragraphs, through: :sections

  has_many :comments, as: :commentable

  validates :title, :content, presence: true
  validates :title, length: { maximum: 80 }
end
