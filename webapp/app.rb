#!/usr/bin/env ruby

require "sinatra"
require "sinatra/cookies"
require "mysql2"

configure do
  enable :inline_templates
end

helpers do
  include ERB::Util
end

set :environment, :production
$mysqlclient = Mysql2::Client.new(:host => "127.0.0.1", reconnect: true, :username => "notroot", :password => "bBbzmqQ48mm1", :database => "somedb")

$mysqlclient.query("CREATE TABLE IF NOT EXISTS `info` (
  `id` INTEGER,
  `text` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

$mysqlclient.query("REPLACE INTO `info` (`id`,`text`) VALUES
  (1, 'Ad pri duis ignota mucius. Pro cibo intellegat at, an sea homero feugiat oportere. Te aliquam corrumpit dissentiet has.'),
  (2, 'Habeo prima inermis et nec, nam ad incorrupte efficiantur. Solet liberavisse an vel. Ut ludus ubique denique has, verterem hendrerit assueverit est at.');")

$mysqlclient.query("CREATE TABLE IF NOT EXISTS `flag` (
  `value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

$mysqlclient.query("REPLACE INTO `flag` (`value`) VALUES ('" + File.read("flag.txt") + "');")

get "/" do
  @title = "Melbourne Shuffle"

  @rows = $mysqlclient.query("SELECT * FROM `info`")
  erb :index
end

get "/fact" do
  redirect to("/") unless params[:id]

  id = params[:id].to_s
  id = id.chars.shuffle(random: Random.new(id.size)).join

  result = $mysqlclient.query("SELECT * FROM `info` WHERE id=#{id}")
  @row = result.first

  @title = "Melbourne Shuffle Fact"
  erb :fact
end


__END__

@@ layout
<!doctype html>
<html>
 <head>
   <style>
    html, body {
        height: 100%;
        background-color: black;
        height: 100%;
        margin: 0px;
        padding: 0px;
        color: white;
        font-family: courier, monospace;
        text-align: center;
    }
    h1 {
        margin-top: 5%;
    }
    a {
        color: green;
    }
    input {
        padding: 10px;
    }
  </style>
  <title><%= h @title %></title>
 </head>
 <body>
  <div class="box">
  <h1><%= h @title %></h1>
  <%= yield %></p>
  </div>
 </body>
</html>

@@ index
<% @rows.each do |row| %>
 <a href="/fact?id=<%= row["id"] %>">Interesting Fact #<%= row["id"] %></a><br />
<% end %>

@@ fact
<% if @row %>
 <%= @row["text"] %>
<% else %>
 Error!
<% end %>
