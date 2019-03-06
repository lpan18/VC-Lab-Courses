import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import torch.optim as optim
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import matplotlib.pyplot as plt
import time

# Load MNIST
batch_size=60
trainset = torchvision.datasets.MNIST(root='./data', train=True, download=True, transform = transforms.Compose([transforms.ToTensor()]))
trainloader = torch.utils.data.DataLoader(trainset, batch_size=batch_size, shuffle=True, num_workers=0)


# Define block
class BasicBlock(nn.Module):
	def __init__(self, channel_num):
		super(BasicBlock, self).__init__()
		
		#TODO: 3x3 convolution -> relu
		#the input and output channel number is channel_num
		self.conv1 = nn.Conv2d(channel_num, channel_num, kernel_size = 3, stride = 1, padding = 1)
		self.bn1 = nn.BatchNorm2d(channel_num)
		self.relu1 = nn.ReLU(inplace=True)
		self.conv2 = nn.Conv2d(channel_num, channel_num, kernel_size = 3, stride = 1, padding = 1)
		self.bn2 = nn.BatchNorm2d(channel_num)
		self.relu2 = nn.ReLU(inplace=True)

	def forward(self, x):
		
		#TODO: forward
		residual = x
		x = self.conv1(x)
		x = self.bn1(x)
		x = self.relu1(x)
		x = self.conv2(x)
		x = self.bn2(x)
		x += residual
		out = self.relu2(x)
		return out


# Define network
class Net100(nn.Module):
	def __init__(self):
		super(Net100, self).__init__()
		channel_num = 16
		
		#TODO: 1x1 convolution -> relu (to convert feature channel number)
		self.conv1 = nn.Conv2d(1, channel_num, 1)
		self.relu1 = nn.ReLU(inplace=True)

		#TODO: stack 100 BasicBlocks
		self.layers = nn.ModuleList([BasicBlock(channel_num) for _ in range(100)])

		#TODO: 1x1 convolution -> sigmoid (to convert feature channel number)
		self.conv2 = nn.Conv2d(channel_num, 1, 1)
		self.sigmoid = nn.Sigmoid()

	def forward(self, x):		
		#TODO: forward
		x = self.conv1(x)
		x = self.relu1(x)
		for i in range(100):
			x = self.layers[i](x)
		x = self.conv2(x)
		out = self.sigmoid(x)
		return out

# Use cuda
network = Net100().cuda()

# Optimizer
optimizer = optim.Adam(network.parameters(), lr = 0.001)

network.train()
time_start = time.time()
for epoch in range(1):
	for i, data in enumerate(trainloader, 0):
		img, label = data
		input_save = img
		if(i % 2==0):
		    img = 1-img
		img = img.cuda()
		optimizer.zero_grad()

		# forward, backward, optimize
		recon = network(img)
		loss_net = torch.mean((recon-img) ** 2)
		#loss_net = torch.mean(torch.abs(recon-img))
		loss_net.backward()
		optimizer.step()

		# show results
		input = input_save.cpu().data[0,0,:,:]
		output = recon.cpu().data[0,0,:,:]
		plt.figure("input")
		plt.imshow(input,cmap="gray")
		plt.pause(0.001)
		plt.figure("output")
		plt.imshow(output,cmap="gray")
		plt.pause(0.001)
		print('[%d/%d, %d/%d] loss: %.5f, time: %.5f' % (epoch, 1, i, int(len(trainset)/batch_size), loss_net.data, time.time()-time_start))


