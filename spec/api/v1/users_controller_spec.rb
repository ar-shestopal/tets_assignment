require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller  do
  let!(:admin) { create :admin }
  let!(:user)  { create :user }

  describe 'GET index' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        get :index, format: :json
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns only current user' do
        get :index, format: :json
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first['name']).to eq(user.name)
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response' do
        get :index, format: :json
        expect(response).to be_success
      end

      it 'returns all the users' do
        get :index, format: :json
        expect(parsed_response.length).to eq(2)
        expect(parsed_response.first['name']).to eq(admin.name)
      end
    end
  end


  describe 'GET show' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        get :show, id: user, format: :json
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response' do
        get :show, id: user, format: :json
        expect(response).to be_success
      end

      it 'returns data of current user' do
        get :show, id: user, format: :json
        expect(parsed_response['name']).to eq(user.name)
      end

      it 'returns an access denied if getting info not current user' do
        get :show, id: admin, format: :json
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }
      
      it 'returns a successful 200 response' do
        get :show, id: user, format: :json
        expect(response).to be_success
      end

      it 'returns data of an single user' do
        get :show, id: user, format: :json
        expect(parsed_response['name']).to eq(user.name)
      end

      it 'returns an error if the user does not exist' do
        get :show, id: 10 , format: :json
        expect(response).to be_not_found
        expect(parsed_response['error']).to eq('Record Not Found')
      end
    end
  end


  describe 'POST create' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        post :create, user: { name: 'New User', email: 'new_user@test.com', password: 'password' }
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns an access denied' do
        post :create, user: { name: 'New User', email: 'new_user@test.com', password: 'password' }
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response' do
        post :create, user: { name: 'New User', email: 'new_user@test.com', password: 'password' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        post :create, user: { name: 'New User', email: 'new_user@test.com' }
        expect(response).to be_unprocessable
        expect(parsed_response['password'][0]).to eq("can't be blank")
      end
    end
  end


  describe 'PUT update' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        put :update, id: user, user: { name: 'New User' }
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns a successful 200 response if update own user data' do
        put :update, id: user, user: { name: 'New User' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        put :update, id: user, user: { name: nil }
        expect(response).to be_unprocessable
        expect(parsed_response['name'][0]).to eq("can't be blank")
      end

      it 'returns an access denied if user is not current user' do
        put :update, id: admin, user: { name: 'New User' }
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response if update own user data' do
        put :update, id: admin, user: { name: 'New User' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a successful 200 response if user is not current user' do
        put :update, id: user, user: { name: 'New User' }
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end

      it 'returns a unprocessable 422 response' do
        put :update, id: admin, user: { name: nil }
        expect(response).to be_unprocessable
        expect(parsed_response['name'][0]).to eq("can't be blank")
      end
    end
  end


  describe 'DELETE destroy' do
    context 'guest user' do
      it 'returns a 401 Unauthorized' do
        delete :destroy, id: user
        expect(response).to be_unauthorized
      end
    end

    context 'regular user' do
      before(:each) { login_by(:regular_user) }

      it 'returns an access denied if current user is not admin' do
        delete :destroy, id: admin
        expect(response).to be_forbidden
        expect(parsed_response['error']).to eq('Access denied')
      end
    end

    context 'admin user' do
      before(:each) { login_by(:admin) }

      it 'returns a successful 200 response if delete user' do
        delete :destroy, id: user
        expect(response).to be_success
        expect(parsed_response['success']).to eq(true)
      end
    end
  end
end
