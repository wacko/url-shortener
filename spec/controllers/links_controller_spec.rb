require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:valid_attributes) {{
    url: 'http://google.com',
    code: 'google'
  }}

  describe "GET /:code" do
    context "when the code exists" do
      it "redirect to the stored url" do
        Link.create code: 'google', url: 'http://google.com'

        get :show, params: {code: 'google'}
        expect(response).to redirect_to('http://google.com')
      end
    end

    context "when the code do not exists" do
      it "return '404 Not Found'" do
        get :show, params: {code: 'not-found'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /urls" do
    context "with valid params" do
      it "returns '201 Created' and shortcode" do
        post :create, params: valid_attributes
        expect(response.body).to eq({code: 'google'}.to_json)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "returns '400 Bad Request' if url is not present" do
        post :create, params: {code: 'error1'}
        expect(response).to have_http_status(:bad_request)
      end
      it "returns '409 Conflict' if shortcode is already used" do
        Link.create valid_attributes
        post :create, params: valid_attributes
        expect(response).to have_http_status(:conflict)
      end
      it "returns '422 Unprocessable Entity' if shortcode format is invalid" do
        post :create, params: {code: 'invalid code', url: 'http://google.com'}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /:code/stats" do
    it "returns '201 Created' and shortcode" do
      Link.create(valid_attributes)
      get :stats, params: {code: 'google'}
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('start_date')
    end
  end

end
