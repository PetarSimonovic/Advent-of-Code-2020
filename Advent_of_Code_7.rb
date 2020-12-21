@input = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.".gsub!("bags","").gsub!("contain", "").gsub!("bag", "").gsub!(".","").gsub!(",", "").gsub!("  "," ").gsub!("  ", " ").gsub!("no other", "0").split("\n")

@rule_book = []
@rule_splitter = []


def split_rules
  @input.each do |bag_rule|
    split_rules = bag_rule.split(" ")
    @rule_splitter.push(split_rules)
  end
end

def bag_rules
  @rule_splitter.each do |rule|
    @bag_rules = Hash.new
    container_colour = rule[0] + " " + rule[1]
    @bag_rules[:container] = container_colour
    @bag_rules[:amount_1] = rule[2]
    if rule.length > 4
      content_colour_1 = rule[3] + " " + rule[4]
      @bag_rules[:colour_1] = content_colour_1
    else
      @bag_rules[:colour_1] = nil
    end
    if rule.length > 5
      @bag_rules[:amount_2] = rule[5]
      content_colour_2 = rule[6] + " " + rule[7]
      @bag_rules[:colour_2] = content_colour_2
    else
      @bag_rules[:amount_2] = nil
      @bag_rules[:colour_2] = nil
    end
    @rule_book.push(@bag_rules)
  end
end

def bag_checker
  @count = []
  @count_unique =[]
  @indirect_colours = []
  @rule_book.each do |bag_checker|
    puts bag_checker
    check_direct_colours(bag_checker)
  end
  @rule_book.each do |bag_checker_indirect|
    check_indirect_colours(bag_checker_indirect)
  end
  @count_unique = @count.uniq
  puts @count_unique
  puts "Total colour combinations: #{@count_unique.length}"
end

def check_direct_colours(bag_checker)
  if bag_checker[:colour_1] != nil && bag_checker[:colour_1] == @colour
    puts "#{bag_checker[:container]} can hold #{bag_checker[:colour_1]}"
    @count.push(bag_checker[:container])
    @indirect_colours.push(bag_checker)
  end
  if bag_checker[:colour_2] != nil && bag_checker[:colour_2] == @colour
    puts "#{bag_checker[:container]} can hold #{bag_checker[:colour_2]}"
    @count.push(bag_checker[:container])
    @indirect_colours.push(bag_checker)
  end
end

def check_indirect_colours(bag_checker_indirect)
  @indirect_colours.each do |container_check|
    if bag_checker_indirect[:colour_1] != nil && bag_checker_indirect[:colour_1] == container_check[:container]
      puts "#{bag_checker_indirect[:container]} can hold #{bag_checker_indirect[:colour_1]}"
     @count.push(bag_checker_indirect[:container])
    end
    if bag_checker_indirect[:colour_1] != nil && bag_checker_indirect[:colour_2] == container_check[:container]
      puts "#{bag_checker_indirect[:container]} can hold #{bag_checker_indirect[:colour_2]}"
      @count.push(bag_checker_indirect[:container])
    end
  end
end


split_rules
bag_rules
@colour = "shiny gold"
bag_checker
