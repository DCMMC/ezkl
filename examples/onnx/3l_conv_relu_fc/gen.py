from torch import nn
from ezkl import export

class MyModel(nn.Module):
    def __init__(self):
        super(MyModel, self).__init__()

        self.conv1 = nn.Conv2d(in_channels=1, out_channels=2, kernel_size=5, stride=2)
        self.relu = nn.ReLU()

        self.d2 = nn.Linear(288, 10)

    def forward(self, x):
        # 32x1x28x28 => 32x32x26x26
        x = self.conv1(x)
        x = self.relu(x)
        x = x.flatten(start_dim = 1)
        logits = self.d2(x)
       
        return logits

circuit = MyModel()
export(circuit, input_shape = [1,28,28])


    
