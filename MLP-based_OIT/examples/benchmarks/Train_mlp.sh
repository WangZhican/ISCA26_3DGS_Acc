#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCENE_DIR="$EXAMPLES_DIR/data/360_v2"
CKPT_ROOT="$EXAMPLES_DIR/results/benchmark"

# Dedicated output root for this script.
RESULT_ROOT="$EXAMPLES_DIR/results/mlp_checkpoint_new"
TYPE="cuda"
SCENE_LIST="stump"
RENDER_TRAJ_PATH="ellipse"
GPU_ID=1
CKPT_NAME="ckpt_6999_rank0.pt"

for SCENE in $SCENE_LIST; do
    case "$SCENE" in
        bonsai|counter|kitchen|room) DATA_FACTOR=2 ;;
        *) DATA_FACTOR=4 ;;
    esac

    echo "============================================================"
    echo "Scene: $SCENE"

    # Benchmark layout is fixed as: results/benchmark/<scene>/ckpts/ckpt_6999_rank0.pt
    CKPT="$CKPT_ROOT/$SCENE/ckpts/$CKPT_NAME"
    if [ ! -f "$CKPT" ]; then
        echo "Checkpoint not found for scene=$SCENE: $CKPT, skipping."
    fi

    RESULT_DIR="$RESULT_ROOT/$SCENE"

    echo "Train from: $CKPT"
    echo "Result dir: $RESULT_DIR"

    CUDA_LAUNCH_BLOCKING=1 CUDA_VISIBLE_DEVICES=$GPU_ID python "$EXAMPLES_DIR/load_simple_trainer.py" default \
        --disable_viewer \
        --type "$TYPE" \
        --data_factor "$DATA_FACTOR" \
        --render_traj_path "$RENDER_TRAJ_PATH" \
        --data_dir "$SCENE_DIR/$SCENE/" \
        --result_dir "$RESULT_DIR" \
        --ckpt "$CKPT" \
        --train_on_ckpt
done
