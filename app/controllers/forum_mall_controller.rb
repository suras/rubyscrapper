class ForumMallController < ApplicationController
  @@arr = Array.new
  def index
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get('http://www.forumvaluemall.com/stores.php')
    links = page.links_with(:class => "cate_link")
    arr = Array.new
    links.each do |link|
      get_stores("http://www.forumvaluemall.com/"+link.href())
    end
    view = ""
  	@@arr.each do |a|
       view += "<p>"+ a+"</p>"
  	end
   render :text => view.html_safe
  end


  def get_stores(link)
  	agent = Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari'}
  	page = agent.get(link)
  	page = page.search('h1')[1].next_element() 
  	page = page.search("tr")
  	arr = Array.new
  	page.drop(2).each do |p|
      @@arr << p.search("td")[1].text()
  	end
  	
  end


end
