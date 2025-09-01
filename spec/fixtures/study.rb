class StudyFixture
  class << self
    def valid
      country_bg = PASS::Country.list(filters: {code: 'BG'}).first.id
      currency_bgn = PASS::Currency.list(filters: {code: 'BGN'}).first.id
      language_en = PASS::Language.list(filters: {code: 'en'}).first.id
      expense_type_mileage = PASS::ExpenseType.list(filters: {name: 'Mileage'}).first.id
      visit_type_onsite = PASS::VisitType.list(filters: {name: 'On-site'}).first.id
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
        country_ids: [country_bg],
        currency_ids: [currency_bgn],
        language_ids: [language_en],
        expense_type_ids: [expense_type_mileage],
        default_language_id: language_en,
        default_currency_id: currency_bgn,
        supported_visit_type_ids: [visit_type_onsite]
      }
    end
  end
end
