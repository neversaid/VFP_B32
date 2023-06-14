*====================================================================
* VFP_B32 - FoxPro Base32 En- and Decoder
*====================================================================
* Author.....: Bernhard Reiter - crossVault GmbH
* Version....: 1.0 - 06/14/23 - Initial Version
*
* About......: A En- and Decoder for Base32
* Parameters.:
*====================================================================

DEFINE CLASS VFP_B32 AS CUSTOM

	PROCEDURE INIT	
	ENDPROC
	
	PROCEDURE Encode (PlainString as String) As String 
		LOCAL lcCharTable as String
		m.lcCharTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
	
	
		LOCAL lcEncodedString AS String 
		LOCAL lnShiftIndex as Integer
		LOCAL lnDigit as Integer
		LOCAL lnIdx as Integer
		LOCAL lnPlainStringLength as Integer
		LOCAL lcChar as String 
		LOCAL lnEncodedPos as Integer
		LOCAL lnEncodedStringLen as Integer
		
		m.lnShiftIndex = 0
		m.lnDigit = 0
		m.lnIdx = 1
		m.lnEncodedPos = 1
		
		IF VARTYPE(m.PlainString) <> "C" THEN
			RETURN ""
		ENDIF
		
		m.lnPlainStringLength = LEN(m.PlainString)
		
		IF m.lnPlainStringLength = 0 THEN
			RETURN ""
		ENDIF
		
		m.lnEncodedStringLen = this.QuintetCount(m.PlainString) * 8
		m.lcEncodedString = REPLICATE(CHR(0x3D),m.lnEncodedStringLen)
		
		DO WHILE lnIdx <= m.lnPlainStringLength
			m.lnCharCode = ASC(SUBSTR(m.PlainString, lnIdx,1))
			
			IF m.lnShiftIndex > 3 THEN
				m.lnDigit = BITAND(lnCharCode, BITRSHIFT(0xFF, m.lnShiftIndex))
				m.lnShiftIndex = MOD((m.lnShiftIndex + 5),8)
				m.lnDigit = BITOR( BITLSHIFT(m.lnDigit, m.lnShiftIndex),;
									BITRSHIFT(;
										IIF(lnIdx  < lnPlainStringLength, ASC(SUBSTR(m.PlainString, lnIdx + 1 ,1)), 0),;
										(8 - m.lnShiftIndex) ;
										) ;
								)
				m.lnIdx = m.lnIdx + 1												
			ELSE
				m.lnDigit =  BITAND(BITRSHIFT(m.lnCharCode, (8 - (m.lnShiftIndex + 5))), 0x1F)
				m.lnShiftIndex = MOD((m.lnShiftIndex + 5),8)
				
				IF m.lnShiftIndex = 0 THEN
					m.lnIdx = m.lnIdx + 1
				ENDIF
			ENDIF
			
			m.lcEncodedString = STUFF(m.lcEncodedString, lnEncodedPos, 1, SUBSTR(lcCharTable, lnDigit +1 ,1) )
			m.lnEncodedPos = m.lnEncodedPos + 1
		ENDDO
		m.lcEncodedString =  STUFF(m.lcEncodedString,lnEncodedPos, lnEncodedStringLen - lnEncodedPos +1, "=")
		RETURN m.lcEncodedString 
	ENDPROC

	PROCEDURE Decode (Base32String as String) As String
		LOCAL lcByteTable 
		LOCAL ARRAY laByteTable (80)
		
		TEXT TO m.lcByteTable NOSHOW FLAGS 0 PRETEXT 15
			0xff, 0xff, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
			0xff, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
			0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
			0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
			0x17, 0x18, 0x19, 0xff, 0xff, 0xff, 0xff, 0xff,
			0xff, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
			0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
			0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
			0x17, 0x18, 0x19, 0xff, 0xff, 0xff, 0xff, 0xff
		ENDTEXT
				
		ALINES(laByteTable, m.lcByteTable,1+4,",")
		LOCAL lnByteTableLen as Integer
		lnByteTableLen = ALEN(laByteTable)
	
	
		LOCAL lnShiftIndex as Integer
		LOCAL lnPlainDigit as Integer
		LOCAL lnPlainChar as Integer
		LOCAL lnPlainPos as Integer
		LOCAL lcDecodedString as String 
		LOCAL lnCharCode as Integer
		LOCAL lnDecodedStringLen as Integer
		LOCAL lnIdx as Integer
		
		m.lnShiftIndex  = 0
		m.lnPlainDigit = 0
		m.lnPlainPos = 0
		m.lnPlainChar = 0
		
		IF VARTYPE(m.Base32String) <> "C" OR EMPTY(m.Base32String) THEN
			RETURN ""
		ENDIF
		
		m.Base32String = ALLTRIM(m.Base32String)
		
		m.lnEncodedStringLen = LEN(m.Base32String)
		m.lnDecodedStringLen = CEILING(m.lnEncodedStringLen * 5 / 8)
		m.lcDecodedString = REPLICATE(" ", m.lnDecodedStringLen )
		
		
		FOR lnIdx = 1 TO m.lnEncodedStringLen
			lnCharCode = ASC(SUBSTR(m.Base32String ,lnIdx,1))
			
			IF lnCharCode == 0x3D THEN
				EXIT FOR 				
			ENDIF
			m.lnCharCode = lnCharCode  - 0x30
			
			IF m.lnCharCode > lnByteTableLen THEN
				RETURN ""
			ENDIF
			
			m.lnPlainDigit = VAL(laByteTable(lnCharcode + 1))
	
			
			IF m.lnShiftIndex > 3 THEN
				m.lnShiftIndex = MOD( m.lnShiftIndex + 5, 8)
				m.lnPlainChar = BITOR(m.lnPlainChar, BITAND(0xFF, BITRSHIFT(m.lnPlainDigit, m.lnShiftIndex)))
				
				m.lcDecodedString = STUFF(m.lcDecodedString, m.lnPlainPos+1, 1, CHR(m.lnPlainChar) )

				m.lnPlainPos = m.lnPlainPos + 1
				m.lnPlainChar = BITAND(0xFF, BITLSHIFT(m.lnPlainDigit, 8 - m.lnShiftIndex))
			ELSE
				m.lnShiftIndex = MOD( m.lnShiftIndex + 5, 8)
				IF m.lnShiftIndex = 0 THEN
					m.lnPlainChar = BITOR(m.lnPlainChar, m.lnPlainDigit)
					m.lcDecodedString = STUFF(m.lcDecodedString, m.lnPlainPos+1, 1, CHR(m.lnPlainChar) )
					
					m.lnPlainPos =  m.lnPlainPos + 1
					m.lnPlainChar = 0
				ELSE
					m.lnPlainChar = BITOR(m.lnPlainChar, BITAND(0xFF, BITLSHIFT(m.lnPlainDigit,  8 - m.lnShiftIndex)))
				ENDIF
			ENDIF
	
		ENDFOR
		

		RETURN SUBSTR(m.lcDecodedString, 1, m.lnPlainPos+1)
	ENDPROC


	PROTECTED PROCEDURE QuintetCount ( TestString as String) as Integer
		
		LOCAL lnStringLen, lnQuints
		m.lnStringLen = LEN(m.TestString)
		m.lnQuints = FLOOR(m.lnStringLen / 5)
		
		RETURN IIF(MOD(lnStringLen,5) = 0, m.lnQuints, m.lnQuints + 1)	
	ENDPROC
	
	
ENDDEFINE