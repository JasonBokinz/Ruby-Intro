require 'set'

class Region
    attr_accessor :infected, :uninfected, :walls
        
    def initialize
        @infected = Set.new
        @uninfected = Set.new
        @walls = 0
    end
end

# method that returns true if the element above is a 2 or -1
def element_above2(grid, row, col)
  if (row > 0)
      return ((grid[row - 1][col] == 2) || (grid[row - 1][col] == -1))
  else
      return true
  end
end
# method that returns true if the element below is a 2 or -1
def element_below2(grid, row, col)
  if (row < grid.length - 1)
      return ((grid[row + 1][col] == 2) || (grid[row + 1][col] == -1))
  else
      return true
  end
end
# method that returns true if the element to the left is a 2 or -1
def element_left2(grid, row, col)
  if (col > 0)
      return ((grid[row][col - 1] == 2) || (grid[row][col - 1] == -1))
  else
      return true
  end
end
# method that returns true if the element to the right is a 2 or -1
def element_right2(grid, row, col)
  if (col < grid[0].length - 1)
      return ((grid[row][col + 1] == 2) || (grid[row][col + 1] == -1))
  else
      return true
  end
end
# determines the number of overlap for the indices of that 1 value
def numOfOverLap2(grid, row, col)
  overlap = 0
  if (element_above2(grid, row, col))
      overlap += 1
  end
  if (element_below2(grid, row, col))
      overlap += 1
  end
  if (element_right2(grid, row, col))
      overlap += 1
  end
  if (element_left2(grid, row, col))
      overlap += 1
  end
  return overlap
end
# determines the number of walls needed to block off the virus
def contain_virus2(grid)
  walls = 0
  grid.each_with_index do |row, i|
      row.each_with_index do |element, j|
          if (element == 2)
              walls += 4 - numOfOverLap2(grid, i, j)
          end
      end
  end
  walls
end

def split_regions(is_infected)
    return [] if is_infected.empty? || is_infected[0].empty?
    visited = Array.new(is_infected.length) { Array.new(is_infected[0].length, false) }
    regions = []
    # Helper function for DFS
    def dfs(row, col, region, is_infected, visited)
        return if ((row < 0) || (row >= is_infected.length) || (col < 0) || (col >= is_infected[0].length) || (visited[row][col]) || (is_infected[row][col] != 1))

    visited[row][col] = true
    region << [row, col]

    dfs(row - 1, col, region, is_infected, visited)
    dfs(row + 1, col, region, is_infected, visited)
    dfs(row, col - 1, region, is_infected, visited)
    dfs(row, col + 1, region, is_infected, visited)
    end
  
    is_infected.each_with_index do |row, i|
      row.each_with_index do |element, j|
        if ((element == 1) && (!visited[i][j]))
          region = []
          dfs(i, j, region, is_infected, visited)
          regions << region
        end
      end
    end
    regions
end

def calculateThreat(is_infected, regions)
    threats = []
    regions.each do |array|
        newRegion = Marshal.load(Marshal.dump(is_infected))
        array.each do |coord|
            i, j = coord
            newRegion[i][j] = 2
        end
        threats << contain_virus2(newRegion)
    end
    threatIndex = threats.each_with_index.max[1]
    regions[threatIndex].each do |coord|
        i, j = coord
        is_infected[i][j] = -1
    end
    threats.max
  end

  def spread(is_infected)
    spread = []

    is_infected.each_with_index do |row, i|
      row.each_with_index do |element, j|
        if (element == 1)
          if ((i > 0) && (is_infected[i - 1][j] == 0))
            spread << [i - 1, j]
          end
          if ((i < is_infected.length - 1) && (is_infected[i + 1][j] == 0))
            spread << [i + 1, j]
          end
          if ((j > 0) && (is_infected[i][j - 1] == 0))
            spread << [i, j - 1]
          end
          if ((j < row.length - 1) && (is_infected[i][j + 1] == 0))
            spread << [i, j + 1]
          end
        end
      end
    end
    spread.each { |element| is_infected[element[0]][element[1]] = 1 }
  end

def contain_virus_bonus(is_infected)
    walls = 0
    while true
        regions = split_regions(is_infected)
        break if regions.empty?
        walls += calculateThreat(is_infected, regions)
        totalSpreaded = spread(is_infected)
    end
    return walls
end

# Example input, where 1 represents infected cells and 0 represents uninfected cells:
# isInfected = [
#   [0, 1, 0, 0, 1],
#   [0, 1, 0, 0, 1],
#   [0, 0, 0, 0, 1]
# ]

isInfected = [[0,1,0,0,0,0,0,1],[0,1,0,0,0,0,0,1],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0]]
result = contain_virus_bonus(isInfected)
puts "Number of walls needed: #{result}" # 10

isInfected2 = [[1,1,1],[1,0,1],[1,1,1]]
result2 = contain_virus_bonus(isInfected2)
puts "Number of walls needed: #{result2}" # 4

isInfected3 = [[1,1,1,0,0,0,0,0,0],
[1,0,1,0,1,1,1,1,1],
[1,1,1,0,0,0,0,0,0]]
result3 = contain_virus_bonus(isInfected3)
puts "Number of walls needed: #{result3}" # 13

isInfected8 = [
  [0, 0, 1],
  [0, 1, 1],
  [0, 1, 1]
]
result8 = contain_virus_bonus(isInfected8)
puts "Number of walls needed: #{result8}" # 4

isInfected5 = 
[
[1,0,0,0,1,0,0,0,0,0],
[1,0,0,0,1,0,0,0,1,1],
[1,0,0,0,1,0,0,0,0,0]]
result5 = contain_virus_bonus(isInfected5)
puts "Number of walls needed: #{result5}" # 6 + 5 + 3 = 14

isInfected6 = 
[
[1,0,0,0,1,0,0,0,0,0],
[1,0,0,0,1,0,0,0,1,1],
[1,1,0,0,1,0,0,0,0,0]]
result6 = contain_virus_bonus(isInfected6)
puts "Number of walls needed: #{result6}" # 6 + 5 + 3 = 14

# [1,1,0,0,-1,0,0,0,1,1]
# [1,1,0,0,-1,0,0,1,1,1]
# [1,1,1,0,-1,0,0,0,1,1]

# [1,1,0,0,-1,0,0,0,-1,-1]
# [1,1,0,0,-1,0,0,-1,-1,-1]
# [1,1,1,0,-1,0,0,0,-1,-1]

# [1,1,1,0,-1,0,0,0,-1,-1]
# [1,1,1,0,-1,0,0,-1,-1,-1]
# [1,1,1,1,-1,0,0,0,-1,-1]

isInfected7 = 
[
[0,0,0,0,0,0,0,0,1,1],
[1,0,0,0,1,0,0,0,0,1],
[1,0,0,0,1,0,0,0,0,0]]
result7 = contain_virus_bonus(isInfected7)
puts "Number of walls needed: #{result7}" # 5 + 5 + 4 = 14