require 'cinch'
require 'hpricot'
require 'httparty'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "el_tachero"	
    c.server = "irc.freenode.org"
    c.channels = ["#despega"]
  end

  helpers do
    # Extremely basic method, grabs the first result returned by Google
    # or "No results found" otherwise
    def gifs()
      url = "http://4gifs.tumblr.com/page/#{rand(900)+1}"
      res = Hpricot.parse(HTTParty.get(url))
      link = (res/"div#content div.post a img")[0].attributes['src']

      return link
    end
  end
  on :message, "donde comemos?" do |m|
    places = ["pompeyo","cuartetas","sotano","333","mc","guerrin!!","pizza barata","bk"]
    m.reply places[rand(places.length)]
  end  
  on :message, /tirate un gif/ do |m, query|
    m.reply gifs
  end
  on :message, /faso|verde|porro|droga|humo|churro|fino|tuca|canio/i do |m, query|
    m.reply "#{m.user.nick} esta hablando del faso!!!!"
  end
  on :message, "hola (.+)" do |m|
    m.reply "hola #{m.user.nick}, aunque seas gorila"
  end
  on :message, "chau" do |m|
    m.reply "chau #{m.user.nick}, aunque seas gorila"
  end
  on :join do |m|
    m.reply "Buen dia #{m.user.nick}, todo piola?" unless m.user.nick=="el_tachero"
  end  
end

bot.start
