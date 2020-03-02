require 'test_helper'

class WidgetServiceTest < ActiveSupport::TestCase

  setup do
    @service = WidgetService.new
    @user = users(:first)
  end

  def login_user
    params = { username: @user.email, password: '123456789' }
    @service.login_user(params)
    @user = @user.reload
  end

  def get_user
    login_user
    @service.get_user_by_token(@user.access_token)
  end

  test 'should create user' do
    user = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email(name: 'john-adam'),
      date_of_birth: '2020-03-03',
      image_url: 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
      password: '123456789'
    }
    assert_difference('User.count') do
      @service.create_user(user)
    end
  end

  test 'should update user' do
    login_user
    user = {
      first_name: 'Johnathan'
    }
    @service.update_user(@user, user)
    assert_equal get_user['first_name'], 'Johnathan'
  end

  test "should login user" do
    params = { username: @user.email, password: '123456789' }
    @service.login_user(params)
    assert_not_nil @user.reload.access_token
  end

  test "should logout user" do
    login_user
    @service.logout_user(@user)
    assert_nil @user.reload.access_token
  end

  test 'should reset password' do
    login_user
    resp = @service.reset_password(@user.email)
    assert resp.code == 200
  end

  test 'should return widgets' do
    login_user
    widget = @service.list.first
    assert widget.keys.include?('id')
    assert widget.keys.include?('name')
    assert widget.keys.include?('description')
    assert widget.keys.include?('kind')
    assert widget.keys.include?('user')
    assert widget.keys.include?('owner')
  end
  
  test 'should return user by id' do
    login_user
    user = @service.get_user_by_id(@user, 1)
    assert_not_nil user
  end

  # test 'should create widget' do
  #   login_user
  #   user_widgets = @service.list(@user).count
  #   params = { name: Faker::Name.name, description: Faker::Lorem.paragraph, public: 'on' }
  #   @service.create_widget(@user, params)
  #   assert (user_widgets + 1) == @service.list(@user).count
  # end

  test 'should update widget' do
    login_user
    widget = @service.list(@user).first
    description = Faker::Lorem.paragraph
    params = { id: widget['id'], name: widget['name'], description: description, public: 'off' }
    @service.update_widget(@user, params)
    assert @service.list(@user).first['description'] == description
  end

  test 'should get widget' do
    login_user
    widget = @service.list(@user).first
    assert widget['name'] == @service.get_widget(@user, widget['id'])['name']
  end

  # test 'should get widgets by term' do
  #   login_user
  #   widgets = @service.get_widgets_by_term('')
  #   assert widgets.count == @service.list.count
  # end
end
