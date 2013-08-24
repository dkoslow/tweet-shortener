class Parser

  # abbreviations is a newline separated string of ABBREV - expansion
  def self.turn_into_array_of_hashes(abbreviations)
    lines = IO.readlines(abbreviations)
    lines.map do |line|
      line_array = line.downcase.split(" - ")
      key_array = line_array[1].split(" ")
      value = line_array[0]
      line_hash = {key_array => value}
      line_hash
    end
  end

end