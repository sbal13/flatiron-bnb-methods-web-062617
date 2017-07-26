class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validates_associated :reservation
  validate :after_checkout

  def after_checkout
  	if reservation.present? && reservation.checkout > Date.today
  		errors.add(:reservation, "You have not checked out yet!")
  	end
  end

end
