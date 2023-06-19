# VFP_B32

## Description
VFP_B32 is a RFC 3548 Base32 String Decoder and Encoder for Visual FoxPro encapsulated in a simple to use class.
The code was adapted from the Javascript implementation of [Thirty-Two] (https://github.com/chrisumbel/thirty-two) by Chris Umbel.



### Some examples / How to use
```xBase
  loBase32 = NewObject("VFP_B32", "vfp_b32.prg")
  ** Encode a String in BASE32
  lcEncodedString = loBase32.Encode("Hello world!")
  ? lcEncodedString
  ** Decode the Base32 string
  lcDecodedString = loBase32.Decode("JBSWY3DPEB3W64TMMQQQ=")
  ? lcDecodedString
```

### About this Program
This program has was written for Visual FoxPro 9. As some VFP specific functions are used (like ALINES) it might not run in older Foxpro Versions. 

#### Function **Encode**  

Parameters: Takes a string as parameter which needs to be encoded into Base32
Return: a Base32 encoded String

Usage:  
```xBase
  loBase32 = NewObject("VFP_B32", "vfp_b32.prg")
  ** Encode a String in BASE32
  ? loBase32.Encode("Hello world!")
```
#### Function **Decode**  

Parameters: Takes a string as parameter (the Base32 encoded one)
Return: Decoded Base32 string - If any errors occured or the string is not a valid Base32 String, an empty string is returned!

Usage:  
```xBase
  loBase32 = NewObject("VFP_B32", "vfp_b32.prg")
  ** Decode the Base32 string
  ? loBase32.Decode("JBSWY3DPEB3W64TMMQQQ=")
```

## If you like this...  
..i would be happy, if you give this repository a star if it was helping you! Thanks. If you have time and love older FoxPro versions, feel free to make a Commit and PR to adapt this code to maybe FoxPro Version before 9 and 8.


## License
The MIT License (MIT)

Copyright © 2015 Adam Pritchard

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
© 2021 GitHub, Inc.

