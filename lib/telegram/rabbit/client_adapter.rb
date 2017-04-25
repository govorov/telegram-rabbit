require 'logger'
require 'bunny'
require 'telegram/bot'


module Telegram
  module Rabbit
    class ClientAdapter

      attr_accessor :client


      def initialize opts={}
        @options      = default_options.merge(opts)
        @logger       = get_option :logger_instance
        @logger.level = get_option :log_level
      end


      def start
        logger.debug "Starting ClientAdapter"
        @connection = Bunny.new(get_option :bunny).start
        at_exit { @connection.close }

        #queues
        send_queue_name    = "#{queue_prefix}.messages"
        receive_queue_name = "#{queue_prefix}.commands"

        @channel       = @connection.create_channel
        @send_queue    = @channel.queue send_queue_name
        @receive_queue = @channel.queue receive_queue_name

        logger.debug "Created queues:"
        logger.debug "  send:    #{send_queue_name}"
        logger.debug "  receive: #{receive_queue_name}"

        @receive_queue.subscribe do |info,metadata,raw_data|
          data = Marshal.load(raw_data)
          command, payload = extract_command(data)
          logger.debug "Received command: #{command}"
          logger.debug payload.inspect
          exec_api_command command, payload
        end

        logger.debug "Starting bot client"

        @client = client || Telegram::Bot::Client.new(get_option :bot, :token)
        @client.run do |bot|
          logger.debug "Bot client started"
          bot.listen do |message|
            logger.debug "Received message:"
            logger.debug message.inspect
            send_to_app message
          end
        end

      end


      private

      def send_to_app message
        payload = Marshal.dump(message)
        @channel.default_exchange.publish payload, routing_key: @send_queue.name
      end


      def logger
        @logger
      end


      def extract_command payload
        [ payload[:command], payload[:payload] ]
      end


      def exec_api_command command, payload
        # WIP error handling - send errors back
        @client.api.send command, payload
      end


      def queue_prefix
        "#{get_option :queue_namespace}.#{get_option :bot, :name}"
      end


      def get_option *args
        (@options || {}).dig *args
      end


      def default_options
        {
          log_level:       Logger::DEBUG,
          logger_instance: Logger.new(STDOUT)
        }
      end

    end
  end # Rabbit
end # Telegram
