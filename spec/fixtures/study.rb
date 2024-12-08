#!/usr/bin/env ruby

class StudyFixture
  class << self
    def valid
      {
        name: 'My study-test',
        sponsor: 'OMAR-CORP',
        protocol_number: '111111',
        phase: 'phase_four',
        service_agreement_type: 'lcnis_study',
        status: 'feasibility',
        description: 'This is a study',
        max_budget: '100000.00',
        notification_percentage: '10.00',
        country_ids: [PASS::Country.list(filters: {code: 'US'}).first.id]
      }
    end
  end
end
