class CreatePerbs < ActiveRecord::Migration
  def self.up
    create_table :perbs do |t|
      #"Command-line arguments"
      t.column :timeout, :integer
      t.column :uri, :string
      t.column :rate, :integer
      t.column :num_conns, :integer
      t.column :num_calls, :integer
      t.column :burst_length, :integer

      #"Total: connections 500 requests 839 replies 678 test-duration 9.368 s"
      t.column :actual_conns, :integer
      t.column :total_requests, :integer
      t.column :total_replies, :integer
      t.column :test_duration, :decimal

      #"Connection rate: 53.4 conn/s (18.7 ms/conn, <=163 concurrent connections)"
      t.column :connections_per_sec, :decimal
      t.column :ms_per_connection, :decimal
      t.column :concurrent_connections, :string
      
      #"Connection time [ms]: min 2.9 avg 4.7 max 13.3 median 4.5 stddev 1.4"
      t.column :connection_time_min, :decimal
      t.column :connection_time_avg, :decimal
      t.column :connection_time_max, :decimal
      t.column :connections_time_stddev, :decimal

      #"Connection time [ms]: connect 1.1"
      t.column :connection_time_latency, :decimal

      #"Connection length [replies/conn]: 2.000"
      t.column :connection_replies_per_connection, :decimal

      #"Request rate: 89.6 req/s (11.2 ms/req)"
      t.column :request_per_sec, :decimal
      t.column :request_duration, :decimal

      #"Request size [B]: 66.0"
      t.column :request_size, :decimal

      #"Reply rate [replies/s]: min 135.6 avg 135.6 max 135.6 stddev 0.0 (1 samples)"
      t.column :replies_per_sec_min, :decimal
      t.column :replies_per_sec_avg, :decimal
      t.column :replies_per_sec_max, :decimal
      t.column :replies_per_sec_stddev, :decimal

      #"Reply time [ms]: response 8.3 transfer 0.0"
      t.column :reply_time, :decimal

      #"Reply size [B]: header 150.0 content 166.0 footer 0.0 (total 316.0)"
      # none of these returns were implemented

      #"Reply status: 1xx=0 2xx=0 3xx=0 4xx=0 5xx=678"
      t.column :reply_status_1xx, :integer
      t.column :reply_status_2xx, :integer
      t.column :reply_status_3xx, :integer
      t.column :reply_status_4xx, :integer
      t.column :reply_status_5xx, :integer

      #"CPU time [s]: user 3.00 system 6.30 (user 32.0% system 67.2% total 99.2%)"
      #"Net I/O: 28.1 KB/s (0.2*10^6 bps)"
      # none of these returns were implemented

      #"Errors: total 161 client-timo 161 socket-timo 0 connrefused 0 connreset 0"
      t.column :errors_total, :integer
      t.column :errors_client_timeout, :integer
      t.column :errors_socket_timeout, :integer
      t.column :errors_connection_refused, :integer
      t.column :errors_connection_reset, :integer

      #"Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0"
      t.column :errors_fd_inavailable, :integer
      t.column :errors_address_unavailable, :integer
      t.column :errors_ftab_full, :integer
      t.column :errors_other, :integer
    end
  end

  def self.down
    drop_table :perbs
  end
end
