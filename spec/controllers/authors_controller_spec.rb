require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    describe 'successful response' do
      before { subject }
      it { expect(response).to be_successful }
      it { expect(response).to render_template('index') }
    end

    context 'authors' do
      let!(:author1) { create(:author) }
      let!(:author2) { create(:author) }

      it 'returns all authors' do
        subject
        expect(assigns(:authors)).to match_array([author1, author2])
      end
    end
  end

  describe 'GET #show' do
    let(:author) { create(:author) }
    before { get :show, params: { id: author.id } }

    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('show') }
    end

    context 'author' do
      it 'returns one author by given id' do
        expect(assigns(:author)).to eq(author)
      end
    end
  end

  describe 'GET #new' do
    before { get :new }

    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('new') }
    end

    context 'author' do
      it 'returns one author by given id' do
        expect(assigns(:author)).to be_a(Author)
        expect(assigns(:author).persisted?).to eq(false)
      end
    end
  end

  describe 'GET #edit' do
    let(:author) { create(:author) }
    before { get :edit, params: { id: author.id } }

    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('edit') }
    end

    context 'author' do
      it 'returns one author by given id' do
        expect(assigns(:author)).to eq(author)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { author: attributes_for(:author) } }
    let(:invalid_attributes) { { author: attributes_for(:author, name: nil) } }

    context 'valid attributes' do
      subject { post :create, params: valid_attributes }

      it { expect(subject).to redirect_to(Author.last) }

      it 'redirects with notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      it { expect { subject }.to change(Author, :count).by(1) }
    end

    context 'invalid attributes' do
      subject { post :create, params: invalid_attributes }

      it { expect(subject).to render_template('new') }
      it { expect { subject }.not_to change(Author, :count) }
    end
  end

  describe 'PUT #update' do
    let(:author) { create(:author) }
    let(:valid_attributes) { { id: author.id, author: attributes_for(:author) } }
    let(:invalid_attributes) { { id: author.id, author: attributes_for(:author, name: nil) } }

    context 'valid attributes' do
      subject { put :update, params: valid_attributes }

      it { expect(subject).to redirect_to(author) }

      it 'redirects with notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      it 'updates author' do
        subject
        expect(author.reload.name).to eq(valid_attributes[:author][:name])
      end
    end

    context 'invalid attributes' do
      subject { put :update, params: invalid_attributes }

      it { expect(subject).to render_template('edit') }
      it { expect { subject }.not_to change(author, :name) }
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:author) }
    subject { delete :destroy, params: { id: author.id } }

    it { expect(subject).to redirect_to(authors_path) }

    it 'redirects with notice' do
      subject
      expect(flash[:notice]).to be_present
    end

    it 'deletes author' do
      author
      expect { subject }.to change(Author, :count).by(-1)
    end
  end
end
