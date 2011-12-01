DROP FUNCTION IF EXISTS foneticalize;

DELIMITER //

CREATE FUNCTION foneticalize(word VARCHAR(255) charset utf8)
  RETURNS VARCHAR(255)
  DETERMINISTIC
  BEGIN
    DECLARE i             int          default 1;
    DECLARE foneticalized varchar(255) default '';
    DECLARE letter        char(1)      default '';
    DECLARE specials      varchar(76) default 'ÁÀÃÂÉÈÊÍÌÎÓÒÔÕÚÙÛÜÇáàãâéèêíìîóòôõúùûüç';
    DECLARE non_specials  varchar(38) default 'AAAAEEEIIIOOOOUUUUSAAAAEEEIIIOOOOUUUUS';
    
    -- removing especial chars
    set i = 1;
    while i <= length(specials) do
      set word = replace(word, substring(specials, i, 2), substring(non_specials, i / 2, 1));
      
      set i = i + 2;
    end while;

    -- uppering word
    set word = upper(word);

    -- replace chars
    set word = replace(word, 'BL',  'B');
    set word = replace(word, 'BR',  'B');
    set word = replace(word, 'PH',  'F');
    set word = replace(word, 'GL',  'G');
    set word = replace(word, 'GR',  'G');
    set word = replace(word, 'MG',  'G');
    set word = replace(word, 'NG',  'G');
    set word = replace(word, 'RG',  'G');

    set word = replace(word, 'Y',   'I');

    set word = replace(word, 'GE',  'J');
    set word = replace(word, 'GI',  'J');
    set word = replace(word, 'RJ',  'J');
    set word = replace(word, 'MJ',  'J');

    set word = replace(word, 'CA',  'K');
    set word = replace(word, 'CO',  'K');
    set word = replace(word, 'CU',  'K');
    set word = replace(word, 'CK',  'K');
    set word = replace(word, 'Q',   'K');

    set word = replace(word, 'N',   'M');

    set word = replace(word, 'AO',  'M');
    set word = replace(word, 'AUM', 'M');
    set word = replace(word, 'GM',  'M');
    set word = replace(word, 'MD',  'M');
    set word = replace(word, 'OM',  'M');
    set word = replace(word, 'ON',  'M');

    set word = replace(word, 'PR',  'P');

    set word = replace(word, 'L',   'R');

    set word = replace(word, 'CE',  'S');
    set word = replace(word, 'CI',  'S');
    set word = replace(word, 'CH',  'S');
    set word = replace(word, 'CS',  'S');
    set word = replace(word, 'RS',  'S');
    set word = replace(word, 'TS',  'S');
    set word = replace(word, 'X',   'S');
    set word = replace(word, 'Z',   'S');

    set word = replace(word, 'TR',  'T');
    set word = replace(word, 'TL',  'T');

    set word = replace(word, 'CT',  'T');
    set word = replace(word, 'RT',  'T');
    set word = replace(word, 'ST',  'T');
    set word = replace(word, 'PT',  'T');
    set word = replace(word, 'RM', 'SM');
    set word = replace(word, 'A',    '');
    set word = replace(word, 'E',    '');
    set word = replace(word, 'I',    '');
    set word = replace(word, 'O',    '');
    set word = replace(word, 'U',    '');
    set word = replace(word, 'H',    '');

    -- replacing chars with regular expression: "\b[UW]" e "[MRS]\b"
    set i = 1;
    while i <= length(word) do
      set letter = substring(word, i, 1);

      if letter = ' ' then
        set foneticalized = concat(foneticalized, ' ');
      elseif (i = 1 or substring(word, i-1, 1) = " ") and (letter = 'W' or letter = 'U') then
        set foneticalized = concat(foneticalized, 'V');
      elseif (i = length(word) or substring(word, i+1, 1) = " ") and (letter = 'M' or letter = 'R' or letter = 'S') then
        set foneticalized = concat(foneticalized, '');
      else
        set foneticalized = concat(foneticalized, letter);
      end if;

      set i = i + 1;
    end while;

    -- removing repeated letters
    set i = 1;
    set word = foneticalized;
    set foneticalized = '';
    while i <= length(word) do
      set letter = substring(word, i, 1);

      if letter = ' ' then
        set foneticalized = concat(foneticalized, ' ');
      elseif i > 1 and letter <> substring(word, i-1, 1) then
        set foneticalized = concat(foneticalized, letter);
      elseif i = 1 then
        set foneticalized = concat(foneticalized, letter);
      end if;

      set i = i + 1;
    end while;

    RETURN foneticalized;
  END
//

DELIMITER ;
