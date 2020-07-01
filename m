Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F925210CE9
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgGAN4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731364AbgGAN4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 09:56:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40F020663;
        Wed,  1 Jul 2020 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593611794;
        bh=THrwtL1ASk/b67OIGerK+sc8zrcxuuEm6We741BdzGs=;
        h=From:To:Cc:Subject:Date:From;
        b=axrX9mltnrmJGa0g5CDiP7LGmbaZzxh0FuP1a765qweJzfWkQRQmyUBDRmPrhdgcK
         jgMimJtgEl00LPDM2W9wYSG4z2QRvje36im4O+EB6wP9YHf227UK2iTuJdrjunfObq
         0mTDL9nMYDCRK6F1dsbdToS7hKZCUIULEuebNYwM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.7.7
Date:   Wed,  1 Jul 2020 09:56:31 -0400
Message-Id: <20200701135632.2689116-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.7.7 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha


 Makefile                                           |   2 +-
 arch/arm/boot/dts/am335x-pocketbeagle.dts          |   1 -
 arch/arm/boot/dts/am33xx.dtsi                      |   4 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |  10 +-
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts      |   1 +
 arch/arm/boot/dts/bcm958522er.dts                  |   4 +
 arch/arm/boot/dts/bcm958525er.dts                  |   4 +
 arch/arm/boot/dts/bcm958525xmc.dts                 |   4 +
 arch/arm/boot/dts/bcm958622hr.dts                  |   4 +
 arch/arm/boot/dts/bcm958623hr.dts                  |   4 +
 arch/arm/boot/dts/bcm958625hr.dts                  |   4 +
 arch/arm/boot/dts/bcm958625k.dts                   |   4 +
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi      |  13 ---
 .../boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi  |  13 +++
 arch/arm/boot/dts/omap4-duovero-parlor.dts         |   2 +-
 arch/arm/mach-bcm/Kconfig                          |   1 +
 arch/arm/mach-imx/pm-imx5.c                        |   6 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   2 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts       |   4 +-
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts  |   4 +-
 arch/arm64/kernel/fpsimd.c                         |   6 +-
 arch/arm64/kernel/perf_regs.c                      |  25 +++-
 arch/powerpc/mm/nohash/kaslr_booke.c               |   1 +
 arch/riscv/include/asm/cmpxchg.h                   |   8 +-
 arch/riscv/kernel/sys_riscv.c                      |   6 +
 arch/s390/include/asm/vdso.h                       |   1 +
 arch/s390/kernel/asm-offsets.c                     |   2 +-
 arch/s390/kernel/entry.S                           |   2 +-
 arch/s390/kernel/ptrace.c                          |  83 ++++++++++---
 arch/s390/kernel/time.c                            |   1 +
 arch/s390/kernel/vdso64/Makefile                   |  10 +-
 arch/s390/kernel/vdso64/clock_getres.S             |  10 +-
 arch/sparc/kernel/ptrace_32.c                      |   9 +-
 arch/x86/boot/compressed/head_64.S                 |  11 +-
 arch/x86/include/asm/cpu.h                         |   5 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/mwait.h                       |   2 -
 arch/x86/include/asm/processor.h                   |   3 +-
 arch/x86/include/asm/resctrl_sched.h               |   3 +
 arch/x86/kernel/cpu/centaur.c                      |   1 +
 arch/x86/kernel/cpu/common.c                       |  51 +++-----
 arch/x86/kernel/cpu/cpu.h                          |   4 -
 arch/x86/kernel/cpu/resctrl/core.c                 |  29 +++++
 arch/x86/kernel/cpu/resctrl/internal.h             |   1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   1 +
 arch/x86/kernel/cpu/umwait.c                       |   6 -
 arch/x86/kernel/cpu/zhaoxin.c                      |   1 +
 arch/x86/kvm/lapic.c                               |   1 +
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   7 +-
 arch/x86/kvm/vmx/vmx.c                             |  27 +----
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/lib/usercopy_64.c                         |   1 +
 arch/x86/power/cpu.c                               |   6 +
 block/bio-integrity.c                              |   1 -
 block/blk-mq.c                                     |   4 +-
 drivers/acpi/acpi_configfs.c                       |   6 +-
 drivers/acpi/sysfs.c                               |   4 +-
 drivers/android/binder.c                           |  14 +--
 drivers/ata/libata-scsi.c                          |   9 +-
 drivers/ata/sata_rcar.c                            |  11 +-
 drivers/base/regmap/regmap.c                       |   1 +
 drivers/block/loop.c                               |   8 +-
 drivers/bus/ti-sysc.c                              |  98 ++++++++++++----
 drivers/char/hw_random/ks-sa-rng.c                 |   1 +
 drivers/clk/sifive/fu540-prci.c                    |   5 +-
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/firmware/efi/esrt.c                        |   2 +-
 drivers/firmware/efi/libstub/file.c                |  16 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   6 +-
 .../drm/amd/display/modules/color/color_gamma.c    |   2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  63 +++++++---
 drivers/gpu/drm/panel/panel-simple.c               |   2 +
 drivers/gpu/drm/radeon/ni_dpm.c                    |   2 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |   1 +
 drivers/i2c/busses/i2c-fsi.c                       |   2 +-
 drivers/i2c/busses/i2c-tegra.c                     |   9 --
 drivers/i2c/i2c-core-smbus.c                       |   7 ++
 drivers/infiniband/core/cma.c                      |  18 +++
 drivers/infiniband/core/mad.c                      |   3 +-
 drivers/infiniband/core/rdma_core.c                |  36 +++---
 drivers/infiniband/hw/efa/efa_verbs.c              |   1 +
 drivers/infiniband/hw/hfi1/debugfs.c               |  19 +--
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |  13 ++-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |   3 +-
 drivers/iommu/dmar.c                               |   3 +-
 drivers/iommu/intel-iommu.c                        |  18 ++-
 drivers/md/bcache/super.c                          |  22 +++-
 drivers/md/dm-writecache.c                         |   4 +
 drivers/misc/mei/hw-me-regs.h                      |   3 +
 drivers/misc/mei/hw-me.c                           |  70 ++++++++++-
 drivers/misc/mei/hw-me.h                           |  17 ++-
 drivers/misc/mei/pci-me.c                          |  17 +--
 drivers/net/bareudp.c                              |   3 +
 drivers/net/dsa/bcm_sf2.c                          |   2 +
 drivers/net/ethernet/atheros/alx/main.c            |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  36 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   8 +-
 drivers/net/ethernet/broadcom/tg3.c                |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           | 128 +++++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |  52 ++++-----
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  23 ++--
 drivers/net/ethernet/freescale/enetc/enetc.c       |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  21 +++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   8 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  21 +++-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |  21 +++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   2 -
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |   1 -
 drivers/net/ethernet/qlogic/qed/qed_vf.c           |  23 +++-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |  31 +++--
 drivers/net/ethernet/qlogic/qede/qede_ptp.h        |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_rdma.c       |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/rocker/rocker_main.c          |   4 +-
 drivers/net/ethernet/socionext/netsec.c            |   5 +-
 drivers/net/geneve.c                               |   1 +
 drivers/net/phy/Kconfig                            |   3 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |  40 ++-----
 drivers/net/phy/phy_device.c                       |   6 +-
 drivers/net/phy/phylink.c                          |  45 +++++---
 drivers/net/phy/smsc.c                             |  11 +-
 drivers/net/usb/ax88179_178a.c                     |  11 +-
 drivers/net/wireguard/device.c                     |  58 +++++-----
 drivers/net/wireguard/device.h                     |   3 +-
 drivers/net/wireguard/netlink.c                    |  14 ++-
 drivers/net/wireguard/receive.c                    |  10 +-
 drivers/net/wireguard/socket.c                     |  25 ++--
 drivers/net/wireless/ath/wil6210/txrx.c            |  39 ++-----
 drivers/nvdimm/region_devs.c                       |  14 +--
 drivers/nvme/host/multipath.c                      |  12 +-
 drivers/nvme/target/core.c                         |  40 ++++---
 drivers/of/of_mdio.c                               |   9 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  21 ++--
 drivers/pinctrl/tegra/pinctrl-tegra.c              |   4 +-
 drivers/regulator/da9063-regulator.c               |   1 -
 drivers/regulator/pfuze100-regulator.c             |  60 ++++++----
 drivers/s390/net/qeth_core_main.c                  |   5 +-
 drivers/s390/scsi/zfcp_erp.c                       |  13 ++-
 drivers/scsi/lpfc/lpfc_init.c                      |   3 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |   4 +-
 drivers/soc/imx/soc-imx8m.c                        |   8 +-
 drivers/spi/spi-fsl-dspi.c                         |   8 +-
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |   4 +-
 drivers/tty/hvc/hvc_console.c                      |  16 +--
 drivers/usb/cdns3/ep0.c                            |  10 +-
 drivers/usb/cdns3/trace.h                          |   2 +-
 drivers/usb/class/cdc-acm.c                        |   2 +
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/dwc2/gadget.c                          |   6 -
 drivers/usb/dwc2/platform.c                        |  11 ++
 drivers/usb/dwc3/dwc3-exynos.c                     |   9 --
 drivers/usb/gadget/udc/mv_udc_core.c               |   3 +-
 drivers/usb/host/ehci-exynos.c                     |   5 +-
 drivers/usb/host/ehci-pci.c                        |   7 ++
 drivers/usb/host/ohci-sm501.c                      |   1 +
 drivers/usb/host/xhci-mtk.c                        |   5 +-
 drivers/usb/host/xhci.c                            |   9 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/renesas_usbhs/fifo.c                   |  23 ++--
 drivers/usb/renesas_usbhs/fifo.h                   |   2 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |  13 ++-
 drivers/usb/typec/tcpm/tcpci_rt1711h.c             |  31 ++---
 drivers/video/fbdev/core/fbcon.c                   |   3 +-
 fs/afs/cell.c                                      |   9 ++
 fs/afs/internal.h                                  |   2 +-
 fs/btrfs/block-group.c                             |  19 ++-
 fs/btrfs/ctree.h                                   |   2 +
 fs/btrfs/file.c                                    |  15 ++-
 fs/btrfs/inode.c                                   |  39 +++++--
 fs/btrfs/tree-log.c                                |   5 +
 fs/cifs/smb2ops.c                                  |  12 ++
 fs/erofs/zdata.h                                   |  20 ++--
 fs/io_uring.c                                      |   9 +-
 fs/nfs/direct.c                                    |  13 ++-
 fs/nfs/file.c                                      |   1 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |  11 +-
 fs/ocfs2/dlmglue.c                                 |  17 ++-
 fs/ocfs2/ocfs2.h                                   |   1 +
 fs/ocfs2/ocfs2_fs.h                                |   4 +-
 fs/ocfs2/suballoc.c                                |   9 +-
 include/linux/intel-iommu.h                        |   1 +
 include/linux/netdevice.h                          |   2 +-
 include/linux/qed/qed_chain.h                      |  26 +++--
 include/linux/syscalls.h                           |   2 +-
 include/linux/tpm_eventlog.h                       |  14 ++-
 include/net/sctp/constants.h                       |   8 +-
 include/net/sock.h                                 |   1 -
 include/net/xfrm.h                                 |   1 +
 include/uapi/linux/fb.h                            |   1 +
 kernel/bpf/cgroup.c                                |  53 +++++----
 kernel/bpf/devmap.c                                |  10 +-
 kernel/dma/direct.c                                |  26 ++++-
 kernel/kprobes.c                                   |   3 +-
 kernel/sched/core.c                                |   3 +-
 kernel/sched/deadline.c                            |   1 +
 kernel/sched/fair.c                                |   2 +-
 kernel/trace/blktrace.c                            |  13 +++
 kernel/trace/ring_buffer.c                         |   2 +-
 kernel/trace/trace_boot.c                          |   8 +-
 kernel/trace/trace_events_trigger.c                |  21 +++-
 lib/test_objagg.c                                  |   4 +-
 mm/compaction.c                                    |  17 ++-
 mm/memcontrol.c                                    |  13 ++-
 mm/memory_hotplug.c                                |  13 ++-
 mm/slab.h                                          |   4 +-
 mm/slab_common.c                                   |   2 +-
 net/bridge/br_private.h                            |   2 +-
 net/core/dev.c                                     |   9 ++
 net/core/sock.c                                    |   4 +-
 net/ethtool/common.c                               |   2 +
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/ip_tunnel.c                               |  14 ++-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv4/tcp_input.c                               |  26 ++++-
 net/ipv6/ip6_gre.c                                 |   9 +-
 net/ipv6/mcast.c                                   |   1 +
 net/mptcp/options.c                                |   2 -
 net/mptcp/subflow.c                                |   4 +-
 net/netfilter/ipset/ip_set_core.c                  |   2 +
 net/netlink/genetlink.c                            |  28 ++---
 net/openvswitch/actions.c                          |   9 +-
 net/rxrpc/call_accept.c                            |   7 ++
 net/rxrpc/input.c                                  |   7 +-
 net/sched/sch_cake.c                               |  58 +++++++---
 net/sctp/associola.c                               |   5 +-
 net/sctp/bind_addr.c                               |   1 +
 net/sctp/protocol.c                                |   3 +-
 net/sunrpc/rpc_pipe.c                              |   1 +
 net/sunrpc/xdr.c                                   |   4 +
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   9 +-
 net/xfrm/xfrm_device.c                             |   4 +-
 samples/bpf/xdp_monitor_user.c                     |   8 +-
 samples/bpf/xdp_redirect_cpu_kern.c                |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |  34 +++---
 samples/bpf/xdp_rxq_info_user.c                    |  13 +--
 scripts/Kbuild.include                             |  11 +-
 scripts/recordmcount.h                             |  98 +++++++++++++++-
 sound/pci/hda/patch_hdmi.c                         |   5 +
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/fsl/fsl_ssi.c                            |  13 ++-
 sound/soc/qcom/common.c                            |  14 ++-
 sound/soc/qcom/qdsp6/q6afe.c                       |   8 ++
 sound/soc/qcom/qdsp6/q6afe.h                       |   1 +
 sound/soc/qcom/qdsp6/q6asm.c                       |   7 +-
 sound/soc/rockchip/rockchip_pdm.c                  |   4 +-
 sound/soc/soc-pcm.c                                |   6 +-
 sound/usb/format.c                                 |   6 +-
 sound/usb/mixer.c                                  |  15 ++-
 sound/usb/mixer.h                                  |   9 +-
 sound/usb/mixer_quirks.c                           |   3 +-
 sound/usb/pcm.c                                    |   2 +
 sound/usb/quirks.c                                 |  10 ++
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |   5 +-
 tools/testing/selftests/net/so_txtime.c            |  33 ++++--
 tools/testing/selftests/powerpc/pmu/ebb/Makefile   |   2 +-
 tools/testing/selftests/wireguard/netns.sh         |  13 ++-
 272 files changed, 1999 insertions(+), 1037 deletions(-)

Aaron Plattner (1):
      ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table

Adam Ford (1):
      drm/panel-simple: fix connector type for LogicPD Type28 Display

Aditya Pakki (3):
      rocker: fix incorrect error handling in dma_rings_init
      RDMA/rvt: Fix potential memory leak caused by rvt_alloc_rq
      test_objagg: Fix potential memory leak in error handling

Al Cooper (1):
      xhci: Fix enumeration issue when setting max packet size for FS devices.

Al Viro (1):
      fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"

Alexander Lobakin (10):
      net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
      net: ethtool: add missing NETIF_F_GSO_FRAGLIST feature string
      net: qed: fix left elements count calculation
      net: qed: fix async event callbacks unregistering
      net: qede: stop adding events on an already destroyed workqueue
      net: qed: fix NVMe login fails over VFs
      net: qed: fix excessive QM ILT lines consumption
      net: qede: fix PTP initialization on recovery
      net: qede: fix use-after-free on recovery and AER handling
      net: qed: reset ILT block sizes before recomputing to fix crashes

Alexander Usyskin (1):
      mei: me: add tiger lake point device ids for H platforms.

Anand Moon (1):
      Revert "usb: dwc3: exynos: Add support for Exynos5422 suspend clk"

Anson Huang (1):
      soc: imx8m: Correct i.MX8MP UID fuse offset

Ard Biesheuvel (1):
      net: phy: mscc: avoid skcipher API for single block AES encryption

Arseny Solokha (1):
      powerpc/fsl_booke/32: Fix build with CONFIG_RANDOMIZE_BASE

Arvind Sankar (1):
      efi/x86: Setup stack correctly for efi_pe_entry

Babu Moger (1):
      x86/resctrl: Fix memory bandwidth counter width for AMD

Ben Widawsky (1):
      mm/memory_hotplug.c: fix false softlockup during pfn range removal

Bernard Zhao (1):
      drm/amd: fix potential memleak in err branch

Borislav Petkov (1):
      EDAC/amd64: Read back the scrub rate PCI register on F15h

Chaitanya Kulkarni (1):
      nvmet: fail outstanding host posted AEN req

Charles Keepax (1):
      regmap: Fix memory leak from regmap_register_patch

Christoffer Nielsen (1):
      ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S

Christopher Swenson (1):
      ALSA: usb-audio: Set 48 kHz rate for Rodecaster

Chuck Lever (2):
      SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
      xprtrdma: Fix handling of RDMA_ERROR replies

Chuhong Yuan (1):
      USB: ohci-sm501: Add missed iounmap() in remove

Claudiu Beznea (3):
      net: macb: undo operations in case of failure
      net: macb: call pm_runtime_put_sync on failure path
      net: macb: free resources on failure path of at91ether_open()

Claudiu Manoil (1):
      enetc: Fix tx rings bitmap iteration range, irq handling

Colin Ian King (1):
      qed: add missing error test for DBG_STATUS_NO_MATCHING_FRAMING_MODE

Cong Wang (1):
      genetlink: clean up family attributes allocations

Dan Carpenter (3):
      x86/resctrl: Fix a NULL vs IS_ERR() static checker warning in rdt_cdp_peer_get()
      usb: gadget: udc: Potential Oops in error handling code
      Staging: rtl8723bs: prevent buffer overflow in update_sta_support_rate()

Daniel Gomez (1):
      drm: rcar-du: Fix build error

Daniel Vetter (1):
      drm/fb-helper: Fix vt restore

David Christensen (1):
      tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (3):
      rxrpc: Fix notification call on completion of discarded calls
      rxrpc: Fix handling of rwind from an ACK packet
      afs: Fix storage of cell names

David Milburn (1):
      nvmet: cleanups the loop in nvmet_async_events_process

David Rientjes (3):
      dma-direct: re-encrypt memory if dma_direct_alloc_pages() fails
      dma-direct: check return value when encrypting or decrypting memory
      dma-direct: add missing set_memory_decrypted() for coherent mapping

Dejin Zheng (1):
      net: phy: smsc: fix printing too many logs

Denis Efremov (2):
      drm/amd/display: Use kfree() to free rgb_user in calculate_user_regamma_ramp()
      drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Denis Kirjanov (1):
      tcp: don't ignore ECN CWR on pure ACK

Dennis Dalessandro (1):
      IB/hfi1: Fix module use count flaw due to leftover module put calls

Dinghao Liu (1):
      hwrng: ks-sa - Fix runtime PM imbalance on error

Dmitry Baryshkov (1):
      pinctrl: qcom: spmi-gpio: fix warning about irq chip reusage

Doug Berger (1):
      net: bcmgenet: use hardware padding of runt frames

Drew Fustini (1):
      ARM: dts: am335x-pocketbeagle: Fix mmc0 Write Protect

Eddie James (1):
      i2c: fsi: Fix the port number field in status register

Eric Dumazet (2):
      net: increment xmit_recursion level in dev_direct_xmit()
      tcp: grow window for OOO packets only for SACK flows

Fabian Vogt (1):
      efi/tpm: Verify event log header before parsing

Fan Guo (1):
      RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()

Filipe Manana (7):
      btrfs: fix a block group ref counter leak after failure to remove block group
      btrfs: fix bytes_may_use underflow when running balance and scrub in parallel
      btrfs: fix data block group relocation failure due to concurrent scrub
      btrfs: check if a log root exists before locking the log_mutex on unlink
      btrfs: fix hang on snapshot creation after RWF_NOWAIT write
      btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
      btrfs: fix RWF_NOWAIT write not failling when we need to cow

Florian Fainelli (3):
      net: phy: Check harder for errors in get_phy_id()
      of: of_mdio: Correct loop scanning logic
      net: dsa: bcm_sf2: Fix node reference count

Frieder Schrempf (2):
      ARM: dts: imx6ul-kontron: Move watchdog from Kontron i.MX6UL/ULL board to SoM
      ARM: dts: imx6ul-kontron: Change WDOG_ANY signal from push-pull to open-drain

Gal Pressman (1):
      RDMA/efa: Set maximum pkeys device attribute

Gao Xiang (1):
      erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup

Gaurav Singh (2):
      ethtool: Fix check in ethtool_rx_flow_rule_create
      bpf, xdp, samples: Fix null pointer dereference in *_user code

Geliang Tang (1):
      mptcp: drop sndr_key in mptcp_syn_options

Greg Kroah-Hartman (1):
      Revert "tty: hvc: Fix data abort due to race in hvc_open"

Harish (1):
      selftests/powerpc: Fix build failure in ebb tests

Heikki Krogerus (1):
      usb: typec: mux: intel_pmc_mux: Fix DP alternate mode entry

Heiner Kallweit (1):
      r8169: fix firmware not resetting tp->ocp_base

Huaisheng Ye (1):
      dm writecache: correct uncommitted_block when discarding uncommitted entry

Huy Nguyen (1):
      xfrm: Fix double ESP trailer insertion in IPsec crypto offload.

Ido Schimmel (1):
      mlxsw: spectrum: Do not rely on machine endianness

Igor Mammedov (1):
      kvm: lapic: fix broken vcpu hotplug

Ilya Ponetayev (1):
      sch_cake: don't try to reallocate or unshare skb unconditionally

Jason A. Donenfeld (5):
      wireguard: device: avoid circular netns references
      wireguard: receive: account for napi_gro_receive never returning GRO_DROP
      socionext: account for napi_gro_receive never returning GRO_DROP
      wil6210: account for napi_gro_receive never returning GRO_DROP
      ACPI: configfs: Disallow loading ACPI tables when locked down

Jeremy Kerr (1):
      net: usb: ax88179_178a: fix packet alignment padding

Jiping Ma (1):
      arm64: perf: Report the PC value in REGS_ABI_32 mode

Jiri Slaby (1):
      syscalls: Fix offset type of ksys_ftruncate()

Joakim Tjernlund (1):
      cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip

Johannes Weiner (1):
      mm: memcontrol: handle div0 crash race condition in memory.low

John van der Kamp (1):
      drm/amdgpu/display: Unlock mutex on error

Julian Wiedmann (1):
      s390/qeth: fix error handling for isolation mode cmds

Junxiao Bi (4):
      ocfs2: avoid inode removal while nfsd is accessing it
      ocfs2: load global_inode_alloc
      ocfs2: fix value of OCFS2_INVALID_SLOT
      ocfs2: fix panic on nfs server over ocfs2

Juri Lelli (2):
      sched/deadline: Initialize ->dl_boosted
      sched/core: Fix PI boosting between RT and DEADLINE tasks

Kai-Heng Feng (3):
      xhci: Poll for U0 after disabling USB2 LPM
      xhci: Return if xHCI doesn't support LPM
      ALSA: hda/realtek: Add mute LED and micmute LED support for HP systems

Kees Cook (1):
      x86/cpu: Use pinning mask for CR4 bits needing to be 0

Krzysztof Kozlowski (1):
      spi: spi-fsl-dspi: Free DMA memory with matching function

Laurence Tratt (1):
      ALSA: usb-audio: Add implicit feedback quirk for SSL2+.

Leon Romanovsky (1):
      RDMA/core: Check that type_attrs is not NULL prior access

Li Jun (1):
      usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs

Longfang Liu (1):
      USB: ehci: reopen solution for Synopsys HC bug

Lorenzo Bianconi (2):
      openvswitch: take into account de-fragmentation/gso_size in execute_check_pkt_len
      samples/bpf: xdp_redirect_cpu: Set MAX_CPUS according to NR_CPUS

Lu Baolu (3):
      iommu/vt-d: Set U/S bit in first level page table by default
      iommu/vt-d: Enable PCI ACS for platform opt in hint
      iommu/vt-d: Update scalable mode paging structure coherency

Luis Chamberlain (1):
      blktrace: break out of blktrace setup on concurrent calls

Macpaul Lin (2):
      usb: host: xhci-mtk: avoid runtime suspend when removing hcd
      ALSA: usb-audio: add quirk for Samsung USBC Headset (AKG)

Mans Rullgard (1):
      i2c: core: check returned size of emulated smbus block read

Marcelo Ricardo Leitner (1):
      sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Mark Zhang (1):
      RDMA/cma: Protect bind_list and listen_list while finding matching cm id

Martin (1):
      bareudp: Fixed multiproto mode configuration

Martin Fuzzey (1):
      regulator: da9063: fix LDO9 suspend and warning.

Masahiro Yamada (1):
      kbuild: improve cc-option to clean up all temporary files

Masami Hiramatsu (2):
      kprobes: Suppress the suspicious RCU warning on kprobes
      tracing: Fix event trigger to accept redundant spaces

Mathias Nyman (1):
      xhci: Fix incorrect EP_STATE_MASK

Matt Fleming (1):
      x86/asm/64: Align start of __clear_user() loop to 16-bytes

Matthew Hagan (3):
      ARM: bcm: Select ARM_TIMER_SP804 for ARCH_BCM_NSP
      ARM: dts: NSP: Disable PL330 by default, add dma-coherent property
      ARM: dts: NSP: Correct FA2 mailbox node

Mauricio Faria de Oliveira (1):
      bcache: check and adjust logical block size for backing devices

Michael Chan (3):
      bnxt_en: Store the running firmware version code.
      bnxt_en: Do not enable legacy TX push on older firmware.
      bnxt_en: Fix statistics counters issue during ifdown with older firmware.

Michal Kalderon (1):
      RDMA/qedr: Fix KASAN: use-after-free in ucma_event_handler+0x532

Mikulas Patocka (1):
      dm writecache: add cond_resched to loop in persistent_memory_claim()

Minas Harutyunyan (1):
      usb: dwc2: Postponed gadget registration to the udc class driver

Muchun Song (1):
      mm/memcontrol.c: add missed css_put()

Nathan Chancellor (2):
      s390/vdso: Use $(LD) instead of $(CC) to link vDSO
      ACPI: sysfs: Fix pm_profile_attr type

Nathan Huckleberry (1):
      riscv/atomic: Fix sign extension for RV64I

Navid Emamdoost (1):
      sata_rcar: handle pm_runtime_get_sync failure cases

Neal Cardwell (2):
      tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT
      bpf: tcp: bpf_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Olga Kornievskaia (1):
      NFSv4 fix CLOSE not waiting for direct IO compeletion

Oskar Holmlund (2):
      ARM: dts: Fix am33xx.dtsi USB ranges length
      ARM: dts: Fix am33xx.dtsi ti,sysc-mask wrong softreset flag

Pavel Begunkov (1):
      io_uring: fix hanging iopoll in case of -EAGAIN

Peter Chen (3):
      usb: cdns3: trace: using correct dir value
      usb: cdns3: ep0: fix the test mode set incorrectly
      usb: cdns3: ep0: add spinlock for cdns3_check_new_setup

Philipp Fent (1):
      efi/libstub: Fix path separator regression

Pierre-Louis Bossart (1):
      ASoC: soc-pcm: fix checks for multi-cpu FE dailinks

Qiushi Wu (2):
      efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
      ASoC: rockchip: Fix a reference count leak.

Rafał Miłecki (1):
      ARM: dts: BCM5301X: Add missing memory "device_type" for Luxul XWC-2000

Rahul Lakkireddy (2):
      cxgb4: move handling L2T ARP failures to caller
      cxgb4: move PTP lock and unlock to caller in Tx path

Reinette Chatre (2):
      x86/cpu: Move resctrl CPUID code to resctrl/
      x86/resctrl: Support CPUID enumeration of MBM counter width

Robin Gong (3):
      regualtor: pfuze100: correct sw1a/sw2 on pfuze3000
      arm64: dts: imx8mm-evk: correct ldo1/ldo2 voltage range
      arm64: dts: imx8mn-ddr4-evk: correct ldo1/ldo2 voltage range

Roman Bolshakov (1):
      scsi: qla2xxx: Keep initiator ports after RSCN

Russell King (3):
      net: phylink: fix ethtool -A with attached PHYs
      net: phylink: ensure manual pause mode configuration takes effect
      netfilter: ipset: fix unaligned atomic access

Sabrina Dubroca (1):
      geneve: allow changing DF behavior after creation

Sagi Grimberg (1):
      nvme: don't protect ns mutation with ns->head->lock

Sami Tolvanen (1):
      recordmcount: support >64k sections

Sascha Ortmann (1):
      tracing/boottime: Fix kprobe multiple events

Sasha Levin (1):
      Linux 5.7.7

Sean Christopherson (3):
      KVM: nVMX: Plumb L2 GPA through to PML emulation
      KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
      x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup

SeongJae Park (1):
      scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()

Shannon Nelson (2):
      ionic: update the queue count on open
      ionic: tame the watchdog timer on reconfig

Shay Drory (1):
      IB/mad: Fix use after free when destroying MAD agent

Shengjiu Wang (1):
      ASoC: fsl_ssi: Fix bclk calculation for mono channel

Srinivas Kandagatla (3):
      ASoC: q6asm: handle EOS correctly
      ASoc: q6afe: add support to get port direction
      ASoC: qcom: common: set correct directions for dailinks

Stanislav Fomichev (1):
      bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE

Steffen Maier (1):
      scsi: zfcp: Fix panic on ERP timeout for previously dismissed ERP action

Steven Rostedt (VMware) (1):
      ring-buffer: Zero out time extend if it is nested and not absolute

Stylon Wang (1):
      drm/amd/display: Enable output_bpc property on all outputs

Sven Auhagen (1):
      mvpp2: ethtool rxtx stats fix

Sven Schnelle (4):
      s390/seccomp: pass syscall arguments via seccomp_data
      s390/ptrace: return -ENOSYS when invalid syscall is supplied
      s390/ptrace: pass invalid syscall numbers to tracing
      s390/ptrace: fix setting syscall number

Taehee Yoo (3):
      net: core: reduce recursion limit value
      ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
      ip_tunnel: fix use-after-free in ip_tunnel_lookup()

Takashi Iwai (3):
      ALSA: usb-audio: Fix potential use-after-free of streams
      ALSA: usb-audio: Fix OOB access of mixer element list
      ALSA: hda/realtek - Add quirk for MSI GE63 laptop

Tang Bin (1):
      usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

Tariq Toukan (1):
      net: Do not clear the sock TX queue in sk_set_socket()

Thierry Reding (1):
      Revert "i2c: tegra: Fix suspending in active runtime PM state"

Thomas Falcon (2):
      ibmveth: Fix max MTU limit
      ibmvnic: Harden device login requests

Thomas Martitz (1):
      net: bridge: enfore alignment for ethernet address

Todd Kjos (1):
      binder: fix null deref of proc->context

Toke Høiland-Jørgensen (3):
      sch_cake: don't call diffserv parsing code when it is not needed
      sch_cake: fix a few style nits
      devmap: Use bpf_map_area_alloc() for allocating hash buckets

Tom Seewald (1):
      RDMA/siw: Fix pointer-to-int-cast warning in siw_rx_pbl()

Tomas Winkler (1):
      mei: me: disable mei interface on Mehlow server platforms

Tomasz Meresiński (1):
      usb: add USB_QUIRK_DELAY_INIT for Logitech C922

Tomi Valkeinen (1):
      drm/panel-simple: fix connector type for newhaven_nhd_43_480272ef_atxl

Tony Lindgren (6):
      bus: ti-sysc: Flush posted write on enable and disable
      bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit
      bus: ti-sysc: Ignore clockactivity unless specified as a quirk
      bus: ti-sysc: Fix uninitialized framedonetv_irq
      ARM: OMAP2+: Fix legacy mode dss_reset
      ARM: dts: Fix duovero smsc interrupt for suspend

Trond Myklebust (1):
      pNFS/flexfiles: Fix list corruption if the mirror count changes

Vasily Averin (1):
      sunrpc: fixed rollback in rpc_gssd_dummy_populate()

Vasundhara Volam (1):
      bnxt_en: Read VPD info only for PFs

Vidya Sagar (1):
      pinctrl: tegra: Use noirq suspend/resume callbacks

Vincent Chen (1):
      clk: sifive: allocate sufficient memory for struct __prci_data

Vincent Guittot (1):
      sched/cfs: change initial value of runnable_avg

Vincenzo Frascino (1):
      s390/vdso: fix vDSO clock_getres()

Vishal Verma (1):
      nvdimm/region: always show the 'align' attribute

Vitaly Kuznetsov (1):
      Revert "KVM: VMX: Micro-optimize vmexit time when not exposing PMU"

Vlastimil Babka (1):
      mm, compaction: make capture control handling safe wrt interrupts

Waiman Long (2):
      mm, slab: fix sign conversion problem in memcg_uncharge_slab()
      mm/slab: use memzero_explicit() in kzfree()

Wang Hai (1):
      mld: fix memory leak in ipv6_mc_destroy_dev()

Wei Yongjun (1):
      mptcp: fix memory leak in mptcp_subflow_create_socket()

Weiping Zhang (1):
      block: update hctx map when use multiple maps

Wenhui Sheng (1):
      drm/amdgpu: add fw release for sdma v5_0

Will Deacon (1):
      arm64: sve: Fix build failure when ARM64_SVE=y and SYSCTL=n

Willem de Bruijn (1):
      selftests/net: report etf errors correctly

Xiaoyao Li (1):
      KVM: X86: Fix MSR range of APIC registers in X2APIC mode

Xiyu Yang (1):
      cifs: Fix cached_fid refcnt leak in open_shroot

Yang Yingliang (1):
      net: fix memleak in register_netdevice()

Yash Shah (1):
      RISC-V: Don't allow write+exec only page mapping request in mmap

Ye Bin (1):
      ata/libata: Fix usage of page address by page_address in ata_scsi_mode_select_xlat function

Yick W. Tse (1):
      ALSA: usb-audio: add quirk for Denon DCD-1500RE

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: getting residue from callback_result

Zekun Shen (1):
      net: alx: fix race condition in alx_remove

Zhang Xiaoxu (2):
      cifs/smb3: Fix data inconsistent when punch hole
      cifs/smb3: Fix data inconsistent when zero file range

Zheng Bin (1):
      loop: replace kill_bdev with invalidate_bdev

guodeqing (1):
      net: Fix the arp error in some cases

yu kuai (2):
      block/bio-integrity: don't free 'buf' if bio_integrity_add_page() failed
      ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAl78lgUACgkQ3qZv95d3
LNzHJw/0CqFMuGyCrICVrYEnVz77+EweEtyxKAIkWlM3HFttRhmmNXn2l6oxe1Lf
hgjOUkqAO65TmzrDsmpG5JnUEeXVzi3UXy9Zkys38LUqri9lTRT0gOzeiNVI8aiv
jZfOI2tbnal869c0ucCnfg/FORrBOoIBsqTN7hK9yJJN2K462niDnnUJaBJEmZ4N
FFyHmIr4oj3V8ytq2RNEy1vAGrnVLFFJ5SjoOGFki/H+86YxoNq9xk2d+LxW//vM
ficOjhgE5HItTyjo9HpV8fLLDZJa1UUAQKcJU48UjOSlIu3pDpn2xmACiNU9+M+x
iequP7hKbqi3phtw/QenFYn4pp/smErIjpTNyG/APZnk0KxQepF9u9Jtc/ZJ3hZt
e7gKsEGFEwSOLlTpSfrnLsCZ3gojbcP0KX76+gXt0doCNZgV8GGrZ3jLMXYgcV0b
/fWUMvqhkoZLEqVVMeSt5MPTtHt8GnDghKF07i2DGCFAjfHUG+q7Hrv/IpPjclwH
jrx1NWtNbMrXVrwlNSvY1zwvs4Rxw++kt1kvqV/5fz1vPY7X1Letlmq4ypxzsCzK
nS0teYeDbLJkborUPDGCwIi54ypF5tDnX5JAIrZfSjoolJdLwZ9MR+PikhSDY57y
ltJg+UrZKD1GO2UO4cBLq7nz/ij4c2rGi/YCbWeyyoOxKyIitw==
=EZPb
-----END PGP SIGNATURE-----
