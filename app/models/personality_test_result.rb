class PersonalityTestResult < ApplicationRecord
  belongs_to :user

  validates :completed_at, presence: true
  validates :openness, :conscientiousness, :extraversion, :agreeableness, :neuroticism,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def expired?
    completed_at < 90.days.ago
  end

  QUESTIONS = [
    # Openness (1-6)
    { id: 1, text: "I have a rich imagination and enjoy exploring new creative concepts.", dimension: :openness, direction: 1 },
    { id: 2, text: "I am fascinated by art, literature, or philosophy.", dimension: :openness, direction: 1 },
    { id: 3, text: "I love learning about diverse topics and intellectual ideas.", dimension: :openness, direction: 1 },
    { id: 4, text: "I prefer routine and familiar environments over constant variety.", dimension: :openness, direction: -1 },
    { id: 5, text: "I find abstract theories and conceptual discussions dry or uninteresting.", dimension: :openness, direction: -1 },
    { id: 6, text: "I tend to focus on concrete facts rather than speculative imagination.", dimension: :openness, direction: -1 },

    # Conscientiousness (7-12)
    { id: 7, text: "I pay close attention to details and strive for accuracy in my work.", dimension: :conscientiousness, direction: 1 },
    { id: 8, text: "I prefer to plan tasks out and follow a structured schedule.", dimension: :conscientiousness, direction: 1 },
    { id: 9, text: "I am highly self-disciplined and driven to complete tasks on time.", dimension: :conscientiousness, direction: 1 },
    { id: 10, text: "I often leave my workspace disorganized or cluttered.", dimension: :conscientiousness, direction: -1 },
    { id: 11, text: "I sometimes procrastinate or delay starting complex projects.", dimension: :conscientiousness, direction: -1 },
    { id: 12, text: "I occasionally make careless mistakes when rushing through tasks.", dimension: :conscientiousness, direction: -1 },

    # Extraversion (13-18)
    { id: 13, text: "I feel energized and expressive when interacting with groups of people.", dimension: :extraversion, direction: 1 },
    { id: 14, text: "I easily strike up conversations with people I've just met.", dimension: :extraversion, direction: 1 },
    { id: 15, text: "I enjoy being the center of attention in social or work settings.", dimension: :extraversion, direction: 1 },
    { id: 16, text: "I prefer quiet, solitary activities over busy social gatherings.", dimension: :extraversion, direction: -1 },
    { id: 17, text: "I tend to keep my thoughts to myself rather than sharing them openly.", dimension: :extraversion, direction: -1 },
    { id: 18, text: "I find prolonged social interactions draining and need time alone to recharge.", dimension: :extraversion, direction: -1 },

    # Agreeableness (19-24)
    { id: 19, text: "I naturally empathize with others and try to understand their perspectives.", dimension: :agreeableness, direction: 1 },
    { id: 20, text: "I go out of my way to help colleagues or friends when they are in need.", dimension: :agreeableness, direction: 1 },
    { id: 21, text: "I value harmony and try to avoid conflict or arguments.", dimension: :agreeableness, direction: 1 },
    { id: 22, text: "I can be blunt or critical if it means getting the job done efficiently.", dimension: :agreeableness, direction: -1 },
    { id: 23, text: "I sometimes suspect that other people have hidden or selfish motives.", dimension: :agreeableness, direction: -1 },
    { id: 24, text: "I am not particularly interested in other people's personal challenges.", dimension: :agreeableness, direction: -1 },

    # Neuroticism (25-30)
    { id: 25, text: "I frequently feel anxious or stressed about upcoming deadlines or changes.", dimension: :neuroticism, direction: 1 },
    { id: 26, text: "I am easily upset or irritated when things do not go as planned.", dimension: :neuroticism, direction: 1 },
    { id: 27, text: "I often experience mood swings or feel overwhelmed by my emotions.", dimension: :neuroticism, direction: 1 },
    { id: 28, text: "I remain calm and level-headed even under high-pressure situations.", dimension: :neuroticism, direction: -1 },
    { id: 29, text: "I rarely worry about potential future problems that are out of my control.", dimension: :neuroticism, direction: -1 },
    { id: 30, text: "I recover quickly from setbacks and do not let stress affect me long-term.", dimension: :neuroticism, direction: -1 }
  ].freeze
end
