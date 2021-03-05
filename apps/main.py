from tkinter import *
import tkinter as tk
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from pandas import DataFrame
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

class RamanGUI:
    def __init__(self):
        self.root = Tk()
        self.root.title("Raman Mapping")

        menubar = Menu(self.root)        
        filemenu = Menu(menubar, tearoff=0)
        menubar.add_cascade(label="File", menu=filemenu)
        filemenu.add_command(label="Open", command=self.Load)
        filemenu.add_separator()
        filemenu.add_command(label="Exit", command=self.root.quit)

        self.btn = Button(self.root, text="OK")
        self.btn.pack()
        
        # plt.plot(x_values, y_values)
        # plt.show()

        self.root.config(menu=menubar)
        self.root.mainloop()

    def Load(self):
        filename = tk.filedialog.askopenfilename(initialdir="/", title="Selecte raw file") # tkinter 로 파일 불러오기
        print(filename)
        data = pd.read_csv(filename) # pandas 로 csv 파일을 읽어옴
        print(data)
        df = DataFrame(data) # 불러온 data 을 데이터프레임 형식으로 만듦
        df1=df.iloc[[60],3:1027] # 만든 데이터프레임 중 60번째 행 전체 스펙트럼 (3~1027)을 자름
        print(df1)
        df1T=df1.T # Transpose
        
        root= tk.Tk() # tkinter 로 새 창 띄우기

        # Graph 1
        figure1 = plt.Figure(figsize=(5,4), dpi=100) # 그래프 띄울 창 사이즈
        ax1 = figure1.add_subplot(111) # 그래프 plot 및 x,y축 범위 조절 (범위 지정 생략하면 auto)
        ax1.set_title('Raman spectrum at selected point')

        line = FigureCanvasTkAgg(figure1, root) # Figure1 그려서 root에 표시 
        line.get_tk_widget().pack(side=tk.LEFT, fill=tk.BOTH) # tkinter 설정에서 그래프를 어떻게 표시할 지 (좌측정렬/채우기 등, pack

        df1T.plot(kind='line', ax=ax, color='r', marker='*', fontsize=10)
        
        # Graph 2
        Rdf1T=df1T['533.1':'533.7']
        figure2 = plt.Figure(figsize=(5,4), dpi=100)
        ax2 = figure2.add_subplot(111)
        ax2.set_title('Specific Range (533.1 ~ 533.7)')

        line2 = FigureCanvasTkAgg(figure2, root) # Figure2 그려서 root에 표시 
        line2.get_tk_widget().pack(side=tk.LEFT, fill=tk.BOTH)

        Rdf1T.plot(kind='line', ax=ax2, color='b', marker='o', fontsize=10)

        root.mainloop() #새로고침 

    # def Sel_pt(self):

# Load()