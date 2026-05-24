# Clear existing database
puts "Clearing database..."
JobApplication.destroy_all
JobOffer.destroy_all
PersonalityTestResult.destroy_all
WorkExperience.destroy_all
Education.destroy_all
ApplicantProfile.destroy_all
User.destroy_all

puts "Creating users..."

# Create Recruiter
recruiter = User.create!(
  email: "recruiter@nexhire.com",
  password: "password",
  password_confirmation: "password",
  role: :recruiter
)
puts "Created Recruiter: #{recruiter.email}"

# Create Applicant 1 (Valid test scores, full profile)
applicant1 = User.create!(
  email: "applicant1@nexhire.com",
  password: "password",
  password_confirmation: "password",
  role: :applicant
)
puts "Created Applicant 1: #{applicant1.email}"

profile1 = applicant1.applicant_profile
profile1.update!(
  name: "John Doe",
  skills: "Ruby on Rails, React, PostgreSQL, Tailwind CSS, System Architecture"
)

profile1.work_experiences.create!(
  company: "Stripe",
  position: "Senior Rails Engineer",
  start_date: 3.years.ago.to_date,
  end_date: 1.year.ago.to_date,
  current: false,
  description: "Designed and scaled core billing APIs in Ruby on Rails. Maintained high reliability and speed."
)

profile1.work_experiences.create!(
  company: "Airbnb",
  position: "Staff Software Engineer",
  start_date: 1.year.ago.to_date,
  current: true,
  description: "Lead engineer for guest checkout experience team. Mentored junior devs and improved frontend performance using Hotwire."
)

profile1.educations.create!(
  school: "Stanford University",
  degree: "Bachelor of Science",
  field_of_study: "Computer Science",
  start_date: Date.new(2016, 9, 1),
  end_date: Date.new(2020, 6, 1),
  description: "Graduated with honors. Specialization in database systems."
)

# Add valid personality test result (taken 5 days ago)
applicant1.personality_test_results.create!(
  completed_at: 5.days.ago,
  openness: 85,
  conscientiousness: 90,
  extraversion: 60,
  agreeableness: 80,
  neuroticism: 15
)
puts "Added active test results for John Doe"


# Create Applicant 2 (Expired test scores, minimal profile)
applicant2 = User.create!(
  email: "applicant2@nexhire.com",
  password: "password",
  password_confirmation: "password",
  role: :applicant
)
puts "Created Applicant 2: #{applicant2.email}"

profile2 = applicant2.applicant_profile
profile2.update!(
  name: "Jane Smith",
  skills: "Python, Django, AWS, React, Docker"
)

profile2.work_experiences.create!(
  company: "Netflix",
  position: "Software Engineer II",
  start_date: 2.years.ago.to_date,
  current: true,
  description: "Building streaming infrastructure scaling to millions of active concurrent users."
)

# Add expired test result (taken 100 days ago)
applicant2.personality_test_results.create!(
  completed_at: 100.days.ago,
  openness: 70,
  conscientiousness: 60,
  extraversion: 75,
  agreeableness: 65,
  neuroticism: 40
)
puts "Added expired test results (100 days ago) for Jane Smith"


# Create Job Offers
puts "Creating Job Offers..."

job1 = JobOffer.create!(
  recruiter: recruiter,
  title: "Senior Product Engineer (Rails/Hotwire)",
  company_name: "Nexhire Tech",
  description: "We are seeking a seasoned engineer who loves Ruby on Rails, Hotwire/Turbo, and crafting clean, animated Tailwind CSS interfaces. You will have high autonomy, work directly with design partners, and define product features from scratch.",
  location: "New York, NY (Hybrid)",
  salary: "$140,000 - $180,000",
  ideal_openness: 80,
  ideal_conscientiousness: 85,
  ideal_extraversion: 50,
  ideal_agreeableness: 70,
  ideal_neuroticism: 20
)

job2 = JobOffer.create!(
  recruiter: recruiter,
  title: "Lead Product Manager",
  company_name: "Nexhire Analytics",
  description: "Looking for an outbound-focused product leader who excels in cross-functional collaboration, customer interviews, and strategic roadmap development. Must be highly empathetic, structured, and curious.",
  location: "Remote (US)",
  salary: "$160,000 - $200,000",
  ideal_openness: 90,
  ideal_conscientiousness: 80,
  ideal_extraversion: 80,
  ideal_agreeableness: 75,
  ideal_neuroticism: 25
)
puts "Created Job Offers"

# Apply John Doe to Senior Product Engineer
# (Jane Smith cannot apply yet because her test has expired, simulating the system constraint)
puts "Applying John Doe to Senior Product Engineer..."
JobApplication.create!(
  applicant: applicant1,
  job_offer: job1,
  status: "pending"
)
puts "Done! Seed complete."
