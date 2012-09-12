module SessionsSupport
  Operator.create!({ email: "admin@example.com",
                     password: "password"})

  def login
    visit new_session_path

    fill_in 'email', with: 'admin@example.com'
    fill_in 'password', with: 'password'
    # TODO: look for input submit instead of text.
    click_button 'Log in'
  end

  def logout
  end
end