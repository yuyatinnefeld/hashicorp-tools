resource "google_bigquery_dataset" "dataset_list" {
  for_each = {
    "hist_table"       = "This dataset contains the history of tables that passed the data validation successfully."
    "latest_table"     = "This dataset contains the latest dataset of tables that passed the data validation successfully."
    "metadata_table"   = "This dataset contains the metadata of tables that passed the data validation successfully."
  }

  dataset_id    = "${each.key}"
  friendly_name = "${each.key}"
  description   = "${each.value}"
  location      = var.region

  labels = {
    created = "terraform"
  }
}
