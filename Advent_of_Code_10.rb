@input = "16
10
15
5
1
11
7
19
6
12
4".split("\n")

@input.map!(&:to_i).sort!
@input.insert(0, 0)
@differentials = {3 => 0, 2 => 0, 1 => 0}
@connection = 0
@total_joltage = 3
@outlet = 0
@joltage_counter = 0
@valid_connections = []

def connect_adapter
  @connect_adapter.each do |adapter|
    differential = adapter - @outlet
    update_differentials(differential)
    @outlet = adapter
  end
end

def update_differentials(differential)
  if differential == 1
    @differentials[1] += 1
  elsif differential == 2
    @differentials[2] += 1
  else
    @differentials[3] += 1
  end
end

def adapter_total
  threes = @differentials[3] * 3
  twos = @differentials[2] * 2
  ones = @differentials[1] * 1
  @total_joltage = threes.to_i + twos.to_i + ones.to_i
  ## puts "Total joltage = #{@total_joltage}"
end


def connections
  z = 1
  @input.each_with_index do |adapter, index|
    until index + z >= @input.length
      connections = [adapter]
      # puts "Checking #{adapter} against #{@input[index + z]}"
      differential = @input[index + z] - adapter
      if check_validity(differential) == true
      #   puts "Adding connection"
        connections.push(@input[index + z])
        check_connections(connections)
      end
      z += 1
    end
    z = 1
  end
end

def check_validity(differential)
  if differential <= 3
   return true
  else
    return false
  end
end



def check_connections(connections)
  #  print connections
  @valid_connections.push(connections)
 #   print @valid_connections
end

def validity_printer
  puts "VALID CONNECTIONS"
  @valid_connections.each do |connection_1, connection_2|
    puts "#{connection_1} : #{connection_2}"
  end
end



def build_connections
  @connected = []
  @all_connections = []
  @test_connections = @valid_connections
  @index = 0
  @valid_connections.each do |connection_1, connection_2|
    prune_connected(connection_1)
    @test_connections.drop(1)
    @index += 1
    if connection_1 == 0
      @connected.push([connection_1, connection_2])
    end
    puts "----- ADAPTER: #{connection_1} : #{connection_2} ---- "
    test_connection(connection_1, connection_2)
    puts "length: #{@connected.length}; #{connection_1}"
    puts "----- RETURNED ---- "
    @connected.uniq!
   ## @connected.each_with_index do |connect, index|
    ## puts "#{index}: #{connect}"
    ## end
  end
end

def prune_connected(connection_1)
  # puts "old length : #{@connected.length}"
  @connected.delete_if do |connected|
    if connection_1 != 0 && connected[-1] < connection_1
      #put"connection_1 = #{connection_1}; last element = #{connected[-1]}"
      true
    end
  end
    puts "new length : #{@connected.length}"
    @connected.each_with_index do |connect, index|
      puts "#{index}: #{connect}"
    end
    puts
end

def test_connection(connection_1, connection_2)
   @test_connections.each do |socket_1, socket_2|
    if socket_1 == connection_2
     puts "Connection_2 #{connection_2} CONNECTS TO socket_1: #{socket_1} - #{socket_2}"
      check_connected(connection_1, connection_2, socket_1, socket_2)
    elsif socket_1 > connection_2
      break
    end
  end
end

def check_connected(connection_1, connection_2, socket_1, socket_2)
    ## puts "Building connection"
  @connected.each_with_index do |connections|
    ## puts "Branch: #{connection_1} : #{connection_2}"
    ##  puts "Checking: #{connections}"
    if connections[-1] == socket_1
    ## puts  "Adding connection"
      x = Array.new
      x.push(connections)
      x.push(socket_2)
      x.flatten!
      @connected.push(x)
    end
  end
end


def differentials
  @final_connections = []
  @connected.each_with_index do |connection, index|
    puts "CONNECTIONS: #{index} - #{connection}"
    @differentials = {3 => 0, 2 => 0, 1 => 0}
    @total_joltage = 0
    @connect_adapter = connection
    connect_adapter
    adapter_total
    puts @total_joltage
    if @total_joltage == @final_joltage
      @final_connections.push(connection)
    end
  end
end

def adapter_checker
  @connect_adapter = @input
  connect_adapter
  puts @differentials
  adapter_total
  connections
  @final_joltage = @total_joltage
  puts "Final joltage : #{@final_joltage}"
  validity_printer
  build_connections
  @connected.uniq!
  @total_joltage = 0
  differentials
  puts @final_connections.length
  ## puts "FINAL CONNECTIONS"
##   @final_connections.each_with_index do |connection, index|
##   puts "#{index+1}: #{connection}"
 ##end
end

adapter_checker
