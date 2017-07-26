class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  before_validation :convert_dates

  validates :checkin, :checkout, presence: true
  validate :guest_not_host
  validate :valid_length_of_stay
  validate :valid_stay

  def duration
  	checkout.day - checkin.day
  end

  def total_price
  	duration*listing.price
  end

  private

  def convert_dates
  	checkin = Date.parse(checkin) if checkin.present? && checkin.class != Date
  	checkout = Date.parse(checkout) if checkout.present? && checkout.class != Date
  end

  def guest_not_host
  	if self.guest == self.listing.host
  		errors.add(:guest, "You can't rent our your own place!")
  	end
  end

  def valid_length_of_stay
  	if self.checkin && self.checkout &&  self.checkout <= self.checkin
  		errors.add(:checkin, "Invalid date range!")
  	end
  end


  def valid_stay
  	if self.checkin && self.checkout && any_overlap?
  		errors.add(:checkin, "Your dates overlaps with another reservation!")
  	end
  end



  def other_reservations
  	self.listing.reservations
  end

  def any_overlap?
  	other_reservations.any?{|reservation| check_overlapping_reservation(reservation)}
  end


  def check_overlapping_reservation(reservation)
  	(reservation.checkin < self.checkin && self.checkin < reservation.checkout) || (reservation.checkin < self.checkout && self.checkout < reservation.checkout)
  end




end
