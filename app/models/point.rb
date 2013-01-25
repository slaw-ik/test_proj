class Point < ActiveRecord::Base

  #=================== Gmaps4Rails===================================
  acts_as_gmappable :process_geocoding => true, :validation => false
  before_create :address_presence
  #==================================================================

  #=================== Geocoder =====================================
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  #==================================================================

  attr_accessible :address, :gmaps, :description, :latitude, :longitude, :no_geocode, :user_id
  attr_accessor :no_geocode

  belongs_to :user

  def gmaps4rails_address
    address
  end

  def self.prepare_parameters(data, user)
    data[:no_geocode] = true
    data[:user_id] = user.id
    return {:point => self.new(data)}
  end

  private

  def address_presence
    Point.acts_as_gmappable :process_geocoding => !self.address.blank? && !self.no_geocode, :validation => false
    return true
  end
end
