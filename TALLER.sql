
----PRIMER PUNTO

DROP TABLE climaexistente;
CREATE TABLE climaexistente( ---WE CREATE THE ORIGINAL TABLE FOR THIS POINT
 pais VARCHAR2(15),
 dpto VARCHAR2(15),
 clima VARCHAR2(15),
 PRIMARY KEY(pais,dpto,clima)
);

INSERT INTO climaexistente VALUES('Colombia','Antioquia','Templado');-- WE INSERT THE RECORDS GIVEN IN THE EXCERSICE
INSERT INTO climaexistente VALUES('Colombia','Antioquia','Cálido');
INSERT INTO climaexistente VALUES('Colombia','Bolívar','Cálido');
INSERT INTO climaexistente VALUES('Colombia','Bolívar','Horneante');
INSERT INTO climaexistente VALUES('Colombia','Nariño','Templado');
INSERT INTO climaexistente VALUES('Colombia','Nariño','Glacial');

drop table w_climas;-- WE CREATE THIS TABLE FOR TO SAVE ALL POSSIBLE COMBINATIONS BETWEEN DEPARTMENTS AND WEATHERS
create table w_climas(
 w_dpto VARCHAR2(15),
 w_clima VARCHAR2(15),
PRIMARY KEY(w_dpto,w_clima)
);

INSERT INTO w_climas VALUES('Antioquia','Templado');-- WE INSERT ALL POSSIBLE COMBINATIONS BETWEEN DEPARTMENTS AND WEATHERS
INSERT INTO w_climas VALUES('Antioquia','Cálido');
INSERT INTO w_climas VALUES('Antioquia','Horneante');
INSERT INTO w_climas VALUES('Antioquia','Glacial');
INSERT INTO w_climas VALUES('Bolívar','Cálido');
INSERT INTO w_climas VALUES('Bolívar','Horneante');
INSERT INTO w_climas VALUES('Bolívar','Templado');
INSERT INTO w_climas VALUES('Bolívar','Glacial');
INSERT INTO w_climas VALUES('Nariño','Templado');
INSERT INTO w_climas VALUES('Nariño','Glacial');
INSERT INTO w_climas VALUES('Nariño','Cálido');
INSERT INTO w_climas VALUES('Nariño','Horneante');


declare

departamento1 varchar2(15);-- VARIABLE FOR THE DEPARTMENT IN W_CLIMAS TABLE
departamento2 varchar2(15);-- VARIABLE FOR THE DEPARTMENT IN THE ORIGINAL TABLE
clima1 varchar2(15);--VARIABLE FOR THE WEATHER IN W_CLIMAS TABLE
clima2 varchar2(15);--VARIABLE FOR THE WEATHER IN THE ORIGINAL TABLE


cursor climaInicial (depart varchar2, cli varchar2) is select dpto, clima from climaexistente where dpto= depart and clima = cli;-- CURSOR FOR TO GET THE RECORDS FROM ORIGINAL TABLE WHICH HAVE THE SAME DEPARTMENT AND WEATHER THAN THE W_CLIMAS TABLE
cursor climaRepetido is select w_dpto,w_clima from w_climas; --CURSOR FOR TO GET ALL RECORDS OF THE W_CLIMAS TABLE

begin

departamento1:= '';-- WE INITIABILIZE THE VARIABLES
clima1:='';
departamento2:= '';
clima2:= '';

         open climaRepetido;-- WE OPEN THE FIRST CURSOR
         fetch climaRepetido into departamento1,clima1;-- WE SAVE THE RESULT OF THE query IN TWO VARIABLES (DEPARTAMENTO1, CLIMA1)
         while climaRepetido%found loop--WE DO A WHILE FOR TO ITERATE THE CURSOR
                open climaInicial(departamento1, clima1);-- WE OPEN THE SECOND CURSOR
                fetch climaInicial into departamento2,clima2;-- WE SAVE ITS RESAULT IN DEPARTAMENTO2, CLIMA2
                if clima1<>clima2 then-- IF THE WEATHER IN W_CLIMAS IS NOT IN THE ORIGINAL TABLE IS BECAUSE THE CONDITION OF THE PROBLEM IS ACCOMPLISHING
                        DBMS_OUTPUT.PUT_LINE(departamento1 ||'  '|| clima1);-- WE SHOW THE RESULT (THE DEPARTMENTS AND WEATHERS THAT AREN'T IN THE ORIGINAL TABLE BUT THEY'RE IN THE W_CLIMAS)
                end if;
                fetch climaRepetido into departamento1,clima1;--WE ITERATE IN THE PRINCIPAL CURSOR                
                close climaInicial;--WE CLOSE THE SECUNDARY CURSOR
         end loop;
         close climaRepetido;--WE CLOSE THE PRINCIPAL CURSOR
    
end;





------ SEGUNDO PUNTO ---------------------
CREATE TABLE mesada (
     id_receptor NUMBER(8) PRIMARY KEY,
     id_benefactor  NUMBER(8) REFERENCES mesada,
     valor NUMBER(6)
    );
INSERT INTO mesada VALUES (10, null, 0);
INSERT INTO mesada VALUES (20, 10, 70);
INSERT INTO mesada VALUES (30, 10, 80);
INSERT INTO mesada VALUES (40, 20, 90);
INSERT INTO mesada VALUES (50, 20, 20);
INSERT INTO mesada VALUES (60, 40, 20);
INSERT INTO mesada VALUES (70, 50, 55);
INSERT INTO mesada VALUES (80, 30, 25);
INSERT INTO mesada VALUES (90, 60, 50);

    SELECT * FROM mesada;                                                                           -----> VIEW OF TABLE WITH WHOLE REGISTERS
    SELECT * FROM mesada WHERE id_benefactor = 20;                                                  -----> VIEW OF TABLE WHERE THE REGISTERS ID IS 20



DECLARE
ammount NUMBER(20) := 0;                                                                            -----> Initialize the variable that will store the total ammount from the first benefactor to the last
benefactor mesada.id_benefactor%TYPE;                                                               -----> Temporal variable as id_benefactor type
valor mesada.valor%TYPE;                                                                            -----> Temporal variable as value type
receptor mesada.id_receptor%TYPE;                                                                   -----> Temporal variable as id_receptor type
CURSOR getBenefactor (id NUMBER) is SELECT id_receptor, valor from mesada where id_benefactor=id;   -----> Method to get the receptor and value, where the benefactor is the same as id parameter
CURSOR getReceptor (id NUMBER) is SELECT valor from mesada where id_benefactor=id;                  -----> Method to get the value of transfer where the id parameter is ID.
BEGIN 
    receptor := 0;                                                                                  -----> Initializing the variable receptor 
    valor := 0;                                                                                     -----> Initializing the variable value  
    benefactor := &Benefactor_Search;                                                               -----> Initializing the variable benefactor, with the user input
    OPEN getBenefactor(benefactor);                                                                 -----> Opening the cursor to get the benefactor 
    FETCH  getBenefactor into receptor,valor;                                                       -----> Index to iterate over the registers   
    WHILE getBenefactor%found LOOP                                                                  -----> While the cursor detects registers do
        ammount := ammount + valor;                                                                 -----> Update the variable ammount 
        OPEN getReceptor(receptor);                                                                 -----> Opening the cursor to get data from receptor and calculate for the derivates registers
        FETCH getReceptor into valor;                                                               -----> Index to iterate over the registers 
        WHILE getReceptor%found LOOP                                                                -----> While the cursor detects registers do
            ammount := ammount + valor;                                                             -----> Update the variable ammount with the values of derivates
            FETCH getReceptor INTO valor;                                                           -----> Index to iterate over the registers (Its like one more iteration) 
        END LOOP;
        CLOSE getReceptor;                                                                          -----> Closing the cursor receptor ( It is the secondary cursor, and it is inside the loop)
        FETCH getBenefactor INTO receptor, valor;                                                   -----> Index to iterate over the registers (Its like one more iteration) 
     END LOOP;
     CLOSE getBenefactor;                                                                           -----> Closing the cursor benefactor
    DBMS_OUTPUT.PUT_LINE(ammount);                                                                  -----> Printing in consolo the value calculated
END;     
        
DROP TABLE mesada;




------ TERCER PUNTO  --------------------------
drop table abecedario;
create table abecedario (
    abcVariable varchar2(1),--VARIABLE FOR TO KNOW WHAT LETTER WILL BE SHOWED
    abcFilaLetra number(1), --VARIABLE FOR TO KNOW WHAT SPECIFY PART OF THE LETTER WILL BE SHOWED
    abcLetra varchar2(20) --- VARIABLE FOR TO SAVE ONE SPECIFY PART OF THE LETTER, FOR EXAMPLE FOR THE LETTER A, THE HEAD WILL BE SOMETHING LIKE THIS AAAAAA, SO THE VARIABLE abcLetra TAKE THE VALUE OF AAAAAA
);

insert into abecedario values ('A', 1, ' AAAAAA  ');
insert into abecedario values ('A', 2, 'AA    AA ');
insert into abecedario values ('A', 3, 'A      A ');
insert into abecedario values ('A', 4, 'A      A ');
insert into abecedario values ('A', 5, 'AAAAAAAA ');
insert into abecedario values ('A', 6, 'A      A ');
insert into abecedario values ('A', 7, 'A      A ');
insert into abecedario values ('A', 8, 'A      A ');
insert into abecedario values ('A', 9, 'A      A ');

insert into abecedario values ('B', 1, 'BBBBBB   ');
insert into abecedario values ('B', 2, 'B    BB  ');
insert into abecedario values ('B', 3, 'B     BB ');
insert into abecedario values ('B', 4, 'B     BB ');
insert into abecedario values ('B', 5, 'BBBBBB   ');
insert into abecedario values ('B', 6, 'B     BB ');
insert into abecedario values ('B', 7, 'B     BB ');
insert into abecedario values ('B', 8, 'B    BB  ');
insert into abecedario values ('B', 9, 'BBBBBB   ');

insert into abecedario values ('C', 1, '  CCCC   ');
insert into abecedario values ('C', 2, ' CC  CC  ');
insert into abecedario values ('C', 3, 'CC    CC ');
insert into abecedario values ('C', 4, 'C        ');
insert into abecedario values ('C', 5, 'C        ');
insert into abecedario values ('C', 6, 'C        ');
insert into abecedario values ('C', 7, 'CC    CC ');
insert into abecedario values ('C', 8, ' CC  CC  ');
insert into abecedario values ('C', 9, '  CCCC   ');

insert into abecedario values ('D', 1, 'DDDDDD   ');
insert into abecedario values ('D', 2, 'D    DD  ');
insert into abecedario values ('D', 3, 'D     DD ');
insert into abecedario values ('D', 4, 'D      D ');
insert into abecedario values ('D', 5, 'D      D ');
insert into abecedario values ('D', 6, 'D      D ');
insert into abecedario values ('D', 7, 'D     DD ');
insert into abecedario values ('D', 8, 'D    DD  ');
insert into abecedario values ('D', 9, 'DDDDDD   ');

insert into abecedario values ('E', 1, 'EEEEEEEE ');
insert into abecedario values ('E', 2, 'E        ');
insert into abecedario values ('E', 3, 'E        ');
insert into abecedario values ('E', 4, 'E        ');
insert into abecedario values ('E', 5, 'EEEEEEE  ');
insert into abecedario values ('E', 6, 'E        ');
insert into abecedario values ('E', 7, 'E        ');
insert into abecedario values ('E', 8, 'E        ');
insert into abecedario values ('E', 9, 'EEEEEEEE ');

insert into abecedario values ('F', 1, 'FFFFFFFF ');
insert into abecedario values ('F', 2, 'F        ');
insert into abecedario values ('F', 3, 'F        ');
insert into abecedario values ('F', 4, 'F        ');
insert into abecedario values ('F', 5, 'FFFFFF   ');
insert into abecedario values ('F', 6, 'F        ');
insert into abecedario values ('F', 7, 'F        ');
insert into abecedario values ('F', 8, 'F        ');
insert into abecedario values ('F', 9, 'F        ');

insert into abecedario values ('G', 1, '  GGGG   ');
insert into abecedario values ('G', 2, ' GG  GG  ');
insert into abecedario values ('G', 3, 'G      G ');
insert into abecedario values ('G', 4, 'G        ');
insert into abecedario values ('G', 5, 'G        ');
insert into abecedario values ('G', 6, 'G   GGGG ');
insert into abecedario values ('G', 7, 'G   G  G ');
insert into abecedario values ('G', 8, ' GG   GG ');
insert into abecedario values ('G', 9, '  GGGGG  ');

insert into abecedario values ('H', 1, 'H      H ');
insert into abecedario values ('H', 2, 'H      H ');
insert into abecedario values ('H', 3, 'H      H ');
insert into abecedario values ('H', 4, 'H      H ');
insert into abecedario values ('H', 5, 'HHHHHHHH ');
insert into abecedario values ('H', 6, 'H      H ');
insert into abecedario values ('H', 7, 'H      H ');
insert into abecedario values ('H', 8, 'H      H ');
insert into abecedario values ('H', 9, 'H      H ');

insert into abecedario values ('I', 1, 'IIIIIIII ');
insert into abecedario values ('I', 2, '   II    ');
insert into abecedario values ('I', 3, '   II    ');
insert into abecedario values ('I', 4, '   II    ');
insert into abecedario values ('I', 5, '   II    ');
insert into abecedario values ('I', 6, '   II    ');
insert into abecedario values ('I', 7, '   II    ');
insert into abecedario values ('I', 8, '   II    ');
insert into abecedario values ('I', 9, 'IIIIIIII ');

insert into abecedario values ('J', 1, 'JJJJJJJJ ');
insert into abecedario values ('J', 2, '     JJ  ');
insert into abecedario values ('J', 3, '     JJ  ');
insert into abecedario values ('J', 4, '     JJ  ');
insert into abecedario values ('J', 5, '     JJ  ');
insert into abecedario values ('J', 6, '     JJ  ');
insert into abecedario values ('J', 7, 'JJ   JJ  ');
insert into abecedario values ('J', 8, ' JJ  JJ  ');
insert into abecedario values ('J', 9, '  JJJJ   ');

insert into abecedario values ('K', 1, 'K     KK ');
insert into abecedario values ('K', 2, 'K    KK  ');
insert into abecedario values ('K', 3, 'K   KK   ');
insert into abecedario values ('K', 4, 'KKKK     ');
insert into abecedario values ('K', 5, 'K  KK    ');
insert into abecedario values ('K', 6, 'K   KK   ');
insert into abecedario values ('K', 7, 'K    KK  ');
insert into abecedario values ('K', 8, 'K     KK ');
insert into abecedario values ('K', 9, 'K      K ');

insert into abecedario values ('L', 1, 'LL       ');
insert into abecedario values ('L', 2, 'LL       ');
insert into abecedario values ('L', 3, 'LL       ');
insert into abecedario values ('L', 4, 'LL       ');
insert into abecedario values ('L', 5, 'LL       ');
insert into abecedario values ('L', 6, 'LL       ');
insert into abecedario values ('L', 7, 'LL       ');
insert into abecedario values ('L', 8, 'LL       ');
insert into abecedario values ('L', 9, 'LLLLLLLL ');

insert into abecedario values ('M', 1, 'M      M ');
insert into abecedario values ('M', 2, 'MM    MM ');
insert into abecedario values ('M', 3, 'M M  M M ');
insert into abecedario values ('M', 4, 'M  MM  M ');
insert into abecedario values ('M', 5, 'M      M ');
insert into abecedario values ('M', 6, 'M      M ');
insert into abecedario values ('M', 7, 'M      M ');
insert into abecedario values ('M', 8, 'M      M ');
insert into abecedario values ('M', 9, 'M      M ');

insert into abecedario values ('N', 1, 'N      N ');
insert into abecedario values ('N', 2, 'NN     N ');
insert into abecedario values ('N', 3, 'N N    N ');
insert into abecedario values ('N', 4, 'N  N   N ');
insert into abecedario values ('N', 5, 'N   N  N ');
insert into abecedario values ('N', 6, 'N    N N ');
insert into abecedario values ('N', 7, 'N     NN ');
insert into abecedario values ('N', 8, 'N      N ');
insert into abecedario values ('N', 9, 'N      N ');

insert into abecedario values ('O', 1, '  OOOO   ');
insert into abecedario values ('O', 2, ' O    O  ');
insert into abecedario values ('O', 3, 'O      O ');
insert into abecedario values ('O', 4, 'O      O ');
insert into abecedario values ('O', 5, 'O      O ');
insert into abecedario values ('O', 6, 'O      O ');
insert into abecedario values ('O', 7, 'O      O ');
insert into abecedario values ('O', 8, ' O    O  ');
insert into abecedario values ('O', 9, '  OOOO   ');

insert into abecedario values ('P', 1, 'PPPPPPP  ');
insert into abecedario values ('P', 2, 'P     PP ');
insert into abecedario values ('P', 3, 'P     PP ');
insert into abecedario values ('P', 4, 'P    PP  ');
insert into abecedario values ('P', 5, 'PPPPPP   ');
insert into abecedario values ('P', 6, 'P        ');
insert into abecedario values ('P', 7, 'P        ');
insert into abecedario values ('P', 8, 'P        ');
insert into abecedario values ('P', 9, 'P        ');

insert into abecedario values ('Q', 1, '  OOOO   ');
insert into abecedario values ('Q', 2, ' OO  OO  ');
insert into abecedario values ('Q', 3, 'OO    OO ');
insert into abecedario values ('Q', 4, 'OO    OO ');
insert into abecedario values ('Q', 5, 'OO    OO ');
insert into abecedario values ('Q', 6, 'OO    OO ');
insert into abecedario values ('Q', 7, 'OO    OO ');
insert into abecedario values ('Q', 8, ' OO  OO  ');
insert into abecedario values ('Q', 9, '  OOO OO ');

insert into abecedario values ('R', 1, 'RRRRRRR  ');
insert into abecedario values ('R', 2, 'R     RR ');
insert into abecedario values ('R', 3, 'R     RR ');
insert into abecedario values ('R', 4, 'R    RR  ');
insert into abecedario values ('R', 5, 'RRRRRR   ');
insert into abecedario values ('R', 6, 'R  RR    ');
insert into abecedario values ('R', 7, 'R   RR   ');
insert into abecedario values ('R', 8, 'R    RR  ');
insert into abecedario values ('R', 9, 'R     RR ');

insert into abecedario values ('S', 1, ' SSSSS   ');
insert into abecedario values ('S', 2, 'SS   SS  ');
insert into abecedario values ('S', 3, 'S     SS ');
insert into abecedario values ('S', 4, 'SS       ');
insert into abecedario values ('S', 5, ' SSSSS   ');
insert into abecedario values ('S', 6, '     SS  ');
insert into abecedario values ('S', 7, 'S     SS ');
insert into abecedario values ('S', 8, 'SS   SS  ');
insert into abecedario values ('S', 9, ' SSSSS   ');

insert into abecedario values ('T', 1, 'TTTTTTTT ');
insert into abecedario values ('T', 2, '   TT    ');
insert into abecedario values ('T', 3, '   TT    ');
insert into abecedario values ('T', 4, '   TT    ');
insert into abecedario values ('T', 5, '   TT    ');
insert into abecedario values ('T', 6, '   TT    ');
insert into abecedario values ('T', 7, '   TT    ');
insert into abecedario values ('T', 8, '   TT    ');
insert into abecedario values ('T', 9, '   TT    ');

insert into abecedario values ('U', 1, 'UU    UU ');
insert into abecedario values ('U', 2, 'UU    UU ');
insert into abecedario values ('U', 3, 'UU    UU ');
insert into abecedario values ('U', 4, 'UU    UU ');
insert into abecedario values ('U', 5, 'UU    UU ');
insert into abecedario values ('U', 6, 'UU    UU ');
insert into abecedario values ('U', 7, 'UU    UU ');
insert into abecedario values ('U', 8, ' UU  UU  ');
insert into abecedario values ('U', 9, '  UUUU   ');

insert into abecedario values ('V', 1, 'VV    VV ');
insert into abecedario values ('V', 2, 'VV    VV ');
insert into abecedario values ('V', 3, 'VV    VV ');
insert into abecedario values ('V', 4, 'VV    VV ');
insert into abecedario values ('V', 5, 'VV    VV ');
insert into abecedario values ('V', 6, 'VV    VV ');
insert into abecedario values ('V', 7, ' VV  VV  ');
insert into abecedario values ('V', 8, ' VV  VV  ');
insert into abecedario values ('V', 9, '   VV    ');

insert into abecedario values ('W', 1, 'W      W ');
insert into abecedario values ('W', 2, 'W      W ');
insert into abecedario values ('W', 3, 'W      W ');
insert into abecedario values ('W', 4, 'W      W ');
insert into abecedario values ('W', 5, 'W      W ');
insert into abecedario values ('W', 6, 'W  WW  W ');
insert into abecedario values ('W', 7, 'W W  W W ');
insert into abecedario values ('W', 8, ' W    W  ');
insert into abecedario values ('W', 9, ' W    W  ');

insert into abecedario values ('X', 1, 'XX    XX ');
insert into abecedario values ('X', 2, 'XX    XX ');
insert into abecedario values ('X', 3, ' XX  XX  ');
insert into abecedario values ('X', 4, '  XXXX   ');
insert into abecedario values ('X', 5, '   XX    ');
insert into abecedario values ('X', 6, '  XXXX   ');
insert into abecedario values ('X', 7, ' XX  XX  ');
insert into abecedario values ('X', 8, 'XX    XX ');
insert into abecedario values ('X', 9, 'XX    XX ');

insert into abecedario values ('Y', 1, 'YY    YY ');
insert into abecedario values ('Y', 2, 'YY    YY ');
insert into abecedario values ('Y', 3, ' YY  YY  ');
insert into abecedario values ('Y', 4, '  YYYY   ');
insert into abecedario values ('Y', 5, '   YY    ');
insert into abecedario values ('Y', 6, '   YY    ');
insert into abecedario values ('Y', 7, '   YY    ');
insert into abecedario values ('Y', 8, '   YY    ');
insert into abecedario values ('Y', 9, '   YY    ');

insert into abecedario values ('Z', 1, 'ZZZZZZZZ ');
insert into abecedario values ('Z', 2, '      ZZ ');
insert into abecedario values ('Z', 3, '     ZZ  ');
insert into abecedario values ('Z', 4, '    ZZ   ');
insert into abecedario values ('Z', 5, '   ZZ    ');
insert into abecedario values ('Z', 6, '  ZZ     ');
insert into abecedario values ('Z', 7, ' ZZ      ');
insert into abecedario values ('Z', 8, 'ZZ       ');
insert into abecedario values ('Z', 9, 'ZZZZZZZZ ');

declare

-- We define the cursor that returns the records that meet the condition with respect to the letter and row that is being processed
cursor lector (abcvari varchar2, fila number) is select abcLetra from abecedario where abcFilaLetra = fila and upper(abcVariable) = upper(abcvari);
-- Variable for to save the big letter
abcRespuesta varchar2(90);
-- Variable for to save the word that is being processed
abcPalabra varchar2(50);
-- Variable for to save the letter of the abec that is being processed
abcLetra varchar2(1);
-- Variable to save the number of the row that is being processed for each letter (1 a 9)
abcNumeroFila number(1);
-- Variable to save what is obtained from each letter in the different rows
abcRespuestaActual varchar2(12);
-- Exception to validate that the size of the word to be processed is not greater than 8
limiteExcedido EXCEPTION;


begin

-- Word to process
abcPalabra := 'Juan';
-- Validation of the word's length 
if length(abcpalabra) > 8 then
raise limiteExcedido;
end if;
-- Initially nothing has been processed so the variable is initialized empty
abcRespuesta := '';
-- Cycle for from 1 until 9 to go through the 9 rows that each letter has
for j in 1..9 loop
    abcNumeroFila :=j;
    -- For cycle that goes from 1 to the size of the word to get the corresponding part of each letter according to the row in which it is (index i)
    for i in 1 .. length(abcPalabra) loop
        abcRespuestaActual :='';
        -- The variable (abcLetra) is assigned the letter that is being processed
        abcLetra := substr(abcPalabra, i, 1);
        -- The cursor is opened with the variables abcLetra and abcNumeroRila that refer to the letter and the row respectively
        open lector(abcLetra,abcNumeroFila);
        -- The result of the query is saved in the variable abcRespuestaActual
        fetch lector into abcRespuestaActual;
        -- A concatenation of what was previously obtained is made, so that the letters are separated
        abcrespuestaactual := concat(abcRespuestaActual, '  ');
        -- AbcRespuestaActual is concatenated with abcRespuesta, so that it is closed saving all the result in said variable (abcRespuesta)
        abcRespuesta:= concat(abcRespuesta, abcRespuestaActual);
        -- The cursor is closed
        close lector;
       
    end loop;-- cycle 1... length word
-- Everything related to row i is printed, that is, everything corresponding to said row for each letter that makes up the word. Example FOR THE WORD YES , WILL BE SOMETHING LIKE THIS: YY   YY  EEEEE  SSSSS
DBMS_OUTPUT.PUT_LINE(abcRespuesta);
-- The abcRespuesta variable is reset because the next row will be processed
abcRespuesta:= '';
end loop;-- cycle 1...9

exception 
-- Exception when the maximum size (8) of the word is exceeded
WHEN limiteExcedido THEN DBMS_OUTPUT.PUT_LINE('Tamaño de palabra excedido');

end;



------ CUARTO PUNTO   ---------------
DECLARE
	-- WE ARE GOING TO DECLARE THE VARIABLES FOR AGE AND BIRTHDAY
        age number(3);
        birthdate VARCHAR2(10);
	-- DECLARING THE VARIABLES OF ACTUAL DATE
        day_actual number(2);
        month_actual number(2);
        year_actual number(4);
	-- DECLARING THE VARIABLES FOR THE BIRTHDATE
        day_born number(2);
        month_born number(2);
        year_born number(4);
	-- DECLARING A CURSOR FOR LATER USE TO GET BIRTHDAY DETAILS (DAY - MONTH - YEAR)
        cursor birth_date (x birthdate%type) is SELECT EXTRACT(DAY from to_date(x,'DD/MM/YYYY')) as DAY,
        EXTRACT(MONTH from to_date(x,'DD/MM/YYYY')) as MONTH,
        EXTRACT(YEAR from to_date(x,'DD/MM/YYYY'))  as YEAR from dual;
        -- DECLARING A CURSOR FOR LATER USE TO GET THE ACTUAL DETAILS (DAY - MONTH - YEAR)
        cursor actual_date is SELECT to_number(TO_CHAR(SYSDATE,'DD')) as DAY,
        to_number(TO_CHAR(SYSDATE,'MM')) as MONTH,
        to_number(TO_CHAR(SYSDATE,'YYYY')) as YEAR from dual;

        
        
    BEGIN
	-- SELECTING RANDOM DATE
        birthdate := '18/11/1999';
    -- FOR TO GET DATA FROM THE BIRTHDATE    
        FOR i in birth_date (birthdate)LOOP
            day_born := i.day;
            month_born := i.month;
            year_born := i.year;
        END LOOP;
    -- FOR TO GET DATA FROM ACTUAL DATE   
        FOR i in actual_date LOOP
            day_actual := i.day;
	        month_actual := i.month;
            year_actual := i.year;
        END LOOP;
     -- AT FIRST WE CALCULATE AGE BY THE DIFFERENCE BETWEEN YEARS   
        age := year_actual - year_born;
     -- BUT IF THE ACTUAL MONTH IS LESS THAN THE BORN MONTH THE AGE IS NOT CORRECT, ACTUALLY IS ONE YEAR LESS BECAUSE ITS NOT YET THE BIRTHDAY   
        IF month_actual < month_born THEN 
            age := age - 1;
     -- BUT IF THE MONTHS ARE EQUALS THEN WE HAVE TO TAKE A LOOK ON THE DAYS FOR THE SAME CALCULATION       
        ELSIF month_actual = month_born THEN
     -- IF THE ACTUAL DAY IS LESS THAN THE BIRTH DAY THEN WE HAVE TO CHANGE AGE FOR ONE YEAR LESS.   
            IF day_actual < day_born THEN 
                age := age - 1;
            END IF;
        END IF;
        dbms_output.put_line(birthdate);
        dbms_output.put_line(age);
    END;



