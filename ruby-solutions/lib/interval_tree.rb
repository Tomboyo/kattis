require 'set'

# Associates values with integer ranges.
class IntervalTree
  attr_reader :left, :right, :range, :values

  def initialize(range)
    @range = range
    @values = []
    
    # this is very expensive and should be removed.
    @range.singleton_class.include(IntRanges)
  end

  def insert(range, value)
    if @range.covered_by? range
      @values << value
    else
      if (@left.nil? || @right.nil?) && @range.size > 1
        low = @range.first
        high = @range.end
        middle = (@range.size / 2) + low - 1
        @left ||= IntervalTree.new(low..middle)
        @right ||= IntervalTree.new((middle + 1)..high)
      end

      if @left.range.intersect? range
        @left.insert range, value
      end

      if @right.range.intersect? range
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
end

module IntRanges
  # Returns the last included integer in the range. For two IntRanges,
  #   (1..n).end == (1...(n + 1)).end
  def end
    if exclude_end?
      super - 1
    else
      super
    end
  end

  def covered_by?(other)
    other.first <= self.first &&
      self.end <= other.end
  end

  def intersect?(other)
    self.end >= other.first &&
        self.first <= other.end
  end

  def self.intersect?(a, b)
    if a.nil? || b.nil?
      return false
    end
    
    a.end >= b.first &&
        a.first <= b.end
  end
end