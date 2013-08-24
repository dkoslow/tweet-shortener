module TweetShortener

  def self.abbreviate_tweet(tweet_string, tree)
    original_tokens = tweet_string.downcase.split(" ")
    abbreviated_tokens = []
    build_abbreviated_tokens_array(original_tokens, abbreviated_tokens, tree).join(" ")
  end

  def self.build_abbreviated_tokens_array(original_tokens, abbreviated_tokens, tree)
    if original_tokens.length == 0
      return abbreviated_tokens
    end
    longest_matched_abbreviation = nil
    longest_matched_abbreviation, rest_of_original_tokens = find_longest_matching_abbreviation(original_tokens, tree, longest_matched_abbreviation)
    if longest_matched_abbreviation
      abbreviated_tokens << longest_matched_abbreviation
      build_abbreviated_tokens_array(rest_of_original_tokens, abbreviated_tokens, tree)
    else
      abbreviated_tokens << original_tokens.slice!(0)
      build_abbreviated_tokens_array(original_tokens, abbreviated_tokens, tree)
    end
  end

  def self.find_longest_matching_abbreviation(unabbreviated_tokens, tree, longest_matched_abbreviation)
    current_token = unabbreviated_tokens.first
    tree_with_token_as_key = (tree.children.select {|child_tree| child_tree.key == current_token })[0]
    if tree_with_token_as_key
      if value = tree_with_token_as_key.value
        longest_matched_abbreviation = value
      end
      remaining_unabbreviated_tokens = unabbreviated_tokens[1..-1].to_a
      find_longest_matching_abbreviation(remaining_unabbreviated_tokens, tree_with_token_as_key, longest_matched_abbreviation)
    else
      [longest_matched_abbreviation, unabbreviated_tokens]
    end
  end
end