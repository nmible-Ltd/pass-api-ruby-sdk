RSpec.describe 'PASS::Client' do
  context "with the correct login information" do
    before do
      ENV['PASS_EMAIL'] = EMAIL
      ENV['PASS_PASSWORD'] = PASSWORD
      ENV['PASS_ENDPOINT'] = BASE_URL

      @client = PASS::Client.instance
    end

    it "is authenticated" do
      expect(@client.authenticated?).to be true
    end
  end
end
