# QUESTION 1:
def isValid(s):

    # charDict: 
    # keys = the character, 
    # values = number of occurences of a specifc character

    #Understanding:
    # character {key} occurs {value} times
    if (s == ""):
        return "YES"
    charDict = {}
    for ch in s:
        if ch in charDict:
            charDict[ch] += 1
        else:
            charDict[ch] = 1

    # occurrenceDict: 
    # keys = number of occurences of a NON-specifc a character, 
    # values = number of characters w/ the same num of occurences
    
    # Understanding: 
    # A character size of {value} occurs a total of {key} times
    occurrenceDict = {}
    
    for count in charDict.values():
        if count in occurrenceDict:
            occurrenceDict[count] += 1
        else:
            occurrenceDict[count] = 1

    if len(occurrenceDict) == 1:
        return "YES"
    elif (len(occurrenceDict) == 2) and (1 in occurrenceDict.values()):
        return "YES"
    return "NO"

# QUESTION 2:

# Method used to check open brack w/ closed bracket
def flipBracket(s):
    if s == "{":
        return "}"
    elif s == "(":
        return ")"
    else:
        return "]"
    
def isBalanced(s):
    stack = []
    open = "{[("

    for each in s:
        if each in open:
            stack.append(each)
        else:
            if (len(stack) != 0) and (each == flipBracket(stack.pop())):
                continue
            else:
                return "NO"
    return "YES"

# QUESTION 3

class Node:

    # Instance of Node method
    def __init__(self, label , left=None, right=None):
        self.label = label
        self.left = left
        self.right = right

    # Preorder traversal
    def preOrder(self):
        traversal = []
        if self != None:
            # Root
            traversal.append(self.label)
            # Left
            if self.left != None:
                traversal.extend(self.left.preOrder())
            # Right
            if self.right != None:
                traversal.extend(self.right.preOrder())
        return traversal
    
    # Inorder traversal
    def inOrder(self):
        traversal = []
        if self != None:
            # Left
            if self.left != None:
                traversal.extend(self.left.inOrder())
            # Root
            traversal.append(self.label)
            # Right
            if self.right != None:
                traversal.extend(self.right.inOrder())
        return traversal
    
    # Postorder traversal
    def postOrder(self):
        traversal = []
        if self != None:
            # Left
            if self.left != None:
                traversal.extend(self.left.postOrder())
            # Right
            if self.right != None:
                traversal.extend(self.right.postOrder())
            # Root
            traversal.append(self.label)
        return traversal

    # Determines the height of the node in the tree
    def getHeight(self, label, search=0):
        # Base case
        if (self != None) and (self.label == label):
            return search
        rightSide = -1
        leftSide = -1
        if (self != None):
            # Recurse through right tree of the node
            if self.right != None:
                rightSide = self.right.getHeight(label, search+1)
            # If found in right side
            if rightSide != -1:
                return rightSide
            # Recurse through left tree of the node
            if self.left != None:
                leftSide = self.left.getHeight(label, search+1)
            # Must be on left side if label exists
            return leftSide
        # Root is null
        return None

    def sumTree(self):
        # Base Cases
        if self == None:
            return 0
        # Recurse right subtree and get sum
        if self.right != None:
            rightSide = self.right.sumTree()
        else:
            rightSide = 0
        # Recurse left subtree and get sum
        if self.left != None:
            leftSide = self.left.sumTree()
        else:
            leftSide = 0

        return self.label + rightSide + leftSide