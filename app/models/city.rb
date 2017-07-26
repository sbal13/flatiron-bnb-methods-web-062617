class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_string, end_string)
  	start_date = Date.parse(start_string)
  	end_date = Date.parse(end_string)
  	self.listings.select do |listing|
  		listing.reservations.none? do |reservation| 
  			check_reservation(reservation, start_date, end_date)
  		end
  	end
  end

  def all_reservations
  	self.listings.collect{|listing| listing.reservations}.flatten
  end


  def self.highest_ratio_res_to_listings
  	self.all.sort_by do |city| 
  		city.all_reservations.length.to_f/city.listings.length
  	end.last
  end



  def self.most_res
  	self.all.sort_by do |city|
  		city.all_reservations.length
  	end.last
  end

  private 

  def check_reservation(reservation, start_date, end_date)
  	(reservation.checkin > start_date && reservation.checkin < end_date) || (reservation.checkout > start_date && reservation.checkout < end_date)
  end

end

