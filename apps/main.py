from tkinter import *
from tkinter import filedialog
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
        filename = filedialog.askopenfilename(initialdir="/", title="Selecte raw file")
        print(filename)
        data = pd.read_csv(filename)
        print(data)
        df = DataFrame(data) # data 로부터 데이터 프레임 만듦
        df1=df.iloc[[60],3:1027]
        print(df1)
        df1T=df1.T
        
        root= tk.Tk() # tkinter 로 창 띄우기

        figure1 = plt.Figure(figsize=(5,6), dpi=100) # 그래프 띄울 창 사이즈
        ax = figure1.add_subplot(111) # 그래프 plot 및 x,y축 범위 조절 (범위 지정 생략하면 auto)
        ax.set_title('Raman spectrum at selected point')

        line = FigureCanvasTkAgg(figure1, root) # Figure 그려서 root에 표시 
        line.get_tk_widget().pack(side=tk.LEFT, fill=tk.BOTH) # pack 에서 그래프를 좌측정렬/채우기 등 설정

        #df.plot(~~~) # df.행이름 으로 특정 행 선택 가능
        df1T.plot(kind='line', ax=ax, color='r', marker='*', fontsize=10)
        
        Rdf1T=df1T['533.1':'533.7']
        
        figure2 = plt.Figure(figsize=(5,6), dpi=100) # 그래프 띄울 창 사이즈
        ax2 = figure2.add_subplot(111)

        line = FigureCanvasTkAgg(figure2, root) # Figure 그려서 root에 표시 
        line.get_tk_widget().pack(side=tk.LEFT, fill=tk.BOTH) # pack 에서 그래프를 좌측정렬/채우기 등 설정

        Rdf1T.plot(kind='line', ax=ax2, color='b', marker='o', fontsize=10)




        root.mainloop() #새로고침 


    # def Sel_pt(self):

# Load()

RamanGUI()