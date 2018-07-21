require 'set'

# Associates values with integer ranges.
class IntervalTree
  attr_reader :left, :right, :range, :values

  def initialize(range)
    @range = range
    @values = []
  end

  def insert(range, value)
    if IntRanges.a_covers_b? @range, range
      @values << value
    else
      if (@left.nil? || @right.nil?) && @range.size > 1
        low = @range.first
        high = @range.end
        middle = (@range.size / 2) + low - 1
        @left ||= IntervalTree.new(low..middle)
        @right ||= IntervalTree.new((middle + 1)..high)
      end

      if IntRanges.intersect? @left.range, range
        @left.insert range, value
      end

      if IntRanges.intersect? @right.range, range
        @right.insert range, value
      end
    end
  end

  def query(range, result_set = Set.new)
    if IntRanges.intersect? @range, range
      result_set.merge @values
    end
      
    if IntRanges.intersect? @left&.range, range
      @left.query range, result_set
    end

    if IntRanges.intersect? @right&.range, range
      @right.query range, result_set
    end

    result_set
  end

  def to_s
    "[#{@range}]=>#{@values.to_s}"
  end

  def pretty_print(indent = 0, string = "")
    string << " " * indent << to_s << "\n"
    @left&.pretty_print(indent + 2, string)
    @right&.pretty_print(indent + 2, string)
    string
  end
end

module IntRanges
  # Test if the first range covers the second range
  # a_covers_b?(1..10, 2..9) == true
  # a_covers_b?(1..10, 1..10) == true
  # a_covers_b?(1..10, 1..11) == false
  # a_covers_b?(1..10, 0..10) == false
  def self.a_covers_b?(a, b)
    b.first <= a.first &&
        a.end <= b.end
  end

  # Test if two ranges intersect
  # intersect?(1..2, 2..4) == true
  # intersect?(1...2, 2..4) == false
  def self.intersect?(a, b)
    if a.nil? || b.nil?
      false
    else
      last_in(a) >= b.first &&
          a.first <= last_in(b)
    end
  end

  # get the last included integer in the given range
  # last_in(1..2) == 2
  # last_in(1...3) == 2
  def self.last_in range
    if range.exclude_end?
      range.end - 1
    else
      range.end
    end
  end
end