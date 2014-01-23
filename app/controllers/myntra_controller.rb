class MyntraController < ApplicationController
  def index
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get('http://www.myntra.com/')
  	main_links = page.search(".mk-level2")
  	@main_links_array = Array.new
  	main_links.each do |link|
      @main_links_array << link[:href]
  	end
   render :text => get_products(@main_links_array)
  end


  def get_products(links_array)
    agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
    page = agent.get('http://www.myntra.com'+links_array[0])
    listing = page.search(".mk-product")
    product_count = page.search(".mk-product-count")[0].text()
    product_count = product_count.gsub(/[a-zA-Z\s]*/, "")
    total_loops = (product_count.to_f/24).to_i
    Rails.logger.info total_loops
    ajax_link = page.search(".mk-more-products-link")[0][:href]
    ajax_link = ajax_link.chop
    listing_array = Array.new
    listing.each do |listing|
       listing_array << listing.search(".mk-prod-name").text().gsub(/\r*\n*\t*/, "")+','+listing.search(".red").text().gsub(/\r*\n*\t*/, "")
       Rails.logger.info listing.at("img")["original"]
    end
    i = 2

    while(i <= total_loops) do
    	url = ajax_link+"#{i}"
    	Rails.logger.info url
     listing_array << get_ajax_products(url)
       i += 1
    end
    listing_array.flatten

  end


   def get_ajax_products(url)
    agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
    page = agent.get(url)
    listing = page.search(".mk-product")
    ajax_link = page.search(".mk-more-products-link")[0][:href]
    ajax_link = ajax_link.chop
    listing_array = Array.new
    listing.each do |listing|
       listing_array << listing.search(".mk-prod-name").text().gsub(/\r*\n*\t*/, "")+','+listing.search(".red").text().gsub(/\r*\n*\t*/, "");
    end
    listing_array

  end

  def ajax_content(links)
  agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  page = agent.post('http://www.myntra.com/searchws/search/styleids2', {
  query: "(global_attr_gender:('Men') AND global_attr_season:('Fall' OR 'Winter') AND global_attr_year:([2013 TO 2013])) AND (count_options_availbale:[1 TO *])"
})
listing = page.search(".mk-product")
    listing_array = Array.new
    listing.each do |listing|
       listing_array << listing.search(".mk-prod-name").text().gsub(/\r*\n*\t*/, "")+','+listing.search(".red").text().gsub(/\r*\n*\t*/, "");
       Rails.logger.info listing.at("img")["original"]
    end
    listing_array
  end
end
