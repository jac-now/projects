r = float(input("Enter rent : "))
u = float(input("Enter utilities : "))
f = float(input("Enter your monthly food and fuel costs : "))
j = float(input("Enter your personal monthly bills : "))
s = float(input("Enter your partner\'s personal monthly bills : "))
jp = float(input("Enter your semi-monthly pay : "))
sp = float(input("Enter your partner\'s biweekly pay : "))
print ("Costs per day")
r=r*12/365
print (f'Rent costs ${r:.2f} per day')
u=u*12/365
print (f'Utilities costs ${u:.2f} per day')
j=j*12/365
print (f'Your bills cost ${j:.2f} per day')
s=s*12/365
print (f'Your partner\'s bills cost ${s:.2f} per day')
f=f*12/365
print (f'Food and Fuel costs ${f:.2f} per day')
t=r+u+j+s+f
print (f'Total cost is ${t:.2f} per day')
jp=jp*24/365
print (f'Your pay brings in ${jp:.2f} per day after taxes')
sp=sp*26/365
print (f'Your partner\'s pay brings in ${sp:.2f} per day after taxes')
pay=jp+sp
print (f'Your combined income is ${pay:.2f} per day after taxes')
net=pay-t
if net > 0.1:
    print (f'You can survive with a gain of ${net:.2f} per day')
elif net < 0:
    print (f'You cannot survive you have a deficit of ${net:.2f} per day')
else:
    print ('You just break even')

####TO DO####
#Improve overall readability
#Make variable names self explanatory
#Add branches for monthly, weekly, or daily breakdowns
#
