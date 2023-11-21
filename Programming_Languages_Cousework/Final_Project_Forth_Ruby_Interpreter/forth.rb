# Chris McLaughlin
# V00912353
##################

# Turns out Ruby has global variables with $
$stack = []
$dictionary = {}
$debug = false
$status = ""

$heap = Array.new(10000)
$firstfreeheapaddr=1000

$CELL_WIDTH = 1

def print_out(str)
    print str
    print " "
end

# Define some sugar to make this less un-fun to code
def debugputs(e)
    if $debug
        puts e
    end
end

def push(v)
    $stack.push(v)
end
def pop()
    if $stack.empty?
        addError("empty stack")
    end
    $stack.pop()
end
def peek()
    $stack[-1]
end

# Make lambdas for each function
$dictionary["+"] = lambda {
    n2 = pop
    n1 = pop
    push n1+n2
}
$dictionary["-"] = lambda {
    n2 = pop
    n1 = pop
    push n1-n2
}
$dictionary["*"] = lambda {
    n2 = pop
    n1 = pop
    push n1*n2
}
$dictionary["/"] = lambda {
    n2 = pop
    n1 = pop
    push n1/n2
}
$dictionary["MOD"] = lambda {
    n2 = pop
    n1 = pop
    push n1%n2
}
$dictionary["DUP"] = lambda {
    n = pop
    push n
    push n
}
$dictionary["SWAP"] = lambda {
    n2 = pop
    n1 = pop
    push n2
    push n1
}
$dictionary["DROP"] = lambda{
    pop
}
$dictionary["DUMP"] = lambda {
    puts $stack.to_s
}
$dictionary["OVER"] = lambda {
    n2 = pop
    n1 = pop
    push n1
    push n2
    push n1
}
$dictionary["ROT"] = lambda {
    n3 = pop
    n2 = pop
    n1 = pop
    push n2
    push n3
    push n1
}
$dictionary["."] = lambda {
    n = pop
    if $status=="ok"
        print_out n
    end
}
$dictionary["EMIT"] = lambda {
    n = pop
    if $status=="ok"
        print_out n
    end
}
$dictionary["CR"] = lambda {
    puts ""
}
$dictionary["="] = lambda {
    n2 = pop
    n1 = pop
    if n1 == n2
        push -1
    else
        push 0
    end
}
$dictionary["<"] = lambda {
    n2 = pop
    n1 = pop
    if n1 < n2
        push -1
    else
        push 0
    end
}
$dictionary[">"] = lambda {
    n2 = pop
    n1 = pop
    if n1 > n2
        push -1
    else
        push 0
    end
}
$dictionary["AND"] = lambda {
    n2 = pop
    n1 = pop
    push n1&n2
}
$dictionary["OR"] = lambda {
    n2 = pop
    n1 = pop
    push n1|n2
}
$dictionary["XOR"] = lambda {
    n2 = pop
    n1 = pop
    push n1^n2
}
$dictionary["INVERT"] = lambda {
    n1 = pop
    push ~n1
}
$dictionary["!"] = lambda {
    addr = pop() # will follow a NAME, so TOS is heap address of data
    $heap[addr] = pop()
}
$dictionary["@"] = lambda {
    addr = pop() # same as above, follows NAME so TOS is heap addr to pull from
    push $heap[addr].to_i
}
$dictionary["?"] = lambda {
    # No overview given, but guessing from use that its a combo of @ and ., where the result is it NOT being on the stack
    addr = pop() # same as above, follows NAME so TOS is heap addr to pull from
    push $heap[addr].to_i
    print_out(pop())
}
$dictionary["CELLS"] = lambda {
    mult = pop()
    push(mult*$CELL_WIDTH)
}
$dictionary["ALLOT"] = lambda {
    reserve = pop()
    $firstfreeheapaddr = $firstfreeheapaddr+reserve
}

def addError(msg)
    if $status == "ok"
        $status = "error: "+msg
    else
        $status = $status + "; error: "+msg
    end
end

def isInputUnbalanced(in_str) # Helper func to make code cleaner
    (in_str.scan(";").size < in_str.scan(":").size) or
    ((in_str.upcase.scan("THEN").size < in_str.upcase.scan("IF").size)) or
    ((in_str.upcase.scan("UNTIL").size < in_str.upcase.scan("BEGIN").size)) or
    ((in_str.upcase.scan("LOOP").size < in_str.upcase.scan("DO").size)) or
    ((in_str.upcase.scan(")").size < in_str.upcase.scan("(").size))
end

def addWordToDict(in_name, in_body)
    $dictionary[in_name] = lambda { parseline(in_body, true) }
end

def executeIfBlock(in_true, in_false)
    if pop()!=0
        parseline(in_true, true)
    elsif in_false != ""
        parseline(in_false, true)
    end
end

def executeBeginLoop(in_loop)
    loopfunc = lambda { parseline(in_loop, true) }
    while pop()==0
        loopfunc.call()
    end
end

def executeDoLoop(in_doloop)
    iterator = pop() #doloop_begin
    doloop_end = pop()
    while iterator < doloop_end    
        (lambda { parseline(in_doloop, true, iterator) }).call()
        iterator = iterator + 1
    end
end

def parseline(in_line, suppress_ok=false, i_doloop=nil)
    $status = "ok"
    #print_out(in_line) #DEBUG
    in_arr = in_line.split()

    i = 0
    while i < in_arr.length()
        if in_arr[i] == '."' # Handle strings
            stringedout=""
            i = i+1
            while not(in_arr[i].end_with?('"'))
                stringedout = stringedout+in_arr[i]+" "
                i = i+1
            end
            #we're now on the next word that ends with "
            stringedout = stringedout+in_arr[i].chop()
            print_out(stringedout)
            i = i+1
        elsif in_arr[i] == ":" # Handle word defs
            i = i+1 #i now wordname
            newword_name = in_arr[i].upcase
            i = i+1 # i now first word of newword body
            newword_body = ""
            while in_arr[i] != ";"
                newword_body = newword_body+" "+in_arr[i]
                i = i+1
            end
            # we're now on ;
            # add newword to dict
            addWordToDict(newword_name, newword_body)
            i = i+1
        elsif in_arr[i].upcase == "IF" # Handle IF (ELSE) THEN blocks
            trueblock = ""
            falseblock = ""
            subifcount = 0
            buildtruefalse = true
            do_build = false

            i = i+1 # start with first word of trueblock
            
            while (in_arr[i].upcase != "THEN" or subifcount > 0)
                do_build = false

                if in_arr[i].upcase == "IF"
                    do_build = true
                    subifcount = subifcount + 1
                elsif in_arr[i].upcase == "ELSE" and subifcount == 0
                    buildtruefalse = false
                elsif in_arr[i].upcase == "THEN" # can only get here if subifcount > 0
                    do_build = true
                    subifcount = subifcount - 1
                else # is just a normal word
                    do_build = true
                end

                if do_build
                    if buildtruefalse
                        trueblock = trueblock+" "+in_arr[i]
                    else
                        falseblock = falseblock+" "+in_arr[i]
                    end
                end

                i = i + 1
            end

            executeIfBlock(trueblock, falseblock)
            # we are now on the final then. Next i is first word of root if's thenblock)
            i = i + 1
        elsif in_arr[i].upcase == "BEGIN"
            # Similar to IF for this part
            loopblock = ""
            subbegincount = 0
            i = i + 1 # start on first word of loopblock

            while (in_arr[i].upcase != "UNTIL" or subbegincount > 0)
                if in_arr[i].upcase == "BEGIN"
                    subbegincount = subbegincount + 1
                elsif in_arr[i].upcase == "UNTIL" #can only get here if subbegincount > 0
                    subbegincount = subbegincount - 1
                end # else its just a normal word

                loopblock = loopblock+" "+in_arr[i]
                i = i + 1
            end

            debugputs("LOOPBLOCK:")
            debugputs(loopblock)
            executeBeginLoop(loopblock)
            # we are on the final until. Next i is first word following root begin's until
            i = i+1
        elsif in_arr[i].upcase == "I"
            if not i_doloop.nil?
                push i_doloop
            else
                addError("Attempted to use I outside the context of a DO...LOOP")
            end
            i = i + 1
        elsif in_arr[i].upcase == "DO"
            doblock = ""
            subdocount = 0
            i = i+1 # start wotj first word of do block

            while (in_arr[i].upcase != "LOOP" or subdocount > 0)
                if in_arr[i].upcase == "DO"
                    subdocount = subdocount + 1
                elsif in_arr[i].upcase == "LOOP" # can only get here if subdocount > 0
                    subdocount = subdocount - 1
                end # else its just a normal word

                doblock = doblock+" "+in_arr[i]
                i = i + 1
            end

            executeDoLoop(doblock)
            i = i + 1
        elsif in_arr[i].upcase == "("
            subcommentcount = 0
            i = i + 1 # start on first word of comment
            while (in_arr[i].upcase != ")" or subcommentcount > 0)
                debugputs(in_arr[i].upcase)
                if in_arr[i].upcase == "("
                    subcommentcount = subcommentcount + 1
                elsif in_arr[i].upcase == ")" # can only get here if subcommentcount > 0
                    subcommentcount = subcommentcount - 1
                end # else is normal word
                i = i + 1
            end
            i = i + 1
        elsif in_arr[i].upcase == "VARIABLE"
            i = i + 1 # Now i is the name
            # variables are just fancy words!
            newword_name = in_arr[i].upcase
            newword_body = $firstfreeheapaddr.to_s
            $firstfreeheapaddr = $firstfreeheapaddr+1
            addWordToDict(newword_name, newword_body)
            i = i+1
        elsif in_arr[i].upcase == "CONSTANT"
            i = i + 1
            newword_name = in_arr[i].upcase
            newword_body = pop() # Follows a value, so ToS will be that value
            addWordToDict(newword_name, newword_body.to_s)
            i = i + 1
        elsif $dictionary.keys.include?(in_arr[i].upcase)# is in the dict?
            # DO THE FUNC STORED AT THIS POINT OF THE DICT 
            $dictionary[in_arr[i].upcase].call()
            i = i+1
        elsif (in_arr[i]=="0" or in_arr[i].to_i!= 0) # is an int
            push in_arr[i].to_i
            i = i+1
        else
            addError("else block of parseline reached")
        end
    end
    if (suppress_ok == false or $status != "ok")
        puts $status
    end
end

# Mainloop
while true
    line_in = $stdin.readline()
    # Read more lines if ; : unbalanced
    while (isInputUnbalanced(line_in))
        line_in = line_in+" "+$stdin.readline()
    end
    parseline(line_in)
    #binding.irb #DEBUG
end
