require 'cuboid'

describe Cuboid do
  describe "#initialize" do
    it "creates a cube with given center" do
      cube = Cuboid.new(4,4,4)
      expect(cube.center).to eq({x: 4, y: 4, z: 4})
    end

    it "sets height, width, and length attributes when dimensions provided" do
      cube = Cuboid.new(3,10,12,6,12,8)
      expect(cube.height).to eq(6)
      expect(cube.width).to eq(12)
      expect(cube.len).to eq(8)
    end

    it "computes max and min values of cuboid's faces" do
      cube = Cuboid.new(3,3,3,6,6,6)
      expect(cube.maxes).to eq({ x: 6, y: 6, z: 6 })
      expect(cube.mins).to eq({ x: 0, y: 0, z: 0 })
    end
  end

  describe "#vertices" do
    it "returns vertices" do
      cube = Cuboid.new(1,1,1,2,2,2)
      expect(cube.vertices.sort).to eq([
        [0,0,0],
        [0,2,0],
        [0,2,2],
        [2,0,0],
        [2,0,2],
        [2,2,0],
        [0,0,2],
        [2,2,2]
      ].sort)
    end

    it "computes vertices (when dimensions provided)" do
      cube = Cuboid.new(3,3,3,6,4,5)
      expect(cube.vertices.sort).to eq([
        [0,5,5.5],
        [0,5,0.5],
        [0,1,5.5],
        [0,1,0.5],
        [6,5,5.5],
        [6,5,0.5],
        [6,1,5.5],
        [6,1,0.5]
      ].sort)
    end

    it "computes correct vertices after rotation, translation" do
      #12x24x12 cuboid centered at 50,50,50, rotated 90 degrees about
      #x axis, will now have dimensions 12x12x24 and vertices:
      #[50 +- 6, 50+-6, 50+- 12]
      cube = Cuboid.new(6,12,12,12,24,12)
      cube.rotatex!
      cube.move_to!(50,50,50)
      expect(cube.vertices.sort).to eq([
        [56,56,62],
        [56,56,38],
        [56,44,62],
        [56,44,38],
        [44,56,62],
        [44,56,38],
        [44,44,62],
        [44,44,38]
      ].sort)
    end
  end

  describe "#move_to!" do
    it "always changes to the provided origin" do
      new_center = [-100,-100,-100]
      cube = Cuboid.new(0,0,0,4,5,6)
      cube.move_to!(*new_center)

      expect(cube.center.values).to eq(new_center)
    end
  end

  describe "#move_to" do
    subject { Cuboid.new(5,5,5,10,10,10)}
    it "returns true when move does not cause collision with boundary" do
      expect(subject.move_to(50,50,50)).to be(true)
    end

    it "moves center to specified coordinates" do
      subject.move_to(50,50,50)
      expect(subject.center.values).to eq([50,50,50])
    end

    it "returns false when overlap would occur with default boundary" do
      expect(subject.move_to(0,0,0)).to be(false)
    end

    it "does not move cuboid if overlap will occur" do
      subject.move_to(-12,0,2)
      expect(subject.center.values).to eq([5,5,5])
    end

    it "returns false when overlap would occur with specified boundary" do
      bounds = { x: 3, y: 1, z: 0 }
      expect(subject.move_to(3,1,0, bounds)).to be(false)
    end

    it "moves center to specified coordinates with specified boundary" do
      bounds = { x: 1, y: 5, z: 10 }
      expect(subject.move_to(6, 10, 15)).to be(true)
      expect(subject.center.values).to eq([6,10,15])
    end
  end

  describe "intersects?" do
    it "detects intersection between two cuboids" do
      cube1 = Cuboid.new(3,3,3,6,6,6)
      cube2 = Cuboid.new(0,0,0,10,10,10)
      expect(cube1.intersects?(cube2)).to be(true)
      expect(cube2.intersects?(cube1)).to be(true)
    end

    it "returns false for two cuboids that are far apart" do
      cube1 = Cuboid.new(3,3,3,6,6,6)
      cube2 = Cuboid.new(100,100,100,5,5,5)
      expect(cube1.intersects?(cube2)).to be(false)
      expect(cube2.intersects?(cube1)).to be(false)
    end

    it "detects when one cuboid is inside another cuboid" do
      cube1 = Cuboid.new(10,10,10,20,20,20)
      cube2 = Cuboid.new(5,5,5,1,1,1)
      expect(cube1.intersects?(cube2)).to be(true)
      expect(cube2.intersects?(cube1)).to be(true)
    end

    it "allows for two cuboids to be adjacent (0 distance from another)" do
      cube1 = Cuboid.new(10,10,10,20,20,20)
      cube2 = Cuboid.new(10,10,30,20,20,20)
      expect(cube1.intersects?(cube2)).to be(false)
      expect(cube2.intersects?(cube1)).to be(false)
    end
  end

  describe "#rotatex!" do
    it "rotates cuboid 90 degrees about the x (height) axis" do
      cube = Cuboid.new(10,10,10,5,10,4)
      expect(cube.width).to eq(10)
      expect(cube.len).to eq(4)
      cube.rotatex!
      expect(cube.center.values).to eq([10,10,10])
      expect(cube.width).to eq(4)
      expect(cube.len).to eq(10)
    end
  end

  describe "#rotatex" do
    it "returns true if rotation about x axis is possible" do
      cube = Cuboid.new(10,10,10,5,10,4)
      expect(cube.rotatex).to be (true)
    end

    it "rotates about x axis if there is room within default boundary" do
      cube = Cuboid.new(10,10,10,5,10,4)
      expect(cube.width).to eq(10)
      expect(cube.len).to eq(4)
      cube.rotatex
      expect(cube.center.values).to eq([10,10,10])
      expect(cube.width).to eq(4)
      expect(cube.len).to eq(10)
    end

    it "rotates about x axis if there is room within arbritrary boundary" do
      bounds = { x: 4, y: 5, z: 10 }
      cube = Cuboid.new(10,10,14,6,6,8)
      expect(cube.width).to eq(6)
      expect(cube.len).to eq(8)
      cube.rotatex
      expect(cube.center.values).to eq([10,10,14])
      expect(cube.width).to eq(8)
      expect(cube.len).to eq(6)
    end

    it "does not rotate if rotation causes cuboid to overlap boundary" do
      bounds = { x: 4, y: 5, z: 10 }
      old_width = 6
      old_length = 8
      cube = Cuboid.new(4,5,10,6,old_width, old_length)
      cube.rotatex(bounds)
      expect(cube.width).to eq(old_width)
      expect(cube.len).to eq(old_length)
    end

    it "returns center minimum distance from boundary required for rotation" do
      cube = Cuboid.new(3,3,4,6,6,8)
      new_center = cube.rotatex
      old_width = 6
      old_length = 8
      expect(cube.rotatex).to eq([3,5,5])
      expect(cube.len).to eq(old_length)
      expect(cube.width).to eq(old_width)
      expect(cube.move_to(3,5,5)).to be(true)
      expect(cube.rotatex).to be(true)
      expect(cube.width).to eq(old_length)
      expect(cube.len).to eq(old_width)
    end
  end
end
