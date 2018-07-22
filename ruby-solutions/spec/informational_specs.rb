require 'minitest/autorun'
require 'minitest/benchmark'

# Some performance observations to help investigate bottlenecks. Inspect the
# runtimes to get a feel for the cost of certain operations.
class OnMyMachine < Minitest::Benchmark

  def self.bench_range
    bench_exp 100, 1000000, 10
  end

  def bench_object_new
    assert_performance_linear do |n|
      n.times { Object.new }
    end
  end

  # Roughly 10 times the cost of .new
  def bench_dynamic_inclusion
    assert_performance_linear do |n|
      n.times { Object.new.singleton_class.include(A) }
    end
  end

  # Roughly twice the cost of .new
  def bench_object_cloning
    assert_performance_linear do |n|
      n.times { Object.new.clone }
    end
  end
end

module A ; end