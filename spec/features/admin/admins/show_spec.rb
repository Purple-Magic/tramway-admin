# frozen_string_literal: true

require 'rails_helper'

describe 'Show admin' do
  before { create :admin }

  it 'should show admin' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_admin = create :admin
    click_on_dropdown 'Администрирование'
    click_on 'Администраторы'
    click_on last_admin.id

    expect(page).to have_content last_admin.email
    expect(page).to have_content last_admin.phone
  end

  context 'events' do
    it 'should show admin events' do
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_admin = create :admin
      event = create :event_created_by_admin
      click_on_dropdown 'Администрирование'
      click_on 'Администраторы'
      click_on last_admin.id

      expect(page).to have_content event.title
    end

    it 'should show partner events' do
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_partner = create :partner
      event = create :event_created_by_partner
      click_on_dropdown 'Администрирование'
      click_on 'Администраторы'
      click_on last_partner.id

      expect(page).to have_content event.title
    end
  end
end
