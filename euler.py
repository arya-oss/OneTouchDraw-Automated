import sys
from math import sqrt
st = sys.argv[1]
V = int(sqrt(len(st)))
g = [[0 for i in range(V)] for j in range(V)]
for i in range(len(st)):
	if st[i] != '0':
		g[int(i/V)][i%V] = int(st[i])

cnt_odd_degree = 0
index = -1
degree = [0 for i in range(V)]

for i in range(V):
	cnt = 0
	for j in range(V):
		if g[i][j] != 0:
			cnt += g[i][j]
	degree[i] = cnt
	if cnt % 2 == 1:
		cnt_odd_degree += 1
		index = i
		
# print degree
if cnt_odd_degree != 0 and cnt_odd_degree != 2:
	print 'error'
else:
	stack = []
	if cnt_odd_degree == 0:
		stack.append(0)
	else:
		stack.append(index)
	path = []
	while len(stack) != 0:
		top = stack.pop()
		if degree[top] == 0:
			path.append(top)
		else:
			stack.append(top)
			for x in range(V):
				if g[top][x] != 0:
					break
			g[top][x] -= 1
			g[x][top] -= 1
			degree[top] -= 1
			degree[x] -= 1
			stack.append(x)
	st = ''
	for p in path:
		st += str(p)+' '

	print st.strip();
