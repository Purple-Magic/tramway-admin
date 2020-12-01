# frozen_string_literal: true

require 'rails_helper'

describe 'Destroy admin' do
  before { create :user }

  it 'should destroy admin' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    user = User.last
    click_on_dropdown 'Администрирование'
    click_on 'Пользователи'
    click_on_delete_button user
    user.reload

    expect(user.removed?).to be_truthy
  end
end
