class JustDialController < ApplicationController
  def index
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get('http://www.justdial.com/Bangalore/Shopping-Malls/ct-496089')
  	#main_boxes = page.search(".rslwrp")
  	arr = Array.new
  	arr << get_pages('http://www.justdial.com/Bangalore/Shopping-Malls/ct-496089')
  	pagination_links = page.links_with(:text => /^[0-9][0-9]?$/)
  	pagination_links.each do |page|
     arr << get_pages(page.href)
  	end
    arr = arr.flatten    
  	view = ""
  	arr.each do |a|
       view += "<p>"+ a+"</p>"
  	end
   render :text => view.html_safe
  end


  def get_pages(link)
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get(link)
    main_boxes_array = Array.new
  	
    main_boxes_array << page.links_with(:text => /More/)
  	
  	main_boxes_array = main_boxes_array.flatten
  	arr = Array.new
  	main_boxes_array.each do |a|
       arr <<  get_address(a.href)
  	end
    return arr
  end


  def get_address(link)
    agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get(link)
  	#page = page.search(".compdt").text()
  	page = page.search(".hReview-aggregate").search(".item")[0].text()

  end


end

