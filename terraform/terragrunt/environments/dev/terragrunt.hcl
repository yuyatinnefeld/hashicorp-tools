include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../src"
}

inputs = {
    env = "dev"
    project = "yuyatinnefeld-dev"
    vpc_network_name = "main-network-dev"
}