GPU_ARG=""
NAME_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in 
    --gpus|-g)
      if [[ -z "$2" ]]; then
        echo "Error: --gpu requires a value." >&2
        exit 1
      fi
      if [[ "$2" == "all" ]]; then
        GPU_ARG="--gpus all"
        shift 2
        continue
      fi
      GPU_ARG="--gpus \"device=$2\""
      shift 2
      ;;
    --name|-n)
      if [[ -z "$2" ]]; then
        echo "Error: --name requires a value." >&2
        exit 1
      fi
      NAME_ARG="--name $2"
      shift 2
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      exit 1
      ;;
  esac
done

echo "GPU_ARG: $GPU_ARG"

docker run -it \
  $GPU_ARG \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  --shm-size 32G \
  -e TZ=Asia/Tokyo \
  -w /workspace \
  -v "$(pwd)":/workspace \
  $NAME_ARG \
  pytorch_tutorial

