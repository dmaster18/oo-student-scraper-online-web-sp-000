require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = doc.css(".student-card") 
    created_students = students.map {|student| 
      {profile_url: student.css("a").first.attributes["href"].value, name: student.css(".student-name").children.text, location: student.css(".student-location").children.text}
    }
  end
 

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = doc.css(".main-wrapper")
    created_student = student.map {|student|
      {:twitter => student.css('.social-icon-container a')[0].attributes['href'].value, :linkedin => student.css('.social-icon-container a')[1].attributes['href'].value, 
        :github => student.css('.social-icon-container a')[2].attributes['href'].value, :blog=>"http://joemburgess.com/", 
        :profile_quote=> student.css(".profile-quote").children.text, :bio=> student.css('.description-holder').children.text
      }
    }
    created_student[0]
  end

end


