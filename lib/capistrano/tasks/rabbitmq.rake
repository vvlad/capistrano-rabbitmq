

set(:rabbitmq_role, :rabbitmq)


namespace :rabbitmq do

    task :defaults do
        set(:rabbitmq_packages, %w[rabbitmq-server])
    end

    task :sources do

      role = fetch(:rabbitmq_role)

      key = :"ubuntu_packages_for_#{role}"
      packages = fetch(key,[])
      packages += fetch(:rabbitmq_packages)
      set(key, packages)

      key = :"ubuntu_software_sources_for_#{role}"
      sources = fetch(key,[])
      sources += [
        [
          "'deb http://www.rabbitmq.com/debian/ testing main'",
          "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
        ]
      ]
      set(key, sources)

    end

    task :enable_plugins do


      on roles(fetch(:rabbitmq_role)) do

        unless test "[[ -f /etc/rabbitmq/enabled_plugins ]] "
          upload_as :rabbitmq, StringIO.new("[rabbitmq_management,rabbitmq_management_visualiser,rabbitmq_stomp,rabbitmq_amqp1_0,rabbitmq_mqtt]."), "/etc/rabbitmq/enabled_plugins"
          sudo "service rabbitmq-server restart"
        end

      end

    end




end


after "load:defaults", "rabbitmq:defaults"
before "ubuntu:update_sources", "rabbitmq:sources"
after "ubuntu:install_packages", "rabbitmq:enable_plugins"
