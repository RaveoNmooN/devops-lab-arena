# Function to securely prompt for a password
function Get-SecurePrompt($promptMessage) {
    $secureString = Read-Host -Prompt $promptMessage -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
    return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
}
# Prompt for Kubernetes context
$context = Read-Host "Enter Kubernetes Cluster context name"

# Switch to the provided context
kubectl config use-context $context

# Prompt for unseal option
$unsealOption = Read-Host "Enter 'O' to unseal one pod or 'M' to unseal multiple pods"

if ($unsealOption -eq 'O') {
    # Prompt for pod name, namespace, and unseal keys
    $namespace = Read-Host "Enter Namespace"
    $podName = Read-Host "Enter Pod Name"
    $unsealKey1 = Get-SecurePrompt "Enter Unseal Key 1"
    $unsealKey2 = Get-SecurePrompt "Enter Unseal Key 2"
    $unsealKey3 = Get-SecurePrompt "Enter Unseal Key 3"

    # Run kubectl commands with pod name, namespace, unseal keys
    kubectl exec -n $namespace $podName -- vault operator unseal  $unsealKey1
    kubectl exec -n $namespace $podName -- vault operator unseal  $unsealKey2
    kubectl exec -n $namespace $podName -- vault operator unseal  $unsealKey3
}
elseif ($unsealOption -eq 'M') {
    # Prompt for multiple pod names, namespace, and unseal keys
    $namespace = Read-Host "Enter Namespace"
    $podNames = Read-Host "Enter Pod Names (separated by space)"
    $unsealKey1 = Get-SecurePrompt "Enter Unseal Key 1"
    $unsealKey2 = Get-SecurePrompt "Enter Unseal Key 2"
    $unsealKey2 = Get-SecurePrompt "Enter Unseal Key 2"
    $unsealKey3 = Get-SecurePrompt "Enter Unseal Key 3"

    # Split the pod names by space
    $podNamesArray = $podNames -split ' '

    # Run kubectl commands with each pod name, namespace, unseal keys
    foreach ($podName in $podNamesArray) {
        kubectl exec -n $namespace $podName -- vault operator unseal  $unsealKey1 
        Start-Sleep -Seconds 1  # Add a delay of 1 second between each command
        kubectl exec -n $namespace $podName -- vault operator unseal  $unsealKey2
        Start-Sleep -Seconds 1  # Add a delay of 1 second between each command
        kubectl exec -n $namespace $podName -- vault operator unseal  $unsealKey3
        Start-Sleep -Seconds 1  # Add a delay of 1 second between each command
    }
}
else {
    Write-Host "Invalid option selected"
}
