using System;
using System.IO;
using System.Linq;

class ListRetractions
{
  static void Main()
  {
    decimal e = 0m;

    while (true)
    {
      string command = Console.ReadLine();

      if (command == null)
        break;

      if (command.StartsWith("G92 "))
      {
        var eArg = command.Split(' ').FirstOrDefault(c => c.StartsWith("E"));

        if (eArg != null)
          e = decimal.Parse(eArg.Substring(1));
      }
      else if (command.StartsWith("G0 ") || command.StartsWith("G1 "))
      {
        var eArg = command.Split(' ').FirstOrDefault(c => c.StartsWith("E"));

        if (eArg != null)
        {
          var newE = decimal.Parse(eArg.Substring(1));

          if (newE < e)
            Console.WriteLine(e - newE);

          e = newE;
        }
      }
    }
  }
}