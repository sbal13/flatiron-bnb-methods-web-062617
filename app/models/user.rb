class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
  	self.listings.collect do |listing|
  		listing.guests
  	end.flatten
  end

  def hosts
  	self.trips.collect do |trip|
  		trip.listing.host
  	end.uniq
  end

  def host_reviews
  	self.guests.collect do |guest|
  		guest.reviews.select do |review|
  			self.listings.include?(review.reservation.listing)
  		end
  	end.flatten
  end
  
end
