#encoding: utf-8
class Emotion
  attr_reader :mood

  MOOD_MIN = -15
  MOOD_MAX = 15
  MOOD_RECOVERY = 0.5

  def initialize(dictionary)
    @dictionary = dictionary
    @mood = 0
  end

  def update(input)
    @dictionary.pattern.each do |ptn_item|
      if ptn_item.match(input)
        adjust_mood(ptn_item.modify)
        break
      end
    end
  
    if @mood < 0
      @mood += MOOD_RECOVERY
    elsif @mood > 0
      @mood -= MOOD_RECOVERY
    end
  end

  def adjust_mood(val)
    @mood += val
    if @mood > MOOD_MAX
      @mood = MOOD_MAX
    elsif @mood < MOOD_MIN
      @mood = MOOD_MIN
    end
  end
end
