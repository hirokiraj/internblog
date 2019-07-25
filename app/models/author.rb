class Author < ApplicationRecord
  validates :name, :surname, presence: true
  has_many :posts, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :comments, as: :commentable

  before_create :default_age

  enum status: [:active, :retired]

  scope :old, -> { where('age > 30') }

  def fullname
    "#{name} #{surname}"
  end

  def self.delete_old_authors
    Author.old.destroy_all
  end

  private

  def default_age
    self.age = 25 unless age
  end
end
