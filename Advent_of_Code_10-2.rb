@input = "95
43
114
118
2
124
120
127
140
21
66
103
102
132
136
93
59
131
32
9
20
141
94
109
143
142
65
73
27
83
133
104
60
110
89
29
78
49
76
16
34
17
105
98
15
106
4
57
1
67
71
14
92
39
68
125
113
115
26
33
61
45
46
11
99
7
25
130
42
3
10
54
44
139
50
8
58
86
64
77
35
79
72
36
80
126
28
123
119
51
22".split("\n")

@input.map!(&:to_i).sort!
@input.insert(0, 0)
@differentials = {3 => 0, 2 => 0, 1 => 0}
@connection = 0
@total_joltage = 3
@outlet = 0
@joltage_counter = 0
@valid_connections = []
@path = 0

def connect_adapter
  @connect_adapter.each do |adapter|
    differential = adapter - @outlet
    #puts "#{adapter} - #{@outlet} = differential: #{differential}"
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
  "Total joltage = #{@total_joltage}"
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
  @paths = []
  @next_steps = []
  puts "VALID CONNECTIONS"
  @valid_connections.each do |connection_1, connection_2|
    puts "#{connection_1} : #{connection_2}"
    @paths.push(connection_1.to_i)
    @next_steps.push(connection_2.to_i)
  end
end



def build_connections
  @new_connections = Array.new
  @connection_tracker = 0
  @multiplier = [0]
  @connected = []
  @pathways = []
  @pathways_count = 0
  @test_connections = @valid_connections
  @valid_connections.each do |connection_1, connection_2|
    puts "----- ADAPTER: #{connection_1} : #{connection_2} ---- "
    prune_connected(connection_1)
    if connection_1 == 0
      @connected.push([connection_1, connection_2])
      @connection_tracker += 1
    end
    puts "---connected---"
    @connected.each_with_index do |connect|
      puts "#{connect}"
    end
    @pathways_count = @connected.length
    puts "Pathways: length #{@connected.length} (count: #{@pathways_count}), path count #{@multiplier}"

    check_connected(connection_1, connection_2)
    #puts "length: #{@connected.length}; #{connection_1}"

    puts "----- RETURNED ---- "

    # puts "Connection tracker: #{@connection_tracker}"
     puts
    #prune_connected(connection_1)
    @connection_memory = connection_1
  end
  final_prune
end

def final_prune
  @connected.delete_if do |connected|
    if connected.last != @valid_connections.last[1]
      true
    end
  end
  @multiplier.push(@connected.length)

  #@connected.each do |connected|
  #  puts "#{connected}"
  #end
end

def prune_connected(connection_1)
  if @connection_memory != connection_1
    #puts "Memory: #{@connection_memory} : #{connection_1}"
    #puts "old length : #{@connected.length}"
    @connected.delete_if do |connected|
      if connected.last < connection_1
      true
      end
    end
    if @connected.uniq.length == 1
      @multiplier.push(@connected.length)
      @connected.uniq!
    end
     # @connected.uniq! # [1, 1, 3, 4, 1, 2, 1]
   #puts "new length : #{@connected.length}"
  end
end


def check_connected(connection_1, connection_2)
  # check_and_clear(connection_1, connection_2)
    ## puts "Building connection"
  @connected.each do |connections|
    # puts "Connecting #{connections}, #{index}"
    ## puts "Branch: #{connection_1} : #{connection_2}"
    #puts "Checking: #{connections}"
    #if connections[-1] == connection_2 && connections[-2] == connection_1
      #puts "Breaking: #{connections}"
    #  break
    if connections[-1] == connection_1
    # puts  "Connecting to"
    # puts "#{connections}"
      @new_connections.clear
      @new_connections.push(connections).push(connection_2)
      # puts "New connection"
      # puts "#{@new_connections}"
      @connected.push(@new_connections.flatten.drop(1))
      diff = @pathways[- 1]
    else
      @connected.drop(1)
    end
     #  @connected.uniq! # [0, 1, 1, 1, 1, 3, 3, 4, 4, 3, 1, 1, 2, 2, 2, 1, 1, 1]
  end
end

def check_and_clear(connection_1, connection_2)
  if connection_2 - connection_1 == 1
    @pathways.push(@connected.length)
    # @connected.uniq!  # [0, 1, 1, 1, 1, 3, 3, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 1]
    puts "WE CAN CLEAR"
    @connected.each do |a, b|
      puts "#{a} - #{b}"
    end
  end
end

def differentials
  @final_connections = []
  @connected.each do |connection|
   # puts "CONNECTIONS: #{index} - #{connection}"
    @differentials = {3 => 0, 2 => 0, 1 => 0}
    @total_joltage = 0
    @connect_adapter = connection
    connect_adapter
    adapter_total
    # puts @total_joltage
    if @total_joltage == @final_joltage
      @final_connections.push(connection)
    end
  end
end

def path_finder
  puts "Paths: #{@paths}"
  puts "Steps: #{@next_steps}"
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
  connection_builder
  # path_finder
end

def connection_builder
  build_connections
  @total_joltage = 0
  # differentials
  #puts @final_connections.length
  #puts "FINAL CONNECTIONS"
  #@final_connections.each_with_index do |connection, index|
  #  puts "#{index+1}: #{connection}"
  #end
  #puts  @differentials
  #puts adapter_total
  puts @multiplier.reject(&:zero?).inject(:*)
end


adapter_checker
