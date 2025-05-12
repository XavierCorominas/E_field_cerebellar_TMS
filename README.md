# **Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling**

## Authors:
**Vridhi Rohiraa**<sup>^</sup>, **Xavier Corominas-Teruel**<sup>^</sup>, **Salim Ouarab**, **Traian Popa**, **Cécile Gallea**<sup>#</sup>, **Antoni Valero-Cabré**<sup>#</sup> & **Martina Bracco**<sup>#</sup>

<sup>^</sup> Equal Contribution  
<sup>#</sup> Senior Authorship

Please see for more details: https://doi.org/10.1016/j.brs.2025.05.010

**Reproducibility Instructions**
This repository contains all necessary scripts to reproduce the models and results presented in the associated publication. To replicate the findings, please run the scripts in the following order:

**1. Head Models:** Generate individual head models for each subject (Head_model.m).

**2. E-Field Simulations:** Use the Figure 8 and DCC coils to perform subject-specific electric field modeling with SIMNIBS (Fig8.m, DDC_coil.m).

**3. Data Analysis – Max Peak Calculation:** E-field maximum peak identifies the maximum values from the simulations. Run separately for each simulation condition to identify the maximum electric field value across the entire brain gray matter. All subsequent analyses are normalized based on this peak value (maxpeak_m.m).

**4. Regional Analysis:** Once the simulations are done and e-field values are normalized across their relative maximum, regional analysis is conducted to explore e-field magnitude and spread. For that, the cerebellum is segmented with SUIT, and e-field data within the cerebellum and on occipital regions is analyzed (do_suit_seg.m, cer_par.m, get_roi_label.m, avg_flat_map_norm.m, avg_wholebrain_efields.m, count_threshold_50.m, data_processing_m.m, normalize_wholebrain_efields.m, occipital_normalisation_right.m).



![image](https://github.com/user-attachments/assets/40c5281c-a092-4d59-85ca-7c901cf94f42)
