class Meetup < ActiveRecord::Base
  has_many :comments

  validates :name,
    presence: true,
    uniqueness: true
  validates :location, presence: true
  validates :description, presence: true
end
