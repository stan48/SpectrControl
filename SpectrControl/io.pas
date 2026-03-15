unit io;

interface

function PortReadByte(Addr: Word): Byte;

function PortReadWord(Addr: Word): Word;

function PortReadWordLS(Addr: Word): Word;

procedure PortWriteByte(Addr: Word; Value: Byte);

procedure PortWriteWord(Addr: Word; Value: Word);

procedure PortWriteWordLS(Addr: Word; Value: Word);

implementation

function PortReadByte(Addr: Word): Byte; assembler; register;
asm
        MOV     DX, AX
        IN      AL, DX
end;

function PortReadWord(Addr: Word): Word; assembler; register;
asm
        MOV     DX, AX
        IN      AX, DX
end;

function PortReadWordLS(Addr: Word): Word; assembler; register;
const
  Delay = 150;
asm
        MOV     DX, AX
        IN      AL, DX
        MOV     ECX, Delay

@1:
        LOOP    @1
        XCHG    AH, AL
        INC     DX
        IN      AL, DX
        XCHG    AH, AL
end;

procedure PortWriteByte(Addr: Word; Value: Byte); assembler; register;
asm
        XCHG    AX, DX
        OUT     DX, AL
end;

procedure PortWriteWord(Addr: word; Value: word); assembler; register;
asm
        XCHG    AX, DX
        OUT     DX, AX
end;

procedure PortWriteWordLS(Addr: word; Value: word); assembler; register;
const
  Delay = 150;
asm
        XCHG    AX, DX
        OUT     DX, AL
        MOV     ECX, Delay

@1:
        LOOP    @1
        XCHG    AH, AL
        INC     DX
        OUT     DX, AL
end;

end.

