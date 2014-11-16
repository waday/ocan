#encoding: utf-8
class Dictionary
  require './lib/markov'
  attr_reader :random, :pattern, :template, :markov

  def initialize
    load_random
    load_pattern
    load_template
    load_markov
  end

  def load_random
    @random = []
    begin
      open('dics/random.txt') do |f|
        f.each do |line|
          line.chomp!
          next if line.empty?
          @random.push(line)
        end
      end
    rescue => e
      puts(e.message)
      @random.push('こんにちは')
    end
  end

  def load_pattern
    @pattern = []
    open('dics/pattern.txt') do |f|
      f.each do |line|
        pattern, phrases = line.chomp.split("___")
        next if pattern.nil? or phrases.nil?
        @pattern.push(PatternItem.new(pattern, phrases))
      end
    end
  end

  def load_template
    @template = []
    open('dics/template.txt') do |f|
      f.each do |line|
        count, template = line.chomp.split(/___/)
        next if count.nil? or template.nil?
        count = count.to_i
        @template[count] = [] unless @template[count]
        @template[count].push(template)
      end
    end
  end

  def load_markov
    @markov = Markov.new
    begin
      open('dics/markov.dat', 'rb') do |f|
        @markov.load(f)
      end
    rescue => e
      puts(e.message)
    end
  end

  def study(input, parts)
    study_random(input)
    study_pattern(input, parts)
    study_template(parts)
    study_markov(parts)
  end

  def study_random(input)
    return if @random.include?(input)
    @random.push(input)
  end

  def study_pattern(input, parts)
    parts.each do |word, part|
      next unless Morph::keyword?(part)
      duped = @pattern.find{|ptn_item| ptn_item.pattern == word}
      if duped
        duped.add_phrase(input)
      else
        @pattern.push(PatternItem.new(word, input))
      end
    end
  end

  def study_template(parts)
    template = ''
    count = 0
    parts.each do |word, part|
      if Morph::keyword?(part)
        word = '%noun%'
        count += 1
      end
      template += word
    end
    return unless count > 0

    @template[count] = [] unless @template[count]
    unless @template[count].include?(template)
      @template[count].push(template)
    end
  end

  def study_markov(parts)
    @markov.add_sentence(parts)
  end

  def save
    open('dics/random.txt', 'w') do |f|
      f.puts(@random)
    end

    open('dics/pattern.txt', 'w') do |f|
      @pattern.each{|ptn_item| f.puts(ptn_item.make_line)}
    end

    open('dics/template.txt', 'w') do |f|
      @template.each_with_index do |template, i|
        next if template.nil?
        template.each do |template|
          f.puts(i.to_s + "___" + template)
        end
      end
    end

    open('dics/markov.dat', 'wb') do |f|
      @markov.save(f)
    end
  end

end

class PatternItem
  attr_reader :modify, :pattern, :phrases

  SEPARATOR = /^((-?\d+)##)?(.*)$/

  def initialize(pattern, phrases)
    # $2:機嫌変動値, $3:マッチパターン
    SEPARATOR =~ pattern
    @modify, @pattern = $2.to_i, $3

    @phrases = []
    phrases.split('|').each do |phrase|
      # $3:機嫌必要値, $3:フレーズ(反応)一覧
      SEPARATOR =~ phrase
      @phrases.push({need: $2.to_i, phrase: $3})
    end
  end

  def match(str)
    return str.match(@pattern)
  end

  def choice(mood)
    choices = []
    @phrases.each do |p|
      choices.push(p[:phrase]) if suitable?(p[:need], mood)
    end
    return (choices.empty?)? nil : choices[rand(choices.size)]
  end

  def suitable?(need, mood)
    return true if need == 0
    if need > 0
      return mood > need
    else
      return mood < need
    end
  end

  def add_phrase(phrase)
    return if @phrases.find{|p| p[:phrase] == phrase}
    @phrases.push({need: 0, phrase: phrase})
  end

  def make_line
    pattern = @modify.to_s + "##" + @pattern
    phrases = @phrases.map{|p| p[:need].to_s + "##" + p[:phrase]}
    return pattern + "___" + phrases.join('|')
  end

end
