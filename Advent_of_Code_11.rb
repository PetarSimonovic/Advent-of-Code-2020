@input = "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL".split("\n")

@seats = []


@x_axis = {
  left: -1,
  centre: 0,
  right: 1
}

@y_axis = {
  top: -1,
  centre: 0,
  down: 1
}


def get_seats
  @input.each do |row|
    seats = row.split("")
    @seats.push(seats)
    @width = seats.length
    @seat_storage = []
  end
  @length = @seats.length - 1
end

def analyse_seats
  y = 0
  @seats.each do |seat_row|
    puts "Y #{y}"
    x = 0
    @length.times do
      puts "x = #{x} : @length = #{@length}"
      seat_row = @seats[y]
      puts "Original: #{seat_row}"
      @new_seat_row = seat_row
      puts "#{@new_seat_row}"
      @current_seat = @new_seat_row[x]
      puts "Current seat: #{@current_seat}"
      check_adjacent_seats(x, y)
      change_seat
      puts "Current seat has become: #{@current_seat}"
      @new_seat_row[x] = @current_seat
      puts "Changed: #{@new_seat_row}"
      x += 1
      puts
    end
    y += 1
    @seat_storage.push(@new_seat_row)
  end
end

def check_adjacent_seats(x, y)
  @occupied = 0
  @all_empty = true
  top_left(x, y)
  top(x, y)
  top_right(x, y)
  right(x, y)
  down_right(x, y)
  down(x, y)
  down_left(x, y)
  left(x, y)
  puts @occupied
  puts @all_empty
end

def top_left(x, y)
  unless y == 0 or x == 0
    row_check = @seats[y - 1]
    seat = row_check[x - 1]
    puts "Top Left: #{seat}"
    check_seat(seat)
  end
end

def top(x, y)
  unless y == 0
    row_check = @seats[y - 1]
    seat = row_check[x]
    puts "Top: #{seat}"
    check_seat(seat)
  end
end

def top_right(x, y)
  unless y == 0 || x >= @width
    row_check = @seats[y - 1]
    seat = row_check[x + 1]
    puts "Top Right: #{seat}"
    check_seat(seat)
  end
end

def right(x, y)
  unless x > @width
    row_check = @seats[y]
    seat = row_check[x + 1]
    puts "Right: #{seat}"
    check_seat(seat)
  end
end

def down_right(x, y)
  unless x > @width || y > @length
    row_check = @seats[y]
    seat = row_check[x + 1]
    puts "Down Right: #{seat}"
    check_seat(seat)
  end
end

def down(x, y)
  unless y >= @length
    row_check = @seats[y + 1]
    seat = row_check[x]
    puts "Down: #{seat}"
    check_seat(seat)
  end
end

def down_left(x, y)
  unless y >= @length || x == 0
    row_check = @seats[y + 1]
    seat = row_check[x - 1]
    puts "Down Left: #{seat}"
    check_seat(seat)
  end
end

def left(x, y)
  unless x == 0
    row_check = @seats[y]
    seat = row_check[x - 1]
    puts "Left: #{seat}"
    check_seat(seat)
  end
end

def check_seat(seat)
  if seat == "#"
    @all_empty == false
    @occupied += 1
  end
end

def change_seat
  puts "Changing seat"
  if @current_seat == "L"
    empty_seat_change
  elsif @current_seat == "#"
    occupied_seat_change
  end
end

def empty_seat_change
  puts  "Empty seat change taking place"
  if @all_empty == true
    @current_seat = "#"
    puts "Changing to occupied: current seat is #{@current_seat}"
  end
end

def occupied_seat_change
  puts "Occupied seat change taking place"
  if @occupied >= 4
    @current_seat = "L"
  end
end

def show_seat_changes
  @seat_storage.each do |new_row|
    puts "#{new_row}"
  end
end

get_seats
analyse_seats
show_seat_changes
