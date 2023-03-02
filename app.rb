# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'sinatra/content_for'
require 'pg'

# get '/memos' do
#   memos = convert_memos_to_hash
#   @memos =
#     memos['all_memos'].map do |memo|
#       { title: memo['title'], id: memo['id'] }
#     end
#   erb :memos
# end

get '/memos' do
  connect = connect_db
  memos = connect.exec("SELECT * FROM Memos")
  @memos =
    memos.map do |memo|
      { title: memo['memo_title'], id: memo['memo_id'] }
    end
  erb :memos
end

# post '/memos/new' do
#   memos = convert_memos_to_hash
#   memos['all_memos'] << { id: SecureRandom.uuid, title: params[:title], content: params[:content] }
#   write_to_memos_list(memos)
#   redirect '/memos'
# end

post '/memos/new' do
  connect = connect_db
  connect.exec("INSERT INTO Memos VALUES ('#{SecureRandom.uuid}', '#{params[:title]}', '#{params[:content]}');")
  redirect '/memos'
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  memos = convert_memos_to_hash
  make_memo_variable(memos)
  @memo_id = params[:id]
  erb :memo_content
end

delete '/memos/:id' do
  memos = convert_memos_to_hash
  after_delete_memo =
    { all_memos: memos['all_memos'].filter { |memo| memo['id'] != params[:id] } }
  write_to_memos_list(after_delete_memo)
  redirect '/deletion_completed_message'
end

get '/deletion_completed_message' do
  erb :deletion_completed_message
end

patch '/memos/:id/edit' do
  memos = convert_memos_to_hash
  edit_memo =
    memos['all_memos'].find { |memo| memo['id'] == params[:id] }
  edit_memo['title'] = params[:title]
  edit_memo['content'] = params[:content]
  write_to_memos_list(memos)
  redirect "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  memos = convert_memos_to_hash
  make_memo_variable(memos)
  @edit_memo_id = params[:id]
  erb :memo_editing
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def convert_memos_to_hash
    JSON.parse(File.read('memo.json'))
  end

  def write_to_memos_list(memo_contents)
    File.open('memo.json', 'w') { |file| JSON.dump(memo_contents, file) }
  end

  def make_memo_variable(memos)
    memo = memos['all_memos'].find { |m| m['id'] == params[:id] }
    @memo = {
      title: memo['title'],
      content: memo['content']
    }
  end

  def connect_db
    PG.connect( dbname: 'memo_app' )
  end
end
