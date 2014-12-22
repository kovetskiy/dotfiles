#!/usr/bin/ruby
# encoding: utf-8

require 'net/http'
require 'json'
require 'uri'
require File.expand_path('~/.config/jira.rb')
# configuration example:
# $host = jira.rn
# $user = e.kovetskiy
# $password = stupidpassword


uri = URI('http://' + $host + '/rest/api/2/search')
req = Net::HTTP::Post.new(
    uri.path,
    initheader = {'Content-Type' => 'application/json'}
)
req.basic_auth $user, $password
req.body = {:jql => 'assignee = currentUser() AND status = "В процессе"'}.to_json

res = Net::HTTP.start(uri.host, uri.port) do |http|
  http.request req
end

json = JSON.parse res.body
issues = json['issues']
currentIssue = issues[0]['key']
url = 'http://' + $host + '/browse/' + currentIssue

system('x-www-browser', url)
