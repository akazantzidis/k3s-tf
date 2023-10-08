resource "random_shuffle" "random_node" {
  input        = var.proxmox_nodes
  seed         = "IldlVWvExoWk4Xx7GlFL8T9XDR6JyolGX2DpAWaDPvt8f1eh5vHeYZGkflDeShi2aKOAO29mSo54dhl2mYUVKO2BDtAdNRfR4WfH"
  result_count = 100
}
