$osLangTag = (Get-WinUserLanguageList)[0].LanguageTag
$osLangEnglish = ([System.Globalization.CultureInfo]::GetCultureInfo($osLangTag)).EnglishName

# Get current active keyboard layout (not default)
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class KeyboardLayoutReader {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hwnd, out uint processId);

    [DllImport("user32.dll")]
    public static extern IntPtr GetKeyboardLayout(uint idThread);

    public static int GetCurrentKeyboardLangId() {
        IntPtr hWnd = GetForegroundWindow();
        if (hWnd == IntPtr.Zero)
            return -1;

        uint pid;
        uint tid = GetWindowThreadProcessId(hWnd, out pid);

        IntPtr hKL = GetKeyboardLayout(tid);

        return (int)hKL & 0xFFFF; // LANGID
    }
}
"@

$langId = [KeyboardLayoutReader]::GetCurrentKeyboardLangId()

if ($langId -lt 0) {
    $keyboardLayoutEnglish = "Unknown"
}

# Convert LANGID to English culture name
if ($langId -ge 0) {
    $culture = [System.Globalization.CultureInfo]::GetCultureInfo($langId)
    $keyboardLayoutEnglish = $culture.EnglishName
}

$xml = "<LANGUAGE>"
$xml += "<OSLANG>$osLangEnglish</OSLANG>"
$xml += "<KEYLAYOUT>$keyboardLayoutEnglish</KEYLAYOUT>"
$xml += "</LANGUAGE>"

Write-Output $xml
