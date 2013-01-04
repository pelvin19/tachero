require 'cinch'
require 'hpricot'
require 'httparty'
require_relative 'plugins/lunch'

bot = Cinch::Bot.new do

  configure do |c|
    c.nick = "el_tachero"
    c.server = "irc.freenode.org"
    c.channels = ["#despega"]
    c.plugins.plugins = [LunchVote]
  end

  helpers do
    # Extremely basic method, grabs the first result returned by Google
    # or "No results found" otherwise
    def gifs()
      url = "http://4gifs.tumblr.com/page/#{rand(900)+1}"
      res = Hpricot.parse(HTTParty.get(url))
      links = (res/"div#content div.post div.media a img")

      return links[rand(links.length)].attributes['src']
    end
    
    def feriado()
      url = "http://esferiadohoy.com/"
      res = Hpricot.parse(HTTParty.get(url))
      holiday = (res/"div#feriado").text + " Faltan " + (res/"span#numero").text + " dias. " + (res/"div#motivo").text + ". " + (res/"div#largo var").text
      
      return holiday
    end
    
    def comics()
      url = "http://www.explosm.net/comics/random/"
      res = Hpricot.parse(HTTParty.get(url))
      link = (res/"div#maincontent div img").select{|img| img.attributes['src'].match(/http:\/\/www.explosm.net\/db\/files\/Comics/)}.first
      if link
        return link.attributes['src']
      else
        puts (res/"div#maincontent div img").collect{|img| img.attributes['src']}
        return "http://www.explosm.net/db/files/Comics/Matt/Open-my-window-and-a-breeze-rolls-in.png"
      end  
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
  on :message, /cuando es el proximo feriado?/ do |m|
    m.reply feriado
  end
  on :message, /tirate un comic/ do |m|
    m.reply comics
  end
  on :message, /saber es poder/ do |m|
    m.reply "http://es.wikipedia.org/wiki/Especial:Aleatoria"
  end
  on :message, /productividad al mango/ do |m|
    m.reply comics + "\n" + gifs + "\n" + "http://procatinator.com/?cat=#{rand(1000)+1}" + "\n" + webcam
  end
  on :message, /tirate un gif/ do |m, query|
    m.reply gifs
  end
  on :message, /tirate un gato/ do |m|
    m.reply "http://procatinator.com/?cat=#{rand(1000)+1}"
  end
  on :message, /thetime/ do |m|
    m.reply Time.now.strftime("%H:%M")
  end
  on :message, /timeleft/ do |m|
    timeleft_hora = (Time.parse("18:00") - Time.now) / 60 / 60
    timeleft_minuto = (Time.parse("18:00") - Time.now) / 60
    m.reply "quedan #{timeleft_hora.to_i} horas con #{timeleft_minuto.to_i} minutos"
  end
  on :message, /tirate una webcam/ do |m|
    m.reply webcam
  end
  on :message, /faso|verde|porro|droga|humo|churro|fino|tuca|canio|fasito|tuquita/i do |m, query|
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
