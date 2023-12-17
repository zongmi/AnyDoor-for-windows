Set-Location $PSScriptRoot

$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1

if (!(Test-Path -Path "venv")) {
    Write-Output  "创建python虚拟环境venv..."
    python -m venv venv
}
.\venv\Scripts\activate

python -m pip install pip==23.0.1 -i https://mirror.baidu.com/pypi/simple

pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple

pip install --no-deps xformers==0.0.22 -i https://mirror.baidu.com/pypi/simple

Write-Output "安装依赖..."

pip install setuptools==66.0.0 -i https://mirror.baidu.com/pypi/simple

$SOURCEFILE="scripts/util.py"

$TARGETFILE="venv/Lib/site-packages/setuptools/_distutils/util.py"

Copy-Item -Path $SOURCEFILE -Destination $TARGETFILE -Force

pip install share==1.0.4 -i https://mirror.baidu.com/pypi/simple

pip install -r requirements-windows.txt -i https://mirror.baidu.com/pypi/simple

pip install git+https://github.com/cocodataset/panopticapi.git

pip install pycocotools -i https://mirror.baidu.com/pypi/simple

pip install lvis -i https://mirror.baidu.com/pypi/simple

if (!(Test-Path -Path "path")) {
    Write-Output  "创建模型文件夹..."
    mkdir "path"
}

Write-Output  "下载模型中..."

git lfs install
git lfs clone https://www.modelscope.cn/bdsqlsz/AnyDoor-Pruned.git path/

if (Test-Path -Path "path/.git/lfs") {
    Remove-Item -Path path/.git/lfs/* -Recurse -Force
}

Write-Output "安装完毕"
Read-Host | Out-Null ;
