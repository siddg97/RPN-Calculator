## Reverse Polish Notation Calculator in Haskell:

- This project was a university assignment that was required by me to do.
- To run this project you will need the `haskell-platform` and the `ghci` interpreter.
- If you are using a linux device then you can run the following command:
```bash
sudo apt install haskell-platform ghci
```
- After you have installed the above dependecies, you can go to the root directory of this repository __(Once you clone this repo on your system)__ and run the following command:
```bash
ghci calc.hs
```
- The above command will run an interpreter and now you can evaluate any RPN expression like this:
```haskell
Main> calc "1 2 + 3 - 1 /"
> "0"
```

## Operators Supported:

### The following operators are unary:

- `inc`
```haskell
    Main> calc "3 inc"
    > "4"
    Main> calc "3 inc inc"
    > "5"
```
- `dec`
```haskell
Main> calc "3 dec" 
> "2"
Main> calc "3 dec dec"
> "1"
```
- `sqrt`
```haskell
Main> calc "3 sqrt"
> "1.7320508075688772"
```
- `sin`
```haskell
Main> calc "3 sin" 
> "0.1411200080598672"
```
- `cos`
```haskell
Main> calc "3 cos"
> "-0.9899924966004454"
```
- `inv`
```haskell
Main> calc "3 inv"
> "0.3333333333333333"
Main>calc "0 inv"
> "Infinity"
```

### The following operators are binary:

- `+`
```haskell
Main> calc "4 2 +"
> "6"
```
- `*`
```haskell
Main> calc "4 2 *"
> "8"
```
- `-`
```haskell
Main> calc "4 2 -"
>"2"
Main> "2 4 -"
> "-2"
```
- `/`
```haskell
Main> calc "4 2 /"
> "2"
Main> calc "2 4 /"
> "0.5"
Main> calc "2 0 /"
>"Infinity"
Main> calc "0 0 /"
> "NaN"
```
- `+all`
```haskell
Main> calc "1 2 3 4 +all"
> "10"
Main> calc "4 +all" 
> "4"
```
- `*all`
```haskell
Main> calc "1 2 3 4 *all"
> "24"
Main> calc "4 *all"
> "4"
```

### The following operators manipulate the args:

- `dup`
```haskell
Main> calc "4 dup *"
> "16"
```

- `pop`
```haskell
Main> calc "4 5 6 pop +all"
> "9"
```
- `clear`
```haskell
Main> calc "1 2 3 clear"
> ""
```
- `swap`
```haskell
Main> calc "4 1 -"
> "3"
Main> calc "4 1 swap -"
> "-3" 
```

## Some examples:
```haskell
Main> calc "1 2 + 3 *"
> "9.0"

Main> calc "1 2 3 * +"
> "7.0"

Main> calc "2 sqrt 3 sqrt +"
> "3.1462643699419726"

Main> calc "11 dup *"
> "121.0"

Main> calc "0 5 /"
> "0.0"

Main> calc "5 0 /"
> "Infinity"

Main> calc "2 3 + 4 2 +all"
> "11.0"

Main> calc "2 3 + 4 2 *all"
> "40.0"

Main> calc "3.2 sin dup * 3.2 cos dup * +"
> "1.0"
```
