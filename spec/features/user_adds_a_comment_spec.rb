require 'rails_helper'

feature "adds a comment", %q{
  As a user
  I want to leave comments on a meetup
  So that I can communicate with other members of the group

  Acceptance Criteria:

  - [ ] I can optionally provide a title for my comment.
  - [ ] I must provide the body of my comment.
  - [ ] I should see my comment listed on the meetup show page.
  - [ ] Comments should be listed most recent first.
  - [ ] I must be authenticated.
  - [ ] I must have already joined the meetup.

  } do

  scenario "with valid attributes" do
    meetup = FactoryGirl.create(:meetup)
    comment = FactoryGirl.build(:comment)

    visit meetup_path(meetup)
    fill_in "Title", with: comment.title
    fill_in "Body", with: comment.body
    click_on "Post Comment"

    expect(page).to have_content "Thanks for commenting!"
    expect(page).to have_content comment.title
    expect(page).to have_content comment.body
  end

  scenario "missing required attributes"

  scenario "unauthenticated user cannot comment"

  scenario "user cannot comment if not member of meetup"

end
