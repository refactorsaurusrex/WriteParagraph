using System;
using System.Linq;
using System.Management.Automation;
using JetBrains.Annotations;

namespace WriteParagraph
{
    [PublicAPI]
    [Cmdlet(VerbsCommunications.Write, "Paragraph")]
    public class WriteParagraphCmdlet : PSCmdlet
    {
        [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true)]
        public string Text { get; set; }

        [Parameter]
        public ConsoleColor? ForegroundColor { get; set; }

        [Parameter]
        public ConsoleColor? BackgroundColor { get; set; }

        [Parameter]
        public int MaxWidth { get; set; }

        [Parameter]
        public int LinesBefore { get; set; }

        [Parameter]
        public int LinesAfter { get; set; }

        protected override void ProcessRecord()
        {
            BackgroundColor = BackgroundColor ?? Host.UI.RawUI.BackgroundColor;
            ForegroundColor = ForegroundColor ?? Host.UI.RawUI.ForegroundColor;
            var width = MaxWidth > 0 ? MaxWidth : Host.UI.RawUI.WindowSize.Width;
            var wrapped = LineWrap(Text, width);

            Host.UI.Write(string.Concat(Enumerable.Repeat(Environment.NewLine, LinesBefore)));
            Host.UI.Write(ForegroundColor.Value, BackgroundColor.Value, wrapped);
            Host.UI.Write(string.Concat(Enumerable.Repeat(Environment.NewLine, LinesAfter)));
        }

        private static string LineWrap(string text, int width)
        {
            var delimiter = ' ';
            var words = text.Split(delimiter);
            var allLines = words.Skip(1).Aggregate(words.Take(1).ToList(), (lines, word) =>
            {
                if (lines.Last().Length + word.Length >= width - 1) // Minus 1, to allow for newline char
                    lines.Add(word);
                else
                    lines[lines.Count - 1] += delimiter + word;
                return lines;
            });

            return $"{string.Join(Environment.NewLine, allLines.ToArray())}{Environment.NewLine}";
        }
    }
}
