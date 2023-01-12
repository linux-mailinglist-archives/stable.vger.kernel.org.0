Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E06670ED
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 12:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjALLaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 06:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbjALL2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 06:28:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BCE192B2;
        Thu, 12 Jan 2023 03:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D3B9B81E24;
        Thu, 12 Jan 2023 11:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508FDC433F1;
        Thu, 12 Jan 2023 11:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673522440;
        bh=tAykYqqw3UxhA0dYmt8+Z0yeIYorQX7T+Qw1gBfixII=;
        h=From:To:Cc:Subject:Date:From;
        b=hv7BabGULT+Xr2c7O1P8eI8o+/0Cld+P7w9AXrPBvreemZzXcyzhCeQZKgvfrNG/r
         heXIBx7pAPJCFl0zB+8wO/31o4+lcXcjAEkJgOCk6UzYnAv3aEeXzA+COQorhhiOM8
         FoRXZ14qASWpQMxVuYZnfg7D1F8G/R26xnsKavW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.5
Date:   Thu, 12 Jan 2023 12:20:23 +0100
Message-Id: <1673522422129196@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.5 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |    2 
 arch/arm/include/asm/thread_info.h                                  |   13 
 arch/mips/ralink/of.c                                               |    2 
 arch/riscv/include/asm/uaccess.h                                    |    2 
 arch/riscv/kernel/probes/simulate-insn.h                            |    4 
 arch/x86/kernel/cpu/bugs.c                                          |    2 
 arch/x86/kernel/crash.c                                             |    4 
 block/blk-merge.c                                                   |   10 
 drivers/acpi/acpi_video.c                                           |   17 
 drivers/block/ublk_drv.c                                            |    3 
 drivers/block/virtio_blk.c                                          |   33 -
 drivers/char/tpm/tpm-interface.c                                    |    4 
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c                 |    3 
 drivers/firmware/efi/efi.c                                          |    4 
 drivers/firmware/efi/libstub/efistub.h                              |    2 
 drivers/firmware/efi/libstub/random.c                               |   42 +
 drivers/gpio/gpio-pca953x.c                                         |    3 
 drivers/gpio/gpio-sifive.c                                          |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                 |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h                          |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                    |   39 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                             |   27 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                          |   19 
 drivers/gpu/drm/amd/amdkfd/kfd_process.c                            |   24 
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c                           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   16 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c      |   39 +
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c |   69 ++
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h |   18 
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h               |    2 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c                        |   94 +++
 drivers/gpu/drm/i915/gvt/debugfs.c                                  |   17 
 drivers/gpu/drm/i915/gvt/gtt.c                                      |   17 
 drivers/gpu/drm/i915/gvt/scheduler.c                                |    1 
 drivers/gpu/drm/i915/i915_irq.c                                     |    3 
 drivers/gpu/drm/i915/i915_reg.h                                     |    1 
 drivers/gpu/drm/imx/ipuv3-plane.c                                   |   14 
 drivers/gpu/drm/meson/meson_viu.c                                   |    5 
 drivers/gpu/drm/panfrost/panfrost_drv.c                             |   27 -
 drivers/gpu/drm/panfrost/panfrost_gem.c                             |   16 
 drivers/gpu/drm/panfrost/panfrost_gem.h                             |    5 
 drivers/gpu/drm/virtio/virtgpu_object.c                             |    6 
 drivers/infiniband/hw/mlx5/counters.c                               |    6 
 drivers/infiniband/hw/mlx5/qp.c                                     |   49 +
 drivers/net/bonding/bond_3ad.c                                      |    1 
 drivers/net/bonding/bond_main.c                                     |    8 
 drivers/net/dsa/mv88e6xxx/Kconfig                                   |    4 
 drivers/net/dsa/qca/qca8k-8xxx.c                                    |  106 +---
 drivers/net/dsa/qca/qca8k.h                                         |    5 
 drivers/net/ethernet/amazon/ena/ena_com.c                           |   29 -
 drivers/net/ethernet/amazon/ena/ena_ethtool.c                       |    6 
 drivers/net/ethernet/amazon/ena/ena_netdev.c                        |   83 ++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h                        |   17 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                            |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c                            |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                           |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |   22 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                           |   15 
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c                       |   20 
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h                       |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                     |   10 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |  132 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h             |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c              |   71 ++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c           |    3 
 drivers/net/ethernet/intel/ice/ice_xsk.c                            |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c            |   30 -
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c                   |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c            |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c                  |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c           |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c          |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c       |    7 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   33 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                   |   30 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h                   |    6 
 drivers/net/ethernet/mellanox/mlx5/core/health.c                    |    6 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c               |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c                   |    1 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                      |    4 
 drivers/net/ethernet/microchip/lan966x/lan966x_port.c               |    2 
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c                 |    2 
 drivers/net/ethernet/qlogic/qed/qed_debug.c                         |   28 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c               |    8 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                     |   10 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                    |    8 
 drivers/net/phy/xilinx_gmii2rgmii.c                                 |    1 
 drivers/net/usb/rndis_host.c                                        |    3 
 drivers/net/veth.c                                                  |    5 
 drivers/net/vmxnet3/vmxnet3_drv.c                                   |    8 
 drivers/net/vrf.c                                                   |    6 
 drivers/net/vxlan/vxlan_core.c                                      |   19 
 drivers/net/wireless/ath/ath11k/qmi.c                               |    3 
 drivers/net/wireless/ath/ath9k/htc.h                                |   14 
 drivers/nvme/host/core.c                                            |   32 -
 drivers/nvme/host/nvme.h                                            |    2 
 drivers/nvme/target/admin-cmd.c                                     |   35 -
 drivers/of/fdt.c                                                    |    6 
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c                           |   20 
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c      |    4 
 drivers/usb/dwc3/dwc3-xilinx.c                                      |    1 
 drivers/usb/dwc3/gadget.c                                           |    5 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                   |   10 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                    |    7 
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c                                |    4 
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c                                |    4 
 drivers/vdpa/virtio_pci/vp_vdpa.c                                   |    2 
 drivers/vhost/vdpa.c                                                |   52 +
 drivers/vhost/vhost.c                                               |    4 
 drivers/vhost/vringh.c                                              |    5 
 drivers/vhost/vsock.c                                               |    9 
 drivers/video/fbdev/matrox/matroxfb_base.c                          |    4 
 fs/btrfs/disk-io.c                                                  |    8 
 fs/btrfs/disk-io.h                                                  |    2 
 fs/btrfs/extent-io-tree.c                                           |    2 
 fs/btrfs/extent_io.c                                                |   11 
 fs/btrfs/file.c                                                     |    2 
 fs/btrfs/ioctl.c                                                    |    9 
 fs/btrfs/rcu-string.h                                               |    6 
 fs/btrfs/super.c                                                    |    2 
 fs/btrfs/tree-defrag.c                                              |    6 
 fs/ceph/caps.c                                                      |    2 
 fs/ceph/locks.c                                                     |    4 
 fs/ceph/super.h                                                     |    1 
 fs/cifs/sess.c                                                      |    3 
 fs/cifs/smb2ops.c                                                   |    3 
 fs/hfs/inode.c                                                      |   15 
 fs/ksmbd/auth.c                                                     |    3 
 fs/ksmbd/connection.c                                               |    7 
 fs/ksmbd/smb2pdu.c                                                  |    7 
 fs/ksmbd/transport_tcp.c                                            |    5 
 fs/locks.c                                                          |   23 
 fs/nfsd/nfs4xdr.c                                                   |   11 
 fs/nfsd/nfssvc.c                                                    |    2 
 fs/ntfs3/file.c                                                     |    4 
 fs/udf/inode.c                                                      |    2 
 include/acpi/video.h                                                |    2 
 include/drm/drm_plane_helper.h                                      |    1 
 include/linux/dsa/tag_qca.h                                         |    4 
 include/linux/efi.h                                                 |    2 
 include/linux/fs.h                                                  |    6 
 include/linux/mlx5/device.h                                         |    5 
 include/linux/mlx5/mlx5_ifc.h                                       |    3 
 include/linux/netfilter/ipset/ip_set.h                              |    2 
 include/linux/sunrpc/rpc_pipe_fs.h                                  |    5 
 include/net/inet_hashtables.h                                       |    4 
 include/net/inet_timewait_sock.h                                    |    5 
 include/net/netfilter/nf_tables.h                                   |   25 
 io_uring/cancel.c                                                   |    9 
 io_uring/io_uring.c                                                 |   19 
 kernel/bpf/trampoline.c                                             |    4 
 kernel/bpf/verifier.c                                               |   12 
 lib/kunit/string-stream.c                                           |    4 
 net/9p/client.c                                                     |   15 
 net/9p/trans_fd.c                                                   |   12 
 net/9p/trans_rdma.c                                                 |    4 
 net/9p/trans_virtio.c                                               |    9 
 net/9p/trans_xen.c                                                  |    4 
 net/caif/cfctrl.c                                                   |    6 
 net/core/filter.c                                                   |    7 
 net/ipv4/inet_connection_sock.c                                     |   40 +
 net/ipv4/inet_hashtables.c                                          |    8 
 net/ipv4/inet_timewait_sock.c                                       |   31 +
 net/ipv4/tcp_ulp.c                                                  |    4 
 net/mptcp/protocol.c                                                |   20 
 net/mptcp/protocol.h                                                |    4 
 net/mptcp/subflow.c                                                 |   19 
 net/netfilter/ipset/ip_set_core.c                                   |    7 
 net/netfilter/ipset/ip_set_hash_ip.c                                |   14 
 net/netfilter/ipset/ip_set_hash_ipmark.c                            |   13 
 net/netfilter/ipset/ip_set_hash_ipport.c                            |   13 
 net/netfilter/ipset/ip_set_hash_ipportip.c                          |   13 
 net/netfilter/ipset/ip_set_hash_ipportnet.c                         |   13 
 net/netfilter/ipset/ip_set_hash_net.c                               |   17 
 net/netfilter/ipset/ip_set_hash_netiface.c                          |   15 
 net/netfilter/ipset/ip_set_hash_netnet.c                            |   23 
 net/netfilter/ipset/ip_set_hash_netport.c                           |   19 
 net/netfilter/ipset/ip_set_hash_netportnet.c                        |   40 -
 net/netfilter/nf_tables_api.c                                       |  261 ++++++----
 net/nfc/netlink.c                                                   |   52 +
 net/sched/cls_tcindex.c                                             |   12 
 net/sched/sch_atm.c                                                 |    5 
 net/sched/sch_cbq.c                                                 |    4 
 net/sunrpc/auth_gss/auth_gss.c                                      |   19 
 sound/soc/intel/boards/bytcr_rt5640.c                               |   15 
 sound/soc/sof/core.c                                                |    9 
 sound/soc/sof/intel/hda-dsp.c                                       |   72 ++
 sound/soc/sof/intel/hda.h                                           |    1 
 sound/soc/sof/intel/tgl.c                                           |    2 
 sound/soc/sof/mediatek/mtk-adsp-common.c                            |    2 
 tools/perf/builtin-lock.c                                           |    2 
 tools/perf/util/bpf_counter_cgroup.c                                |   14 
 tools/perf/util/cgroup.c                                            |   23 
 tools/perf/util/data.c                                              |    2 
 tools/perf/util/dwarf-aux.c                                         |   23 
 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh            |   15 
 197 files changed, 1987 insertions(+), 875 deletions(-)

Adham Faris (1):
      net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Andreas Rammhold (1):
      of/fdt: run soc memory setup when early_init_dt_scan_memory fails

Antoine Tenart (1):
      net: vrf: determine the dst using the original ifindex for multicast

Ard Biesheuvel (1):
      efi: random: combine bootloader provided RNG seed with RNG protocol output

Arnd Bergmann (2):
      wifi: ath9k: use proper statements in conditionals
      usb: dwc3: xilinx: include linux/gpio/consumer.h

Baochen Qiang (1):
      wifi: ath11k: Send PME message during wakeup from D3cold

Ben Dooks (1):
      riscv: uaccess: fix type of 0 variable on error in get_user()

Björn Töpel (1):
      riscv, kprobes: Stricter c.jr/c.jalr decoding

Caleb Sander (1):
      qed: allow sleep in qed_mcp_trace_dump()

Carlo Caione (1):
      drm/meson: Reduce the FIFO lines held when AFBC is not used

Chris Mi (2):
      net/mlx5e: CT: Fix ct debugfs folder name
      net/mlx5e: Always clear dest encap in neigh-update-del

Christian Marangi (3):
      Revert "net: dsa: qca8k: cache lo and hi for mdio write"
      net: dsa: qca8k: fix wrong length value for mgmt eth packet
      net: dsa: tag_qca: fix wrong MGMT_DATA2 size

Christoph Hellwig (2):
      nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it
      nvme: also return I/O command effects from nvme_command_effects

Chuang Wang (1):
      bpf: Fix panic due to wrong pageattr of im->image

Cindy Lu (1):
      vhost_vdpa: fix the crash in unmap a large memory

Dan Carpenter (1):
      drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()

Daniil Tatianin (2):
      qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
      drivers/net/bonding/bond_3ad: return when there's no aggregator

David Arinzon (7):
      net: ena: Fix toeplitz initial hash value
      net: ena: Don't register memory info on XDP exchange
      net: ena: Account for the number of processed bytes in XDP
      net: ena: Use bitmask to indicate packet redirection
      net: ena: Fix rx_copybreak value update
      net: ena: Set default value for RX interrupt moderation
      net: ena: Update NUMA TPH hint register upon NUMA node update

Dillon Varone (1):
      drm/amd/display: Add check for DET fetch latency hiding for dcn32

Dmitry Fomichev (1):
      virtio-blk: use a helper to handle request queuing errors

Dominique Martinet (1):
      9p/client: fix data race on req->status

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Eli Cohen (3):
      vdpa/mlx5: Fix rule forwarding VLAN to TIR
      vdpa/mlx5: Fix wrong mac address deletion
      net/mlx5: Lag, fix failure to cancel delayed bond work

Eric Dumazet (1):
      bonding: fix lockdep splat in bond_miimon_commit()

Filipe Manana (1):
      btrfs: fix off-by-one in delalloc search during lseek

Geetha sowjanya (1):
      octeontx2-pf: Fix lmtst ID used in aura free

Greg Kroah-Hartman (1):
      Linux 6.1.5

Haibo Chen (1):
      gpio: pca953x: avoid to use uninitialized value pinctrl

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet

Hawkins Jiawei (1):
      net: sched: fix memory leak in tcindex_set_parms

Horatiu Vultur (2):
      net: lan966x: Fix configuration of the PCS
      net: sparx5: Fix reading of the MAC address

Ido Schimmel (1):
      vxlan: Fix memory leaks in error path

Jakub Kicinski (1):
      bpf: pull before calling skb_postpull_rcsum()

Jamal Hadi Salim (2):
      net: sched: atm: dont intepret cls results when asked to drop
      net: sched: cbq: dont intepret cls results when asked to drop

Jan Kara (1):
      udf: Fix extension of the last extent in the file

Jani Nikula (2):
      drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence
      drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index

Jason A. Donenfeld (1):
      tpm: Allow system suspend to continue when TPM suspend fails

Jason Wang (1):
      vdpasim: fix memory leak when freeing IOTLBs

Jeff Layton (3):
      nfsd: shut down the NFSv4 state objects before the filecache
      filelock: new helper: vfs_inode_has_locks
      nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Jens Axboe (4):
      ARM: renumber bits related to _TIF_WORK_MASK
      io_uring/cancel: re-grab ctx mutex after finishing wait
      io_uring: check for valid register opcode earlier
      block: don't allow splitting of a REQ_NOWAIT bio

Jian Shen (3):
      net: hns3: fix miss L3E checking for rx packet
      net: hns3: fix VF promisc mode not update when mac table full
      net: hns3: refine the handling for VF heartbeat

Jie Wang (1):
      net: hns3: add interrupts re-initialization while doing VF FLR

Jiguang Xiao (1):
      net: amd-xgbe: add missed tasklet_kill

Jiri Pirko (1):
      net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Johan Hovold (1):
      phy: qcom-qmp-combo: fix broken power on

Johnny S. Lee (1):
      net: dsa: mv88e6xxx: depend on PTP conditionally

Jozsef Kadlecsik (2):
      netfilter: ipset: fix hash:net,port,net hang with /0 subnet
      netfilter: ipset: Rework long task execution when adding/deleting entries

Kai Vehmanen (2):
      ASoC: SOF: Revert: "core: unregister clients and machine drivers in .shutdown"
      ASoC: SOF: Intel: pci-tgl: unblock S5 entry if DMA stop has failed"

Kees Cook (1):
      bpf: Always use maximal size for copy_array()

Kuniyuki Iwashima (1):
      tcp: Add TIME_WAIT sockets in bhash2.

Linus Torvalds (1):
      hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Luben Tuikov (1):
      drm/amdgpu: Fix size validation for non-exclusive domains (v4)

Ma Jun (1):
      drm/plane-helper: Add the missing declaration of drm_atomic_state

Maciej Fijalkowski (1):
      ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf

Maor Dickman (1):
      net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option

Maor Gottlieb (1):
      RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Mario Limonciello (3):
      ACPI: video: Allow GPU drivers to report no panels
      drm/amd/display: Report to ACPI video if no panels were found
      ACPI: video: Don't enable fallback path for creating ACPI backlight by default

Marios Makassikis (1):
      ksmbd: send proper error response in smb2_tree_connect()

Masami Hiramatsu (Google) (2):
      perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor
      perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data

Miaoqian Lin (4):
      nfc: Fix potential resource leaks
      net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
      gpio: sifive: Fix refcount leak in sifive_gpio_probe
      perf tools: Fix resources leak in perf_data__open_dir()

Michael Chan (4):
      bnxt_en: Simplify bnxt_xdp_buff_init()
      bnxt_en: Fix XDP RX path
      bnxt_en: Fix first buffer size calculations for XDP multi-buffer
      bnxt_en: Fix HDS and jumbo thresholds for RX packets

Michel Dänzer (1):
      Revert "drm/amd/display: Enable Freesync Video Mode by default"

Ming Lei (1):
      ublk: honor IO_URING_F_NONBLOCK for handling control command

Moshe Shemesh (1):
      net/mlx5: E-Switch, properly handle ingress tagged packets on VST

Mukul Joshi (1):
      drm/amdkfd: Fix kernel warning during topology setup

Namhyung Kim (2):
      perf stat: Fix handling of unsupported cgroup events when using BPF counters
      perf stat: Fix handling of --for-each-cgroup with --bpf-counters to match non BPF mode

Namjae Jeon (1):
      ksmbd: fix infinite loop in ksmbd_conn_handler_loop()

Pablo Neira Ayuso (4):
      netfilter: nf_tables: consolidate set description
      netfilter: nf_tables: add function to create set stateful expressions
      netfilter: nf_tables: perform type checking for existing sets
      netfilter: nf_tables: honor set timeout and garbage collection updates

Paolo Abeni (3):
      mptcp: fix deadlock in fastopen error path
      mptcp: fix lockdep false positive
      net/ulp: prevent ULP without clone op from entering the LISTEN status

Paul Menzel (1):
      fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB

Pavel Begunkov (2):
      io_uring: pin context while queueing deferred tw
      io_uring: fix CQ waiting timeout handling

Philip Yang (2):
      drm/amdkfd: Fix kfd_process_device_init_vm error handling
      drm/amdkfd: Fix double release compute pasid

Philipp Zabel (1):
      drm/imx: ipuv3-plane: Fix overlay plane width

Po-Hsu Lin (2):
      selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
      selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier

Qu Wenruo (2):
      btrfs: fix compat_ro checks against remount
      btrfs: handle case when repair happens with dev-replace

Rafael Mendonca (1):
      virtio_blk: Fix signedness bug in virtblk_prep_rq()

Rodrigo Branco (1):
      x86/bugs: Flush IBP in ib_prctl_set()

Ronak Doshi (1):
      vmxnet3: correctly report csum_level for encapsulated packet

Rong Wang (1):
      vdpa/vp_vdpa: fix kfree a wrong pointer in vp_vdpa_remove

Samson Tam (1):
      drm/amd/display: Uninitialized variables causing 4k60 UCLK to stay at DPM1 and not DPM0

Sasha Levin (2):
      btrfs: replace strncpy() with strscpy()
      btrfs: fix an error handling path in btrfs_defrag_leaves()

Shawn Bohrer (1):
      veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Shay Drory (4):
      net/mlx5: Fix io_eq_size and event_eq_size params validation
      net/mlx5: Avoid recovery in probe flows
      net/mlx5: Fix RoCE setting at HCA level
      RDMA/mlx5: Fix mlx5_ib_get_hw_stats when used for device

Shyam Prasad N (2):
      cifs: fix interface count calculation during refresh
      cifs: refcount only the selected iface during interface update

Srinivas Pandruvada (1):
      thermal: int340x: Add missing attribute for data rate base

Stefano Garzarella (4):
      vringh: fix range used in iotlb_translate()
      vhost: fix range used in translate_desc()
      vhost-vdpa: fix an iotlb memory leak
      vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Steven Price (1):
      drm/panfrost: Fix GEM handle creation ref-counting

Szymon Heidrich (1):
      usb: rndis_host: Secure rndis_query check against int overflow

Takashi Iwai (1):
      x86/kexec: Fix double-free of elf header buffer

Tariq Toukan (1):
      net/mlx5e: Fix RX reporter for XSK RQs

Tetsuo Handa (1):
      fs/ntfs3: don't hold ni_lock when calling truncate_setsize()

Thinh Nguyen (1):
      usb: dwc3: gadget: Ignore End Transfer delay on teardown

Thomas Richter (1):
      perf lock contention: Fix core dump related to not finding the "__sched_text_end" symbol on s/390

Wei Yongjun (1):
      virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()

William Liu (1):
      ksmbd: check nt_len to be at least CIFS_ENCPWD_SIZE in ksmbd_decode_ntlmssp_auth_blob

Xiu Jianfeng (1):
      drm/virtio: Fix memory leak in virtio_gpu_object_create()

Xiubo Li (1):
      ceph: switch to vfs_inode_has_locks() to fix file lock bug

YC Hung (1):
      ASoC: SOF: mediatek: initialize panic_info to zero

Yanjun Zhang (1):
      nvme: fix multipath crash caused by flush request when blktrace is enabled

YoungJun.park (1):
      kunit: alloc_string_stream_fragment error handling bug fix

Yuan Can (1):
      vhost/vsock: Fix error handling in vhost_vsock_init()

Zheng Wang (1):
      drm/i915/gvt: fix double free bug in split_2MB_gtt_entry

Zhengchao Shao (1):
      caif: fix memory leak in cfctrl_linkup_request()

Zhenyu Wang (2):
      drm/i915/gvt: fix gvt debugfs destroy
      drm/i915/gvt: fix vgpu debugfs clean in remove

minoura makoto (1):
      SUNRPC: ensure the matching upcall is in-flight upon downcall

ruanjinjie (1):
      vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

