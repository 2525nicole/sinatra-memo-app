# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'sinatra/content_for'
require 'pg'

connect =  PG.connect( dbname: 'memo_app' )

get '/memos' do
  memos = connect.exec("SELECT * FROM Memos")
  @memos =
    memos.map do |memo|
      { title: memo['memo_title'], id: memo['memo_id'] }
    end
  erb :memos
end

post '/memos/new' do
  connect.exec("INSERT INTO Memos VALUES ('#{SecureRandom.uuid}', '#{params[:title]}', '#{params[:content]}');")
  redirect '/memos'
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  make_memo_variable
  erb :memo_content
end

delete '/memos/:id' do
  connect.exec("DELETE FROM Memos WHERE memo_id = '#{params[:id]}'")
  redirect '/deletion_completed_message'
end

get '/deletion_completed_message' do
  erb :deletion_completed_message
end

patch '/memos/:id/edit' do
  connect.exec(
    "UPDATE Memos
      SET memo_title = '#{params[:title]}',
      memo_content = '#{params[:content]}'
      WHERE memo_id = '#{params[:id]}'"
      )
  redirect "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  make_memo_variable
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

  def make_memo_variable
    connect = connect_db
    memo = connect.exec(
      "SELECT memo_id, memo_title, memo_content
        FROM Memos
        WHERE memo_id = '#{params[:id]}';"
        )
    @memo = {
      id: memo[0]['memo_id'],
      title: memo[0]['memo_title'],
      content: memo[0]['memo_content']
    }
  end
end
