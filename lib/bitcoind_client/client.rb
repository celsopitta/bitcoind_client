module BitcoindClient
  class Client
    def initialize(user, pass, host, port)
      @endpoint = "http://#{user}:#{pass}@#{host}:#{port}"
    end

    def balance
      request 'getbalance'
    end

    def balance_for_account(fromaccount, minconf = 6)
      request 'getbalance', fromaccount, minconf.to_i
    end

    def dump_private_key(addr)
      request 'dumpprivkey', addr
    end

    def address_for_account(fromaccount)

      request 'getaccountaddress', fromaccount
    end

    def  address_by_account(fromaccount)
      request 'getaddressesbyaccount', fromaccount
    end

    def move(fromaccount, toaccount, amount, minconf=1)

      request 'move', fromaccount, toaccount, amount, minconf.to_i
    end

    def send(fromaccount, bitcoinaddress, amount, minconf=1)
      txn_id = request 'sendfrom', fromaccount, bitcoinaddress, amount, minconf.to_i
    end

    def listtransactions(fromaccount, count, from)
      request 'listtransactions', fromaccount, count, from
    end

    def listaccounts
      request 'listaccounts'
    end

    def accounts
      balance_hash = request 'listaccounts'
      AccountHash.new self, balance_hash
    end

    def request(method, *args)

        body = { 'id'=>'jsonrpc', 'method'=>method}
        body['params'] = args unless args.empty?
        #puts body.to_s
        response_json = RestClient.post @endpoint, body.to_json
        response = JSON.parse response_json
        return response['result']

        #if response_json.present?
        #  puts "json response"
        #  pp response_json
        #  response = JSON.parse response_json
        #
        #  if response['result'].present?
        #    return response['result']
        #  else
        #    return response
        #  end
        #
        #end

    end

    def inspect
      "#<BitcoindClient::Client #{@endpoint.inspect} >"
    end
  end
end
