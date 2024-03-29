# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'sinatra/content_for'
require 'pg'

CONNECTION = PG.connect(dbname: 'memo_app')

get '/memos' do
  memos = CONNECTION.exec('SELECT * FROM memos ORDER BY created_at DESC')
  @memos = memos.map do |memo|
    memo.transform_keys(&:to_sym)
  end
  erb :memos
end

post '/memos' do
  CONNECTION.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect '/memos'
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  @memo = retrieve_one_memo
  erb :memo_content
end

delete '/memos/:id' do
  CONNECTION.exec('DELETE FROM memos WHERE id = $1', [params[:id]])
  redirect '/deletion_completed_message'
end

get '/deletion_completed_message' do
  erb :deletion_completed_message
end

patch '/memos/:id' do
  CONNECTION.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], params[:id]])
  redirect "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  @memo = retrieve_one_memo
  erb :memo_editing
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def retrieve_one_memo
    memo = CONNECTION.exec('SELECT id, title, content FROM memos WHERE id = $1', [params[:id]])
    memo[0].transform_keys(&:to_sym)
  end
end
