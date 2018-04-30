require_relative 'clicks'
require 'date'

class Solution
  attr_accessor :result_set
  def initialize
    @data = Clicks::CLICKS
    @result_set = nil
  end
  def find(arr=nil)
    myclick = arr || @data
    myhash = Hash.new({})
    myresult = []
    myclick.each do |x|
      click_time = x[:timestamp]
      click_ip =x[:ip]
      click_amount = x[:amount]
      if mykey = create_timestamp_key(click_time)
        if !myhash[mykey].empty? && myhash[mykey].has_key?(click_ip)
          myhash[mykey][click_ip] << {timestamp: click_time, amount: click_amount }
        else
          myhash[mykey] = myhash[mykey].merge({click_ip => [{timestamp: click_time, amount: click_amount }] })
        end
      else
        puts "#{click_ip} doesn't have timestamp"
      end

    end
    # get the result
    # remove click from same ip that appears > 10 times
    ip_count = Hash.new(0)
    remove_clicks = []
    myhash.each do |time_period, myclicks|
      myclicks.each do |click_ip, value|
        max_value = value.max_by{|m| m[:amount]}
        myresult << {ip: click_ip}.merge(max_value)
        ip_count[click_ip]+=1
        # stop count at 11, add the ip to the delete click arr
        remove_clicks << click_ip if ip_count[click_ip] == 11
      end
    end

    final_result = myresult.select{|x| !remove_clicks.include?(x[:ip])}
    # puts remove_clicks
    # puts final_result
    @result_set = final_result
    File.open('result-set.txt','w'){|file| file.write(final_result)}

  end

  def create_timestamp_key(str)
    if str
      mydate = DateTime.parse(str)
      mydate.to_date.to_s+"p"+(mydate.hour+1).to_s
    end
  end


end


m = Solution.new
m.find
