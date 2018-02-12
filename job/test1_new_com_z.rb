#!/usr/bin/ruby
#encoding: utf-8
#gem install addressable
#gem install nokogiri

require 'rubygems'
require 'nokogiri'
require 'open-uri'
#require 'openssl'
#require 'rest-client'
require 'set'
#require 'uri'
require "date"
require "addressable/uri"

# https request
def open_web(url)
	res = open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
	#hasu_push(url,res.status)
	return res.status
end

#http://www.dead-link-checker.com/ja/
#https://faq.dnk-airregi.jp/special/
#https://denki.marubeni.co.jp/adjust/
#https://faq.dnk-airregi.jp/hc/ja/articles/236200267-10%E5%BA%97%E8%88%97%E4%BB%A5%E4%B8%8A%E3%81%AE%E4%B8%80%E6%8B%AC%E3%81%8A%E7%94%B3%E8%BE%BC%E3%81%BF-%E4%BB%96%E7%A4%BE%E3%81%8B%E3%82%89%E3%81%AE%E5%88%87%E6%9B%BF%E3%81%88-
#https://www.tohoku-epco.co.jp/news/normal/1195222_1049.html

  z = 0
  $a_src = ""
  $ref_url = ""
  data = []
  dest = []
  seen_pages = Set.new

#ページ内リンクを再帰的に1件ずつ取得し処理する
#def main(url,ref_url,data,seen_pages,start_url,z)
def main(url,data,seen_pages,start_url,z)

  starting_url = Addressable::URI.parse("#{start_url}")
  #p starting_url
  #input_value = gets
  #starting_url = URI.parse(starting_url)
  host = starting_url.host
  top = start_url.split('/').first(3).join('/')

    #puts  "[URL] = "
    #puts  url
    #puts "[start_url] = " + start_url
    #input_value = gets

#処理URLとスタートURLが同じだったらスキップ
if url.to_s == start_url.to_s
  puts "処理URLとスタートURLが同じだったらスキップ"
  #input_value = gets
else

	  #(初回用)url,$a_srcが空ならstart_urlを代入
	  if url == ""
	    url = start_url
		#input_value = gets
	  end

	  if $a_src == ""
	    $a_src = url
		#input_value = gets
	  end

	  if $ref_url == ""
	    $ref_url = url
		#input_value = gets
	  end

  #mid = URI.parse(url)
  #mid = url.split('/').join('{')
  #mid = mid.split('{').drop(1)

#    puts "--デバッグ1----------"
    puts  "[url] = "
    puts url
    puts "[start_url] = " + start_url
    #puts "[starting_url.host] = "
    #puts host
    puts "[top] = #{top}"
    #puts "[mid] = #{mid}"
    puts "[$a_src] = "
    puts $a_src
    puts "[$ref_url] = "
    puts $ref_url
    #puts "[data] = "
    #puts data
    #puts "[seen_pages] = "
    #p seen_pages
	puts "ループ前:#{z}"
    puts "----------------------------------"
    puts ""
    #input_value = gets

	begin
      #対象URLを開きdocに格納(解析用) Use Nokogiri to get the document
		  $ref_url = url

      doc = Nokogiri::HTML(open(url))
      #File.write( "doc_#{z}.csv", doc)
	puts "doc取得通過"
	#input_value = gets
      #1件ずつaタグを取得しanchorに格納し処理
      doc.css('a').each do |anchor|
		  puts "ループ内:#{z}"
		  z = z + 1
	      input_value = gets
          #リンクURLを変数$a_srcに格納
          $a_src = anchor[:href]
          puts "補完前[$a_src] = " + $a_src

			#リンク補完処理
			if $a_src.include?(host)
		      puts "補完なし[$a_src] = "
		      puts $a_src
			else
			  $a_src = URI.join( top,$a_src )
		      puts "補完後[$a_src] = "
	          puts $a_src
			end

 		  #puts "[data] = "
	      #puts data
	      #puts "[seen_pages] = "
     	  #p seen_pages
          #input_value = gets

    	  #puts "--seen_pagesに含まれているか判定----------"
          unless seen_pages.include?($a_src.to_s)
	        puts "--seen_pagesに含まれていない----------"
            #input_value = gets

		    	  #puts "--$a_srcにhostが含まれているか判定----------"
		          if !(url.to_s.include?(host.to_s))
		            #別ホストの場合はそれ以上は再帰処理せずスルー
			        puts "$a_srcにhostが含まれていないので再帰処理せずスルー"

		          else

		            #seen_pagesに$a_srcを追加
		            seen_pages.add?("#{$a_src}")
			        #input_value = gets

#data.push("#{$a_src} - #{$ref_url}")


		            再帰処理開始：main($a_src,ref_url,data,seen_pages,start_url,z)
					puts "再帰処理開始"
		            #main($a_src,ref_url,data,seen_pages,start_url,z)
		            main($a_src,data,seen_pages,start_url,z)

	                puts "再帰処理終了"
					#ref_url = url

		            #data、seen_pagesに$a_srcを追加
		            #seen_pages.add?("#{$a_src}")
					#puts "[data] = "
				    #puts data
			        #puts "[seen_pages] = "
     			    #p seen_pages
		            #input_value = gets
		          end
          else
		  #unless seen_pages.includeのelse
	          #seen_pagesに含まれていたので既にアクセス済みなのでスルー
	          puts "seen_pagesに含まれていたので既にアクセス済みなのでスルー"
          end
		  #unless seen_pages.includeの閉じ
		#z = z + 1

      end
	  #ループの閉じ
      data.push("#{url}")
	  #data.push("#{url} - #{ref_url}")
#data.push("#{url} - #{$a_src}")
#data.push("#{$a_src} - #{$ref_url}")

	rescue => ex
		puts "error:#{url}:#{ex}"
		seen_pages.add?("#{url}")
		#data.push("#{$a_src} Error: #{ex} - #{$ref_url}")
		data.push("#{url}:Error: #{ex}")
		#data.push("#{url}")
		puts "[data] = "
		puts data
	    #puts "[seen_pages] = "
	    #p seen_pages
		#z = z + 1
		puts "Errorです"
        input_value = gets
	end

	puts "#{url}のループ外"
   #input_value = gets

  #puts "--デバッグ最終----------"
  #puts "[data] = "
  #puts data
  #puts "[seen_pages] = "
  #p seen_pages
  #puts "----------------------------------"
  #puts ""

end
#スタート同一判定の閉じ

  return(data);
  #return(seen_pages);
  
end

url = ""
#start_url = "http://www.connectw.jp/TEST.html"
start_url = "https://faq.dnk-airregi.jp/hc/ja"
#start_url = "https://faq.airid.airregi.jp/hc/ja"
#start_url = "https://faq.market.airregi.jp/hc/ja"
#start_url = "https://faq.petsalonboard.airreserve.net/hc/ja"
#start_url = "https://faq.petsalonboard.airreserve.net/hc/ja"
#start_url = "https://airregi.jp/reserve/"
ref_url = start_url

#調査対象
#https://faq.airregi.jp
#https://faq.airreserve.net
#https://faq.airwait.jp→https://faq.airwait.jp/hc/ja
#https://faq.petsalonboard.airreserve.net→https://faq.petsalonboard.airreserve.net/hc/ja
#https://faq.market.airregi.jp→https://faq.market.airregi.jp/hc/ja
#https://airid.zendesk.com→https://faq.airid.airregi.jp/hc/ja
#https://faq.dnk-airregi.jp→https://faq.dnk-airregi.jp/hc/ja

puts "処理開始"
d = DateTime.now
str = d.strftime("%Y年 %m月 %d日 %H時 %M分 %S秒")
p str

#data2 = main(url,ref_url,data,seen_pages,start_url,z)
data2 = main(url,data,seen_pages,start_url,z)

#puts "--------------------------"
#puts data2.size
#puts data2
#p seen_pages
puts "ALL_END■■■■■■■■■■■■■■■■"
d = DateTime.now
str = d.strftime("%Y年 %m月 %d日 %H時 %M分 %S秒")
p str

#"配列をCSV形式でファイルに出力"
File.write( "data.csv", data2 )

