# firebase_explorer

Flutter plugin used to explore a Firebase Storage bucket as if it was a classic folder and files system.  
<br>
To make it work, you need to clone the package on your system or link the git, and **HAVE TO USE RIVERPOD** in your app (with a ScopeProvider at the root of your widget tree).  
Then you can import the *FirebaseExplorer* widget and pass it your *FirebaseStorage* instance. 

## What is left to do

- First, I need to keep cleaning the code.
- Secondly, there is a problem in the state handling as you first have to interract with the ui in order to make the files and folder appears for the first time.
- Thirdly, I have to remove the flickering.

For now, the main features are there, its just some QOL and visuals ameliorations left to do.