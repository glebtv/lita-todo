require "lita"

module Lita
  module Handlers
    class Todo < Handler
      route(/^todo\wlist$/, :list)
      route(/^todo\s+add\s+(?<task>)$/, :add)
      route(/^todo\s+delete\s+(?<task>)$/, :delete)

      def list(response)
        user_id = response.message.source.user.id.to_s
        reply = []
        redis.lrange(user_id, 0, -1).each_with_index do |task, index|
          reply << "[#{index}] #{task}"
        end
        response.reply(reply.join("\n"))
      end

      def add(response)
        user_id = response.message.source.user.id.to_s
        task = response.match_data['task']
        redis.rpush(user_id, task)
        response.reply("task #{redis.llen(user_id) - 1} added")
      end
      
      def delete(response)
        user_id = response.message.source.user.id.to_s
        task = response.match_data['task']
        text = redis.lindex user_id, task
        redis.lset(user_id, task, nil)
        response.reply("TODO #{task} (#{text}) deleted")
      end
    end

    Lita.register_handler(Todo)
  end
end
