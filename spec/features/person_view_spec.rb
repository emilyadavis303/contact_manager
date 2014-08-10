require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the person view', type: :feature do
	let(:person) { Person.create(first_name: 'Human', last_name: 'Being') }

	describe 'in relation to phone numbers' do 

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
			expect(page).to 				have_content('555-2222')
		end

		it 'has links to edit phone numbers' do 
			person.phone_numbers.each do |phone|
				expect(page).to have_link('Edit', href: edit_phone_number_path(phone))
			end
		end

		it 'edits a phone number' do 
			phone 		 = person.phone_numbers.first
			old_number = phone.number

			first(:link, 'Edit').click
			page.fill_in('Number', with: '555-4545')
			page.click_button('Update Phone number')
			
			expect(current_path).to eq(person_path(person))
			expect(page).to 				have_content('555-4545')
			expect(page).to_not 		have_content(old_number)
		end

		it 'has links to delete phone numbers' do 
			person.phone_numbers.each do |phone|
				expect(page).to have_link('Delete', href: phone_number_path(phone))
			end
		end

		it 'deletes a phone number' do 
			phone = person.phone_numbers.first

			first(:link, 'Delete').click

			expect(current_path).to eq(person_path(person))
			expect(page).to_not 		have_content(phone)
		end
	end

	describe 'in relation to email addresses' do
		
		before(:each) do
			person.email_addresses.create(address: 'being@example.com')
			person.email_addresses.create(address: 'human_be@example.com')
			visit person_path(person)
		end

		it 'shows the email addresses' do
			person.email_addresses.each do |email_address|
				expect(page).to have_selector('li', text: email_address.address)
			end
		end

		it 'has a link to add new email address' do
			expect(page).to have_link('Add email address', href: new_email_address_path(person_id: person.id))
		end
		
		it 'adds a new email address' do
			page.click_link('Add email address')
			page.fill_in('Address', with: 'tweaked_example@example.com')
			page.click_button('Create Email address')

			expect(current_path).to eq(person_path(person))
			expect(page).to 				have_content('tweaked_example@example.com')
		end
	end

end