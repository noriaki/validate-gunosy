require 'json'
require 'open-uri'
require 'nokogiri'
require 'mongoid'
require 'csv'
require 'kconv'

$LOAD_PATH << '.'
require 'user'
require 'article'
require 'recommended'
#require 'hotentry'
#require 'picking'

Mongoid.configure do |conf|
  conf.master = Mongo::Connection.new('localhost', 27017).db('validate_gunosy')
end

if __FILE__ == $0
  Article.destroy_all
  User.destroy_all
  Hotentry.destroy_all

  search_results = (1..10).map{  |i|
    JSON.parse(File.open("g/#{ i}.json").read)['items'].map do |t|
      t['link']
   end
  }.flatten
  search_results.each do |l|
    name = l[/[^g]\/([^\/]*?)\/?$/,1]
    if name && !%w(gunosy.com signup login iphone).include?(name)
      User.create name: name
    end
  end

  links = User.all.each do |user|
    Nokogiri(
      (open(user.url(Date.parse('2013/5/5'))) rescue StringIO.new).read
      ).css('article h1').each do |e|
      article = Article.find_or_initialize_by url: e.parent['href']
      article.title = e.text.strip
      article.save
      Recommended.create user_id: user.id, article_id: article.id
    end
  end

end
