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
package com.neophi.error
{
    import flexunit.framework.Assert;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;

    public class ErrorChainTest
    {
        private var _argumentError:ArgumentError;

        private var _errorChain:ErrorChain;

        [Before]
        public function setup():void
        {
            _argumentError = new ArgumentError("Bad data");
            _errorChain = new ErrorChain("Root", 0, _argumentError);
        }

        [Test]
        public function testGetStackTrace():void
        {
            var stackTrace:String = _errorChain.getStackTrace();
            assertNotNull(stackTrace);
        }

        [Test]
        public function testGetRootCause():void
        {
            assertEquals(_argumentError, _errorChain.rootCause);
        }

        [Test]
        public function testToString():void
        {
            assertEquals("ErrorChain: Root\nCaused by:\n" + _argumentError.toString(), _errorChain.toString());
        }
    }
}