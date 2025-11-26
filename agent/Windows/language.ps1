# ---------------------------
# Get current OS display language (always available)
# ---------------------------

$osLang = (Get-WinUserLanguageList)[0].Autonym


# ---------------------------
# Get current active keyboard layout (not default)
# ---------------------------

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
    $keyboardLayout = "Unknown"
}

# Convert LANGID -> Culture using Win32 fallback (always works)
try {
    $culture = [System.Globalization.CultureInfo]::GetCultureInfo($langId)
} catch {
    $culture = "Unknown"
}

$keyboardLayout = $culture.DisplayName

# ---------------------------
# Output
# ---------------------------

$xml = "<LANGUAGE>"
$xml += "<OSLANG>$osLang</OSLANG>"
$xml += "<KEYLAYOUT>$keyboardLayout</KEYLAYOUT>"
$xml += "</LANGUAGE>"

Write-Output $xml
