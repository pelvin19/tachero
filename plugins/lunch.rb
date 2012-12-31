#encoding: utf-8

require 'cinch'

class LunchVote
  include Cinch::Plugin

  @grid = {} 

  listen_to :message
  def listen(m)

    if md = m.message.match(/adonde comemos/i)
      m.reply "Iniciemos una nueva votacion para ver adonde comemos. Escucho sus votos (:"
      @grid = {}
    elsif md = m.message.match(/voto por (.+)/i)
      m.reply "Votaste por #{md[1]} #{m.user.nick}. Podés cambiar tu voto votando de nuevo."
      @grid[m.user.nick] = md[1]
    elsif md = m.message.match(/quien gana\?/i)
      m.reply "La votación para el almuerzo va así:"

      cuenta = @grid.values.inject(Hash.new(0)) { |m, n| m[n] += 1; m }
      cuenta.each_pair do |k,v|
        m.reply "#{k}: #{v} votos"  #TODO listar usuarios que votaron
      end
    end

  end

end
