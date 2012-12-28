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

   #Returns a public TrendNET CAM for fun (bug exploit).
   def webcam()
     res  = HTTParty.get('http://pastebin.com/raw.php?i=DtCL8Nvm')
     webcams = []
     res.body.each_line do |line|
       if line.match(/http/) then webcams << line end
     end
     webcams[rand(webcams.length)]
   end

    #Retuns a greeting message according to the current time
    def greeting_message()
      greeting_message = case Time.now.hour
        when 6..11 then "Buen dia"
        when 12..20 then "Buenas tardes"
        else "Buenas noches"
      end
    end

  end

  on :message, "donde comemos?" do |m|
    places = ["pompeyo","cuartetas","sotano","333","mc","guerrin!!","pizza barata","bk"]
    m.reply places[rand(places.length)]
  end
  on :message, /tirate un gif/ do |m, query|
    m.reply gifs
  end

  on :message, /tirate un gato/ do |m|
    m.reply "http://procatinator.com/?cat=#{rand(1000)+1}"
  end

  on :message, /tirate una webcam/ do |m|
    m.reply webcam
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
     greet = greeting_message
     m.reply "#{greeting_message} #{m.user.nick}, todo piola?" unless m.user.nick=="el_tachero"
  end

end

bot.start
