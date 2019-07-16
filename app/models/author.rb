class Author < ApplicationRecord
  validates :name, :surname, presence: true
  has_many :posts

  before_create :default_age

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
