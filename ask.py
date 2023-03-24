import sys
from langchain.document_loaders import DirectoryLoader, TextLoader
from langchain.indexes import VectorstoreIndexCreator

def create_index():
    loader = DirectoryLoader('./doc/', 
                             glob="**/*.txt", 
                             loader_cls=TextLoader)
    index = VectorstoreIndexCreator().from_loaders([loader])
    return index

def main(argv):
    print(argv)
    if (len(argv) > 1):
        print("Max argv are 1")
        sys.exit(1)
    index = create_index()
    print(index.query(argv[0]))

if __name__ == "__main__":
    main(sys.argv[1:])
