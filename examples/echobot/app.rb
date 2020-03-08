require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["e66cf1bed8481c9ad3e661851b5903ef"]
    config.channel_token = ENV["GutdYNnFfVz6WnwSvH5cuyfqNtnoNgroztJD02uYZnbCw/bsTzme81GHPttRIWInRHilagj7UP283LJcNyEB5/muR690VDZjPYrfLPp7+COOZT8yIjTybQ3ahK2TLLY8E38ewqxNNbXemErs+Lfw/wdB04t89/1O/w1cDnyilFU="]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
  end

  events = client.parse_events_from(body)

  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  end

  "OK"
end
