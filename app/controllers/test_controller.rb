class TestController < ApplicationController
 
  def get
    require 'rest_client'

    api_url = Rails.application.secrets.api_url
    auth = Rails.application.secrets.auth
    response = RestClient.get(api_url, {'authorization' => auth});

    @crawl = { :crawl_names => [], :crawl_values => [] }
    @string = JSON.parse(response.body).take(10).each do |string|
      @crawl[:crawl_names] << string[0]
      @crawl[:crawl_values] << string[1]
    end
    @crawl_full = @crawl[:crawl_names].zip(@crawl[:crawl_values])

    @h = { :names => [], :values => [] }
    @string = JSON.parse(response.body)["results"]["stats"].take(21).each do |string|
      @h[:names] << string['name']
      @h[:values] << string['value']['text']
    end
    @c = @h[:names].zip(@h[:values])

  end

  def gmail
    require 'google/api_client'
      client = Google::APIClient.new
      client.authorization.access_token = Token.last.fresh_token
      service = client.discovered_api('gmail')
      result = client.execute(
        :api_method => service.users.messages.list,
        :parameters => {'userId' => 'me', 'q' => 'orders@clips4sale.com'},
        :headers => {'Content-Type' => 'application/json'})
        
        @h = { :id => [] }
        JSON.parse(result.body)["messages"].take(10).each do |string|
          @h[:id] << string['id']
        end
      render :text => @h
  end

  def email
    require 'base64url'
    require 'google/api_client'
      client = Google::APIClient.new
      client.authorization.access_token = Token.last.fresh_token
      service = client.discovered_api('gmail')
      result = client.execute(
        :api_method => service.users.messages.get,
        :parameters => {'userId' => 'me', 'id' => params[:id], 'format' => 'full'},
        :headers => {'Content-Type' => 'application/json'})
#        render :text => Base64URL.decode(JSON.parse(result.body)["raw"])
        @snippet = JSON.parse(result.body)["snippet"]
        @subject = JSON.parse(result.body)["payload"]["headers"][8]["value"]
        @from = JSON.parse(result.body)["payload"]["headers"][12]["value"]
        d = Date.parse JSON.parse(result.body)["payload"]["headers"][14]["value"]
        @date = d.strftime('%m/%d/%y') 
  end
end