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

    /**
     * Wraps an Error to capture a root cause.
     */
    public class ErrorChain extends Error
    {
        private var _rootCause:Error;

        /**
         * Construct a new insatnce.
         * @param message Error message
         * @param id Error identifier
         * @param rootCause Root cause of error
         */
        public function ErrorChain(message:String = "", id:int = 0, rootCause:Error = null)
        {
            super(message, id);
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
         * Combines this error's stack trace with the root cause's stack trace if available.
         * @inheritDoc
         */
        override public function getStackTrace():String
        {
            var stackTrace:String = super.getStackTrace();

            if (_rootCause != null)
            {
                stackTrace += "\nCaused by:\n" + _rootCause.getStackTrace();
            }
            return stackTrace;
        }

        /**
         * Combines this error's message with the root cause's message if available.
         * @inheritDoc
         */
        public function toString():String
        {
            var string:String = "ErrorChain";

            if (message != null)
            {
                string += ": " + message;
            }

            if (_rootCause != null)
            {
                string += "\nCaused by:\n" + _rootCause.toString();
            }
            return string;
        }
    }
}