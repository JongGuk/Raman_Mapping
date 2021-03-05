import tkinter as tk
from pandas import DataFrame
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

data = {'Raman Shift': [-464, -460, -455, -450, -445], 
         'Intensity1': [745, 752, 746, 740, 750], 'Intensity2': [734, 745, 768, 763, 755]
        } # 데이터 짤라온것 받아오기

df = DataFrame(data) # data 로부터 데이터 프레임 만듦
df.set_index('Raman Shift', inplace=True) # 만들어진 데이터 프레임 중, Raman_Shift 항목을 x 축으로 지정

root= tk.Tk() # tkinter 로 창 띄우기

figure = plt.Figure(figsize=(5,4), dpi=100) # 그래프 띄울 창 사이즈
ax = figure.add_subplot(111) # 그래프 plot 및 x,y축 범위 조절 (범위 지정 생략하면 auto)
ax.set_title('Raman spectrum at selected point')

line = FigureCanvasTkAgg(figure, root) # Figure 그려서 root에 표시 
line.get_tk_widget().pack() # pack 에서 그래프를 좌측정렬/채우기 등 설정

#df.plot(~~~) # df.행이름 으로 특정 행 선택 가능
df.Intensity2.plot(kind='line', ax=ax, color='r', marker='o', fontsize=10)

root.mainloop() #새로고침 

