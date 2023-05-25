Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[int32]$iFormWidth = 350
[int32]$iWidthTextBox = 50
[int32]$iMaxFaultTime = 0

$form = New-Object System.Windows.Forms.Form
$form.Text = 'GUI AuswertungStoerungsCSV'
$form.StartPosition = 'CenterScreen'
$form.Size = New-Object System.Drawing.Size($iFormWidth,300)

$label = New-Object System.Windows.Forms.Label
$label.Text = 'Max. Dauer der Stoerungen in Sekunden:'
$label.AutoSize = $true

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size($iWidthTextBox,$textBox.Size.Height)
$textBox.Text = '1'

$folderButton = New-Object System.Windows.Forms.Button
$folderButton.Text = 'ganzer Ordner'
$folderButton.AutoSize = $true
$folderButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes

$fileButton = New-Object System.Windows.Forms.Button
$fileButton.Size = New-Object System.Drawing.Size($folderButton.Size.Width,$folderButton.Size.Height)
$fileButton.Text = '1 Datei'
$fileButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Size = New-Object System.Drawing.Size($folderButton.Size.Width,$folderButton.Size.Height)
$cancelButton.Text = 'beenden'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton

$label.Location = New-Object System.Drawing.Point(25,10)
$form.Controls.Add($label)

$textBox.Location = New-Object System.Drawing.Point((2 * $label.Location.X + $label.Size.Width),($label.Location.Y + ($label.Size.Height - $textBox.Size.Height) / 2))
$form.Controls.Add($textBox)

$fileButton.Location = New-Object System.Drawing.Point((($form.Size.Width - ($fileButton.Size.Width * 3))/5),(2 * $label.Location.Y + $label.Size.Height))
$form.Controls.Add($fileButton)

$folderButton.Location = New-Object System.Drawing.Point((2 * $fileButton.Location.X + $fileButton.Size.Width),$fileButton.Location.Y)
$form.Controls.Add($folderButton)

$cancelButton.Location = New-Object System.Drawing.Point(($folderButton.Location.X + $folderButton.Size.Width + $fileButton.Location.X),$fileButton.Location.Y)
$form.Controls.Add($cancelButton)

$form.Size = New-Object System.Drawing.Size($iFormWidth,($fileButton.Location.Y + $fileButton.Size.Height + $label.Location.Y + 40))

$form.Add_Shown({$textBox.Select()})

$form.Topmost = $true

$result = $form.ShowDialog()

if($result.value__.Equals(1)){
 $iMaxFaultTime = $textBox.Text
 $selectFile = New-Object System.Windows.Forms.OpenFileDialog
 $selectFile.InitialDirectory = "c:\"
 $selectFile.Filter = "CSV-Files (*.csv)|*.csv"
 $selectFile.Multiselect = $false
 $selectFile.ShowDialog() | Out-Null
 if($selectFile.FileName -ne ""){
  $selectedFile = Get-Item $selectFile.FileName
  .\AuswertungStoerungsCSV.ps1 $selectedFile.PSParentPath $selectedFile.Name $iMaxFaultTime
  exit
 }
 else{
  .\AuswertungStoerungsCSV-GUI.ps1
 }
}
elseif($result.value__.Equals(6)){
 $iMaxFaultTime = $textBox.Text
 $selectFolder = New-Object System.Windows.Forms.FolderBrowserDialog
 $selectFolder.ShowNewFolderButton = $false
 $selectFolder.ShowDialog() | Out-Null
 if($selectFolder.SelectedPath -ne ""){
  .\AuswertungStoerungsCSVsKompletterOrdner.ps1 $selectFolder.SelectedPath $iMaxFaultTime
  exit
 }
 else{
  .\AuswertungStoerungsCSV-GUI.ps1  
 }
}
elseif($result.value__.Equals(2)){
 stop-process -Id $PID
}