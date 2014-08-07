require 'rails_helper'

RSpec.describe Person, :type => :model do
  it 'is valid' do
  	person = Person.new(first_name: 'Human', last_name: 'Being')
  	expect(person).to be_valid
  end

  it 'is invalid without a first name' do
  	person = Person.new(first_name: nil, last_name: 'Being')
  	expect(person).not_to be_valid
	end

	it 'is invalid without a last name' do
		person = Person.new(first_name: 'Human', last_name: nil)
	end
end
