Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


function Style-ModernButton {
    param (
        [System.Windows.Forms.Button]$btn
    )

    # Define the colors for normal and hover states
    $normalColor = "#00856F"
    $hoverColor  = [System.Drawing.Color]::FromArgb(65, 65, 70)

    # Apply base styles to the button
    $btn.FlatStyle = 'Flat'
    $btn.BackColor = $normalColor
    $btn.ForeColor = [System.Drawing.Color]::WhiteSmoke
    $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::DodgerBlue
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
     $btn.Cursor = [System.Windows.Forms.Cursors]::Hand

    # Hover effect (using event sender casting)
    $btn.Add_MouseEnter({
        $button = $_.Sender
        if ($button -is [System.Windows.Forms.Button]) {
            $button.BackColor = $hoverColor
        }
    })

    $btn.Add_MouseLeave({
        $button = $_.Sender
        if ($button -is [System.Windows.Forms.Button]) {
            $button.BackColor = $normalColor
        }
    })
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Office"
$form.Size = New-Object System.Drawing.Size(200, 250)
$form.BackColor = [System.Drawing.Color]::white
$form.ForeColor = [System.Drawing.Color]::Black
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
$form.Location = New-Object System.Drawing.Point(10,300)
$form.FormBorderStyle = 'None'
$form.TopMost = $true
$iconPath = ".\icon\2.ico"
if (Test-Path $iconPath) {
    $form.Icon = New-Object System.Drawing.Icon($iconPath)
} else {
    Write-Host "Icon file not found at path: $iconPath"
}

$header = New-Object Windows.Forms.Panel
$header.Height = 20
$header.Dock = 'Top'
$header.BackColor = "#00856F"
$form.Controls.Add($header)

$titleLabel = New-Object Windows.Forms.Label
$titleLabel.Text = "Office"
$titleLabel.ForeColor = [Drawing.Color]::White
$titleLabel.Font = New-Object Drawing.Font("Segoe UI", 9, [Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $false
$titleLabel.Dock = 'left'
$titleLabel.Width = 50
$titleLabel.TextAlign = 'MiddleLeft'
$titleLabel.Padding = '5,0,0,0'
$header.Controls.Add($titleLabel)

$btnMin = New-Object Windows.Forms.Button
$btnMin.Text = "─"
$btnMin.Font = New-Object Drawing.Font("Segoe UI", 9)
$btnMin.Size = New-Object Drawing.Size(30, 20)
$btnMin.Anchor = 'Top,Right'
$btnMin.Location = New-Object Drawing.Point([int]($form.ClientSize.Width - 60), 0)
$header.Controls.Add($btnMin)
$btnMin.FlatStyle = 'Flat'
$btnMin.FlatAppearance.BorderSize = 0
$btnMin.BackColor = [Drawing.Color]::DimGray
$btnMin.ForeColor = [Drawing.Color]::White
$btnMin.Add_Click({ $form.WindowState = 'Minimized' })

$btnClose = New-Object Windows.Forms.Button
$btnClose.Text = "X"
$btnClose.Font = New-Object Drawing.Font("Segoe UI", 9)
$btnClose.Size = New-Object Drawing.Size(30, 20)
$btnClose.Anchor = 'Top,Right'
$btnClose.Location = New-Object Drawing.Point([int]($form.ClientSize.Width - 30), 0)
$header.Controls.Add($btnClose)
$btnClose.FlatStyle = 'Flat'
$btnClose.FlatAppearance.BorderSize = 0
$btnClose.BackColor = [Drawing.Color]::IndianRed
$btnClose.ForeColor = [Drawing.Color]::White
$btnClose.Add_Click({ $form.Close() })

# --- Make Header Draggable ---
$global:dragging = $false
$global:startPoint = [System.Drawing.Point]::Empty
$global:sensitivity = 10  # Adjust sensitivity threshold for smoother dragging

$header.Add_MouseDown({
    $global:dragging = $true
    $mousePos = [System.Windows.Forms.Control]::MousePosition
    $global:startPoint = $mousePos
})

$header.Add_MouseMove({
    if ($global:dragging) {
        $mousePos = [System.Windows.Forms.Control]::MousePosition
        
        # Calculate the difference between the current mouse position and the starting point
        $deltaX = $mousePos.X - $global:startPoint.X
        $deltaY = $mousePos.Y - $global:startPoint.Y

        # Only move the form if the mouse has moved more than the sensitivity threshold
        if ([Math]::Abs($deltaX) -gt $global:sensitivity -or [Math]::Abs($deltaY) -gt $global:sensitivity) {
            $formX = $form.Left + $deltaX
            $formY = $form.Top + $deltaY

            # Move the form based on the mouse position
            $form.Location = New-Object System.Drawing.Point($formX, $formY)

            # Update the start point to the new mouse position for smoother movement
            $global:startPoint = $mousePos
        }
    }
})

$header.Add_MouseUp({
    $global:dragging = $false
})


# Function to read JSON data from a file
function Read-JsonFile {
    param (
        [string]$filePath
    )
    $jsonData = Get-Content -Path $filePath -Raw | ConvertFrom-Json
    return $jsonData
}


# Read JSON data from the file
$jsonFilePath = "$($env:TEMP)\DataAktivasi.json"  # Specify the path to your JSON file

if (-Not (Test-Path -Path $jsonFilePath)) {
    [System.Windows.Forms.MessageBox]::Show("Error: Tidak ada Data Aktivasi", "File Not Found", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    return
} else {
    $jsonData = Read-JsonFile -filePath $jsonFilePath
}

$centerLabel = New-Object Windows.Forms.Label
$centerLabel.Text = "Account Creation Helper"
$centerLabel.Location = New-Object System.Drawing.Point(30,20)
$centerLabel.Size = New-Object System.Drawing.Size(200, 20)
$centerLabel.ForeColor = "#00856F"
$centerLabel.Font = New-Object Drawing.Font("Segoe UI", 9, [Drawing.FontStyle]::Bold)
$form.Controls.Add($centerLabel)


# TEXTBOX STYLER ============================================================================================
function Style-TextBox {
    param (
        [System.Windows.Forms.TextBox]$tbx
    )
        $tbx.Add_MouseDown({
        param ($sender, $e)
        if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
            # Ensure the textBox is initialized before trying to drag
            if ($sender -ne $null) {
                $sender.DoDragDrop($sender.Text, [System.Windows.Forms.DragDropEffects]::Copy)
            }
        }
    })
}



$openLink = New-Object System.Windows.Forms.Button
$openLink.Text = "Open Page >>"
$openLink.Size = "200, 30"
$openLink.Location = New-Object System.Drawing.Point(0, 40)
Style-ModernButton $openLink
$openLink.Add_Click({
      

$urls = @(
    "https://signup.live.com/"
)

Start-Process "msedge.exe" -ArgumentList "-inprivate", "$urls"
})

$form.Controls.Add($openLink)


$brand = $jsonData.brand
$teknisi = $jsonData.teknisi
$modelprocessed = $jsonData.modelprocessed
$modeldetected = $jsonData.modeldetected
$serialnumber = $jsonData.serialnumber
$processor = $jsonData.processor
$ram = $jsonData.ram
$storage = $jsonData.storage
$akunoffice = $jsonData.akunoffice


$officeAccountTextBox = New-Object System.Windows.Forms.TextBox
$officeAccountTextBox.Location = New-Object System.Drawing.Point(0, 70)
$officeAccountTextBox.Size = New-Object System.Drawing.Size(200, 20)
$officeAccountTextBox.Text = $jsonData.akunoffice
#$officeAccountTextBox.ReadOnly = $true
Style-TextBox $officeAccountTextBox
$form.Controls.Add($officeAccountTextBox)

$copyAccount = New-Object System.Windows.Forms.Button
$copyAccount.Text = "Copy Email"
$copyAccount.Location = New-Object System.Drawing.Point(0, 90)
$copyAccount.Size = New-Object System.Drawing.Size(200, 30)
Style-ModernButton $copyAccount
$copyAccount.Add_Click({
        [System.Windows.Forms.Clipboard]::SetText($officeAccountTextBox.Text)
        $copyAccount.Text = "Copied"
        start-sleep -Milliseconds 700
        $copyAccount.Text = "Copy Email"

})
$form.Controls.Add($copyAccount)


$passwd = New-Object System.Windows.Forms.TextBox
$passwd.Location = New-Object System.Drawing.Point(0, 120)
$passwd.Size = New-Object System.Drawing.Size(200, 20)
$passwd.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Center
$passwd.Text = "v       Silakan Pilih       v"
$passwd.ReadOnly = $true
Style-TextBox $passwd
$form.Controls.Add($passwd)
$passwd2021 = New-Object System.Windows.Forms.Button
$passwd2021.Text = "office2021"
$passwd2021.Location = New-Object System.Drawing.Point(0, 140)
$passwd2021.Size = New-Object System.Drawing.Size(100, 30)
Style-ModernButton $passwd2021
$passwd2021.Add_Click({
        $passwd.Text = "office2021"
        [System.Windows.Forms.Clipboard]::SetText($passwd2021.Text)
        $passwd2021.Text = "Copied"
        start-sleep -Milliseconds 700
        $passwd2021.Text = "office2021"

})
$form.Controls.Add($passwd2021)
$passwd2024 = New-Object System.Windows.Forms.Button
$passwd2024.Text = "office2024"
$passwd2024.Location = New-Object System.Drawing.Point(100, 140)
$passwd2024.Size = New-Object System.Drawing.Size(100, 30)
Style-ModernButton $passwd2024
$passwd2024.Add_Click({
        $passwd.Text = "office2024"
        [System.Windows.Forms.Clipboard]::SetText($passwd2024.Text)
        $passwd2024.Text = "Copied"
        start-sleep -Milliseconds 700
        $passwd2024.Text = "office2024"

})
$form.Controls.Add($passwd2024)

$namaDpn = New-Object System.Windows.Forms.TextBox
$namaDpn.Location = New-Object System.Drawing.Point(0, 170)
$namaDpn.Size = New-Object System.Drawing.Size(100, 20)
$namaDpn.Text = $jsonData.brand
$namaDpn.ReadOnly = $true
Style-TextBox $namaDpn
$form.Controls.Add($namaDpn)

$copynamaDpn = New-Object System.Windows.Forms.Button
$copynamaDpn.Text = "Nama Dpn"
$copynamaDpn.Location = New-Object System.Drawing.Point(0, 190)
$copynamaDpn.Size = New-Object System.Drawing.Size(100, 30)
Style-ModernButton $copynamaDpn
$copynamaDpn.Add_Click({
        [System.Windows.Forms.Clipboard]::SetText($namaDpn.Text)
        $copynamaDpn.Text = "Copied"
        start-sleep -Milliseconds 700
        $copynamaDpn.Text = "Nama Dpn"

})
$form.Controls.Add($copynamaDpn)


$namaBlkg = New-Object System.Windows.Forms.TextBox
$namaBlkg.Location = New-Object System.Drawing.Point(100, 170)
$namaBlkg.Size = New-Object System.Drawing.Size(350, 20)
$namaBlkg.Text = $jsonData.modelprocessed
$namaBlkg.ReadOnly = $true
Style-TextBox $namaBlkg
$form.Controls.Add($namaBlkg)

$copynamaBlkg = New-Object System.Windows.Forms.Button
$copynamaBlkg.Text = "Nama Blkg"
$copynamaBlkg.Location = New-Object System.Drawing.Point(100, 190)
$copynamaBlkg.Size = New-Object System.Drawing.Size(100, 30)
Style-ModernButton $copynamaBlkg
$copynamaBlkg.Add_Click({
        [System.Windows.Forms.Clipboard]::SetText($namaBlkg.Text)
        $copynamaBlkg.Text = "Copied"
        start-sleep -Milliseconds 700
        $copynamaBlkg.Text = "Nama Blkg"

})
$form.Controls.Add($copynamaBlkg)

$uploadBtn = New-Object System.Windows.Forms.Button
$uploadBtn.Text = "Upload"
$uploadBtn.Location = New-Object System.Drawing.Point(50, 230)
$uploadBtn.Size = New-Object System.Drawing.Size(100, 20)
Style-ModernButton $uploadBtn
$uploadBtn.Add_Click({
    if ($passwd.Text -ne "office2021" -and $passwd.Text -ne "office2024") {
            # Show an error message if the password is invalid
            [System.Windows.Forms.MessageBox]::Show("Silakan Pilih Password 'office2021' atau 'office2024'.", "Invalid Password", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }else{
       
            $uploadBtn.Text = "Uploading"
        
            #https://docs.google.com/forms/d/e/1FAIpQLSf8rBNxLD_s3EJrtajH_v_WE7DUxO5uA9_kkxMW4WnzW0036g/viewform?usp=pp_url&entry.1123239085=Teknisi&entry.1647863460=SerialNumber&entry.862978679=Brand&entry.942663444=ModelProcessed&entry.1915803962=ModelDetected&entry.490213951=Processor&entry.433477474=Ram&entry.551716795=Storage&entry.1305841159=AkunOffice&entry.434891167=Password
        $formUrl = "https://docs.google.com/forms/d/e/1FAIpQLSetEJsh0YeC8YRn-W6EMNmQfcYhLxCNkGpn5zf0SNr2XW0jqg/formResponse"
         $formData = @{
            "entry.80679584" = "$teknisi"   #teknisi
            "entry.1221910596" = "$serialnumber" #sn
            "entry.1477663918" = "$brand" #brand
            "entry.1219257192" = "$modelprocessed" #modelprocessd
            "entry.2013583334" = "$modeldetected" #modeldtcted
            "entry.985676516" = "$processor" #processor
            "entry.1024081183" = "$($ram)GB"   #ram
            "entry.642883361" = "$storage" #storage
            "entry.315707343" = "$($officeAccountTextBox.Text)" #akunoffice
            "entry.1851907708" = "$($passwd.Text)" #password
        }
         $response = Invoke-WebRequest -Uri $formUrl -Method POST -Body $formData
          if ($response.StatusCode -eq 200) {
           $uploadBtn.Text = "Upload Success"
           
          } else {
            [System.Windows.Forms.MessageBox]::Show("Gagal Menyimpan Data. Pastikan Terkoneksi Internet", "No Internet")
            $uploadBtn.Text = "Upload"
            return
            }

    }
})
$form.Controls.Add($uploadBtn)



$form.Add_Shown({
    $form.Activate()
})
# Run
[void]$form.ShowDialog()
