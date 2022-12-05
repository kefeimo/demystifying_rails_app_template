class ApplicationController < ActionController::Base
  def hello_world
    # render inline: '<em>Hello, World!</em>'
    # render "application/hello_world"
    # render inline: File.read("app/views/application/hello_world.html.erb")

    name = params["name"] || "world"
    p "p name #{name}"
    p name
    # name = "keessdfd"
    render "application/hello_world", locals: { name: name}


  end
end
