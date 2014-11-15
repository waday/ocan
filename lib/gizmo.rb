#encoding; utf-8
require './lib/responder'
require './lib/dictionary'
require './lib/emotion'

class Gizmo
  attr_reader :name, :emotion

  def initialize(name)
    @name = name
    @dictionary = Dictionary.new
    @emotion = Emotion.new(@dictionary)
    @resp_what = WhatResponder.new('What', @dictionary)
    @resp_random = RandomResponder.new('Random', @dictionary)
    @resp_pattern = PatternResponder.new('Pattern', @dictionary)
    @responder = @resp_pattern
  end

  def dialogue(input)
  
    @emotion.update(input)

    case rand(100)
    when 0..59
      @responder = @resp_pattern
    when 60..89
      @responder = @resp_random
    else
      @responder = @resp_what
    end
    resp = @responder.response(input, @emotion.mood)

    @dictionary.study(input)
    return resp
  end

  def save
    @dictionary.save
  end

  def responder_name
    return @responder.name
  end

  def mood
    return @emotion.mood
  end

end
