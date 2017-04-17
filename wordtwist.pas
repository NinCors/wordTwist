{$mode Delphi}

program wordTwist;
	uses
		Sysutils;
	const
		dictionary = 'dictionary.txt';
	var
		sixLetter_count : integer;
		sixLetter_word : string[6];
		dictionary_count : integer;

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
			test = 'test.txt';
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
	
	
	
	{
	
	function readDictionary( randWord : string): array of string; 

	function checkSub( randWord : string, dicWord : string) : boolean;

	function game: boolean;

	}
	
	begin
		Randomize;
		sixLetter_count := 0;
		sixLetter_word := readSixLetter;
		writeln('The randomed six letter word is ', sixLetter_word);

	end.

