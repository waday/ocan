# encoding: utf-8
require './lib/gizmo'

def prompt(gizmo)
  return gizmo.name + ':' + gizmo.responder_name + '> '
end

puts('Unmo System prototype : proto')
proto = Gizmo.new('proto')
while true
  print('> ')
  input = gets
  input.chomp!
  break if input == ''

  response = proto.dialogue(input)
  puts(prompt(proto) + response)
end
