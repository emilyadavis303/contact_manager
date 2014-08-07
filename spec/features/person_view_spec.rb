require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the person view', type: :feature do 
	let(:person) { Person.create(first_name: 'Human', last_name: 'Being') }

	before(:each) do
		person.phone_numbers.create(number: '123-4567')
		person.phone_numbers.create(number: '987-6543')
		visit person_path(person)
	end

	it 'shows the phone numbers' do
		person.phone_numbers.each do |phone|
			expect(page).to have_content(phone.number)
		end
	end

	it 'has a link to add new phone number' do
		expect(page).to have_link('Add phone number', href: new_phone_number_path(person_id: person.id))
	end

	it 'adds a new phone number' do
		page.click_link('Add phone number')
		page.fill_in('Number', with: '555-2222')
		page.click_button('Create Phone number')

		expect(current_path).to eq(person_path(person))
		expect(page).to have_content('555-2222')
	end
end