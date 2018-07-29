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

    before do
      @tree.insert(Interval.new(1, 10), "1..10")
      @tree.insert(Interval.new(2, 9), "2..9")
      @tree.insert(Interval.new(3, 8), "3..8")
      @tree.insert(Interval.new(2, 2), "2..2")
      @tree.insert(Interval.new(9, 9), "9..9")
    end

    it 'gets all values intersecting the given range' do
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
      values = Set.new
      @tree.get(Interval.new(1, 1)) do |i, v|
        values.merge(v)
      end

      assert_equal 1, values.size
      assert_equal true, values.include?("1..10")
    end
  end
end

# Some of the bench* methods are not available yet, so we're
# not using spec for benchmarking
class Benchmarks < Minitest::Benchmark
  
  def self.bench_range
    bench_exp 2**8, 2**11, 2
  end

  # Performance degrades logarithmically with the number of
  # elements stored within the interval tree.
  def bench_insert
    assert_performance_logarithmic do |n|
      tree = IntervalTree.new Interval.new(1, n)
      n.times do
        i = rand 1..n
        tree.insert Interval.new(i, i), i
      end
    end
  end

end
