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
        data = open(filename,'rt')
        self.text.delete('1.0', END)
        self.text.insert(END,data.read())

# Load()

RamanGUI()