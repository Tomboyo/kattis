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
    [100, 500, 1_000, 5_000]
  end

  MaxRuntime = Proc.new do |samples, runtime|
    #runtime[0] <= 0.333
  end

  def bench_mostly_updates
    assert_performance MaxRuntime do |n|
      q = QueryOnArray.new(IntervalTree.new(1..n), n)

      n.times do
        case rand
        when 0.0...0.3
          low = rand 0...n
          high = rand low..n
          #puts "Insert [#{low}..#{high}] => 1"
          q.increment_range low..high
        when 0.3...0.6
          low = rand 0...n
          high = rand low..n
          #puts "Insert [#{low}..#{high}] => -1"
          q.decrement_range low..high
        else
          low = rand 0...n
          high = rand low..n
          #puts "Query [#{low}..#{high}]"
          q.eval_range low..high
        end
      end
    end
  end

end