# ------------------------------------------------------------
# Get OS display language (English)
# ------------------------------------------------------------
$osLang = (Get-WinUserLanguageList)[0].EnglishName

# ------------------------------------------------------------
# Add C# code to read active keyboard layout
# ------------------------------------------------------------
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

    public static int GetCurrentKeyboardLayout() {
        IntPtr hWnd = GetForegroundWindow();
        if (hWnd == IntPtr.Zero) return -1;

        uint pid;
        uint tid = GetWindowThreadProcessId(hWnd, out pid);
        IntPtr hKL = GetKeyboardLayout(tid);

        return hKL.ToInt32() & 0xFFFF; // LANGID (low word)
    }
}
"@


# ------------------------------------------------------------
# Impersonate the active console user
# ------------------------------------------------------------
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class TokenUtil {
    [DllImport("wtsapi32.dll", SetLastError = true)]
    public static extern bool WTSQueryUserToken(uint sessionId, out IntPtr Token);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool ImpersonateLoggedOnUser(IntPtr token);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool RevertToSelf();
}
"@


# Get active session ID (console user)
$sessionId = (Get-Process -Name explorer -ErrorAction SilentlyContinue).SessionId

# Get and impersonate the logged‑in user token
$token = [IntPtr]::Zero
[TokenUtil]::WTSQueryUserToken([uint32]$sessionId, [ref]$token) | Out-Null

if ($token -ne [IntPtr]::Zero) {
    [TokenUtil]::ImpersonateLoggedOnUser($token) | Out-Null
}

# ------------------------------------------------------------
# Get ACTIVE keyboard layout (English name)
# ------------------------------------------------------------
$langId = [KeyboardLayoutReader]::GetCurrentKeyboardLayout()

if ($langId -gt 0) {
    $keyboardLayout = (New-Object System.Globalization.CultureInfo($langId)).EnglishName
} else {
    $keyboardLayout = ""
}

# Stop impersonation
[TokenUtil]::RevertToSelf() | Out-Null

# ------------------------------------------------------------
# OUTPUT
# ------------------------------------------------------------
$xml = "<LANGUAGE>"
$xml += "<OSLANG>$osLang</OSLANG>"
$xml += "<KEYLAYOUT>$keyboardLayout</KEYLAYOUT>"
$xml += "</LANGUAGE>"

Write-Output $xml