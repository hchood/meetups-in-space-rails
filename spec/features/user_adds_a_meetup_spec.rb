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
    visit root_path
    click_on "Add a Meetup"

    fill_in "Name", with: "Ice Skating"
    fill_in "Location", with: "Space Frog Pond."
    fill_in "Description", with: "Magnetic ice skating rink simulates gravity."
    click_on "Submit"

    expect(page).to have_content "Success! Your meetup has been created."
    expect(page).to have_content "Ice Skating"
    expect(page).to have_content "Space Frog Pond."
    expect(page).to have_content "Magnetic ice skating rink simulates gravity."
  end

  scenario "without required attributes"

  scenario "unauthenticated user cannot add meetup"
end
