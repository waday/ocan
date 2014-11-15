# encoding: utf-8
require './lib/gizmo'

def prompt(gizmo)
  return gizmo.name + ':' + gizmo.responder_name + '(' + gizmo.emotion.mood.to_s + ')> '
end

puts('Unmo System prototype : ocan')
ocan = Gizmo.new('ocan')
while true
  print('> ')
  input = gets
  input.chomp!
  if input == ''
    ocan.save
    break
  end

  response = ocan.dialogue(input)
  puts(prompt(ocan) + response)
end
