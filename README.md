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
