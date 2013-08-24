require_relative "parser"

class Tree

  class << self
    def create_tree
      array_of_hashes = Parser.turn_into_array_of_hashes("abbreviations.txt")
      abbreviation_tree = Tree.new(nil, nil, [])
      abbreviation_tree.build_branches!(array_of_hashes)
    end
  end

  attr_accessor :key, :value, :children

  def initialize(key, value, children_array)
    @key = key
    @value = value
    @children = children_array
  end

  def build_branches!(array_of_hashes)
    if array_of_hashes.flatten.empty?
      return nil
    end
    branches_grouped_by_first_token = split_array_into_branch_groups!(array_of_hashes)
    branches_grouped_by_first_token.each do |array|
      key, value = set_root(array)
      child_tree = Tree.new(key, value, [])
      @children << child_tree
      array.each do |hash|
        hash.keys[0].shift
        if hash.keys.flatten.empty?
          array.delete(hash)
        end
      end
      child_tree.build_branches!(array)
    end
    self
  end

  def split_array_into_branch_groups!(array_of_hashes)
    branches_grouped_by_first_token = []
    while array_of_hashes.length > 0
      first_hash = array_of_hashes.shift
      hashes_with_same_first_token = [first_hash]
      i = 0
      while i < array_of_hashes.length
        if array_of_hashes[i].keys.flatten[0] == first_hash.keys.flatten[0]
          hashes_with_same_first_token << array_of_hashes.slice!(i)
        else
          i += 1
        end
      end
      branches_grouped_by_first_token << hashes_with_same_first_token
    end
    branches_grouped_by_first_token
  end

  def set_root(array)
    hash_with_single_word_key = array.find {|hash| hash.keys.flatten.length == 1 }
    if hash_with_single_word_key
      key = hash_with_single_word_key.keys.flatten[0]
      value = hash_with_single_word_key.values.flatten[0]
    else
      key = array.first.keys.flatten[0]
      value = nil
    end
    [key, value]
  end
end
