
require 'mysql2'

# Ejemplo
# `ruby /home/s/Dropbox/Proyectos/UNO/TelegramBot/libreria.rb persistir #{message.chat.id.to_s} siga`
def persistir(id,nombre,apellido)
  begin
    sql = "SELECT * from usuarios WHERE id = #{id.to_i} AND interesado_en LIKE 'siga'"

    mysql = Mysql2::Client.new(:host => "the-old-server.*****.com.ar", :username => "telegramcito",
                               :password => '***********', :database => 'telegrambot')
    mymatrix_select = mysql.query(sql)

    if mymatrix_select.count == 0
      sql = "INSERT INTO usuarios (id,nombre,apellido,interesado_en) " \
              "VALUES (#{id.to_i}, '#{nombre}', '#{apellido}', 'siga')"
      mymatrix_insert = mysql.query(sql)
      puts "Insertando #{id.to_i}, '#{nombre}', '#{apellido}', 'siga'"
    else
      puts 'Usuario ya existe, y se encuentra anotado en esta categoría'
    end
  rescue
    correo "alonso.sergio@***********.com.ar", "No me puedo comunicar con la base de telegrambot. Excepción: #{$!} - #{$@}"
    mysql.close
  end
  mysql.close
end
