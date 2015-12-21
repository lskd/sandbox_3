






#http://stackoverflow.com/questions/18082778/rails-checking-if-a-record-exists-in-database
# checking if a record exisit
if Trucks.where(:id => currrent_truck.id).blank?
  # no truck record for this id
else
  # at least 1 record for this truck
end
# where method returns an ActiveRecord::Relation object (acts like an array which contains the
# results of the where), it can be emtpy but never nil.
if Truck.exists?(10)
  # your truck e4xists in the db
else
  # the truck doesn't exists in db
end

# simple solution to combine DB check and retrieval of data into 1 DB query
# Note: using rails 4 / Ruby 2 syntax
first_truck = Truck.select(:truck_no).find_by(id) # => <Truck id: nil, truck_no: "123"> OR nil if no record matches criteria

if first_truck
  truck_number = first_truck.truck_no
  # do some processing...
else
  # record does not exist with that criteria
end
# Can go extra by adding method to Truck class does this for you and conveys intent:
# truck.rb model
class Truck < Activerecord::Base
  def self.truck_number_if_exists(record_id)
    record = Truck.select(:truck_no).find_by(record_id)
    if record
      record.truck_no
    else
      nil # explicit nil so other developers know exactly what's going on
    end
  end
end

# then you call it like so
if truck_number = Truck.truck_number_if_exists(id)
  # do processing because record exists and you have the value
else
  # no matching criteria
end

# ActiveRecord.find_by method will retrieve the first record that matches your criteria or else
# returns nil if no record is found with that criteria. Note that the order of the find_by and where
# methods is importnat; you must call the select on the Truck model. This is because when you
# call the where method you're actually returning an ActiveRelation object which is not what
# you're looking for here

# exists? method is engineered specifically to check for the existence of something. It doesn't return the value, just confirms that
# the DB has a record that matches some criteria
# verify uniqueness or accuracy of some piece of data. Allows one to use ActiveRelation(Record?) where(...) criteria.
# example of User model with email attribute and need to see if a value already exists
User.exists?(email: "test@test.com")
# if you need to conditionally retrieve data from a DB this isn't th method to use.
# does work great for simple checking and syntax is clear to other developers#
# let the code comment itself

#
# http://stackoverflow.com/questions/302782/rails-how-do-i-check-if-a-column-has-a-value
# kinda ok..
# http://stackoverflow.com/questions/11932960/check-db-value-in-rails-view
#
# http://stackoverflow.com/questions/13790263/ruby-on-rails-check-if-query-result-is-empty-model-find
# sells blank?
# Customer.where(:name=> $login_name) # will return you AcitveRecord::Relation (which can have 0-n results) always.
# and empty? method will work on it
#
# https://hackhands.com/ruby-on-enums-queries-and-rails-4-1/
# http://apidock.com/rails/ActiveRecord/Base/exists%3F/class
#


#













# Create defaults via a hash and woory not on Argument order
# below shows some methods to do thus
#

#
# Cntrl-shift K : Delete line
# apple L : Select line
# Ctrl + apple + Up/Down: move line(s) up or down
# apple Z,Y: go back to where I was
#


# specifying defaults using ||
# using args Hash : not best with boolean args
# @bool = args[:boolean_thing]  || true # can't set false or nil
def initialize(args)
  @chainring = args[:chainring] ||  40
  @cog       = args[:cog]       ||  18
  @wheel     = args[:wheel]
end

# specifying defaults using fetch
# advantach over || method of defaults allows for @chainring & @cog to be false or nil
def initialize(args)
  @chainring  = args.fetch(:chainring, 40)
  @cog        = args.fetch(:cog, 18)
  @wheel      = args[:wheel]
end

# defaults via default method
# removes defaults away from initialize known as isolation technique
# helps with complicated defaults
def initialize(args)
  args = defaults.merge(args)
  @chainring = args[:chainring]
# ...
end

def defaults
  { :chainring => 40, :cog => 18 }
end
###


# Gear initialized with an objec tthat can respond to diameter: via dependency injection
#
#
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring  = chainring
    @cog        = cog
    @wheel      = wheel
  end

  def gear_inches
    ratio * wheel.diameter
  end
#...
end
# Gear expects a 'Duck' that knows 'diameter'
Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches
# uses @wheel to hold , and wheel method to access this object
# moving creation of new Wheel instance outside of Gear decouples
# the two classes. Gear can now collaborate with any object that implements diameter.

###


#
# Isolate Multiparameter Initialization
#
# When Gear is part of an external interface
module SomeFramework
    class Gear
      attr_reader :chainring, :cog, :wheel
      def initialize(chainring, cog, wheel)
        @chainring  = chainring
        @cog        = cog
        @wheel      = wheel
      end
      # ...
    end
  end

  # wrap the interface to protect yourself from changes
  module GearWrapper
    def self.gear(args)
      SomeFramework::Gear.new(args[:chainring],
                              args[:cog],
                              args[:wheel])
    end
  end

# Now you can create a new Gear using an arguments hash.
GearWrapper.gear(
    :chainring  =>  52,
    :cog        =>  11,
    :wheel      =>  Wheel.new(26, 1.5)).gear_inches
# substituting an options hash for a list of fixed-order arguments is perfect for classes where you are forced to depend on external interfaces
# that you cannot change. Protect yourself by wrapping each in a method that is owned by your own applicatoin
# Note, its a module instead of a class. GearWrapper  is responsible for creating new instances of SomeFrameork::gear. Allsoed separate and distinct
# object sto which you can send and conveying the indea that you don't esxpect to have instances of GearWrapper.
###


### Duck Typing snippet and words from S. Metz OOD Pg 94-ish
## The prepare method now expects its arguments to be Preparers and each argumen's class# implements the new interface.
## The ability to tolerate ambiguity about the class of an object is the hallmark of
## a cofident disgner.
## Once you begin to treat your objects as if they are defined by their behavior
## rather than by their class, you enter into a new real of
##  expressive flexible design. (listen to their messages)
#
# Trip preparation becomes easier
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each { |preparer|
      preparer.prepare_trip(self)}
    end
  end

  #when ever preparer is a Duck# that responds to 'prepare_trip'
  class Mechanic
    def prepare_trip(trip)
      trip.bicycles.each {|bicycle|
        prepare_bicycle(bicycle)}
    end #the code doesn't have a second end which I expect for the . each iterator

    #...
  end

  class TripCoordinator
    def prepare_trip(trip)
      buy_food(trip.customers)
    end

    #...
  end

  class Driver
    def prepare_trip(trip)
      vehicle = trip.vehicle
      gas_up(vehicle)
      fill_water_tank(vehicle)
    end
    #...
  end
  #...
end
###
###
