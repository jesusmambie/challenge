class Template < ApplicationRecord
  has_and_belongs_to_many :questions

  def tags(content)
    tags = []
    words = content.split(" ")
    words.each do |word|
      if word[0] == '['
        tags.push(word)
      end
    end
    return tags
  end

end
