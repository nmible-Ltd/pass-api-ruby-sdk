RSpec.describe 'PASS::Client' do
  context "with the correct login information" do
    before do
      @email = EMAIL
      @password = PASSWORD
      @endpoint = BASE_URL

      @client = PASS::Client.new(
        endpoint: @endpoint,
        email: @email,
        password: @password
      )
    end

    it "is authenticated" do
      expect(@client.authenticated?).to be true
    end
  end

  context "with the incorrect email" do
    before do
      @email = "bad-email@email.com"
      @password = PASSWORD
      @endpoint = BASE_URL
    end

    it "raises an authentication error" do
      expect {
        @client = PASS::Client.new(
          endpoint: @endpoint,
          email: @email,
          password: @password
        )
      }.to raise_error Faraday::UnauthorizedError
    end

  end

  context "with the incorrect password" do
    before do
      @email = EMAIL
      @password = "bad-password"
      @endpoint = BASE_URL
    end

    it "raises an authentication error" do
      expect {
        @client = PASS::Client.new(
          endpoint: @endpoint,
          email: @email,
          password: @password
        )
      }.to raise_error Faraday::UnauthorizedError
    end
  end

end
