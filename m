Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E32B9272
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 13:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgKSMPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 07:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgKSMPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 07:15:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9AE3246B0;
        Thu, 19 Nov 2020 12:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605788149;
        bh=Tgw+uoIz/8pu3lWxAiroGOU4E4+Tshlg4O/3JXt1Dig=;
        h=From:To:Cc:Subject:Date:From;
        b=Bsg/SIdlZT4XZchFrZv6AKMkB8qe1iSOE8uSRUBIMmaVzvDF1LIbynBqcRzlX+5+u
         yNaX743Rs70lzsiKtqlZj5IKHDIHSnDxqP9ZU6EvRpFUkYlzNch5QhCrauG6IaW8MM
         5jK0wxUMLH2otAqcw7rSCPQc5Kqns1GRG+1WCgkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.9
Date:   Thu, 19 Nov 2020 13:16:28 +0100
Message-Id: <1605788188121239@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.9 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/j1939.rst                               |    4 
 Makefile                                                         |    6 
 arch/arc/kernel/head.S                                           |   17 
 arch/arc/plat-hsdk/platform.c                                    |   17 
 arch/arm/include/asm/kprobes.h                                   |   22 -
 arch/arm/probes/kprobes/opt-arm.c                                |   18 
 arch/arm/vdso/Makefile                                           |    2 
 arch/arm64/kernel/kexec_image.c                                  |   41 +
 arch/arm64/kernel/machine_kexec_file.c                           |    9 
 arch/arm64/kernel/vdso/Makefile                                  |    2 
 arch/arm64/kernel/vdso32/Makefile                                |    2 
 arch/arm64/kvm/hypercalls.c                                      |    2 
 arch/arm64/kvm/mmu.c                                             |    1 
 arch/arm64/kvm/sys_regs.c                                        |   18 
 arch/arm64/mm/mmu.c                                              |   17 
 arch/mips/vdso/Makefile                                          |    2 
 arch/powerpc/kernel/eeh_cache.c                                  |    5 
 arch/powerpc/kernel/head_32.S                                    |   12 
 arch/riscv/kernel/head.S                                         |    5 
 arch/riscv/kernel/vdso/.gitignore                                |    1 
 arch/riscv/kernel/vdso/Makefile                                  |   18 
 arch/riscv/kernel/vdso/so2s.sh                                   |    6 
 arch/s390/kernel/smp.c                                           |    3 
 arch/s390/kernel/vdso64/Makefile                                 |    2 
 arch/sparc/vdso/Makefile                                         |    2 
 arch/x86/boot/compressed/mem_encrypt.S                           |   16 
 arch/x86/entry/vdso/Makefile                                     |    2 
 arch/x86/kernel/cpu/bugs.c                                       |   51 +-
 block/genhd.c                                                    |    5 
 drivers/accessibility/speakup/main.c                             |    1 
 drivers/accessibility/speakup/selection.c                        |   11 
 drivers/accessibility/speakup/speakup.h                          |    1 
 drivers/accessibility/speakup/spk_ttyio.c                        |   10 
 drivers/accessibility/speakup/spk_types.h                        |    8 
 drivers/block/loop.c                                             |    3 
 drivers/block/nbd.c                                              |   10 
 drivers/block/null_blk.h                                         |    1 
 drivers/block/null_blk_zoned.c                                   |   31 +
 drivers/char/tpm/eventlog/efi.c                                  |    5 
 drivers/char/tpm/tpm_tis.c                                       |   29 +
 drivers/char/virtio_console.c                                    |    8 
 drivers/cpufreq/cpufreq.c                                        |    4 
 drivers/cpufreq/cpufreq_governor.h                               |    2 
 drivers/cpufreq/cpufreq_performance.c                            |    1 
 drivers/cpufreq/cpufreq_powersave.c                              |    1 
 drivers/cpufreq/intel_pstate.c                                   |   16 
 drivers/crypto/chelsio/chcr_ktls.c                               |   27 -
 drivers/firmware/xilinx/zynqmp.c                                 |    3 
 drivers/gpio/gpio-aspeed.c                                       |    1 
 drivers/gpio/gpio-pcie-idio-24.c                                 |   62 ++
 drivers/gpio/gpio-sifive.c                                       |    2 
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c                            |   27 -
 drivers/gpu/drm/amd/amdgpu/soc15.c                               |    3 
 drivers/gpu/drm/amd/display/dc/irq/dcn30/irq_service_dcn30.c     |    4 
 drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c                    |    7 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c                 |    4 
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h                        |    1 
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h                       |    2 
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c                 |   29 +
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c                    |    8 
 drivers/gpu/drm/gma500/psb_irq.c                                 |   34 -
 drivers/gpu/drm/i915/gem/i915_gem_domain.c                       |   28 -
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                        |    3 
 drivers/gpu/drm/i915/i915_vma.c                                  |    6 
 drivers/gpu/drm/panfrost/panfrost_device.c                       |   40 +
 drivers/gpu/drm/panfrost/panfrost_drv.c                          |   20 
 drivers/gpu/drm/vc4/vc4_bo.c                                     |    5 
 drivers/gpu/drm/vc4/vc4_drv.c                                    |    1 
 drivers/gpu/drm/vc4/vc4_drv.h                                    |    2 
 drivers/hv/hv_balloon.c                                          |    2 
 drivers/hwmon/amd_energy.c                                       |    2 
 drivers/hwmon/applesmc.c                                         |  130 +++---
 drivers/hwtracing/coresight/coresight-etm-perf.c                 |    4 
 drivers/i2c/busses/i2c-designware-slave.c                        |   52 --
 drivers/i2c/busses/i2c-mt65xx.c                                  |    8 
 drivers/i2c/busses/i2c-sh_mobile.c                               |   86 +++-
 drivers/infiniband/ulp/srpt/ib_srpt.c                            |   13 
 drivers/iommu/amd/amd_iommu_types.h                              |    6 
 drivers/iommu/intel/svm.c                                        |    8 
 drivers/irqchip/irq-sifive-plic.c                                |   10 
 drivers/mfd/sprd-sc27xx-spi.c                                    |   28 +
 drivers/misc/mei/client.h                                        |    4 
 drivers/mmc/host/renesas_sdhi_core.c                             |    1 
 drivers/mmc/host/sdhci-of-esdhc.c                                |    2 
 drivers/mtd/spi-nor/core.c                                       |    8 
 drivers/net/can/dev.c                                            |   14 
 drivers/net/can/flexcan.c                                        |    5 
 drivers/net/can/peak_canfd/peak_canfd.c                          |   11 
 drivers/net/can/rx-offload.c                                     |    4 
 drivers/net/can/ti_hecc.c                                        |    8 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                     |   51 ++
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c                       |   48 +-
 drivers/net/can/xilinx_can.c                                     |    6 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c               |   26 +
 drivers/net/ethernet/intel/igc/igc_main.c                        |   14 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c              |   72 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c           |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c              |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c       |   14 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                  |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                  |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                |    7 
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c              |   23 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h              |    2 
 drivers/net/ethernet/microchip/lan743x_main.c                    |   24 -
 drivers/net/ethernet/microchip/lan743x_main.h                    |    3 
 drivers/net/ethernet/realtek/r8169_main.c                        |   18 
 drivers/net/phy/realtek.c                                        |    2 
 drivers/net/vrf.c                                                |   92 +++-
 drivers/net/wan/cosa.c                                           |    1 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                    |    2 
 drivers/nvme/host/core.c                                         |  106 +++-
 drivers/nvme/host/nvme.h                                         |    1 
 drivers/nvme/host/pci.c                                          |   23 -
 drivers/nvme/host/rdma.c                                         |   14 
 drivers/nvme/host/tcp.c                                          |   16 
 drivers/of/address.c                                             |    4 
 drivers/opp/core.c                                               |    7 
 drivers/pci/controller/pci-mvebu.c                               |   23 -
 drivers/pci/pci.c                                                |    9 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                          |    7 
 drivers/pinctrl/intel/pinctrl-intel.c                            |   40 +
 drivers/pinctrl/pinctrl-amd.c                                    |    6 
 drivers/pinctrl/pinctrl-mcp23s08_spi.c                           |    2 
 drivers/pinctrl/qcom/pinctrl-msm.c                               |   32 -
 drivers/pinctrl/qcom/pinctrl-sm8250.c                            |   18 
 drivers/scsi/device_handler/scsi_dh_alua.c                       |    9 
 drivers/scsi/hpsa.c                                              |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.c                              |    7 
 drivers/scsi/ufs/ufshcd-crypto.c                                 |    4 
 drivers/spi/spi-bcm2835.c                                        |    3 
 drivers/spi/spi-fsl-dspi.c                                       |   10 
 drivers/spi/spi-imx.c                                            |   23 -
 drivers/thunderbolt/nhi.c                                        |   19 
 drivers/thunderbolt/xdomain.c                                    |    1 
 drivers/uio/uio.c                                                |   10 
 drivers/usb/class/cdc-acm.c                                      |    9 
 drivers/usb/dwc3/dwc3-pci.c                                      |    4 
 drivers/usb/gadget/legacy/raw_gadget.c                           |    5 
 drivers/usb/gadget/udc/fsl_udc_core.c                            |    2 
 drivers/usb/gadget/udc/goku_udc.c                                |    2 
 drivers/usb/host/xhci-histb.c                                    |    2 
 drivers/usb/misc/apple-mfi-fastcharge.c                          |    4 
 drivers/usb/musb/musb_dsps.c                                     |    4 
 drivers/usb/typec/ucsi/psy.c                                     |    9 
 drivers/usb/typec/ucsi/ucsi.c                                    |    7 
 drivers/usb/typec/ucsi/ucsi.h                                    |    2 
 drivers/vfio/pci/vfio_pci.c                                      |    2 
 drivers/vfio/pci/vfio_pci_rdwr.c                                 |   43 +-
 drivers/vfio/platform/vfio_platform_common.c                     |    3 
 fs/afs/write.c                                                   |    5 
 fs/afs/xattr.c                                                   |    7 
 fs/afs/yfsclient.c                                               |    1 
 fs/btrfs/dev-replace.c                                           |   26 +
 fs/btrfs/ioctl.c                                                 |   10 
 fs/btrfs/ref-verify.c                                            |    1 
 fs/btrfs/relocation.c                                            |    4 
 fs/btrfs/volumes.c                                               |   26 -
 fs/ceph/caps.c                                                   |    2 
 fs/ceph/mds_client.c                                             |   50 +-
 fs/ceph/mds_client.h                                             |    1 
 fs/ceph/quota.c                                                  |    2 
 fs/ceph/snap.c                                                   |    2 
 fs/cifs/cifs_unicode.c                                           |    8 
 fs/erofs/inode.c                                                 |   21 
 fs/erofs/zdata.c                                                 |    7 
 fs/ext4/inline.c                                                 |    1 
 fs/ext4/super.c                                                  |    4 
 fs/gfs2/rgrp.c                                                   |    5 
 fs/gfs2/super.c                                                  |    1 
 fs/io_uring.c                                                    |   29 -
 fs/iomap/buffered-io.c                                           |   15 
 fs/jbd2/checkpoint.c                                             |    2 
 fs/jbd2/transaction.c                                            |    4 
 fs/nfs/nfs42xattr.c                                              |    2 
 fs/nfs/nfs42xdr.c                                                |    4 
 fs/nfsd/nfs4proc.c                                               |    3 
 fs/ocfs2/super.c                                                 |    1 
 fs/xfs/libxfs/xfs_alloc.c                                        |    1 
 fs/xfs/libxfs/xfs_bmap.h                                         |    2 
 fs/xfs/libxfs/xfs_rmap.c                                         |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c                                   |   16 
 fs/xfs/scrub/bmap.c                                              |    2 
 fs/xfs/scrub/inode.c                                             |    3 
 fs/xfs/scrub/refcount.c                                          |    8 
 fs/xfs/xfs_aops.c                                                |    6 
 fs/xfs/xfs_iops.c                                                |   10 
 fs/xfs/xfs_pnfs.c                                                |    2 
 include/linux/arm-smccc.h                                        |    2 
 include/linux/can/skb.h                                          |   20 
 include/linux/compiler-gcc.h                                     |    2 
 include/linux/compiler_types.h                                   |    4 
 include/linux/cpufreq.h                                          |   18 
 include/linux/genhd.h                                            |    2 
 include/linux/memcontrol.h                                       |   11 
 include/linux/netfilter/nfnetlink.h                              |    9 
 include/linux/netfilter_ipv4.h                                   |    2 
 include/linux/netfilter_ipv6.h                                   |   10 
 include/trace/events/sunrpc.h                                    |    8 
 init/main.c                                                      |   14 
 kernel/bpf/Makefile                                              |    6 
 kernel/bpf/core.c                                                |    2 
 kernel/bpf/hashtab.c                                             |   30 +
 kernel/dma/swiotlb.c                                             |    6 
 kernel/events/core.c                                             |   12 
 kernel/events/internal.h                                         |    2 
 kernel/exit.c                                                    |    5 
 kernel/futex.c                                                   |    5 
 kernel/irq/Kconfig                                               |    1 
 kernel/reboot.c                                                  |   28 -
 kernel/sched/cpufreq_schedutil.c                                 |    2 
 kernel/trace/trace.c                                             |    4 
 kernel/watchdog.c                                                |    4 
 mm/compaction.c                                                  |   12 
 mm/gup.c                                                         |   14 
 mm/hugetlb.c                                                     |   90 ----
 mm/memcontrol.c                                                  |   28 -
 mm/memory-failure.c                                              |   36 -
 mm/migrate.c                                                     |   44 +-
 mm/rmap.c                                                        |    5 
 mm/slub.c                                                        |    2 
 mm/vmscan.c                                                      |    5 
 net/can/j1939/socket.c                                           |    6 
 net/core/devlink.c                                               |    8 
 net/ethtool/features.c                                           |    2 
 net/ipv4/ip_tunnel_core.c                                        |    4 
 net/ipv4/netfilter.c                                             |    8 
 net/ipv4/netfilter/iptable_mangle.c                              |    2 
 net/ipv4/netfilter/nf_reject_ipv4.c                              |    2 
 net/ipv4/syncookies.c                                            |    9 
 net/ipv4/udp_offload.c                                           |   19 
 net/ipv4/xfrm4_tunnel.c                                          |    4 
 net/ipv6/netfilter.c                                             |    6 
 net/ipv6/netfilter/ip6table_mangle.c                             |    2 
 net/ipv6/sit.c                                                   |    2 
 net/ipv6/syncookies.c                                            |   10 
 net/ipv6/udp_offload.c                                           |   17 
 net/ipv6/xfrm6_tunnel.c                                          |    4 
 net/iucv/af_iucv.c                                               |    3 
 net/mac80211/mlme.c                                              |    3 
 net/mac80211/tx.c                                                |   37 +
 net/mptcp/protocol.c                                             |    1 
 net/netfilter/ipset/ip_set_core.c                                |    3 
 net/netfilter/ipvs/ip_vs_core.c                                  |    4 
 net/netfilter/nf_nat_proto.c                                     |    4 
 net/netfilter/nf_synproxy_core.c                                 |    2 
 net/netfilter/nf_tables_api.c                                    |   19 
 net/netfilter/nfnetlink.c                                        |   22 -
 net/netfilter/nft_chain_route.c                                  |    4 
 net/netfilter/utils.c                                            |    4 
 net/tipc/topsrv.c                                                |   10 
 net/wireless/core.c                                              |   57 +-
 net/wireless/core.h                                              |    5 
 net/wireless/nl80211.c                                           |    3 
 net/wireless/reg.c                                               |    2 
 net/x25/af_x25.c                                                 |    2 
 net/xfrm/xfrm_interface.c                                        |    8 
 net/xfrm/xfrm_state.c                                            |    8 
 security/selinux/ibpkey.c                                        |    4 
 sound/hda/ext/hdac_ext_controller.c                              |    2 
 sound/pci/hda/hda_controller.h                                   |    3 
 sound/pci/hda/hda_intel.c                                        |   63 +-
 sound/soc/codecs/cs42l51.c                                       |   22 -
 sound/soc/codecs/wcd9335.c                                       |    2 
 sound/soc/codecs/wcd934x.c                                       |    2 
 sound/soc/codecs/wsa881x.c                                       |    2 
 sound/soc/intel/boards/kbl_rt5663_max98927.c                     |   39 +
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c               |   31 +
 sound/soc/qcom/sdm845.c                                          |    2 
 sound/soc/sof/loader.c                                           |    5 
 tools/bpf/bpftool/prog.c                                         |    2 
 tools/lib/bpf/hashmap.h                                          |   15 
 tools/perf/builtin-trace.c                                       |   15 
 tools/perf/util/scripting-engines/trace-event-python.c           |    7 
 tools/perf/util/session.c                                        |   14 
 tools/testing/kunit/kunit_parser.py                              |    3 
 tools/testing/selftests/bpf/Makefile                             |    2 
 tools/testing/selftests/bpf/prog_tests/map_init.c                |  214 ++++++++++
 tools/testing/selftests/bpf/progs/test_map_init.c                |   33 +
 tools/testing/selftests/clone3/clone3_cap_checkpoint_restore.c   |    2 
 tools/testing/selftests/core/close_range_test.c                  |    8 
 tools/testing/selftests/filesystems/binderfs/binderfs_test.c     |    8 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc |    4 
 tools/testing/selftests/lib.mk                                   |    2 
 tools/testing/selftests/pidfd/pidfd_open_test.c                  |    1 
 tools/testing/selftests/pidfd/pidfd_poll_test.c                  |    1 
 tools/testing/selftests/proc/proc-loadavg-001.c                  |    1 
 tools/testing/selftests/proc/proc-self-syscall.c                 |    1 
 tools/testing/selftests/proc/proc-uptime-002.c                   |    1 
 tools/testing/selftests/tc-testing/tc-tests/filters/tests.json   |    4 
 tools/testing/selftests/wireguard/netns.sh                       |    8 
 tools/testing/selftests/wireguard/qemu/kernel.config             |    2 
 296 files changed, 2431 insertions(+), 1240 deletions(-)

Al Viro (1):
      don't dump the threads that had been already exiting when zapped.

Alex Williamson (1):
      vfio/pci: Implement ioeventfd thread handler for contended memory lock

Alexander Lobakin (4):
      virtio: virtio_console: fix DMA memory allocation for rproc serial
      ethtool: netlink: add missing netdev_features_change() call
      net: udp: fix IP header access and skb lookup on Fast/frag0 UDP GRO
      net: udp: fix UDP header access on Fast/frag0 UDP GRO

Alexander Usyskin (1):
      mei: protect mei_cl_mtu from null dereference

Anand Jain (1):
      btrfs: dev-replace: fail mount if we don't have replace item with target device

Anand K Mistry (1):
      x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

Andrew Jeffery (1):
      ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Andrew Jones (1):
      KVM: arm64: Don't hide ID registers from userspace

Andy Shevchenko (4):
      kunit: Don't fail test suites if one of them is empty
      pinctrl: intel: Fix 2 kOhm bias which is 833 Ohm
      pinctrl: intel: Set default bias in case no particular value given
      pinctrl: mcp23s08: Use full chunk of memory for regmap configuration

Anshuman Khandual (1):
      arm64/mm: Validate hotplug range before creating linear mapping

Ard Biesheuvel (1):
      bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

Arnaldo Carvalho de Melo (1):
      perf scripting python: Avoid declaring function pointers with a visibility attribute

Arnaud de Turckheim (3):
      gpio: pcie-idio-24: Fix irq mask when masking
      gpio: pcie-idio-24: Fix IRQ Enable Register value
      gpio: pcie-idio-24: Enable PEX8311 interrupts

Arnd Bergmann (1):
      firmware: xilinx: fix out-of-bounds access

Aya Levin (1):
      net/mlx5e: Fix VXLAN synchronization after function reload

Baolin Wang (1):
      mfd: sprd: Add wakeup capability for PMIC IRQ

Bard Liao (1):
      ASoC: SOF: loader: handle all SOF_IPC_EXT types

Benjamin Gwin (1):
      arm64: kexec_file: try more regions if loading segments fails

Bert Vermeulen (1):
      mtd: spi-nor: Fix address width on flash chips > 16MB

Bhawanpreet Lakha (1):
      drm/amd/display: Add missing pflip irq

Bill Wendling (1):
      kbuild: explicitly specify the build id style

Billy Tsai (2):
      gpio: aspeed: fix ast2600 bank properties
      pinctrl: aspeed: Fix GPI only function problem.

Bjorn Andersson (1):
      pinctrl: qcom: sm8250: Specify PDC map

Bob Peterson (3):
      gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
      gfs2: Add missing truncate_inode_pages_final for sd_aspace
      gfs2: check for live vs. read-only file system in gfs2_fitrim

Boris Protopopov (1):
      Convert trailing spaces and periods in path components

Brad Campbell (1):
      hwmon: (applesmc) Re-work SMC comms

Brian Foster (2):
      xfs: flush new eof page on truncate to avoid post-eof corruption
      iomap: clean up writeback state logic on writepage error

Chao Leng (3):
      nvme: introduce nvme_sync_io_queues
      nvme-rdma: avoid race between time out and tear down
      nvme-tcp: avoid race between time out and tear down

Chen Zhou (1):
      selinux: Fix error return code in sel_ib_pkey_sid_slow()

Chris Brandt (1):
      usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Chris Wilson (2):
      drm/i915: Hold onto an explicit ref to i915_vma_work.pinned
      drm/i915/gem: Flush coherency domains on first set-domain-ioctl

Christoph Hellwig (4):
      nbd: fix a block_device refcount leak in nbd_release
      xfs: fix a missing unlock on error in xfs_fs_map_blocks
      nvme: factor out a nvme_configure_metadata helper
      block: add a return value to set_capacity_revalidate_and_notify

Christophe Leroy (1):
      powerpc/603: Always fault when _PAGE_ACCESSED is not set

Chuck Lever (2):
      SUNRPC: Fix general protection fault in trace_rpc_xdr_overflow()
      NFS: Fix listxattr receive buffer size

Clément Péron (2):
      drm/panfrost: rename error labels in device_init
      drm/panfrost: move devfreq_init()/fini() in device

Coiby Xu (2):
      pinctrl: amd: use higher precision for 512 RtcClk
      pinctrl: amd: fix incorrect way to disable debounce filter

Colin Ian King (1):
      selftests/ftrace: check for do_sys_openat2 in user-memory test

Dai Ngo (2):
      NFSD: Fix use-after-free warning when doing inter-server copy
      NFSD: fix missing refcount in nfsd4_copy by nfsd4_do_async_copy

Damien Le Moal (2):
      gpio: sifive: Fix SiFive gpio probe
      null_blk: Fix scheduling in atomic with zoned mode

Dan Carpenter (3):
      ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()
      can: peak_usb: add range checking in decode operations
      futex: Don't enable IRQs unconditionally in put_pi_state()

Darrick J. Wong (7):
      xfs: set xefi_discard when creating a deferred agfl free log intent item
      xfs: fix missing CoW blocks writeback conversion retry
      xfs: fix scrub flagging rtinherit even if there is no rt device
      xfs: fix flags argument to rmap lookup when converting shared file rmaps
      xfs: set the unwritten bit in rmap lookup flags in xchk_bmap_get_rmapextents
      xfs: fix rmap key and record comparison functions
      xfs: fix brainos in the refcount scrubber's rmap fragment processor

David Gow (1):
      kunit: Fix kunit.py --raw_output option

David Howells (3):
      afs: Fix warning due to unadvanced marshalling pointer
      afs: Fix incorrect freeing of the ACL passed to the YFS ACL store op
      afs: Fix afs_write_end() when called with copied == 0 [ver #3]

David Verbeiren (1):
      bpf: Zero-fill re-used per-cpu map element

Dinghao Liu (1):
      btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod

Evan Nimmo (1):
      of/address: Fix of_node memory leak in of_dma_is_coherent

Evan Quan (4):
      drm/amdgpu: perform srbm soft reset always on SDMA resume
      drm/amd/pm: correct the baco reset sequence for CI ASICs
      drm/amd/pm: perform SMC reset on suspend/hibernation
      drm/amd/pm: do not use ixFEATURE_STATUS for checking smc running

Evgeny Novikov (1):
      usb: gadget: goku_udc: fix potential crashes in probe

Fred Gao (1):
      vfio/pci: Bypass IGD init in case of -ENODEV

Gao Xiang (2):
      erofs: fix setting up pcluster for temporary pages
      erofs: derive atime instead of leaving it empty

Geert Uytterhoeven (1):
      Revert "usb: musb: convert to devm_platform_ioremap_resource_byname"

Greentime Hu (2):
      irqchip/sifive-plic: Fix broken irq_set_affinity() callback
      irqchip/sifive-plic: Fix chip_data access within a hierarchy

Greg Kroah-Hartman (1):
      Linux 5.9.9

Hannes Reinecke (1):
      scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Heikki Krogerus (2):
      usb: dwc3: pci: add support for the Intel Alder Lake-S
      usb: typec: ucsi: Report power supply changes

Heiner Kallweit (3):
      r8169: fix potential skb double free in an error path
      r8169: disable hw csum for short packets on all chip versions
      net: phy: realtek: support paged operations on RTL8201CP

Ian Rogers (1):
      libbpf, hashmap: Fix undefined behavior in hash_bits

J. Bruce Fields (1):
      NFSv4.2: fix failure to unregister shrinker

Jason A. Donenfeld (2):
      netfilter: use actual socket sk rather than skb sk when routing harder
      wireguard: selftests: check that route_me_harder packets use the right sk

Jason Gunthorpe (1):
      mm/gup: use unpin_user_pages() in __gup_longterm_locked()

Jeff Layton (1):
      ceph: check session state after bumping session->s_seq

Jens Axboe (2):
      io_uring: ensure consistent view of original task ->mm from SQPOLL
      io_uring: round-up cq size before comparing with rounded sq size

Jerry Snitselaar (1):
      tpm_tis: Disable interrupts on ThinkPad T490s

Jing Xiangfeng (1):
      thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()

Jiri Olsa (1):
      perf tools: Add missing swap for ino_generation

Joakim Zhang (2):
      can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
      can: flexcan: flexcan_remove(): disable wakeup completely

Joerg Roedel (1):
      x86/boot/compressed/64: Introduce sev_status

Johannes Berg (3):
      mac80211: don't require VHT elements for HE on 2.4 GHz
      mac80211: fix use of skb payload instead of header
      cfg80211: initialize wdev data earlier

Josef Bacik (1):
      btrfs: fix min reserved size calculation in merge_reloc_root

Joseph Qi (1):
      ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Kai-Heng Feng (2):
      ALSA: hda: Separate runtime and system suspend
      ALSA: hda: Reinstate runtime_allow() for all hda controllers

Kaixu Xia (1):
      ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Keita Suzuki (1):
      scsi: hpsa: Fix memory leak in hpsa_init_one()

Keith Busch (1):
      Revert "nvme-pci: remove last_sq_tail"

Laurent Dufour (1):
      mm/slub: fix panic in slab_alloc_node()

Linu Cherian (1):
      coresight: etm: perf: Sink selection using sysfs is deprecated

Liu Yi L (1):
      iommu/vt-d: Fix sid not set issue in intel_svm_bind_gpasid()

Liu, Yi L (1):
      iommu/vt-d: Fix a bug for PDP check in prq_event_thread

Lorenz Bauer (1):
      tools/bpftool: Fix attaching flow dissector

Mao Wenan (1):
      net: Update window_clamp if SOCK_RCVBUF is set

Maor Dickman (1):
      net/mlx5e: Fix modify header actions memory leak

Maor Gottlieb (2):
      IB/srpt: Fix memory leak in srpt_add_one
      net/mlx5: Fix deletion of duplicate rules

Marc Kleine-Budde (1):
      can: rx-offload: don't call kfree_skb() from IRQ context

Marc Zyngier (1):
      genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Martin Hundebøll (1):
      spi: bcm2835: remove use of uninitialized gpio flags variable

Martin Schiller (1):
      net/x25: Fix null-ptr-deref in x25_connect

Martin Willi (1):
      vrf: Fix fast path output packet handling with async Netfilter rules

Masami Hiramatsu (1):
      bootconfig: Extend the magic check range to the preceding 3 bytes

Masashi Honma (1):
      ath9k_htc: Use appropriate rs_datalen type

Matteo Croce (2):
      Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
      reboot: fix overflow parsing reboot cpu number

Matthew Wilcox (Oracle) (1):
      btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch

Maulik Shah (1):
      pinctrl: qcom: Move clearing pending IRQ to .irq_request_resources callback

Maxim Mikityanskiy (2):
      net/mlx5e: Use spin_lock_bh for async_icosq_lock
      net/mlx5e: Fix incorrect access of RCU-protected xdp_prog

Maxime Ripard (1):
      drm/vc4: bo: Add a managed action to cleanup the cache

Michael Wu (2):
      i2c: designware: call i2c_dw_read_clear_intrbits_slave() once
      i2c: designware: slave should do WRITE_REQUESTED before WRITE_RECEIVED

Mika Westerberg (1):
      thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()

Mike Kravetz (1):
      hugetlbfs: fix anon huge page migration race

Mike Leach (1):
      coresight: Fix uninitialised pointer bug in etm_setup_aux()

Ming Lei (1):
      nbd: don't update block size after device is started

Muchun Song (1):
      mm: memcontrol: fix missing wakeup polling thread

Namhyung Kim (1):
      perf tools: Add missing swap for cgroup events

Naveen Krishna Chatradhi (1):
      hwmon: (amd_energy) modify the visibility of the counters

Navid Emamdoost (1):
      can: xilinx_can: handle failure cases of pm_runtime_get_sync

Nicholas Piggin (1):
      mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit

Olaf Hering (1):
      hv_balloon: disable warning when floor reached

Oleksij Rempel (1):
      can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp (1):
      can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames

Oliver Herms (1):
      IPv6: Set SIT tunnel hard_header_len to zero

Olivier Moysan (1):
      ASoC: cs42l51: manage mclk shutdown delay

Pablo Neira Ayuso (2):
      netfilter: nftables: fix netlink report logic in flowtable and genid
      netfilter: nf_tables: missing validation from the abort path

Palmer Dabbelt (1):
      RISC-V: Fix the VDSO symbol generaton for binutils-2.35+

Paolo Abeni (1):
      mptcp: provide rmem[0] limit

Parav Pandit (2):
      net/mlx5: E-switch, Avoid extack error log for disabled vport
      devlink: Avoid overwriting port attributes of registered port

Peter Zijlstra (3):
      perf: Fix get_recursion_context()
      perf: Simplify group_sched_in()
      perf: Fix event multiplexing for exclusive groups

Petr Vorel (1):
      loop: Fix occasional uevent drop

Pujin Shi (1):
      scsi: ufs: Fix missing brace warning for old compilers

Qian Cai (2):
      powerpc/eeh_cache: Fix a possible debugfs deadlock
      s390/smp: move rcu_cpu_starting() earlier

Qii Wang (1):
      i2c: mediatek: move dma reset before i2c reset

Qiujun Huang (1):
      tracing: Fix the checking of stackidx in __ftrace_trace_stack

Rafael J. Wysocki (4):
      cpufreq: Introduce governor flags
      cpufreq: Introduce CPUFREQ_GOV_STRICT_TARGET
      cpufreq: Add strict_target to struct cpufreq_policy
      cpufreq: intel_pstate: Take CPUFREQ_GOV_STRICT_TARGET into account

Rajat Jain (1):
      PCI: Always enable ACS even if no ACS Capability

Ran Wang (1):
      usb: gadget: fsl: fix null pointer checking

Rob Herring (1):
      PCI: mvebu: Fix duplicate resource requests

Rohit Maheshwari (2):
      ch_ktls: Update cheksum information
      ch_ktls: tcb update fails sometimes

Roman Gushchin (1):
      mm: memcg: link page counters to root if use_hierarchy is false

Sagi Grimberg (3):
      nvme-rdma: avoid repeated request completion
      nvme-tcp: avoid repeated request completion
      nvme: fix incorrect behavior when BLKROSET is called by the user

Samuel Thibault (3):
      speakup: Fix var_id_t values and thus keymap
      speakup ttyio: Do not schedule() in ttyio_in_nowait
      speakup: Fix clearing selection in safe context

Santosh Shukla (1):
      KVM: arm64: Force PTE mapping on fault resulting in a device mapping

Santosh Sivaraj (1):
      kernel/watchdog: fix watchdog_allowed_mask not used warning

Sascha Hauer (1):
      spi: imx: fix runtime pm support for !CONFIG_PM

Sasha Levin (1):
      nvme: freeze the queue over ->lba_shift updates

Sean Anderson (1):
      riscv: Set text_offset correctly for M-Mode

Shin'ichiro Kawasaki (1):
      uio: Fix use-after-free in uio_unregister_device()

Slawomir Laba (1):
      i40e: Fix MAC address setting for a VF via Host/VM

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix timeouts observed while reenabling IRQ

Srinivas Kandagatla (4):
      ASoC: codecs: wsa881x: add missing stream rates and format
      ASoC: codecs: wcd934x: Set digital gain range correctly
      ASoC: codecs: wcd9335: Set digital gain range correctly
      ASoC: qcom: sdm845: set driver name correctly

Stanislav Ivanichkin (1):
      perf trace: Fix segfault when trying to trace events by cgroup

Stefano Brivio (2):
      netfilter: ipset: Update byte and packet counters regardless of whether they match
      tunnels: Fix off-by-one in lower MTU bounds for ICMP/ICMPv6 replies

Stefano Stabellini (1):
      swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Stephane Grosjean (2):
      can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
      can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Stephen Boyd (1):
      KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED

Steven Price (1):
      drm/panfrost: Fix module unload

Suravee Suthikulpanit (1):
      iommu/amd: Increase interrupt remapping table limit to 512 entries

Sven Van Asbroeck (3):
      lan743x: correctly handle chips with internal PHY
      lan743x: fix "BUG: invalid wait context" when setting rx mode
      lan743x: fix use of uninitialized variable

Theodore Ts'o (1):
      jbd2: fix up sparse warnings in checkpoint code

Thomas Zimmermann (1):
      drm/gma500: Fix out-of-bounds access to struct drm_device.vblank[]

Tomasz Figa (1):
      ASoC: Intel: kbl_rt5663_max98927: Fix kabylake_ssp_fixup function

Tommi Rantala (6):
      selftests: filter kselftest headers from command in lib.mk
      selftests: core: use SKIP instead of XFAIL in close_range_test.c
      selftests: clone3: use SKIP instead of XFAIL
      selftests: binderfs: use SKIP instead of XFAIL
      selftests: pidfd: fix compilation errors due to wait.h
      selftests: proc: fix warning: _GNU_SOURCE redefined

Tyler Hicks (1):
      tpm: efi: Don't create binary_bios_measurements file for an empty log

Tzung-Bi Shih (1):
      ASoC: mediatek: mt8183-da7219: fix DAPM paths for rt1015

Ulrich Hecht (1):
      i2c: sh_mobile: implement atomic transfers

Ursula Braun (1):
      net/af_iucv: fix null pointer dereference on shutdown

Veerabadhran Gopalakrishnan (1):
      amd/amdgpu: Disable VCN DPG mode for Picasso

Venkata Sandeep Dhanalakota (1):
      drm/i915: Correctly set SFC capability for video engines

Vincent Mailhol (1):
      can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Vineet Gupta (1):
      ARC: [plat-hsdk] Remap CCMs super early in asm boot trampoline

Vinicius Costa Gomes (1):
      igc: Fix returning wrong statistics

Viresh Kumar (1):
      opp: Reduce the size of critical section in _opp_table_kref_release()

Vlad Buslov (2):
      net/mlx5e: Protect encap route dev from concurrent release
      selftest: fix flower terse dump tests

Wang Hai (2):
      cosa: Add missing kfree in error path of cosa_write
      tipc: fix memory leak in tipc_topsrv_start()

Wengang Wang (1):
      ocfs2: initialize ip_next_orphan

Xin Long (1):
      xfrm: interface: fix the priorities for ipip and ipv6 tunnels

Yangbo Lu (1):
      mmc: sdhci-of-esdhc: Handle pulse width detection erratum for more SoCs

Ye Bin (1):
      cfg80211: regulatory: Fix inconsistent format argument

Yegor Yefremov (1):
      can: j1939: swap addr and pgn in the send example

Yoshihiro Shimoda (1):
      mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at remove

Zhang Changzhong (2):
      can: j1939: j1939_sk_bind(): return failure if netdev is down
      can: ti_hecc: ti_hecc_probe(): add missed clk_disable_unprepare() in error path

Zhang Qilong (3):
      USB: apple-mfi-fastcharge: fix reference leak in apple_mfi_fc_set_property
      vfio: platform: fix reference leak in vfio_platform_open
      xhci: hisilicon: fix refercence leak in xhci_histb_probe

Zhao Qiang (1):
      spi: fsl-dspi: fix wrong pointer in suspend/resume

Zi Yan (2):
      mm/compaction: count pages and stop correctly during page isolation
      mm/compaction: stop isolation if too many pages are isolated and we have pages to migrate

Zqiang (1):
      usb: raw-gadget: fix memory leak in gadget_setup

zhongjiang-ali (1):
      mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg

zhuoliang zhang (1):
      net: xfrm: fix a race condition during allocing spi

