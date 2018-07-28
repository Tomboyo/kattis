require 'minitest/autorun'
require 'minitest/spec'
require 'binary_search_tree'

describe BinarySearchTree do

  before do
    @bst = BinarySearchTree.new
  end

  describe '#put' do
    it 'creates a key-value mapping' do
      @bst.put 0, :value

      assert_equal :value, @bst.get(0)
    end

    it 'overwrites a key-value mapping' do
      @bst.put 0, :before
      @bst.put 0, :after

      assert_equal :after, @bst.get(0)
    end

    it 'saves arbitrarily many mappings' do
      # Oder of keys chosen to exercise branching
      [7, 5, 6, 1, 2, 3, 4].each do |i|
        @bst.put i, i
      end

      [7, 5, 6, 1, 2, 3, 4].each do |i|
        assert_equal i, @bst.get(i)
      end
    end
  end

  describe '#get' do
    it 'gets the value associated with a mapping if present' do
      @bst.put 5, :present

      assert_equal :present, @bst.get(5)
    end

    it 'gets nil if no mapping exists for the given key' do
      assert_equal true, @bst.get(5).nil?
    end
  end

  describe '#findLargestAtMost' do

    describe 'when the tree is empty' do
      it 'returns nil' do
        assert_equal true, @bst.findLargestAtMost(5).nil?
      end
    end

    describe 'when the tree is not empty' do

      before do
        @bst.put 5, 5
        @bst.put 7, 7
        @bst.put 3, 3
      end

      it 'returns the largest number <= the key' do
        assert_equal 7, @bst.findLargestAtMost(8)
        assert_equal 7, @bst.findLargestAtMost(7)

        assert_equal 5, @bst.findLargestAtMost(6)
        assert_equal 5, @bst.findLargestAtMost(5)

        assert_equal 3, @bst.findLargestAtMost(4)
        assert_equal 3, @bst.findLargestAtMost(3)
      end

      describe 'when the key is smaller than all tree elements' do
        it 'returns nil' do
          assert_equal true, @bst.findLargestAtMost(2).nil?
        end
      end
    end
  end
end