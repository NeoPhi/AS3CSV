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
    import flash.events.ErrorEvent;

    import flexunit.framework.Assert;

    import org.flexunit.asserts.assertEquals;

    public class ErrorEventChainTest
    {
        private var _argumentError:ArgumentError;

        private var _errorEventChain:ErrorEventChain;

        [Before]
        public function setup():void
        {
            _argumentError = new ArgumentError("Bad data");
            _errorEventChain = new ErrorEventChain(ErrorEvent.ERROR, true, true, "Root Error", 2, _argumentError);
        }

        [Test]
        public function testClone():void
        {
            var clone:ErrorEventChain = ErrorEventChain(_errorEventChain.clone());
            assertEquals(ErrorEvent.ERROR, clone.type);
            assertEquals(true, clone.bubbles);
            assertEquals(true, clone.cancelable);
            assertEquals("Root Error", clone.text);
            assertEquals(2, clone.errorID);
            assertEquals(_argumentError, clone.rootCause);
        }

        [Test]
        public function testGetRootCause():void
        {
            assertEquals(_argumentError, _errorEventChain.rootCause);
        }

        [Test]
        public function testToString():void
        {
            var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, true, true, "Root Error", 2);
            assertEquals(errorEvent.toString() + "\nCaused by:\n" + _argumentError.toString(), _errorEventChain.toString());
        }
    }
}