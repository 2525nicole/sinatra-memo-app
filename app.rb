# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'sinatra/content_for'
require 'pg'

CONNECTION = PG.connect(dbname: 'memo_app')

get '/memos' do
  @memos = CONNECTION.exec('SELECT * FROM memos ORDER BY created_at DESC')
  erb :memos
end

post '/memos' do
  CONNECTION.exec(
    'INSERT INTO memos (memo_title, memo_content) VALUES ($1, $2)',
    [params[:title], params[:content]]
  )
  redirect '/memos'
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  memo = identify_the_memo(CONNECTION)
  make_memo_variable(memo)
  erb :memo_content
end

delete '/memos/:id' do
  CONNECTION.exec(
    "DELETE FROM memos WHERE memo_id = '#{params[:id]}'"
  )
  redirect '/deletion_completed_message'
end

get '/deletion_completed_message' do
  erb :deletion_completed_message
end

patch '/memos/:id' do
  CONNECTION.exec(
    "UPDATE memos
      SET memo_title = $1,
      memo_content = $2
      WHERE memo_id = $3",
    [params[:title], params[:content], params[:id]]
  )
  redirect "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  memo = identify_the_memo(CONNECTION)
  make_memo_variable(memo)
  erb :memo_editing
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def identify_the_memo(connection)
    connection.exec(
      "SELECT memo_id, memo_title, memo_content
        FROM memos
        WHERE memo_id = '#{params[:id]}';"
    )
  end

  def make_memo_variable(memo)
    @memo = {
      id: memo[0]['memo_id'],
      title: memo[0]['memo_title'],
      content: memo[0]['memo_content']
    }
  end
end
