<# ========================== Discord Bot Control GUI ==========================

SYNOPSIS
This script generates a GUI window to control a Discord Bot in Powershell.

FEATURES
- Display all guilds
- Display Channels in a Guild
- Display Messages for each Channel
- Send a Message as the Bot
- Create an Invite Link for selected Channel
- Create a channel with custom name
- Delete a selected channel
- Kick / Ban Selected Users
- Unban username

USAGE
1. Run the script to open the GUI window.
2. Input your token.
3. Control the bot actions in 'Control' Tab.

#>

$HideConsole = 1 # HIDE THE WINDOW - Change to 1 to hide the console window while running

# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$imageUrl = "https://i.imgur.com/v162hMS.png"
$client = New-Object System.Net.WebClient
$imageBytes = $client.DownloadData($imageUrl)
$ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Discord LiveBot"
$form.Size = New-Object System.Drawing.Size(1400, 920)
$form.Font = 'Microsoft Sans Serif,10'
$form.BackColor = "#242424"
$form.ForeColor = [System.Drawing.Color]::White

# Create a tab control to switch between login and main application
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'
$tabControl.Font = 'Microsoft Sans Serif,11'
$tabControl.BackColor = "#242424"

# Create the login tab
$loginTab = New-Object System.Windows.Forms.TabPage
$loginTab.Text = "Login"
$loginTab.BackgroundImage = [System.Drawing.Image]::FromStream($ms, $true)
$loginTab.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::zoom
$loginTab.BackColor = "#242424"

# Token Label
$tokenLabel = New-Object System.Windows.Forms.Label
$tokenLabel.Text = "Discord Bot Token"
$tokenLabel.Location = New-Object System.Drawing.Point(600, 300)
$tokenLabel.Size = New-Object System.Drawing.Size(200, 33)
$tokenLabel.Font = 'Microsoft Sans Serif,16,style=Bold'

# Token TextBox
$tokenTextBox = New-Object System.Windows.Forms.TextBox
$tokenTextBox.Location = New-Object System.Drawing.Point(400, 340)
$tokenTextBox.Width = 600
$tokenTextBox.Height = 40
$tokenTextBox.Font = 'Microsoft Sans Serif,10'
$tokenTextBox.BackColor = "#242424"
$tokenTextBox.ForeColor = [System.Drawing.Color]::White

# Login Button
$loginButton = New-Object System.Windows.Forms.Button
$loginButton.Text = "Login"
$loginButton.Location = New-Object System.Drawing.Point(640, 380)
$loginButton.Size = New-Object System.Drawing.Size(100, 40)
$loginButton.Width = 100
$loginButton.BackColor = "#242424"
$loginButton.ForeColor = [System.Drawing.Color]::White
$loginButton.Font = 'Microsoft Sans Serif,12,style=Bold'

# Add controls to the login tab
$loginTab.Controls.AddRange(@($tokenLabel, $tokenTextBox, $loginButton))
$tabControl.TabPages.Add($loginTab)

# Create the main application tab
$appTab = New-Object System.Windows.Forms.TabPage
$appTab.Text = "Control "
$appTab.BackgroundImage = [System.Drawing.Image]::FromStream($ms, $true)
$appTab.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::zoom
$appTab.BackColor = "#242424"

# Layout: Labels and ListBoxes
$guildsLabel = New-Object System.Windows.Forms.Label
$guildsLabel.Text = "Guilds"
$guildsLabel.Location = New-Object System.Drawing.Point(10, 10)
$guildsLabel.Font = 'Microsoft Sans Serif,12,style=Bold'

$guildsListBox = New-Object System.Windows.Forms.ListBox
$guildsListBox.Location = New-Object System.Drawing.Point(10, 40)
$guildsListBox.Size = New-Object System.Drawing.Size(250, 600)
$guildsListBox.BackColor = "#242424"
$guildsListBox.ForeColor = [System.Drawing.Color]::White

$channelsLabel = New-Object System.Windows.Forms.Label
$channelsLabel.Text = "Channels"
$channelsLabel.Location = New-Object System.Drawing.Point(270, 10)
$channelsLabel.Font = 'Microsoft Sans Serif,12,style=Bold'

$channelsListBox = New-Object System.Windows.Forms.ListBox
$channelsListBox.Location = New-Object System.Drawing.Point(270, 40)
$channelsListBox.Size = New-Object System.Drawing.Size(250, 600)
$channelsListBox.BackColor = "#242424"
$channelsListBox.ForeColor = [System.Drawing.Color]::White

$usersLabel = New-Object System.Windows.Forms.Label
$usersLabel.Text = "Members"
$usersLabel.Location = New-Object System.Drawing.Point(1110, 10)
$usersLabel.Font = 'Microsoft Sans Serif,12,style=Bold'

$usersListBox = New-Object System.Windows.Forms.ListBox
$usersListBox.Location = New-Object System.Drawing.Point(1110, 40)
$usersListBox.Size = New-Object System.Drawing.Size(250, 800)
$usersListBox.BackColor = "#242424"
$usersListBox.ForeColor = [System.Drawing.Color]::White

$messagesLabel = New-Object System.Windows.Forms.Label
$messagesLabel.Text = "Messages"
$messagesLabel.Location = New-Object System.Drawing.Point(530, 10)
$messagesLabel.Font = 'Microsoft Sans Serif,12,style=Bold'

$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(530, 40)
$outputBox.Size = New-Object System.Drawing.Size(565, 750)
$outputBox.ReadOnly = $true
$outputBox.BackColor = "#242424"
$outputBox.ForeColor = [System.Drawing.Color]::White
$outputBox.Font = 'Microsoft Sans Serif,11'

$messageTextBox = New-Object System.Windows.Forms.TextBox
$messageTextBox.Location = New-Object System.Drawing.Point(530, 800)
$messageTextBox.Size = New-Object System.Drawing.Size(450, 30)
$messageTextBox.BackColor = "#242424"
$messageTextBox.ForeColor = [System.Drawing.Color]::White

$sendButton = New-Object System.Windows.Forms.Button
$sendButton.Text = "Send"
$sendButton.Location = New-Object System.Drawing.Point(1000, 796)
$sendButton.Size = New-Object System.Drawing.Size(90, 30)
$sendButton.BackColor = "#242424"
$sendButton.ForeColor = [System.Drawing.Color]::White
$sendButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Generate Invite Link Button
$generateInviteButton = New-Object System.Windows.Forms.Button
$generateInviteButton.Text = "Generate Invite Link"
$generateInviteButton.Location = New-Object System.Drawing.Point(15, 647)
$generateInviteButton.Size = New-Object System.Drawing.Size(160, 30)
$generateInviteButton.BackColor = "#242424"
$generateInviteButton.ForeColor = [System.Drawing.Color]::White
$generateInviteButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Output box for invite link
$inviteLinkBox = New-Object System.Windows.Forms.TextBox
$inviteLinkBox.Location = New-Object System.Drawing.Point(190, 650)
$inviteLinkBox.Size = New-Object System.Drawing.Size(320, 30)
$inviteLinkBox.Text = "No Link Generated"
$inviteLinkBox.ReadOnly = $true
$inviteLinkBox.BackColor = "#242424"
$inviteLinkBox.ForeColor = [System.Drawing.Color]::White
$inviteLinkBox.Font = 'Microsoft Sans Serif,10'

$newChannelNameTextBox = New-Object System.Windows.Forms.TextBox
$newChannelNameTextBox.Location = New-Object System.Drawing.Point(20, 690)
$newChannelNameTextBox.Size = New-Object System.Drawing.Size(150, 30)
$newChannelNameTextBox.Text = "new-channel-name"
$newChannelNameTextBox.BackColor = "#242424"
$newChannelNameTextBox.ForeColor = [System.Drawing.Color]::White
$newChannelNameTextBox.Font = 'Microsoft Sans Serif,10'

# Button to create a new channel
$createChannelButton = New-Object System.Windows.Forms.Button
$createChannelButton.Text = "Create Channel"
$createChannelButton.Location = New-Object System.Drawing.Point(185, 687)
$createChannelButton.Size = New-Object System.Drawing.Size(130, 30)
$createChannelButton.BackColor = "#242424"
$createChannelButton.ForeColor = [System.Drawing.Color]::White
$createChannelButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Button to delete selected channel
$deleteChannelButton = New-Object System.Windows.Forms.Button
$deleteChannelButton.Text = "Delete Selected Channel"
$deleteChannelButton.Location = New-Object System.Drawing.Point(325, 687)
$deleteChannelButton.Size = New-Object System.Drawing.Size(190, 30)
$deleteChannelButton.BackColor = "#242424"
$deleteChannelButton.ForeColor = [System.Drawing.Color]::White
$deleteChannelButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Kick Button
$kickButton = New-Object System.Windows.Forms.Button
$kickButton.Text = "Kick Selected Member"
$kickButton.Location = New-Object System.Drawing.Point(15, 730)
$kickButton.Size = New-Object System.Drawing.Size(240, 30)
$kickButton.BackColor = "#242424"
$kickButton.ForeColor = [System.Drawing.Color]::White
$kickButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Ban Button
$banButton = New-Object System.Windows.Forms.Button
$banButton.Text = "Ban Selected Member"
$banButton.Location = New-Object System.Drawing.Point(270, 730)
$banButton.Size = New-Object System.Drawing.Size(240, 30)
$banButton.BackColor = "#242424"
$banButton.ForeColor = [System.Drawing.Color]::White
$banButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Unban Input Box for username
$unbanUserTextBox = New-Object System.Windows.Forms.TextBox
$unbanUserTextBox.Location = New-Object System.Drawing.Point(20, 775)
$unbanUserTextBox.Size = New-Object System.Drawing.Size(150, 30)
$unbanUserTextBox.Text = "username"
$unbanUserTextBox.BackColor = "#242424"
$unbanUserTextBox.ForeColor = [System.Drawing.Color]::White

# Unban Button
$unbanButton = New-Object System.Windows.Forms.Button
$unbanButton.Text = "Unban Username"
$unbanButton.Location = New-Object System.Drawing.Point(180, 772)
$unbanButton.Size = New-Object System.Drawing.Size(160, 30)
$unbanButton.BackColor = "#242424"
$unbanButton.ForeColor = [System.Drawing.Color]::White
$unbanButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Invite User Button
$inviteuserButton = New-Object System.Windows.Forms.Button
$inviteuserButton.Text = "Invite Username"
$inviteuserButton.Location = New-Object System.Drawing.Point(350, 772)
$inviteuserButton.Size = New-Object System.Drawing.Size(160, 30)
$inviteuserButton.BackColor = "#242424"
$inviteuserButton.ForeColor = [System.Drawing.Color]::White
$inviteuserButton.Font = 'Microsoft Sans Serif,10,style=Bold'

# Add controls to the app tab
$appTab.Controls.AddRange(@($messagesLabel, $guildsLabel, $guildsListBox, $channelsLabel, $channelsListBox, $usersLabel, $usersListBox, $outputBox, $messageTextBox, $sendButton, $generateInviteButton, $inviteLinkBox, $newChannelNameLabel, $newChannelNameTextBox, $createChannelButton, $deleteChannelButton, $unbanUserTextBox, $unbanButton, $kickButton, $banButton, $inviteuserButton))
$tabControl.TabPages.Add($appTab)
$form.Controls.Add($tabControl)

# Login button click event
$loginButton.Add_Click({
    $token = $tokenTextBox.Text
    if (-not [string]::IsNullOrWhiteSpace($token)) {
        $guildsListBox.Items.Clear()
        # Fetch guilds
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $guildsResponse = $wc.DownloadString("https://discord.com/api/v10/users/@me/guilds")
        $guilds = $guildsResponse | ConvertFrom-Json
        foreach ($guild in $guilds) {
            $guildsListBox.Items.Add("$($guild.name) ($($guild.id))")
        }
        $tabControl.SelectTab($appTab)  # Switch to the app tab
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a valid Discord Bot Token.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Guilds list box selection changed event
$guildsListBox.Add_SelectedIndexChanged({
    $channelsListBox.Items.Clear()  # Clear previous channels
    $usersListBox.Items.Clear()      # Clear previous users
    $outputBox.Clear()
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    if ($selectedGuild) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        # Fetch channels
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $channelsResponse = $wc.DownloadString("https://discord.com/api/v10/guilds/$guildId/channels")
        $channels = $channelsResponse | ConvertFrom-Json
        foreach ($channel in $channels) {
            # Display channel name and ID
            if ($channel.type -eq 0) {  # Only include text channels
                $channelsListBox.Items.Add("$($channel.name) ($($channel.id))") 
            }
        }

        # Fetch users (members) of the guild
        $membersResponse = $wc.DownloadString("https://discord.com/api/v10/guilds/$guildId/members?limit=1000")
        $members = $membersResponse | ConvertFrom-Json
        foreach ($member in $members) {
            $usersListBox.Items.Add("$($member.user.username) ($($member.user.id))")
        }
    }
})

$channelsListBox.Add_SelectedIndexChanged({
    $outputBox.Clear()
    $token = $tokenTextBox.Text
    $selectedChannel = $channelsListBox.SelectedItem
    if ($selectedChannel) {
        $channelId = $selectedChannel -replace '.* \((.*)\)', '$1'  # Extract the Channel ID
        # Fetch messages
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $messagesResponse = $wc.DownloadString("https://discord.com/api/v10/channels/$channelId/messages")
        $messages = $messagesResponse | ConvertFrom-Json
        
        # Reverse the messages order
        $messages = $messages | Sort-Object timestamp -Unique
        
        foreach ($message in $messages) {
            $username = $message.author.username
            $timestamp = [datetime]::Parse($message.timestamp).ToString("yyyy-MM-dd HH:mm:ss")
            $outputBox.SelectionColor = [System.Drawing.Color]::Gray
            $outputBox.SelectionFont = New-Object System.Drawing.Font("Microsoft Sans Serif", 8)
            $outputBox.AppendText("[$timestamp]  :  $username`r`n")
            $outputBox.SelectionColor = [System.Drawing.Color]::White
            $outputBox.SelectionFont = New-Object System.Drawing.Font("Microsoft Sans Serif", 11)
            $outputBox.AppendText("$($message.content)`r`n`n")
            $outputBox.ScrollToCaret()
        }
    }
})

# Send button click event
$sendButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedChannel = $channelsListBox.SelectedItem
    if ($selectedChannel) {
        $channelId = $selectedChannel -replace '.* \((.*)\)', '$1'  # Extract the Channel ID
        $messageContent = $messageTextBox.Text
        if (-not [string]::IsNullOrWhiteSpace($messageContent)) {
            # Send message
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("Authorization", "Bot $token")
            $wc.Headers.Add("Content-Type", "application/json")
            $messageBody = @{
                content = $messageContent
            } | ConvertTo-Json
            $wc.UploadString("https://discord.com/api/v10/channels/$channelId/messages", "POST", $messageBody)
            $messageTextBox.Clear()
            $outputBox.Refresh()
            $outputBox.ScrollToCaret()
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a channel to send a message.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Generate Invite Link button click event
$generateInviteButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    $selectedChannel = $channelsListBox.SelectedItem
    if ($selectedGuild -and $selectedChannel) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        $channelId = $selectedChannel -replace '.* \((.*)\)', '$1'  # Extract the Channel ID
        # Generate invite link
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $wc.Headers.Add("Content-Type", "application/json")
        $inviteParams = @{
            max_age = 3600  # 1 hour expiration
            max_uses = 1    # Single use
            target_channel_id = $channelId
        } | ConvertTo-Json
        $inviteResponse = $wc.UploadString("https://discord.com/api/v10/channels/$channelId/invites", "POST", $inviteParams)
        $invite = $inviteResponse | ConvertFrom-Json
        $inviteLink = "https://discord.gg/$($invite.code)"
        $inviteLinkBox.Text = $inviteLink
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select both a guild and a channel.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})


# Create new channel button click event
$createChannelButton.Add_Click({
    $token = $tokenTextBox.Text
    $newChannelName = $newChannelNameTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    if ($selectedGuild -and $newChannelName) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        # Create new channel
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $wc.Headers.Add("Content-Type", "application/json")
        $body = @{
            name = $newChannelName
            type = 0  # Text channel
        } | ConvertTo-Json
        $wc.UploadString("https://discord.com/api/v10/guilds/$guildId/channels", "POST", $body)
        [System.Windows.Forms.MessageBox]::Show("Channel '$newChannelName' created successfully.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a guild and enter a channel name.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Delete selected channel button click event
$deleteChannelButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    $selectedChannel = $channelsListBox.SelectedItem
    if ($selectedGuild -and $selectedChannel) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        $channelId = $selectedChannel -replace '.* \((.*)\)', '$1'  # Extract the Channel ID
        # Delete selected channel
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $wc.UploadString("https://discord.com/api/v10/channels/$channelId", "DELETE", "")
        [System.Windows.Forms.MessageBox]::Show("Channel '$selectedChannel' deleted successfully.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $channelsListBox.Items.Remove($selectedChannel)  # Remove from listbox
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a guild and a channel to delete.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Invite User Button Click Event
$inviteuserButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    $selectedChannel = $channelsListBox.SelectedItem
    $usernameToInvite = $unbanUserTextBox.Text  # Assuming $unbanUserTextBox holds the username

    if ($selectedGuild -and $selectedChannel -and $usernameToInvite) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        $channelId = $selectedChannel -replace '.* \((.*)\)', '$1'  # Extract the Channel ID

        # Generate invite link
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $wc.Headers.Add("Content-Type", "application/json")
        
        # Create invite for the selected channel
        $inviteParams = @{
            max_age = 3600  # 1 hour expiration
            max_uses = 1    # Single use invite
            target_channel_id = $channelId
        } | ConvertTo-Json

        try {
            $inviteResponse = $wc.UploadString("https://discord.com/api/v10/channels/$channelId/invites", "POST", $inviteParams)
            $invite = $inviteResponse | ConvertFrom-Json
            $inviteLink = "https://discord.gg/$($invite.code)"

            # Display generated invite link in the inviteLinkBox
            $inviteLinkBox.Text = $inviteLink

            # Notify or use this link to send it to the given username
            [System.Windows.Forms.MessageBox]::Show("Invite link generated for $usernameToInvite : $inviteLink", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to generate invite link.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a guild, a channel, and provide a username to invite.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

$unbanButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    $unbanUsername = $unbanUserTextBox.Text
    if ($selectedGuild -and $unbanUsername) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        
        # Fetch all bans to get the user ID for the given username
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $bansResponse = $wc.DownloadString("https://discord.com/api/v10/guilds/$guildId/bans")
        $bans = $bansResponse | ConvertFrom-Json

        # Find the user in the ban list by username (no discriminator)
        $userToUnban = $bans | Where-Object { $_.user.username -eq $unbanUsername }

        if ($userToUnban) {
            # Unban the user by user ID
            $userId = $userToUnban.user.id
            $wc.UploadString("https://discord.com/api/v10/guilds/$guildId/bans/$userId", "DELETE", "")
            [System.Windows.Forms.MessageBox]::Show("User '$unbanUsername' unbanned successfully.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show("User '$unbanUsername' not found in the ban list.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a guild and enter a valid username.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Ban button click event
$banButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    $selectedUser = $usersListBox.SelectedItem
    if ($selectedGuild -and $selectedUser) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        $userId = $selectedUser -replace '.* \((.*)\)', '$1'    # Extract the User ID
        # Ban the user
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $wc.UploadString("https://discord.com/api/v10/guilds/$guildId/bans/$userId", "PUT", "")
        [System.Windows.Forms.MessageBox]::Show("User '$selectedUser' banned successfully.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $usersListBox.Items.Remove($selectedUser)  # Remove from listbox
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a guild and a user to ban.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Kick button click event
$kickButton.Add_Click({
    $token = $tokenTextBox.Text
    $selectedGuild = $guildsListBox.SelectedItem
    $selectedUser = $usersListBox.SelectedItem
    if ($selectedGuild -and $selectedUser) {
        $guildId = $selectedGuild -replace '.* \((.*)\)', '$1'  # Extract the Guild ID
        $userId = $selectedUser -replace '.* \((.*)\)', '$1'    # Extract the User ID
        # Kick the user
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        $wc.UploadString("https://discord.com/api/v10/guilds/$guildId/members/$userId", "DELETE", "")
        [System.Windows.Forms.MessageBox]::Show("User '$selectedUser' kicked successfully.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $usersListBox.Items.Remove($selectedUser)  # Remove from listbox
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a guild and a user to kick.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

function HideWindow {
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    if($hwnd -ne [System.IntPtr]::Zero){
        $Type::ShowWindowAsync($hwnd, 0)
    }
    else{
        $Host.UI.RawUI.WindowTitle = 'hideme'
        $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
        $hwnd = $Proc.MainWindowHandle
        $Type::ShowWindowAsync($hwnd, 0)
    }
}

If ($hideconsole -eq 1){ 
    HideWindow
}

# Show the form
[void]$form.ShowDialog()
