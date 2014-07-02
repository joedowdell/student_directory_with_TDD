require 'date'

def show(string)
   puts string
end

def take_user_input
 	gets.chomp
end

def ask_for_data (info_needed)
	show("Please enter #{info_needed}.")
end


def is_cohort_valid?(string)
	Date::MONTHNAMES.compact.include?(string.downcase.capitalize)
end

def create_student(name, cohort)
	{name: name, cohort: cohort.downcase.capitalize.to_sym}
end

def students
	@students ||= []
end

def add_student_to_list(new_student)
	students << new_student
end


def get_input (data_type)
	if data_type=="cohort"
		ask_for_data (data_type)
		user_input = take_user_input
		until is_cohort_valid?(user_input)
			print "Sorry that doesn't look like a month. "
			ask_for_data (data_type)
			user_input = take_user_input
		end
	else 
		ask_for_data (data_type)
		user_input = take_user_input
	end
	return user_input
end

def get_details_of_new_student
	name, cohort = get_inputs(["student's name", "cohort"])
	create_student(name, cohort)
	# puts "the students are ------ #{students}"
end


def get_inputs(input_list)
	input_list.map {|input_type| get_input(input_type)}
end

def input_students
	show('Would you like to add a new student ("Y") or finish ("N")')
	selection = take_user_input.upcase
 	process_user_choice(selection)
end

def process_user_choice selection
	case selection
	when "Y"
		new_student = get_details_of_new_student
		add_student_to_list(new_student)
		input_students
	when "N"
		 print_footer(students)
	else
		puts "try again"
		input_students
	end
end

def print_student(student)
	show("#{student[:name].capitalize} is in the #{student[:cohort].capitalize} cohort")
end

def print_student_list(students)
	students.each do |student|
		print_student(student)
	end
end

def select_by_month(month, students)
	students.select{|student| student[:cohort]==month.to_sym}
end

def print_students_by_month students
	Date::MONTHNAMES.compact.each do |month|
		selected_month_students = select_by_month(month,students)
		if selected_month_students.length!=0
			print_month_header month
			print_student_list(selected_month_students)
			puts ""
		end
	end
end

def print_month_header month
	show month
	show "---------"
end

def print_header
	show "The students at Makers Academy are:\n====================================="
	puts ""
end

def print_footer(students)
	if students.length == 1
		show "There is #{students.length} student in the directory"
	else
		show "There are #{students.length} students in the directory"
	end
end

def student_to_csv (student)
	[student[:name],student[:cohort].to_s]
end

require 'csv'

def save_students_to_file(students)
	CSV.open("./student.csv", "wb") do |csv|
		students.each do |student|
			csv << student_to_csv(student)
		end
	end
end

def load_students_from_csv
	CSV.foreach("./student.csv") do |row|
	  new_student = create_student(row[0],row[1])
	  add_student_to_list(new_student)
	end
end

	
# input_students
# load_students_from_csv
# print_students_by_month(students)
# save_students_to_file(students)












