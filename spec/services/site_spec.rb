RSpec.describe 'PASS::Site' do
  context 'when listing sites' do
    before do
      @sites = PASS::Site.list
    end

    it 'should return a list of sites' do
      expect(@sites).to be_kind_of(Array)
      expect(@sites.first).to be_kind_of(PASS::Site)
      expect(@sites.first.name).to be_kind_of(String)
    end
  end

  context 'when listing sites with a filter of study' do
    before do
      @study = PASS::Study.list.first
      @sites = PASS::Site.list(filters: {study: @study.id})
    end


    it 'should return a list of sites associated to a study' do
      expect(@sites).to be_kind_of(Array)
      expect(@sites.first).to be_kind_of(PASS::Site)
      expect(@sites.first.study_id).to eq(@study.id)
    end
  end

  context 'with an existing study' do
    before do
      study_attributes = StudyFixture.valid
      @country = PASS::Country.list(filters: {code: 'US'}).first
      @study = PASS::Study.new
      @study.assign_attributes(study_attributes)
      @study.save
      @site_attributes = SiteFixture.valid
      @site_attributes[:country_id] = @country.id
      @site_attributes[:study_id] = @study.id
    end

    it 'should create a site' do
      @site = PASS::Site.new
      @site.assign_attributes(@site_attributes)
      @site.save
      expect(@site.valid?).to be true
      expect(@site.id).to be_present
      expect(@site.study_id).to eq(@study.id)
    end

    after do
      begin
        @site.destroy
      ensure
        @study.destroy
      end
    end
  end
end
