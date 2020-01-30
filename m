Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A9B14D77E
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 09:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgA3IaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 03:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgA3IaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 03:30:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D48206D5;
        Thu, 30 Jan 2020 08:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580373011;
        bh=P2Pjag4OH868WeM/vK7+yIKL+ZU6sJMOHRKjNImkess=;
        h=Date:From:To:Cc:Subject:From;
        b=ZGxF4cDaWbMyE3zHLEW19UxY9kx3ZsqgsXWEcyL8ra9RNNamRIFKhoCy79WD6pAsq
         RXkMmNUUaq6uLbojR2KwudujrrnwpWX5a/bwwDTYP4W7WaoLqTtXi0c+2hjiv28K2h
         /ISiofrYmxZzJpTq8G1RKwtBZ8yStPFtwHpyIhzs=
Date:   Thu, 30 Jan 2020 09:30:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.212
Message-ID: <20200130083008.GA645896@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.212 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/common/mcpm_entry.c                        |    2 
 arch/arm/include/asm/suspend.h                      |    1 
 arch/arm/kernel/sleep.S                             |   12 ++
 arch/arm/mach-omap2/omap_hwmod.c                    |    2 
 arch/arm/mach-rpc/irq.c                             |    3 
 arch/arm/plat-pxa/ssp.c                             |    6 -
 arch/arm64/boot/dts/arm/juno-clocks.dtsi            |    4 
 arch/m68k/amiga/cia.c                               |    9 +
 arch/m68k/atari/ataints.c                           |    4 
 arch/m68k/atari/time.c                              |   15 ++
 arch/m68k/bvme6000/config.c                         |   20 +--
 arch/m68k/hp300/time.c                              |   10 +
 arch/m68k/mac/via.c                                 |  119 +++++++++++---------
 arch/m68k/mvme147/config.c                          |   18 +--
 arch/m68k/mvme16x/config.c                          |   21 +--
 arch/m68k/q40/q40ints.c                             |   19 +--
 arch/m68k/sun3/sun3ints.c                           |    3 
 arch/m68k/sun3x/time.c                              |   16 +-
 arch/mips/include/asm/io.h                          |   14 --
 arch/mips/kernel/setup.c                            |    2 
 arch/nios2/kernel/nios2_ksyms.c                     |   12 ++
 arch/powerpc/Makefile                               |    2 
 arch/powerpc/include/asm/archrandom.h               |    2 
 arch/powerpc/kernel/cacheinfo.c                     |   17 ++
 arch/powerpc/kernel/cacheinfo.h                     |    4 
 arch/powerpc/sysdev/qe_lib/gpio.c                   |    4 
 arch/x86/Kconfig.debug                              |    2 
 arch/x86/kernel/kgdb.c                              |    2 
 block/blk-merge.c                                   |    8 -
 crypto/pcrypt.c                                     |    2 
 crypto/tgr192.c                                     |    6 -
 drivers/ata/libahci.c                               |    1 
 drivers/atm/firestream.c                            |    3 
 drivers/bcma/driver_pci.c                           |    4 
 drivers/block/drbd/drbd_main.c                      |    2 
 drivers/clk/clk-highbank.c                          |    1 
 drivers/clk/clk-qoriq.c                             |    1 
 drivers/clk/imx/clk-imx6q.c                         |    1 
 drivers/clk/imx/clk-imx6sx.c                        |    1 
 drivers/clk/imx/clk-imx7d.c                         |    1 
 drivers/clk/imx/clk-vf610.c                         |    1 
 drivers/clk/mvebu/armada-370.c                      |    4 
 drivers/clk/mvebu/armada-xp.c                       |    4 
 drivers/clk/mvebu/kirkwood.c                        |    2 
 drivers/clk/samsung/clk-exynos4.c                   |    1 
 drivers/clk/socfpga/clk-pll-a10.c                   |    1 
 drivers/clk/socfpga/clk-pll.c                       |    1 
 drivers/clocksource/timer-sun5i.c                   |   10 +
 drivers/crypto/caam/caamrng.c                       |    5 
 drivers/dma/dma-axi-dmac.c                          |    2 
 drivers/dma/dw/platform.c                           |   14 ++
 drivers/dma/edma.c                                  |    6 -
 drivers/dma/imx-sdma.c                              |    8 +
 drivers/gpu/drm/drm_dp_mst_topology.c               |   15 ++
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c               |   24 +---
 drivers/gpu/drm/msm/dsi/dsi_host.c                  |    6 -
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c             |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c      |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c      |    4 
 drivers/gpu/drm/radeon/cik.c                        |    4 
 drivers/gpu/drm/radeon/r600.c                       |    4 
 drivers/gpu/drm/radeon/si.c                         |    4 
 drivers/gpu/drm/virtio/virtgpu_vq.c                 |    5 
 drivers/hwmon/adt7475.c                             |    5 
 drivers/hwmon/nct7802.c                             |    4 
 drivers/hwmon/shtc1.c                               |    2 
 drivers/hwmon/w83627hf.c                            |   42 ++++++-
 drivers/iio/dac/ad5380.c                            |    2 
 drivers/iio/industrialio-buffer.c                   |    6 -
 drivers/infiniband/hw/mlx5/qp.c                     |   21 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c         |    2 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c        |    2 
 drivers/infiniband/ulp/isert/ib_isert.c             |   12 --
 drivers/input/keyboard/nomadik-ske-keypad.c         |    2 
 drivers/input/misc/keyspan_remote.c                 |    9 +
 drivers/input/tablet/aiptek.c                       |    6 -
 drivers/input/tablet/gtco.c                         |   10 -
 drivers/input/touchscreen/sur40.c                   |    2 
 drivers/iommu/amd_iommu.c                           |    2 
 drivers/iommu/amd_iommu_init.c                      |    3 
 drivers/iommu/intel-iommu.c                         |    5 
 drivers/iommu/iommu.c                               |    6 -
 drivers/md/bitmap.c                                 |    8 -
 drivers/media/i2c/ov2659.c                          |    2 
 drivers/media/i2c/soc_camera/ov6650.c               |   72 ++++++++----
 drivers/media/pci/cx18/cx18-fileops.c               |    2 
 drivers/media/pci/cx23885/cx23885-dvb.c             |    5 
 drivers/media/pci/ivtv/ivtv-fileops.c               |    2 
 drivers/media/platform/davinci/isif.c               |    9 -
 drivers/media/platform/davinci/vpbe.c               |    2 
 drivers/media/platform/omap/omap_vout.c             |   15 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c         |    2 
 drivers/media/platform/vivid/vivid-osd.c            |    2 
 drivers/media/radio/wl128x/fmdrv_common.c           |    5 
 drivers/mfd/intel-lpss.c                            |    1 
 drivers/misc/mic/card/mic_x100.c                    |   28 ++--
 drivers/misc/sgi-xp/xpc_partition.c                 |    2 
 drivers/mmc/host/sdhci.c                            |   10 +
 drivers/net/can/slcan.c                             |   12 +-
 drivers/net/ethernet/broadcom/bcmsysport.c          |    2 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c     |    2 
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c       |    2 
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    2 
 drivers/net/ethernet/natsemi/sonic.c                |    6 -
 drivers/net/ethernet/pasemi/pasemi_mac.c            |    2 
 drivers/net/ethernet/qualcomm/qca_spi.c             |    9 -
 drivers/net/ethernet/qualcomm/qca_spi.h             |    1 
 drivers/net/ethernet/renesas/sh_eth.c               |    6 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c    |    2 
 drivers/net/slip/slip.c                             |   12 +-
 drivers/net/usb/lan78xx.c                           |   15 ++
 drivers/net/wireless/ath/ath9k/dynack.c             |    8 -
 drivers/net/wireless/libertas/cfg.c                 |   16 ++
 drivers/net/wireless/libertas_tf/cmd.c              |    2 
 drivers/net/wireless/mediatek/mt7601u/phy.c         |    2 
 drivers/pinctrl/sh-pfc/pfc-emev2.c                  |   20 +++
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c                |    3 
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c                |    8 -
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c                |    2 
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                 |    2 
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                 |    4 
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                 |    4 
 drivers/platform/mips/cpu_hwmon.c                   |    2 
 drivers/platform/x86/alienware-wmi.c                |    2 
 drivers/power/power_supply_core.c                   |   10 -
 drivers/regulator/wm831x-dcdc.c                     |    4 
 drivers/rtc/rtc-88pm80x.c                           |   21 ++-
 drivers/rtc/rtc-88pm860x.c                          |   21 ++-
 drivers/rtc/rtc-ds1672.c                            |    3 
 drivers/rtc/rtc-pcf8563.c                           |   11 -
 drivers/rtc/rtc-pm8xxx.c                            |    6 -
 drivers/scsi/libfc/fc_exch.c                        |    2 
 drivers/scsi/megaraid/megaraid_sas_base.c           |    4 
 drivers/scsi/qla2xxx/qla_os.c                       |   34 +++--
 drivers/scsi/scsi_transport_iscsi.c                 |    7 +
 drivers/spi/spi-bcm2835aux.c                        |   13 ++
 drivers/spi/spi-fsl-spi.c                           |    2 
 drivers/spi/spi-tegra114.c                          |   45 ++++++-
 drivers/staging/comedi/drivers/ni_mio_common.c      |   24 ++--
 drivers/target/iscsi/iscsi_target.c                 |    6 -
 drivers/thermal/cpu_cooling.c                       |    2 
 drivers/tty/ipwireless/hardware.c                   |    2 
 drivers/usb/class/cdc-wdm.c                         |    2 
 drivers/usb/host/xhci-hub.c                         |    2 
 drivers/vfio/pci/vfio_pci.c                         |   19 ++-
 drivers/video/backlight/lm3630a_bl.c                |    4 
 drivers/video/fbdev/chipsfb.c                       |    3 
 drivers/xen/cpu_hotplug.c                           |    2 
 fs/btrfs/inode-map.c                                |    1 
 fs/cifs/connect.c                                   |    3 
 fs/exportfs/expfs.c                                 |    1 
 fs/ext4/inline.c                                    |    2 
 fs/jfs/jfs_txnmgr.c                                 |    3 
 fs/namei.c                                          |   17 +-
 fs/nfs/super.c                                      |    2 
 fs/xfs/xfs_quotaops.c                               |    3 
 include/asm-generic/rtc.h                           |    2 
 include/linux/bitmap.h                              |    8 +
 include/linux/device.h                              |    3 
 include/linux/netfilter/ipset/ip_set.h              |    7 -
 include/linux/platform_data/dma-imx-sdma.h          |    3 
 include/linux/signal.h                              |   15 ++
 include/media/davinci/vpbe.h                        |    2 
 include/trace/events/xen.h                          |    6 -
 kernel/debug/kdb/kdb_main.c                         |    2 
 kernel/signal.c                                     |    5 
 lib/bitmap.c                                        |   20 +++
 lib/devres.c                                        |    3 
 lib/kfifo.c                                         |    3 
 net/6lowpan/nhc.c                                   |    2 
 net/bridge/netfilter/ebtables.c                     |    4 
 net/core/neighbour.c                                |    4 
 net/ieee802154/6lowpan/reassembly.c                 |    2 
 net/ipv4/ip_tunnel.c                                |    4 
 net/ipv6/reassembly.c                               |    2 
 net/iucv/af_iucv.c                                  |   27 +++-
 net/llc/af_llc.c                                    |   34 +++--
 net/llc/llc_conn.c                                  |   35 +----
 net/llc/llc_if.c                                    |   12 +-
 net/mac80211/rc80211_minstrel_ht.c                  |    2 
 net/mac80211/rx.c                                   |   11 +
 net/netfilter/ipset/ip_set_bitmap_gen.h             |    2 
 net/netfilter/ipset/ip_set_bitmap_ip.c              |    6 -
 net/netfilter/ipset/ip_set_bitmap_ipmac.c           |    6 -
 net/netfilter/ipset/ip_set_bitmap_port.c            |    6 -
 net/packet/af_packet.c                              |   25 +++-
 net/rds/ib_stats.c                                  |    2 
 net/sched/ematch.c                                  |    2 
 net/tipc/sysctl.c                                   |    8 +
 net/x25/af_x25.c                                    |    6 -
 scripts/recordmcount.c                              |   17 ++
 sound/aoa/codecs/onyx.c                             |    4 
 sound/pci/hda/hda_controller.h                      |    9 -
 sound/soc/codecs/cs4349.c                           |    1 
 sound/soc/codecs/es8328.c                           |    2 
 sound/soc/codecs/wm8737.c                           |    2 
 sound/soc/davinci/davinci-mcasp.c                   |   13 +-
 sound/soc/fsl/imx-sgtl5000.c                        |    3 
 sound/soc/qcom/apq8016_sbc.c                        |   21 ++-
 sound/soc/soc-pcm.c                                 |    4 
 sound/usb/mixer.c                                   |    4 
 sound/usb/quirks-table.h                            |    9 -
 204 files changed, 1059 insertions(+), 559 deletions(-)

Akinobu Mita (1):
      media: ov2659: fix unbalanced mutex_lock/unlock

Al Viro (1):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types

Alexandru Ardelean (1):
      dmaengine: axi-dmac: Don't check the number of frames for alignment

Anders Roxell (1):
      ALSA: hda: fix unused variable warning

Andre Przywara (1):
      arm64: dts: juno: Fix UART frequency

Andy Shevchenko (5):
      mfd: intel-lpss: Release IDA resources
      dmaengine: dw: platform: Switch to acpi_dma_controller_register()
      ahci: Do not export local variable ahci_em_messages
      md: Avoid namespace collision with bitmap API
      bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()

Antonio Borneo (1):
      net: stmmac: fix length of PTP clock's name string

Ard Biesheuvel (1):
      powerpc/archrandom: fix arch_get_random_seed_int()

Arnd Bergmann (4):
      jfs: fix bogus variable self-initialization
      media: davinci-isif: avoid uninitialized variable use
      devres: allow const resource arguments
      mic: avoid statically declaring a 'struct device'.

Axel Lin (1):
      regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA

Bart Van Assche (2):
      scsi: qla2xxx: Unregister chrdev if module initialization fails
      scsi: RDMA/isert: Fix a recently introduced regression related to logout

Ben Hutchings (1):
      powerpc: vdso: Make vdso32 installation conditional in vdso_install

Bo Wu (1):
      scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Brian Masney (1):
      backlight: lm3630a: Return 0 on success in update_status functions

Changbin Du (1):
      tracing: xen: Ordered comparison of function pointers

Chen-Yu Tsai (2):
      clocksource/drivers/sun5i: Fail gracefully when clock rate is unavailable
      rtc: pcf8563: Clear event flags and disable interrupts before requesting irq

Christophe Leroy (1):
      spi: spi-fsl-spi: call spi_finalize_current_message() at the end

Chuhong Yuan (1):
      dmaengine: ti: edma: fix missed failure handling

Colin Ian King (12):
      pcrypt: use format specifier in kobject_add
      rtc: ds1672: fix unintended sign extension
      rtc: 88pm860x: fix unintended sign extension
      rtc: 88pm80x: fix unintended sign extension
      rtc: pm8xxx: fix unintended sign extension
      drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON
      drm/nouveau/pmu: don't print reply values if exec is false
      media: vivid: fix incorrect assignment operation when setting video mode
      scsi: libfc: fix null pointer dereference on a null lport
      ext4: set error return correctly when ext4_htree_store_dirent fails
      bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
      iio: dac: ad5380: fix incorrect assignment to val

Cong Wang (1):
      net_sched: fix datalen for ematch

Dan Carpenter (15):
      drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()
      Input: nomadik-ske-keypad - fix a loop timeout test
      xen, cpu_hotplug: Prevent an out of bounds access
      media: ivtv: update *pos correctly in ivtv_read_pos()
      media: cx18: update *pos correctly in cx18_read_pos()
      media: wl128x: Fix an error code in fm_download_firmware()
      soc/fsl/qe: Fix an error code in qe_pin_request()
      6lowpan: Off by one handling ->nexthdr
      media: omap_vout: potential buffer overflow in vidioc_dqbuf()
      media: davinci/vpbe: array underflow in vpbe_enum_outputs()
      platform/x86: alienware-wmi: printing the wrong error code
      kdb: do a sanity check on the cpu in kdb_per_cpu()
      net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
      net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
      net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()

Dan Robertson (1):
      hwmon: (shtc1) fix shtc1 and shtw1 id mask

Eric Auger (1):
      vfio_pci: Enable memory accesses before calling pci_map_rom

Eric Biggers (3):
      crypto: tgr192 - fix unaligned memory access
      llc: fix another potential sk_buff leak in llc_ui_sendmsg()
      llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Dumazet (3):
      inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
      net: neigh: use long type to store jiffies delta
      packet: fix data-race in fanout_flow_is_huge()

Eric W. Biederman (3):
      fs/nfs: Fix nfs_parse_devname to not modify it's argument
      signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig
      signal: Allow cifs and drbd to receive their terminating signals

Eric Wong (1):
      rtc: cmos: ignore bogus century byte

Felix Fietkau (1):
      mac80211: minstrel_ht: fix per-group max throughput rate initialization

Filipe Manana (1):
      Btrfs: fix hang when loading existing inode cache off disk

Filippo Sironi (1):
      iommu/amd: Wait for completion of IOTLB flush in attach_device

Finn Thain (2):
      m68k: mac: Fix VIA timer counter accesses
      m68k: Call timer_interrupt() with interrupts disabled

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule

Gal Pressman (2):
      IB/usnic: Fix out of bounds index check in query pkey
      RDMA/ocrdma: Fix out of bounds index check in query pkey

Geert Uytterhoeven (12):
      pinctrl: sh-pfc: r8a7740: Add missing REF125CK pin to gether_gmii group
      pinctrl: sh-pfc: r8a7740: Add missing LCD0 marks to lcd0_data24_1 group
      pinctrl: sh-pfc: r8a7791: Remove bogus ctrl marks from qspi_data4_b group
      pinctrl: sh-pfc: r8a7791: Remove bogus marks from vin1_b_data18 group
      pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group
      pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field
      pinctrl: sh-pfc: sh7734: Add missing IPSR11 field
      pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
      pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value
      pinctrl: sh-pfc: emev2: Add missing pinmux functions
      pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
      pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

Gerd Rausch (1):
      net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Gilles Buloz (1):
      hwmon: (nct7802) Fix voltage limits to wrong registers

Greg Kroah-Hartman (1):
      Linux 4.4.212

Guenter Roeck (2):
      nios2: ksyms: Add missing symbol exports
      hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses

Iuliana Prodan (1):
      crypto: caam - free resources in case caam_rng registration failed

Jack Morgenstein (1):
      IB/mlx5: Add missing XRC options to QP optional params mask

James Hughes (1):
      net: usb: lan78xx: Add .ndo_features_check

Jan Kara (1):
      xfs: Sanity check flags of Q_XQUOTARM call

Janusz Krzysztofik (3):
      media: ov6650: Fix incorrect use of JPEG colorspace
      media: ov6650: Fix some format attributes not under control
      media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support

Jeffrey Hugo (2):
      drm/msm/mdp5: Fix mdp5_cfg_init error return
      drm/msm/dsi: Implement reset correctly

Jerome Brunet (1):
      ASoC: fix valid stream condition

Jie Liu (1):
      tipc: set sysctl_tipc_rmem and named_timeout right range

Johan Hovold (4):
      Input: keyspan-remote - fix control-message timeouts
      Input: sur40 - fix interface sanity checks
      Input: gtco - fix endpoint sanity check
      Input: aiptek - fix endpoint sanity check

Johannes Berg (2):
      ALSA: aoa: onyx: always initialize register read value
      mac80211: accept deauth frames in IBSS mode

Julian Wiedmann (1):
      net/af_iucv: always register net_device notifier

Kadlecsik József (1):
      netfilter: ipset: use bitmap infrastructure completely

Kangjie Lu (1):
      net: sh_eth: fix a missing check of of_get_phy_mode

Kevin Mitchell (1):
      iommu/amd: Make iommu_disable safer

Lars Möllendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest element

Linus Torvalds (1):
      Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

Lorenzo Bianconi (2):
      mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
      ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Lu Baolu (2):
      iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU
      iommu: Use right function to get group for device

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Lyude Paul (1):
      drm/dp_mst: Skip validating ports during destruction, just ref

Mao Wenan (2):
      net: sonic: return NETDEV_TX_OK if failed to map buffer
      net: sonic: replace dev_kfree_skb in sonic_send_packet

Marek Szyprowski (1):
      ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used

Martin Schiller (1):
      net/x25: fix nonblocking connect

Martin Sperl (1):
      spi: bcm2835aux: fix driver to not allow 65535 (=-1) cs-gpios

Masami Hiramatsu (1):
      x86, perf: Fix the dependency of the x86 insn decoder selftest

Matthias Kaehlcke (1):
      thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_get_power

Michael Ellerman (1):
      net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Michał Mirosław (1):
      mmc: sdhci: fix minimum clock rate for v3 controller

Ming Lei (1):
      block: don't use bio->bi_vcnt to figure out segment number

Nathan Chancellor (1):
      misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa

Nathan Lynch (1):
      powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild

Nicholas Mc Guire (1):
      media: cx23885: check allocation return

Nick Desaulniers (1):
      mips: avoid explicit UB in assignment of mips_io_port_base

Nicolas Huaman (1):
      ALSA: usb-audio: update quirk for B&W PX to remove microphone

Pawe? Chmiel (1):
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple AXRs

Richard Palethorpe (1):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Rob Clark (1):
      drm/msm/a3xx: remove TPL1 regs from snapshot

Robin Gong (1):
      dmaengine: imx-sdma: fix size check for sdma script_number

Ruslan Bilovol (1):
      usb: host: xhci-hub: fix extra endianness conversion

Russell King (1):
      ARM: riscpc: fix lack of keyboard interrupts after irq conversion

Sam Bobroff (1):
      drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Sowjanya Komatineni (2):
      spi: tegra114: clear packed bit for unpacked mode
      spi: tegra114: fix for unpacked mode transfers

Spencer E. Olson (1):
      staging: comedi: ni_mio_common: protect register write overflow

Stefan Agner (1):
      ASoC: imx-sgtl5000: put of nodes if finding codec fails

Stefan Wahren (1):
      net: qca_spi: Move reset_count to struct qcaspi

Stephen Boyd (1):
      power: supply: Init device wakeup after device_add()

Steve French (1):
      cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Steve Sistare (1):
      scsi: megaraid_sas: reduce module load time

Takashi Iwai (2):
      ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()
      ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()

Thomas Gleixner (1):
      x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI

Tiezhu Yang (1):
      MIPS: Loongson: Fix return value of loongson_hwmon_init

Tony Lindgren (1):
      ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (1):
      net: pasemi: fix an use-after-free in pasemi_mac_phy_init()

Wenwen Wang (1):
      firestream: fix memory leaks

Willem de Bruijn (1):
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll

William Dauchy (1):
      net, ip_tunnel: fix namespaces move

Yangtao Li (11):
      clk: highbank: fix refcount leak in hb_clk_init()
      clk: qoriq: fix refcount leak in clockgen_init()
      clk: socfpga: fix refcount leak
      clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
      clk: imx6q: fix refcount leak in imx6q_clocks_init()
      clk: imx6sx: fix refcount leak in imx6sx_clocks_init()
      clk: imx7d: fix refcount leak in imx7d_clocks_init()
      clk: vf610: fix refcount leak in vf610_clocks_init()
      clk: armada-370: fix refcount leak in a370_clk_init()
      clk: kirkwood: fix refcount leak in kirkwood_clk_init()
      clk: armada-xp: fix refcount leak in axp_clk_init()

YueHaibing (10):
      exportfs: fix 'passing zero to ERR_PTR()' warning
      tty: ipwireless: Fix potential NULL pointer dereference
      fbdev: chipsfb: remove set but not used variable 'size'
      cdc-wdm: pass return value of recover_from_urb_loss
      ehea: Fix a copy-paste err in ehea_init_port_res
      ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
      libertas_tf: Use correct channel range in lbtf_geo_init
      ASoC: es8328: Fix copy-paste error in es8328_right_line_controls
      ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'
      ASoC: wm8737: Fix copy-paste error in wm8737_snd_controls

