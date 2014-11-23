# coding:utf-8
 
require './lib/twitter/bot.rb'
 
bot = Bot.new
 
begin
  bot.timeline.userstream do |status|
 
    p status
    twitter_id = status.user.screen_name
    name = status.user.name
    contents = status.text
    status_id = status.id
 
    # リツイート以外を取得
    if !contents.index("RT")
      str_time = Time.now.strftime("[%Y-%m-%d %H:%M]")
 
      # botを呼び出す(他人へのリプを無視)
      if !(/^@\w*/.match(contents))
        if contents =~ /おーい/
          text = "はい\n#{str_time}"
          bot.retweet(status_id:status_id)
          bot.post(text,twitter_id:twitter_id,status_id:status_id)
        end
      end
 
      # 自分へのリプであれば
      if contents =~ /^@ocanbot\s*/
        if contents =~ /カーチャン/
          text = "何だい？\n#{str_time}"
          #bot.fav(status_id:status_id)
          bot.post(text,twitter_id:twitter_id,status_id:status_id)
        end
      end
 
    end
 
  sleep 2
  end
 
rescue => em
  puts Time.now
  p em
  sleep 2
  retry
 
rescue Interrupt
  exit 1
end
