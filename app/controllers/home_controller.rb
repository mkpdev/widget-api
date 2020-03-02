class HomeController < ApplicationController
  def index
    @widgets = WidgetService.new.list
  end
end
