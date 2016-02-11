class PagesController < ApplicationController
  def home
    @greeting = Time.now.to_i
#    @greeting = "Home action says: Hello world!"
#    puts "Honey, I'm home!"
  end
end
