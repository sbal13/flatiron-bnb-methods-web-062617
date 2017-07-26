class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_string, end_string)
  	start_date = Date.parse(start_string)
  	end_date = Date.parse(end_string)
  	self.listings.select do |listing|
  		listing.reservations.none? do |reservation| 
  			check_reservation(reservation, start_date, end_date)
  		end
  	end
  end

  def all_reservations
  	self.listings.collect do |listing| 
  		listing.reservations if listing.reservations.any?
  	end.flatten.compact
  end


  def self.highest_ratio_res_to_listings
  	self.all.sort_by do |neighborhood| 
  		rate = 0
  		if neighborhood.all_reservations.length != 0 && neighborhood.listings.length != 0
  			rate = neighborhood.all_reservations.length/neighborhood.listings.length
  		end
  		rate
  	end.last
  end



  def self.most_res
  	self.all.sort_by do |neighborhood|
  		neighborhood.all_reservations.length
  	end.last
  end

  private 

  def check_reservation(reservation, start_date, end_date)
  	(reservation.checkin > start_date && reservation.checkin < end_date) || (reservation.checkout > start_date && reservation.checkout < end_date)
  end


end
