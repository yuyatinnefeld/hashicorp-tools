include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../src"
}

inputs = {
    env = "test"
    project = "yuyatinnefeld-test"
    vpc_network_name = "main-network-test"
}