# Set Execution Policy (bypass restrictions temporarily)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Allow incoming ping requests (ICMP)
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -Direction Inbound -Action Allow

# Allow SSH through Windows Firewall (port 22)
New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow

# Check if OpenSSH is installed
$sshCapability = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

# Install OpenSSH Server if not installed
if ($sshCapability -match "OpenSSH.Server") {
    Write-Output "OpenSSH Server is already installed."
} else {
    Write-Output "Installing OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

# Start SSH service and set it to start automatically
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Confirm SSH status
Get-Service sshd

# Ping a specific IP to test connectivity
ping 10.5.49.161

# Restore execution policy (optional, for security)
Set-ExecutionPolicy Restricted -Scope Process -Force

