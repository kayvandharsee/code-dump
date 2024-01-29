// 1. Deposit some money
// 2. Determine number of lines to bet
// 3. Collect a bet amount
// 4. Spin the slot machine
// 5. Check if the user won
// 6. Give use their winnings
// 7. Play again?

// import prompting function from package
const prompt = require("prompt-sync")();

const ROWS = 3;
const COLS = 3;

// key value pairs of symbols and how often they appear in a column (this is an object)
const SYMBOLS_COUNT = {
    A: 2,
    B: 4,
    C: 6,
    D: 8
}

// key value pairs of symbols and their multipliers (if they are all in a row)
const SYMBOL_VALUES = {
    A: 5,
    B: 4,
    C: 3,
    D: 2
}


// Old way of making a function
    // function deposit() {
    //     return 1
    // }

// Newer method of making a function
const deposit = () => {
    while (true) {
        const depositAmount = prompt("Enter a deposit amount: $");
        const numberDepositAmount = parseFloat(depositAmount);
        if (isNaN(numberDepositAmount) || numberDepositAmount <= 0) {
            console.log("Invalid deposit amount, try again.");
        }
        else {
            return numberDepositAmount;
        }
    }
}

const getNumberOfLines = () => {
    while (true) {
        const lines = prompt("Enter the amount of lines you wish to bet on (1-3): ");
        const numOfLines = parseFloat(lines);
        if (isNaN(numOfLines) || numOfLines < 1 || numOfLines > 3 || !Number.isInteger(numOfLines)) {
            console.log("Invalid number of lines, try again.");
        }
        else {
            return numOfLines;
        }
    }
}

const getBet = (balance, lines) => {
    while (true) {
        const bet = prompt("Enter the bet per line: $");
        const numBet = parseFloat(bet);
        if (isNaN(numBet) || numBet <= 0 || numBet > balance/lines) {
            console.log("Invalid bet, try again.");
        }
        else {
            return numBet;
        }
    }
}

const spin = () => {
    const symbols = [];
    // Double for loop puts all the symbols in a column (with repeptition) into an array
    for (const [symbol, count] of Object.entries(SYMBOLS_COUNT)) {
        for (let i = 0; i < count; i++) {
            symbols.push(symbol);
        }
    }

    const reels = [];
    for (let i = 0; i < COLS; i++) {
        // adds a reel column for every column (done this way so if we change the amount of cols it still works)
        reels.push([])
        // makes a shallow copy of symbols array
        const reelSymbols = [...symbols];
        for (let j = 0; j < ROWS; j++) {
            // creates a random index by multiplying random by symbols length and round down as indices start at 0
            const randomIndex = Math.floor(Math.random() * reelSymbols.length);
            const selectedSymbol = reelSymbols[randomIndex];
            reels[i].push(selectedSymbol);
            // removes one copy of the selected symbol from reel so its not selected again when generating the reel (reels have 3 rows)
            reelSymbols.splice(randomIndex, 1);
        }
    }
    return reels;
}

// we need to transpose, as reels is a list of lists which contain the results for each column instead of row
const transpose = (reels) => {
    const rows = [];
    for (let i = 0; i < ROWS; i++) {
        // so function works for any amount of rows
        rows.push([]);
        for (let j = 0; j < COLS; j++) {
            rows[i].push(reels[j][i]);
        }
    }
    return rows;
}

const printSlot = (rows) => {
    for (const row of rows) {
        let rowString = "";
        for (const [i, symbol] of row.entries()) {
            rowString += symbol;
            if (i != rows.length - 1) {
                rowString += " | ";
            }
        }
        // Prints each row in order
        console.log(rowString);
    }
}

const getWinnings = (rows, bet, lines) => {
    let winnings = 0;

    for (let row = 0; row < lines; row++) {
        const symbols = rows[row];
        let allSame = true;
        // checks if all symbols in row are the same (equals the first one)
        for(const symbol of symbols) {
            if(symbol != symbols[0]) {
                allSame = false;
                break;
            }
        }
        // multiplies bet by value of symbol multiplier, and adds to winnings
        if (allSame) {
            winnings += bet * SYMBOL_VALUES[symbols[0]]
        }
    }
    if (winnings > 0) {
        console.log("You Won: $" + winnings);
    }
    else {
        console.log("Better Luck Next Time");
    }
    return winnings;
}

const game = () => {
    let balance = deposit();
    while(true) {
        console.log("Your Current Balance is $" + balance);
        const numOfLines = getNumberOfLines();
        const bet = getBet(balance, numOfLines);
        balance -= bet * numOfLines;
        const reels = spin();
        const rows = transpose(reels);
        printSlot(rows);
        const winnings = getWinnings(rows, bet, numOfLines)
        balance += winnings;
        if (balance <= 0) {
            console.log("Your balance is empty")
        }
        const replay = prompt("Would you like to play again (y/n)? ");
        if (replay != "y"){
            break;
        }
        let reUp = null;
        if (balance > 0) {
            reUp = prompt("Would you like to add to your balance (y/n)? ");
        }
        let increase = null;
        if(balance <= 0 || reUp == "y") {
            increase = deposit();
            balance += increase;
        }
    }
}

game();


