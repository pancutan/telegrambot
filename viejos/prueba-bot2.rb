# Supercanal Telegram Bot
# 2017 Copyleft Sergio A. Alonso - about.me/elbunker

# https://www.sitepoint.com/quickly-create-a-telegram-bot-in-ruby/
# https://github.com/atipugin/telegram-bot-ruby

# Usar /mybots en el canal de botfather
# @supercanalbot
# t.me/supercanalbot

require 'telegram/bot'

puts 'Bot escuchando'

token='**********************************'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    puts message.new_chat_members
    puts message.left_chat_member

    puts ''
    puts Time.at(message.date)
    puts message.from.first_name + ' ' + message.from.last_name + ' - ' + message.from.username.to_s
    puts 'Envía: ' + message.text

    case
    when message.text == 'SIGA'
      puts 'en Submenu SIGA'; question = 'Submenu SIGA'
      # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
      cualsiga = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(Front Middles), %w(ControlSiga Base), %w(Principal)], one_time_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: cualsiga)
    when message.text == 'Front'
       puts 'en Submenu Fronts'
        # ; question = 'Submenu SIGA'
       cualfront = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(Principal)], one_time_keyboard: true)
       bot.api.send_message(chat_id: message.chat.id, text: 'El estado de los balanceadores es blah', reply_markup: cualfront)
    else
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(SIGA Correo), %w(DNS Sap), %w(Principal)], one_time_keyboard: true)
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
