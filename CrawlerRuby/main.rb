require 'nokogiri'
require 'open-uri'

url = 'https://www.amazon.com/s?i=specialty-aps&bbn=16225007011&rh=n%3A16225007011%2Cn%3A193870011&ref=nav_em__nav_desktop_sa_intl_computer_components_0_2_6_3'

user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'

html = URI.open(url, 'User-Agent' => user_agent)
doc = Nokogiri::HTML.parse(html)

products = []

doc.css('.s-main-slot .s-result-item').each do |product_node|
    title_node = product_node.at_css('h2 a span')
    price_node = product_node.at_css('.a-offscreen')
  
    if title_node && price_node
      title = title_node.text
      price = price_node.text
      products << { title: title, price: price }
    end
end

products.each_with_index do |product, index|
  puts "\n#{index + 1}) #{product[:title]}\nPrice: #{product[:price]}\n"
end