require 'httparty'
require 'json'

$stdout.sync = true

class Toxme

  @@API_URL = 'https://toxme.io/api'

  @@ACTIONS_MAP = {
    'id' => 3,
    'name' => 5
  }

  def self.request(action, args)
    req_body = {'action' => @@ACTIONS_MAP[action]}.update(args).to_json
    res = HTTParty.post(@@API_URL,
      :body => req_body,
      :headers => { 'Content-Type' => 'application/json' }
    )
    JSON.parse(res.body)
  end

  def self.id(name)
    res = request('id', {'name' => name})
    case res['c'].to_i
    when 0
      return res['tox_id']
    when -42
      return 'Sorry, this name is not found in ToxMe database.'
    else
      return 'Sorry, unknown error occured.'
    end
  end

  def self.name(id, json = false)
    res = request('name', {'id' => id})
    json ? res : res[]
  end
end
