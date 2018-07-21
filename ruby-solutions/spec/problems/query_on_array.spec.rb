require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/benchmark'
require 'problems/query_on_array'

describe QueryOnArray do

  before do
    @query_on_array = QueryOnArray.new(
      IntervalTree.new(1..100),
      100
    )
  end

  describe '#increment_range' do
    it 'for each k_i in in x..y, adds (i)(i+1)(i+2) to k_i' do
      @query_on_array.increment_range(1..100)
      assert_equal 6, @query_on_array.eval_range(1..1)
      assert_equal 24, @query_on_array.eval_range(2..2)
      assert_equal 60, @query_on_array.eval_range(3..3)

      @query_on_array.increment_range(2..3)
      assert_equal 6, @query_on_array.eval_range(1..1)
      assert_equal 30, @query_on_array.eval_range(2..2)
      assert_equal 84, @query_on_array.eval_range(3..3)
    end
  end

  describe '#decrement_range' do
    it 'for each k_i in in x..y, subtracts (i)(i+1)(i+2) from k_i' do
      @query_on_array.decrement_range(1..100)
      assert_equal -6, @query_on_array.eval_range(1..1)
      assert_equal -24, @query_on_array.eval_range(2..2)
      assert_equal -60, @query_on_array.eval_range(3..3)

      @query_on_array.decrement_range(2..3)
      assert_equal -6, @query_on_array.eval_range(1..1)
      assert_equal -30, @query_on_array.eval_range(2..2)
      assert_equal -84, @query_on_array.eval_range(3..3)
    end

    it 'is the inverse of #incremenet_range' do
      @query_on_array.increment_range(1..100)
      @query_on_array.decrement_range(1..100)

      assert_equal 0, @query_on_array.eval_range(1..100)
    end
  end

  describe '#eval_range' do
    it 'sums the k_i in x..y' do
      @query_on_array.increment_range(1..100)

      assert_equal 90, @query_on_array.eval_range(1..3)
      assert_equal 84, @query_on_array.eval_range(2..3)
    end
  end
end

class Benchmarks < Minitest::Benchmark
  def self.bench_range
    bench_exp 100, 100000, 10
  end

  def bench_initialize
    assert_performance_linear do |n|
      QueryOnArray.new(IntervalTree.new(1..n), n)
    end
  end
end