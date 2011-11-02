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
    import flash.events.Event;

    /**
     * Error event that captures the root cause for the error.
     */
    public class ErrorEventChain extends ErrorEvent
    {
        private var _rootCause:Error;

        /**
         * Create a new error event that captures the root cause of the error.
         */
        public function ErrorEventChain(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0,
                rootCause:Error = null)
        {
            super(type, bubbles, cancelable, text, id);
            _rootCause = rootCause;
        }

        /**
         * Root cause of the error.
         * @return Root cause
         */
        public function get rootCause():Error
        {
            return _rootCause;
        }

        /**
         * @inheritDoc
         */
        override public function clone():Event
        {
            return new ErrorEventChain(type, bubbles, cancelable, super.text, errorID, _rootCause);
        }

        /**
         * Combines this error's toString() with the root cause's toString() if available.
         * @inheritDoc
         */
        override public function toString():String
        {
            var string:String = super.toString();

            if (_rootCause != null)
            {
                string += "\nCaused by:\n" + _rootCause.toString();
            }
            return string;
        }
    }
}