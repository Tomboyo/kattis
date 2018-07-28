class BinarySearchTree

  attr_accessor :key, :value, :left, :right

  def initialize key = nil, value = nil
    @key = key
    @value = value
    @left = @right = nil
  end

  # Create or update a key-value pair in the tree.
  def put key, value
    if value.nil?
      throw "nil not supported"
    end

    if @key.nil?
      @key = key
      @value = value
      return
    end

    current = self
    previous = current
    until current.nil? || current.key == key
      previous = current
      current = current.search key
    end

    if current&.key&. == key
      current.value = value
    else
      node = BinarySearchTree.new key, value
      if key < previous.key
        previous.left = node
      else
        previous.right = node
      end
    end
  end

  protected def search key
    if key < @key
      @left
    else
      @right
    end
  end

  # Get the value associated with the key or nil if there is
  # no such key.
  def get key
    current = self
    while current&.key&. != key
      current = current.search key
    end

    current&.value
  end

  def findLargestAtMost key
    current = self

    if current.key.nil? # empty tree
      return nil
    end

    next_node = current.search key
    while current.key != key && next_node != nil
      previous = current
      current = next_node
      next_node = current.search key
    end

    if current.key > key
      if previous.key < key
        previous.value
      else
        nil
      end
    elsif current.key <= key
      current.value
    end
  end

  def to_s
    "<key:#{@key} value:#{@value} left:#{@left} right: #{@right}>"
  end

  def pretty_to_s(level = 0)
    indent = " " * level * 2
    "key: #{@key}, value: #{@value}"\
      "\n#{indent}left: #{@left&.pretty_to_s(level + 1)}"\
      "\n#{indent}right: #{@right&.pretty_to_s(level + 1)}"
  end
end