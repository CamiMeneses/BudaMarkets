require 'open-uri'
require 'JSON'
require 'byebug'

class Buda
  attr_accessor :base

  def initialize
    @base = 'https://www.buda.com/api/v2/markets'
  end

  def markets_max_amount
    data = {}
    begin
      markets.map { |i| data[i[:id]] = max_amount(i[:id]) }
      puts '-' * 45 + "\n|      Mercado      Monto máximo en 24h     |\n " + '-' * 45
      data.map do |name, value|
        puts '-' * 45
        puts '      ' + name + '       ' + name[0..2] + '   ' + value
      end
    rescue => e
      puts e
    end
  end

  private

  def markets
    res = request(@base)
    res[:markets]
  end

  def max_amount(market_id)
    timestamp = (Time.now - 60 * 60 * 24).to_i
    url = @base + '/' + market_id + '/trades?=timestamp' + timestamp.to_s
    request(url)[:trades][:entries].map { |i| i[1] }.max
  end

  def request(url)
    begin
      JSON.parse(open(url).read, symbolize_names: true)
    rescue
      raise RuntimeError, "Hubo un problema con la solicitud"
    end
  end
end

buda = Buda.new
puts buda.markets_max_amount
