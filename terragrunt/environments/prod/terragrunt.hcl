include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../src"
}

inputs = {
    env = "prod"
    project = "yuyatinnefeld-prod"
    vpc_network_name = "main-network-prod"
}