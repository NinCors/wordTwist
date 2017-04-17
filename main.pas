Program main;
    const
        size = 3;
    var
        grid : array[0..size-1,0..size-1] of char;
        win : boolean;
        
    procedure createGird;
        var 
            i : integer;
            w : integer;
        begin
            for i:= 0 to size-1 do
                begin
                for w:= 0 to size-1 do
                    grid[i][w] := 'e';
                end;
        end;
    procedure print;
        var 
            i : integer;
            w : integer;
        begin
            for i:= 0 to size-1 do
                begin
                for w:= 0 to size-1 do
                    write(grid[i][w]);
                write(#13#10);
                end;
                
        end;
    procedure player;
        var
            col: integer;
            row: integer;
        begin
            row := -1;
            col := -1;
            repeat
                repeat
                    writeln('Please enter row for the move ');
                    read(row);
                until (row >= 0) AND (row < 3);
                repeat
                    writeln('Please enter col for the move ');
                    read(col);
                until (col >= 0) AND (col < 3);
            until grid[row][col] = 'e';
            grid[row][col] := 'X';
        end;
    procedure comp;
        var 
            c: integer;
            r: integer;
        begin
            repeat
            c := random(3);
            r := random(3);
            until grid[r][c] = 'e';
            writeln('I choose move ', r, ',', c);
            grid[r][c] := 'O';
        end;
    
    function checkWin(c : char): boolean;
        begin
            if grid[1][1] = c then
                begin
                    if (grid[0][0] = c) and (grid[2][2] = c) then
                        checkWin := true;
                    if (grid[0][1] = c) and (grid[2][1] = c) then
                        checkWin := true;
                    if(grid[0][2] = c) and (grid[2][0] = c) then
                        checkWin := true;
                    if(grid[1][0] = c) and (grid[1][2] = c) then
                        checkWin := true;
                end;
            if grid[0][0] = c then
                begin
                    if (grid[0][1] = c) and (grid[0][2] = c) then
                        checkWin := true;
                    if (grid[1][0] = c) and (grid[2][0] = c) then
                        checkWin := true;
                end;
            if grid[2][2] = c then
                begin
                    if (grid[0][2] = c) and (grid[1][2] = c) then
                        checkWin := true;
                    if (grid[2][0] = c) and (grid[2][1] = c) then
                        checkWin := true;
                end;
        end;
        
    function endGame: boolean;
        var
            full: boolean;
            win: boolean;
            i: integer;
            w: integer;
        begin
            endGame := false;
            full := false;
            for i:= 0 to size-1 do
                begin
                for w:= 0 to size-1 do
                    if grid[i][w] = 'e' then
                        full := true;
                end;
            if full = false then
                begin
                writeln('The deck is full!');
                endGame := true;
                end;
            win:= checkWin('X');
            if win = true then
                begin
                writeln('Congratulation User! You just win!');
                endGame := true;
                end;
            win:= checkWin('O');
            if win = true then
                begin
                writeln('Sorry you lost!');
                endGame := true;
                end;
        end;
        
begin
    win := false;
    createGird;
    print;
    repeat
        player;
        print;
        comp;
        print;
        win := endGame;
    until win = true;
end.

