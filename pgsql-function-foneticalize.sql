CREATE OR REPLACE FUNCTION foneticalize(word VARCHAR(255))
  RETURNS VARCHAR(255) AS $$
  DECLARE 
    i             int          default 1;
    foneticalized varchar(255) default '';
    letter        char(1)      default '';
    specials      varchar(76) default 'ÁÀÃÂÉÈÊÍÌÎÓÒÔÕÚÙÛÜÇáàãâéèêíìîóòôõúùûüç';
    non_specials  varchar(38) default 'AAAAEEEIIIOOOOUUUUSAAAAEEEIIIOOOOUUUUS';
  BEGIN
    -- removing especial chars
    word := translate(word, specials, non_specials);

    -- uppering word
    word := upper(word);
    
    -- replace chars
    word := regexp_replace(word, e'BL|BR', 'B', 'g');
    word := replace(word, 'PH', 'F');
    word := regexp_replace(word, e'GL|GR|MG|NG|RG', 'G', 'g');
    word := replace(word, 'Y', 'I');
    word := regexp_replace(word, e'GE|GI|RJ|MJ', 'J', 'g');
    word := regexp_replace(word, e'CA|CO|CU|CK|Q', 'K', 'g');
    word := replace(word, 'N', 'M');
    word := regexp_replace(word, e'AO|AUM|GM|MD|OM|ON', 'M', 'g');
    word := replace(word, 'PR', 'P');
    word := replace(word, 'L', 'R');
    word := regexp_replace(word, e'CE|CI|CH|CS|RS|TS|X|Z', 'S', 'g');
    word := regexp_replace(word, e'TR|TL', 'T', 'g');
    word := regexp_replace(word, e'CT|RT|ST|PT', 'T', 'g');
    word := regexp_replace(word, e'\\y[UW]', 'V', 'g');
    word := replace(word, 'RM', 'SM');
    word := regexp_replace(word, e'[MRS]\\y', '', 'g');
    word := regexp_replace(word, e'[AEIOU]', '', 'g');

    -- removing repeated letters
    i := 1;
    while i <= length(word) loop
      letter := substring(word, i, 1);

      if letter = ' ' then
        foneticalized := concat(foneticalized, ' ');
      elseif i > 1 and letter <> substring(word, i-1, 1) then
        foneticalized := concat(foneticalized, letter);
      elseif i = 1 then
        foneticalized := concat(foneticalized, letter);
      end if;

      i := i + 1;
    end loop;

    RETURN foneticalized;
  END;
$$ LANGUAGE plpgsql;

