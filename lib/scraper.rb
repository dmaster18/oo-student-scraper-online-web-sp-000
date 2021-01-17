require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  @@all = []
  
  def self.all
    @@all
  end
  
  @@profile_urls = []
  
  def self.profile_urls
    @@profile_urls
  end
  
  def self.scrape_index_page(index_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")
     doc = Nokogiri::HTML(open(index_url))
     doc.css(".student-card").each { |student_card|
      student_hash = {
        name: student_card.css(".student-name").text,
        location: student_card.css(".student-location").text,
        profile_url: student_card.css("a")[0]["href"]
          }
       student = Student.new(student_hash)
       Student.all << student
     }
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    social_detail = doc.css(".social-icon-container").css("a")
    attributes_hash = {
      twitter: social_detail[0]["href"],
      linkedin: social_detail[1]["href"],
      github: social_detail[2]["href"],
      profile_quote: doc.css(".profile-quote").text,
      bio: doc.css('.description-holder').css('p').text,
      name: doc.css('.profile-name').text,
      }
  end  
  
end

class Student ##student class

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []
  
  def initialize(student_hash)
    @name = student_hash[:name]  
    @location = student_hash[:location]  
    @profile_url = student_hash[:profile_url]
  end

  def self.create_from_collection(students_array = Scraper.scrape_index_page)
    students_array
    all
  end

  def add_student_attributes(attributes_hash = Scraper.scrape_profile_page)
      if self.name == attributes_hash[:name] 
        @twitter = attributes_hash[:twitter]
        @linkedin = attributes_hash[:linkedin]
        @github = attributes_hash[:github]
        @profile_quote = attributes_hash[:profile_quote]
        @bio = attributes_hash[:bio]
      end
  end

  def self.all
    @@all
  end
end


binding.pry

