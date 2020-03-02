class UsersController < ApplicationController
  def create
    user = WidgetService.new.create_user(user_params)
    signin(user)
    redirect_to root_path
  end

  def widgets
    @widgets = WidgetService.new.list(current_user)
  end

  def create_widget
    WidgetService.new.create_widget(current_user, widget_params)
    redirect_to widgets_users_path
  end

  def edit_widget
    @widget = WidgetService.new.get_widget(current_user, params[:id])
  end

  def update_widget
    WidgetService.new.update_widget(current_user, widget_params)
    redirect_to widgets_users_path
  end

  def show
    @user = WidgetService.new.get_user_by_id(current_user, params[:id])
  end

  def show_widget
    @widget = WidgetService.new.get_widget(current_user, params[:id])
  end

  def search_widgets
    @widgets = WidgetService.new.get_widgets_by_term(params[:term])
    render 'home/index'
  end

  def update
    WidgetService.new.update_user(current_user, user_params)
    redirect_to user_path(id: current_user.remote_id)
  end

  def reset_password
    WidgetService.new.reset_password(user_params[:email])
  end

  def login
    @user = WidgetService.new.login_user(user_params)
    signin(@user)
    redirect_to root_path
  end

  def logout
    signout if WidgetService.new.logout_user(current_user)
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit!
  end

  def widget_params
    params.require(:widget).permit!
  end
end
