CREATE OR REPLACE FUNCTION foneticalize(v_word IN VARCHAR2)
    RETURN VARCHAR AS
    i INTEGER;
    foneticalized VARCHAR2(255);
    letter CHAR;
    specials VARCHAR2(38);
    non_specials VARCHAR2(38);
    word VARCHAR2(255);
BEGIN
    -- Converting letter to uppercase
    word := UPPER(v_word);

    i := 1;
    foneticalized := '';
    letter := '';
    specials := 'ÁÀÃÂÉÈÊÍÌÎÓÒÔÕÚÙÛÜÇ';
    non_specials := 'AAAAEEEIIIOOOOUUUUS';

    -- Removing especial chars
    WHILE i < LENGTH(specials) LOOP
      word := REPLACE(word, SUBSTR(specials, i, 1), SUBSTR(non_specials, i, 1));
		
      i := i + 1;
    END LOOP;

    -- Replace chars
    word := REPLACE(word, 'Y',   'I');
    
    word := REPLACE(word, 'BL',  'B');
    word := REPLACE(word, 'BR',  'B');
    
    word := REPLACE(word, 'PH',  'F');
    
    word := REPLACE(word, 'GL',  'G');
    word := REPLACE(word, 'GR',  'G');
    word := REPLACE(word, 'MG',  'G');
    word := REPLACE(word, 'NG',  'G');
    word := REPLACE(word, 'RG',  'G');
	
    word := REPLACE(word, 'GE',  'J');
    word := REPLACE(word, 'GI',  'J');
    word := REPLACE(word, 'RJ',  'J');
    word := REPLACE(word, 'MJ',  'J');
    word := REPLACE(word, 'NJ',  'J');
	
    word := REPLACE(word, 'Q',   'K');
    word := REPLACE(word, 'C',  'K');
    word := REPLACE(word, 'CA',  'K');
    word := REPLACE(word, 'CO',  'K');
    word := REPLACE(word, 'CU',  'K');
    
    word := REPLACE(word, 'LH',  'L');
	
    word := REPLACE(word, 'N',   'M');
    word := REPLACE(word, 'RM',   'M');
    word := REPLACE(word, 'GM',  'M');
    word := REPLACE(word, 'MD',  'M');
    word := REPLACE(word, 'SM',  'M');
 
    word := REPLACE(word, 'NH',  'N');
    
    word := REPLACE(word, 'PR',  'P');
    
    word := REPLACE(word, 'Ç',  'S');
    word := REPLACE(word, 'X',  'S');
    word := REPLACE(word, 'TS',  'S');
    word := REPLACE(word, 'C',  'S');
    word := REPLACE(word, 'Z',  'S');
    word := REPLACE(word, 'RS',  'S');
    
    word := REPLACE(word, 'LT',  'T');
    word := REPLACE(word, 'TR',  'T');
    word := REPLACE(word, 'CT',  'T');
    word := REPLACE(word, 'RT',  'T');
    word := REPLACE(word, 'ST',  'T');
    
    word := REPLACE(word, 'W',  'V');

    -- Remove ending chars
    i := LENGTH(word) - 1;
    
    letter := SUBSTR(word, i, 1);
    
    IF (letter = 'S' OR letter = 'Z' OR letter = 'R' OR letter = 'M' OR letter = 'N' OR letter = 'L') THEN
      word := substr(word, 0, i);
    ELSIF substr(word, (i - 1), 2) = 'AO' THEN
      word := substr(word, 0, (i - 1));
    END IF;
    
    word := REPLACE(word, 'R',  'L');
    
    word := REPLACE(word, 'A',  '');
    word := REPLACE(word, 'E',  '');
    word := REPLACE(word, 'I',  '');
    word := REPLACE(word, 'O',  '');
    word := REPLACE(word, 'U',  '');
    word := REPLACE(word, 'H',  '');
    
    -- Removing repeated letters
    i := 1;
	
    WHILE i < LENGTH(word) LOOP
      letter := SUBSTR(word, i, 1);

      IF letter = ' ' THEN
        foneticalized := foneticalized || ' ';
      ELSIF i > 1 AND letter <> SUBSTR(word, i - 1, 1) THEN
        foneticalized := foneticalized || letter;
      ELSIF i = 1 THEN
        foneticalized := foneticalized || letter;
      END IF;

      i := i + 1;
    END LOOP;

    RETURN foneticalized;
    
    EXCEPTION
      WHEN OTHERS THEN
        RETURN '';
END;