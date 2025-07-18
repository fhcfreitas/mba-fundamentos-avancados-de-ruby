class Vector2
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def *(number)
    if number.is_a?(Numeric)
      Vector2.new(@x * number, @y * number)
    elsif number.is_a?(Vector2)
      @x * number.x + @y * number.y
    else 
      raise ArgumentError, "Cannot multiply Vector2 by #{number.class}"
    end
  end

  def coerce(number)
    [self, number]
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end


v = Vector2.new(3, 4)
puts v * 2
puts v * 2.5
puts v * v
puts 2 * v
puts 2.5 * v
