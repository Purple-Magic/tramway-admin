# frozen_string_literal: true

# WILL BE FIXED IN https://trello.com/c/LzQ9tuTa/76-%D0%B8%D1%81%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D1%82%D1%8C-%D1%82%D0%B5%D1%81%D1%82%D1%8B-%D0%BD%D0%B0-notifications

require 'rails_helper'

describe 'Index new participants' do
  let!(:participants) { create_list :participant, 5, participation_state: :requested }

  before do
    create_list :participant, 6, participation_state: :prev_approved
  end

  it 'should show collection of new participants' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    find('ul.navbar-nav li.nav-item.dropdown a', text: 5, visible: true).click.click

    participants.each do |participant|
      expect(page).to have_content(Tramway::Event::ParticipantDecorator.decorate(participant).title, exact: false)
    end
  end
end
