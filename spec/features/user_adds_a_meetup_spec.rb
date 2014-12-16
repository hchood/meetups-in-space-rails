require 'rails_helper'

feature "adds a meetup", %q{
  As a user
  I want to create a meetup
  So that I can gather a group of people to discuss a given topic

  Acceptance Criteria:

  - [ ] I must supply a name.
  - [ ] I must supply a location.
  - [ ] I must supply a description.
  - [ ] I should be brought to the details page for the meetup after I create it.
  - [ ] I should see a message that lets me know that I have created a meetup successfully.
  - [ ] I must be signed in.
} do

  scenario "with valid attributes" do
    meetup = FactoryGirl.build(:meetup)

    visit root_path
    click_on "Add a Meetup"

    fill_in "Name", with: meetup.name
    fill_in "Location", with: meetup.location
    fill_in "Description", with: meetup.description
    click_on "Submit"

    expect(page).to have_content "Success! Your meetup has been created."
    expect(page).to have_content meetup.name
    expect(page).to have_content meetup.location
    expect(page).to have_content meetup.description
  end

  scenario "without required attributes"

  scenario "unauthenticated user cannot add meetup"
end
