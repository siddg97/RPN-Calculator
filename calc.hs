-- Token: class definition for a single token.
data Token = Num Double | Op String | Err String
instance Show Token where
  show (Num n)   = (show n)
  show (Op op)   = op
  show (Err err) = err

--____________________GETTER FUNCTIONS_______________________________________________

-- Return the string of the operator token
-- USAGE: opStr op
opStr :: Token -> String
opStr (Op o) = o


-- ____________________TYPE CHECKING/CONVERSION FUNCTIONS____________________________

isOperator :: String -> Bool
isOperator str
           | str == "inc"   || str == "dec"  ||
             str == "sqrt"  || str == "sin"  ||
             str == "cos"   || str == "inv"  ||
             str == "+"     || str == "*"    ||
             str == "-"     || str == "/"    ||
             str == "+all"  || str == "*all" ||
             str == "dup"   || str == "pop"  ||
             str == "clear" || str == "swap"    = True
           | otherwise                          = False

isNumber :: String -> Bool
isNumber str = if ((not (null (reads str :: [(Double,String)]))) &&
                  ((snd (head (reads str :: [(Double,String)])))==""))
               then True
               else False

strToDouble :: String -> Double
strToDouble str = fst (head (reads str :: [(Double,String)]))

-- Convert a given string into the corresponding data type or give an error message
-- USAGE: toToken str
toToken :: String -> Token
toToken str 
         | isNumber str   = Num (strToDouble str)
         | isOperator str = Op str
         | otherwise      = Err "[ERROR]: Invalid expression!"

-- Convert a given token into a string
-- USAGE: toString t
toString :: Token -> String
toString (Num n) = show n
toString (Op op) = op
toString (Err e) = e

-- Convert a given list of strings into a list of tokens
-- USAGE: toTokenList lst
toTokenList :: [String] -> [Token]
toTokenList lst = map toToken lst

-- Determine if a Token is a Num or not
-- USAGE: isNum t
isNum :: Token -> Bool
isNum (Num _) = True
isNum _       = False

-- Determine if a Token is an Op or not
-- USAGE: isOp t
isOp :: Token -> Bool
isOp (Op op) = True
isOp _       = False


-- Determine if token is an error or not
-- USAGE: isErr t
isErr :: Token -> Bool
isErr (Err _) = True
isErr _       = False

-- Determine if an operator is Binary or not
-- USAGE: isBinaryOp op
isBinaryOp :: Token -> Bool
isBinaryOp (Op "+")   = True
isBinaryOp (Op "-")   = True
isBinaryOp (Op "*")   = True
isBinaryOp (Op "/")   = True
isBinaryOp (Op "pop") = True
isBinaryOp _          = False

-- Determine if an operator is Unary or not
-- USAGE: isUnaryOp op
isUnaryOp :: Token -> Bool
isUnaryOp (Op "inc")  = True
isUnaryOp (Op "dec")  = True
isUnaryOp (Op "sqrt") = True
isUnaryOp (Op "sin")  = True
isUnaryOp (Op "cos")  = True
isUnaryOp (Op "inv")  = True
isUnaryOp _           = False


-- Convert a given string of space separated items into a string of tokens
-- USAGE: tokenize str
tokenize :: String -> [Token]
tokenize str = toTokenList str_tokens
               where str_tokens = words str

-- Given a list of tokens converts it into a human readable string expression
-- USAGE: stringify t_lst
stringify :: [Token] -> String
stringify []        = ""
stringify (car:cdr) = (show car) ++ "\n\n" ++ (stringify cdr)


-- change the '\n' to a space char ' '
repl :: Char -> Char
repl '\n' = ' '
repl c    = c

-- Stack: a list of tokens
--    + first element of the list is the top element of the stack


--_________________STACK FUNCTIONS____________________________________________

-- Return the top element of the stack
pop :: [Token] -> Token
pop stack = head stack


-- Return the stack from the second element onwards
popedStack :: [Token] -> [Token]
popedStack stack = tail stack

-- add a token to the top of the stack
push :: Token -> [Token] -> [Token]
push t stack = [t]++stack


-- _________________OPERAOTRS FOR CALCULATOR___________________________________

-- BINARY OPERATORS

-- "+"" operator
plusTokens :: Token -> Token -> Token
plusTokens (Num x) (Num y) = Num (x+y)

-- "-" operator
minusTokens :: Token -> Token -> Token
minusTokens (Num x) (Num y) = Num (x-y)

-- "*" operator
mulTokens :: Token -> Token -> Token
mulTokens (Num x) (Num y) = Num (x*y)

-- "/" operator
divTokens :: Token -> Token -> Token
divTokens (Num x) (Num y) = Num (x/y)


-- UNARY OPERATOR

-- "inc" operator
incToken :: Token -> Token
incToken x = plusTokens x (Num 1) 

-- "dec" operator
decToken :: Token -> Token
decToken x = minusTokens x (Num 1)

-- "sqrt" operator
sqrtToken :: Token -> Token
sqrtToken (Num x) = Num (sqrt x)

-- "sin" operator
sinToken :: Token -> Token
sinToken (Num x) = Num (sin x)

-- "cos" operator
cosToken :: Token -> Token
cosToken (Num x) = Num (cos x)

-- "inv" operator
invToken :: Token -> Token
invToken x = divTokens (Num 1) x


-- STACK MODIFICATION OPERATORS

-- "dup" operator
dupToken :: Token -> Token
dupToken x = x

-- "swap" operator
swapTokens :: Token -> Token -> [Token]
swapTokens x y = [y,x]


-- MISC OPERATORs

-- "+all" operator
plusAllTokens :: [Token] -> Token
plusAllTokens []        = (Num 0)
plusAllTokens (car:cdr) = plusTokens car (plusAllTokens cdr)

-- "*all" operator
mulAllTokens :: [Token] -> Token
mulAllTokens []        = (Num 1)
mulAllTokens (car:cdr) = mulTokens car (mulAllTokens cdr)



-- apply the operation which is determined by the given operator
applyOp :: String ->[Token] -> [Token]
applyOp "+" arg_stack     = if ((length arg_stack) < 2) 
                            then [(Err "Operator [+]: Not enough arguments!")]
                            else [(plusTokens (pop arg_stack) (pop (popedStack arg_stack)))]++(popedStack (popedStack arg_stack))
applyOp "-" arg_stack     = if ((length arg_stack) < 2) 
                            then [(Err "Operator [-]: Not enough arguments!")]
                            else[(minusTokens (pop (popedStack arg_stack)) (pop arg_stack))]++(popedStack (popedStack arg_stack))
applyOp "*" arg_stack     = if ((length arg_stack) < 2) 
                            then [(Err "Operator [*]: Not enough arguments!")]
                            else[(mulTokens (pop arg_stack) (pop (popedStack arg_stack)))]++(popedStack (popedStack arg_stack))
applyOp "/" arg_stack     = if ((length arg_stack) < 2) 
                            then [(Err "Operator [/]: Not enough arguments!")]
                            else[(divTokens (pop (popedStack arg_stack)) (pop arg_stack))]++(popedStack (popedStack arg_stack))
applyOp "inc" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [inc]: Not enough arguments!")]
                            else [(incToken (pop arg_stack))]++(popedStack arg_stack)
applyOp "dec" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [dec]: Not enough arguments!")]
                            else [(decToken (pop arg_stack))]++(popedStack arg_stack)
applyOp "sqrt" arg_stack  = if ((length arg_stack) < 1) 
                            then [(Err "Operator [sqrt]: Not enough arguments!")]
                            else  [(sqrtToken (pop arg_stack))]++(popedStack arg_stack)
applyOp "sin" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [sin]: Not enough arguments!")]
                            else [(sinToken (pop arg_stack))]++(popedStack arg_stack)
applyOp "cos" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [cos]: Not enough arguments!")]
                            else  [(cosToken (pop arg_stack))]++(popedStack arg_stack)
applyOp "inv" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [inv]: Not enough arguments!")]
                            else [(invToken (pop arg_stack))]++(popedStack arg_stack)
applyOp "+all" arg_stack  = if ((length arg_stack) < 1) 
                            then [(Err "Operator [+all]: Not enough arguments!")]
                            else [(plusAllTokens arg_stack)]
applyOp "*all" arg_stack  = if ((length arg_stack) < 1) 
                            then [(Err "Operator [*all]: Not enoughw arguments!")]
                            else [(mulAllTokens arg_stack)]
applyOp "dup" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [dup]: Not enough arguments!")]
                            else push (dupToken (pop arg_stack)) arg_stack
applyOp "pop" arg_stack   = if ((length arg_stack) < 1) 
                            then [(Err "Operator [pop]: Cannot pop an element from an empty stack!")]
                            else popedStack arg_stack
applyOp "clear" arg_stack = []
applyOp "swap" arg_stack  = if ((length arg_stack) < 2) 
                            then [(Err "Operator [swap]: Not enough arguments!")]
                            else (swapTokens (pop arg_stack) (pop (popedStack arg_stack)))++(popedStack (popedStack arg_stack)) 


-- evaluate the expression
-- USAGE: eval tokens arg_stack [arg_stack is passed as an empty list]
eval :: [Token] -> [Token] -> [Token]
eval [] arg_stack = arg_stack
eval (car:cdr) arg_stack
              | (not (null arg_stack)) && (isErr (head arg_stack)) = [(head arg_stack)]
              | isErr car                                          = [car]
              | isNum car                                          = eval cdr (push car arg_stack)
              | isOp  car                                          = eval cdr (applyOp (opStr car) arg_stack)


-- calculate the given string expression in postfix format
calc :: String -> String
calc [] = "Empty stack!"
calc str = show (head result)
           where result = eval (tokenize str) []