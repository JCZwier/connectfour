-- connectfour.lua
-- Implementation of the game 'Connect Four' | Jurgen van der Wal & Jan Christiaan Zwier
-- Version 1.0, started on 03/10/2014

-- Define local variables
local f, err = io.open ("logfile.txt", "a")

-- Configure stuff
os.execute ("cls")

-- This function writes a log message to logfile.txt
function logmessage (a)
if not f then
	return io.write (err)
end
f: write (os.date ("** %I:%M:%S %p %a %b %d, %Y"))
f: write (" :: "..a.."\n")
end

-- This function creates a new deck
function createdeck ()
deck = {}
for i = 1, 42 do 
	deck [i] = " " 
end
index = {} -- Indicates whether the cell is already occupied or not (not occupied: 0, occupied by an O: 1, occupied by an X: 10) for O's and X's
for i = 1, 42 do
	index [i] = 0
end
win = 0
end

-- This function displays the start menu
function menu ()
	io.write ("\n  --------------------------\n")
	io.write ("  ------ CONNECT FOUR ------\n")
	io.write ("  --------------------------\n\n")
	io.write ("  There are three gamemodes to play in:\n\n")
	io.write ("   1. Player vs. Player\n")
	io.write ("   2. Player vs. PC\n")
	io.write ("   3. Random vs. PC\n\n")
	io.write ("  To view the instructions, press 4.\n\n")
end

-- This function lets the player choose a gamemode
function choice ()
	io.write ("\n  Choose 1, 2, 3 or 4 [Enter]:\n\n  ")
	answer = io.read ("*number")
	while answer == nil do
		io.read ()
		return choice ()
	end
	if answer < 1 or answer > 4 then
		return choice ()
	end
	if answer == 4 then
		instructions ()
		return choice ()
	end
	os.execute ("cls")
end

-- This function shows the instructions for the game
function instructions ()
	io.write ("\n  Instructions: \n\n")
	io.write ("  This is a Lua implementation of the game Connect Four. The goal of the game\n  is to place the chips in the rows in such a way that a vertical, horizontal\n  or diagonal row of chips of the same kind is formed. Player 1 inserts the 'O'\n  chips and Player 2 the 'X' chips. There are seven rows in which the chips can\n  be thrown, by typing a number from 1 to 7. You can choose from three game\n  modes:\n\n  1. Player vs. Player: two players play against each other by choosing a row\n  in turn.\n\n  2. Player vs. PC: a player plays against the computer that tries to win from\n  the player.\n\n  3. Random vs. PC: your computer competes against the power of a random\n  algorithm. Just watch and enjoy!\n\n  When a player has won, this will be reported and the screen will be closed.\n\n")
end

-- This function regulates the sleeps that are being used throughout the whole program
function sleep (n)
	if n > 0 then
		os.execute ("ping -n " .. tonumber (n + 1) .. " localhost > NUL")
	end
end

-- This initialises the pseudo random number generator
math.randomseed (os.time ())
math.random (); math.random (); math.random ()

-- This function sets the right gamemode for the answer chosen in choice ()
function gamemode ()
	if answer == 1 then
		playernames1 ()
		turnoptions ()
		turnchoice ()
		if startplayer == 1 then
			firstturn = 1
		elseif startplayer == 2 then
			firstturn = 2
		else
			firstturn = math.random (1, 2)
		end
		if firstturn == 1 then
			io.write ("\n  " .. playername1 .. " may start the game!\n  ")
			sleep (2)
			printdeck ()
			while win == 0 do
				playervsplayer1 ()
				windetect (playername1)
				if win == 1 then
					break
				end
				playervsplayer2 ()
				windetect (playername2)
			end
		end
		if firstturn == 2 then
			io.write ("\n  " .. playername2 .. " may start the game!\n  ")
			sleep (2)
			printdeck ()
			while win == 0 do
				playervsplayer2 ()
				windetect (playername2)
				if win == 1 then
					break
				end
				playervsplayer1 ()
				windetect (playername1)
			end
		end
	end
	if answer == 2 then
		playernames2 ()
		difficulty ()
		difficultychoice ()
		turnoptions ()
		turnchoice ()
		if startplayer == 1 then
			firstturn = 1
		elseif startplayer == 2 then
			firstturn = 2
		else
			firstturn = math.random (1, 2)
		end
		if firstturn == 1 then
			io.write ("\n  " .. playername .. " may start the game!\n  ")
			sleep (2)
			printdeck ()
			while win == 0 do
				playervspc1 ()
				windetect (playername)
				if win == 1 then
					break
				end
				playervspc2 ()
				windetect ("The PC")
			end
		end
		if firstturn == 2 then
			io.write ("\n  The PC may start the game!\n  ")
			sleep (2)
			printdeck ()
			while win == 0 do
				playervspc2 ()
				windetect ("The PC")
				if win == 1 then
					break
				end
				playervspc1 ()
				windetect (playername)
			end
		end
	end
	if answer == 3 then
		difficulty ()
		difficultychoice ()
		turnoptions ()
		turnchoice ()
		if startplayer == 1 then
			firstturn = 1
		elseif startplayer == 2 then
			firstturn = 2
		else
			firstturn = math.random (1, 2)
		end
		if firstturn == 1 then
			printdeck ()
			io.write ("  The random algorithm may start the game!\n  ")
			sleep (2)
			while win == 0 do
				autoplay1 ()
				windetect ("The random algorithm")
				if win == 1 then
					break
				end
				io.write ("  Random algorithm's turn... (O)\n  ")
				sleep (2)
				autoplay2 ()
				windetect ("The PC")
				if win == 1 then
					break
				end
				io.write ("  PC's turn... (X)\n  ")
				sleep (2)
			end
		end
		if firstturn == 2 then
			printdeck ()
			io.write ("  The PC may start the game!\n  ")
			sleep (2)
			while win == 0 do
				autoplay2 ()
				windetect ("The PC")
				if win == 1 then
					break
				end
				io.write ("  PC's turn... (X)\n  ")
				sleep (2)
				autoplay1 ()
				windetect ("The random algorithm")
				if win == 1 then
					break
				end
				io.write ("  Random algorithm's turn... (O)\n  ")
				sleep (2)
			end
		end
	end
end

-- These two functions let the players choose a name in Player vs. Player
function playernames1 ()
    io.write ("\n  Player 1, choose a name [Enter]: ")
	io.read ()
    playername1 = io.read ()
	if playername1 == "" then
		playername1 = "Player 1"
	end
    os.execute ("cls")
    io.write ("\n  Player 2, choose a name [Enter]: ")
    playername2 = io.read ()
	if playername2 == "" then
		playername2 = "Player 2"
	end
	os.execute ("cls")
end

-- For the player in Player vs. PC
function playernames2 ()
	io.write ("\n  Player, choose a name [Enter]: ")
	io.read ()
	playername = io.read ()
	if playername == "" then
		playername = "Player"
	end
	os.execute ("cls")
end

-- These two functions let the player choose the difficulty of the game
function difficulty ()
	if answer == 2 then
		io.write ("\n  There are three difficulty levels to play in:\n\n")
	end
	if answer == 3 then
		io.write ("\n  There are three difficulty levels to set the PC to:\n\n")
	end
	io.write ("   1. Easy mode\n")
	io.write ("   2. Normal mode\n")
	io.write ("   3. Hard mode\n\n")
end

function difficultychoice ()
	io.write ("\n  Choose 1, 2 or 3 [Enter]:\n\n  ")
	difficulty = io.read ("*number")
	while difficulty == nil do
		io.read ()
		return difficultychoice ()
	end
	if difficulty < 1 or difficulty > 3 then
		return difficultychoice ()
	end
	os.execute ("cls")
end

-- These two functions let the players choose which player may start the game, or can choose for a random first turn
function turnoptions ()
	if answer == 1 then
		io.write ("\n  Choose which player may start the game:\n\n  ")
		io.write ("1. " .. playername1 .. "\n  ")
		io.write ("2. " .. playername2 .. "\n\n  ")
		io.write ("For a random first turn, choose 3.\n\n\n  ")
		io.write ("Choose 1, 2 or 3 [Enter]:\n\n  ")
	end
	if answer == 2 then
		io.write ("\n  Choose which player may start the game:\n\n  ")
		io.write ("1. " .. playername .. "\n  ")
		io.write ("2. The PC\n\n  ")
		io.write ("For a random first turn, choose 3.\n\n\n  ")
		io.write ("Choose 1, 2 or 3 [Enter]:\n\n  ")
	end
	if answer == 3 then
		io.write ("\n  Choose which player may start the game:\n\n  ")
		io.write ("1. The random algorithm\n  ")
		io.write ("2. The PC\n\n  ")
		io.write ("For a random first turn, choose 3.\n\n\n  ")
		io.write ("Choose 1, 2 or 3 [Enter]:\n\n  ")
	end
end

function turnchoice ()
	startplayer = io.read ("*number")
	while startplayer == nil do
		io.read ()
		return turnchoice ()
	end
	if startplayer < 1 or startplayer > 3 then
		return turnchoice ()
	end
	os.execute ("cls")
end

-- This function prints the deck
function printdeck ()
	os.execute ("cls")
	io.write ("\n  -----------------------------------------")
	io.write ("\n  --------------CONNECT  FOUR--------------")
	io.write ("\n  -----------------------------------------")
	io.write ("\n  ------  1   2   3   4   5   6   7  ------")
	io.write ("\n  ------|   |   |   |   |   |   |   |------")
	io.write ("\n  ------| "..deck [36].." | "..deck [37].." | "..deck [38].." | "..deck [39].." | "..deck [40].." | "..deck [41].." | "..deck [42].." |------")
	io.write ("\n  ------|   |   |   |   |   |   |   |------")
	io.write ("\n  ------| "..deck [29].." | "..deck [30].." | "..deck [31].." | "..deck [32].." | "..deck [33].." | "..deck [34].." | "..deck [35].." |------")
	io.write ("\n  ------|   |   |   |   |   |   |   |------")
	io.write ("\n  ------| "..deck [22].." | "..deck [23].." | "..deck [24].." | "..deck [25].." | "..deck [26].." | "..deck [27].." | "..deck [28].." |------")
	io.write ("\n  ------|   |   |   |   |   |   |   |------")
	io.write ("\n  ------| "..deck [15].." | "..deck [16].." | "..deck [17].." | "..deck [18].." | "..deck [19].." | "..deck [20].." | "..deck [21].." |------")
	io.write ("\n  ------|   |   |   |   |   |   |   |------")
	io.write ("\n  ------| "..deck [8].." | "..deck [9].." | "..deck [10].." | "..deck [11].." | "..deck [12].." | "..deck [13].." | "..deck [14].." |------")
	io.write ("\n  ------|   |   |   |   |   |   |   |------")
	io.write ("\n  ------| "..deck [1].." | "..deck [2].." | "..deck [3].." | "..deck [4].." | "..deck [5].." | "..deck [6].." | "..deck [7].." |------")
	io.write ("\n  -----------------------------------------\n\n")
end

-- These two functions let a player play against another (playervsplayer1 and playervsplayer2)
function playervsplayer1 ()
	io.write ("  " .. playername1 .. " (O) [Enter]: ")
    player1 = io.read ("*number")
	while player1 == nil do
		io.write ("\n  That is not a number. Please enter a number from 1 to 7:\n\n")
		io.read ()
		return playervsplayer1 ()
	end
	if player1 < 1 or player1 > 7 then
		io.write ("\n  That is not a valid row number. Please enter a number from 1 to 7:\n\n")
		return playervsplayer1 ()
	end
	if player1 >= 1 or player1 <= 7 then
		-- This is the variable which determines how much cells the concerning cell is above the ground cell
		w = 0
		while index [player1 + w * 7] == 1 or index [player1 + w * 7] == 10 do
			w = w + 1
		end
		if w > 5 then
			io.write ("\n  That row is already full. Please choose another (emptier) row:\n\n")
			return playervsplayer1 ()
		else
			player1 = player1 + w * 7
			deck [player1] = "O"
			index [player1] = 1
			printdeck ()
		end
	end
end

function playervsplayer2 ()
	io.write ("  " .. playername2 .. " (X) [Enter]: ")
	player2 = io.read ("*number")
	while player2 == nil do
		io.write ("\n  That is not a number. Please enter a number from 1 to 7:\n\n")
		io.read ()
		return playervsplayer2 ()
	end
	if player2 < 1 or player2 > 7 then
		io.write ("\n  That is not a valid row number. Please enter a number from 1 to 7:\n\n")
		return playervsplayer2 ()
	end
	if player2 >= 1 or player2 <= 7 then
		x = 0
		while index [player2 + x * 7] == 1 or index [player2 + x * 7] == 10 do
			x = x + 1
		end
		if x > 5 then
			io.write ("\n  That row is already full. Please choose another (emptier) row:\n\n")
			return playervsplayer2 ()
		else
			player2 = player2 + x * 7
			deck [player2] = "X"
			index [player2] = 10
			printdeck ()
		end
	end
end

-- These two functions let the player play against the PC (playervspc1 and playervspc2)
function playervspc1 ()
	io.write ("  " .. playername .. " (O) [Enter]: ")
    player = io.read ("*number")
	if player < 1 or player > 7 then
		io.write ("\n  That is not a valid row number. Please enter a number from 1 to 7:\n\n")
		return playervspc1 ()
	end
	if player >= 1 or player <= 7 then
		y = 0
		while index [player + y * 7] == 1 or index [player + y * 7] == 10 do
			y = y + 1
		end
		if y > 5 then
			io.write ("\n  That row is already full. Please choose another (emptier) row:\n\n")
			return playervspc1 ()
		else
			player = player + y * 7
			deck [player] = "O"
			index [player] = 1
			printdeck ()
		end
	end
end

function playervspc2 ()
	io.write ("  PC's turn... (X)\n  ")
	sleep (1)
	priority = {} -- Indicates the priority for each cell, ranging from 0 to 6
	for i = 1, 42 do
		priority [i] = 0
	end
	if index [4] == 0 then
		pc = 4
	else
		intelligence ()
	end
	if pc == nil then
		pc = math.random (1, 7)
	end
	z = 0
	while index [pc + z * 7] == 1 or index [pc + z * 7] == 10 do
		z = z + 1
	end
	if z > 5 then
		return playervspc2 ()
	else
		pc = pc + z * 7
		deck [pc] = "X"
		index [pc] = 10
		printdeck ()
	end
	io.write ("  PC's turn is over.\n\n")
end

-- These two functions let the computer play against a random algorithm (autoplay1 and autoplay2)
function autoplay1 ()
	random1 = math.random (1, 7)
	p = 0
	while index [random1 + p * 7] == 1 or index [random1 + p * 7] == 10 do
		p = p + 1
	end
	if p > 5 then
		return autoplay1 ()
	else
		random1 = random1 + p * 7
		deck [random1] = "O"
		index [random1] = 1
		printdeck ()
	end
end

function autoplay2 ()
	priority = {}
	for i = 1, 42 do
		priority [i] = 0
	end
	if index [4] == 0 then
		pc = 4
	else
		intelligence ()
	end
	if pc == nil then
		pc = math.random (1, 7)
	end
	q = 0
	while index [pc + q * 7] == 1 or index [pc + q * 7] == 10 do
		q = q + 1
	end
	if q > 5 then
		return autoplay1 ()
	else
		pc = pc + q * 7
		deck [pc] = "X"
		index [pc] = 10
		printdeck ()
	end
end

-- This gets the number of entries in a table
function tablelength (t)
  local count = 0
  for _ in pairs (t) do count = count + 1 end
  return count
end

-- This function creates the artificial intelligence of the PC, to improve its choices in the game and to make it harder for the player to win from it.
function intelligence ()
	for r = 1, 39 do
		if r == 1 or r == 2 or r == 3 or r == 4 or r % 7 == 1 or r % 7 == 2 or r % 7 == 3 or r % 7 == 4 then
			horizontalturn = index [r]
			if horizontalturn + index [r + 1] + index [r + 2] == 30 then
				if index [r - 1] ~= 1 and index [r - 1] ~= 10 and index [r - 1] ~= nil then
					if (index [r - 8] == 1 or index [r - 8] == 10 or index [r - 8] == nil) and priority [r - 1] <= 6 then
						priority [r - 1] = 6
					end
				end
				if index [r + 3] ~= 1 and index [r + 3] ~= 10 then
					if (index [r - 4] == 1 or index [r - 4] == 10 or index [r - 4] == nil) and priority [r + 3] <= 6 then
						priority [r + 3] = 6
					end
				end
			end
			if horizontalturn + index [r + 1] + index [r + 2] == 3 then
				if index [r - 1] ~= 1 and index [r - 1] ~= 10 and index [r - 1] ~= nil then
					if (index [r - 8] == 1 or index [r - 8] == 10 or index [r - 8] == nil) and priority [r - 1] <= 5 then
						priority [r - 1] = 5
					end
				end
				
				if index [r + 3] ~= 1 and index [r + 3] ~= 10 then
					if (index [r - 4] == 1 or index [r - 4] == 10 or index [r - 4] == nil) and priority [r + 3] <= 5 then
						priority [r + 3] = 5
					end
				end
			end
			if difficulty == 2 or difficulty == 3 then
				if horizontalturn + index [r + 1] == 20 then
					if index [r - 1] ~= 1 and index [r - 1] ~= 10 and index [r - 1] ~= nil then
						if (index [r - 8] == 1 or index [r - 8] == 10 or index [r - 8] == nil) and priority [r - 1] <= 4 then
							priority [r - 1] = 4
						end
					end
					if index [r + 2] ~= 1 and index [r + 2] ~= 10 then
						if (index [r - 5] == 1 or index [r - 5] == 10 or index [r - 5] == nil) and priority [r + 2] <= 4 then
							priority [r + 2] = 4
						end
					end
				end
				if horizontalturn + index [r + 1] == 2 then
					if index [r - 1] ~= 1 and index [r - 1] ~= 10 and index [r - 1] ~= nil then
						if (index [r - 8] == 1 or index [r - 8] == 10 or index [r - 8] == nil) and priority [r - 1] <= 3 then
							priority [r - 1] = 3
						end
					end
					if index [r + 2] ~= 1 and index [r + 2] ~= 10 then
						if (index [r - 5] == 1 or index [r - 5] == 10 or index [r - 5] == nil) and priority [r + 2] <= 3 then
							priority [r + 2] = 3
						end
					end
				end
			end
			if difficulty == 3 then
				if horizontalturn == 10 then
					if index [r - 1] ~= 1 and index [r - 1] ~= 10 and index [r - 1] ~= nil then
						if (index [r - 8] == 1 or index [r - 8] == 10 or index [r - 8] == nil) and priority [r - 1] <= 2 then
							priority [r - 1] = 2
						end
					end
					if index [r + 1] ~= 1 and index [r + 1] ~= 10 then
						if (index [r - 6] == 1 or index [r - 6] == 10 or index [r - 6] == nil) and priority [r + 1] <= 2 then
							priority [r + 1] = 2
						end
					end
				end
				if horizontalturn == 1 then
					if index [r - 1] ~= 1 and index [r - 1] ~= 10 and index [r - 1] ~= nil then
						if (index [r - 8] == 1 or index [r - 8] == 10 or index [r - 8] == nil) and priority [r - 1] <= 1 then
							priority [r - 1] = 1
						end
					end
					if index [r + 1] ~= 1 and index [r + 1] ~= 10 then
						if (index [r - 6] == 1 or index [r - 6] == 10 or index [r - 6] == nil) and priority [r + 1] <= 1 then
							priority [r + 1] = 1
						end
					end
				end
			end
		end
	end
	for r = 1, 21 do
		verticalturn = index [r]
		if verticalturn + index [r + 7] + index [r + 14] == 30 then
			if index [r + 21] ~= 1 and index [r + 21] ~= 10 then
				if priority [r + 21] <= 6 then
					priority [r + 21] = 6
				end
			end
		end
		if verticalturn + index [r + 7] + index [r + 14] == 3 then
			if index [r + 21] ~= 1 and index [r + 21] ~= 10 then
				if priority [r + 21] <= 5 then
					priority [r + 21] = 5
				end
			end
		end
		if difficulty == 2 or difficulty == 3 then
			if verticalturn + index [r + 7] == 20 then
				if index [r + 14] ~= 1 and index [r + 14] ~= 10 then
					if priority [r + 14] <= 4 then
						priority [r + 14] = 4
					end
				end
			end
			if verticalturn + index [r + 7] == 2 then
				if index [r + 14] ~= 1 and index [r + 14] ~= 10 then
					if priority [r + 14] <= 3 then
						priority [r + 14] = 3
					end
				end
			end
		end
		if difficulty == 3 then
			if verticalturn == 10 then
				if index [r + 7] ~= 1 and index [r + 7] ~= 10 then
					if priority [r + 7] <= 2 then
						priority [r + 7] = 2
					end
				end
			end
			if verticalturn == 1 then
				if index [r + 7] ~= 1 and index [r + 7] ~= 10 then
					if priority [r + 7] <= 1 then
						priority [r + 7] = 1
					end
				end
			end
		end
	end
	for r = 1, 18 do
		if r == 1 or r == 2 or r == 3 or r == 4 or r % 7 == 1 or r % 7 == 2 or r % 7 == 3 or r % 7 == 4 then
			diagonalforwardturn = index [r]
			if diagonalforwardturn + index [r + 8] + index [r + 16] == 30 then
				if index [r - 8] ~= 1 and index [r - 8] ~= 10 and index [r - 8] ~= nil then
					if (index [r - 15] == 1 or index [r - 15] == 10 or index [r - 15] == nil) and priority [r - 8] <= 6 then
						priority [r - 8] = 6
					end
				end
				if index [r + 24] ~= 1 and index [r + 24] ~= 10 then
					if (index [r + 17] == 1 or index [r + 17] == 10) and priority [r + 24] <= 6 then
						priority [r + 24] = 6
					end
				end
			end
			if diagonalforwardturn + index [r + 8] + index [r + 16] == 3 then
				if index [r - 8] ~= 1 and index [r - 8] ~= 10 and index [r - 8] ~= nil then
					if (index [r - 15] == 1 or index [r - 15] == 10 or index [r - 15] == nil) and priority [r - 8] <= 5 then
						priority [r - 8] = 5
					end
				end
				if index [r + 24] ~= 1 and index [r + 24] ~= 10 then
					if (index [r + 17] == 1 or index [r + 17] == 10) and priority [r + 24] <= 5 then
						priority [r + 24] = 5
					end
				end
			end
			if difficulty == 2 or difficulty == 3 then
				if diagonalforwardturn + index [r + 8] == 20 then
					if index [r - 8] ~= 1 and index [r - 8] ~= 10 and index [r - 8] ~= nil then
						if (index [r - 15] == 1 or index [r - 15] == 10 or index [r - 15] == nil) and priority [r - 8] <= 4 then
							priority [r - 8] = 4
						end
					end
					if index [r + 16] ~= 1 and index [r + 16] ~= 10 then
						if (index [r + 9] == 1 or index [r + 9] == 10) and priority [r + 16] <= 4 then
							priority [r + 16] = 4
						end
					end
				end
				if diagonalforwardturn + index [r + 8] == 2 then
					if index [r - 8] ~= 1 and index [r - 8] ~= 10 and index [r - 8] ~= nil then
						if (index [r - 15] == 1 or index [r - 15] == 10 or index [r - 15] == nil) and priority [r - 8] <= 3 then
							priority [r - 8] = 3
						end
					end
					if index [r + 16] ~= 1 and index [r + 16] ~= 10 then
						if (index [r + 9] == 1 or index [r + 9] == 10) and priority [r + 16] <= 3 then
							priority [r + 16] = 3
						end
					end
				end
			end
			if difficulty == 3 then
				if diagonalforwardturn == 10 then
					if index [r - 8] ~= 1 and index [r - 8] ~= 10 and index [r - 8] ~= nil then
						if (index [r - 15] == 1 or index [r - 15] == 10 or index [r - 15] == nil) and priority [r - 8] <= 2 then
							priority [r - 8] = 2
						end
					end
					if index [r + 8] ~= 1 and index [r + 8] ~= 10 then
						if (index [r + 1] == 1 or index [r + 1] == 10) and priority [r + 8] <= 2 then
							priority [r + 8] = 2
						end
					end
				end
				if diagonalforwardturn == 1 then
					if index [r - 8] ~= 1 and index [r - 8] ~= 10 and index [r - 8] ~= nil then
						if (index [r - 15] == 1 or index [r - 15] == 10 or index [r - 15] == nil) and priority [r - 8] <= 1 then
							priority [r - 8] = 1
						end
					end
					if index [r + 8] ~= 1 and index [r + 8] ~= 10 then
						if (index [r + 1] == 1 or index [r + 1] == 10) and priority [r + 8] <= 1 then
							priority [r + 8] = 1
						end
					end
				end
			end
		end
	end
	for r = 1, 24 do
		if r == 4 or r == 5 or r == 6 or r == 7 or r % 7 == 4 or r % 7 == 5 or r % 7 == 6 or r % 7 == 0 then
			diagonalbackwardturn = index [r]
			if diagonalbackwardturn + index [r + 6] + index [r + 12] == 30 then
				if index [r - 6] ~= 1 and index [r - 6] ~= 10 and index [r - 6] ~= nil then
					if (index [r - 13] == 1 or index [r - 13] == 10 or index [r - 13] == nil) and priority [r - 6] <= 6 then
						priority [r - 6] = 6
					end
				end
				if index [r + 18] ~= 1 and index [r + 18] ~= 10 then
					if (index [r + 11] == 1 or index [r + 11] == 10) and priority [r + 18] <= 6 then
						priority [r + 18] = 6
					end
				end
			end
			if diagonalbackwardturn + index [r + 6] + index [r + 12] == 3 then
				if index [r - 6] ~= 1 and index [r - 6] ~= 10 and index [r - 6] ~= nil then
					if (index [r - 13] == 1 or index [r - 13] == 10 or index [r - 13] == nil) and priority [r - 6] <= 5 then
						priority [r - 6] = 5
					end
				end
				if index [r + 18] ~= 1 and index [r + 18] ~= 10 then
					if (index [r + 11] == 1 or index [r + 11] == 10) and priority [r + 18] <= 5 then
						priority [r + 18] = 5
					end
				end
			end
			if difficulty == 2 or difficulty == 3 then
				if diagonalbackwardturn + index [r + 6] == 20 then
					if index [r - 6] ~= 1 and index [r - 6] ~= 10 and index [r - 6] ~= nil then
						if (index [r - 13] == 1 or index [r - 13] == 10 or index [r - 13] == nil) and priority [r - 6] <= 4 then
							priority [r - 6] = 4
						end
					end
					if index [r + 12] ~= 1 and index [r + 12] ~= 10 then
						if (index [r + 5] == 1 or index [r + 5] == 10) and priority [r + 12] <= 4 then
							priority [r + 12] = 4
						end
					end
				end
				if diagonalbackwardturn + index [r + 6] == 2 then
					if index [r - 6] ~= 1 and index [r - 6] ~= 10 and index [r - 6] ~= nil then
						if (index [r - 13] == 1 or index [r - 13] == 10 or index [r - 13] == nil) and priority [r - 6] <= 3 then
							priority [r - 6] = 3
						end
					end
					if index [r + 12] ~= 1 and index [r + 12] ~= 10 then
						if (index [r + 5] == 1 or index [r + 5] == 10) and priority [r + 12] <= 3 then
							priority [r + 12] = 3
						end
					end
				end
			end
			if difficulty == 3 then
				if diagonalbackwardturn == 10 then
					if index [r - 6] ~= 1 and index [r - 6] ~= 10 and index [r - 6] ~= nil then
						if (index [r - 13] == 1 or index [r - 13] == 10 or index [r - 13] == nil) and priority [r - 6] <= 2 then
							priority [r - 6] = 2
						end
					end
					if index [r + 12] ~= 1 and index [r + 12] ~= 10 then
						if (index [r - 1] == 1 or index [r - 1] == 10 or index [r - 1] == nil) and priority [r + 6] <= 2 then
							priority [r + 6] = 2
						end
					end
				end
				if diagonalbackwardturn == 1 then
					if index [r - 6] ~= 1 and index [r - 6] ~= 10 and index [r - 6] ~= nil then
						if (index [r - 13] == 1 or index [r - 13] == 10 or index [r - 13] == nil) and priority [r - 6] <= 1 then
							priority [r - 6] = 1
						end
					end
					if index [r + 6] ~= 1 and index [r + 6] ~= 10 then
						if (index [r - 1] == 1 or index [r - 1] == 10 or index [r - 1] == nil) and priority [r + 6] <= 1 then
							priority [r + 6] = 1
						end
					end
				end
			end
		end
	end
	-- This determines the maximum value of the priority table
	max_val, key = -math.huge
	for k, v in pairs (priority) do
		if v > max_val then
			max_val, key = v, k
		end
	end
	-- This puts all keys with the maximum priority in a new table
	highestpriority = {}
	for i, v in ipairs (priority) do
		if v == max_val then
			table.insert (highestpriority, 1, i)
		end
	end
	-- This determines the length of the highestpriority table and selects a random key, thus a row, for pc
	entrykeys = tablelength (highestpriority)
	randomentryvalue = (highestpriority [math.random (entrykeys)])
	pc = randomentryvalue % 7
	if pc == 0 then
		pc = 7
	end
end

-- These function checks if there are four cells of the same kind on a row (vertical, horizontal and diagonal) and detects them by counting if there is a certain pattern to be recognized in the array. After detecting four on a row, the player who has achieved this, wins the game.
function windetect (player)
	for s = 1, 39 do
		if s == 1 or s == 2 or s == 3 or s == 4 or s % 7 == 1 or s % 7 == 2 or s % 7 == 3 or s % 7 == 4 then
			horizontalwin = index [s] + index [s + 1] + index [s + 2] + index [s + 3]
			if horizontalwin ==  4 or horizontalwin == 40 then
				win = 1
			end
		end
	end
	for s = 1, 21 do
		verticalwin = index [s] + index [s + 7] + index [s + 14] + index [s + 21]
		if verticalwin == 4 or verticalwin == 40 then
			win = 1
		end
	end
	for s = 1, 18 do
		if s == 1 or s == 2 or s == 3 or s == 4 or s % 7 == 1 or s % 7 == 2 or s % 7 == 3 or s % 7 == 4 then
			diagonalforwardwin = index [s] + index [s + 8] + index [s + 16] + index [s + 24]
			if diagonalforwardwin == 4 or diagonalforwardwin == 40 then
				win = 1
			end
		end
	end
	for s = 1, 24 do
		if s == 4 or s == 5 or s == 6 or s == 7 or s % 7 == 4 or s % 7 == 5 or s % 7 == 6 or s % 7 == 0 then
			diagonalbackwardwin = index [s] + index [s + 6] + index [s + 12] + index [s + 18]
			if diagonalbackwardwin == 4 or diagonalbackwardwin == 40 then
				win = 1
			end
		end
	end
	if win == 1 then
		io.write ("  " .. player .. " has won the game! The screen will close in 5 seconds...")
		sleep (5)
	end
end

-- Main
logmessage ("Program Started")
createdeck ()
menu ()
choice ()
gamemode ()
logmessage ("Program Ended")
f: close ()
