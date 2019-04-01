param(
    # Manifest file path
    [Parameter(Mandatory=$true)]
    [String]$manifestFilePath,
    # Node to update
    [Parameter(Mandatory=$true)]
    [String]$nodeToUpdate,
    # Value to update
    [Parameter(Mandatory=$true)]
    [String]$valueToUpdate,
    # Whether the value is Version
    [Parameter(Mandatory=$true)]
    [string]$isVersion,
    # Part in version to update
    [Parameter(Mandatory=$false)]
    [string]$versionPart
)

function Update-Version {
    param (
        [Version]$version, [string]$partToIncrement
    )
    Write-Host "Current Major: " $version.Major
    Write-Host "Current Minor: " $version.Minor
    Write-Host "Current Build: " $version.Build
    Write-Host "Current Revision: " $version.Revision

    $major = $version.Major
    $minor = $version.Minor
    $build = $version.Build
    $revision = $version.Revision

    switch ($partToIncrement.ToLower()) {
        "major" { 
            $major += 1 
            $minor = 0
            $build = 0
            $revision = 0
        }
        "minor" { 
            $minor += 1 
            $build = 0
            $revision = 0
        }
        "build" { 
            $build += 1 
            $revision = 0
        }
        "revision" { $revision += 1 }
    }

    $newVersion = "{0}.{1}.{2}.{3}" -f $major, $minor, $build, $revision

    Write-Host "New Version number : " $newVersion
    return $newVersion
}

Write-Host "Manifest file : " $manifestFilePath
Write-Host "Node to update : " $nodeToUpdate
if ($isVersion -eq "true") {
    Write-Host "Version part to update : " $versionPart    
}
else {
    Write-Host "Value to update : " $valueToUpdate    
}

$xml= [XML] (Get-Content $manifestFilePath)
$nodes = $xml.SelectNodes($nodeToUpdate)

Write-Host "No of matching nodes in manifest file : " $nodes.Count

Write-Host "Node values before update : "
foreach($node in $nodes){
    Write-Host $node.InnerText
    if ($isVersion -eq "true") {
        $currentVersion = [version]$node.InnerText
        $node.InnerText = Update-Version -version $currentVersion -partToIncrement $versionPart
    }
    else {
        $node.InnerText = $valueToUpdate
    }
}

$xml.Save($manifestFilePath)
Write-Host "Manifest file updated and saved."

Write-Host "Node values after update : "
foreach($node in $nodes){
    Write-Host $node.InnerText
}