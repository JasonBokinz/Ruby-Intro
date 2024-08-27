# method that returns true if the element above is a 1
def element_above(grid, row, col)
    if (row > 0)
        return (grid[row - 1][col] == 1)
    else
        return false
    end
end
# method that returns true if the element below is a 1
def element_below(grid, row, col)
    if (row < grid.length - 1)
        return (grid[row + 1][col] == 1)
    else
        return false
    end
end
# method that returns true if the element to the left is a 1
def element_left(grid, row, col)
    if (col > 0)
        return (grid[row][col - 1] == 1)
    else
        return false
    end
end
# method that returns true if the element to the right is a 1
def element_right(grid, row, col)
    if (col < grid[0].length - 1)
        return (grid[row][col + 1] == 1)
    else
        return false
    end
end
# determines the number of overlap for the indices of that 1 value
def numOfOverLap(grid, row, col)
    overlap = 0
    if (element_above(grid, row, col))
        overlap += 1
    end
    if (element_below(grid, row, col))
        overlap += 1
    end
    if (element_right(grid, row, col))
        overlap += 1
    end
    if (element_left(grid, row, col))
        overlap += 1
    end
    return overlap
end
# determines the number of walls needed to block off the virus
def contain_virus(grid)
    walls = 0
    grid.each_with_index do |row, i|
        row.each_with_index do |element, j|
            if (element == 1)
                walls += 4 - numOfOverLap(grid, i, j)
            end
        end
    end
    walls
end


# Test Cases

isInfected = [[0,1,0,0],[1,1,1,0],[0,1,0,0],[1,1,0,0]]
result = contain_virus(isInfected)
puts "Number of walls needed: #{result}" # 16

isInfected2 =  [[0,1,0,0,0,0,0,1],[0,1,0,0,0,0,0,1],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0]]
result2 = contain_virus(isInfected2)
puts "Number of walls needed: #{result2}" # 14

isInfected3 = [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1]
  ]
result3 = contain_virus(isInfected3)
puts "Number of walls needed: #{result3}" # 16

isInfected4 = [
    [1, 0, 1],
    [0, 0, 0],
    [1, 0, 1]
  ]
result4 = contain_virus(isInfected4)
puts "Number of walls needed: #{result4}" # 16

isInfected5 = [
    [1, 0, 1],
    [0, 1, 0],
    [1, 0, 1]
  ]
result5 = contain_virus(isInfected5)
puts "Number of walls needed: #{result5}" # 20

  isInfected6 = [
    [1, 0, 1, 1],
    [0, 1, 1, 0],
    [1, 1, 0, 1]
  ]
result6 = contain_virus(isInfected6)
puts "Number of walls needed: #{result6}" # 22

isInfected7 = [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1]
  ]
result7 = contain_virus(isInfected7)
puts "Number of walls needed: #{result7}" # 16

isInfected8 = [
    [0, 0, 1],
    [0, 1, 1],
    [0, 1, 1]
  ]
result8 = contain_virus(isInfected8)
puts "Number of walls needed: #{result8}" # 10

isInfected9 = 
[
[0,0,0,0,0,0,0,0,1,1],
[1,0,0,0,1,0,0,0,0,1],
[1,0,0,0,1,0,0,0,0,0]]
result9 = contain_virus(isInfected9)
puts "Number of walls needed: #{result9}" # 20