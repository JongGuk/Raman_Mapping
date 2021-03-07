from tkinter import *
from tkinter import filedialog
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

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

        self.text = Text(self.root)
        self.text.pack()

        self.root.config(menu=menubar)
        self.root.mainloop()

    def Load(self):
        filename = filedialog.askopenfilename(initialdir="/", title="Selecte raw file")
        print(filename)

        data = pd.read_csv(filename) # pandas 로 csv 파일을 읽어옴
        print(data)
        df = DataFrame(data) # 불러온 data 을 데이터프레임 형식으로 만듦
        df1=df.iloc[[60],3:1027] # 만든 데이터프레임 중 60번째 행 전체 스펙트럼 (3~1027)을 자름 (60 대신 나중에 input 받을 예정)
        print(df1)
        df1T=df1.T # Transpose
        
        root= tk.Tk() # tkinter 로 새 창 띄우기
        root.title("Raman Mapping")

        # Graph 1
        figure1 = plt.Figure(figsize=(5,4), dpi=100) # 그래프 띄울 창 사이즈
        ax1 = figure1.add_subplot(111) # 그래프 plot 및 x,y축 범위 조절 (범위 지정 생략하면 auto)
        ax1.set_title('Raman spectrum at selected point')

        line = FigureCanvasTkAgg(figure1, root) # Figure1 그려서 root에 표시 
        line.get_tk_widget().pack(side=tk.LEFT, fill=tk.BOTH) # tkinter 설정에서 그래프를 어떻게 표시할 지 (좌측정렬/채우기 등, pack

        df1T.plot(kind='line', ax=ax1, color='r', marker='*', fontsize=10)
        
        # Graph 2
        Rdf1T=df1T['533.1':'533.7'] # 데이터 범위 설정 (나중에 input 받을 예정)
        print(Rdf1T)

        figure2 = plt.Figure(figsize=(5,4), dpi=100)
        ax2 = figure2.add_subplot(111)
        ax2.set_title('Specific Range (533.1 ~ 533.7)')

        line2 = FigureCanvasTkAgg(figure2, root) # Figure2 그려서 root에 표시 
        line2.get_tk_widget().pack(side=tk.LEFT, fill=tk.BOTH)

        Rdf1T.plot(kind='line', ax=ax2, color='b', marker='o', fontsize=10)
        
        # Set baseline
        df1T_idx = list(df1T.index.values)
        Rdf1T_idx = list(Rdf1T.index.values)
        strpt_idx = df1T_idx.index(Rdf1T_idx[0])-3 #baseline 부분의 raman shift index(set pt의 3칸 전)
        finpt_idx = df1T_idx.index(Rdf1T_idx[-1])+3
        print(strpt_idx, finpt_idx)
        
        # cal area
        sum=Rdf1T.sum(axis=0) #baseline 빼기 필요
        print(area)


        root.mainloop() #새로고침 

# Load()

RamanGUI()