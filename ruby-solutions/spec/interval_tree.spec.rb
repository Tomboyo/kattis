require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/benchmark'
require 'interval_tree'
require 'set'

describe IntervalTree do

  before do
    @tree = IntervalTree.new Interval.new(1, 10)
  end

  describe '#insert' do
    it 'adds an interval with the given value' do
      @tree.insert(Interval.new(1, 10), "1..10")

      @tree.get(Interval.new(1, 10)) do |interval, values|
        assert_equal 1, interval.low
        assert_equal 10, interval.high
        assert_equal 1, values.size
        assert_equal true, values.include?("1..10")
      end
    end
  end

  describe '#get' do
    it 'gets all values intersecting the given range' do
      @tree.insert(Interval.new(1, 10), "1..10")
      @tree.insert(Interval.new(2, 9), "2..9")
      @tree.insert(Interval.new(3, 8), "3..8")
      @tree.insert(Interval.new(2, 2), "2..2")
      @tree.insert(Interval.new(9, 9), "9..9")

      values = Set.new
      @tree.get(Interval.new(2, 9)) do |i, v|
        values.merge(v)
      end

      assert_equal true, values.include?("1..10")
      assert_equal true, values.include?("2..9")
      assert_equal true, values.include?("3..8")
      assert_equal true, values.include?("2..2")
      assert_equal true, values.include?("9..9")
    end

    it 'does not get values outside the range' do
      @tree.insert(Interval.new(1, 1), "1..1")
      @tree.insert(Interval.new(10, 10), "10..10")

      values = Set.new
      @tree.get(Interval.new(2, 9)) do |i, v|
        values.merge(v)
      end

      assert_equal true, values.empty?
    end
  end
end

# Some of the bench* methods are not available yet, so we're not using spec for
# benchmarking
# class Benchmarks < Minitest::Benchmark
#   def self.bench_range
#     bench_exp 10_000, 1_000_000, 10
#   end

#   def bench_initialize
#     assert_performance_constant do |n|
#       100.times { IntervalTree.new n }
#     end
#   end

#   # Large ranges can be inserted without exploring as many nodes. If a range
#   # covers the root, it is inserted at the root.
#   def bench_insert_best_case
#     assert_performance_constant do |n|
#       @tree = IntervalTree.new n
#       100.times { @tree.insert 1..n, :value }
#     end
#   end

#   # A range containing a single value has to be inserted in a leaf. This forces
#   # the tree to explore from root to leaf, creating approximately log(n) nodes
#   # on the way.
#   #
#   # 1_000 reps and relaxed threshold because the runtime growth is subtle.
#   def bench_insert_worse_case
#     assert_performance_logarithmic 0.9 do |n|
#       1000.times do
#         tree = IntervalTree.new n
#         tree.insert 1..1, :value
#       end
#     end
#   end

#   # Lerger ranges are inserted closer to the root, so queries similarly do not
#   # need to descend as deep into the tree. We can find the root's range in
#   # constant time.
#   def bench_get_best_case
#     assert_performance_constant do |n|
#       tree = IntervalTree.new n
#       tree.insert 1..n, :value
#       100.times do
#         tree.get 1..n
#       end
#     end
#   end

#   # Single-value intervals are inserted in leafs, requiring queries to descend
#   # deep into the tree to locate them. There are log(n) layers in a tree to
#   # descend through, so queries should be at worst logarithmic.
#   #
#   # 1_000 reps and relaxed threshold because the runtime growth is subtle.
#   def bench_get_worst_case
#     assert_performance_logarithmic 0.9 do |n|
#       tree = IntervalTree.new n
#       tree.insert 1..1, :value
#       1000.times do
#         tree.get 1..1
#       end
#     end
#   end
# end
