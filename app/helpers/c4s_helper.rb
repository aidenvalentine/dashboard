module C4sHelper
    def import
    require "importio.rb"
    require "json" 

    # To use an API key for authentication, use the following code:
    client = Importio::new("9d6d4341-9112-4f0a-a92e-62340a0558a5","aGNTXaUkKafQC36umlmbxFdN8YdR2FO7w7wzfmjx4/tYDa8LB3i+x64lAB9bBtjYfYLKRv/z055mOATdXo8Btg==", "https://query.import.io")

    # Once we have started the client and authenticated, we need to connect it to the server:
    client.connect

    # Define here a global variable that we can put all our results in to when they come back from
    # the server, so we can use the data later on in the script
    data_rows = []

    # In order to receive the data from the queries we issue, we need to define a callback method
    # This method will receive each message that comes back from the queries, and we can take that
    # data and store it for use in our app
    callback = lambda do |query, message|
      # Disconnect messages happen if we disconnect the client library while a query is in progress
      if message["type"] == "DISCONNECT"
        puts "The query was cancelled as the client was disconnected"
      end
      if message["type"] == "MESSAGE"
        if message["data"].key?("errorType")
          # In this case, we received a message, but it was an error from the external service
          puts "Got an error!"
          puts JSON.pretty_generate(message["data"])
        else
          # We got a message and it was not an error, so we can process the data
          puts "Got data!"
          puts JSON.pretty_generate(message["data"])
          # Save the data we got in our dataRows variable for later
          data_rows << message["data"]["results"]
        end
      end
      if query.finished
        puts "Query finished"
      end
    end

    # Issue queries to your data sources with your specified inputs
    # You can modify the inputs and connectorGuids so as to query your own sources
    # Query for tile C4S
    client.query({"input"=>{"webpage/url"=>"https://storeadmin.zapya.com/members/index.php"}, "additionalInput"=>{"6c214dc8-4fdc-4f8f-a1e6-80b216a1d5ea"=>{"cookies"=>["To find out how to get cookies to go here, visit our docs:","http://go.import.io/auth-conn-session-docs","The domains for this source are: storeadmin.zapya.com"]}},"connectorGuids"=>["6c214dc8-4fdc-4f8f-a1e6-80b216a1d5ea"]}, callback )

    puts "Queries dispatched, now waiting for results"

    # Now we have issued all of the queries, we can wait for all of the threads to complete meaning the queries are done
    client.join

    puts "Join completed, all results returned"

    # It is best practice to disconnect when you are finished sending queries and getting data - it allows us to
    # clean up resources on the client and the server
    client.disconnect

    # Now we can print out the data we got
    puts "All data received:"
    puts JSON.pretty_generate(data_rows)
    end
end