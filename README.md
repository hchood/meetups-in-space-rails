## Meetups in Space - Rails edition

Clinics:

* Mon. 12/15 - `Add a meetup` branch.
  - Use acceptance testing to test-drive the "add a meetup feature"
* Tues. 12/16 - `factory-girl` branch.
  - Incorporate the `factory_girl_rails` gem to clean up our tests.
  - Complete other tests.

## Using FactoryGirl

### Step 1. Adding FactoryGirl

* Add to Gemfile and bundle

```ruby
group :development, :test do
  # ...
  gem 'factory_girl_rails'
end
```

### Step 2. Create a factory for your model

You can manually create a factory for your model, or it will be created for you if you run `rails generate model <MODELNAME>`:


```no-highlight
$ rails g model user

invoke  active_record
create    db/migrate/20141216151223_create_users.rb
create    app/models/user.rb
invoke    rspec
create      spec/models/user_spec.rb
invoke      factory_girl
create        spec/factories/users.rb
```

The Factory will look something like this to start:

```ruby
# spec/factories/users.rb
FactoryGirl.define do
  factory :user do
    # we need to add attributes here
  end
end
```

We need to add our attributes to our user factory (as well as our migration for creating the users table):

```ruby
# spec/factories/users.rb
FactoryGirl.define do
  factory :user do
    first_name "Gene"
    last_name "Parmesan"
    sequence(:email) { |n| "#{n}geneparm@privateeyes.com"}
    password "superspy"
  end
end
```

#### Unique fields

For unique fields, you need to use a `sequence`.  All of our FactoryGirl-created objects can have the same name, but they can't have the same email.  A sequence allows you to insert a number into your `email` attribute (in this example) to make it unique.

```ruby
FactoryGirl.define do
  factory :user do
    # ...
    sequence(:email) { |n| "#{n}geneparm@privateeyes.com"}
    # ...
  end
end
```

#### Associated objects

OK, we've got a factory for `User`.  Now let's make one for `Meetup`, and let's assume for the purposes of this example that a `Meetup` must `belong_to :user`.

Whenever we create a `Meetup` object, we'll want to make sure to also create an associated user object.

FactoryGirl makes this super simple:

```ruby
# spec/factories/meetups.rb
FactoryGirl.define do
  factory :meetup do
    name "Ice Skating"
    location "Space Frog Pond."
    description "Magnetic ice skating rink simulates gravity."

    association :user
  end
end
```

Now if I call `FactoryGirl.create(:meetup)`, it'll create two objects:  a `Meetup` object and a `User` object.


```ruby
meetup = FactoryGirl.create(:meetup) # creates a meetup and a user
user = meetup.creator # returns the user object that FG created
```

Actually, FG makes this even simpler and we can just do this:

```ruby
# spec/factories/meetups.rb
FactoryGirl.define do
  factory :meetup do
    # ...

    user # omg this is also an association whattttt
  end
end
```

You can also alias factories to give them different names.  So if we wanted a meetup to `belong_to :creator, class_name: "User"`, we could do this:

```ruby
# spec/factories/meetups.rb
FactoryGirl.define do
  factory :meetup do
    # ...

    association :creator, factory: :user
  end
end
```

### Step 3. Use your factories to build objects in your tests.

#### Strategies

FactoryGirl gives you a few methods to build objects using your factories.  Here are the main ones:

* **CREATE**. Create a persisted `User` object (like `User.create`)

  ```ruby
  user = FactoryGirl.create(:user)
  ```

* **BUILD**. Create a `User` object that hasn't yet been persisted to the DB - similar to calling `User.new`:

  ```ruby
  user = FactoryGirl.build(:user)
  ```

* **BUILD_STUBBED**. Sort of pretend to persist an object but don't really.  Useful for speeding up your tests if you find you're creating tons of objects in your tests.  However, for some things you really do need to persist objects to the DB so you'll need `.create` instead. (Check out this [blog post](http://robots.thoughtbot.com/use-factory-girls-build-stubbed-for-a-faster-test).)

  ```ruby
  user = FactoryGirl.build_stubbed(:user)
  ```

* **CREATE_LIST**. Create a list of objects. Great for testing index pages, for example. (There's also a `build_list` method.)

  ```ruby
  meetups = FactoryGirl.create_list(:meetup, 3)
  ```

* **ATTRIBUTES_FOR**.  Doesn't actually create an object, but returns a hash of attributes that we can use for other things.  We might use this to test a "user sign up" feature, for example.

  ```ruby
  user = FactoryGirl.attributes_for(:users)
  ```

#### Overriding the default attributes

You can override FactoryGirl's default attributes like so:

```ruby
user = FactoryGirl.create(:user, first_name: "Barry", last_name: "Zuckercorn")
```

You can manually associate objects in the same way.  Say you want to create a user, and then 3 meetups that they created:

```ruby
my_user = FactoryGirl.create(:user)
meetups = FactoryGirl.create_list(:meetup, 3, user: my_user)
```

### Notes

There's a whole bunch of crazy stuff you can do with FactoryGirl.  Read the docs to learn more:

* [Getting Started with FactoryGirl](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md)
* [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails)

I'd recommend sticking with these basics, though, rather than going nuts with things like traits, etc.

**Protip: Put your factories in a single `spec/support/factories.rb` file. Or not.**

You can stick with the default location for factories (`spec/factories/<MODELNAME_PLURAL>.rb`) if you want.
I prefer to put my factories in a single file in the `spec/support` directory (which you may need to create manually).  I think it's a pain to have to look at a whole bunch of files to see my factories.

```ruby
# spec/support/factories.rb
FactoryGirl.define do
  factory :user do
    # ...
  end

  factory :meetup do
    # ...
  end

  factory :rsvp do
    # ...
  end  

  # etc.
end
```
If you do that, though, you need to tell RSpec to load your factories by uncommenting the following line in your `rails_helper.rb` file:

```ruby
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
```

[**Aside:** Now you can put whatever helpers you want in the `spec/support` directory, in addition to factories.]
