using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace csKrugNStSpkv
{
    class Log
    {
        private static object locker = new object();
        private static string logFile;
        public static void W(string logText, string _logFile="") //W==Write
        {
            if (_logFile!="") { logFile = _logFile; }
            lock (locker)
            {
                try
                {
                    using (StreamWriter sw = new StreamWriter (logFile,true,System.Text.Encoding.Unicode))
                    {
                        sw.WriteLine(DateTime.Now.ToString()+" "+logText);
                    }
                }
                catch (Exception)
                {
                    ;
                }
            }

        }

    }
}
