class SiteFixture
  class << self
    def valid
      {
        name: 'Omar site',
        number: '111111',
        status: 'approved',
        line1: 'First line of address',
        line2: 'Second line of address',
        town: 'Faketown',
        postcode: '90210',
        max_patient_count: 100,
        point_of_contact_name: 'Omar',
        point_of_contact_phone_number: '+15552369478',
        point_of_contact_email: 'test@fake.com',
        travel_rate_value: '0.74',
        travel_rate_unit_of_measurement: 'miles'
      }
    end
  end
end
