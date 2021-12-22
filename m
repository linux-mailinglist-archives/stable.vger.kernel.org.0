Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3B47CEB5
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 10:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbhLVJER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 04:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243757AbhLVJDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 04:03:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD55C061747;
        Wed, 22 Dec 2021 01:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C74E0B81B77;
        Wed, 22 Dec 2021 09:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3758C36AE5;
        Wed, 22 Dec 2021 09:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640163810;
        bh=wHoQNdqLPCFqlBp5bheRxpIzXf3lCyhU+4bKMgH3Oy4=;
        h=From:To:Cc:Subject:Date:From;
        b=bq+1s8tS/Vhe+8Tp9WVqImcxERk5z//0NYZCx0hEQ50R2KCStyjsklm/ugkA/eEfy
         vFzxkgp2tJAYQRNwi9CpLGTHouxO4V8m2jl//tH/cat47e6b7L9SPhHpOIDbBPbrfz
         fbS9/2efj0eZwm76/QdcdhYQSVC3JNb9MQ/djcpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.11
Date:   Wed, 22 Dec 2021 10:03:15 +0100
Message-Id: <164016379620910@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.11 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst |   16 +
 Makefile                                                         |    2 
 arch/arm/boot/dts/imx6ull-pinfunc.h                              |    2 
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts                 |    2 
 arch/arm/boot/dts/socfpga_arria5_socdk.dts                       |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts                     |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts                    |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts                  |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts                     |    2 
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts               |    4 
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts              |    2 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                        |    2 
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts                   |    2 
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi             |    1 
 arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts           |    1 
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts                |    2 
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi               |    2 
 arch/arm64/kernel/machine_kexec_file.c                           |    1 
 arch/powerpc/kernel/module_64.c                                  |   42 ++
 arch/powerpc/platforms/85xx/smp.c                                |    4 
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts              |    1 
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts              |    2 
 arch/s390/kernel/irq.c                                           |    9 
 arch/s390/kernel/machine_kexec_file.c                            |    7 
 arch/x86/kvm/ioapic.h                                            |    1 
 arch/x86/kvm/irq.h                                               |    1 
 arch/x86/kvm/vmx/vmx.c                                           |    4 
 arch/x86/kvm/x86.c                                               |   14 
 arch/x86/net/bpf_jit_comp.c                                      |  101 ++++---
 block/blk-iocost.c                                               |    9 
 drivers/Makefile                                                 |    3 
 drivers/ata/libata-scsi.c                                        |   15 -
 drivers/block/xen-blkfront.c                                     |   15 -
 drivers/bus/ti-sysc.c                                            |    3 
 drivers/clk/clk.c                                                |   15 -
 drivers/dma/idxd/irq.c                                           |    7 
 drivers/dma/idxd/registers.h                                     |    1 
 drivers/dma/idxd/submit.c                                        |   18 +
 drivers/dma/st_fdma.c                                            |    2 
 drivers/firmware/scpi_pm_domain.c                                |   10 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                            |    4 
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c                          |    1 
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c                          |    1 
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c                          |    1 
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c                          |    1 
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c                          |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c                |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c                   |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                   |    3 
 drivers/gpu/drm/ast/ast_mode.c                                   |    5 
 drivers/gpu/drm/drm_fb_helper.c                                  |    8 
 drivers/gpu/drm/i915/display/g4x_hdmi.c                          |    1 
 drivers/gpu/drm/i915/display/intel_ddi.c                         |    1 
 drivers/gpu/drm/i915/display/intel_dmc.c                         |    2 
 drivers/gpu/drm/i915/display/intel_hdmi.c                        |   32 +-
 drivers/gpu/drm/i915/display/intel_hdmi.h                        |    1 
 drivers/gpu/drm/tiny/simpledrm.c                                 |    2 
 drivers/md/persistent-data/dm-btree-remove.c                     |    2 
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                          |   16 -
 drivers/net/can/m_can/m_can.c                                    |   24 +
 drivers/net/can/m_can/m_can.h                                    |    3 
 drivers/net/can/m_can/m_can_pci.c                                |   48 +++
 drivers/net/dsa/mv88e6xxx/chip.c                                 |    4 
 drivers/net/dsa/mv88e6xxx/port.c                                 |    4 
 drivers/net/ethernet/broadcom/bcmsysport.c                       |    5 
 drivers/net/ethernet/broadcom/bcmsysport.h                       |    1 
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                      |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c               |   20 -
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c         |    3 
 drivers/net/ethernet/intel/ice/ice_ptp.c                         |   13 
 drivers/net/ethernet/intel/ice/ice_ptp.h                         |    6 
 drivers/net/ethernet/intel/igb/igb_main.c                        |   28 -
 drivers/net/ethernet/intel/igbvf/netdev.c                        |    1 
 drivers/net/ethernet/intel/igc/igc_i225.c                        |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                    |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c                    |    3 
 drivers/net/ethernet/sfc/ef100_nic.c                             |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c                   |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                     |   17 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c                  |   86 +++++
 drivers/net/netdevsim/bpf.c                                      |    1 
 drivers/net/netdevsim/ethtool.c                                  |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                      |    5 
 drivers/net/xen-netback/common.h                                 |    1 
 drivers/net/xen-netback/rx.c                                     |   77 +++--
 drivers/net/xen-netfront.c                                       |  125 ++++++--
 drivers/pci/msi.c                                                |   15 -
 drivers/pinctrl/pinctrl-amd.c                                    |   29 +-
 drivers/reset/tegra/reset-bpmp.c                                 |    9 
 drivers/scsi/scsi_debug.c                                        |   42 +-
 drivers/scsi/ufs/ufshcd.c                                        |   12 
 drivers/soc/imx/soc-imx.c                                        |    4 
 drivers/soc/tegra/fuse/fuse-tegra.c                              |    2 
 drivers/soc/tegra/fuse/fuse.h                                    |    2 
 drivers/tee/amdtee/core.c                                        |    5 
 drivers/tty/hvc/hvc_xen.c                                        |   30 +-
 drivers/tty/n_hdlc.c                                             |   23 +
 drivers/tty/serial/8250/8250_fintek.c                            |   20 -
 drivers/usb/cdns3/cdnsp-gadget.c                                 |   12 
 drivers/usb/cdns3/cdnsp-ring.c                                   |   11 
 drivers/usb/cdns3/cdnsp-trace.h                                  |    4 
 drivers/usb/core/devio.c                                         |  144 +++++++---
 drivers/usb/core/quirks.c                                        |    3 
 drivers/usb/dwc2/platform.c                                      |    3 
 drivers/usb/early/xhci-dbc.c                                     |   15 -
 drivers/usb/gadget/composite.c                                   |    6 
 drivers/usb/gadget/function/u_ether.c                            |   16 -
 drivers/usb/gadget/legacy/dbgp.c                                 |    6 
 drivers/usb/gadget/legacy/inode.c                                |    6 
 drivers/usb/host/xhci-mtk-sch.c                                  |    2 
 drivers/usb/host/xhci-pci.c                                      |    6 
 drivers/usb/serial/cp210x.c                                      |    6 
 drivers/usb/serial/option.c                                      |    8 
 drivers/usb/typec/tcpm/tcpm.c                                    |   18 -
 drivers/vdpa/vdpa.c                                              |    3 
 drivers/vdpa/vdpa_user/vduse_dev.c                               |    6 
 drivers/vhost/vdpa.c                                             |    2 
 drivers/virtio/virtio_ring.c                                     |    2 
 drivers/xen/events/events_base.c                                 |    6 
 fs/afs/file.c                                                    |    5 
 fs/afs/super.c                                                   |    1 
 fs/btrfs/disk-io.c                                               |   14 
 fs/btrfs/extent_io.c                                             |   10 
 fs/btrfs/inode.c                                                 |    2 
 fs/btrfs/super.c                                                 |   26 -
 fs/btrfs/tree-log.c                                              |    1 
 fs/btrfs/volumes.c                                               |   25 -
 fs/btrfs/volumes.h                                               |    6 
 fs/ceph/caps.c                                                   |   16 -
 fs/ceph/file.c                                                   |   18 +
 fs/ceph/mds_client.c                                             |    3 
 fs/cifs/fs_context.c                                             |   38 ++
 fs/fuse/dir.c                                                    |    2 
 fs/io-wq.c                                                       |   31 +-
 fs/overlayfs/dir.c                                               |    3 
 fs/overlayfs/overlayfs.h                                         |    1 
 fs/overlayfs/super.c                                             |   12 
 fs/zonefs/super.c                                                |    1 
 include/uapi/linux/mptcp.h                                       |   18 -
 include/xen/events.h                                             |    1 
 kernel/audit.c                                                   |   21 -
 kernel/bpf/verifier.c                                            |   49 ++-
 kernel/locking/rtmutex.c                                         |    2 
 kernel/rcu/tree.c                                                |   10 
 kernel/time/timekeeping.c                                        |    3 
 net/core/skbuff.c                                                |    2 
 net/ipv4/inet_diag.c                                             |    4 
 net/ipv6/sit.c                                                   |    1 
 net/mac80211/agg-rx.c                                            |    5 
 net/mac80211/agg-tx.c                                            |   16 -
 net/mac80211/driver-ops.h                                        |    5 
 net/mac80211/mlme.c                                              |   13 
 net/mac80211/sta_info.h                                          |    1 
 net/mac80211/tx.c                                                |    6 
 net/mac80211/util.c                                              |    7 
 net/mptcp/pm_netlink.c                                           |    3 
 net/mptcp/protocol.c                                             |    6 
 net/mptcp/sockopt.c                                              |    1 
 net/packet/af_packet.c                                           |    5 
 net/rds/connection.c                                             |    1 
 net/sched/cls_api.c                                              |    1 
 net/sched/sch_cake.c                                             |    6 
 net/sched/sch_ets.c                                              |    4 
 net/smc/af_smc.c                                                 |    4 
 net/vmw_vsock/virtio_transport_common.c                          |    3 
 net/wireless/reg.c                                               |    7 
 scripts/recordmcount.pl                                          |    2 
 security/selinux/hooks.c                                         |   33 +-
 tools/perf/builtin-inject.c                                      |   13 
 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c     |   16 -
 tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c            |   86 +++++
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c           |   23 +
 tools/testing/selftests/damon/.gitignore                         |    2 
 tools/testing/selftests/damon/Makefile                           |    2 
 tools/testing/selftests/damon/debugfs_attrs.sh                   |   18 +
 tools/testing/selftests/damon/huge_count_read_write.c            |   39 ++
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c               |   30 ++
 tools/testing/selftests/net/fcnal-test.sh                        |   45 ++-
 tools/testing/selftests/net/forwarding/forwarding.config.sample  |    2 
 tools/testing/selftests/net/icmp_redirect.sh                     |    2 
 tools/testing/selftests/net/toeplitz.c                           |    2 
 virt/kvm/kvm_main.c                                              |    6 
 185 files changed, 1583 insertions(+), 554 deletions(-)

Adrian Hunter (2):
      perf inject: Fix segfault due to close without open
      perf inject: Fix segfault due to perf_data__fd() without open

Alan Stern (1):
      USB: core: Make do_proc_control() and do_proc_bulk() killable

Alejandro Concepcion-Rodriguez (1):
      drm: simpledrm: fix wrong unit with pixel clock

Alex Bee (1):
      arm64: dts: rockchip: fix audio-supply for Rock Pi 4

Alexei Starovoitov (2):
      bpf: Fix extable fixup offset.
      bpf: Fix extable address check.

Alyssa Ross (1):
      dmaengine: st_fdma: fix MODULE_ALIAS

Amelie Delaunay (1):
      usb: dwc2: fix STM ID/VBUS detection startup delay in dwc2_driver_probe

Anand Jain (4):
      btrfs: convert latest_bdev type to btrfs_device and rename
      btrfs: use latest_dev in btrfs_show_devname
      btrfs: update latest_dev when we create a sprout device
      btrfs: remove stale comment about the btrfs_show_devname

Andrey Eremeev (1):
      dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED

Arnd Bergmann (1):
      virtio: always enter drivers/virtio/

Artem Lapkin (1):
      arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge

Baowen Zheng (1):
      flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Bin Meng (2):
      riscv: dts: unleashed: Add gpio card detect to mmc-spi-slot
      riscv: dts: unmatched: Add gpio card detect to mmc-spi-slot

Christian Brauner (1):
      ceph: fix up non-directory creation in SGID directories

Chunfeng Yun (1):
      usb: xhci-mtk: fix list_del warning when enable list debug

Cyril Novikov (1):
      ixgbe: set X550 MDIO speed before talking to PHY

D. Wythe (1):
      net/smc: Prevent smc_release() from long blocking

Dan Carpenter (4):
      vduse: fix memory corruption in vduse_dev_ioctl()
      vduse: check that offset is within bounds in get_config()
      vdpa: check that offsets are within bounds
      tee: amdtee: fix an IS_ERR() vs NULL bug

Daniel Borkmann (7):
      bpf: Fix kernel address leakage in atomic fetch
      bpf, selftests: Add test case for atomic fetch on spilled pointer
      bpf: Fix signed bounds propagation after mov32
      bpf: Make 32->64 bounds propagation slightly more robust
      bpf, selftests: Add test case trying to taint map value pointer
      bpf: Fix kernel address leakage in atomic cmpxchg's r0 aux reg
      bpf, selftests: Update test case for atomic cmpxchg on r0 with pointer

Daniele Palmas (1):
      USB: serial: option: add Telit FN990 compositions

Dave Jiang (3):
      dmaengine: idxd: add halt interrupt support
      dmaengine: idxd: fix calling wq quiesce inside spinlock
      dmaengine: idxd: fix missed completion on abort path

David Ahern (3):
      selftests: Add duplicate config only for MD5 VRF tests
      selftests: Fix raw socket bind tests with VRF
      selftests: Fix IPv6 address bind tests

David Howells (1):
      afs: Fix mmap

Davide Caratti (1):
      net/sched: sch_ets: don't remove idle classes from the round-robin list

Dinh Nguyen (1):
      ARM: socfpga: dts: fix qspi node compatible

Eric Dumazet (3):
      sch_cake: do not call cake_destroy() from cake_init()
      inet_diag: fix kernel-infoleak for UDP sockets
      sit: do not call ipip6_dev_free() from sit_init_net()

Fabio Estevam (1):
      ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Felix Fietkau (3):
      mac80211: fix rate control for retransmitted frames
      mac80211: fix regression in SSN handling of addba tx
      mac80211: send ADDBA requests using the tid/queue of the aggregation session

Filip Pokryvka (1):
      netdevsim: don't overwrite read only ethtool parms

Filipe Manana (1):
      btrfs: fix double free of anon_dev after failure to create subvolume

Florian Fainelli (1):
      net: systemport: Add global locking for descriptor lifecycle

Florian Klink (1):
      arm64: dts: rockchip: fix poweroff on helios64

Florian Westphal (2):
      mptcp: remove tcp ulp setsockopt support
      mptcp: clear 'kern' flag from fallback sockets

Gal Pressman (1):
      net: Fix double 0x prefix print in SKB dump

George Kennedy (4):
      libata: if T_LENGTH is zero, dma direction should be DMA_NONE
      scsi: scsi_debug: Don't call kcalloc() if size arg is zero
      scsi: scsi_debug: Fix type in min_t to avoid stack OOB
      scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

Greg Kroah-Hartman (3):
      USB: gadget: bRequestType is a bitfield, not a enum
      Revert "usb: early: convert to readl_poll_timeout_atomic()"
      Linux 5.15.11

Haimin Zhang (1):
      netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Hangbin Liu (1):
      selftest/net/forwarding: declare NETIFS p9 p10

Hangyu Hua (1):
      rds: memory leak in __rds_conn_create()

Harshit Mogalapalli (1):
      drm/i915/display: Fix an unsigned subtraction which can never be negative.

Hawking Zhang (1):
      drm/amdgpu: don't override default ECO_BITs setting

Hu Weiwen (1):
      ceph: fix duplicate increment of opened_inodes metric

Ilan Peer (1):
      cfg80211: Acquire wiphy mutex on regulatory work

Jaegeuk Kim (1):
      scsi: ufs: core: Retry START_STOP on UNIT_ATTENTION

Jani Nikula (1):
      drm/i915/hdmi: convert intel_hdmi_to_dev to intel_hdmi_to_i915

Javier Martinez Canillas (1):
      Revert "drm/fb-helper: improve DRM fbdev emulation device names"

Jens Axboe (3):
      io-wq: remove spurious bit clear on task_work addition
      io-wq: check for wq exit after adding new worker task_work
      io-wq: drop wqe lock before creating new worker

Jerome Marchand (1):
      recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Ji-Ze Hong (Peter Hong) (1):
      serial: 8250_fintek: Fix garbled text for console

Jianglei Nie (1):
      btrfs: fix memory leak in __add_inode_ref()

Jiasheng Jiang (2):
      drm/ast: potential dereference of null pointer
      sfc_ef100: potential dereference of null pointer

Jie Meng (1):
      bpf, x64: Factor out emission of REX byte in more cases

Jie Wang (1):
      net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg

Jie2x Zhou (1):
      selftests: net: Correct ping6 expected rc from 2 to 1

Jimmy Wang (1):
      USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

Joe Thornber (1):
      dm btree remove: fix use after free in rebalance_children()

Johan Hovold (1):
      USB: serial: cp210x: fix CP2105 GPIO registration

Johannes Berg (6):
      mac80211: mark TX-during-stop for TX in in_reconfig
      mac80211: validate extended element ID is present
      mac80211: track only QoS data frames for admission control
      iwlwifi: mvm: don't crash on invalid rate w/o STA
      mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock
      mac80211: fix lookup when adding AddBA extension element

John Keeping (3):
      arm64: dts: rockchip: fix rk3308-roc-cc vcc-sd supply
      arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply
      net: stmmac: dwmac-rk: fix oob read in rk_gmac_setup

Jon Hunter (1):
      reset: tegra-bpmp: Revert Handle errors in BPMP response

Josef Bacik (1):
      btrfs: check WRITE_ERR when trying to read an extent buffer

Juergen Gross (6):
      x86/kvm: remove unused ack_notifier callbacks
      xen/blkfront: harden blkfront against event channel storms
      xen/netfront: harden netfront against event channel storms
      xen/console: harden hvc_xen against event channel storms
      xen/netback: fix rx queue stall detection
      xen/netback: don't queue unlimited number of packages

Karen Sornek (1):
      igb: Fix removal of unicast MAC filters of VFs

Karol Kolacinski (2):
      ice: Use div64_u64 instead of div_u64 in adjfine
      ice: Don't put stale timestamps in the skb

Lai Jiangshan (1):
      KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()

Lakshmi Ramasubramanian (1):
      arm64: kexec: Fix missing error code 'ret' warning in load_other_segments()

Lang Yu (1):
      drm/amd/pm: fix a potential gpu_metrics_table memory leak

Le Ma (1):
      drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

Letu Ren (1):
      igbvf: fix double free in `igbvf_probe`

Magnus Karlsson (2):
      xsk: Do not sleep in poll() when need_wakeup set
      Revert "xsk: Do not sleep in poll() when need_wakeup set"

Marek Behún (1):
      net: dsa: mv88e6xxx: Unforce speed & duplex in mac_link_down()

Marian Postevca (1):
      usb: gadget: u_ether: fix race in setting MAC address in setup phase

Mario Limonciello (2):
      pinctrl: amd: Fix wakeups when IRQ is shared with SCI
      drm/amd/pm: fix reading SMU FW version from amdgpu_firmware_info on YC

Martin KaFai Lau (1):
      bpf, selftests: Fix racing issue in btf_skc_cls_ingress test

Martin Kepplinger (1):
      arm64: dts: imx8mq: remove interconnect property from lcdif

Mathew McBride (1):
      arm64: dts: ten64: remove redundant interrupt declaration for gpio-keys

Matthias Schiffer (3):
      Revert "can: m_can: remove support for custom bit timing"
      can: m_can: make custom bittiming fields const
      can: m_can: pci: use custom bit timings for Elkhart Lake

Matthieu Baerts (1):
      mptcp: add missing documented NL params

Maxim Galaganov (1):
      mptcp: fix deadlock in __mptcp_push_pending()

Mike Tipton (1):
      clk: Don't parent clks until the parent is fully registered

Miklos Szeredi (2):
      fuse: annotate lock in fuse_reverse_inval_entry()
      ovl: fix warning in ovl_create_real()

Naohiro Aota (1):
      zonefs: add MODULE_ALIAS_FS

Nathan Chancellor (1):
      soc/tegra: fuse: Fix bitwise vs. logical OR warning

Nehal Bakulchandra Shah (1):
      usb: xhci: Extend support for runtime power management for AMD's Yellow carp.

Nicholas Kazlauskas (1):
      drm/amd/display: Set exit_optimized_pwr_state for DCN31

Ong Boon Leong (1):
      net: stmmac: fix tc flower deletion for VLAN priority Rx steering

Paolo Abeni (1):
      mptcp: never allow the PM to close a listener subflow

Paolo Bonzini (2):
      KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
      KVM: downgrade two BUG_ONs to WARN_ON_ONCE

Parav Pandit (1):
      vdpa: Consider device id larger than 31

Paul E. McKenney (1):
      rcu: Mark accesses to rcu_state.n_force_qs

Paul Moore (1):
      audit: improve robustness of the audit queue handling

Pavel Skripkin (1):
      media: mxl111sf: change mutex_init() location

Pawel Laszczak (4):
      usb: cdnsp: Fix incorrect status for control request
      usb: cdnsp: Fix incorrect calling of cdnsp_died function
      usb: cdnsp: Fix issue in cdnsp_log_ep trace event
      usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore

Philipp Rudo (1):
      s390/kexec_file: fix error handling when applying relocations

Po-Hsu Lin (1):
      selftests: icmp_redirect: pass xfail=0 to log_test()

Robert Schlabbach (1):
      ixgbe: Document how to enable NBASE-T support

Russell Currey (1):
      powerpc/module_64: Fix livepatching for RO modules

Sasha Neftin (1):
      igc: Fix typo in i225 LTR functions

Scott Mayhew (1):
      selinux: fix sleeping function called from invalid context

SeongJae Park (1):
      selftests/damon: test debugfs file reads/writes with huge count

Shin'ichiro Kawasaki (1):
      btrfs: fix missing blkdev_put() call in btrfs_scan_one_device()

Stefan Roese (1):
      PCI/MSI: Mask MSI-X vectors only on success

Stephan Gerhold (1):
      soc: imx: Register SoC device only on i.MX boards

Sudeep Holla (1):
      firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Sven Schnelle (1):
      s390/entry: fix duplicate tracking of irq nesting level

Tejun Heo (1):
      iocost: Fix divide-by-zero on donation from low hweight cgroup

Tetsuo Handa (1):
      tty: n_hdlc: make n_hdlc_tty_wakeup() asynchronous

Thiago Rafael Becker (1):
      cifs: sanitize multiple delimiters in prepath

Thomas Gleixner (1):
      PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Tony Lindgren (1):
      bus: ti-sysc: Fix variable set but not used warning for reinit_modules

Ville Syrjälä (1):
      drm/i915/hdmi: Turn DP++ TMDS output buffers back on in encoder->shutdown()

Vitaly Kuznetsov (2):
      KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
      KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES

Wei Wang (1):
      virtio/vsock: fix the transport to work with VMADDR_CID_ANY

Will Deacon (1):
      virtio_ring: Fix querying of maximum DMA mapping size for virtio device

Willem de Bruijn (2):
      selftests/net: toeplitz: fix udp option
      net/packet: rx_owner_map depends on pg_vec

Xiaoming Ni (1):
      powerpc/85xx: Fix oops when CONFIG_FSL_PMC=n

Xiubo Li (1):
      ceph: initialize pathlen variable in reconnect_caps_cb

Xu Yang (1):
      usb: typec: tcpm: fix tcpm unregister port but leave a pending timer

Yu Liao (1):
      timekeeping: Really make sure wall_to_monotonic isn't positive

Yufeng Mo (1):
      net: hns3: fix race condition in debugfs

Zqiang (1):
      locking/rtmutex: Fix incorrect condition in rtmutex_spin_on_owner()

