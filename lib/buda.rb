require 'rest-client'

class Buda
  attr_accessor :base

  def initialize
    @base = 'https://www.buda.com/api/v2/markets'
  end

  def markets
    res = request(@base)
    res[:markets]
  end

  def max_amount(market_id)
    timestamp = (Time.now - 60 * 60 * 24).to_i
    url = @base + '/' + market_id + '/trades?=timestamp' + timestamp.to_s
    request(url)[:trades][:entries].map { |i| i[1] }.max
  end

  private

  def request(url)
    begin
      response = RestClient.get(url)
      JSON.parse(response).deep_symbolize_keys
    rescue
      raise RuntimeError, "Hubo un problema con la solicitud"
    end
  end
end
