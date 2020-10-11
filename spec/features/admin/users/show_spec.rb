# frozen_string_literal: true

require 'rails_helper'

describe 'Show user' do
  before { create :user }

  it 'should show admin' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_user = create :user
    click_on_dropdown 'Администрирование'
    click_on 'Пользователи'
    click_on last_user.id

    expect(page).to have_content last_user.email
  end
end
