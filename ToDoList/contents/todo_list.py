import sys
import os
from PyQt4.QtCore import *
from PyQt4.QtGui import *



f_i="TextInput"
s_i="text:"
base_path = os.path.dirname(os.path.realpath(__file__))
qml_loc = os.path.join(base_path, 'contents/ui/main.qml')
txt_loc=  os.path.join(base_path, 'contents/ui/list.txt')
class inputdialogdemo(QWidget):
   def __init__(self, parent = None):
      super(inputdialogdemo, self).__init__(parent)
		
      layout = QFormLayout()
      self.btn = QPushButton("Choose Date")
      self.btn.clicked.connect(self.getDate)
		
      self.le = QLineEdit()
      layout.addRow(self.btn)

      self.btn1 = QPushButton("Enter Time")
      self.btn1.clicked.connect(self.getTime)
		
      self.btn2 = QPushButton("Enter Task")
      self.btn2.clicked.connect(self.getTask)
      
      
      self.btn3 = QPushButton("Update To-Do List")
      self.btn3.clicked.connect(self.updateTextFile)
      
      
      self.le1 = QLineEdit()
      self.le2 = QLineEdit()
      layout.addRow(self.btn1)
      layout.addRow(self.btn2)
      
      layout.addRow(self.le,self.le1)
      layout.addRow(self.le2)
      layout.addRow(self.btn3)
      
		
      
      self.setLayout(layout)
      self.setWindowTitle("Input Dialog demo")
		
   def getDate(self):
      text, ok = QInputDialog.getText(self, 'Text Input Dialog', 'Enter Date:')
		
      if ok:
         self.le.setText(str(text))
			
   def getTime(self):
      text, ok = QInputDialog.getText(self, 'Text Input Dialog', 'Enter Time:')
		
      if ok:
         self.le1.setText(str(text))
         
   def getTask(self):
      text, ok = QInputDialog.getText(self, 'Text Input Dialog', 'Enter Task:')
		
      if ok:
         self.le2.setText(str(text))
         
   def updateList (self):
      print(qml_loc)
      #x=input()
      with open(qml_loc) as f:
	flag=False
	flag1=False
	todolist=None
	while True:
	  cl=f.readline()
	  word_list=cl.split()
	  print(word_list,"--\n")
	  i=-1
	  for word in word_list:
	    i+=1
	    if word==f_i:
	      flag=True
	      break
	    if word==s_i and flag:
	      flag1=True
	      break
	  if flag and flag1:
	    temp=word_list[i+1]
	    print("temp;" , temp,'\n')
	    temp= "text: "+temp+"\\n"+"Date: "+str(self.le.text())+" Time:"+str(self.le1.text())+" Task:"+str(self.le2.text())
	    print("tempa: " , temp,'\n')
	    f.write(temp)
	    break
	  
	  if not cl:
	    break
	print("Out of loop")


   def updateTextFile (self):
      print(qml_loc)
      temp=""
      #x=input()
      with open (txt_loc,'w') as f:
	temp= "text: "+temp+"\\n"+"Date: "+str(self.le.text())+" Time:"+str(self.le1.text())+" Task:"+str(self.le2.text())+"\n"
	f.write(temp)
	
	

	
	
def main(): 
   app = QApplication(sys.argv)
   ex = inputdialogdemo()
   ex.show()
   sys.exit(app.exec_())
	
if __name__ == '__main__':
   main()