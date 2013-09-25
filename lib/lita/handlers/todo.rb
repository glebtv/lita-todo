require "lita"

module Lita
  module Handlers
    class Todo < Handler
      route(/^todo$/, :list, help: {"todo list" => "list my TOOD items"})
      route(/^todo\s+add\s+(?<task>.*)$/, :add, help: {"todo add task" => "add a todo item"})
      route(/^todo\s+delete\s+(?<task>\d+)$/, :delete, help: {"todo delete ID" => "delete a todo item"})

      def list(response)
        user_id = response.message.source.user.id.to_s
        reply = []
        redis.lrange(user_id, 0, -1).each_with_index do |task, index|
          unless task.nil? || task == ''
            reply << "[#{index}] #{task}"
          end
        end
        if reply.empty?
          response.reply "todo list is empty"
        else
          response.reply(reply.join("\n"))
        end
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
        response.reply("task #{task} (#{text}) deleted")
      end
    end

    Lita.register_handler(Todo)
  end
end
