import tensorflow as tf
import torch


def main():
    # check gpu ready
    print(f"tensorflow gpu: {tf.test.is_gpu_available()}")
    print(f"pytorch cuda: {torch.cuda.is_available()}")
    tensor = tf.constant([[1.0, 2.0], [3.0, 4.0]])
    print(f"tensor: {tensor}")


if __name__ == "__main__":
    main()
