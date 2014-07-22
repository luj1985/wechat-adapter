require_relative 'spec_helper'

describe Wechat::Adapter do
  access_token = "jDBx_Q_ClVPDCxgcqdzVdf4GqiWlW3xhxphm2VIszvpsPKVZextLULiZKWX5OMAozhW6kxvBB7Z7DKiv5qRF6A"
  appid = "wxb3fae34df644fbf7"
  appsecret = "d0aae6a89949c8c789068397f9e1c59c"
  base_url = "https://api.weixin.qq.com/cgi-bin"
  wechat_menu = {
    :button => [
      { :type => "click", :name => "今日歌曲", :key  => "V1001_TODAY_MUSIC", :sub_button => [] }, 
      { :type => "click", :name => "歌手简介", :key  => "V1001_TODAY_SINGER", :sub_button => [] }, 
      { :name => "菜单", :sub_button => [
        { :type => "view", :name => "搜索",  :url => "http://www.soso.com/", :sub_button => [] }, 
        { :type => "view", :name => "视频",  :url => "http://v.qq.com/", :sub_button => [] }, 
        { :type => "click", :name => "赞一下我们", :key => "V1001_GOOD", :sub_button => []
      }]
    }]
  }

  let (:app) { Wechat::Adapter::WechatAPI.new(appid, appsecret, base_url)}
  
  it "should be able to get access token" do

    access_token_response = double
    allow(access_token_response).to receive(:body).and_return({ :access_token => access_token, :expires_in => 7200}.to_json)
    allow(RestClient::Request).to receive(:execute) { access_token_response }
    expect(app.aquire_access_token).to eq(access_token)
  end

  it "should be able to get menu token" do
    access_token_response = double
    allow(access_token_response).to receive(:body).and_return({:access_token => access_token, :expires_in => 7200}.to_json)
    
    menu_get_response = double
    allow(menu_get_response).to receive(:body).and_return({:menu => wechat_menu}.to_json)

    access_token_retrieve_method = double
    expect(access_token_retrieve_method).to receive(:invoke).once

    menu_retrieve_method = double
    expect(menu_retrieve_method).to receive(:invoke).exactly(10).times

    allow(RestClient::Request).to receive(:execute) do |args|
      case args[:url]
      when "https://api.weixin.qq.com/cgi-bin/token" then
        expect(args[:method]).to eq(:get)
        params = args[:headers][:params]
        expect(params[:grant_type]).to eq("client_credential")
        expect(params[:appid]).to eq(appid)
        expect(params[:secret]).to eq(appsecret)
        access_token_retrieve_method.send(:invoke)
        access_token_response
      when "https://api.weixin.qq.com/cgi-bin/menu/get" then
        expect(args[:method]).to eq(:get)
        params = args[:headers][:params]
        expect(params[:access_token]).to eq(access_token)
        menu_retrieve_method.send(:invoke)
        menu_get_response
      else fail
      end
    end

    10.times {
      app.get 'menu/get'
    }
  end

  it "should be able to delete menu" do
    access_token_response = double
    allow(access_token_response).to receive(:body).and_return({:access_token => access_token, :expires_in => 7200}.to_json)
    
    menu_delete_response = double
    allow(menu_delete_response).to receive(:body).and_return({:errcode => 0, :errmsg => "ok"}.to_json)

    allow(RestClient::Request).to receive(:execute) do |args|
      case args[:url]
      when "https://api.weixin.qq.com/cgi-bin/token" then access_token_response
      when "https://api.weixin.qq.com/cgi-bin/menu/delete" then
        expect(args[:method]).to eq(:get)
        params = args[:headers][:params]
        expect(params[:access_token]).to eq(access_token)
        menu_delete_response
      else fail
      end
    end
    app.get 'menu/delete'
  end

  it "should be able to create menu" do
    access_token_response = double
    allow(access_token_response).to receive(:body).and_return({:access_token => access_token, :expires_in => 7200}.to_json)
    
    menu_create_response = double
    allow(menu_create_response).to receive(:body).and_return({:errcode => 0, :errmsg => "ok"}.to_json)

    allow(RestClient::Request).to receive(:execute) do |args|
      case args[:url]
      when "https://api.weixin.qq.com/cgi-bin/token" then access_token_response
      when "https://api.weixin.qq.com/cgi-bin/menu/create" then
        expect(args[:method]).to eq(:post)
        params = args[:headers][:params]
        expect(params[:access_token]).to eq(access_token)
        expect(args[:payload]).to eq(wechat_menu.to_json)
        menu_create_response
      else fail
      end
    end
    app.post 'menu/create', {}, wechat_menu
  end
end