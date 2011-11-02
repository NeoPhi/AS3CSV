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
    import flash.utils.ByteArray;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertTrue;

    public class CSVParserTest
    {

        [Test]
        public function testNextRecord_NoData_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser(null, false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(0, result.length);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_ReadAfterEOF_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser(null, false);
            var result:Vector.<String> = csvParser.nextRecord();
            result = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(0, result.length);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_OneTextField_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("test", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(1, result.length);
            assertEquals("test", result[0]);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_OneEmptyTextField_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("\"\"", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(1, result.length);
            assertEquals("", result[0]);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_OneEscapedTextField_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("\"test\"", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(1, result.length);
            assertEquals("test", result[0]);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_OneComma_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser(",", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(2, result.length);
            assertEquals(null, result[0]);
            assertEquals(null, result[1]);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_TwoFieldsOneComma_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("test,test2", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(2, result.length);
            assertEquals("test", result[0]);
            assertEquals("test2", result[1]);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_TwoFieldsOneCommaEOL_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("test,test2\r\n", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(2, result.length);
            assertEquals("test", result[0]);
            assertEquals("test2", result[1]);
            assertFalse(csvParser.complete);
            result = csvParser.nextRecord();
            assertEquals(0, result.length);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_OneCommaTwoEmptyEscapedText_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("\"\",\"\"", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(2, result.length);
            assertEquals("", result[0]);
            assertEquals("", result[1]);
            assertTrue(csvParser.complete);
        }

        [Test]
        public function testNextRecord_OnlyCRLF_EmptyVector():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("\r\n", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(0, result.length);
        }

        [Test]
        public function testNextRecord_TwoRecords_ParsesFine():void
        {
            var csvParser:CSVParser = CSVParserMother.createCSVParser("test\r\ntest2", false);
            var result:Vector.<String> = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(1, result.length);
            assertEquals("test", result[0]);
            result = csvParser.nextRecord();
            assertNotNull(result);
            assertEquals(1, result.length);
            assertEquals("test2", result[0]);
            assertTrue(csvParser.complete);
        }
    }
}