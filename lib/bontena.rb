require "bontena/version"
require "slop"
require "kommando"

module Bontena

  def self.run
    opts = Slop.parse do |o|
      o.separator ""
      o.separator "grid"
      o.separator " stats"
      o.on '--help', "This help text" do
        puts o
        exit 1
      end
    end

    show_help = Proc.new do
      puts opts
      exit 1
    end
    component = opts.arguments[0]
    subcomponent = opts.arguments[1]
    subsubcomponent = opts.arguments[2]

    case component
    when "grid"
      case subcomponent
      when "stats"
        k = Kommando.run_async "$ kontena service ls | tail -n +2 | cut -f2 -d ' ' | xargs -L 1 kontena service stats"
        last_line = nil
        while k.code == nil do
          lines = k.out.split("\n")
          puts lines.last unless last_line == lines.last
          last_line = lines.last
          sleep 0.10
        end
      else
        show_help.call
      end
    else
      show_help.call
    end
  end
end


Bontena.run
