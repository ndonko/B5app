require 'rubygems'
require 'dm-core'
require 'data_mapper'  #requires all the gems listed above
require 'sinatra'
require 'sass'
require 'haml'
#require 'Time'

#this will display the logs
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default,{
   :adapter  => 'mysql',
   #:encoding => 'utf8',
   :database  => 'B5' ,  
   :username  => 'root',
   :password => "",
   :host     => '127.0.0.1'
})

class Article
  include DataMapper::Resource 
  property :id,         Serial
  property :title,      Text
  property :text ,      Text
  property :posted_by,  String
  property :permalink,  Text
  property :created_at, DateTime
  property :updated_at, DateTime 
end

class Comment 
  include DataMapper::Resource
  property :id,         Serial
  property :text ,      Text
  property :posted_by,  String
  property :permalink,  Text
  property :created_at, DateTime
  property :updated_at, DateTime 
   
end


# list all article
get '/articles' do
  @articles = Article.all
  haml :articles
end
# add new article
get '/articles/new' do
  @article = Article.new
  haml :article_new
end
# create new article  
post '/articles' do
  @article= Article.new(params[:article])
  if @article.save
    status 201
    redirect '/article/' + @article.id.to_s
  else
    status 400
    haml :article_new
  end
end
# edit article
get '/articles/edit/:id' do
  @article = Article.get(params[:id])
  haml :article_edit
end
# update article
put '/articles/:id' do
  @article = Article.get(params[:id])
  if @article.update(params[:article])
    status 201
    redirect '/articles/' + params[:id]
  else
    status 400
    haml :article_edit  
  end
end
# delete article confirmation
get '/articles/delete/:id' do
  @article= Article.get(params[:id])
  erb :delete
end

# delete article
delete '/:id' do
  article=Article.get params[:id]
  article.destroy
  redirect '/articles'  
end
# show rabbit
get '/articles/:id' do
  @article = Article.get(params[:id])
  haml :article_show
end
DataMapper.auto_upgrade!
