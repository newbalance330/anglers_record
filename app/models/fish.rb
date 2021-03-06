class Fish < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  belongs_to :user
  has_many :fish_comments, dependent: :destroy
  has_many :fish_favorites, dependent: :destroy
  has_many :spots, dependent: :destroy

  attachment :image

  validates :fish_name, presence: true
  validates :lure, presence: true
  validates :address, presence: true
  validates :image, presence: true

  def fish_favorited_by?(user)
    fish_favorites.where(user_id: user.id).exists?
  end

  def self.looks(search, word)
    if word == ""
      @fish = []
    elsif search == "perfect_match"
      @fish = Fish.where("fish_name LIKE?","#{word}")
    elsif search == "partial_match"
      @fish = Fish.where("fish_name LIKE?","%#{word}%")
    else
      @fish = Fish.all
    end
  end


end