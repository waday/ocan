#encoding; utf-8
require './lib/responder'
require './lib/dictionary'
require './lib/emotion'
require './lib/morph'

class Gizmo
  attr_reader :name, :emotion

  def initialize(name)
    @name = name
    @dictionary = Dictionary.new
    @emotion = Emotion.new(@dictionary)
    @resp_what = WhatResponder.new('What', @dictionary)
    @resp_random = RandomResponder.new('Random', @dictionary)
    @resp_pattern = PatternResponder.new('Pattern', @dictionary)
    @resp_template = TemplateResponder.new('Template', @dictionary)
    @resp_markov = MarkovResponder.new('Markov', @dictionary)
    @responder = @resp_pattern
  end

  def dialogue(input)
  
    @emotion.update(input)
    parts = Morph::analyze(input)

    case rand(100)
    when 0..29
      @responder = @resp_pattern
    when 30..49
      @responder = @resp_template
    when 40..69
      @responder = @resp_random
    when 70..89
      @responder = @resp_markov
    else
      @responder = @resp_what
    end
    resp = @responder.response(input, parts, @emotion.mood)

    @dictionary.study(input, parts)
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
