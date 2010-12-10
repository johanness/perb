require 'yaml'
require 'rubygems'
require "active_record"
require "ruby-debug"

class Result < ActiveRecord::Base
end

def save_result_to_database(match)

  connection = ActiveRecord::Base.establish_connection(
    :adapter => "mysql",
    :host => "localhost",
    :user => "root",
    :database => "perbs",
    :password => ""
  )
  unless connection.connected?
    puts "Could not establish connection, please run"
    puts "rake db:create"
    puts "rake db:migrate"
    Process.exit
  end
  Result.create(:average_reply_rate => match[20].to_f)
end

def measure
  settings_yml=File.expand_path('../../../config/settings.yml', __FILE__)
  settings = YAML::load_file(settings_yml)
  settings.values.each do |test_settings|
    # set the parameters
    command = "httperf"
    test_settings.each_pair do  |key, val|
      command += " --#{key}=#{val}"
    end

    # run the command
    result = `#{command}`
    result_by_line = result.split("\n").delete_if{|e| e.empty?}

    params = {:timeout        => "--timeout=",
              :uri            => "--uri=",
              :rate           => "--rate=",
              :num_conns      => "--num-conns=", 
              :num_calls      => "--num-calls=",
              :burst_length   => "--burst-length="}
    debugger


    save_result_to_database(match)
  end
end

    #result =~ /httperf --timeout=\d* --client=\d*\/\d* --server=localhost --port=\d* --uri=\/ --rate=\d* --send-buffer=\d* --recv-buffer=\d* --num-conns=\d* --num-calls=\d*\\nMaximum connect burst length: (\d*)\\n\\nTotal: connections (\d*) requests (\d*) replies (\d*) test-duration (\d*\.\d*) s\\n\\nConnection rate: (\d*\.\d*) conn\/s \((\d*\.\d*) ms\/conn, <=(\d*) concurrent connections\)\\nConnection time \[ms\]: min (\d*\.\d*) avg (\d*\.\d*) max (\d*\.\d*) median (\d*\.\d*) stddev (\d*\.\d*)\\nConnection time \[ms\]: connect (\d*\.\d*)\\nConnection length \[replies\/conn\]: (\d*\.\d*)\\n\\nRequest rate: (\d*\.\d*) req\/s \((\d*\.\d*) ms\/req\)\\nRequest size \[B\]: (\d*\.\d*)\\n\\nReply rate \[replies\/s\]: min (\d*\.\d*) avg (\d*\.\d*) max (\d*\.\d*) stddev (\d*\.\d*) \((\d*) samples\)\\nReply time \[ms\]: response (\d*\.\d*) transfer (\d*\.\d*)\\nReply size \[B\]: header (\d*\.\d*) content (\d*\.\d*) footer (\d*\.\d*) \(total (\d*\.\d*)\)\\nReply status: 1xx=(\d*) 2xx=(\d*) 3xx=(\d*) 4xx=(\d*) 5xx=(\d*)\\n\\nCPU time \[s\]: user (\d*.\d*) system (\d*.\d*) \(user (\d*.\d*)% system (\d*.\d*)% total (\d*.\d*)%\)\\nNet I\/O: (\d*.\d*) KB\/s \((\d*.\d*\*\d*\^\d*) bps\)\\n\\nErrors: total (\d*) client-timo (\d*) socket-timo (\d*) connrefused (\d*) connreset (\d*)\\nErrors: fd-unavail (\d*) addrunavail (\d*) ftab-full (\d*) other (\d*)\\n/

    #match = Regexp.compile('httperf --timeout=\d* --client=\d*\/\d* --server=localhost --port=\d* --uri=\/ --rate=\d* --send-buffer=\d* --recv-buffer=\d* --num-conns=\d* --num-calls=\d*\\nMaximum connect burst length: (\d*)\\n\\nTotal: connections (\d*) requests (\d*) replies (\d*) test-duration (\d*\.\d*) s\\n\\nConnection rate: (\d*\.\d*) conn\/s \((\d*\.\d*) ms\/conn, <=(\d*) concurrent connections\)\\nConnection time \[ms\]: min (\d*\.\d*) avg (\d*\.\d*) max (\d*\.\d*) median (\d*\.\d*) stddev (\d*\.\d*)\\nConnection time \[ms\]: connect (\d*\.\d*)\\nConnection length \[replies\/conn\]: (\d*\.\d*)\\n\\nRequest rate: (\d*\.\d*) req\/s \((\d*\.\d*) ms\/req\)\\nRequest size \[B\]: (\d*\.\d*)\\n\\nReply rate \[replies\/s\]: min (\d*\.\d*) avg (\d*\.\d*) max (\d*\.\d*) stddev (\d*\.\d*) \((\d*) samples\)\\nReply time \[ms\]: response (\d*\.\d*) transfer (\d*\.\d*)\\nReply size \[B\]: header (\d*\.\d*) content (\d*\.\d*) footer (\d*\.\d*) \(total (\d*\.\d*)\)\\nReply status: 1xx=(\d*) 2xx=(\d*) 3xx=(\d*) 4xx=(\d*) 5xx=(\d*)\\n\\nCPU time \[s\]: user (\d*.\d*) system (\d*.\d*) \(user (\d*.\d*)% system (\d*.\d*)% total (\d*.\d*)%\)\\nNet I\/O: (\d*.\d*) KB\/s \((\d*.\d*\*\d*\^\d*) bps\)\\n\\nErrors: total (\d*) client-timo (\d*) socket-timo (\d*) connrefused (\d*) connreset (\d*)\\nErrors: fd-unavail (\d*) addrunavail (\d*) ftab-full (\d*) other (\d*)\\n').match(result)
