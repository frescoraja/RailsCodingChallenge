class Cuboid
  #x: height, y: width, z: length
  @@DFLT_BNDS = { x: 0, y: 0, z: 0 }
  attr_reader :x, :y, :z, :mins, :maxes,
    :height, :width, :len

  def initialize(x, y, z, h = 2, w = 2, l = 2)
    @x, @y, @z = x, y, z
    @len, @width, @height = Float(l), Float(w), Float(h)
    @maxes, @mins = {}, {}
    set_bounds
  end

  def center
    { x: @x, y: @y, z: @z }
  end

  def diag
    Math.sqrt((@maxes[:y] - @y)**2 + (@maxes[:z] - @z)**2)
  end

  def intersects?(other)
    (other.mins[:x] < @maxes[:x] && other.maxes[:x] > @mins[:x]) &&
    (other.mins[:y] < @maxes[:y] && other.maxes[:y] > @mins[:y]) &&
    (other.mins[:z] < @maxes[:z] && other.maxes[:z] > @mins[:z])
  end

  def move_to(x, y, z, bounds = @@DFLT_BNDS)
    container = bounds
    test_center = { x: x, y: y, z: z }
    if will_fit?(test_center, container)
      move_to!(x, y, z)
      true
    else
      false
    end
  end

  def move_to!(x, y, z)
    @x, @y, @z = x, y, z
    set_bounds

    self
  end

  def rotatex(bounds = @@DFLT_BNDS)
    container = bounds
    old_center = self.center
    new_center = {}
    if (container[:x] > @mins[:x])
      new_center[:x] = container[:x] + @height / 2
    end
    [:y, :z].each do |axis|
      new_center[axis] =
        [
          center[axis],
          container[axis] + diag
        ].max
    end
    new_center = old_center.merge(new_center)
    if new_center == old_center
      rotatex!
      true
    else
      new_center.values
    end
  end

  def rotatex!
    @width, @len = @len, @width
    set_bounds
  end

  def vertices
    vertices = []
    [@maxes[:x], @mins[:x]].each do |x|
      [@maxes[:y], @mins[:y]].each do |y|
        [@maxes[:z], @mins[:z]].each do |z|
          vertices.push([x, y, z])
        end
      end
    end

    vertices
  end

  private
  def set_bounds
    @maxes[:x], @mins[:x] = [@x + (@height / 2), @x - (@height / 2)]
    @maxes[:y], @mins[:y] = [@y + (@width / 2), @y - (@width / 2)]
    @maxes[:z], @mins[:z] = [@z + (@len / 2), @z - (@len / 2)]
  end

  def will_fit?(new_center, bounds = @@DFLT_BNDS)
    container = bounds
    new_center.none? do |axis, val|
      diff = center[axis] - new_center[axis]
      @mins[axis] - diff < container[axis]
    end
  end
end
