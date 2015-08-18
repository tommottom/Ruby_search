class RubyController < ApplicationController
  
  def index
    search = Search.new
    @results = search.search 
  end
  
  def trend#twitter APIを入れる予定です。
  end
end

