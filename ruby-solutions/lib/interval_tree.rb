require 'binary_search_tree'

class Interval
  attr_accessor :low, :high

  def initialize low, high
    if !high.kind_of?(Numeric) || !low.kind_of?(Numeric)
      throw "#{low}, #{high} must be numbers"
    end

    @low = low
    @high = high
  end

  # Shares no common points with interval other
  def disjoint? other
    @high < other.low ||
        @low > other.high
  end

  # Endpoints are contained by interval other
  def subinterval_of? other
    other.low <= @low &&
        @high <= other.high
  end

  # Is a subinterval of other and does not share endpoints
  # with other
  def proper_subinterval_of? other
    other.low < @low &&
        @high < other.high
  end

  def to_s
    "[#{@low}, #{@high}]"
  end
end

class  IntervalList
  include Enumerable

  attr_accessor :interval, :values, :next

  def initialize(interval, values = [], next_node = nil)
    if !values.kind_of?(Array)
      throw "Values not kind of array!"
    end

    @interval = interval
    @values = values
    @next = next_node
  end

  # Subdivides the current list-node in-place about the
  # given interval and returns an array containing the
  # sublist nodes thus created or modified.
  #
  # If a list node containing [1..5] is split about [2..2],
  # the result will be an array of three nodes: [1..1],
  # [2..2], [3..5].
  def split_around! interval
    if @interval.subinterval_of?(interval) ||
        @interval.disjoint?(interval)
      [self]
    elsif interval.proper_subinterval_of? @interval
      bisect_at! interval.low - 1
      @next.bisect_at! interval.high
      [self, @next, @next.next]
    else
      if @interval.low < interval.low
        bisect_at! interval.low - 1
      else
        bisect_at! interval.high
      end
      [self, @next]
    end
  end

  # Bisect this interval list at the given point. This
  # modifies the current list in-place and creates a new
  # list to hold the other half of the original interval.
  # The new list interval excludes the point, whereas this
  # list interval includes it.
  #
  # < 1..5 >.bisect_at! 3
  #     #=> < 1..3 next:<4..5> >
  protected def bisect_at! point
    tmp_high = @interval.high
    tmp_next = @next

    @interval.high = point
    @next = IntervalList.new(
      Interval.new(point + 1, tmp_high),
      @values.clone,
      tmp_next
    )
  end

  def each
    current = self
    while current
      yield current
      current = current.next
    end
  end

  def to_s
    "(#{@interval}: #{@values})"
  end
end

# Associates values with integer ranges.
class IntervalTree

  def initialize(entire_interval)
    @interval_list = IntervalList.new(entire_interval)
    @index = BinarySearchTree.new
  end

  def to_s
    @interval_list.to_s
  end

  def insert(interval, value)
    each_in_interval(interval) do |node|
      node.split_around!(interval).each do |subnode|
        @index.put subnode.interval.low, subnode
        subnode.values << value unless
            interval.disjoint? subnode.interval
      end
    end
  end

  def each_in_interval(interval)
    current = find_first(interval.low)
    while current&.interval&.low&. <= interval.high
      tmp_next = current.next
      yield current
      current = tmp_next
    end
  end

  private def find_first(point)
    @index.findLargestAtMost(point) || @interval_list
  end

  def get interval
    each_in_interval(interval) do |node|
      yield node.interval, node.values
    end
  end

  def pretty_to_s
    intervals = @interval_list.map do |it|
      it.to_s
    end.join(" -> ")
    <<~PRETTY
      Intervals: #{intervals}
      Index: #{@index.pretty_to_s}
    PRETTY
  end
end
