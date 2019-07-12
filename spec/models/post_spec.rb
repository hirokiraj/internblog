require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'attributes' do
    it { expect(subject.attributes).to include('title', 'content', 'author_id') }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:author) }
  end
end
