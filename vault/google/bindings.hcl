# component level
resource "buckets/hello-world-test-vault-999999" {
  roles = [
    "roles/storage.objectAdmin",
    "roles/storage.legacyBucketReader",
  ]
}

# # At instance level, using self-link
# resource "https://www.googleapis.com/compute/v1/projects/my-project/zone/my-zone/instances/my-instance" {
#   roles = [
#     "roles/compute.instanceAdmin.v1"
#   ]
# }
# # At project level
# resource "//cloudresourcemanager.googleapis.com/projects/my-project" {
#   roles = [
#     "roles/compute.instanceAdmin.v1",
#     "roles/iam.serviceAccountUser",  # required if managing instances that run as service accounts
#   ]
# }