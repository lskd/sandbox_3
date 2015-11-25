class Task < ActiveRecord::Base
  
  geocoded_by :location,
    :latitude => :lat, :longitude => :lng
    after_validation :geocode

end
