# MLP-BASED OIT FOR FAST 3D GAUSSIAN SPLATTING

MLP-based OIT is a 3D Gaussian Splatting variant integrated in this repository for efficient training and evaluation on mip-NeRF360 scenes.

## Environment Setup

There are two ways to set up the environment:

1. Build and run with Docker (from the provided Dockerfile)
2. Set up locally with Conda using setup.sh

### Universal Step: Clone Repository

Both setup methods require the repository files, so clone first:

```bash
git clone --recurse-submodules https://github.com/WangZhican/ISCA26_3DGS_Acc.git
cd MLP-based_OIT
```

## Option 1: Docker Setup

Use this option if you want a reproducible containerized environment.

### 1) Build Docker image

From the repository root (where the Dockerfile lives):

```bash
docker build -t mlp-based-oit:cu118 .
```

### 2) Run Docker container (GPU)

Mount dataset and results directories from host to keep outputs persistent.
Replace `/path/to/data` and `/path/to/results` with the actual directories on your machine where you want to store the dataset and outputs. For example, if you want them inside the current folder, use `./examples/data` and `./examples/results`.

> Note: only single-GPU usage has been tested.

```bash
docker run --gpus 1 -it --rm \
    -v /path/to/data:/workspace/MLP-based_OIT/examples/data \
    -v /path/to/results:/workspace/MLP-based_OIT/examples/results \
    mlp-based-oit:cu118 bash
```

### 3) Download dataset and checkpoints inside container

```bash
bash docker_setup.sh
```

This downloads:
- mip-NeRF360 dataset into examples/data/360_v2
- benchmark checkpoints into examples/results/benchmark
- pretrained MLP checkpoints into examples/results/mlp_checkpoint

### 4) Run evaluation inside container

```bash
cd examples
bash benchmarks/Eval_mlp.sh
```

## Option 2: Local Setup with setup.sh

Use this option if you want to run directly on your machine with Conda.

### 1) Run setup script from repository root

```bash
source ./setup.sh
```

The script performs the following:
- installs required system packages (uses sudo when available)
- creates Conda environment mlp-based_oit (Python 3.10)
- installs PyTorch (CUDA 11.8) and required Python packages
- installs MLP-based OIT from source
- installs examples requirements
- downloads mip-NeRF360 dataset
- downloads benchmark and pretrained checkpoints from Zenodo

Important:
- Prefer source ./setup.sh.
- If you run bash ./setup.sh, setup still runs, but Conda activation will not persist in your current shell.

## Usage

### Training (optional)

Training is optional because checkpoints are downloaded during setup.

To train/fine-tune:

```bash
cd examples
bash benchmarks/Train_mlp.sh
```

Outputs are written to:
- examples/results/mlp_checkpoint_new/

Note:
- Train_mlp.sh currently has SCENE_LIST set to stump.
- Edit the scene list in the script if you want to train other scenes.

### Evaluation

```bash
cd examples
bash benchmarks/Eval_mlp.sh
```

Eval_mlp.sh checks checkpoints in this order:
1. examples/results/mlp_checkpoint_new/ (if fine-tuned checkpoints exist)
2. examples/results/mlp_checkpoint/ (downloaded pretrained checkpoints)


## Acknowledgements

This work builds on the [gsplat library](https://github.com/nerfstudio-project/gsplat) developed by the Nerfstudio team.

```bibtex
@article{ye2024gsplatopensourcelibrarygaussian,
        title={gsplat: An Open-Source Library for {Gaussian} Splatting},
        author={Vickie Ye and Ruilong Li and Justin Kerr and Matias Turkulainen and Brent Yi and Zhuoyang Pan and Otto Seiskari and Jianbo Ye and Jeffrey Hu and Matthew Tancik and Angjoo Kanazawa},
        year={2024},
        eprint={2409.06765},
        journal={arXiv preprint arXiv:2409.06765},
        archivePrefix={arXiv},
        primaryClass={cs.CV},
        url={https://arxiv.org/abs/2409.06765},
}
```
