#!/usr/bin/env ruby

class StudyFixture
  class << self
    def valid
      country_us = PASS::Country.list(filters: {code: 'US'}).first.id
      currency_usd = PASS::Currency.list(filters: {code: 'USD'}).first.id
      language_en = PASS::Language.list(filters: {code: 'EN'}).first.id
      expense_type_mileage = PASS::ExpenseType.list(filters: {name: 'Mileage'}).first.id

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
        country_ids: [country_us],
        currency_ids: [currency_usd],
        language_ids: [language_en],
        expense_type_ids: [expense_type_mileage],
        default_language_id: language_en,
        default_currency_id: currency_usd
      }
    end
  end
end
