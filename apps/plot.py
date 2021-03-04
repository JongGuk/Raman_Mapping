import tkinter as tk
from pandas import DataFrame
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

data = {'Raman_Shift': [-464, -460, -455, -450, -445], 
         'Intensity1': [745, 752, 746, 740, 750], 'Intensity2': [734, 745, 768, 763, 755]
        } # 데이터 짤라온것 받아오기

df = DataFrame(data, columns=['Raman_Shift','Intensity1','Intensity2'])#, index='Raman_Shift') # 
df.set_index('Raman_Shift', inplace=True)

root= tk.Tk() # tkinter 로 띄우기

figure = plt.Figure(figsize=(5,4), dpi=100) # 그래프 띄울 창 사이즈
ax = figure.add_subplot(111) # 그래프 plot + x,y축 범위 조절

line = FigureCanvasTkAgg(figure, root) # Figure 그려서 root에 표시 
line.get_tk_widget().pack() # pack 에서 그래프를 좌측정렬/채우기 등 설정

#df = df[['Intensity1','Intensity2']]
# df = df['Intensity']
# df.plt(x="Raman_Shift", y="Intensity", kind="line", color="r", marker="o", fontsize=10)
df.plot(kind='line', ax=ax, color='r', marker='o', fontsize=10)
#df.plot.line()

#ax.set_title('Year Vs. Unemployment Rate')

root.mainloop() # 새로고침 

