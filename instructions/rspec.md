# Testowanie aplikacji przy użyciu biblioteki RSpec

#### 1. Instalacja i instrukcja użycia
Dodajemy gem do gemfile'a
```ruby
# Gemfile

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
end
```
Instalujemy go, uruchamiamy instalację i sprawdzamy czy działa
```zsh
$ bundle install
$ rails generate rspec:install
$ rspec .
```

Od góry w kolejności - wywołanie wszystkich testów, wywołanie testów z jednego pliku, wywołanie testów z jednego pliku które są w konretnym bloku w konkretnej linijce
```zsh
$ rspec .
$ rspec sciezka/do/pliku/na/dysku_spec.rb
$ rspec sciezka/do/pliku/na/dysku_spec.rb:145
```

#### 2. Test modelu - iteracja pierwsza
```ruby
# spec/models/author_spec.rb

require 'rails_helper'

RSpec.describe Author, type: :model do
  it 'should have proper attributes' do
    expect(subject.attributes).to include('name', 'surname', 'age')
  end

  it 'should require name and surname' do
    expect(Author.new).not_to be_valid
    expect(Author.new(name: 'test')).not_to be_valid
    expect(Author.new(name: 'test', surname: 'test')).to be_valid
  end

  it 'should have old scope' do
    author1 = Author.create(name: 'test', surname: 'test', age: 10)
    author2 = Author.create(name: 'test', surname: 'test', age: 55)
    expect(Author.old).to include(author2)
    expect(Author.old).not_to include(author1)
  end

  it 'should set age to 25 if not given any' do
    author = Author.create(name: 'test', surname: 'test')
    expect(author.age).to eq(25)
  end

  it 'should have working #fullname method' do
    author = Author.new(name: 'test', surname: 'example')
    expect(author.fullname).to eq('test example')
  end
end
```


#### 3. Test modelu - druga iteracja - shoulda matchers
Dodajemy gem do gemfile'a
```ruby
# Gemfile

group :test do
  gem 'shoulda-matchers', '~> 3.1'
end
```
Instalujemy go
```zsh
$ bundle install
```

Dodajemy konfigurację do `rails_helper.rb`
```ruby
# spec/rails_helper.rb

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

```ruby
# spec/models/author_spec.rb

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'attributes' do
    it 'should have proper attributes' do
      expect(subject.attributes).to include('name', 'surname', 'age')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
  end

  describe 'scopes' do
    it 'should have old scope' do
      author1 = Author.create(name: 'test', surname: 'test', age: 10)
      author2 = Author.create(name: 'test', surname: 'test', age: 55)
      expect(Author.old).to include(author2)
      expect(Author.old).not_to include(author1)
    end
  end

  describe 'callbacks' do
    it 'should set age to 25 if not given any' do
      author = Author.create(name: 'test', surname: 'test')
      expect(author.age).to eq(25)
    end
  end

  describe '#fullname' do
    it 'should return fullname' do
      author = Author.new(name: 'test', surname: 'example')
      expect(author.fullname).to eq('test example')
    end
  end
end
```

#### 4. Test modelu - trzecia iteracja - let
```ruby
# spec/models/author_spec.rb

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'attributes' do
    it 'should have proper attributes' do
      expect(subject.attributes).to include('name', 'surname', 'age')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
  end

  describe 'scopes' do
    let!(:author1) { Author.create(name: 'test', surname: 'test', age: 10) }
    let!(:author2) { Author.create(name: 'test', surname: 'test', age: 55) }

    it 'should have old scope' do
      expect(Author.old).to include(author2)
      expect(Author.old).not_to include(author1)
    end
  end

  describe 'callbacks' do
    let(:author) { Author.create(name: 'test', surname: 'test') }

    it 'should set age to 25 if not given any' do
      expect(author.age).to eq(25)
    end
  end

  describe '#fullname' do
    let(:author) { Author.new(name: 'test', surname: 'example') }

    it 'should return fullname' do
      expect(author.fullname).to eq('test example')
    end
  end
end
```

#### 5. Test modelu - czwarta iteracja - tworzenie obiektów testowych przy użyciu `factory bot`
Dodajemy gem do gemfile'a
```ruby
# Gemfile

group :development, :test do
  gem 'factory_bot_rails'
end
```
Instalujemy go
```zsh
$ bundle install
```

Dodajemy konfigurację do `rails_helper.rb`
```ruby
# spec/rails_helper.rb

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

```ruby
# spec/factories/authors.rb

FactoryBot.define do
  factory :author do
    name { 'Andrzej' }
    surname { 'Tester' }
    age { 32 }
  end
end
```

```ruby
# spec/models/author_spec.rb

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'attributes' do
    it 'should have proper attributes' do
      expect(subject.attributes).to include('name', 'surname', 'age')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
  end

  describe 'scopes' do
    let!(:author1) { create(:author, age: 10) }
    let!(:author2) { create(:author, age: 55) }

    it 'should have old scope' do
      expect(Author.old).to include(author2)
      expect(Author.old).not_to include(author1)
    end
  end

  describe 'callbacks' do
    let(:author) { create(:author, age: nil) }

    it 'should set age to 25 if not given any' do
      expect(author.age).to eq(25)
    end
  end

  describe '#fullname' do
    let(:author) { build(:author) }

    it 'should return fullname' do
      expect(author.fullname).to eq('Andrzej Tester')
    end
  end
end
```

#### 6. Test modelu - piąta iteracja - losowe dane przy użyciu `faker`
Dodajemy gem do gemfile'a
```ruby
# Gemfile

group :development, :test do
  gem 'faker'
end
```
Instalujemy go
```zsh
$ bundle install
```

```ruby
# spec/factories/authors.rb

FactoryBot.define do
  factory :author do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    age { Faker::Number.between(10, 80) }
  end
end

```

```ruby
# spec/models/author_spec.rb

...

  describe '#fullname' do
    let(:author) { build(:author) }

    it 'should return fullname' do
      expect(author.fullname).to eq("#{author.name} #{author.surname}")
    end
  end

...
```
