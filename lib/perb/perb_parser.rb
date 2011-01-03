require 'yaml'
require 'rubygems'
require "active_record"
require "ruby-debug"

module Perb
  PERB_FLOAT=/\A\d*\.\d*\z/
  PERB_INTEGER=/\A\d*\z/
  class PerbParser
    #TODO: 1. Needles/haystack theme is confusing.
    #      2. input/output references should be renamed.
    #      3. each_pair... calls should use something more
    #         descriptive than 'k'/'v' in associated blocks

    attr_reader :result

    def initialize(result)
      unless result.is_a?(Array)
        raise ArgumentError, "PerbParser expects and Array of Strings for initialization"
      end

      @result=result
    end

    def find_needle(needle, haystack)
      value = cast(haystack.sub(/.*#{needle}.*/, '\1'))
        value
    end

    def find_needles(needles, haystack)
      unless needles.is_a?(Hash)
        raise ArgumentError, "PerbParser expects and Hash of Strings for initialization"
      end

      attributes_and_values={}

      needles.each_pair do|k, v|
        attributes_and_values[k]=find_needle(v, haystack)
      end

      attributes_and_values
    end

    def get_matching_output_line(current_haystack_line)
      ret_val = ""
      result.each do |r|
        ret_val = r if (r =~ /.*#{current_haystack_line}.*/) == 0
      end
       ret_val
    end

    def cast(string)
      if(string=~PERB_FLOAT)
        result=string.to_f
      elsif(string=~PERB_INTEGER)
        result=string.to_i
      else
        result=string
      end
      result
    end

    def parse
      all_attributes={:created_at => Time.now.to_s}

      haystacks_and_needles.each_pair do |k, v|
        output_line = get_matching_output_line(k)
        all_attributes.merge!(find_needles(v, output_line))
      end

      all_attributes
    end

    def haystacks_and_needles
      { /httperf.*/=>{
              :timeout                              => /timeout=(\d*)/,
              :uri                                  => /uri=(\S*)/,
              :rate                                 => /rate=(\d*)/,
              :num_conns                            => /num-conns=(\d*)/,
              :num_calls                            => /num-calls=(\d*)/ },
        /Maximum.*/=>{
              :burst_length                         => /burst\ length: (\d*)/ },
        /Total:.*/=>{
              :actual_conns                         => /Total: connections (\d*)/,
              :total_requests                       => /Total: connections .*requests (\d*)/,
              :total_replies                        => /Total: connections .*replies (\d*)/,
              :test_duration                        => /Total: connections .*test-duration (\d*\.\d*)/ },
        /Connection rate:.*/=>{
              :connections_per_sec                  => /Connection rate: (\d*\.\d*)/,
              :ms_per_connection                    => /conn\/s \((\d*\.\d*)/,
              :concurrent_connections               => /conn, (<=\d*) concurrent/ },
        /Connection time \[ms\]: min.*/=>{
              :connection_time_min                  => /Connection time \[ms\]: min (\d*\.\d*)/,
              :connection_time_avg                  => /Connection time \[ms\]: .* avg (\d*\.\d*)/,
              :connection_time_max                  => /Connection time \[ms\]: .* max (\d*\.\d*)/,
              :connections_time_stddev              => /Connection time \[ms\]: .* stddev (\d*\.\d*)/ },
        /Connection time \[ms\]: connect.*/=>{
              :connection_time_latency              => /Connection time \[ms\]: connect (\d*\.\d*)/ },
        /Connection length.*/=>{
              :connection_replies_per_connection    => /Connection length \[replies\/conn\]: (\d*\.\d*)/ },
        /Request rate.*/=>{
              :request_per_sec                      => /Request rate: (\d*\.\d*)/,
              :request_duration                     => /Request rate: .* req\/s \((\d*\.\d*)/ },
        /Request size.*/=>{
              :request_size                         => /Request size \[B\]: (\d*\.\d*)/ },
        /Reply rate.*/=>{
              :replies_per_sec_min                  => /\[replies\/s\]: min (\d*\.\d*)/,
              :replies_per_sec_avg                  => /\[replies\/s\]: min.* avg (\d*\.\d*)/,
              :replies_per_sec_max                  => /\[replies\/s\]: min.* max (\d*\.\d*)/,
              :replies_per_sec_stddev               => /\[replies\/s\]: min.* stddev (\d*\.\d*)/ },
        /Reply time.*/=>{
              :reply_time                           => /Reply time .* (\d*\.\d*)/ },
        /Reply size.*/=>{},
        /Reply status.*/=>{
              :reply_status_1xx                     => /Reply status.* 1xx=(\d*)/,
              :reply_status_2xx                     => /Reply status.* 2xx=(\d*)/,
              :reply_status_3xx                     => /Reply status.* 3xx=(\d*)/,
              :reply_status_4xx                     => /Reply status.* 4xx=(\d*)/,
              :reply_status_5xx                     => /Reply status.* 5xx=(\d*)/ },
        /CPU time.*/=>{},
        /Net I\/O.*/=>{},
        /Errors: total.*/=>{
              :errors_total                         => /Errors: total (\d*)/,
              :errors_client_timeout                => /Errors: .*client-timo (\d*)/,
              :errors_socket_timeout                => /Errors: .*socket-timo (\d*)/,
              :errors_connection_refused            => /Errors: .*connrefused (\d*)/,
              :errors_connection_reset              => /Errors: .*connreset (\d*)/ },
        /Errors: fd-unavail.*/=>{
              :errors_fd_inavailable                => /Errors: fd-unavail (\d*)/,
              :errors_address_unavailable           => /Errors: .* addrunavail (\d*)/,
              :errors_ftab_full                     => /Errors: .* ftab-full (\d*)/,
              :errors_other                         => /Errors: .* other (\d*)/ }}
    end
  end
end
