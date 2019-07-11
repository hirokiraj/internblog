require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'attributes' do
    it { expect(subject.attributes).to include('name', 'surname', 'age') }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
  end

  describe 'scopes' do
    let!(:author1) { create(:author, age: 12) }
    let!(:author2) { create(:author, age: 14) }
    let!(:author3) { create(:author, age: 36) }
    let!(:author4) { create(:author, age: 65) }

    it 'old' do
      expect(Author.old.count).to eq(2)
      expect(Author.old).to match_array([author3, author4])
    end
  end

  describe 'callbacks' do
    let(:author) { create(:author, age: nil) }

    it 'should set age to 25 if not given any' do
      expect(author.age).to eq(25)
    end
  end

  describe '#fullname' do
    let(:author) { create(:author) }

    it 'return author fullname' do
      expect(author.fullname).to eq("#{author.name} #{author.surname}")
    end
  end

  describe '.delete_old_author' do
    let!(:author1) { create(:author, age: 12) }
    let!(:author2) { create(:author, age: 14) }
    let!(:author3) { create(:author, age: 36) }
    let!(:author4) { create(:author, age: 65) }

    it 'should delete old author with .delete_old_authors method' do
      expect { Author.delete_old_authors }.to change(Author, :count).by(-2)
    end
  end
end
