class CouponNationController < ApplicationController
  def index
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get('http://www.cuponation.in/')
  	main_links = page.search(".category-dropdown")
    main_links = main_links.search(".dropdown")
    main_links = main_links.search("li a")
  	main_links_array = Array.new
  	main_links.each do |link|
      main_links_array << "http://www.cuponation.in"+link["href"]
  	end
   arr = get_coupons(main_links_array)
  	view = ""
  	arr.each do |a|
       view += "<p>"+ a+"</p>"
  	end
   render :text => view.html_safe
  end


  def get_coupons(main_links_array)
    agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get(main_links_array[0])
  	coupons = page.search(".code")
  	pages = page.search(".pager a")
  	coupons_array = Array.new
    coupons.each do |c|
      link = c.at(".six a")["href"]
      title = c.search(".title a").text().gsub(/\r*\n*\t*/, "")
      coupons_array << link
      coupons_array << title
    end
    pages.each do |page|
     url =  "http://www.cuponation.in"+page["href"]
     coupons_array << get_pagination_pages(url)
    end
  	return coupons_array.flatten
  end

  def get_pagination_pages(link)
    agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get(link)
    coupons = page.search(".code")
  	pages = page.search(".pager a")
  	coupons_array = Array.new
    coupons.each do |c|
      link = c.at(".six a")["href"]
      title = c.search(".title a").text().gsub(/\r*\n*\t*/, "")
      coupons_array << link
      coupons_array << title
    end
    coupons_array
  end
end
