# frozen_string_literal: true

require 'rails_helper'

describe 'Index new participants' do
  before do
    create_list :participant, 6, participation_state: :prev_approved
  end

  it 'should show collection of new participants' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    find('ul.navbar-nav li.nav-item.notifications').click

    expect(page).not_to have_css '.dropdown-menu'
  end
end
