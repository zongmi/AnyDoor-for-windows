Set-Location $PSScriptRoot

$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1

if (!(Test-Path -Path "venv")) {
    Write-Output  "Creating venv for python..."
    python -m venv venv
}
.\venv\Scripts\activate

python -m pip install pip==23.0.1

pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 --extra-index-url https://download.pytorch.org/whl/cu118

pip install --no-deps xformers==0.0.22

Write-Output "Installing deps..."

pip install setuptools==66.0.0

$SOURCEFILE="scripts/util.py"

$TARGETFILE="venv/Lib/site-packages/setuptools/_distutils/util.py"

Copy-Item -Path $SOURCEFILE -Destination $TARGETFILE -Force

pip install share==1.0.4

pip install -r requirements-windows.txt

pip install git+https://github.com/cocodataset/panopticapi.git

pip install pycocotools

pip install lvis

Write-Output "Checking models..."

if (!(Test-Path -Path "path")) {
    Write-Output  "Creating pretrained_models..."
    mkdir "path"
}

git lfs install
git lfs clone https://huggingface.co/bdsqlsz/AnyDoor-Pruned ./path

if (Test-Path -Path "path/.git/lfs") {
    Remove-Item -Path path/.git/lfs/* -Recurse -Force
}

Set-Location .\path

Write-Output "Downloading dinoV2 models..."
Write-Output "from https://dl.fbaipublicfiles.com/dinov2/dinov2_vitg14/dinov2_vitg14_reg4_pretrain.pth..."
Write-Output "If it downloads slowly,you can copy link then close this window for downloading manually"

wget https://dl.fbaipublicfiles.com/dinov2/dinov2_vitg14/dinov2_vitg14_reg4_pretrain.pth

Write-Output "Install completed"
Read-Host | Out-Null ;
