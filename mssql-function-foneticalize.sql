--DROP function dbo.foneticalize
CREATE function dbo.foneticalize(@word varchar(255))
    returns varchar(255) as
BEGIN
-- ORIGINAL: https://github.com/vyper/fonetica-sql/blob/master/mssql-function-foneticalize.sql
-- AJUSTES FEITOS BASEADOS EM: https://github.com/sobrinho/fonetica/blob/master/lib/fonetica.rb
    DECLARE @i             int
    DECLARE @foneticalized varchar(255)
    DECLARE @letter        char(1)
   
    set @i = 1
    set @foneticalized = ''
    set @letter = ''

    -- uppering word
    set @word = upper(@word)
	set @word = replace(@word, 'Ç',  'S')

    -- removing especial chars
    select  @word = @word COLLATE SQL_Latin1_General_Cp1251_CS_AS

    -- replace chars
    set @word = replace(@word, 'BL',  'B')
    set @word = replace(@word, 'BR',  'B')

    set @word = replace(@word, 'PH',  'F')
    
	SET @word = replace(@word, 'GL',  'G')
    set @word = replace(@word, 'GR',  'G')
    set @word = replace(@word, 'MG',  'G')
    set @word = replace(@word, 'NG',  'G')
    set @word = replace(@word, 'RG',  'G')

    set @word = replace(@word, 'Y',   'I')

    set @word = replace(@word, 'GE',  'J')
    set @word = replace(@word, 'GI',  'J')
    set @word = replace(@word, 'RJ',  'J')
    set @word = replace(@word, 'MJ',  'J')

    set @word = replace(@word, 'CA',  'K')
    set @word = replace(@word, 'CO',  'K')
    set @word = replace(@word, 'CU',  'K')
    set @word = replace(@word, 'CK',  'K')
    set @word = replace(@word, 'Q',   'K')

    set @word = replace(@word, 'N',   'M')

    set @word = replace(@word, 'AO',  'M')
    set @word = replace(@word, 'AUM', 'M')
    set @word = replace(@word, 'GM',  'M')
    set @word = replace(@word, 'MD',  'M')
    set @word = replace(@word, 'OM',  'M')
    set @word = replace(@word, 'ON',  'M')

    set @word = replace(@word, 'PR',  'P')

    set @word = replace(@word, 'L',   'R')

    set @word = replace(@word, 'CE',  'S')
    set @word = replace(@word, 'CI',  'S')
    set @word = replace(@word, 'CH',  'S')
    set @word = replace(@word, 'CS',  'S')
    set @word = replace(@word, 'RS',  'S')
    set @word = replace(@word, 'TS',  'S')
    set @word = replace(@word, 'X',   'S')
    set @word = replace(@word, 'Z',   'S')

    set @word = replace(@word, 'TR',  'T')
    set @word = replace(@word, 'TL',  'T')
	

    set @word = replace(@word, 'CT',  'T')
    set @word = replace(@word, 'RT',  'T')
    set @word = replace(@word, 'ST',  'T')
    set @word = replace(@word, 'PT',  'T')
    set @word = replace(@word, 'RM', 'SM')

    -- replacing chars with regular expression: "\b[UW]" e "[MRS]\b"
    set @i = 1
    while @i <= len(@word)
    begin
      set @letter = substring(@word, @i, 1)
	
      if @letter = ' '
        set @foneticalized = @foneticalized + ' '
      else if (@i = 1 or substring(@word, @i-1, 1) = ' ') and (@letter = 'W' or @letter = 'U')
        set @foneticalized = @foneticalized + 'V'
      else if (@i = len(@word) or substring(@word, @i+1, 1) = ' ') and (@letter = 'M' or @letter = 'R' or @letter = 'S')
        set @foneticalized = @foneticalized + ''
      else
        set @foneticalized = @foneticalized + @letter

      set @i = @i + 1
    end

	set @word = @foneticalized;
	
	set @word = replace(@word, 'A',    '')
    set @word = replace(@word, 'E',    '')
    set @word = replace(@word, 'I',    '')
    set @word = replace(@word, 'O',    '')
    set @word = replace(@word, 'U',    '')
    set @word = replace(@word, 'H',    '')


    -- removing repeated letters
    set @i = 1;
    
    set @foneticalized = '';
    while @i <= len(@word)
    begin
      set @letter = substring(@word, @i, 1)

      if @letter = ' '
        set @foneticalized = @foneticalized + ' '
      else if @i > 1 and @letter <> substring(@word, @i-1, 1)
        set @foneticalized = @foneticalized + @letter
      else if @i = 1
        set @foneticalized = @foneticalized + @letter

      set @i = @i + 1
    end

    return @foneticalized
END
GO
-- TESTS
--SELECT dbo.foneticalize('ÇABIá Sábiá')
--SELECT dbo.foneticalize('broco bloco')
--SELECT dbo.foneticalize('casa kasa')
--SELECT dbo.foneticalize('sela cela')
--SELECT dbo.foneticalize('circo sirco')
--SELECT dbo.foneticalize('coroar koroar')
--SELECT dbo.foneticalize('cuba kuba')
--SELECT dbo.foneticalize('roça rosa')
--SELECT dbo.foneticalize('ameixa ameicha')
--SELECT dbo.foneticalize('toracs torax')
--SELECT dbo.foneticalize('compactar compatar')
--SELECT dbo.foneticalize('fleuma fleugma')
--SELECT dbo.foneticalize('hieroglifo hierogrifo')
--SELECT dbo.foneticalize('negro nego')
--SELECT dbo.foneticalize('luminar ruminar')
--SELECT dbo.foneticalize('mudez nudez')
--SELECT dbo.foneticalize('comendo comeno')
--SELECT dbo.foneticalize('bunginganga bugiganga')
--SELECT dbo.foneticalize('philipe felipe')
--SELECT dbo.foneticalize('estupro estrupo')
--SELECT dbo.foneticalize('queijo keijo')
--SELECT dbo.foneticalize('lagarto largarto')
--SELECT dbo.foneticalize('perspectiva pespectiva')
--SELECT dbo.foneticalize('lagartixa largatixa')
--SELECT dbo.foneticalize('mesmo mermo')
--SELECT dbo.foneticalize('virgem virge')
--SELECT dbo.foneticalize('supersticao superticao')
--SELECT dbo.foneticalize('estupro estrupo')
--SELECT dbo.foneticalize('contrato contlato')
--SELECT dbo.foneticalize('kubitscheck kubixeque')
--SELECT dbo.foneticalize('walter valter')
--SELECT dbo.foneticalize('exceder esceder')
--SELECT dbo.foneticalize('yara iara')
--SELECT dbo.foneticalize('casa caza')
--SELECT dbo.foneticalize('wilson uilson')
--SELECT dbo.foneticalize('óptico ótico')
--SELECT dbo.foneticalize('órgãozinho órgaozinho')
--SELECT dbo.foneticalize('batista baptista')
--SELECT dbo.foneticalize('alison allisonn')
