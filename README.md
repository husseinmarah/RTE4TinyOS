## Round-trip Engineering for TinyOS applications (RTE4TinyOS)
This repository contains the project folders for the roundtrip engineering for TinyOS applications.
The folder **dsml4tinyos** is for the forward engineering framework. DSML4TinyOS has four main parts: the metamodel, the Acceleo generation engine and the Sirius graphical editor.
Eclipse Oxygen3 was used to develop this environment.

Steps for using DSML4TinyOS:
1. Extract the `tinyos.metamodel.zip`
1. Import the project to the Eclipse.
1. Run the project with `Run Configuration -> Eclipse Application` and import the extracted folder from `tinyos.sirius.zip` in the new Eclipse window with the Sirius perspective. Then, you can create a project for modeling the TinyOS application. 
1. You can use Acceleo code generation provided in the project by running `Run Configuration -> Acceleo Application `, providing your modeled TinyOS application, and then generating the code for that application.

The folder **re4tinyos** contains the reverse engineering tool files.
Eclipse Luna Release (4.4.0) was used to develop the RE4TinyOS environment.

Stpes to use the RE4TinyOS:
1. You can run the `run.jar` directly, read TinyOS applications as input, and then get the parsed models for those applications.
1. The folder `project.zip` contains the source code and includes the required dependencies (Antlr4.7.2, Antlr4.4, xml-apis)

The **example** folder contains all the artefacts and original codes for the applications used to evaluate the approach.

For citation and reading the research, it's possible to access the article from this link:
https://www.sciencedirect.com/science/article/pii/S2590118421000307

    @article{marah2021model,
      title={Model-driven round-trip engineering for TinyOS-based WSN applications},
      author={Marah, Hussein and Kardas, Geylani and Challenger, Moharram},
      journal={Journal of Computer Languages},
      volume={65},
      pages={101051},
      issn = {2590-1184},
      doi = {https://doi.org/10.1016/j.cola.2021.101051},
      year={2021},
      publisher={Elsevier}
    }
