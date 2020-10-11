# frozen_string_literal: true

require 'rails_helper'

describe 'Index new participants' do
  let!(:participants) { create_list :participant, 5, participation_state: :requested }

  it 'should show collection of new participants' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    expect(find('ul.navbar-nav li.nav-item.notifications a.nav-link span.badge')).to have_content 5
  end
end
