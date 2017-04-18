{Author: Chiyu Cheng}

{$mode Delphi}

program wordTwist;
	uses
		Sysutils;
	type
		arrayString = array of string;
	const	
		test = 'test.txt';
		test_dic = 'test_dic.txt';
	var
		sixLetter_count : integer;
		sixLetter_word : string[6];

		matched_count : integer;
		matched_words : arrayString;

		input_word : string;

		guess_count : integer;{how many times user guesses}
		guess_words : arrayString; {the word lists that user guesses}
		guess_right_count : integer; {how many times user guess right}
		guess_sixLetter_count : integer;{how many times user get the real word that uses all 6 letters}
		
		game_end : boolean;

	function shuffleLetter( wordd:string ) : string;
		var
			newWord : string[6];
			rand : integer;
			count: integer;
		begin
			count := 1;
			newWord := '111111';
			rand := 0;
			repeat
				repeat
					rand := random(6) + 1;
				until(newWord[rand] = '1');
				
				newWord[rand] := wordd[count];
				count := count + 1;
			until(count > 6);
			shuffleLetter := newWord;
		end;

	function readSixLetter: string;
		const
			sixLetter = 'sixLetters.txt';
		var
			words : array of string[6];
			tfIn: TextFile;
			randNum : integer;

		begin
			AssignFile(tfIn,sixLetter);

			try
				reset(tfIn);
				while not eof(tfIn) do
					begin
						{ Reset the length every time }
						SetLength(words, sixLetter_count + 1);
						readln(tfIn, words[sixLetter_count]);
						sixLetter_count := sixLetter_count + 1;
					end;

				{ Close the file }
				CloseFile(tfIn);

				{ randomly choose the sixletter word }
				randNum := random(sixLetter_count);
				
				{ return the random choosed six character word }
				readSixLetter := shuffleLetter(words[randNum]);
			except
				on E: EInOutError do
					writeln('File handling error occurred. Details: ', E.Message);
			end;
		end;			
	

	function checkSub( randWord1 : string;  dicWord : string) : boolean;
		var
			len : integer;
			ps : integer; //position
			randWord : string[6];
			i : integer;
		
		begin
			try	
				randWord := randWord1;
				checkSub := true;
				len := length(dicWord);

				{initalize new randWord to avoid EAccessViolation}
				for i := 1 to 7 do
					randWord[i] := randWord1[i];

				repeat
					ps := pos(dicWord[len],randWord);
					if ps = 0 then
						begin
							checkSub := false;
						end
					{mark the ps is readed}
					else	
						begin
							randWord[ps] := '1';
						end;
					len := len - 1;
				until(len < 1);
			except
				writeln('Something is wrong here!');
				checkSub := false;
			end;
		end;


	function readDictionary( randWord : string):arrayString; 
		const
			dictionary = 'dictionary.txt';
		var
			w: string[6];
			match_count : integer;
			match_words : arrayString;
			tfIn1: TextFile;

		begin
			match_count := 0;
			AssignFile(tfIn1,dictionary);

			try
				reset(tfIn1);
				while not eof(tfIn1) do
					begin
						readln(tfIn1, w);
						{if this word is sub word of randWord, 
						then add it to matched_word array}
						if checkSub(randWord,w) then 
							begin
								try
									SetLength(match_words, match_count+1);
									match_words[match_count] := w;
									match_count := match_count + 1;
								except
									writeln('Something wrong here.');
								end;
							end;
					end;
				{ Close the file }
				readDictionary := match_words;
				CloseFile(tfIn1);
			except
				on E: EInOutError do
					writeln('File handling error occurred. Details: ', E.Message);
			end;
		end;		

	{check if inputword matchs with a word in some list}
	function match( inputWord : string ; words: arrayString): boolean;
		var
			len: integer;
			i: integer;
		begin
			len := length(words);
			match := false;
			for i := 0 to len-1 do
				begin
					{writeln('Input word is ', inputWord, ' list word is ', words[i]);}
					if inputWord = words[i] then
						match := true;
				end;
		end;
		
	{
		check the input words suing only the six letters provided or not
			true: didn't use six letter provided
			false: use the six letter provided 
	}
	function checkSixLetter( inputWord : string ; randWord: string): boolean;
		var 
			len: integer;
			ps: integer;
			i: integer;
		begin
			checkSixLetter := false;
			len := length(inputWord);
			for i := 1 to len do
				begin
					{writeln('input word char is ', inputWord[i],' randword is ', randWord);}
					ps := pos(inputWord[i], randWord);
					{writeln('The position is ', ps);}
					if ps = 0 then
					    checkSixLetter := true;
				end;
		end;

	{print list}
	procedure cheat( words : arrayString );
		var
			i:integer;
			len: integer;
		begin
			len := length(words);
			for i := 0 to len-1 do
				try
					writeln(words[i]);
				except
					writeln('Unexpected error');
				end;
		end;
	
	{sort matched list}
	function sort( words : arrayString ): arrayString;
		var
			i:integer;
			count:integer;
			len: integer;
			tmp: string;

		begin
			len:= length(words);
			count := 0;
			for i:= 1 to len-1 do
				begin
				count := i;	
				while (count > 0) and (length(words[count]) > length(words[count-1])) and (words[count][1] = words[count-1][1]) do
					begin
					tmp := words[count];
					words[count] := words[count-1];
					words[count-1] := tmp;
					count := count - 1;
					end;
				end;
			sort := words;
		end;

	function checkWin : boolean;
		begin
			checkWin := false;
			if (guess_right_count > matched_count/2) and (guess_sixLetter_count >= 1) then
				begin
					writeln('You win!!!!!!!!!!!');
					checkWin := true;
				end;
		end;


	begin
		Randomize;
		game_end := false;
		sixLetter_count := 0;
		guess_count := 0;
		guess_right_count := 0;
		guess_sixLetter_count := 0;
		
		sixLetter_word := readSixLetter;
		matched_words := readDictionary(sixLetter_word);
		matched_count := length(matched_words);
		sort(matched_words);

		{main game part}
		writeln(#13#10,'Hello! Welcome to play word twist game! ');
		writeln('Be nice, plz do not use /cheat command to look at the solution');	
		repeat
			writeln(#13#10,'The randomed six letter word is ', sixLetter_word);
			writeln('The possible solution num is ', matched_count);
			writeln('You guess right num : ', guess_right_count);
			writeln('Please input the possible word : ');
			readln(input_word);
			
			if input_word = 'qqq' then
				begin
					writeln('Byebye, see you later!');
					game_end := true;
				end
			else if input_word = '/cheat' then
				begin
					cheat(matched_words);
				end
			else if checkSixLetter(input_word, sixLetter_word) then
				begin
					writeln('You should use the provided letter!');
				end
			else if match(input_word, guess_words) then
				begin
					writeln('You can not input same word !');
				end
			else if match(input_word, matched_words) then
				begin
					writeln('Congratulation! You are right! ');
					SetLength(guess_words, guess_count + 1);
					guess_words[guess_count] := input_word;
					guess_count := guess_count + 1;
					guess_right_count := guess_right_count + 1;
					if length(input_word) = 6 then
						guess_sixLetter_count := guess_sixLetter_count + 1;
				end
			else
				begin
					writeln('Sorry you are wrong, plz input again! ');
					SetLength(guess_words, guess_count + 1);
					guess_words[guess_count] := input_word;
					guess_count := guess_count + 1;
				end;
			game_end := checkWin;
		until(game_end);
	end.

