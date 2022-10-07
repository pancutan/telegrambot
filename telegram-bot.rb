# Telegram Bot
# 2017 Copyleft Sergio A. Alonso - about.me/elbunker

# https://www.sitepoint.com/quickly-create-a-telegram-bot-in-ruby/
# https://github.com/atipugin/telegram-bot-ruby

# Usar /mybots en el canal de botfather
# @supercanalbot
# t.me/supercanalbot

# Workaround:
#`ruby libreria.rb (parametros)`
require 'telegram/bot' # Falla en la ultima versión de Arch, si se usa junto a librerias que usen ssl
require 'mysql2' # En ubuntu 14.04 y 16.04 anda bien junto a telegram/bot

require 'pry'
require 'pry-byebug'
require 'pry-rescue'
require 'awesome_print'

require 'pry-auditlog'

load 'correo.rb'
load 'libreria.rb'

puts 'Bot escuchando e informando'

token='**********************************'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    puts message.new_chat_members
    puts message.left_chat_member

    puts ''
    puts Time.at(message.date)
    puts message.from.first_name + ' ' + message.from.last_name + ' - ' + message.from.username.to_s
    # Guardamos su chat.id para poder mandarle updates en tiempo real desde los agentes
    puts 'Conectado desde ' + message.chat.id.to_s
    puts 'Envía: ' + message.text

    case
      when message.text == 'SIGA'
        puts ' en Submenu SIGA'; question = 'Submenu SIGA'
        # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
        cualsiga = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(ControlSiga Base), %w(Principal)], one_time_keyboard: false)
        bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: cualsiga)

        begin
          mysql = Mysql2::Client.new(:host => "scripts.*******.com.ar", :username => "telegramcito",
                                     :password => '**************', :database => 'telegrambot')
          sql = "SELECT * from nodos"
          mymatrix_select = mysql.query(sql)

          # binding.pry

          texto = ""
          if mymatrix_select.count != 0
            mymatrix_select.each do |m|
              # binding.pry
              # entidad = Telegram::Bot::Types::MessageEntity.new
              # entidad.type = 'bold'
              # bot.api.send_message(chat_id: message.chat.id, text: '*bold* _italic_ `fixed width font` [link](http://google.com).', reply_markup: cualsiga, parse_mode: "Markdown")

              texto +=  "\n\n--------------------------------------\n" # los .to_s son para prevenir excepciones por nil
              texto +=  "*Nodo*: `"                   + m['nombre'].to_s + "`\n"
              texto += "*Carga*: "                    + m["carga_segun_balanceador"].to_f.to_s + "\n"

              texto += "*Peso*: "                     + m["peso_asignado_desde_balanceador"].to_i.to_s
              if m["peso_asignado_desde_balanceador"].to_i == 0
                texto += " (no asignado) \n"
              else
                texto += "\n"
              end

              texto += "*Estado según balanceador*: " + m["estado_segun_balanceador"].to_s + "\n"

              texto += "*Estado según Bloisebot*: "   + m["estado_sigasc_segun_bloisebot"].to_s
              if m["estado_sigasc_segun_bloisebot"] == nil
                texto += " (sin datos)\n"
              else
                texto += "\n"
              end

              texto += "*Ultimo contacto:* "          + m["ultimo_contacto_desde_balanceador"].to_s[0..15]

              # bot.api.send_message(chat_id: message.chat.id, text: 'Nodo: '  +  m["nombre"], reply_markup: cualsiga)
              # bot.api.send_message(chat_id: message.chat.id, text: 'Carga: ' + m["carga_segun_balanceador"].to_f.to_s, reply_markup: cualsiga)
              #binding.pry
              # bot.api.send_message(chat_id: message.chat.id, text: 'Peso: '   + m["peso_asignado_desde_balanceador"].to_i.to_s, reply_markup: cualsiga)
              # bot.api.send_message(chat_id: message.chat.id, text: 'Estado según balanceador: ' + m["estado_segun_balanceador"], reply_markup: cualsiga)
              # bot.api.send_message(chat_id: message.chat.id, text: 'Estado según Bloisebot: '   + m["estado_sigasc_segun_bloisebot"].to_s, reply_markup: cualsiga)

            end
          else
            puts 'Tabla sin datos... ¬¬'
            texto += 'Tabla sin datos ¬¬'
          end # if mymatrix_select.count != 0
          bot.api.send_message(chat_id: message.chat.id, text: texto, reply_markup: cualsiga, parse_mode: "Markdown")
        rescue
          correo "alonso.sergio@*******.com.ar", "No me puedo comunicar con la base de telegrambot. Excepción: #{$!}" #{$@}
          mysql.close
        end
        mysql.close

        # Lo "inscribo"
        # `ruby /home/s/Dropbox/Proyectos/UNO/TelegramBot/libreria.rb persistir #{message.chat.id.to_s} #{message.from.first_name} #{message.from.last_name} front`
        persistir(message.chat.id.to_s, message.from.first_name,message.from.last_name)

      when message.text == 'Principal' # igual al else
        answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(SIGA Correo), %w(DNS Sap), %w(Principal)], one_time_keyboard: false)
        puts 'En Menu principal'
        bot.api.send_message(chat_id: message.chat.id, text: '<b>Menu principal</b>', reply_markup: answers, parse_mode: :html)
        bot.api.send_message(chat_id: message.chat.id, text: 'Navegue por los siguientes menus, o utilice las palabras Front, Base, Middles, Menu')
      else
        answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(SIGA Correo), %w(DNS Sap), %w(Principal)], one_time_keyboard: false)
        puts 'En Menu principal'
        bot.api.send_message(chat_id: message.chat.id, text: '<b>Menu principal</b>', reply_markup: answers, parse_mode: :html)
        bot.api.send_message(chat_id: message.chat.id, text: 'Navegue por los siguientes menus, o utilice las palabras Front, Base, Middles, Menu')
    end
  end

  # when '/stop'
  # See more: https://core.telegram.org/bots/api#replykeyboardremove
  #  kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
  #  bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)

end


