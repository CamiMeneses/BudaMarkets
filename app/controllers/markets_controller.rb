require 'buda'

class MarketsController < ApplicationController
  def index
    @markets = markets_max_amount
  end

  private

  def markets_max_amount
    data = {}
    begin
      buda.markets.map { |i| data[i[:id]] = buda.max_amount(i[:id]) }
    rescue => e
      flash[:alert] = e
      return
    end

    return data
  end

  def buda
    @buda ||= Buda.new
  end
end
