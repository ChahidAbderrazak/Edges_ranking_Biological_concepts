#%% Packages and functions 
import matplotlib.pyplot as plt
import numpy as np
import pandas

#%% Useful commands
# variables
x = 3+5j
print(x)
print(type(x))

# Casting
x = int("3") # z will be 3
print(x)

x = str(3.6) # z will be 3
print(x)

# The strip() method removes any whitespace from the beginning or the end:
a = " Hello, World! "
print(a.strip()) # returns "Hello, World!"
print(a.replace("H", "J"))

# Operators
x=3
y=x**3
print(y/3)
print(y%3)
print(y//3)

#%% Arrays
cars = ["Ford", "Volvo", "BMW"]
print(cars)
# List 
thislist = ["apple", "banana", "cherry"]
if "apple" in thislist:
  print("Yes, 'apple' is in the fruits list")
  
print(len(thislist))
thislist.append("orange")
print(thislist)
 
thislist.insert(1, "orange1")
thislist.remove("orange1")
print(thislist)

fruits = thislist
print(fruits)

x = fruits.count("cherry")
print(x)

x=list(range(0,3))
x.insert(2,5)
x.sort()
print(x)

# Create and print a dictionary:
dict =	{
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
print(dict)

#%% Python Conditions and   statements
# if statements
a = 200
b = 33
if b > a:
  print("b is greater than a")
elif a == b:
  print("a and b are equal")
else:
  print("a is greater than b")

# for loop
    # Do not print banana:
fruits = ["apple", "banana", "cherry"]
for x in fruits:
  if x == "banana":
    continue
  print(x)
  
  
  
#%% Function 
#A lambda function that adds 10 to the number passed in as an argument, and print the result:

x = lambda a : a + 10
print(x(5))

#%% Classes

class Person:
    def __init__(self, fname, lname):
        self.firstname = fname
        self.lastname = lname
    def printname(self):
        print(self.firstname, self.lastname)
#-------------------------------------------------------------
x = Person("John", "Doe")
x.printname()

# Child class
class Student(Person):
    def __init__(self, fname, lname, year):
        Person.__init__(self, fname, lname)
        self.graduationyear = year
        
    def welcome(self):
        print("Welcome", self.firstname, self.lastname, "to the class of", self.graduationyear)
#-------------------------------------------------------------

x = Student("Mike", "Olsen", 2019)
x.welcome()
#%% END  
