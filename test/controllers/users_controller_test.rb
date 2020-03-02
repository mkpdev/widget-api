require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: {
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email(name: 'john-adam'),
          date_of_birth: '2020-03-03',
          image_url: 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
          password: '123456789'
        }
      }
    end
  end

  test 'should login user' do
    post login_users_url, params: {
      user: {
        username: users(:first).email,
        password: '123456789'
      }
    }
    assert_redirected_to root_url
  end

  test 'should logout user' do
    sign_in_as(users(:first))
    post logout_users_url
    assert_redirected_to root_url
  end

  test 'should show user' do
    sign_in_as(users(:first))
    get user_url(users(:first).remote_id)
    assert_response :success
  end

  test 'should update user' do
    sign_in_as(users(:first))
    patch user_url(users(:first).id), params: {
      user: {
        first_name: 'Dwayne',
        last_name: 'smith'
      }
    }
    assert_redirected_to user_url(id: users(:first).remote_id)
  end

  test 'should reset password' do
    sign_in_as(users(:first))
    post reset_password_users_path, params: { user: { email: users(:first).email } }, xhr: true
    assert_response :success
  end

  test 'should get users widgets' do
    sign_in_as(users(:first))
    get widgets_users_path
    assert_response :success
  end

  test 'should create users widgets' do
    user = users(:first)
    sign_in_as(user)
    user.reload
    post create_widget_users_path, params: { widget: { name: Faker::Name.name, description: Faker::Lorem.paragraph, public: 'on' } }
    assert_redirected_to widgets_users_url
  end

  test 'should show widget' do
    user = users(:first)
    sign_in_as(user)
    get show_widget_users_path, params: { id: 1268 }
    assert_response :success
  end

  test 'should edit widget' do
    user = users(:first)
    sign_in_as(user)
    get edit_widget_users_path, params: { id: 1268 }, xhr: :true
    assert_response :success
  end

  test 'should update widget' do
    user = users(:first)
    sign_in_as(user)
    post update_widget_users_path, params: { widget: { name: Faker::Name.name, description: Faker::Lorem.paragraph, public: 'on', id: 1268 } }
    assert_redirected_to widgets_users_url
  end

  test 'should search widgets' do
    user = users(:first)
    sign_in_as(user)
    get search_widgets_users_path, params: { term: 'ajax' }
    assert_response :success
  end
end
