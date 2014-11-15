# encoding: utf-8
require './lib/gizmo'

def prompt(gizmo)
  return gizmo.name + ':' + gizmo.responder_name + '(' + gizmo.emotion.mood.to_s + ')> '
end

puts('Unmo System prototype : proto')
proto = Gizmo.new('proto')
while true
  print('> ')
  input = gets
  input.chomp!
  if input == ''
    proto.save
    break
  end

  response = proto.dialogue(input)
  puts(prompt(proto) + response)
end
