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

class Benchmarks < Minitest::Benchmark
  def self.bench_range
    bench_exp 100, 100000, 10
  end

  def bench_initialize
    assert_performance_linear do |n|
      IntervalTree.new(1..n)
    end
  end
end
