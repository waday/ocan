#encoding: utf-8
# 形態素解析モジュール
require 'mecab'

module Morph

  def analyze(text)
    words = []
    node = MeCab::Tagger.new.parseToNode(text)
    while node
      words.push("#{node.surface}\t#{node.feature}") unless node.feature.match("BOS")
      node = node.next
    end

    return words.map do |part|
      part.split(/\t/)
    end
  end

  def keyword?(part)
    return /名詞,(一般|固有名詞|サ変名詞|形容動詞語幹)/ =~ part
  end

  module_function :analyze, :keyword?
end
