class SayController < ApplicationController
  def hello
     @greeting = "Hello, how you doing!"
  end

  def goodbye
     @greeting = "Goodbye, nice meeting you!"
  end
end
