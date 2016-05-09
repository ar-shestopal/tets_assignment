require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller  do
  let(:admin) { create :admin }
  let(:user)  { create :user }
  let(:article1) { create :article, user: user }
  let(:article2) { create :article, user: user }
  let!(:comment1) { create(:comment, article: article1, user: admin) }
  let!(:comment2) { create(:comment, article: article2, user: user) }

  describe 'GET index' do
    context 'guest user' do
      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the comments' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['body']).to eq(comment1.body)
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the comments' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['body']).to eq(comment1.body)
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the comments' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['body']).to eq(comment1.body)
      end
    end
  end


  describe 'GET show' do
    context 'guest user' do
      it 'returns a successful 200 response' do
        get :show, id: comment1, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single comment' do
        get :show, id: comment1, format: :json
        expect(parsed_response['body']).to eq(comment1.body)
      end

      it 'returns an error if the comment does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        get :show, id: comment1, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single comment' do
        get :show, id: comment1, format: :json
        expect(parsed_response['body']).to eq(comment1.body)
      end

      it 'returns an error if the comment does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }
      
      it 'returns a successful 200 response' do
        get :show, id: comment1, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single comment' do
        get :show, id: comment1, format: :json
        expect(parsed_response['body']).to eq(comment1.body)
      end

      it 'returns an error if the comment does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end
  end


  describe 'POST create' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        post :create, { comment: { body: 'comment by guest', article_id: article1.id } }
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        post :create, { comment: { body: 'comment by user', article_id: article1.id } }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        post :create, { comment: { body: 'comment by user' } }
        expect(response).to be_unprocessable
        expect(parsed_response['article_id'][0]).to eq("can't be blank")
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response' do
        post :create, { comment: { body: 'comment by admin', article_id: article1.id } }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        post :create, { comment: { body: 'comment by admin' } }
        expect(response).to be_unprocessable
        expect(parsed_response['article_id'][0]).to eq("can't be blank")
      end
    end
  end


  describe 'PUT update' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        put :update, id: comment1, comment: { body: 'updated comment by guest' }
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response if update own comment' do
        put :update, id: comment2, comment: { body: 'updated comment by user' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        put :update, id: comment2, comment: { body: nil }
        expect(response).to be_unprocessable
        expect(parsed_response['body'][0]).to eq("can't be blank")
      end

      it "returns an access denied if comment doesn't belong to user" do
        put :update, id: comment1, comment: { body: 'updated comment by user' }
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response if update own comment' do
        put :update, id: comment1, comment: { body: 'updated comment by admin' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it "returns a successful 200 response if comment doesn't belong to user" do
        put :update, id: comment2, comment: { body: 'updated comment by admin' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        put :update, id: comment2, comment: { body: nil }
        expect(response).to be_unprocessable
        expect(parsed_response['body'][0]).to eq("can't be blank")
      end
    end
  end


  describe 'DELETE destroy' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        delete :destroy, id: comment1
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response if delete own comment' do
        delete :destroy, id: comment2
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it "returns an access denied if comment doesn't belong to user" do
        delete :destroy, id: comment1
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response if delete own comment' do
        delete :destroy, id: comment1
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it "returns a successful 200 response if comment doesn't belong to user" do
        delete :destroy, id: comment2
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end
    end
  end
end
