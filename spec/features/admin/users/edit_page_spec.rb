# frozen_string_literal: true

require 'rails_helper'

describe 'Edit admin page' do
  before { create :user }

  it 'should show edit admin page' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_user = User.last
    click_on_dropdown 'Администрирование'
    click_on 'Пользователи'
    click_on last_user.id
    find('.btn.btn-warning', match: :first).click

    expect(page).to have_field 'record[email]', with: last_user.email
    expect(page).to have_field 'record[first_name]', with: last_user.first_name
    expect(page).to have_field 'record[last_name]', with: last_user.last_name
  end
end
