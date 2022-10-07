require  'pony'

def correo(subject,body)
  begin
    Pony.mail({ :to => 'alonso.sergio@********.com.ar', :from => 'Tecnologia My old department <tecnologia@********.com.ar>',
                # :cc => 'my.old.boss@***********.com.ar',
                :subject => subject,
                :body => body, :html_body => body, :charset => "UTF-8", :via => :smtp,
                :via_options => {
                    :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
                    :address              => 'zimbra.*******.com.ar',
                    :port                 => '25',
                    :enable_starttls_auto => true,
                    :user_name            => 'tecnologia@********.com.ar',
                    :password             => '********',
                    :domain               => "********.com.ar" # the HELO domain provided by the client to the server
                }
              })
      #ver mas sobre excepciones en excepciones.txt
  rescue Net::ReadTimeout
    puts "No se pudo enviar correo: no se puede llegar al servidor"
  rescue Net::OpenTimeout
    puts "No se pudo enviar correo: servidor de correo no responde"
  rescue Net::SMTPServerBusy
    puts "Insufficient system storage (Net::SMTPServerBusy)"
  rescue SocketError
    puts "getaddrinfo: Name or service not known"
  rescue Net::SMTPAuthenticationError
    puts "Error autenticando al correo"
  rescue Errno::ECONNREFUSSED
    puts "Conexión rechazada del servidor de correo"
  end
end #fin def correo
