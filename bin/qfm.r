#! /usr/bin/env Rscript

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ANTsRCore))
suppressPackageStartupMessages(library(imager))
suppressPackageStartupMessages(library(cowplot))
suppressPackageStartupMessages(library(reshape2))

# default theme: theme_cowplot
# theme_get()$legend.title$size
theme_update(
  plot.title = element_text(size = 16, face = "plain", colour = "black"),
  plot.caption = element_text(hjust = 0.5, size = 16, face = "plain"),
  legend.title = element_text(size = 11),
  legend.text = element_text(size = 11)
  # plot.title = element_text(size = rel(1.0), colour = utah_crimson),
  # plot.subtitle = element_text(colour = utah_crimson),
  # plot.caption = element_text(colour = utah_crimson),
  # legend.title = element_text(size = 12),
  # legend.text = element_text(size = 12),
  # axis.title.x = element_blank(),
  # axis.text.x = element_blank(),
  # axis.ticks.x = element_blank()
)

# setwd("QFM")
source("R/pltr_imager.r")

image_dpi = 50

# ----

df = read_rds("badanie_miesni_uda.rds") %>%
  select(subject, z_slice, sequence, pathname) %>%
  spread(key = sequence, value = pathname) %>%
  select(subject, z_slice, in_phase, water, fat)

df104 = df %>% filter(z_slice == 104) %>% select(-z_slice)
df120 = df %>% filter(z_slice == 120) %>% select(-z_slice)

# View(df104)

# Compute slice volumes

generate_images <- function(row, z_slice, images_dir, max_si = 800, verbose = FALSE) {
  in_phase_img = antsImageRead(row$in_phase)
  dim3 = dim(in_phase_img)

  voxel_cm3 = voxel3D_volume_cm3(in_phase_img)

  in_phase_slice = extractSliceFromImage(row$in_phase, slice = z_slice)
  water_slice = extractSliceFromImage(row$water, slice = z_slice)
  fat_slice = extractSliceFromImage(row$fat, slice = z_slice)

  fat_fraction_slice = fat_slice / (water_slice + fat_slice)

  if (verbose) {
    message(
      ".. subject: ", row$subject,
      ", z_slice: ", z_slice,
      ", x×y = ", dim3[1], "×", dim3[2],
      ", voxel: ", round(voxel_cm3, 6), " cm3"
      )
  }

  tissue_slice_mask = getTissueMask(in_phase_slice)
  femur_slice_mask = getFemurMask(in_phase_slice, tissue_slice_mask)

  tissue_without_femur_slice_mask = tissue_slice_mask - femur_slice_mask
  water_slice_mask = water_slice >= fat_slice

  muscle_slice_mask = water_slice_mask * tissue_without_femur_slice_mask

  noise_tissue_boundary = get_background_tissue_boundary(
    in_phase_slice, NULL, K = 3
  )

  noise_fat_boundary = get_background_tissue_boundary(
    in_phase_slice, tissue_without_femur_slice_mask
  )

  tissue_cm3 = muscle_volume(
    tissue_without_femur_slice_mask,
    voxel3D_vol = voxel_cm3
  )

  muscle_cm3 = muscle_volume(
    muscle_slice_mask,
    voxel3D_vol = voxel_cm3
  )

  intramuscular_cm3 = intramuscular_fat_volume(
    fat_fraction_slice,
    muscle_slice_mask,
    voxel3D_vol = voxel_cm3
  )

  # intramuscular_fat_percent(fat_fraction_slice, muscle_slice_mask)

  tissue_caption = bquote(
    paste("tissue" == .(tissue_cm3), "cm"^3)
  )

  muscle_caption = bquote(
    paste("muscles" == .(muscle_cm3), "cm"^3)
  )

  intramuscular_caption = bquote(
    paste("intramuscular fat" == .(intramuscular_cm3), "cm"^3)
  )

  results_2d_plot = plot_grid(
    make_fake_label(tissue_caption, size = 20),
    make_fake_label(muscle_caption, size = 20),
    make_fake_label(intramuscular_caption, size = 20),
    plot2D_slice(
      in_phase_slice,
      title = "in-phase",
      legend_title = "signal\nintensity"
    ),
    plot2D_slice_with_mask(
      fat_fraction_slice,
      tissue_without_femur_slice_mask,
      title = "fat-fraction in thigh",
      legend_title = "fat\nfraction"
    ),
    plot2D_ffrac_slice_with_mask(
      fat_fraction_slice,
      muscle_slice_mask,
      title = "fat-fraction in muscles",
      legend_title = "fat\nfraction"
    ) +
    scale_fill_gradient(low = "black", high = "gray50", na.value = mikado_yellow),
    plot_0D(
      in_phase_slice,
      n_voxels = 10^5,
      title = "in-phase image",
      ylim = c(0, max_si),
      yintercept = noise_tissue_boundary,
      dot_size = 0.4,
      dot_alpha = 0.3
    ),
    plot_0D_with_mask(
      fat_fraction_slice, tissue_without_femur_slice_mask,
      n_voxels = 10^5,
      title = "thigh in fat-fraction image",
      y_label = "fat fraction", ylim = c(0, 1),
      yintercept = 0.5,
      dot_size = 0.4,
      dot_alpha = 0.3
    ),
    plot_0D_with_mask(
      in_phase_slice, tissue_without_femur_slice_mask,
      n_voxels = 10^5,
      title = "thigh in in-phase image",
      ylim = c(0, max_si),
      yintercept = noise_fat_boundary,
      dot_size = 0.4,
      dot_alpha = 0.3
    ),
    rel_heights = c(0.35, 1, 1),
    ncol = 3, axis = "lr", align = "hv"
  )

  dir.create(images_dir, showWarnings = FALSE)
  out_pname = file.path(images_dir, str_glue("{row$subject}.png"))

  ggsave(
    out_pname,
    plot = results_2d_plot,
    width = 18, height = 10, dpi = image_dpi
  )
}

# purrr::transpose(head(df104, 3)) %>%
purrr::transpose(df104) %>%
  walk(
    generate_images,
    z_slice = 94,
    max_si = 400,
    images_dir = "slices_z104",
    verbose = TRUE
  )

purrr::transpose(df120) %>%
  walk(
    generate_images,
    z_slice = 110,
    max_si = 400,
    images_dir = "slices_z120",
    verbose = TRUE
  )
