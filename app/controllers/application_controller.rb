class ApplicationController < ActionController::Base
  def hello_world
    # render inline: '<em>Hello, World!</em>'
    # render "application/hello_world"
    render inline: File.read("app/views/application/hello_world.html")

    # binding.pry
    # ### inside Pry ###
    # response.body         # => "<em>Hello, World!</em>"
    # response.content_type # => "text/html"
    # response.status       # => 200

  end
end
