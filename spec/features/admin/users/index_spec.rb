# frozen_string_literal: true

require 'rails_helper'

describe 'Index admin' do
  let!(:users) { create_list :user, 5 }

  it 'should index admin' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Администрирование'
    click_on 'Пользователи'

    users.each do |user|
      expect(page).to have_content user.email
    end
  end
end
