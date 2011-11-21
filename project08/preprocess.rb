#! /usr/bin/env ruby

#this file contains a few scripts to manipulate the mushroom.data.csv


####################################################################################################
#Create  csv weka doesn't scream at

readfile = File.open('mushroom.data.csv','r') 
writefile = File.open('mushroomWeka.csv','w')

columnNames = "'poisonus','cap-shape','cap-surface','cap-color','bruised','odor','gill-attachment','gill-spacing','gill-size','gill-color','stalk-shape','stalk-root','stalk-surface-above-ring','stalk-surface-below-ring','stalk-color-above-ring','stalk-color-below-ring','veil-type','veil-color','ring=number','ring-type','spore-print-color','population','habitat'"
writefile.write(columnNames+"\n")


while line=readfile.gets #for every line in the file
	line = line[0..-2]
	items = line.split(',')
	newline = items.join('\',\'')
	newline = "'"+ newline + "'\n"
	writefile.write(newline)
end

readfile.close()
writefile.close()


#end create aarf
####################################################################################################



####################################################################################################
#Create  csv weka doesn't scream at

readfile = File.open('mushroom.data.csv','r') 
writefile = File.open('mushroomWekaRand.csv','w')

columnNames = "'poisonus','cap-shape','cap-surface','cap-color','bruised','odor','gill-attachment','gill-spacing','gill-size','gill-color','stalk-shape','stalk-root','stalk-surface-above-ring','stalk-surface-below-ring','stalk-color-above-ring','stalk-color-below-ring','veil-type','veil-color','ring=number','ring-type','spore-print-color','population','habitat'"
writefile.write(columnNames+"\n")

outArray = Array.new
while line=readfile.gets #for every line in the file
	line = line[0..-2]
	items = line.split(',')
	newline = items.join('\',\'')
	newline = "'"+ newline + "'\n"
	outArray.push(newline)
	
end
outArray.shuffle!

#spit it out in a random way
outArray.each  {|out| writefile.write(out)}


readfile.close()
writefile.close()


#end create aarf
####################################################################################################

####################################################################################################
#Create  aarf

readfile = File.open('mushroom.data.csv','r') 
writefile = File.open('mushroom.arff','w')

headder = "   @RELATION mushroom

   @ATTRIBUTE class	{e,p}
   @ATTRIBUTE class	{b,c,x,f,k,s}
   @ATTRIBUTE class	{f,g,y,s}
   @ATTRIBUTE class	{n,b,c,g,r,p,u,e,w,y}
   @ATTRIBUTE class	{t,f}
   %5
   @ATTRIBUTE class	{a,l,c,y,f,m,n,p,s}
   @ATTRIBUTE class	{a,d,f,n}
   @ATTRIBUTE class	{c,w,d}
   @ATTRIBUTE class	{b,n}
   @ATTRIBUTE class	{k,n,b,h,g,r,o,p,u,e,w,y}
   %10
   @ATTRIBUTE class	{e}
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   %15
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   @ATTRIBUTE class	
   %20
   "




while line=readfile.gets #for every line in the file
	writefile.write(line)
end

readfile.close()
writefile.close()













#end create aarf
####################################################################################################

####################################################################################################
#Create detailed aarf

readfile = File.open('mushroom.data.csv','r') 
writefile = File.open('mushroom.arff','w')

while line=readfile.gets #for every line in the file
	elements = line.split(',') 
	


	# poisonous or not
	letter = elements[0]
	case letter
	when 'e'; elements[0] = 'edible'
	when 'p'; elements[0] = 'poisonous'
	end
	

	# cap shape
	case elements[1]
	when 'b'; elements[1]='bell'
	when 'c'; elements[1]='conical'
	when 'x'; elements[1] = 'convex'
	when 'f'; elements[1] = 'flat'
	when 'k'; elements[1] = 'knobbed'
	when 's'; elements[1] = 'sunken'
	end
	
	#cap surface
	case elements[2]
	when 'f'; elements[2]='fibrous'
	when 'g'; elements[2] = 'grooves'
	when 'y'; elements[2] = 'scaly'
	when 's'; elements[2] = 'smooth'
	end
	
	writefile.write(elements.join(','));
			
end

readfile.close()
writefile.close()













#end create detailed aarf
####################################################################################################