# Tramway::Admin
Short description and motivation.

## English readme

*If you need translation of this Readme, please message us kalashnikov@ulmic.ru. We'll translate for you and post to this page*

## Russian readme

Готовая админка для проекта. Она подготовлена для работы со всеми tramway плагинами, а также поддерживает и ваши модели тоже.

## Usage
How to use my plugin.

#### 1. Add this gems to Gemfile

*Gemfile*
```ruby
gem 'tramway-admin'
gem 'tramway-auth'
gem 'tramway-core'
gem 'tramway-user'
gem 'state_machine', github: 'seuros/state_machine'
gem 'bcrypt'
gem 'haml-rails'
gem 'selectize-rails'
gem 'bootstrap'
gem 'jquery-rails'
gem 'copyright_mafa'
gem 'trap'
gem 'kaminari'
gem 'bootstrap-kaminari-views', github: 'kalashnikovisme/bootstrap-kaminari-views', branch: :master
gem 'state_machine_buttons'
gem 'ckeditor', '4.2.4'
gem 'ransack'
gem 'smart_buttons'
gem 'carrierwave'
gem 'validates'
```

#### 2. You should remove gem `turbolinks` from your application and from app/assets/javascripts/application.js

#### 3. Update your routes

*config/routes.rb*

```ruby
Rails.application.routes.draw do
  mount Tramway::Auth::Engine, at: '/auth'
  mount Tramway::Admin::Engine, at: '/admin'
end
```

#### 4. Then make `tramway-core` installation. [How-to](https://github.com/ulmic/tramway-dev/blob/develop/tramway-core/README.md#installation)


#### 5. And then execute:

```bash
$ bundle
$ rails g tramway:user:install
$ rails db:migrate
```

#### 6. Create your first admin user

```bash
$ rails c
$> Tramway::User::User.create! email: 'your@email.com', password: '123456789', role: :admin
```

#### 7. Add models to your admin

*app/config/initializers/tramway.rb*

```ruby
# set available models for your admin
::Tramway::Admin.set_available_models YourModel, AnotherYourModel, project: #{project_name_which_you_used_in_application_name}
# set singleton models for your admin
::Tramway::Admin.set_singleton_models YourSingletonModel, AnotherYourSingletonModel, project: #{project_name_which_you_used_in_application_name}
::Tramway::Auth.root_path = '/admin' # you need it to redirect in the admin panel after admin signed_in
```

#### 8. Configurate navbar

*config/initializers/tramway.rb*
```ruby
Tramway::Admin.navbar_structure(
  YourModel, # this line will create first-level link in your navbar, which will send you to the YourModel management
  {
    my_dropdown: [ # this line contains dropdown link name
      AnotherYourModel # this line will create 2nd-level link in your navbar, which will send you to the YourModel management,
      :divider # this line adds bootstrap divider to the dropdown list
    ]
  },
  project: :your_application_name
)
```

#### 9. Create decorator for models

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  class << self
    def collections
      [ :all, :scope1, :scope2 ]
    end
    
    def list_filters
      {
        filter_name: {
          type: :select,
          select_collection: filter_collection,
          query: lambda do |list, value|
            list.where some_attribute: value
          end
        },
        date_filter_name: {
          type: :dates,
          query: lambda do |list, begin_date, end_date|
            list.where 'created_at > ? AND created_at < ?', begin_date, end_date
          end
        }
      }
    end
  end
  
  delegate :title, to: :object
end
```

**NOTES:**
* `collections` method must return array of scopes of `YourModel`. Every collection will be a tab in a list of your model in admin panel
* `list_filters` method returns hash of filters where:
  * select_collection - collection which will be in the select of filter. It must be compatible with [options_for_select](https://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/options_for_select) method
  * query - some Active Record query which be used as a filter of records

Filters naming:

*Select filters*

```yaml
en:
  tramway:
    admin:
      filters:
        model_name:
          filter_name: Your Filter
```

*Date filters*

```yaml
en:
  tramway:
    admin:
      filters:
        model_name:
          date_filter_name:
            begin_date: Your Begin date filter
            end_date Your end date filter
```

#### 10. Add inheritance to YourModel

*app/models/your_model.rb*
```ruby
class YourModel < Tramway::Core::ApplicationRecord
end
```

#### 11. Create `Admin::YourModelForm`

*app/forms/admin/your_model_form.rb
```ruby
class Admin::YourModelForm < Tramway::Core::ApplicationForm
  properties :title, :description, :text, :date, :logo

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        logo: :file,
        description: :ckeditor,
        date: :date_picker,
        text: :text
    end
  end
end
```

### 12. You can add search to your index page

Tramway use gem [PgSearch](https://github.com/Casecommons/pg_search`) as search engine

Just add `search` method to `YourModel` like this

```ruby
search_by *attributes, **associations # `attributes` and `associations` should be the same syntax as in PgSearch
```

Example:

```ruby
class YourModel < Tramway::Core::ApplicationRecord
  search_by :my_attribute, :another_attribute, my_association: [ :my_association_attribute, :another_my_association_attribute ]
```

#### 12. Run server `rails s`
#### 13. Launch `localhost:3000/admin`


### CRUDs for models

By default users with role `admin` have access to all models used as arguments in method `::Tramway::Admin.set_available_models`. If you want specify models by roles, use them as keys

```ruby
::Tramway::Admin.set_available_models ::Tramway::Event::Event, ::Tramway::Event::ParticipantFormField,
  ::Tramway::Event::Participant, ::Tramway::Landing::Block, ::Tramway::User::User,
  ::Tramway::Profiles::SocialNetwork, project: #{project_name_which_you_used_in_application_name}, role: :admin

::Tramway::Admin.set_available_models ::Tramway::Event::Event, ::Tramway::Event::ParticipantFormField,
  ::Tramway::Event::Participant, project: #{project_name_which_you_used_in_application_name}, role: :another_role
```

You can set functions which are available by default some CRUD functions for any role:

```ruby
# this line gives access only index page to YourModel for partner role
::Tramway::Admin.set_available_models YourModel => [ :index ], role: :partner
```

You can set conditions for functions which are available for any role:

```ruby
# this line gives access to destroy only record with name `Elon Musk`

::Tramway::Admin.set_available_models YourModel => [
  destroy => lambda do |record|
    record.name == 'Elon Musk'
  end
 ], role: :partner
```

Here docs about changing roles of `Tramway::User::User` model [Readme](https://github.com/ulmic/tramway-dev/tree/develop/tramway#if-you-want-to-edit-roles-to-the-tramwayuseruser-class)

## Associations management

### has_and_belongs_to_many

We have models Game and Packs.

*app/models/game.rb*
```ruby
class Game < Tramway::Core::ApplicationRecord
  has_and_belongs_to_many :packs
end
```

*app/models/pack.rb*
```ruby
class Pack < Tramway::Core::ApplicationRecord
  has_and_belongs_to_many :games
end
```

**You want to manage games in the Pack show admin page**

#### 1. Add association to PackDecorator

*app/decorators/pack_decorator.rb*
```ruby
class PackDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :games
end
```

#### 2. Create `Admin::Packs::AddGameForm` and `Admin::Packs::RemoveGameForm`

*app/forms/admin/packs/add_game_form.rb*
```ruby
class Admin::Packs::AddGameForm < Tramway::Core::ApplicationForm
  properties :game_ids
  association :games

  def initialize(object)
    super(object).tap do
      form_properties games: :association
    end
  end

  def submit(params)
    params[:game_ids].each do |id|
      model.games << Game.find(id) if id.present?
    end
    model.save!
  end
end
```

*app/forms/admin/packs/remove_game_form.rb*
```ruby
class Admin::Packs::RemoveGameForm < Tramway::Core::ApplicationForm
  properties :id

  def submit(params)
    model.games -= [Game.find(params)] if id.present?
    model.save!
  end
end

```

#### 3. Add this forms to initializer

*config/initializers/tramway/admin/forms.rb*
```ruby
Tramway::Admin.forms = 'packs/add_game', 'packs/remove_game'
```

## Date Picker locale

DatePicker provides `ru`, `en` locales. To set needed locale, just add

```javascript
window.current_locale = window.i18n_locale('en');
```
to the `app/assets/javascripts/admin/application.js` file

**OR**

```coffeescript
window.current_locale = window.i18n_locale 'en'
```
to the `app/assets/javascripts/admin/application.js.coffee` file

## Notifications

You can add notification to your admin panel to the navbar.

To add notification to application, you need just set queries in initializers.

*config/initializers/tramway.rb*
```ruby
::Tramway::Admin.set_notificable_queries :"#{your_title}"  => -> { your_query }

# Example from tramway-event gem (you also can push context variables here)

::Tramway::Admin.set_notificable_queries new_participants: -> (current_user) do
  ::Tramway::Event::Participant.active.where(participation_state: :requested).send "#{current_user}_scope", current_user.id
end
```

**NOTE:** Proc with `current_user` argument is expecting. If you don't need `current_user`, just name do something like that:

```ruby
::Tramway::Admin.set_notificable_queries new_participants: -> (_current_user) do
  # some code which does not need current_user
end
```

## Admin Main Page management

Start page of admin panel contains only `application.name` by default. To manage it just set `Tramway::Admin.welcome_page_actions` with some lambda and set `@content` variable with HTML.

Example:

*config/initializers/tramway/admin.rb*
```ruby
::Tramway::Admin.welcome_page_actions = lambda do
  @content = '<a href="http://it-way.pro">IT Way</a>'
end
```

## Navbar management

### Navbar structure

You can manage your navbar easy

*config/initializers/tramway.rb*
```ruby
Tramway::Admin.navbar_structure(
  YourModel, # this line will create first-level link in your navbar, which will send you to the YourModel management
  {
    my_dropdown: [ # this line contains dropdown link name
      AnotherYourModel # this line will create 2nd-level link in your navbar, which will send you to the YourModel management,
      :divider # this line adds bootstrap divider to the dropdown list
    ]
  },
  project: :your_application_name
)
```

**NOTE:** navbar structure is the same for all roles, but users will see only available models for them

### Dropdown localization

To set human-read name for dropdown link you can use i18n:

*config/locales/admin.yml*

```yaml
en:
  admin:
    navbar:
      links:
        my_dropdown: Very important dropdown
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
