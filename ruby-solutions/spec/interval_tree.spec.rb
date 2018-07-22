require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/benchmark'
require 'interval_tree'

describe IntervalTree do

  before do
    @tree = IntervalTree.new(1..10)
  end

  describe '#insert' do
    it 'adds an interval with the given value' do
      @tree.insert(1..10, "1..10")

      assert_equal 1..10, @tree.range
      assert_equal "1..10", @tree.values.first
    end

    it 'converts exclusive ranges to inclusive ranges' do
      @tree.insert(1...11, "1...11")

      assert_equal (1..10), @tree.range
      assert_equal false, (1...11) == @tree.range
      assert_equal "1...11", @tree.values.first
    end
  end

  describe '#query' do
    it 'gets all values intersecting the given range' do
      @tree.insert(1..10, "1..10")
      @tree.insert(2..9, "2..9")
      @tree.insert(3..8, "3..8")
      @tree.insert(2..2, "2..2")
      @tree.insert(9..9, "9..9")

      @tree.query(2..9).tap do |set|
        assert_equal true, set.include?("1..10")
        assert_equal true, set.include?("2..9")
        assert_equal true, set.include?("3..8")
        assert_equal true, set.include?("2..2")
        assert_equal true, set.include?("9..9")
      end
    end

    it 'does not get values outside the range' do
      @tree.insert(1..1, "1..1")
      @tree.insert(10..10, "10..10")

      @tree.query(2..9).tap do |set|
        assert_equal true, set.empty?
      end
    end

    it 'can query using exclusive ranges' do
      @tree.insert(1..10, "1..10")
      @tree.insert(3..8, "3..8")

      @tree.query(1...3).tap do |set|
        assert_equal true, set.include?("1..10")
        assert_equal false, set.include?("3..8")
      end
    end
  end
end

# Some of the bench* methods are not available yet, so we're not using spec for
# benchmarking
class Benchmarks < Minitest::Benchmark
  def self.bench_range
    bench_exp 10_000, 1_000_000, 10
  end

  def bench_initialize
    assert_performance_constant do |n|
      100.times { IntervalTree.new 1..n }
    end
  end

  # Large ranges can be inserted without exploring as many nodes. If a range
  # covers the root, it is inserted at the root.
  def bench_insert_best_case
    assert_performance_constant do |n|
      @tree = IntervalTree.new 1..n
      100.times { @tree.insert 1..n, :value }
    end
  end

  # A range containing a single value has to be inserted in a leaf. This forces
  # the tree to explore from root to leaf, creating approximately log(n) nodes
  # on the way.
  #
  # 1_000 reps and relaxed threshold because the runtime growth is subtle.
  def bench_insert_worse_case
    assert_performance_logarithmic 0.9 do |n|
      1000.times do
        tree = IntervalTree.new 1..n
        tree.insert 1..1, :value
      end
    end
  end

  # Lerger ranges are inserted closer to the root, so queries similarly do not
  # need to descend as deep into the tree. We can find the root's range in
  # constant time.
  def bench_query_best_case
    assert_performance_constant do |n|
      tree = IntervalTree.new 1..n
      tree.insert 1..n, :value
      100.times do
        tree.query 1..n
      end
    end
  end

  # Single-value intervals are inserted in leafs, requiring queries to descend
  # deep into the tree to locate them. There are log(n) layers in a tree to
  # descend through, so queries should be at worst logarithmic.
  #
  # 1_000 reps and relaxed threshold because the runtime growth is subtle.
  def bench_query_worst_case
    assert_performance_logarithmic 0.9 do |n|
      tree = IntervalTree.new 1..n
      tree.insert 1..1, :value
      1000.times do
        tree.query 1..1
      end
    end
  end
end
