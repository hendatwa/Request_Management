.data 

char: .asciiz "character: "
priority: .asciiz "priority: "
newline: .asciiz "\n"
.align 2  # asking for 2^2=4 byte alignment
list1: .space 164 # list contain chars,their priorities and size of list
                  #(priority,char--priority,char....),priority of first char in (0),char in 4 ...etc and size of list in 160
.align 2  # asking for 2^2=4 byte alignment
list2: .space 164 # list contain chars,their priorities and size of list
                  #(priority,char--priority,char....),priority of first char in (0),char in 4 ...etc and size of list in 160
.align 2  # asking for 2^2=4 byte alignment
list3: .space 164  # list contain chars,their priorities and size of list
                  #(priority,char--priority,char....),priority of first char in (0),char in 4 ...etc and size of list in 160
.align 2  # asking for 2^2=4 byte alignment
list4: .space 164  # list contain chars,their priorities and size of list
                  #(priority,char--priority,char....),priority of first char in (0),char in 4 ...etc and size of list in 160
.align 2  # asking for 2^2=4 byte alignment
arr: .space 640 # array for processing all requests                
                  
.align 2  # asking for 2^2=4 byte alignment
entry: .space 8 # array for processing all requests                    

.align 2 
entry: .space 8 
string: .asciiz "list is full\n" 

.text 
.globl main

main:
   la $a0,list1
   jal createlist
   la $a0,list2
   jal createlist
   la $a0,list3
   jal createlist
   la $a0,list4
   jal createlist
   while:
   la $a0,list1
   jal isfull 
   beq $v0,1,else 
   la $a0,list2
   jal isfull 
   beq $v0,1,else 
   la $a0,list3
   jal isfull 
   beq $v0,1,else 
   la $a0,list4
   jal isfull 
   beq $v0,1,else 
   li      $v0,4                     # code 4 == print string
   la      $a0,string1  # $a0 == address of the string
   syscall 
   li $v0,12
   syscall
   addi $t0,$zero,0
   sw $v0,entry($t0)
   li $v0,12
   syscall
   li      $v0,4                     # code 4 == print string
   la      $a0,string2  # $a0 == address of the string
   syscall 
   li $v0,5
   syscall
   addi $t0,$zero,4
   sw $v0,entry($t0)
   la $a0,list1
   jal isfull
   beq $v0,1,end
   la $a1,entry
   addi $t0,$zero,160
   lw $a2,list1($t1)
   jal Insert
   j end3
   end:
   #*****
   jal isfull
   beq $v0,1,end1
   la $a1,entry
   addi $t0,$zero,160
   lw $a2,list2($t1)
   jal Insert
   j end3
   #******
   end1:
   jal isfull
   beq $v0,1,end2
   la $a1,entry
   addi $t0,$zero,160
   lw $a2,list3($t1)
   jal Insert
   j end3
   #*****
   end2:
   jal isfull
   beq $v0,1,end3
   la $a1,entry
   addi $t0,$zero,160
   lw $a2,list4($t1)
   jal Insert
    #****
   break:
   j while4
    #****
   end3:
   li $v0,4         # code 4 == print string
   la $a0,string3  # $a0 == address of the string
   syscall 
   li $v0,5
   syscall
   beq $v0,2,while4
   #****
   while4:
   li $v0,10
   syscall
   
   
#************************** createlist function ************************
createlist:
     sw $zero,160($a0)#set the size of List to be zero
     jr $ra
     
     
#************************** isfull function *************************   
isfull:
  lw $t1, 160($a0)           # $t1=l->size
  beq $t1, 20, reachMax      # if (l->size== 20)
   addi $v0, $zero, 0        #return 0
   
  reachMax:
   addi $v0, $zero, 1       #return 1
    
  jr $ra
  
 
#*************************** isempty function **************************** 
isempty:
     lw $t0,160($a0)
     beq $t0,160,zero
     addi $v0,$zero,1
     jr $ra
     zero:
     addi $v0,$zero,0
     jr $ra
     
     
#****************************** insert function ****************************
Insert:
   sw $ra ,0($sp) #storing the return address
   jal isfull 
   beq $v0,1,else 
   lw $ra ,0($sp) 
   la $t0,($a0)    #put the address of the list on $t0
   la $t5,($a0)    #put the address of the list on $t5
   lw $t1,160($a0)  #load the value of size
   mul $t1,$t1,8    #multiply the size by 8 to get the index
   addi $t0,$t1,0   #get the index of the end of list
   mul $t2,$a2,8    #get the index of the position
   add $t5,$t5,$t2  #address of the position
   sub $t3,$t0,8   #get the index of the last element in the list
   
   for:
   blt  $t3,$t2,end_loop
    lw $t4,0($t3) #get the piriotity 
    sw $t4,0($t1)  #store the piriotity
    lw $t4,4($t3) #get the data
    sw $t4,4($t1) #store the data
    sub $t3,$t3,8
    sub $t3,$t3,8
    j for
   end_loop:
   lw $t6,0($a1)#load the priority 
   sw $t6,0($t5)#store the priority 
   lw $t6,4($a1)#load the priority 
   sw $t6,4($t5)#store the priority 
   lw $t7,160($a0)
   addi $t7,$t7,1 
   sw $t7,160($a0)
   jr $ra
   else:
   li      $v0,4       # code 4 == print string
   la      $a0,string  # $a0 == address of the string
   syscall             # Ask the operating system to perform the service.
   jr $ra
   
   
#************************* delete function ************************
Delete:
     addi $sp,$sp,-4                #store return address
     sw $ra,0($sp)
     
     jal isempty                     #call isempty
     bne $v1,$zero,Exit              #if $v1!=0 (list empty) then exit
     addi $t0,$a0,0                  #set address of list in $t0
     addi $t1,$a1,0                  #set index of char to be deleted in $t1
     addi $t2,$a2,0                  #set address of char and its priority in $t2
     lw $t4,160($a0)                 #load size of list in $t0
     addi $t5,$t4,-1                 #decrement $t4
     
     la $t4,($t4)
     
     #load the item to be deleted in entry
     mul $t3,$t1,8                #multiply array index by 8
     add $t6,$t0,$t3              #add list index to base address
     lw $t7,0($t6)                #load priority of item to be deleted
     lw $t8,4($t6)               #load char of item to be deleted
     sw $t7,0($t2)               #store priority of item to be deleted
     sw $t8,4($t2)               #store data of item to be deleted
     
     
     For:
        beq $t1,$t5,Exit
        
        mul $t3,$t1,8                #multiply array index by 8
        add $t6,$t0,$t3              #add array index to base address
        lw $t7,8($t6)                #load priority of list[i+1]
        lw $t8,12($t6)               #load char of list[i+1]
        sw $t7,0($t6)                #list[i].priority=list[i+1].priority
        sw $t8,4($t6)                #list[i].data=list[i+1].data 
        addi $t1, $t1, 1             # increment i (counter)
        
        j For
     Exit:
       
         addi $t4,$t4,-1             #decreament size of list
         sw $t4,160($a0)             #store value of $t0 to this memory address
                                     #store the new size of the list    
         lw $ra,0($sp)               #load return address
         add $sp,$sp,4                                                                              
         jr $ra
         
         

#***************************** ListSize function *******************
ListSize:
  lw $t1, 160($a0)           # $t1=l->size
  add $v0, $t1, $0           # return list size
  jr $ra
  

#*********************** destroy function*************************
destroy :
  addi $t0 ,$zero,0 
  sw $t0 ,160($a0)  
  jr $ra
  
  
#*********************** join function ***************************
join:
  la $t0,($a0)    #store the address of the list1
  la $t1,($a1)    #store the address of the list2
  la $t2,($a2)    #store the address of the list3
  la $t3,($a3)    #store the address of the list4
  sw $ra ,0($sp) #storing the return address
  while0:
    lw $t4,160($t2)
    lw $t5,160($t3)
    bge $t4,20,while1
     ble $t5 ,0,while1
       la $a0,($t3)
       li $a1,0
       la $a2,entry
       jal Delete
       la $a0,($t2)
       la $a1,entry
       lw $a2,160($t2)
       jal Insert
       j while0
  while1:
    lw $t4,160($t1)
    lw $t5,160($t2)
    bge $t4,20,while2
     ble $t5 ,0,while2
     la $a0,($t2)
     li $a1,0
     la $a2,entry
     jal Delete
     la $a0,($t1)
     la $a1,entry
     lw $a2,160($t1)
     jal Insert
     j while1
  while2:
    lw $t4,160($t0)
    lw $t5,160($t1)
    bge $t4,20,exit
     ble $t5 ,0,exit
      la $a0,($t1)
      li $a1,0
      la $a2,entry
      jal Delete
      la $a0,($t0)
      la $a1,entry
      lw $a2,160($t0)
      jal Insert
      j while2
  exit:
   lw $ra ,0($sp)
   jr $ra
   
   
#*********************************** loopinglists function************************
loopinglists:
  # $s0 = i
  # $t0 = l->size
  # $t1 = l->arr[$t0]->data
  # $t2 = l->arr[i]->priority
  addi $sp, $sp, -4
  sw $s0, 0($sp)                #save the previous value of register $s0
  li $s0, 0 # i=0
  add $t0, $a0, 160             #to get size of list (list->size)
  loop:
    bge $s0,$t0, exitloop       #START FOR LOOP (for loop condition) i< l->size
    mul $t1, $s0, 8             # i* 8 to acces l->arr[i]->data
    add $t1, $t1, $a0           # to get data address
    lw $t1, 0($t1)              # l->arr[i]->data
    bne $t1, $a1, exitIF        # if(l->arr[i].data==req)
      lw $t2, 4($t1)            # t2 = l->arr[i]->priority
      sw $a2, 0($t2)            # set l->arr[i]->priority = newp
      
  exitIF:
    addi $s0, $s0, 1 # i ++
    j loop 
  
  exitloop:
    jr $ra
  
  lw $s0, 0($sp)               #restor the previous value of $s0
  addi $sp, $sp, 4             #restor the value of $sp
  jr $ra



#****************************** updatePriority function********************************
updatePriority:
  # ensure thet there are 6 arguments passed to the function, or we need to return from it
  beq $fp, $sp, end
   sub $sp, $sp, 20            #to store our local vars
   sw $ra, 0($sp)              #store return address of this func
   sw $a0, 4($sp)              #store adress of l1
   sw $a1, 8($sp)              #store adress of l2
   sw $a2, 12($sp)             #store adress of l3
   sw $a3, 16($sp)             #store adress of l4
   lw $a0, 4($sp)              #send l1 to isempty
   jal isempty
   add $t0, $v0, $zero         # store if list is empty or not
   bne $t0, 0, listIsEmpty     # do the folowing ins if list is not empty
    lw $a0, 4($sp)             #secd l1 to loopinglists
    lw $a1, -4($fp)            #load the value of 'req'
    lw $a2, -8($fp)            #load the value of 'newp'
    jal loopinglists
    
   lw $a0, 8($sp)              #send l2 to isempty
   jal isempty
   add $t0, $v0, $zero         # store if list is empty or not
   bne $t0, 0, listIsEmpty     # do the folowing ins if list is not empty
    lw $a0, 8($sp)             #secd l2 to loopinglists
    lw $a1, -4($fp)            #load the value of 'req'
    lw $a2, -8($fp)            #load the value of 'newp'
    jal loopinglists
    
   lw $a0, 12($sp)             #send l3 to isempty
   jal isempty
   add $t0, $v0, $zero         # store if list is empty or not
   bne $t0, 0, listIsEmpty     # do the folowing ins if list is not empty
    lw $a0, 12($sp)            #secd l3 to loopinglists
    lw $a1, -4($fp)            #load the value of 'req'
    lw $a2, -8($fp)            #load the value of 'newp'
    jal loopinglists
    
   lw $a0, 16($sp)             #send l4 to isempty
   jal isempty
   add $t0, $v0, $zero         # store if list is empty or not
   bne $t0, 0, listIsEmpty     # do the folowing ins if list is not empty
    lw $a0, 16($sp)            #secd l4 to loopinglists
    lw $a1, -4($fp)            #load the value of 'req'
    lw $a2, -8($fp)            #load the value of 'newp'
    jal loopinglists
  
  listIsEmpty:
  
  end:
   lw $ra, 0($sp)             #load return address of this func
   add $sp, $sp, 20           #restor the value of $sp
   jr $ra
   
   
   
#************************************* swap function *****************************
swap:				#swap method

  addi $sp, $sp, -12	# Make stack room for three

  sw $a0, 0($sp)		# Store a0   arr
  sw $a1, 4($sp)		# Store a1  i
  sw $a2, 8($sp)		# store a2   j

  sll $t1, $a1, 3 	#t1 = 4i
  add $t1, $a0, $t1	#t1 = arr + 4i
  lw $s3, 0($t1)		#s3  t = array[i].priority
  lw $s5, 4($t1)         #s5   t = array[i].data    

  sll $t2, $a2, 3 	#t2 = 4j
  add $t2, $a0, $t2	#t2 = arr + 4j
  lw $s4, 0($t2)		#s4 = arr[j]
  lw $s6, 4($t2)         #s5   t = array[j].data  

 sw $s4, 0($t1)		#arr[i].priority = arr[j].priority
  sw $s3, 0($t2)		#arr[j].priority = t

  sw $s5, 4($t2)		#arr[j].data = t 
  sw $s6, 4($t1)		#arr[i].data = arr[j].data 

       
  addi $sp, $sp, 12	#Restoring the stack size

  jr $ra			#jump back to the caller
	

#******************************** function ******************************
partition: 			#partition method

  addi $sp, $sp, -20	#Make room for 5

  sw $a0, 0($sp)		#store a0
  sw $a1, 4($sp)		#store a1
  sw $a2, 8($sp)		#store a2
  sw $a3, 12($sp)		#store a2
  sw $ra, 16($sp)		#store return address
	
  move $s1, $a1		#s1 = low
  move $s2, $a2		#s2 = high
  move $t9, $a3		#t9 = priority
	
  mul $t1,$s2,8            #multiply array index by 8
  add $t1, $a0, $t1	# t1 = arr + 8*high
  lw $t2, 0($t1)		# t2 = arr[high] //pivot

  addi $t3, $s1, 0 	#t3, i=low -1   
  move $t4, $s1		#t4, j=low
  addi $t5, $s2, 0	#t5 = high - 1  
        
  beq  $t9, 1, partitionByData         #if k==i jump to endfor

 forloop: 
		#slt $t6, $t5, $t4	#t6=1 if j>high-1, t6=0 if j<=high-1
		#bne $t6, $zero, endfor	#if t6=1 then branch to endfor
   beq $t4,$t5,endfor
    mul $t1,$t4,8          #multiply array index by 8
    add $t1, $t1, $a0	#t1 = arr + 4j
    lw $t7, 0($t1)		#t7 = arr[j]
		
    slt $t8, $t2, $t7	#t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
    beq $t2,$t7,endfif     # if pivot = arr[j] branch to endfif 
    bne $t8, $zero, endfif	#if t8=1 then branch to endfif
		
    move $a1, $t3		#a1 = i
    move $a2, $t4		#a2 = j
    addi $t3, $t3, 1	#i=i+1 
    jal swap		#swap(arr, i, j)
		
    addi $t4, $t4, 1	#j++
    j forloop

 endfif:
  addi $t4, $t4, 1	#j++
  j forloop		#junp back to forloop

 endfor:
  addi $a1, $t3, 0		#a1 = i+1 
  move $a2, $s2		#a2 = high  
  add $v0, $zero, $a1	#v0 = i+1 return (i + 1);
  jal swap		#swap(arr, i + 1, high);

  lw $ra, 16($sp)		#return address
  addi $sp, $sp, 20		#restore the stack
  jr $ra		#junp back to the caller


#************************************ partitionByData function *************************
partitionByData:   # if sortBy !=0
  lw $t2, 4($t1)		# t2 = arr[high] //pivot
  forloop2: 
		#slt $t6, $t5, $t4	#t6=1 if j>high-1, t6=0 if j<=high-1
		#bne $t6, $zero, endfor	#if t6=1 then branch to endfor
    beq $t4,$t5,endfor2
    mul $t1,$t4,8          #multiply array index by 8
    add $t1, $t1, $a0	#t1 = arr + 4j
    lw $t7, 4($t1)		#t7 = arr[j]
		
    slt $t8, $t2, $t7	#t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
    beq $t2,$t7,endfif2    # if pivot = arr[j] branch to endfif 
    bne $t8, $zero, endfif2	#if t8=1 then branch to endfif
		
    move $a1, $t3		#a1 = i
    move $a2, $t4		#a2 = j
    addi $t3, $t3, 1	#i=i+1 
    jal swap		#swap(arr, i, j)
		
    addi $t4, $t4, 1	#j++
    j forloop2

 endfif2:
   addi $t4, $t4, 1	#j++
   j forloop2		#junp back to forloop

 endfor2:
   addi $a1, $t3, 0		#a1 = i+1 
   move $a2, $s2		#a2 = high  
   add $v0, $zero, $a1	#v0 = i+1 return (i + 1);
   jal swap		#swap(arr, i + 1, high);

   lw $ra, 16($sp)		#return address
   addi $sp, $sp, 20	#restore the stack
   jr $ra	
   
   
#****************** quicksort function *************************
quicksort: #quicksort function

  addi $sp, $sp, -20	# Make room for 5

  sw $a0, 0($sp)		# save list in stack
  sw $a1, 4($sp)		# save low in stack
  sw $a2, 8($sp)		# save high in stack
  sw $a3, 12($sp)		# save priority in stack
  sw $ra, 16($sp)		# save return address

  move $t0, $a2		#saving high in t0

  slt $t1, $a1, $t0		# t1=1 if low < high, else 0
  beq $t1, $zero, endif	# if low >= high, endif

  jal partition		# call partition 
  move $s0, $v0		# pivot, s0= v0

  lw $a1, 4($sp)		#a1 = low
  addi $a2, $s0, -1		#a2 = pivot -1
  jal quicksort		#call quicksort

  addi $a1, $s0, 1		#a1 = pivot + 1
  lw $a2, 8($sp)		#a2 = high
  jal quicksort		#call quicksort
 
 endif:

   lw $a0, 0($sp)		#restore list
   lw $a1, 4($sp)		#restore low
   lw $a2, 8($sp)		#restore high
   lw $a3, 8($sp)		#restore priority
   lw $ra, 16($sp)		#restore return address
   addi $sp, $sp, 20	#restore the stack
   jr $ra		#return to caller
 	
 	
 #***************************** TransferListToArray function ********************
 TransferListToArray:

     addi $sp,$sp,-4                  #store return address
     addi $s0,$ra,0
     sw $s0,0($sp)
    
    addi $s1,$a0,0                    #$a0 contains address of arr
    addi $s2,$a1,0	               #$t2=i
    addi $s3,$a2,0                    #$a2 contains address of List
    
    
    While:
         addi $a0, $s3, 0                  #$a0 contains address of list
         jal isempty
         beq $v1, 1, endWhile
          #delete function parameters
         addi $a0, $s3, 0                  #$a0 contains address of list
         addi $a1,$zero,0	            #$t2=0 //j
         la $a2,entry                      #load address of entry(to return the item that will be deleted) in $a2
        
         jal Delete                        #call delete function
         mul $t4,$s2,8                     #multiply array index by 8
         add $t5,$s1,$t4                   #add array index to base address
         la $t6,entry                      #load address of entry
         lw $t7,0($t6)                     #load priority of item (entry)
         lw $t8,4($t6)                     #load char of item (entry)
         sw $t7,0($t5)                     #store priority of item in arr
                                           #arr[i].data=e.data
         sw $t8,4($t5)                     #store data of item in arr
                                           #arr[i].priority=e.priority
         addi $s2,$s2,1                    #i=i+1                                  
         j While
    endWhile:    
        
        addi $v1,$s2,0                #put $t4(i) in $v1 to return i
        lw $s0,0($sp)                 #load return address
        add $sp,$sp,4  
        addi $ra,$s0,0
        jr $ra 
   
   	
#**************************** ProcessAllRequests function *********************
ProcessAllRequests:

     addi $sp,$sp,-4                   #store return address
     addi $s5,$ra,0
     sw $s5,0($sp)
     la $t0, arr                       # Moves the address of array into register $t0.
     la $t3,list1                      #load address of List1 in $t3
     addi $a0, $t0, 0                  #$a0 contains address of arr
     addi $a1,$zero,0	                #i=0
     addi $a2, $t3, 0                  #$a2 contains address of List1
      
     jal  TransferListToArray           #call the function
     
     li $v0,1                          #load the return from the function
     la $t0, arr                       # Moves the address of array into register $t0.
     addi $a0, $t0, 0                  #$a0 contains address of arr
     addi $a1,$v1,0                 	#put return integer in $a1
     
     la $t3,list2                      #load address of List2 in $t3
     addi $a2, $t3, 0                  #$a2 contains address of List2
  
     jal  TransferListToArray
     
     li $v0,1                          #load the return from the function
     la $t0, arr                       # Moves the address of array into register $t0.
     addi $a0, $t0, 0                  #$a0 contains address of arr
     addi $a1,$v1,0                 	#put return integer in $a1
     
      la $t3,list3                     #load address of List2 in $t3
     addi $a2, $t3, 0                  #$a2 contains address of List3
     
     jal TransferListToArray
     
     li $v0,1                          #load the return from the function
     la $t0, arr                       # Moves the address of array into register $t0.
     addi $a0, $t0, 0                  #$a0 contains address of arr
     addi $a1,$v1,0                 	#put return integer in $a1
     
     la $t3,list4                     #load address of List2 in $t3
     addi $a2, $t3, 0                  #$a2 contains address of List4
     
     jal TransferListToArray
     
     li $v0,1                          #load the return from the function
     addi $a1,$v1,0                 	#put return integer in $a1
     addi $s7,$v1,0                 	#put return integer in $s7
     addi $t3,$a1,-1                   #$t3=i-1
     addi $t1,$a1,0                    #put $a1(i) in $t1 
      
     la $t0, arr                     # Moves the address of array into register $t0.
     addi $a0, $t0, 0                # Set argument 1 to the array.
     addi $a1, $zero, 0              # Set argument 2 to (low = 0)
     addi $a2, $t3, 0                # Set argument 3 to (high = i-1, last index in array)
     addi $a3, $zero, 0        	# Set argument 3 to (priority = 0)
     jal quicksort
     addi $t2, $zero, 0                #k=0
     
     la $t0,arr                      #load address of arr in $t0
     
     for:
        beq  $t2, $s7, endFor         #if k==i jump to endfor
        
        li $v0, 4                     #print string
        la $a0, char                  # load address of string to be printed into $a0
        syscall
        
      
        mul $t3,$t2,8                #multiply array index by 8
        add $t3,$t3,$t0              #$t3=4j*arr
        lw $t4,0($t3)                #$t4=arr[k].priority
        
       
        lw $t5,4($t3)                #$t5=arr[k].data
        
        
        li $v0, 11                    #print char 
        la $a0,($t5)                 # load address of string to be printed into $a0
        syscall
        

        li $a0, 32                   # print space, 32 is ASCII code for space
        li $v0, 11  
        syscall
       
        li $v0, 4                     #print string
        la $a0, priority              # load address of string to be printed into $a0
        syscall
        
        li $v0, 1                     #print priority of char
        la $a0,($t4)                  #load address of int to be printed into $a0
        syscall
        
        li $v0, 4                     #print newline
        la $a0, newline       
        syscall
         
        addi    $t2, $t2, 1          #increment k (counter)
        j for
     
     endFor:
        lw $s5,0($sp)                #load return address
        add $sp,$sp,4  
        addi $ra,$s5,0
        jr $ra
     
       
#**********************************8 emptyLists function *********************
emptyLists:
 sw $ra ,0($sp) #storing the return address
 #empty list one
 la $a0,list1
 jal destroy
 #******
 #empty list two
 la $a0,list2
 jal destroy
 #******
 #empty list three
 la $a0,list3
 jal destroy
 #*******
 #empty list four
 la $a0,list4
 jal destroy
 lw $ra ,0($sp) #restore the return address
 jr $ra
	