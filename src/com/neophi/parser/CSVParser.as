/*
 * Copyright (c) 2010 Daniel Rinehart <danielr@neophi.com> [http://danielr.neophi.com/]
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.neophi.parser
{
    import flash.errors.IOError;

    /**
     * This class is designed to parse files that conform to RFC 4180 with the exception that no distinction is made between
     * a header and a record. If the first line of the input should be treated as a header, the calling application should
     * make that distinction.
     *
     * By default the end of line (EOL) sequence is defined per the specification as CR LF but maybe changed to another
     * common format such as just CR through the use of the <code>eol</code> property. Using an EOL sequence
     * composed of characters other than CR and/or LF is not supported.
     *
     * Given a record consisting of test,,test a null will be returned for the middle field.
     * Given a record consisting of test,"",test an empty string will be returned for the middle field.
     *
     * The following file format definition is from http://tools.ietf.org/html/rfc4180
     *
     * The ABNF grammar appears as follows:
     * file = [header CRLF] record *(CRLF record) [CRLF]
     * header = name *(COMMA name)
     * record = field *(COMMA field)
     * name = field
     * field = (escaped / non-escaped)
     * escaped = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE
     * non-escaped = *TEXTDATA
     * COMMA = %x2C
     * CR = %x0D ;as per section 6.1 of RFC 2234
     * DQUOTE = %x22 ;as per section 6.1 of RFC 2234
     * LF = %x0A ;as per section 6.1 of RFC 2234
     * CRLF = CR LF ;as per section 6.1 of RFC 2234
     * TEXTDATA =  %x20-21 / %x23-2B / %x2D-7E
     */
    public class CSVParser implements ICSVParser
    {
        /**
         * COMMA = %x2C
         */
        public static const COMMA:Number = 44;

        /**
         * CR = %x0D ; as per section 6.1 of RFC 2234
         */
        public static const CR:Number = 13;

        /**
         * DQUOTE = %x22 ; as per section 6.1 of RFC 2234
         */
        public static const DQUOTE:Number = 34;

        /**
         * LF = %x0A ; as per section 6.1 of RFC 2234
         */
        public static const LF:Number = 10;

        private var _eol:Vector.<Number> = Vector.<Number>([CR, LF]);

        private var _input:String;

        private var _record:Vector.<String>;

        private var _complete:Boolean;

        private var _hitEOL:Boolean;

        private var _inputPosition:Number = 0;

        private var _currentCharCode:Number;

        private var _currentChar:String;

        private var _field:Vector.<String>;

        /**
         * Create a new CSVParser instance.
         * @param input Data source to read from
         */
        public function CSVParser(input:String)
        {
            _input = input;
        }

        /**
         * @inheritDoc
         */
        public function get complete():Boolean
        {
            return _complete;
        }

        /**
         * @inheritDoc
         */
        public function get processedBytes():Number
        {
            return _inputPosition;
        }

        /**
         * @inheritDoc
         */
        public function get totalBytes():Number
        {
            return _input.length;
        }

        /**
         * Change the end of line sequence. Only sequences composed of CR and/or LF are supported.
         * @param eol New end of line sequence
         * @default [CR, LF];
         */
        public function set eol(eol:Vector.<Number>):void
        {
            if ((eol == null) || (eol.length == 0))
            {
                throw new ArgumentError("Invalid EOL.");
            }
            _eol = eol;
        }

        /**
         * @inheritDoc
         */
        public function nextRecord():Vector.<String>
        {
            _record = new Vector.<String>();
            readNextRecord();
            return _record;
        }

        private function readNextByte(eofIsError:Boolean):void
        {
            if ((_input == null) || (_inputPosition == _input.length))
            {
                _complete = true;

                if (eofIsError)
                {
                    throw new IOError("Unexpected end of file.");
                }
            }
            else
            {
                _currentChar = _input.charAt(_inputPosition);
                _currentCharCode = _input.charCodeAt(_inputPosition);
                _inputPosition++;
            }
        }

        private function readNextRecord():void
        {
            var includeNullRecord:Boolean = false;

            while (true)
            {
                readNextByte(false);
                _hitEOL = false;

                if (_complete)
                {
                    if (includeNullRecord)
                    {
                        _record.push(null);
                    }
                    return;
                }
                else if (isEOL())
                {
                    ensureEOL();

                    if (includeNullRecord)
                    {
                        _record.push(null);
                    }
                    return;
                }
                else if (isComma())
                {
                    _record.push(null);
                    includeNullRecord = true;
                }
                else if (isDQuote())
                {
                    _record.push(readEscaped());
                    includeNullRecord = false;

                    if (_hitEOL)
                    {
                        return;
                    }
                }
                else if (isText())
                {
                    _record.push(readNonEscaped());
                    includeNullRecord = false;

                    if (_hitEOL)
                    {
                        return;
                    }
                }
                else
                {
                    throw new ArgumentError(_currentCharCode + " is not valid in readNextRecord context.");
                }
            }
        }

        private function readNonEscaped():String
        {
            var _fieldStartPosition:Number = _inputPosition - 1;

            while (true)
            {
                readNextByte(false);

                if (_complete)
                {
                    return _input.substring(_fieldStartPosition, _inputPosition);
                }
                else if (isEOL())
                {
                    ensureEOL();
                    _hitEOL = true;
                    return _input.substring(_fieldStartPosition, _inputPosition - _eol.length);
                }
                else if (isComma())
                {
                    return _input.substring(_fieldStartPosition, _inputPosition - 1);
                }
                else if (isText())
                {
                    // no-op
                }
                else
                {
                    throw new ArgumentError(_currentCharCode + " is not valid in readNonEscaped context.");
                }
            }
            return null;
        }

        private function readEscaped():String
        {
            _field = new Vector.<String>();

            while (true)
            {
                readNextByte(true);

                if (isDQuote())
                {
                    if (checkEscapedEnd())
                    {
                        return _field.join("");
                    }
                }
                else if (isEscapedText())
                {
                    _field.push(_currentChar);
                }
                else
                {
                    throw new ArgumentError(_currentCharCode + " is not valid in readEscaped context.");
                }
            }
            return null;
        }

        private function checkEscapedEnd():Boolean
        {
            readNextByte(false);

            if (_complete)
            {
                return true;
            }
            else if (isEOL())
            {
                ensureEOL();
                _hitEOL = true;
                return true;
            }
            else if (isComma())
            {
                return true;
            }
            else if (isDQuote())
            {
                _field.push('"');
                return false;
            }
            throw new ArgumentError(_currentCharCode + " is not valid in checkEscapedEnd context.");
        }

        private function ensureEOL():void
        {
            for (var i:int = 1; i < _eol.length; i++)
            {
                readNextByte(true);

                if (_currentCharCode != _eol[i])
                {
                    throw new ArgumentError(_currentCharCode + " is not valid in ensureEOL context.");
                }
            }
        }

        private function isComma():Boolean
        {
            return _currentCharCode == COMMA;
        }

        private function isEOL():Boolean
        {
            return _currentCharCode == _eol[0];
        }

        private function isDQuote():Boolean
        {
            return _currentCharCode == DQUOTE;
        }

        private function isText():Boolean
        {
            return (((_currentCharCode >= 45) && (_currentCharCode <= 126)) || ((_currentCharCode >= 35) && (_currentCharCode <= 43)) ||
                    (_currentCharCode == 32) || (_currentCharCode == 33));
        }

        private function isEscapedText():Boolean
        {
            return (((_currentCharCode >= 32) && (_currentCharCode <= 126)) || (_currentCharCode == LF) || (_currentCharCode == CR));
        }
    }
}