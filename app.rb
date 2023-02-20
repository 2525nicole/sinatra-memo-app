# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require "sinatra/content_for"

get '/memos' do
  memo_details_list = convert_memos_to_hash
  @memos = 
  memo_details_list['all_memos'].map do |memo_details|
    { title: memo_details['title'], id: memo_details['id'] }
  end
  erb :memos
end

post '/memos/new' do
  memo_details_list = convert_memos_to_hash
  memo_details_list['all_memos'] << { 'id' => SecureRandom.uuid, 'title' => params[:title], 'content' => params[:content] }
  write_to_memos_list(memo_details_list)
  redirect '/memos'
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  memo_details_list = convert_memos_to_hash
  make_memo_variable(memo_details_list)
  @memo_id = params[:id]
  erb :memo_content
end

delete '/memos/:id' do
  memo_details_list = convert_memos_to_hash
  after_delete_memo = memo_details_list.each { |_key, val| val.delete_if { |memo_details| memo_details['id'] == params[:id] } }
  write_to_memos_list(after_delete_memo)
  redirect '/deletion_completed_message'
end

get '/deletion_completed_message' do
  erb :deletion_completed_message
end

patch '/memos/:id/edit' do
  memo_details_list = convert_memos_to_hash
  memo_details_list['all_memos'].each do |memo_details|
    @edit_memo = memo_details if memo_details['id'] == params[:id]
  end
  @edit_memo['title'] = params[:title]
  @edit_memo['content'] = params[:content]
  write_to_memos_list(memo_details_list)
  redirect "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  memo_details_list = convert_memos_to_hash
  make_memo_variable(memo_details_list)
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
    memos['all_memos'].each do |memo_details|
      if memo_details['id'] == params[:id]
        @title = memo_details['title']
        @content = memo_details['content']
      end
    end
  end
end
