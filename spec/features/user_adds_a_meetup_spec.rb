require 'rails_helper'

feature "adds a meetup", %q{
  As a user
  I want to create a meetup
  So that I can gather a group of people to discuss a given topic

  Acceptance Criteria:

  - [X] I must supply a name.
  - [X] I must supply a location.
  - [X] I must supply a description.
  - [X] Name must be unique or I receive an error message.
  - [X] I should be brought to the details page for the meetup after I create it.
  - [X] I should see a message that lets me know that I have created a meetup successfully.
  - [X] I must be signed in.
} do

  context "authenticated user" do
    before :each do
      @user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      within ".new_user" do
        click_on "Sign in"
      end
    end

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

    scenario "without required attributes" do
      visit new_meetup_path
      click_on "Submit"

      expect(page).to have_content "ERRAH"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Location can't be blank"
      expect(page).to have_content "Description can't be blank"
    end

    scenario "meetup name already in use" do
      existing_meetup = FactoryGirl.create(:meetup)

      visit new_meetup_path
      fill_in "Name", with: existing_meetup.name
      fill_in "Location", with: existing_meetup.location
      fill_in "Description", with: existing_meetup.description
      click_on "Submit"

      expect(page).to have_content "ERRAH"
      expect(page).to have_content "Name has already been taken"

      name = find_field("Name").value
      expect(name).to eq existing_meetup.name
    end
  end

  context "unauthenticated user" do
    scenario "cannot add meetup" do
      visit new_meetup_path
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end
