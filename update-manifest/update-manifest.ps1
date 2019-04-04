param(
    # Manifest file path
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [String]$manifestFilePath,
    # Node to update
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [String]$nodeToUpdate,
    # Value to update
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [String]$valueToUpdate,
    # Whether the value is Version
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$isVersion,
    # Part in version to update
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$versionPart
)

function Update-Version {
    param (
        [Version]$version, [string]$partToIncrement
    )
    # Write-Output "Current Major: $($version.Major)"
    # Write-Output "Current Minor: $($version.Minor)"
    # Write-Output "Current Build: $($version.Build)"
    # Write-Output "Current Revision: $($version.Revision)"

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

    # Write-Output $newVersion
    return $newVersion
}

Write-Output "Manifest file : $manifestFilePath"
Write-Output "Node to update : $nodeToUpdate"
if ($isVersion -eq "true") {
    Write-Output "Version part to update : $versionPart"    
}
else {
    Write-Output "Value to update : $valueToUpdate"    
}

$xml = [XML] (Get-Content $manifestFilePath)
$nodes = $xml.SelectNodes($nodeToUpdate)

Write-Output "No of matching nodes in manifest file : $($nodes.Count)"

Write-Output "Node values before update : "
foreach ($node in $nodes) {
    Write-Output $node.InnerText
    if ($isVersion -eq "true") {
        $currentVersion = [version]$node.InnerText
        $node.InnerText = Update-Version -version $currentVersion -partToIncrement $versionPart
    }
    else {
        $node.InnerText = $valueToUpdate
    }
}

$xml.Save($manifestFilePath)
Write-Output "Manifest file updated and saved."

Write-Output "Node values after update : "
foreach ($node in $nodes) {
    Write-Output $node.InnerText
}