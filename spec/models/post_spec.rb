require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'attributes' do
    it { expect(subject.attributes).to include('title', 'content', 'author_id') }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:author) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:title).is_at_most(80) }
  end
end
