Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4356A380574
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 10:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhENIuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 04:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhENIuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 04:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7CB613DF;
        Fri, 14 May 2021 08:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620982143;
        bh=tmGu7TNCLTtMx//02TWB03wZDdzG6MyexZ/amDWLAAQ=;
        h=From:To:Cc:Subject:Date:From;
        b=1HN+y1wF6IasERbLEejZdRpC63sIiIuyvt+byUP8krXy0ZTeIhC329vwRNft64MfN
         QboxxUyeQNXPt/YV6EWYDvjBKpWLH0ZHDFK6lF8kQJeZ31F0xgapUMqFk9bIEgnRH3
         DbzBV/USzYqv3B0ALDxDdHHskKqFP1KvH9mBz3to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.119
Date:   Fri, 14 May 2021 10:48:59 +0200
Message-Id: <16209821397161@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.119 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |    2 
 arch/arm/boot/dts/exynos4412-midas.dtsi                             |    6 
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi                     |    2 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                           |    2 
 arch/arm/boot/dts/exynos5250-snow-common.dtsi                       |    2 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                                |    2 
 arch/arm64/boot/dts/renesas/r8a77980.dtsi                           |   16 
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi                    |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi                    |    4 
 arch/m68k/include/asm/mvme147hw.h                                   |    3 
 arch/m68k/mvme147/config.c                                          |   14 
 arch/m68k/mvme16x/config.c                                          |   14 
 arch/mips/boot/dts/brcm/bcm3368.dtsi                                |    2 
 arch/mips/boot/dts/brcm/bcm63268.dtsi                               |    2 
 arch/mips/boot/dts/brcm/bcm6358.dtsi                                |    2 
 arch/mips/boot/dts/brcm/bcm6362.dtsi                                |    2 
 arch/mips/boot/dts/brcm/bcm6368.dtsi                                |    2 
 arch/mips/pci/pci-legacy.c                                          |    9 
 arch/mips/pci/pci-mt7620.c                                          |    5 
 arch/mips/pci/pci-rt2880.c                                          |   37 
 arch/powerpc/Kconfig                                                |    2 
 arch/powerpc/Kconfig.debug                                          |    1 
 arch/powerpc/include/asm/book3s/64/radix.h                          |    6 
 arch/powerpc/kernel/fadump.c                                        |    2 
 arch/powerpc/kernel/prom.c                                          |    2 
 arch/powerpc/kvm/book3s_hv.c                                        |    3 
 arch/powerpc/mm/book3s64/radix_pgtable.c                            |    4 
 arch/powerpc/perf/isa207-common.c                                   |    4 
 arch/powerpc/platforms/52xx/lite5200_sleep.S                        |    2 
 arch/powerpc/platforms/pseries/pci_dlpar.c                          |    4 
 arch/powerpc/sysdev/xive/common.c                                   |   14 
 arch/s390/kernel/setup.c                                            |    4 
 arch/s390/kvm/gaccess.h                                             |   54 -
 arch/s390/kvm/kvm-s390.c                                            |    4 
 arch/x86/Kconfig                                                    |    1 
 arch/x86/events/amd/iommu.c                                         |    6 
 arch/x86/kernel/cpu/microcode/core.c                                |    8 
 arch/x86/kernel/kprobes/core.c                                      |   17 
 arch/x86/kvm/vmx/nested.c                                           |    2 
 drivers/acpi/cppc_acpi.c                                            |   14 
 drivers/ata/libahci_platform.c                                      |    4 
 drivers/ata/pata_arasan_cf.c                                        |   15 
 drivers/ata/pata_ixp4xx_cf.c                                        |    6 
 drivers/ata/sata_mv.c                                               |    4 
 drivers/base/node.c                                                 |   26 
 drivers/base/regmap/regmap-debugfs.c                                |    1 
 drivers/block/null_blk_zoned.c                                      |    1 
 drivers/block/xen-blkback/common.h                                  |    1 
 drivers/block/xen-blkback/xenbus.c                                  |   38 
 drivers/bus/qcom-ebi2.c                                             |    4 
 drivers/char/ttyprintk.c                                            |   11 
 drivers/clk/clk-ast2600.c                                           |    4 
 drivers/clk/mvebu/armada-37xx-periph.c                              |   83 -
 drivers/clk/qcom/a53-pll.c                                          |    1 
 drivers/clk/uniphier/clk-uniphier-mux.c                             |    4 
 drivers/clk/zynqmp/pll.c                                            |   12 
 drivers/cpufreq/armada-37xx-cpufreq.c                               |   76 +
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c                            |    4 
 drivers/crypto/qat/qat_c62xvf/adf_drv.c                             |    4 
 drivers/crypto/qat/qat_common/adf_isr.c                             |   29 
 drivers/crypto/qat/qat_common/adf_transport.c                       |    1 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                          |   17 
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c                         |    4 
 drivers/devfreq/devfreq.c                                           |    2 
 drivers/firmware/Kconfig                                            |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c                              |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h                              |    9 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   17 
 drivers/gpu/drm/i915/gvt/gvt.c                                      |    8 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                             |   13 
 drivers/gpu/drm/radeon/radeon_kms.c                                 |    1 
 drivers/hid/hid-ids.h                                               |    1 
 drivers/hid/hid-plantronics.c                                       |   60 +
 drivers/hsi/hsi_core.c                                              |    3 
 drivers/hv/channel_mgmt.c                                           |   30 
 drivers/i2c/busses/i2c-cadence.c                                    |    5 
 drivers/i2c/busses/i2c-emev2.c                                      |    5 
 drivers/i2c/busses/i2c-img-scb.c                                    |    4 
 drivers/i2c/busses/i2c-imx-lpi2c.c                                  |    2 
 drivers/i2c/busses/i2c-jz4780.c                                     |    5 
 drivers/i2c/busses/i2c-omap.c                                       |    8 
 drivers/i2c/busses/i2c-sh7760.c                                     |    5 
 drivers/i2c/busses/i2c-sprd.c                                       |    4 
 drivers/i3c/master.c                                                |    5 
 drivers/iio/accel/adis16201.c                                       |    2 
 drivers/infiniband/hw/bnxt_re/qplib_res.c                           |    1 
 drivers/infiniband/hw/cxgb4/resource.c                              |    2 
 drivers/infiniband/hw/hfi1/firmware.c                               |    1 
 drivers/infiniband/hw/i40iw/i40iw_pble.c                            |    6 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                             |    4 
 drivers/infiniband/sw/siw/siw_mem.c                                 |    4 
 drivers/infiniband/ulp/srpt/ib_srpt.c                               |    1 
 drivers/irqchip/irq-gic-v3-mbi.c                                    |    2 
 drivers/md/md-bitmap.c                                              |    2 
 drivers/md/md.c                                                     |   73 -
 drivers/media/platform/aspeed-video.c                               |    9 
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c                |    4 
 drivers/media/platform/vivid/vivid-vid-out.c                        |    2 
 drivers/media/tuners/m88rs6000t.c                                   |    6 
 drivers/media/v4l2-core/v4l2-ctrls.c                                |   17 
 drivers/memory/omap-gpmc.c                                          |    7 
 drivers/memory/pl353-smc.c                                          |    2 
 drivers/mfd/stm32-timers.c                                          |    7 
 drivers/misc/lis3lv02d/lis3lv02d.c                                  |   21 
 drivers/misc/vmw_vmci/vmci_doorbell.c                               |    2 
 drivers/misc/vmw_vmci/vmci_guest.c                                  |    2 
 drivers/mtd/mtdchar.c                                               |    8 
 drivers/mtd/mtdcore.c                                               |    3 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                            |    6 
 drivers/mtd/nand/raw/fsmc_nand.c                                    |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                          |    2 
 drivers/mtd/nand/raw/qcom_nandc.c                                   |    7 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |   10 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h               |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c                  |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c                   |   22 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                     |    3 
 drivers/net/ethernet/qualcomm/emac/emac-mac.c                       |    4 
 drivers/net/ethernet/renesas/ravb_main.c                            |   35 
 drivers/net/ethernet/ti/davinci_emac.c                              |    4 
 drivers/net/fddi/defxx.c                                            |   47 
 drivers/net/geneve.c                                                |    4 
 drivers/net/phy/intel-xway.c                                        |   21 
 drivers/net/wan/lapbether.c                                         |   32 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                           |    3 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                       |    2 
 drivers/net/wireless/ath/ath9k/hw.c                                 |    2 
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c                      |    6 
 drivers/net/wireless/marvell/mwl8k.c                                |    1 
 drivers/net/wireless/mediatek/mt7601u/eeprom.c                      |    2 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c              |  500 +++++++---
 drivers/net/wireless/realtek/rtw88/phy.c                            |    5 
 drivers/nfc/pn533/pn533.c                                           |    3 
 drivers/nvme/host/multipath.c                                       |    4 
 drivers/nvme/host/pci.c                                             |    2 
 drivers/nvme/host/tcp.c                                             |    4 
 drivers/nvme/target/tcp.c                                           |    4 
 drivers/of/fdt.c                                                    |   12 
 drivers/pci/vpd.c                                                   |    1 
 drivers/phy/marvell/Kconfig                                         |    4 
 drivers/platform/x86/pmc_atom.c                                     |   28 
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                              |    6 
 drivers/scsi/ibmvscsi/ibmvfc.c                                      |   57 -
 drivers/scsi/jazz_esp.c                                             |    4 
 drivers/scsi/sni_53c710.c                                           |    5 
 drivers/scsi/sun3x_esp.c                                            |    4 
 drivers/soc/aspeed/aspeed-lpc-snoop.c                               |    4 
 drivers/soc/qcom/mdt_loader.c                                       |   17 
 drivers/soundwire/bus.c                                             |    3 
 drivers/soundwire/stream.c                                          |   10 
 drivers/spi/spi-fsl-lpspi.c                                         |    2 
 drivers/spi/spi-stm32.c                                             |    3 
 drivers/spi/spi.c                                                   |    9 
 drivers/staging/fwserial/fwserial.c                                 |   10 
 drivers/staging/greybus/uart.c                                      |   13 
 drivers/staging/media/omap4iss/iss.c                                |    4 
 drivers/staging/rtl8192u/r8192U_core.c                              |    2 
 drivers/tty/amiserial.c                                             |    1 
 drivers/tty/moxa.c                                                  |   18 
 drivers/tty/serial/serial_core.c                                    |    6 
 drivers/tty/serial/stm32-usart.c                                    |   17 
 drivers/tty/serial/stm32-usart.h                                    |    3 
 drivers/tty/tty_io.c                                                |    8 
 drivers/usb/class/cdc-acm.c                                         |   16 
 drivers/usb/dwc2/core_intr.c                                        |  154 +--
 drivers/usb/dwc2/hcd.c                                              |   10 
 drivers/usb/gadget/udc/aspeed-vhub/core.c                           |    3 
 drivers/usb/gadget/udc/aspeed-vhub/epn.c                            |    2 
 drivers/usb/gadget/udc/fotg210-udc.c                                |   26 
 drivers/usb/gadget/udc/pch_udc.c                                    |   49 
 drivers/usb/gadget/udc/r8a66597-udc.c                               |    2 
 drivers/usb/gadget/udc/snps_udc_plat.c                              |    4 
 drivers/usb/host/xhci-mtk-sch.c                                     |   80 +
 drivers/usb/host/xhci-mtk.h                                         |    6 
 drivers/usb/serial/ti_usb_3410_5052.c                               |    9 
 drivers/usb/serial/usb_wwan.c                                       |    9 
 drivers/usb/typec/tcpm/tcpci.c                                      |   21 
 drivers/usb/typec/tcpm/tcpm.c                                       |  105 +-
 drivers/usb/usbip/vudc_sysfs.c                                      |    2 
 drivers/vfio/mdev/mdev_sysfs.c                                      |    2 
 fs/overlayfs/copy_up.c                                              |    3 
 include/linux/hid.h                                                 |    2 
 include/linux/kvm_host.h                                            |    4 
 include/linux/smp.h                                                 |    2 
 include/linux/spi/spi.h                                             |    3 
 include/linux/tty_driver.h                                          |    2 
 include/net/addrconf.h                                              |    1 
 include/net/bluetooth/hci_core.h                                    |    1 
 include/uapi/linux/tty_flags.h                                      |    4 
 kernel/sched/debug.c                                                |   42 
 kernel/smp.c                                                        |   10 
 kernel/up.c                                                         |    2 
 lib/bug.c                                                           |   33 
 mm/memory-failure.c                                                 |    2 
 mm/sparse.c                                                         |    1 
 net/bluetooth/hci_event.c                                           |    3 
 net/bluetooth/hci_request.c                                         |   12 
 net/bridge/br_multicast.c                                           |   33 
 net/core/dev.c                                                      |    8 
 net/hsr/hsr_framereg.c                                              |    3 
 net/ipv4/route.c                                                    |   42 
 net/ipv4/tcp_cong.c                                                 |    4 
 net/ipv6/mcast_snoop.c                                              |   12 
 net/mac80211/main.c                                                 |    7 
 net/nfc/digital_dep.c                                               |    2 
 net/nfc/llcp_sock.c                                                 |    4 
 net/sctp/socket.c                                                   |   38 
 net/vmw_vsock/vmci_transport.c                                      |    3 
 net/wireless/scan.c                                                 |    2 
 samples/kfifo/bytestream-example.c                                  |    8 
 samples/kfifo/inttype-example.c                                     |    8 
 samples/kfifo/record-example.c                                      |    8 
 sound/core/init.c                                                   |    2 
 sound/pci/hda/patch_realtek.c                                       |  127 +-
 sound/soc/codecs/ak5558.c                                           |    4 
 sound/soc/generic/audio-graph-card.c                                |    2 
 sound/soc/generic/simple-card.c                                     |    2 
 sound/soc/intel/boards/kbl_da7219_max98927.c                        |   38 
 sound/soc/samsung/tm2_wm5110.c                                      |    2 
 sound/usb/card.c                                                    |   14 
 sound/usb/midi.c                                                    |    2 
 sound/usb/quirks.c                                                  |   16 
 sound/usb/usbaudio.h                                                |    2 
 tools/perf/trace/beauty/fsconfig.sh                                 |    7 
 tools/perf/util/symbol_fprintf.c                                    |    2 
 tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh |    2 
 virt/kvm/coalesced_mmio.c                                           |   19 
 virt/kvm/kvm_main.c                                                 |   10 
 229 files changed, 2005 insertions(+), 1065 deletions(-)

Alexander Lobakin (1):
      gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check

Andrew Scull (1):
      bug: Remove redundant condition check in report_bug

Andy Shevchenko (4):
      usb: gadget: pch_udc: Revert d3cb25a12138 completely
      usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
      usb: gadget: pch_udc: Check if driver is present before calling ->setup()
      usb: gadget: pch_udc: Check for DMA mapping error

Antonio Borneo (1):
      spi: stm32: drop devres version of spi_register_master

Archie Pusaka (1):
      Bluetooth: verify AMP hci_chan before amp_destroy

Arnaldo Carvalho de Melo (1):
      perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Arnd Bergmann (2):
      irqchip/gic-v3: Fix OF_BAD_ADDR error handling
      smp: Fix smp_call_function_single_async prototype

Artur Petrosyan (2):
      usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.
      usb: dwc2: Fix hibernation between host and device modes.

Arun Easi (1):
      PCI: Allow VPD access for QLogic ISP2722

Athira Rajeev (1):
      powerpc/perf: Fix PMU constraint check for EBB events

Badhri Jagan Sridharan (4):
      usb: typec: tcpm: Address incorrect values of tcpm psy for fixed supply
      usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply
      usb: typec: tcpm: update power supply once partner accepts
      usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS

Bjorn Andersson (2):
      soc: qcom: mdt_loader: Validate that p_filesz < p_memsz
      soc: qcom: mdt_loader: Detect truncated read of segments

Boris Brezillon (2):
      drm/panfrost: Clear MMU irqs before handling the fault
      drm/panfrost: Don't try to map pages that are already mapped

Brian King (1):
      scsi: ibmvfc: Fix invalid state machine BUG_ON()

Chen Huang (1):
      powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration

Chen Hui (1):
      clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE

Christoph Hellwig (2):
      md: split mddev_find
      md: factor out a mddev_find_locked helper from mddev_find

Christophe Leroy (1):
      powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Chunfeng Yun (2):
      usb: xhci-mtk: remove or operator for setting schedule parameters
      usb: xhci-mtk: improve bandwidth scheduling with TT

Claudio Imbrenda (2):
      KVM: s390: split kvm_s390_logical_to_effective
      KVM: s390: split kvm_s390_real_to_abs

Colin Ian King (13):
      drm/radeon: fix copy of uninitialized variable back to userspace
      memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
      staging: rtl8192u: Fix potential infinite loop
      usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
      media: vivid: fix assignment of dev->fbuf_out_flags
      media: m88rs6000t: avoid potential out-of-bounds reads on arrays
      clk: uniphier: Fix potential infinite loop
      liquidio: Fix unintented sign extension of a left shift of a u16
      mt7601u: fix always true expression
      cxgb4: Fix unintentional sign extension issues
      net: thunderx: Fix unintentional sign extension issue
      ALSA: usb: midi: don't return -ENOMEM when usb_urb_ep_type_check fails
      net: davinci_emac: Fix incorrect masking of tx and rx error channel

Cédric Le Goater (1):
      powerpc/xive: Fix xmon command "dxi"

Dan Carpenter (10):
      ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
      ovl: fix missing revert_creds() on error path
      mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()
      node: fix device cleanups in error handling code
      soc: aspeed: fix a ternary sign expansion bug
      HSI: core: fix resource leaks in hsi_add_client_from_dt()
      nfc: pn533: prevent potential memory corruption
      drm/i915/gvt: Fix error code in intel_gvt_init_device()
      bnxt_en: fix ternary sign extension bug in bnxt_show_temp()
      kfifo: fix ternary sign extension bugs

David Hildenbrand (1):
      s390: fix detection of vector enhancements facility 1 vs. vector packed decimal facility

Dong Aisheng (1):
      PM / devfreq: Use more accurate returned new_freq as resume_freq

Eric Dumazet (1):
      inet: use bigger hash table for IP ID generation

Erwan Le Ray (2):
      serial: stm32: fix incorrect characters on console
      serial: stm32: fix tx_empty condition

Fabian Vogt (6):
      fotg210-udc: Fix DMA on EP0 for length > max packet size
      fotg210-udc: Fix EP0 IN requests bigger than two packets
      fotg210-udc: Remove a dubious condition leading to fotg210_done
      fotg210-udc: Mask GRP2 interrupts we don't handle
      fotg210-udc: Don't DMA more than the buffer can take
      fotg210-udc: Complete OUT requests on short packets

Fabrice Gasnier (1):
      mfd: stm32-timers: Avoid clearing auto reload register

Felix Kuehling (1):
      drm/amdkfd: fix build error with AMD_IOMMU_V2=m

Finn Thain (1):
      m68k: mvme147,mvme16x: Don't wipe PCC timer config bits

Geert Uytterhoeven (1):
      phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally

Giovanni Cabiddu (1):
      crypto: qat - fix error path in adf_isr_resource_alloc()

Greg Kroah-Hartman (1):
      Linux 5.4.119

Hannes Reinecke (1):
      nvme: retrigger ANA log update if group descriptor isn't found

Hans Verkuil (1):
      media: v4l2-ctrls.c: fix race condition in hdl->requests list

Hans de Goede (1):
      misc: lis3lv02d: Fix false-positive WARN on various HP models

Harry Wentland (1):
      drm/amd/display: Reject non-zero src_y and src_x for video planes

He Ying (1):
      firmware: qcom-scm: Fix QCOM_SCM configuration

Heiko Carstens (1):
      KVM: s390: fix guarded storage control register handling

Heming Zhao (1):
      md-cluster: fix use-after-free issue when removing rdev

Ilya Lipnitskiy (3):
      MIPS: pci-mt7620: fix PLL lock check
      MIPS: pci-rt2880: fix slot 0 configuration
      MIPS: pci-legacy: stop using of_pci_range_to_resource

Ingo Molnar (1):
      x86/platform/uv: Fix !KEXEC build failure

Jae Hyun Yoo (2):
      Revert "i3c master: fix missing destroy_workqueue() on error in i3c_master_register"
      media: aspeed: fix clock handling logic

Jan Glauber (1):
      md: Fix missing unused status line of /proc/mdstat

Jane Chu (1):
      mm/memory-failure: unnecessary amount of unmapping

Jason Gunthorpe (1):
      vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer

Jia Zhou (1):
      ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Jia-Ju Bai (1):
      media: platform: sunxi: sun6i-csi: fix error return code of sun6i_video_start_streaming()

Johan Hovold (15):
      Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"
      tty: moxa: fix TIOCSSERIAL jiffies conversions
      tty: amiserial: fix TIOCSSERIAL permission check
      USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions
      staging: greybus: uart: fix TIOCSSERIAL jiffies conversions
      USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check
      staging: fwserial: fix TIOCSSERIAL jiffies conversions
      tty: moxa: fix TIOCSSERIAL permission check
      staging: fwserial: fix TIOCSSERIAL permission check
      staging: greybus: uart: fix unprivileged TIOCCSERIAL
      USB: cdc-acm: fix unprivileged TIOCCSERIAL
      USB: cdc-acm: fix TIOCGSERIAL implementation
      tty: actually undefine superseded ASYNC flags
      tty: fix return value for unsupported ioctls
      serial: core: return early on unsupported ioctls

Johannes Berg (2):
      cfg80211: scan: drop entry from hidden_list on overflow
      mac80211: bail out if cipher schemes are invalid

Jonathan Cameron (1):
      iio:accel:adis16201: Fix wrong axis assignment that prevents loading

Jonathon Reinhart (1):
      net: Only allow init netns to set default tcp cong to a restricted algo

Jordan Niethe (1):
      powerpc/64s: Fix pte update for kernel memory on radix

Krzysztof Kozlowski (7):
      ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
      ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family
      ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family
      ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
      ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
      ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
      ASoC: simple-card: fix possible uninitialized single_cpu local variable

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
      arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Lin Ma (1):
      bluetooth: eliminate the potential race condition when removing the HCI controller

Linus Lüssing (1):
      net: bridge: mcast: fix broken length + header check for MRDv6 Adv.

Lukasz Majczak (1):
      ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function

Lv Yunlong (8):
      mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init
      crypto: qat - Fix a double free in adf_create_ring
      drivers/block/null_blk/main: Fix a double free in null_init.
      mwl8k: Fix a double Free in mwl8k_probe_hw
      net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
      RDMA/siw: Fix a use after free in siw_alloc_mr
      RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res
      net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Maciej W. Rozycki (1):
      FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR

Manivannan Sadhasivam (2):
      mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()
      mtd: rawnand: qcom: Return actual error code instead of -ENODEV

Marek Behún (2):
      cpufreq: armada-37xx: Fix setting TBG parent for load levels
      clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock

Martin Schiller (1):
      net: phy: intel-xway: enable integrated led functions

Masami Hiramatsu (1):
      x86/kprobes: Fix to check non boostable prefixes correctly

Maxim Mikityanskiy (1):
      HID: plantronics: Workaround for double volume key presses

Meng Li (1):
      regmap: set debugfs_name to NULL after it is freed

Michael Chan (1):
      bnxt_en: Fix RX consumer index logic in the error path.

Michael Kelley (1):
      Drivers: hv: vmbus: Increase wait time for VMbus unload

Michael Walle (1):
      mtd: require write permissions for locking and badblock ioctls

Nathan Chancellor (4):
      ACPI: CPPC: Replace cppc_attr with kobj_attribute
      x86/events/amd/iommu: Fix sysfs type mismatch
      powerpc/fadump: Mark fadump_calculate_reserve_size as __init
      powerpc/prom: Mark identical_pvr_fixup as __init

Nicholas Piggin (1):
      KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit

Niklas Cassel (1):
      nvme-pci: don't simple map sgl when sgls are disabled

Or Cohen (1):
      net/nfc: fix use-after-free llcp_sock_bind/connect

Otavio Pontes (1):
      x86/microcode: Check for offline CPUs before requesting new microcode

Pali Rohár (5):
      cpufreq: armada-37xx: Fix the AVS value for load L1
      clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz
      clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0
      cpufreq: armada-37xx: Fix driver cleanup when registration failed
      cpufreq: armada-37xx: Fix determining base CPU frequency

Pan Bian (1):
      bus: qcom: Put child node before return

Paul Durrant (1):
      xen-blkback: fix compatibility bug with single page rings

Petr Machata (1):
      selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static

Phillip Potter (1):
      net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Pierre-Louis Bossart (1):
      ASoC: samsung: tm2_wm5110: check of of_parse return value

Ping-Ke Shih (2):
      rtw88: Fix array overrun in rtw_get_tx_power_params()
      rtlwifi: 8821ae: upgrade PHY and RF parameters

Potnuri Bharat Teja (1):
      RDMA/cxgb4: add missing qpid increment

Qinglang Miao (4):
      i2c: img-scb: fix reference leak when pm_runtime_get_sync fails
      i2c: imx-lpi2c: fix reference leak when pm_runtime_get_sync fails
      i2c: omap: fix reference leak when pm_runtime_get_sync fails
      i2c: sprd: fix reference leak when pm_runtime_get_sync fails

Quanyang Wang (1):
      clk: zynqmp: move zynqmp_pll_set_mode out of round_rate callback

Quentin Perret (2):
      Revert "of/fdt: Make sure no-map does not remove already reserved regions"
      Revert "fdt: Properly handle "no-map" field in the memory region"

Rander Wang (1):
      soundwire: stream: fix memory leak in stream config error path

Randy Dunlap (1):
      powerpc: iommu: fix build when neither PCI or IBMVIO is set

Sagi Grimberg (2):
      nvme-tcp: block BH in sk state_change sk callback
      nvmet-tcp: fix incorrect locking in state_change sk callback

Salil Mehta (1):
      net: hns3: Limiting the scope of vector_ring_chain variable

Sami Loone (1):
      ALSA: hda/realtek: ALC285 Thinkpad jack pin quirk is unreachable

Sean Christopherson (2):
      KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in !64-bit
      KVM: Stop looking for coalesced MMIO zones if the bus is destroyed

Sergey Shtylyov (13):
      pata_arasan_cf: fix IRQ check
      pata_ipx4xx_cf: fix IRQ check
      sata_mv: add IRQ checks
      ata: libahci_platform: fix IRQ check
      scsi: hisi_sas: Fix IRQ checks
      scsi: jazz_esp: Add IRQ check
      scsi: sun3x_esp: Add IRQ check
      scsi: sni_53c710: Add IRQ check
      i2c: cadence: add IRQ check
      i2c: emev2: add IRQ check
      i2c: jz4780: add IRQ check
      i2c: sh7760: add IRQ check
      i2c: sh7760: fix IRQ error path

Shawn Guo (1):
      arm64: dts: qcom: sm8150: fix number of pins in 'gpio-ranges'

Shengjiu Wang (1):
      ASoC: ak5558: correct reset polarity

Shuah Khan (1):
      ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Sindhu Devale (1):
      RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Srinivas Kandagatla (1):
      soundwire: bus: Fix device found flag correctly

Stefano Garzarella (1):
      vsock/vmci: log once the failed queue pair allocation

Steffen Dirkwinkel (1):
      platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table

Sudhakar Panneerselvam (1):
      md/bitmap: wait for external bitmap writes to complete during tear down

Taehee Yoo (1):
      hsr: use netdev_err() instead of WARN_ONCE()

Takashi Iwai (13):
      ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Clevo quirk table entries
      ALSA: hda/realtek: Re-order ALC269 HP quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Acer quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries
      ALSA: hda/realtek: Re-order ALC269 ASUS quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries
      ALSA: hda/realtek: Re-order remaining ALC269 quirk table entries
      ALSA: hda/realtek: Re-order ALC662 quirk table entries
      ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices
      ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Tao Ren (1):
      usb: gadget: aspeed: fix dma map failure

Tetsuo Handa (3):
      misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct
      misc: vmw_vmci: explicitly initialize vmci_datagram payload
      ttyprintk: Add TTY hangup callback.

Toke Høiland-Jørgensen (1):
      ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Tong Zhang (2):
      crypto: qat - don't release uninitialized resources
      crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

Tyrel Datwyler (1):
      powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Vitaly Chikunov (1):
      perf beauty: Fix fsconfig generator

Vladimir Barinov (1):
      arm64: dts: renesas: r8a77980: Fix vin4-7 endpoint binding

Waiman Long (1):
      sched/debug: Fix cgroup_path[] serialization

Wang Li (1):
      spi: fsl-lpspi: Fix PM reference leak in lpspi_prepare_xfer_hardware()

Wang Wensheng (4):
      RDMA/qedr: Fix error return code in qedr_iw_connect()
      IB/hfi1: Fix error return code in parse_platform_config()
      RDMA/srpt: Fix error return code in srpt_cm_req_recv()
      mm/sparse: add the missing sparse_buffer_fini() in error branch

William A. Kennington III (1):
      spi: Fix use-after-free with devm_spi_alloc_*

Xie He (1):
      net: lapbether: Prevent racing when checking whether the netif is running

Xin Long (2):
      Revert "net/sctp: fix race condition in sctp_destroy_sock"
      sctp: delay auto_asconf init until binding the first addr

Yang Yingliang (2):
      USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()
      media: omap4iss: return error code when omap4iss_get() failed

Ye Bin (1):
      usbip: vudc: fix missing unlock on error in usbip_sockfd_store()

Yoshihiro Shimoda (1):
      net: renesas: ravb: Fix a stuck issue when a lot of frames are received

Zhao Heming (1):
      md: md_open returns -EBUSY when entering racing area

gexueyuan (1):
      memory: pl353: fix mask of ECC page_size config register

Álvaro Fernández Rojas (2):
      mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC
      mips: bmips: fix syscon-reboot nodes

