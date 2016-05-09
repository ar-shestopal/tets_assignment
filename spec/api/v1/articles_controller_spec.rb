require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :controller  do
  let(:admin) { create :admin }
  let(:user)  { create :user }
  let!(:article1) { create :article, user: admin }
  let!(:article2) { create :article, user: user }

  describe 'GET index' do
    context 'guest user' do
      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the articles' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['body']).to eq(article1.body)
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the articles' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['body']).to eq(article1.body)
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the articles' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['body']).to eq(article1.body)
      end
    end
  end


  describe 'GET show' do
    context 'guest user' do
      it 'returns a successful 200 response' do
        get :show, id: article1, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single article' do
        get :show, id: article1, format: :json
        expect(parsed_response['body']).to eq(article1.body)
      end

      it 'returns an error if the article does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        get :show, id: article1, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single article' do
        get :show, id: article1, format: :json
        expect(parsed_response['body']).to eq(article1.body)
      end

      it 'returns an error if the article does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }
      
      it 'returns a successful 200 response' do
        get :show, id: article1, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single article' do
        get :show, id: article1, format: :json
        expect(parsed_response['body']).to eq(article1.body)
      end

      it 'returns an error if the article does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end
  end


  describe 'POST create' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        post :create, { article: { body: 'article by guest' } }
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        post :create, { article: { title: 'title', body: 'article by guest' } }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        post :create, { article: { title: 'title', body: nil } }
        expect(response).to be_unprocessable
        expect(parsed_response['body'][0]).to eq("can't be blank")
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response' do
        post :create, { article: { title: 'title', body: 'article by guest' } }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        post :create, { article: { title: 'title', body: nil } }
        expect(response).to be_unprocessable
        expect(parsed_response['body'][0]).to eq("can't be blank")
      end
    end
  end


  describe 'PUT update' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        put :update, id: article1, article: { title: 'title', body: 'updated article by guest' }
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response if update own article' do
        put :update, id: article2, article: { title: 'title', body: 'updated article by guest' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        put :update, id: article2, article: {title: 'title',  body: nil }
        expect(response).to be_unprocessable
        expect(parsed_response['body'][0]).to eq("can't be blank")
      end

      it "returns an access denied if article doesn't belong to user" do
        put :update, id: article1, article: { title: 'title', body: 'updated article by guest' }
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response if update own article' do
        put :update, id: article1, article: { title: 'title', body: 'updated article by guest' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it "returns a successful 200 response if article doesn't belong to user" do
        put :update, id: article2, article: { title: 'title', body: 'updated article by guest' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        put :update, id: article2, article: { title: 'title', body: nil }
        expect(response).to be_unprocessable
        expect(parsed_response['body'][0]).to eq("can't be blank")
      end
    end
  end


  describe 'DELETE destroy' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        delete :destroy, id: article1.id
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response if delete own article' do
        delete :destroy, id: article2
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it "returns an access denied if article doesn't belong to user" do
        delete :destroy, id: article1
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response if delete own article' do
        delete :destroy, id: article1
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it "returns a successful 200 response if article doesn't belong to user" do
        delete :destroy, id: article2
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end
    end
  end
end
