module BitcoindClient
  class Client
    def initialize(user, pass, host, port)
      @endpoint = "http://#{user}:#{pass}@#{host}:#{port}"
    end

    def balance
      request 'getbalance'
    end

    def move(fromaccount, toaccount, amount, minconf=1, comment)

      request 'move', fromaccount, toaccount, amount, minconf.to_i, comment
    end

    def accounts
      balance_hash = request 'listaccounts'
      AccountHash.new self, balance_hash
    end

    def request(method, *args)
      body = { 'id'=>'jsonrpc', 'method'=>method}
      body['params'] = args unless args.empty?
      response_json = RestClient.post @endpoint, body.to_json
      response = JSON.parse response_json
      return response['result']
    end

    def inspect
      "#<BitcoindClient::Client #{@endpoint.inspect} >"
    end
  end
end
