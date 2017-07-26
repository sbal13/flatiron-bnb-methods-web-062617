class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :set_status

  after_destroy :all_destroyed

  def set_status
  	self.host.host = true
  	self.host.save
  end

  def all_destroyed
  	self.host.update(host: false) if self.host.listings.empty?
  end

  def average_review_rating
  	total = self.reviews.collect{|review| review.rating}.reduce(:+)
  	total.to_f/self.reviews.length
  end


  
end
