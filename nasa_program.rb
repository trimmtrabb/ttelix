# frozen_string_literal: true

module FuelCalculator
  # Example:
  # FuelCalculator.calculate(28801,
  #                          [[:launch, 9.807], [:land, 1.62],
  #                           [:launch, 1.62],  [:land, 9.807]])

  class << self
    def calculate(mass, mission_data)
      mission_data.reverse.reduce(0) do |sum, route|
        added_fuel = fuel_with_extra(mass, *route)
        mass = mass + added_fuel
        sum + added_fuel
      end
    end

    private

    def fuel_with_extra(mass, action, gravity)
      base = base_fuel(mass, action, gravity)
      base + extra_fuel(base, action, gravity)
    end

    def extra_fuel(unhandled, action, gravity)
      extra = 0
      until (added = base_fuel(unhandled, action, gravity)) < 0
        extra = extra + added
        unhandled = added
      end
      extra
    end

    def base_fuel(mass, action, gravity)
      case action
      when :launch then (mass * gravity * 0.042 - 33).floor
      when :land then (mass * gravity * 0.033 - 42).floor
      end
    end
  end
end
