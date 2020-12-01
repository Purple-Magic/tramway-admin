# frozen_string_literal: true

require 'rails_helper'

describe 'Update user' do
  let!(:attributes) { attributes_for :user_admin_attributes }
  before { create :user }

  it 'should update admin' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    user = User.last
    click_on_dropdown 'Администрирование'
    click_on 'Пользователи'
    click_on user.id
    find('.btn.btn-warning', match: :first).click
    fill_in 'record[email]', with: attributes[:email]
    fill_in 'record[password]', with: attributes[:password]
    fill_in 'record[first_name]', with: attributes[:first_name]
    fill_in 'record[last_name]', with: attributes[:last_name]

    click_on 'Сохранить', class: 'btn-success'
    user.reload
    attributes.keys.each do |attr|
      next if attr == :password

      actual = user.send(attr)
      expecting = attributes[attr]
      case actual.class.to_s
      when 'NilClass'
        expect(actual).not_to be_empty, "#{attr} is empty"
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end
