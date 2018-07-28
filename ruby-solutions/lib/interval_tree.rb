require 'set'

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
    "[#{@low},  #{@high}]"
  end
end

class  IntervalList
  attr_accessor :interval, :values, :next

  def initialize(interval, values = [], next_node = nil)
    if !values.kind_of?(Array)
      throw "Values not kind of array!"
    end

    @interval = interval
    @values = values
    @next = next_node
  end

  def low
    @interval.low
  end

  def high
    @interval.high
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
      trisect_around! interval
      [self, @next, @next.next]
    else
      if low < interval.low
        bisect_after! interval.low - 1
      else
        bisect_after! interval.high
      end
      [self, @next]
    end
  end

  private def trisect_around! interval
    tmp_next = @next
    tmp_high = high

    @interval.high = interval.low - 1
    @next = IntervalList.new(
      interval,
      @values.clone,
      IntervalList.new(
        Interval.new(interval.high + 1, tmp_high),
        @values.clone,
        tmp_next
      )
    )
  end

  private def bisect_after! point
    tmp_high = high
    tmp_next = @next

    @interval.high = point
    @next = IntervalList.new(
      Interval.new(point + 1, tmp_high),
      @values.clone,
      tmp_next
    )
  end

  def to_s
    "<#{@interval} #{@values} #{@next&.interval}>"
  end
end

# Associates values with integer ranges.
class IntervalTree

  def initialize(entire_interval)
    @interval_list = IntervalList.new(
      entire_interval
    )
  end

  def to_s
    @interval_list.to_s
  end

  def insert(interval, value)
    each_in_interval(interval) do |node|
      node.split_around!(interval).each do |subnode|
        subnode.values << value unless
            interval.disjoint? subnode.interval
      end
    end
  end

  def each_in_interval(interval)
    current = find_first(interval.low)
    while current&.low&. <= interval.high
      tmp_next = current.next
      yield current
      current = tmp_next
    end
  end

  private def find_first(point)
    #TODO: use a BST
    current = @interval_list
    while current&.next&.low&. <= point
      current = current.next
    end
    current
  end

  def get interval
    each_in_interval(interval) do |node|
      yield node.interval, node.values
    end
  end
end
