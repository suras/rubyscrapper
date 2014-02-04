class CouponduniaController < ApplicationController
  def index
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get('http://www.coupondunia.in/')
  	main_links = page.search(".navbar li")[0]
    main_links = main_links.search("ul li")
  	main_links_array = Array.new
  	main_links.each do |link|
      main_links_array << link.at('a')["href"]
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
  	coupons = page.search(".detail")
  	pages = page.search(".page_click_coupons")
  	coupons_array = Array.new
    coupons.each do |c|
      elm = c.search("a.couponTitle")
      coupons_array << elm.text().gsub(/\r*\n*\t*/, "")
      coupons_array << c.at("a.couponTitle")["href"]
    end
    pages.each do |page|
      coupons_array << get_pagination_pages(main_links_array[0]+page["href"])
    end
  	return coupons_array.flatten
  end

  def get_pagination_pages(link)
    agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get(link)
    coupons = page.search(".detail")
  	pages = page.search(".page_click_coupons")
  	coupons_array = Array.new
    coupons.each do |c|
      elm = c.search("a.couponTitle")
      coupons_array << elm.text().gsub(/\r*\n*\t*/, "")
      coupons_array << c.at("a.couponTitle")["href"]
    end
    coupons_array
  end

end
