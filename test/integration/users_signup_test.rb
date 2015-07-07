require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                                email: "goo@gb",
                                password: '12345',
                                password_confirmation: '2145' }
    end
    assert_template 'users/new'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "teste",
                                            email: "goo@gb.com",
                                            password: '123455',
                                            password_confirmation: '123455' }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
