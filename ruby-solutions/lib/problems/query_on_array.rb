require 'interval_tree'

Pair = Struct.new(:range, :sign)

class QueryOnArray
  def initialize(interval_tree, size)
    @tree = interval_tree
    @sums = Array.new(size)

    @sums[0] = 6
    (1..size).each do |i|
      @sums[i] = @sums[i - 1] +
          (i + 1) * (i + 2) * (i + 3)
    end
  end

  def increment_range(range)
    @tree.insert(range, Pair.new(range, 1))
  end

  def decrement_range(range)
    @tree.insert(range, Pair.new(range, -1))
  end

  def eval_range(query_range)
    sum = 0
    @tree.query(query_range).each do |pair|
      intersect = intersect_of query_range, pair.range
      x = intersect.first - pair.range.first
      y = x + intersect.size - 1
      sum += sum(x, y) * pair.sign
    end

    sum
  end

  def intersect_of(range1, range2)
    low = [range1.first, range2.first].max
    high = [range1.end, range2.end].min
    low..high
  end

  def sum(x, y)
    @sums[y] - (x > 0 ? @sums[x - 1] : 0)
  end
end

# if __FILE__ == $0
#   solution = QUeryOnArray.new

#   Size_Of_Array, Number_Of_Queries = gets.split.map(&:to_i)

#   query_on_array = QueryOnArray.new(
#     IntervalTree.new { |tree| tree[1..8] = 0 }
#   )

#   $stdin.each_line do |line|
#     query_on_array.query(
#       line.split
#         .map(&:to_i)
#         .map do |code, _, _|
#           case code
#           when 0: 
#         end
#     )
#   end
# end