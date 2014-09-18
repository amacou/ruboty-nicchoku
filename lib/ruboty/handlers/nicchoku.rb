module Ruboty
  module Handlers
    class Nicchoku < Base
      NAMESPACE = "nicchoku"
      MINE_REGEXP = "わたく?し|ワタク?シ|あたし|アタシ|私|ボク|ぼく|僕|オレ|おれ|俺|ちん|チン|朕|じぶん|自分|"
      on(
        /(#{MINE_REGEXP})が日直です|日直は(#{MINE_REGEXP})です/,
        description: "言った人が日直になります",
        name: "stand_up",
        all: true
      )

      on(
        /(?<someone>[^#{MINE_REGEXP}]+)が日直です/,
        description: "だれかを日直に登録します",
        name: "recommend",
        all: true
      )

      on(
        /.*日直(さん|の方|の人)/,
        description: "<日直さん>にメッセージを振ります",
        name: "resolve",
        all: true
      )

      def stand_up(message)
        register(message.original[:from])
        infomation(message)
      end

      def recommend(message)
        register(message[:someone])
        infomation(message)
      end

      def infomation(message)
        message.reply("#{registered}を日直に登録しました")
      end

      def resolve(message)
        if registered
          message.reply("#{registered}: #{message.body}", type: :privmsg)
        else
          message.reply("日直が登録されていません")
        end
      end

      private
      def register(someone)
        robot.brain.data[NAMESPACE] = {name: someone, date: Date.today}
      end

      def registered
        data = robot.brain.data[NAMESPACE]
        return nil if data.nil? || data[:date] < Date.today
        data[:name]
      end
    end
  end
end
