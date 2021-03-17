Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFB933F680
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhCQRTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231596AbhCQRTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E9164E0F;
        Wed, 17 Mar 2021 17:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616001556;
        bh=5DqdQTmL58bAPvfdlFaCmRLfbXibuHh92LC3Sj7vAjY=;
        h=From:To:Cc:Subject:Date:From;
        b=Z01xZPAkvNJOODCzifpZe/Ztc3gioRShdrcV0U2X4OXB/FExX6ki9o6KB0FEATj9O
         pTtNgCYAOpiuomQA2cALNti1H6TSlXowUe4eKpwCGlqd/XA9siXt+01nCJTwktdOD1
         dhuxcF9tPN+qcTeaSVLe3IYDTsqFzvXmq9RXqSsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.24
Date:   Wed, 17 Mar 2021 18:19:08 +0100
Message-Id: <1616001548169209@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.24 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-memory                      |    5 
 Documentation/admin-guide/mm/memory-hotplug.rst                     |    4 
 Documentation/gpu/todo.rst                                          |   21 +
 Documentation/networking/netdev-FAQ.rst                             |   78 ---
 Documentation/process/stable-kernel-rules.rst                       |    6 
 Documentation/process/submitting-patches.rst                        |    5 
 Documentation/virt/kvm/api.rst                                      |    3 
 Makefile                                                            |   14 
 arch/arm/boot/compressed/head.S                                     |    3 
 arch/arm/include/asm/assembler.h                                    |   84 ++++
 arch/arm/kernel/iwmmxt.S                                            |   89 ++--
 arch/arm/kernel/iwmmxt.h                                            |   47 ++
 arch/arm64/include/asm/kvm_asm.h                                    |    4 
 arch/arm64/include/asm/kvm_hyp.h                                    |    8 
 arch/arm64/include/asm/memory.h                                     |    5 
 arch/arm64/include/asm/mmu_context.h                                |    5 
 arch/arm64/include/asm/pgtable-prot.h                               |    1 
 arch/arm64/include/asm/pgtable.h                                    |    3 
 arch/arm64/kernel/head.S                                            |    2 
 arch/arm64/kernel/perf_event.c                                      |    2 
 arch/arm64/kvm/arm.c                                                |    7 
 arch/arm64/kvm/hyp/entry.S                                          |    2 
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                                  |   12 
 arch/arm64/kvm/hyp/nvhe/host.S                                      |   20 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                                  |    4 
 arch/arm64/kvm/hyp/nvhe/switch.c                                    |   14 
 arch/arm64/kvm/hyp/nvhe/tlb.c                                       |    3 
 arch/arm64/kvm/hyp/pgtable.c                                        |    1 
 arch/arm64/kvm/hyp/vhe/tlb.c                                        |    3 
 arch/arm64/kvm/mmu.c                                                |    3 
 arch/arm64/kvm/reset.c                                              |   12 
 arch/arm64/mm/init.c                                                |   12 
 arch/arm64/mm/mmu.c                                                 |    5 
 arch/mips/crypto/Makefile                                           |    4 
 arch/powerpc/include/asm/code-patching.h                            |    2 
 arch/powerpc/include/asm/machdep.h                                  |    3 
 arch/powerpc/include/asm/ptrace.h                                   |    7 
 arch/powerpc/include/asm/switch_to.h                                |   10 
 arch/powerpc/kernel/asm-offsets.c                                   |    2 
 arch/powerpc/kernel/exceptions-64s.S                                |    2 
 arch/powerpc/kernel/head_book3s_32.S                                |    9 
 arch/powerpc/kernel/pci-common.c                                    |   10 
 arch/powerpc/kernel/process.c                                       |    2 
 arch/powerpc/kernel/traps.c                                         |    5 
 arch/powerpc/perf/core-book3s.c                                     |   23 -
 arch/powerpc/platforms/pseries/msi.c                                |   25 +
 arch/s390/kernel/smp.c                                              |    2 
 arch/sparc/include/asm/mman.h                                       |   54 +-
 arch/sparc/mm/init_32.c                                             |    3 
 arch/x86/entry/common.c                                             |   37 -
 arch/x86/entry/entry_64_compat.S                                    |    2 
 arch/x86/events/intel/core.c                                        |    5 
 arch/x86/include/asm/idtentry.h                                     |    3 
 arch/x86/include/asm/insn-eval.h                                    |    2 
 arch/x86/include/asm/proto.h                                        |    1 
 arch/x86/include/asm/ptrace.h                                       |   15 
 arch/x86/kernel/cpu/mce/core.c                                      |    6 
 arch/x86/kernel/kvmclock.c                                          |   19 
 arch/x86/kernel/nmi.c                                               |    6 
 arch/x86/kernel/sev-es.c                                            |   22 -
 arch/x86/kernel/traps.c                                             |   16 
 arch/x86/kernel/unwind_orc.c                                        |   12 
 arch/x86/kvm/lapic.c                                                |   11 
 arch/x86/lib/insn-eval.c                                            |   66 ++-
 block/blk-zoned.c                                                   |   38 +
 crypto/Kconfig                                                      |    2 
 drivers/base/memory.c                                               |   25 -
 drivers/base/swnode.c                                               |    3 
 drivers/base/test/Makefile                                          |    1 
 drivers/block/rsxx/core.c                                           |    1 
 drivers/block/zram/zram_drv.c                                       |   11 
 drivers/clk/qcom/gdsc.c                                             |   10 
 drivers/clk/qcom/gdsc.h                                             |    3 
 drivers/clk/qcom/gpucc-msm8998.c                                    |    8 
 drivers/cpufreq/qcom-cpufreq-hw.c                                   |    6 
 drivers/firmware/efi/libstub/efi-stub.c                             |   16 
 drivers/gpio/gpio-pca953x.c                                         |   78 +--
 drivers/gpio/gpiolib-acpi.c                                         |   19 
 drivers/gpio/gpiolib.c                                              |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                 |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                             |    4 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   49 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                       |    1 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c               |    6 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c               |   48 ++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c               |   66 +++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c               |   48 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c                              |   32 +
 drivers/gpu/drm/drm_ioc32.c                                         |   11 
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                           |    7 
 drivers/gpu/drm/i915/i915_cmd_parser.c                              |   19 
 drivers/gpu/drm/i915/i915_drv.h                                     |    2 
 drivers/gpu/drm/meson/meson_drv.c                                   |   11 
 drivers/gpu/drm/qxl/qxl_display.c                                   |    1 
 drivers/gpu/drm/tiny/gm12u320.c                                     |   44 +-
 drivers/gpu/drm/udl/udl_drv.c                                       |   17 
 drivers/gpu/drm/udl/udl_drv.h                                       |    1 
 drivers/gpu/drm/udl/udl_main.c                                      |   10 
 drivers/hid/hid-logitech-dj.c                                       |    7 
 drivers/i2c/busses/i2c-rcar.c                                       |   13 
 drivers/infiniband/core/umem.c                                      |    8 
 drivers/input/keyboard/applespi.c                                   |   21 -
 drivers/iommu/amd/init.c                                            |   45 +-
 drivers/iommu/intel/svm.c                                           |   13 
 drivers/media/platform/vsp1/vsp1_drm.c                              |    6 
 drivers/media/rc/Makefile                                           |    1 
 drivers/media/rc/keymaps/Makefile                                   |    1 
 drivers/media/rc/keymaps/rc-cec.c                                   |   28 -
 drivers/media/rc/rc-main.c                                          |    6 
 drivers/media/usb/usbtv/usbtv-audio.c                               |    2 
 drivers/misc/fastrpc.c                                              |    5 
 drivers/misc/pvpanic.c                                              |    1 
 drivers/mmc/core/bus.c                                              |   11 
 drivers/mmc/core/mmc.c                                              |   15 
 drivers/mmc/host/mmci.c                                             |   10 
 drivers/mmc/host/mtk-sd.c                                           |   18 
 drivers/mmc/host/mxs-mmc.c                                          |    2 
 drivers/mmc/host/sdhci-iproc.c                                      |   18 
 drivers/mmc/host/sdhci.c                                            |    8 
 drivers/net/Kconfig                                                 |    2 
 drivers/net/can/flexcan.c                                           |   24 -
 drivers/net/can/m_can/tcan4x5x.c                                    |    6 
 drivers/net/dsa/sja1105/sja1105_main.c                              |    2 
 drivers/net/ethernet/atheros/alx/main.c                             |    7 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |   14 
 drivers/net/ethernet/davicom/dm9000.c                               |   21 -
 drivers/net/ethernet/freescale/enetc/enetc.c                        |   93 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h                        |    5 
 drivers/net/ethernet/freescale/enetc/enetc_hw.h                     |   18 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                     |  117 ++++-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c                     |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h              |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |    7 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |   13 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c                      |    5 
 drivers/net/ethernet/intel/ixgbevf/ipsec.c                          |    5 
 drivers/net/ethernet/mediatek/mtk_star_emac.c                       |    5 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                     |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                      |    2 
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                        |    1 
 drivers/net/ethernet/mellanox/mlxsw/reg.h                           |    1 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c              |    5 
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c                      |    3 
 drivers/net/ethernet/mscc/ocelot_flower.c                           |    3 
 drivers/net/ethernet/realtek/r8169_main.c                           |    2 
 drivers/net/ethernet/renesas/sh_eth.c                               |    7 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                   |    5 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c                  |    9 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c                    |   19 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c                    |    4 
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c                |    2 
 drivers/net/ethernet/stmicro/stmmac/hwif.h                          |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |   19 
 drivers/net/netdevsim/netdev.c                                      |    1 
 drivers/net/phy/phy.c                                               |    6 
 drivers/net/phy/phy_device.c                                        |    6 
 drivers/net/usb/qmi_wwan.c                                          |   14 
 drivers/net/wan/lapbether.c                                         |    3 
 drivers/net/wireless/ath/ath11k/core.c                              |    1 
 drivers/net/wireless/ath/ath11k/core.h                              |    1 
 drivers/net/wireless/ath/ath11k/mac.c                               |   25 +
 drivers/net/wireless/ath/ath11k/peer.c                              |   61 ++-
 drivers/net/wireless/ath/ath11k/peer.h                              |    4 
 drivers/net/wireless/ath/ath11k/wmi.c                               |   17 
 drivers/net/wireless/ath/ath9k/ath9k.h                              |    3 
 drivers/net/wireless/ath/ath9k/xmit.c                               |    6 
 drivers/net/wireless/mediatek/mt76/dma.c                            |   11 
 drivers/nvme/host/fc.c                                              |    2 
 drivers/pci/controller/pci-xgene-msi.c                              |   10 
 drivers/pci/controller/pcie-mediatek.c                              |    7 
 drivers/pci/pci.c                                                   |    4 
 drivers/pci/pcie/Kconfig                                            |    8 
 drivers/pci/pcie/Makefile                                           |    1 
 drivers/pci/pcie/bw_notification.c                                  |  138 ------
 drivers/pci/pcie/portdrv.h                                          |    6 
 drivers/pci/pcie/portdrv_pci.c                                      |    1 
 drivers/platform/olpc/olpc-ec.c                                     |   15 
 drivers/s390/block/dasd.c                                           |    6 
 drivers/s390/cio/vfio_ccw_ops.c                                     |    6 
 drivers/s390/crypto/vfio_ap_ops.c                                   |    2 
 drivers/s390/net/qeth_core.h                                        |    5 
 drivers/s390/net/qeth_core_main.c                                   |  200 ++++------
 drivers/scsi/libiscsi.c                                             |   11 
 drivers/scsi/ufs/ufs-sysfs.c                                        |    3 
 drivers/scsi/ufs/ufs.h                                              |    6 
 drivers/scsi/ufs/ufshcd.c                                           |    2 
 drivers/spi/spi-stm32.c                                             |   15 
 drivers/staging/comedi/drivers/addi_apci_1032.c                     |    4 
 drivers/staging/comedi/drivers/addi_apci_1500.c                     |   18 
 drivers/staging/comedi/drivers/adv_pci1710.c                        |   10 
 drivers/staging/comedi/drivers/das6402.c                            |    2 
 drivers/staging/comedi/drivers/das800.c                             |    2 
 drivers/staging/comedi/drivers/dmm32at.c                            |    2 
 drivers/staging/comedi/drivers/me4000.c                             |    2 
 drivers/staging/comedi/drivers/pcl711.c                             |    2 
 drivers/staging/comedi/drivers/pcl818.c                             |    2 
 drivers/staging/ks7010/ks_wlan_net.c                                |    6 
 drivers/staging/media/rkisp1/rkisp1-params.c                        |    1 
 drivers/staging/rtl8188eu/core/rtw_ap.c                             |    5 
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c                      |    6 
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c                          |    7 
 drivers/staging/rtl8192u/r8192U_wx.c                                |    6 
 drivers/staging/rtl8712/rtl871x_cmd.c                               |    6 
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                       |    2 
 drivers/target/target_core_pr.c                                     |   15 
 drivers/target/target_core_transport.c                              |   15 
 drivers/tty/serial/max310x.c                                        |   29 -
 drivers/usb/class/cdc-acm.c                                         |    5 
 drivers/usb/class/usblp.c                                           |   16 
 drivers/usb/core/usb.c                                              |   32 +
 drivers/usb/dwc3/dwc3-qcom.c                                        |   77 +++
 drivers/usb/gadget/function/f_uac1.c                                |    1 
 drivers/usb/gadget/function/f_uac2.c                                |    2 
 drivers/usb/gadget/function/u_ether_configfs.h                      |    5 
 drivers/usb/gadget/udc/s3c2410_udc.c                                |    4 
 drivers/usb/host/xhci-pci.c                                         |   13 
 drivers/usb/host/xhci-ring.c                                        |    3 
 drivers/usb/host/xhci.c                                             |   78 ++-
 drivers/usb/host/xhci.h                                             |    1 
 drivers/usb/renesas_usbhs/pipe.c                                    |    2 
 drivers/usb/serial/ch341.c                                          |    1 
 drivers/usb/serial/cp210x.c                                         |    3 
 drivers/usb/serial/io_edgeport.c                                    |   26 -
 drivers/usb/usbip/stub_dev.c                                        |   42 +-
 drivers/usb/usbip/vhci_sysfs.c                                      |   39 +
 drivers/usb/usbip/vudc_sysfs.c                                      |   49 ++
 drivers/xen/events/events_2l.c                                      |   22 -
 drivers/xen/events/events_base.c                                    |  140 +++++--
 drivers/xen/events/events_fifo.c                                    |    7 
 drivers/xen/events/events_internal.h                                |   14 
 fs/binfmt_misc.c                                                    |   29 -
 fs/block_dev.c                                                      |   11 
 fs/cifs/cifsfs.c                                                    |    2 
 fs/cifs/cifsglob.h                                                  |   11 
 fs/cifs/connect.c                                                   |   10 
 fs/cifs/sess.c                                                      |    1 
 fs/cifs/smb2inode.c                                                 |    1 
 fs/cifs/smb2misc.c                                                  |    8 
 fs/cifs/smb2ops.c                                                   |   10 
 fs/cifs/smb2proto.h                                                 |    3 
 fs/cifs/transport.c                                                 |    2 
 fs/configfs/file.c                                                  |    6 
 fs/ext4/super.c                                                     |    9 
 fs/nfs/dir.c                                                        |   40 +-
 fs/nfs/nfs4proc.c                                                   |    2 
 fs/pnode.h                                                          |    2 
 fs/udf/inode.c                                                      |    9 
 include/linux/acpi.h                                                |   10 
 include/linux/can/skb.h                                             |    8 
 include/linux/compiler-clang.h                                      |    6 
 include/linux/entry-common.h                                        |   39 +
 include/linux/gpio/consumer.h                                       |    2 
 include/linux/memory.h                                              |    3 
 include/linux/perf_event.h                                          |    2 
 include/linux/pgtable.h                                             |    4 
 include/linux/sched/mm.h                                            |    3 
 include/linux/seqlock.h                                             |    5 
 include/linux/stop_machine.h                                        |   11 
 include/linux/usb.h                                                 |    2 
 include/linux/virtio_net.h                                          |    7 
 include/media/rc-map.h                                              |    7 
 include/target/target_core_backend.h                                |    1 
 include/uapi/linux/l2tp.h                                           |    1 
 include/uapi/linux/netfilter/nfnetlink_cthelper.h                   |    2 
 kernel/entry/common.c                                               |   36 +
 kernel/events/core.c                                                |   42 +-
 kernel/sched/membarrier.c                                           |    4 
 kernel/sysctl.c                                                     |    8 
 kernel/time/hrtimer.c                                               |   60 +--
 lib/logic_pio.c                                                     |    3 
 lib/test_kasan.c                                                    |   10 
 mm/madvise.c                                                        |   13 
 mm/memory.c                                                         |    8 
 mm/memory_hotplug.c                                                 |    2 
 mm/page_alloc.c                                                     |  158 +++----
 mm/slub.c                                                           |    2 
 net/dsa/slave.c                                                     |   45 ++
 net/dsa/tag_ar9331.c                                                |    3 
 net/dsa/tag_brcm.c                                                  |    3 
 net/dsa/tag_dsa.c                                                   |    5 
 net/dsa/tag_edsa.c                                                  |    4 
 net/dsa/tag_gswip.c                                                 |    5 
 net/dsa/tag_ksz.c                                                   |   73 ---
 net/dsa/tag_lan9303.c                                               |    9 
 net/dsa/tag_mtk.c                                                   |   22 -
 net/dsa/tag_ocelot.c                                                |    7 
 net/dsa/tag_qca.c                                                   |    3 
 net/dsa/tag_rtl4_a.c                                                |   12 
 net/dsa/tag_trailer.c                                               |   31 -
 net/ethtool/channels.c                                              |   26 -
 net/ipv4/cipso_ipv4.c                                               |   11 
 net/ipv4/ip_tunnel.c                                                |    5 
 net/ipv4/ip_vti.c                                                   |    6 
 net/ipv4/nexthop.c                                                  |   10 
 net/ipv4/tcp.c                                                      |   26 -
 net/ipv4/udp_offload.c                                              |    2 
 net/ipv6/calipso.c                                                  |   14 
 net/ipv6/ip6_gre.c                                                  |   16 
 net/ipv6/ip6_tunnel.c                                               |   10 
 net/ipv6/ip6_vti.c                                                  |    6 
 net/ipv6/sit.c                                                      |    2 
 net/l2tp/l2tp_core.c                                                |   41 +-
 net/l2tp/l2tp_core.h                                                |    1 
 net/l2tp/l2tp_netlink.c                                             |    6 
 net/mpls/mpls_gso.c                                                 |    3 
 net/netfilter/nf_nat_proto.c                                        |   25 +
 net/netfilter/x_tables.c                                            |    6 
 net/netlabel/netlabel_cipso_v4.c                                    |    3 
 net/qrtr/qrtr.c                                                     |    4 
 net/sched/sch_api.c                                                 |    8 
 net/sunrpc/sched.c                                                  |    5 
 samples/bpf/xdpsock_user.c                                          |    2 
 security/commoncap.c                                                |   12 
 sound/pci/hda/hda_bind.c                                            |    4 
 sound/pci/hda/hda_controller.c                                      |    7 
 sound/pci/hda/hda_intel.c                                           |    2 
 sound/pci/hda/patch_ca0132.c                                        |    1 
 sound/pci/hda/patch_conexant.c                                      |   62 ++-
 sound/pci/hda/patch_hdmi.c                                          |   13 
 sound/usb/card.c                                                    |    6 
 sound/usb/quirks.c                                                  |   11 
 sound/usb/usbaudio.h                                                |    1 
 tools/bpf/resolve_btfids/main.c                                     |    5 
 tools/lib/bpf/xsk.c                                                 |    5 
 tools/perf/Makefile.perf                                            |    2 
 tools/perf/util/sort.c                                              |    4 
 tools/perf/util/trace-event-read.c                                  |    1 
 tools/testing/selftests/bpf/progs/netif_receive_skb.c               |   13 
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c                |    6 
 tools/testing/selftests/bpf/verifier/array_access.c                 |    3 
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh |    9 
 332 files changed, 3001 insertions(+), 1732 deletions(-)

Adrian Hunter (1):
      mmc: core: Fix partition switch time for eMMC

Alain Volmat (1):
      spi: stm32: make spurious and overrun interrupts visible

Aleksandr Miloserdov (2):
      scsi: target: core: Add cmd length set before cmd complete
      scsi: target: core: Prevent underflow for service actions

Alex Deucher (3):
      drm/amdgpu/display: simplify backlight setting
      drm/amdgpu/display: don't assert in set backlight function
      drm/amdgpu/display: handle aux backlight in backlight_get_brightness

Alexander Shiyan (1):
      Revert "serial: max310x: rework RX interrupt handling"

Andreas Larsson (1):
      sparc32: Limit memblock allocation to low memory

Andrew Scull (1):
      KVM: arm64: Fix nVHE hyp panic host context restore

Andrey Konovalov (2):
      kasan: fix memory corruption in kasan_bitops_tags test
      arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL

Andy Lutomirski (1):
      x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls

Andy Shevchenko (3):
      gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk
      gpiolib: acpi: Allow to find GpioInt() resource by name and index
      gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2

AngeloGioacchino Del Regno (2):
      clk: qcom: gdsc: Implement NO_RET_PERIPH flag
      clk: qcom: gpucc-msm8998: Add resets, cxc, fix flags on gpu_gx_gdsc

Anna-Maria Behnsen (1):
      hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()

Anshuman Khandual (1):
      arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory

Antonio Terceiro (1):
      perf build: Fix ccache usage in $(CC) when generating arch errno table

Antony Antony (1):
      ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Ard Biesheuvel (4):
      ARM: assembler: introduce adr_l, ldr_l and str_l macros
      ARM: efistub: replace adrl pseudo-op with adr_l macro invocation
      arm64: mm: use a 48-bit ID map when possible on 52-bit VA builds
      efi: stub: omit SetVirtualAddressMap() if marked unsupported in RT_PROP table

Arjun Roy (1):
      tcp: Fix sign comparison bug in getsockopt(TCP_ZEROCOPY_RECEIVE)

Arnd Bergmann (5):
      net: phy: make mdio_bus_phy_suspend/resume as __maybe_unused
      enetc: Fix unused var build warning for CONFIG_OF
      drivers/base: build kunit tests without structleak plugin
      stop_machine: mark helpers __always_inline
      linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Artem Lapkin (1):
      drm: meson_drv add shutdown function

Athira Rajeev (2):
      powerpc/perf: Fix handling of privilege level checks in perf interrupt context
      powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Aurelien Aptel (1):
      cifs: fix credit accounting for extra channel

Balazs Nemeth (2):
      net: check if protocol extracted by virtio_net_hdr_set_proto is correct
      net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

Benjamin Coddington (1):
      SUNRPC: Set memalloc_nofs_save() for sync tasks

Biao Huang (1):
      net: ethernet: mtk-star-emac: fix wrong unmap in RX handling

Biju Das (2):
      media: v4l: vsp1: Fix uif null pointer access
      media: v4l: vsp1: Fix bru null pointer access

Bjorn Helgaas (1):
      PCI/LINK: Remove bandwidth notification

Carl Huang (1):
      ath11k: start vdev if a bss peer is already created

Catalin Marinas (1):
      arm64: mte: Map hotplugged memory as Normal Tagged

Chaotian Jing (1):
      mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christian Brauner (1):
      mount: fix mounting of detached mounts onto targets that reside on shared mounts

Christian Eggers (2):
      net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
      net: dsa: trailer: don't allocate additional memory for padding/tagging

Christoph Hellwig (1):
      RDMA/umem: Use ib_dma_max_seg_size instead of dma_get_max_seg_size

Christophe JAILLET (1):
      mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Christophe Leroy (2):
      powerpc/603: Fix protection of user pages mapped with PROT_NONE
      powerpc: Fix missing declaration of [en/dis]able_kernel_vsx()

Colin Ian King (1):
      qxl: Fix uninitialised struct field head.surface_id

DENG Qingfang (2):
      net: dsa: tag_rtl4_a: fix egress tags
      net: dsa: tag_mtk: fix 802.1ad VLAN egress

Dafna Hirschfeld (1):
      media: rkisp1: params: fix wrong bits settings

Daiyue Zhang (1):
      configfs: fix a use-after-free in __configfs_open_file

Dan Carpenter (6):
      USB: gadget: u_ether: Fix a configfs return code
      staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()
      staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()
      staging: rtl8712: unterminated string leads to read overflow
      staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()
      staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

Daniel Axtens (1):
      powerpc/64s/exception: Clean up a missed SRR specifier

Daniel Borkmann (1):
      net: Fix gro aggregation for udp encaps with zero csum

Daniel Vetter (1):
      drm/compat: Clear bounce structures

Daniele Palmas (1):
      net: usb: qmi_wwan: allow qmimux add/del with master up

Danielle Ratson (2):
      selftests: forwarding: Fix race condition in mirror installation
      mlxsw: spectrum_ethtool: Add an external speed to PTYS register

David Hildenbrand (1):
      drivers/base/memory: don't store phys_device in memory blocks

Dmitry Baryshkov (1):
      misc: fastrpc: restrict user apps from sending kernel RPC messages

Dmitry V. Levin (1):
      uapi: nfnetlink_cthelper.h: fix userspace compilation error

Edwin Peer (1):
      bnxt_en: reliably allocate IRQ table on reset to avoid crash

Eric Dumazet (1):
      tcp: add sanity tests to TCP_QUEUE_SEQ

Eric Farman (1):
      s390/cio: return -EFAULT if copy_to_user() fails

Eric W. Biederman (1):
      Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Felix Fietkau (1):
      ath9k: fix transmitting to stations in dynamic SMPS mode

Filipe Laíns (1):
      HID: logitech-dj: add support for the new lightspeed connection iteration

Florian Westphal (1):
      netfilter: nf_nat: undo erroneous tcp edemux lookup

Forest Crossman (1):
      usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Frank Li (1):
      mmc: cqhci: Fix random crash when remove mmc module/card

Geert Uytterhoeven (1):
      PCI: Fix pci_register_io_range() memory leak

Greg Kroah-Hartman (1):
      Linux 5.10.24

Greg Kurz (1):
      powerpc/pseries: Don't enforce MSI affinity with kdump

Guangbin Huang (1):
      net: phy: fix save wrong speed and duplex problem if autoneg is on

Hangbin Liu (1):
      selftests/bpf: No need to drop the packet when there is no geneve opt

Hans Verkuil (1):
      media: rc: compile rc-cec.c into rc-core

Hayes Wang (1):
      r8169: fix r8168fp_adjust_ocp_cmd function

Heikki Krogerus (1):
      software node: Fix node registration

Heiko Carstens (1):
      s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Hillf Danton (1):
      netdevsim: init u64 stats for 32bit hardware

Holger Hoffstätte (2):
      drm/amdgpu/display: use GFP_ATOMIC in dcn21_validate_bandwidth_fp()
      drm/amd/display: Fix nested FPU context in dcn21_validate_bandwidth()

Ian Abbott (9):
      staging: comedi: addi_apci_1032: Fix endian problem for COS sample
      staging: comedi: addi_apci_1500: Fix endian problem for command sample
      staging: comedi: adv_pci1710: Fix endian problem for AI command data
      staging: comedi: das6402: Fix endian problem for AI command data
      staging: comedi: das800: Fix endian problem for AI command data
      staging: comedi: dmm32at: Fix endian problem for AI command data
      staging: comedi: me4000: Fix endian problem for AI command data
      staging: comedi: pcl711: Fix endian problem for AI command data
      staging: comedi: pcl818: Fix endian problem for AI command data

Ian Rogers (1):
      perf traceevent: Ensure read cmdlines are null terminated.

Ido Schimmel (1):
      nexthop: Do not flush blackhole nexthops when loopback goes down

Ilya Leoshkevich (1):
      selftests/bpf: Use the last page in test_snprintf_btf on s390

Jaegeuk Kim (1):
      scsi: ufs: WB is only available on LUN #0 to #7

Jakub Kicinski (2):
      ethernet: alx: fix order of calls on resume
      docs: networking: drop special stable handling

James Smart (1):
      nvme-fc: fix racing controller reset and create association

Jan Kara (1):
      block: Try to handle busy underlying device on discard

Jason A. Donenfeld (1):
      net: always use icmp{,v6}_ndo_send from ndo_start_xmit

Jeremy Linton (2):
      mmc: sdhci-iproc: Add ACPI bindings for the RPi
      mmc: sdhci: Update firmware interface API

Jia He (1):
      KVM: arm64: Fix range alignment when walking page tables

Jia-Ju Bai (2):
      net: qrtr: fix error return code of qrtr_sendmsg()
      block: rsxx: fix error return code of rsxx_pci_probe()

Jian Cai (1):
      ARM: 9029/1: Make iwmmxt.S support Clang's integrated assembler

Jian Shen (3):
      net: hns3: fix query vlan mask value error for flow director
      net: hns3: fix bug when calculating the TCAM table info
      net: hns3: fix error mask definition of flow director

Jiri Wiesner (1):
      ibmvnic: always store valid MAC address

Joakim Zhang (6):
      can: flexcan: assert FRZ bit in flexcan_chip_freeze()
      can: flexcan: enable RX FIFO after FRZ/HALT valid
      can: flexcan: invoke flexcan_chip_freeze() to enter freeze mode
      net: stmmac: stop each tx channel independently
      net: stmmac: fix watchdog timeout during suspend/resume stress test
      net: stmmac: fix wrongly set buffer2 valid when sph unsupport

Joerg Roedel (4):
      x86/sev-es: Introduce ip_within_syscall_gap() helper
      x86/sev-es: Check regs->sp is trusted before adjusting #VC IST stack
      x86/sev-es: Correctly track IRQ states in runtime #VC handler
      x86/sev-es: Use __copy_from_user_inatomic()

Johan Hovold (1):
      gpio: fix gpio-device list corruption

John Ernberg (1):
      ALSA: usb: Add Plantronics C320-M USB ctrl msg delay quirk

Josh Poimboeuf (1):
      x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2

Juergen Gross (3):
      xen/events: reset affinity of 2-level event when tearing it down
      xen/events: don't unmask an event channel when an eoi is pending
      xen/events: avoid handling the same event on two cpus at the same time

Julian Wiedmann (5):
      s390/qeth: fix memory leak after failed TX Buffer allocation
      s390/qeth: don't replace a fully completed async TX buffer
      s390/qeth: remove QETH_QDIO_BUF_HANDLED_DELAYED state
      s390/qeth: improve completion of pending TX buffers
      s390/qeth: fix notification for pending buffers during teardown

Kai-Heng Feng (1):
      ALSA: usb-audio: Disable USB autosuspend properly in setup_disable_autosuspend()

Kalle Valo (1):
      ath11k: fix AP mode for QCA6390

Kan Liang (2):
      perf/core: Flush PMU internal buffers for per-CPU events
      perf/x86/intel: Set PERF_ATTACH_SCHED_CB for large PEBS and LBR

Karan Singhal (1):
      USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Keita Suzuki (1):
      i40e: Fix memory leak in i40e_probe

Kenneth Feng (1):
      drm/amd/pm: bug fix for pcie dpm

Kevin(Yudong) Yang (1):
      net/mlx4_en: update moderation when config reset

Khalid Aziz (1):
      sparc64: Use arch_validate_flags() to validate ADI flag

Krzysztof Wilczyński (1):
      PCI: mediatek: Add missing of_node_put() to fix reference leak

Kun-Chuan Hsieh (1):
      tools/resolve_btfids: Fix build error with older host toolchains

Lee Gibson (2):
      staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd
      staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Lin Feng (1):
      sysctl.c: fix underflow value setting risk in vm_table

Linus Torvalds (1):
      Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Lior Ribak (1):
      binfmt_misc: fix possible deadlock in bm_register_write

Lorenzo Bianconi (1):
      mt76: dma: do not report truncated frames to mac80211

Lu Baolu (1):
      iommu/vt-d: Clear PRQ overflow only when PRQ is empty

Lubomir Rintel (1):
      Platform: OLPC: Fix probe error handling

Maciej Fijalkowski (2):
      samples, bpf: Add missing munmap in xdpsock
      libbpf: Clear map_info before each bpf_obj_get_info_by_fd

Maciej W. Rozycki (1):
      crypto: mips/poly1305 - enable for all MIPS processors

Marc Zyngier (3):
      KVM: arm64: Reject VM creation when the default IPA size is unsupported
      KVM: arm64: Fix exclusive limit for IPA size
      KVM: arm64: Ensure I-cache isolation between vcpus of a same VM

Martin Kaiser (1):
      PCI: xgene-msi: Fix race in installing chained irq handler

Mathias Nyman (2):
      xhci: Improve detection of device initiated wake signal.
      xhci: Fix repeated xhci wake after suspend due to uncleared internal wake state

Mathieu Desnoyers (1):
      sched/membarrier: fix missing local execution of ipi_sync_rq_state()

Matthew Wilcox (Oracle) (1):
      include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Matthias Kaehlcke (1):
      usb: dwc3: qcom: Honor wakeup enabled/disabled state

Matthias Schiffer (1):
      net: l2tp: reduce log level of messages in receive path, add counter instead

Maxim Mikityanskiy (1):
      media: usbtv: Fix deadlock on suspend

Maximilian Heyne (1):
      net: sched: avoid duplicates in classes dump

Michael Ellerman (1):
      powerpc/64: Fix stack trace not displaying final frame

Michal Suchanek (1):
      ibmvnic: Fix possibly uninitialized old_num_tx_queues variable warning.

Mike Christie (1):
      scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Mike Rapoport (1):
      mm/page_alloc.c: refactor initialization of struct page for holes in memory layout

Minchan Kim (1):
      zram: fix return value on writeback_store

Nadav Amit (1):
      mm/userfaultfd: fix memory corruption due to writeprotect

Naveen N. Rao (1):
      powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Neil Roberts (2):
      drm/shmem-helper: Check for purged buffers in fault handler
      drm/shmem-helper: Don't remove the offset in vm_area_struct pgoff

Nicholas Piggin (2):
      powerpc: improve handling of unrecoverable system reset
      powerpc: Fix inverted SET_FULL_REGS bitop

Niv Sardi (1):
      USB: serial: ch341: add new Product ID

Noralf Trønnes (1):
      drm/shmem-helpers: vunmap: Don't put pages for dma-buf

Oleksij Rempel (1):
      can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Oliver O'Halloran (1):
      powerpc/pci: Add ppc_md.discover_phbs()

Ondrej Mosnacek (1):
      NFSv4.2: fix return value of _nfs4_get_security_label()

Ong Boon Leong (2):
      net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10
      net: stmmac: Fix VLAN filter delete timeout issue in Intel mGBE SGMII

Paul Cercueil (2):
      net: davicom: Fix regulator not turned off on failed probe
      net: davicom: Fix regulator not turned off on driver removal

Paul Moore (1):
      cipso,calipso: resolve a number of problems with the DOI refcounts

Paulo Alcantara (2):
      cifs: return proper error code in statfs(2)
      cifs: do not send close in compound create+close requests

Pavel Skripkin (3):
      ALSA: usb-audio: fix NULL ptr dereference in usb_audio_probe
      ALSA: usb-audio: fix use after free in usb_audio_disconnect
      USB: serial: io_edgeport: fix memory leak in edge_startup

Pete Zaitcev (1):
      USB: usblp: fix a hang in poll() if disconnected

Peter Zijlstra (1):
      seqlock,lockdep: Fix seqcount_latch_init()

Ravi Bangoria (1):
      perf report: Fix -F for branch & mem modes

Ritesh Singh (1):
      ath11k: peer delete synchronization with firmware

Rob Herring (1):
      arm64: perf: Fix 64-bit event counter read truncation

Ronald Tschalär (1):
      Input: applespi - don't wait for responses to commands indefinitely.

Ruslan Bilovol (2):
      usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
      usb: gadget: f_uac1: stop playback on function disable

Sasha Levin (1):
      kbuild: clamp SUBLEVEL to 255

Sean Christopherson (1):
      KVM: x86: Ensure deadline timer has truly expired before posting its IRQ

Sebastian Reichel (1):
      USB: serial: cp210x: add some more GE USB IDs

Serge Semin (1):
      usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

Sergey Shtylyov (3):
      sh_eth: fix TRSCER mask for SH771x
      sh_eth: fix TRSCER mask for R7S9210
      sh_eth: fix TRSCER mask for R7S72100

Shawn Guo (3):
      usb: dwc3: qcom: add URS Host support for sdm845 ACPI boot
      usb: dwc3: qcom: add ACPI device id for sc8180x
      cpufreq: qcom-hw: fix dereferencing freed memory 'data'

Shile Zhang (1):
      misc/pvpanic: Export module FDT device table

Shin'ichiro Kawasaki (1):
      block: Discard page cache of zone reset target range

Shuah Khan (6):
      usbip: fix stub_dev to check for stream socket
      usbip: fix vhci_hcd to check for stream socket
      usbip: fix vudc to check for stream socket
      usbip: fix stub_dev usbip_sockfd_store() races leading to gpf
      usbip: fix vhci_hcd attach_store() races leading to gpf
      usbip: fix vudc usbip_sockfd_store races leading to gpf

Simeon Simeonoff (1):
      ALSA: hda/ca0132: Add Sound BlasterX AE-5 Plus support

Stanislaw Gruszka (1):
      usb: xhci: do not perform Soft Retry for some xHCI hosts

Stefan Haberland (2):
      s390/dasd: fix hanging DASD driver unbind
      s390/dasd: fix hanging IO request during DASD driver unbind

Steven J. Magnani (1):
      udf: fix silent AED tagLocation corruption

Suravee Suthikulpanit (1):
      iommu/amd: Fix performance counter initialization

Suren Baghdasaryan (1):
      mm/madvise: replace ptrace attach requirement for process_madvise

Suzuki K Poulose (1):
      KVM: arm64: nvhe: Save the SPE context early

Takashi Iwai (8):
      drm/amd/display: Add a backlight module option
      ALSA: hda/hdmi: Cancel pending works before suspend
      ALSA: hda/conexant: Add quirk for mute LED control on HP ZBook G5
      ALSA: hda: Drop the BATCH workaround for AMD controllers
      ALSA: hda: Flush pending unsolicited events before suspend
      ALSA: hda: Avoid spurious unsol event handling during S3/S4
      ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar
      ALSA: usb-audio: Apply the control quirk to Plantronics headsets

Theodore Ts'o (1):
      ext4: don't try to processed freed blocks until mballoc is initialized

Thomas Gleixner (1):
      x86/entry: Move nmi entry/exit into common code

Thomas Zimmermann (1):
      drm: Use USB controller's DMA mask when importing dmabufs

Torin Cooper-Bennun (1):
      can: tcan4x5x: tcan4x5x_init(): fix initialization - clear MRAM before entering Normal Mode

Trond Myklebust (2):
      NFS: Don't revalidate the directory permissions on a lookup failure
      NFS: Don't gratuitously clear the inode cache when lookup failed

Tvrtko Ursulin (1):
      drm/i915: Wedge the GPU if command parser setup fails

Vasily Averin (1):
      netfilter: x_tables: gpf inside xt_find_revision()

Vladimir Oltean (21):
      net: enetc: don't overwrite the RSS indirection table when initializing
      net: enetc: take the MDIO lock only once per NAPI poll cycle
      net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
      net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
      net: enetc: force the RGMII speed and duplex instead of operating in inband mode
      net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr
      net: enetc: keep RX ring consumer index in sync with hardware
      net: mscc: ocelot: properly reject destination IP keys in VCAP IS1
      net: dsa: sja1105: fix SGMII PCS being forced to SPEED_UNKNOWN instead of SPEED_10
      net: enetc: allow hardware timestamping on TX queues with tc-etf enabled
      net: dsa: implement a central TX reallocation procedure
      net: dsa: tag_qca: let DSA core deal with TX reallocation
      net: dsa: tag_ocelot: let DSA core deal with TX reallocation
      net: dsa: tag_mtk: let DSA core deal with TX reallocation
      net: dsa: tag_lan9303: let DSA core deal with TX reallocation
      net: dsa: tag_edsa: let DSA core deal with TX reallocation
      net: dsa: tag_brcm: let DSA core deal with TX reallocation
      net: dsa: tag_dsa: let DSA core deal with TX reallocation
      net: dsa: tag_gswip: let DSA core deal with TX reallocation
      net: dsa: tag_ar9331: let DSA core deal with TX reallocation
      net: enetc: initialize RFS/RSS memories for unused ports too

Wang Qing (2):
      s390/cio: return -EFAULT if copy_to_user() fails again
      s390/crypto: return -EFAULT if copy_to_user() fails

Wanpeng Li (1):
      KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged

Wei Yongjun (2):
      USB: gadget: udc: s3c2410_udc: fix return value check in s3c2410_udc_probe()
      cpufreq: qcom-hw: Fix return value check in qcom_cpufreq_hw_cpu_init()

Will Deacon (1):
      KVM: arm64: Avoid corrupting vCPU context register in guest exit

Wolfram Sang (2):
      i2c: rcar: faster irq code to minimize HW race condition
      i2c: rcar: optimize cacheline to minimize HW race condition

Wong Vee Khee (1):
      stmmac: intel: Fixes clock registration error seen for multiple interfaces

Xie He (1):
      net: lapbether: Remove netif_start_queue / netif_stop_queue

Yann Gautier (1):
      mmc: mmci: Add MMC_CAP_NEED_RSP_BUSY for the stm32 variants

Yauheni Kaliuta (1):
      selftests/bpf: Mask bpf_csum_diff() return value to 16 bits in test_verifier

Yinjun Zhang (1):
      ethtool: fix the check logic of at least one channel for RX/TX

Yorick de Wid (1):
      Goodix Fingerprint device is not a modem

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM

