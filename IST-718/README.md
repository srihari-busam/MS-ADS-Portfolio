# IST 718: Big Data Analytics

# hpa-deep-learning

This project is about detecting single cells from HPA kaggle competition

## Folder structure
```
├── 12-class-file-details.ipynb                 # Contains train, test, validation sample details
├── IST-718-Project.pptx                        # Project PPT presentation
├── README.md                                   # About the folder (this file)
├── extract-single-images-from-samples.ipynb    # jupytenr notebook about extraction of single cell from image having multiple cells
├── model-based-on-effnetb6.ipynb               # Jupyter notebook about image classification using effnet-b6
├── model-based-on-resnet.ipynb                 # Jupyter notebook about image classification using resnet
├── model-based-on-vgg16.ipynb                  # Jupyter notebook about image classification using VGG16
├── pre-process-non-image-eda.ipynb             # Jupyter notebook about preprocessing the data EDA details
└── sripada_busam_week7projectheckin.docx       # Project check-in document
```

`Note: Image data used is omitted due to size (about ~150GB). Please refer the kaggle directly for the data details`

#### References
* Kaggle competion : [here](https://www.kaggle.com/c/hpa-single-cell-image-classification)
* Cell segmentation is taken from [here](https://github.com/CellProfiling/HPA-Cell-Segmentation)

## Technology
* Extraction is using pytorch while the modeling used tensorflow 2.4
