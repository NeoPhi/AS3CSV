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

    /**
     * Parser for CSV files.
     */
    public interface ICSVParser
    {
        /**
         * Has the input been fully parsed.
         * @return True if the input has been fully parsed
         */
        function get complete():Boolean;

        /**
         * The total number of data bytes read.
         * @return Number of bytes read
         */
        function get processedBytes():Number;

        /**
         * The total length of the data being processed, if known.
         * @return Total number of possible bytes
         * @default NaN
         */
        function get totalBytes():Number;

        /**
         * Read and return the next record from the CSV.
         * @return Next record
         * @throws IOError For unexpected end of data
         * @throws ArgumentError For unexpected input
         */
        function nextRecord():Vector.<String>;
    }
}