require 'open-uri'

class Search < ActiveRecord::Base
  
  def retrieve_search_result(query)
      mechanize = Mechanize.new { |agent|
          agent.user_agent_alias = 'Mac Safari'
      }
      
      search_page = mechanize.get('https://www.youtube.com')
      search_result = search_page.form_with(:id => 'masthead-search' ) do |search|
          search_form['search_query'] = query
      end.submit
      
      results = Array.new
      search_result.search('div.yt-lockup.yt-lockup-tile.yt-lockup-video.vve-check.yt-uix-tile').each do |div|
          result = Hash.new
          result['text'] = div.css('a.yt-uix-sessionlink.yt-uix-tile-link.yt-ui-ellipsis.yt-ui-ellipsis-2.spf-link').text
          result['link'] = div.css('a.yt-uix-sessionlink.yt-uix-tile-link.yt-ui-ellipsis.yt-ui-ellipsis-2.spf-link').attribute('href').value
          result['image'] = div.css('div.yt-thumb.video-thumb img').attribute('src').value
          results << result
      end
      return results
  end
  
  
  
  def search
    # スクレイピング先のURL
    url = 'http://matome.naver.jp'

    charset = nil
    html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
    end


    # htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    
    results = Array.new
    doc.xpath('//li[@class="mdTopMTMList01Item"]').each do |node|
        result = Hash.new
       
        result[:title] = node.css('h3').inner_text
      
        result[:img] =  node.css('img').attribute('src').value

        result[:link] =  node.css('a').attribute('href').value
        
        results << result
    end
    
    return results
  end
end

