Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E838D4A2
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 10:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhEVI62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 04:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbhEVI62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 04:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B3661183;
        Sat, 22 May 2021 08:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621673823;
        bh=MlBOZp/J+I6e58s/paoCjcxcpCnBOHSEGdyvH/eo8Co=;
        h=From:To:Cc:Subject:Date:From;
        b=KXNgQfHNn+g5oBChFnXXJPYV4Q19zOAKAigfyxfcQIpg5XSr5j05lOjI9iC0+y5dP
         Ch0XNNF4quQOgoLnSmn6IMYErpWkCRdOcEiTAQphBpK7IzMpYi94q+CyZSJWMutL+U
         DIdmZksvMHJ1DlNwcrpyWolvjAiOeR8ol2+m7sx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.269
Date:   Sat, 22 May 2021 10:56:57 +0200
Message-Id: <1621673817181180@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.269 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arc/kernel/entry.S                               |    4 -
 arch/arm/boot/dts/exynos5250-smdk5250.dts             |    2 
 arch/arm/boot/dts/exynos5250-snow-common.dtsi         |    2 
 arch/arm/kernel/hw_breakpoint.c                       |    2 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi              |    2 
 arch/arm64/kernel/vdso/vdso.lds.S                     |    8 ++
 arch/mips/include/asm/div64.h                         |   55 +++++++++++-----
 arch/mips/pci/pci-legacy.c                            |    9 ++
 arch/powerpc/Kconfig.debug                            |    1 
 arch/powerpc/include/uapi/asm/errno.h                 |    1 
 arch/powerpc/kernel/eeh.c                             |   11 +--
 arch/powerpc/kernel/iommu.c                           |    4 -
 arch/powerpc/kernel/prom.c                            |    2 
 arch/powerpc/lib/feature-fixups.c                     |   17 ++++-
 arch/powerpc/perf/isa207-common.c                     |    4 -
 arch/powerpc/platforms/52xx/lite5200_sleep.S          |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c          |    3 
 arch/powerpc/platforms/pseries/pci_dlpar.c            |    4 -
 arch/s390/kernel/dis.c                                |    2 
 arch/um/kernel/dyn.lds.S                              |    6 +
 arch/um/kernel/uml.lds.S                              |    6 +
 arch/x86/Kconfig                                      |    1 
 arch/x86/Makefile                                     |    1 
 arch/x86/events/amd/iommu.c                           |    6 -
 arch/x86/kvm/x86.c                                    |    1 
 arch/x86/lib/msr-smp.c                                |    4 -
 drivers/acpi/custom_method.c                          |    4 -
 drivers/acpi/scan.c                                   |    1 
 drivers/ata/libahci_platform.c                        |    4 -
 drivers/ata/pata_arasan_cf.c                          |   15 +++-
 drivers/ata/pata_ixp4xx_cf.c                          |    6 +
 drivers/ata/sata_mv.c                                 |    4 +
 drivers/bus/qcom-ebi2.c                               |    4 -
 drivers/char/ttyprintk.c                              |   11 +++
 drivers/clk/samsung/clk-exynos7.c                     |    7 +-
 drivers/clk/socfpga/clk-gate-a10.c                    |    1 
 drivers/clk/uniphier/clk-uniphier-mux.c               |    4 -
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c              |    4 -
 drivers/crypto/qat/qat_c62xvf/adf_drv.c               |    4 -
 drivers/crypto/qat/qat_common/adf_isr.c               |   29 ++++++--
 drivers/crypto/qat/qat_common/adf_transport.c         |    1 
 drivers/crypto/qat/qat_common/adf_vf_isr.c            |   17 +++--
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c           |    4 -
 drivers/extcon/extcon-arizona.c                       |   17 ++---
 drivers/firmware/Kconfig                              |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c               |    2 
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c       |   10 ++-
 drivers/gpu/drm/radeon/radeon_atombios.c              |    6 -
 drivers/gpu/drm/radeon/radeon_kms.c                   |    1 
 drivers/hid/hid-ids.h                                 |    1 
 drivers/hid/hid-plantronics.c                         |   60 +++++++++++++++++-
 drivers/hsi/hsi_core.c                                |    3 
 drivers/hv/channel_mgmt.c                             |   30 +++++++--
 drivers/hwtracing/intel_th/gth.c                      |    4 -
 drivers/i2c/busses/i2c-cadence.c                      |    5 +
 drivers/i2c/busses/i2c-emev2.c                        |    5 +
 drivers/i2c/busses/i2c-jz4780.c                       |    5 +
 drivers/i2c/busses/i2c-sh7760.c                       |    5 +
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c     |    1 
 drivers/infiniband/hw/i40iw/i40iw_pble.c              |    6 -
 drivers/input/touchscreen/silead.c                    |   44 ++++++++++++-
 drivers/isdn/capi/kcapi.c                             |    4 -
 drivers/md/dm-ioctl.c                                 |    2 
 drivers/md/dm-rq.c                                    |    2 
 drivers/md/md.c                                       |   43 +++++++-----
 drivers/md/persistent-data/dm-btree-internal.h        |    4 -
 drivers/md/persistent-data/dm-space-map-common.c      |    2 
 drivers/md/persistent-data/dm-space-map-common.h      |    8 +-
 drivers/media/dvb-core/dvbdev.c                       |    1 
 drivers/media/i2c/adv7511-v4l2.c                      |    2 
 drivers/media/i2c/adv7604.c                           |    2 
 drivers/media/i2c/adv7842.c                           |    2 
 drivers/media/pci/saa7164/saa7164-encoder.c           |   20 +++---
 drivers/media/platform/vivid/vivid-vid-out.c          |    2 
 drivers/media/rc/ite-cir.c                            |    8 ++
 drivers/media/tuners/m88rs6000t.c                     |    6 -
 drivers/media/usb/dvb-usb/dvb-usb-init.c              |   20 ++++--
 drivers/media/usb/dvb-usb/dvb-usb.h                   |    3 
 drivers/media/usb/em28xx/em28xx-dvb.c                 |    1 
 drivers/media/usb/gspca/gspca.c                       |    2 
 drivers/media/usb/gspca/gspca.h                       |    1 
 drivers/media/usb/gspca/sq905.c                       |    2 
 drivers/media/usb/gspca/stv06xx/stv06xx.c             |    9 ++
 drivers/memory/omap-gpmc.c                            |    7 +-
 drivers/misc/kgdbts.c                                 |   26 +++----
 drivers/misc/lis3lv02d/lis3lv02d.c                    |   21 ++++--
 drivers/misc/vmw_vmci/vmci_doorbell.c                 |    2 
 drivers/misc/vmw_vmci/vmci_guest.c                    |    2 
 drivers/mmc/core/core.c                               |    2 
 drivers/mmc/core/sd.c                                 |    6 +
 drivers/mtd/mtdchar.c                                 |    8 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c                |    2 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c    |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h           |    1 
 drivers/net/ethernet/qualcomm/emac/emac-mac.c         |    4 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c   |    2 
 drivers/net/ethernet/ti/davinci_emac.c                |    4 -
 drivers/net/fddi/Kconfig                              |   15 ++--
 drivers/net/fddi/defxx.c                              |   47 +++++++++-----
 drivers/net/usb/ax88179_178a.c                        |    4 -
 drivers/net/wan/lapbether.c                           |   32 +++++++--
 drivers/net/wimax/i2400m/op-rfkill.c                  |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c         |    2 
 drivers/net/wireless/ath/ath9k/hw.c                   |    2 
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c        |    6 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          |    7 +-
 drivers/net/wireless/marvell/mwl8k.c                  |    1 
 drivers/net/wireless/mediatek/mt7601u/eeprom.c        |    2 
 drivers/net/wireless/wl3501.h                         |   47 ++++++--------
 drivers/net/wireless/wl3501_cs.c                      |   54 ++++++++--------
 drivers/nfc/pn533/pn533.c                             |    3 
 drivers/of/fdt.c                                      |   12 ---
 drivers/pci/hotplug/acpiphp_glue.c                    |    1 
 drivers/pci/pci.c                                     |   16 ----
 drivers/pci/probe.c                                   |    1 
 drivers/phy/phy-twl4030-usb.c                         |    2 
 drivers/platform/x86/thinkpad_acpi.c                  |   31 ++++++---
 drivers/power/supply/generic-adc-battery.c            |    2 
 drivers/power/supply/lp8788-charger.c                 |    2 
 drivers/power/supply/pm2301_charger.c                 |    2 
 drivers/power/supply/s3c_adc_battery.c                |    2 
 drivers/power/supply/tps65090-charger.c               |    2 
 drivers/power/supply/tps65217_charger.c               |    2 
 drivers/scsi/device_handler/scsi_dh_alua.c            |    5 -
 drivers/scsi/jazz_esp.c                               |    4 -
 drivers/scsi/libfc/fc_lport.c                         |    2 
 drivers/scsi/lpfc/lpfc_nportdisc.c                    |    2 
 drivers/scsi/lpfc/lpfc_sli.c                          |    1 
 drivers/scsi/qla2xxx/qla_attr.c                       |    8 ++
 drivers/scsi/sni_53c710.c                             |    5 +
 drivers/scsi/sun3x_esp.c                              |    4 -
 drivers/spi/spi-dln2.c                                |    2 
 drivers/spi/spi-omap-100k.c                           |    6 -
 drivers/staging/greybus/uart.c                        |    2 
 drivers/staging/media/omap4iss/iss.c                  |    4 -
 drivers/staging/rtl8192u/r8192U_core.c                |    2 
 drivers/target/target_core_pscsi.c                    |    3 
 drivers/thermal/fair_share.c                          |    4 +
 drivers/tty/serial/stm32-usart.c                      |   12 +++
 drivers/tty/tty_io.c                                  |    8 +-
 drivers/usb/class/cdc-acm.c                           |    2 
 drivers/usb/core/hub.c                                |    6 -
 drivers/usb/core/quirks.c                             |    4 +
 drivers/usb/dwc2/core.h                               |    2 
 drivers/usb/dwc2/gadget.c                             |    3 
 drivers/usb/dwc3/gadget.c                             |    9 ++
 drivers/usb/gadget/config.c                           |    4 +
 drivers/usb/gadget/function/f_fs.c                    |    3 
 drivers/usb/gadget/function/f_uvc.c                   |    7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                    |   23 ++++--
 drivers/usb/gadget/udc/fotg210-udc.c                  |   26 +++++--
 drivers/usb/gadget/udc/pch_udc.c                      |   49 +++++++++-----
 drivers/usb/gadget/udc/r8a66597-udc.c                 |    2 
 drivers/usb/host/fotg210-hcd.c                        |    4 -
 drivers/usb/host/sl811-hcd.c                          |    9 +-
 drivers/usb/host/xhci-ext-caps.h                      |    5 -
 drivers/usb/host/xhci-mem.c                           |    9 ++
 drivers/usb/host/xhci.c                               |    6 -
 drivers/video/fbdev/core/fbcmap.c                     |    8 +-
 fs/btrfs/ioctl.c                                      |   18 ++++-
 fs/btrfs/relocation.c                                 |    6 -
 fs/ceph/caps.c                                        |    1 
 fs/ceph/inode.c                                       |    1 
 fs/dlm/debug_fs.c                                     |    1 
 fs/ecryptfs/main.c                                    |    6 +
 fs/ext4/ialloc.c                                      |   48 +++++++++-----
 fs/ext4/super.c                                       |    6 +
 fs/f2fs/inline.c                                      |    3 
 fs/fuse/cuse.c                                        |    2 
 fs/jffs2/compr_rtime.c                                |    3 
 fs/jffs2/scan.c                                       |    2 
 fs/nfs/flexfilelayout/flexfilelayout.c                |    2 
 fs/nfs/inode.c                                        |    8 +-
 fs/nfs/nfs42proc.c                                    |   21 +++---
 fs/nfs/pnfs.c                                         |    2 
 fs/squashfs/file.c                                    |    6 -
 include/linux/extcon/extcon-adc-jack.h                |    2 
 include/linux/hid.h                                   |    2 
 include/linux/tty_driver.h                            |    2 
 include/net/bluetooth/hci_core.h                      |    1 
 include/scsi/libfcoe.h                                |    2 
 include/uapi/linux/tty_flags.h                        |    4 -
 kernel/futex.c                                        |    3 
 kernel/kexec_file.c                                   |    4 -
 kernel/trace/ftrace.c                                 |    5 +
 kernel/trace/trace.c                                  |   45 +++++--------
 kernel/trace/trace_clock.c                            |   44 +++++++++----
 lib/kobject_uevent.c                                  |    9 +-
 lib/stackdepot.c                                      |    6 -
 mm/hugetlb.c                                          |   11 ++-
 mm/khugepaged.c                                       |   18 ++---
 mm/ksm.c                                              |    1 
 net/bluetooth/hci_event.c                             |    3 
 net/bluetooth/hci_request.c                           |   12 ++-
 net/bluetooth/l2cap_core.c                            |    4 +
 net/hsr/hsr_framereg.c                                |    3 
 net/ipv6/ip6_gre.c                                    |    3 
 net/ipv6/ip6_tunnel.c                                 |    3 
 net/ipv6/ip6_vti.c                                    |    3 
 net/ipv6/sit.c                                        |    5 -
 net/mac80211/main.c                                   |    7 +-
 net/mac80211/mlme.c                                   |    5 +
 net/netfilter/nf_conntrack_standalone.c               |    5 +
 net/nfc/digital_dep.c                                 |    2 
 net/nfc/llcp_sock.c                                   |    4 +
 net/openvswitch/actions.c                             |    8 +-
 net/sctp/sm_make_chunk.c                              |    2 
 net/sctp/sm_statefuns.c                               |    3 
 net/sctp/socket.c                                     |   38 ++++++-----
 net/tipc/netlink_compat.c                             |    2 
 net/vmw_vsock/vmci_transport.c                        |    3 
 net/wireless/scan.c                                   |    2 
 samples/bpf/tracex1_kern.c                            |    4 -
 samples/kfifo/bytestream-example.c                    |    8 +-
 samples/kfifo/inttype-example.c                       |    8 +-
 samples/kfifo/record-example.c                        |    8 +-
 scripts/kconfig/nconf.c                               |    2 
 sound/core/init.c                                     |    2 
 sound/isa/sb/emu8000.c                                |    4 -
 sound/isa/sb/sb16_csp.c                               |    8 +-
 sound/pci/hda/hda_generic.c                           |   16 +++-
 sound/pci/hda/patch_realtek.c                         |   21 +++---
 sound/pci/rme9652/hdsp.c                              |    3 
 sound/pci/rme9652/hdspm.c                             |    3 
 sound/pci/rme9652/rme9652.c                           |    3 
 sound/soc/codecs/rt286.c                              |   23 +++---
 sound/usb/card.c                                      |   14 ++--
 sound/usb/quirks-table.h                              |   10 +++
 sound/usb/quirks.c                                    |   16 +++-
 sound/usb/usbaudio.h                                  |    2 
 tools/perf/util/symbol_fprintf.c                      |    2 
 tools/testing/selftests/lib.mk                        |    4 +
 236 files changed, 1236 insertions(+), 620 deletions(-)

Alexander Aring (1):
      fs: dlm: fix debugfs dump

Alexey Kardashevskiy (1):
      powerpc/iommu: Annotate nested lock for lockdep

Amey Telawane (1):
      tracing: Use strlcpy() instead of strcpy() in __trace_find_cmdline()

Andy Shevchenko (4):
      usb: gadget: pch_udc: Revert d3cb25a12138 completely
      usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
      usb: gadget: pch_udc: Check if driver is present before calling ->setup()
      usb: gadget: pch_udc: Check for DMA mapping error

Anirudh Rayabharam (1):
      usb: gadget: dummy_hcd: fix gpf in gadget_setup

Archie Pusaka (2):
      Bluetooth: verify AMP hci_chan before amp_destroy
      Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default

Arnaldo Carvalho de Melo (1):
      perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Arnd Bergmann (6):
      scsi: fcoe: Fix mismatched fcoe_wwn_from_mac declaration
      media: dvb-usb-remote: fix dvb_usb_nec_rc_key_to_event type mismatch
      x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
      kgdb: fix gcc-11 warning on indentation
      usb: sl811-hcd: improve misleading indentation
      isdn: capi: fix mismatched prototypes

Athira Rajeev (1):
      powerpc/perf: Fix PMU constraint check for EBB events

Bart Van Assche (2):
      scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
      scsi: libfc: Fix a format specifier

Benjamin Block (1):
      dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Bill Wendling (1):
      arm64/vdso: Discard .note.gnu.property sections in vDSO

Chaitanya Kulkarni (1):
      scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

Chris Chiu (1):
      USB: Add reset-resume quirk for WD19's Realtek Hub

Christoph Hellwig (1):
      md: factor out a mddev_find_locked helper from mddev_find

Christophe JAILLET (3):
      usb: fotg210-hcd: Fix an error message
      ACPI: scan: Fix a memory leak in an error handling path
      xhci: Do not use GFP_KERNEL in (potentially) atomic context

Christophe Leroy (1):
      powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Chunfeng Yun (2):
      arm64: dts: mt8173: fix property typo of 'phys' in dsi node
      usb: core: hub: fix race condition about TRSMRCY of resume

Colin Ian King (13):
      clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
      drm/radeon: fix copy of uninitialized variable back to userspace
      memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
      staging: rtl8192u: Fix potential infinite loop
      usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
      media: vivid: fix assignment of dev->fbuf_out_flags
      media: m88rs6000t: avoid potential out-of-bounds reads on arrays
      clk: uniphier: Fix potential infinite loop
      liquidio: Fix unintented sign extension of a left shift of a u16
      mt7601u: fix always true expression
      net: thunderx: Fix unintentional sign extension issue
      net: davinci_emac: Fix incorrect masking of tx and rx error channel
      f2fs: fix a redundant call to f2fs_balance_fs if an error occurs

Dan Carpenter (4):
      ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
      HSI: core: fix resource leaks in hsi_add_client_from_dt()
      nfc: pn533: prevent potential memory corruption
      kfifo: fix ternary sign extension bugs

Daniel Niv (1):
      media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

David Ward (2):
      ASoC: rt286: Generalize support for ALC3263 codec
      ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Davide Caratti (1):
      openvswitch: fix stack OOB read while fragmenting IPv4 packets

Dean Anderson (1):
      usb: gadget/function/f_fs string table fix for multiple languages

Dinghao Liu (1):
      iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Dmitry Baryshkov (1):
      PCI: Release OF node in pci_scan_device()'s error path

DooHyun Hwang (1):
      mmc: core: Do a power cycle when the CMD11 fails

Emmanuel Grumbach (1):
      mac80211: clear the beacon's CRC after channel switch

Eric Dumazet (4):
      ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
      sit: proper dev_{hold|put} in ndo_[un]init methods
      ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
      ipv6: remove extra dev_hold() for fallback tunnels

Erwan Le Ray (1):
      serial: stm32: fix incorrect characters on console

Ewan D. Milne (1):
      scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Fabian Vogt (6):
      fotg210-udc: Fix DMA on EP0 for length > max packet size
      fotg210-udc: Fix EP0 IN requests bigger than two packets
      fotg210-udc: Remove a dubious condition leading to fotg210_done
      fotg210-udc: Mask GRP2 interrupts we don't handle
      fotg210-udc: Don't DMA more than the buffer can take
      fotg210-udc: Complete OUT requests on short packets

Feilong Lin (1):
      ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: fix RX VLAN offload

Fengnan Chang (1):
      ext4: fix error code in ext4_commit_super

Filipe Manana (1):
      btrfs: fix metadata extent leak after failure to create subvolume

Giovanni Cabiddu (1):
      crypto: qat - fix error path in adf_isr_resource_alloc()

Greg Kroah-Hartman (2):
      kobject_uevent: remove warning in init_uevent_argv()
      Linux 4.9.269

Guchun Chen (1):
      drm/amdgpu: fix NULL pointer dereference

Gustavo A. R. Silva (3):
      sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
      wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
      wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Hans Verkuil (2):
      media: gspca/sq905.c: fix uninitialized variable
      media: gscpa/stv06xx: fix memory leak

Hans de Goede (3):
      extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
      misc: lis3lv02d: Fix false-positive WARN on various HP models
      Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state

He Ying (1):
      firmware: qcom-scm: Fix QCOM_SCM configuration

Hemant Kumar (1):
      usb: gadget: Fix double free of device descriptor pointers

Heming Zhao (1):
      md-cluster: fix use-after-free issue when removing rdev

Hoang Le (1):
      tipc: convert dest node's address to network order

Hui Wang (1):
      ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

Ilya Lipnitskiy (1):
      MIPS: pci-legacy: stop using of_pci_range_to_resource

Ingo Molnar (1):
      x86/platform/uv: Fix !KEXEC build failure

James Smart (1):
      scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response

Jeff Layton (1):
      ceph: fix fscache invalidation

Jeffrey Mitchell (1):
      ecryptfs: fix kernel panic with null dev_name

Jia Zhou (1):
      ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Jia-Ju Bai (1):
      kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Joe Thornber (2):
      dm persistent data: packed struct should have an aligned() attribute too
      dm space map common: fix division bug in sm_ll_find_free_block()

Joel Fernandes (1):
      tracing: Treat recording comm for idle task as a success

Johan Hovold (4):
      staging: greybus: uart: fix unprivileged TIOCCSERIAL
      USB: cdc-acm: fix unprivileged TIOCCSERIAL
      tty: actually undefine superseded ASYNC flags
      tty: fix return value for unsupported ioctls

Johannes Berg (3):
      cfg80211: scan: drop entry from hidden_list on overflow
      mac80211: bail out if cipher schemes are invalid
      um: Mark all kernel symbols as local

John Millikin (1):
      x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Jonathan McDowell (1):
      net: stmmac: Set FIFO sizes for ipq806x

Jonathon Reinhart (1):
      netfilter: conntrack: Make global sysctls readonly in non-init netns

Josef Bacik (1):
      btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Kai-Heng Feng (1):
      USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Kaixu Xia (1):
      cxgb4: Fix the -Wmisleading-indentation warning

Kees Cook (1):
      drm/radeon: Fix off-by-one power_state index heap overwrite

Krzysztof Kozlowski (2):
      ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
      ARM: dts: exynos: correct PMIC interrupt trigger level on Snow

Lin Ma (1):
      bluetooth: eliminate the potential race condition when removing the HCI controller

Lukasz Luba (1):
      thermal/core/fair share: Lock the thermal zone while looping over instances

Lv Yunlong (7):
      ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer
      ALSA: sb: Fix two use after free in snd_sb_qsound_build
      mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init
      crypto: qat - Fix a double free in adf_create_ring
      mwl8k: Fix a double Free in mwl8k_probe_hw
      net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
      net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Maciej W. Rozycki (5):
      FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR
      FDDI: defxx: Make MMIO the configuration default except for EISA
      MIPS: Reinstate platform `__div64_32' handler
      MIPS: Avoid DIVU in `__div64_32' is result would be zero
      MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Mahesh Salgaonkar (1):
      powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

Marijn Suijten (1):
      drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal

Mark Langsdorf (2):
      ACPI: custom_method: fix potential use-after-free issue
      ACPI: custom_method: fix a possible memory leak

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Maxim Mikityanskiy (1):
      HID: plantronics: Workaround for double volume key presses

Maximilian Luz (1):
      usb: xhci: Increase timeout for HC halt

Miaohe Lin (3):
      khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
      mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
      ksm: fix potential missing rmap_item for stable_node

Michael Ellerman (2):
      powerpc/pseries: Stop calling printk in rtas_stop_self()
      powerpc/64s: Fix crashes when toggling entry flush barrier

Michael Kelley (1):
      Drivers: hv: vmbus: Increase wait time for VMbus unload

Michael Walle (1):
      mtd: require write permissions for locking and badblock ioctls

Mihai Moldovan (1):
      kconfig: nconf: stop endless search loops

Miklos Szeredi (1):
      cuse: prevent clone

Mikulas Patocka (1):
      dm ioctl: fix out of bounds array access when no devices

Muhammad Usama Anjum (1):
      media: em28xx: fix memory leak

Nathan Chancellor (2):
      x86/events/amd/iommu: Fix sysfs type mismatch
      powerpc/prom: Mark identical_pvr_fixup as __init

Nikola Livic (1):
      pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Olga Kornievskaia (1):
      NFSv4.2 fix handling of sr_eof in SEEK's reply

Or Cohen (1):
      net/nfc: fix use-after-free llcp_sock_bind/connect

Pan Bian (1):
      bus: qcom: Put child node before return

Pavel Machek (1):
      intel_th: Consistency and off-by-one fix

Pavel Skripkin (1):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init

Pawel Laszczak (1):
      usb: gadget: uvc: add bInterval checking for HS mode

Paweł Chmiel (1):
      clk: exynos7: Mark aclk_fsys1_200 as critical

Peilin Ye (1):
      media: dvbdev: Fix memory leak in dvb_media_device_free()

Peter Foley (1):
      extcon: adc-jack: Fix incompatible pointer type warning

Phil Elwell (1):
      usb: dwc2: Fix gadget DMA unmap direction

Phillip Lougher (1):
      squashfs: fix divide error in calculate_skip()

Phillip Potter (2):
      net: usb: ax88179_178a: initialize local variables before use
      fbdev: zero-fill colormap in fbcmap.c

Quentin Perret (2):
      Revert "of/fdt: Make sure no-map does not remove already reserved regions"
      Revert "fdt: Properly handle "no-map" field in the memory region"

Rafael J. Wysocki (1):
      PCI: PM: Do not read power state in pci_enable_device_flags()

Randy Dunlap (1):
      powerpc: iommu: fix build when neither PCI or IBMVIO is set

Sean Young (1):
      media: ite-cir: check for receive overflow

Sergey Shtylyov (12):
      pata_arasan_cf: fix IRQ check
      pata_ipx4xx_cf: fix IRQ check
      sata_mv: add IRQ checks
      ata: libahci_platform: fix IRQ check
      scsi: jazz_esp: Add IRQ check
      scsi: sun3x_esp: Add IRQ check
      scsi: sni_53c710: Add IRQ check
      i2c: cadence: add IRQ check
      i2c: emev2: add IRQ check
      i2c: jz4780: add IRQ check
      i2c: sh7760: add IRQ check
      i2c: sh7760: fix IRQ error path

Seunghui Lee (1):
      mmc: core: Set read only for SD cards with permanent write protect bit

Sindhu Devale (1):
      RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Stefano Garzarella (1):
      vsock/vmci: log once the failed queue pair allocation

Steven Rostedt (VMware) (3):
      ftrace: Handle commands when closing set_ftrace_filter file
      tracing: Map all PIDs to command lines
      tracing: Restructure trace_clock_global() to never block

Taehee Yoo (1):
      hsr: use netdev_err() instead of WARN_ONCE()

Takashi Iwai (7):
      ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX
      ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries
      ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices
      ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Tetsuo Handa (4):
      misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct
      misc: vmw_vmci: explicitly initialize vmci_datagram payload
      ttyprintk: Add TTY hangup callback.
      Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Thinh Nguyen (1):
      usb: xhci: Fix port minor revision

Thomas Gleixner (2):
      Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
      KVM: x86: Cancel pvclock_gtod_work on module removal

Toke Høiland-Jørgensen (1):
      ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Tong Zhang (5):
      crypto: qat - don't release uninitialized resources
      crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init
      ALSA: hdsp: don't disable if not enabled
      ALSA: hdspm: don't disable if not enabled
      ALSA: rme9652: don't disable if not enabled

Tony Ambardar (1):
      powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Trond Myklebust (3):
      NFSv4: Don't discard segments marked for return in _pnfs_return_layout()
      NFSv4.2: Always flush out writes in nfs42_proc_fallocate()
      NFS: Deal correctly with attribute generation counter overflow

Tyrel Datwyler (1):
      powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Vasily Gorbik (1):
      s390/disassembler: increase ebpf disasm buffer size

Vineet Gupta (1):
      ARC: entry: fix off-by-one error in syscall number validation

Wei Yongjun (2):
      spi: dln2: Fix reference leak to master
      spi: omap-100k: Fix reference leak to master

Wesley Cheng (1):
      usb: dwc3: gadget: Ignore EP queue requests during bus reset

Xie He (1):
      net: lapbether: Prevent racing when checking whether the netif is running

Xin Long (3):
      Revert "net/sctp: fix race condition in sctp_destroy_sock"
      sctp: delay auto_asconf init until binding the first addr
      sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Yang Yang (1):
      jffs2: check the validity of dstlen in jffs2_zlib_compress()

Yang Yingliang (7):
      phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
      power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
      power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
      media: adv7604: fix possible use-after-free in adv76xx_remove()
      media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
      media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
      media: omap4iss: return error code when omap4iss_get() failed

Yaqi Chen (1):
      samples/bpf: Fix broken tracex1 due to kprobe argument change

Yonghong Song (1):
      selftests: Set CC to clang in lib.mk if LLVM is set

Zhang Yi (1):
      ext4: fix check to prevent false positive report of incorrect used inodes

Zhao Heming (1):
      md: md_open returns -EBUSY when entering racing area

Zhen Lei (1):
      ARM: 9064/1: hw_breakpoint: Do not directly check the event's overflow_handler hook

Zqiang (1):
      lib: stackdepot: turn depot_lock spinlock to raw_spinlock

dongjian (1):
      power: supply: Use IRQF_ONESHOT

karthik alapati (1):
      staging: wimax/i2400m: fix byte-order issue

lizhe (1):
      jffs2: Fix kasan slab-out-of-bounds problem

