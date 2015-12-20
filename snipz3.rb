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
