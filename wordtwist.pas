{$mode Delphi}

program wordTwist;
	uses
		Sysutils;
	const	
		test = 'test.txt';
	var
		sixLetter_count : integer;
		sixLetter_word : string[6];
		matched_count : integer;
		matched_words : array of string;

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
			writeln('The original word is ', wordd);
			writeln('After : ', newWord);
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
			writeln('Read sixletter file ');
			writeln('--------------------');
		
			AssignFile(tfIn,test);

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
				writeln('Randomed index is ', randNum);
				
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
						checkSub := false;
					{mark the ps is readed}
					randWord[ps] := '1';
					len := len - 1;
				until(len < 1);
			except
				writeln('Something is wrong here!');
				checkSub := false;
			end;
		end;


	function readDictionary( randWord : string):integer; 
		const
			test_dic = 'test_dic.txt';
			dictionary = 'dictionary.txt';
		var
			w: string[6];
			match_count : integer;
			tfIn1: TextFile;

		begin
			match_count := 0;

			writeln('Read dictionary file ');
			writeln('--------------------');
		
			AssignFile(tfIn1,test_dic);

			try
				reset(tfIn1);
				while not eof(tfIn1) do
					begin
						readln(tfIn1, w);
						writeln(w,' ',randWord);
						{if this word is sub word of randWord, 
						then add it to matched_word array}
						if checkSub(randWord,w) then 
							begin
								writeln('1');
								SetLength(matched_words, match_count+1);
								matched_words[match_count] := w;
								match_count := match_count + 1;
							end;
					end;
				{ Close the file }
				readDictionary := match_count;
				CloseFile(tfIn1);
			except
				on E: EInOutError do
					writeln('File handling error occurred. Details: ', E.Message);
			end;
		end;		
{

	}
	
	begin
		Randomize;
		sixLetter_count := 0;
		sixLetter_word := readSixLetter;
		writeln('The randomed six letter word is ', sixLetter_word);
		
		matched_count := readDictionary(sixLetter_word);
		writeln('matched words are ');
				sixLetter_count := 0;
		
		sixLetter_count := length(matched_words);
		repeat
			writeln(matched_words[sixLetter_count]);
			sixLetter_count := sixLetter_count - 1;	
		until(sixLetter_count = 0);
	end.

