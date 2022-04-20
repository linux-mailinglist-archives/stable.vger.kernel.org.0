Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAEF5081EB
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347805AbiDTHYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242930AbiDTHYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:24:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714F225C56;
        Wed, 20 Apr 2022 00:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D247CE1C3C;
        Wed, 20 Apr 2022 07:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6377DC385A0;
        Wed, 20 Apr 2022 07:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650439302;
        bh=1y7tXGN3nVsXm5xXHQFz6qi2OOIYsrbvNZf/HQqLHMw=;
        h=From:To:Cc:Subject:Date:From;
        b=wzaGFluRVdcbcjuHrNRCEHzwqkE+A4FFpmKJFQM3S1crblqulD1Ad0vbzDupKybQ1
         mzkuKnMh3EoV9Yl8mk/o+huncA05eHJMteJWvMk76eqiXevm013dfaXaHT/wi4ZXi/
         lGro74T4xTnDKiELEOJDd3d8h0f/KKrD36wrcqZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.311
Date:   Wed, 20 Apr 2022 09:21:38 +0200
Message-Id: <1650439298178134@kroah.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.311 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi                        |    2 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                        |    3 
 arch/arm/boot/dts/exynos5420-smdk5420.dts                        |    3 
 arch/arm/boot/dts/qcom-ipq4019.dtsi                              |    3 
 arch/arm/boot/dts/qcom-msm8960.dtsi                              |    8 
 arch/arm/boot/dts/spear1340.dtsi                                 |    6 
 arch/arm/boot/dts/spear13xx.dtsi                                 |    6 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                          |    6 
 arch/arm/mach-davinci/board-da850-evm.c                          |    4 
 arch/arm/mach-mmp/sram.c                                         |   22 -
 arch/arm/mach-s3c24xx/mach-jive.c                                |    6 
 arch/arm64/boot/dts/broadcom/bcm2837.dtsi                        |   49 +++
 arch/arm64/boot/dts/broadcom/ns2-svk.dts                         |    8 
 arch/arm64/boot/dts/broadcom/ns2.dtsi                            |    2 
 arch/arm64/kernel/insn.c                                         |    4 
 arch/arm64/kernel/module.lds                                     |    2 
 arch/mips/dec/prom/Makefile                                      |    2 
 arch/mips/include/asm/dec/prom.h                                 |   15 
 arch/mips/include/asm/setup.h                                    |    2 
 arch/mips/kernel/traps.c                                         |   22 -
 arch/mips/rb532/devices.c                                        |    6 
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi                          |    4 
 arch/powerpc/sysdev/fsl_gtm.c                                    |    4 
 arch/x86/events/intel/pt.c                                       |    2 
 arch/x86/kvm/emulate.c                                           |   14 
 arch/x86/kvm/hyperv.c                                            |   15 
 arch/x86/kvm/lapic.c                                             |    5 
 arch/x86/kvm/pmu_amd.c                                           |    8 
 arch/x86/power/cpu.c                                             |   21 +
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi                      |    8 
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi                       |    8 
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi                        |    4 
 crypto/authenc.c                                                 |    2 
 drivers/acpi/acpica/nswalk.c                                     |    3 
 drivers/acpi/apei/bert.c                                         |    8 
 drivers/acpi/cppc_acpi.c                                         |    5 
 drivers/base/power/main.c                                        |    6 
 drivers/block/drbd/drbd_int.h                                    |    8 
 drivers/block/drbd/drbd_nl.c                                     |   41 +-
 drivers/block/drbd/drbd_state.c                                  |   18 -
 drivers/block/drbd/drbd_state_change.h                           |    8 
 drivers/block/loop.c                                             |   10 
 drivers/block/virtio_blk.c                                       |   12 
 drivers/char/virtio_console.c                                    |   15 
 drivers/clk/clk-clps711x.c                                       |    2 
 drivers/clk/loongson1/clk-loongson1c.c                           |    1 
 drivers/clk/qcom/clk-rcg2.c                                      |    1 
 drivers/clk/tegra/clk-emc.c                                      |    1 
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c                   |    1 
 drivers/clocksource/acpi_pm.c                                    |    6 
 drivers/crypto/ccp/ccp-dmaengine.c                               |   16 +
 drivers/crypto/mxs-dcp.c                                         |    2 
 drivers/crypto/vmx/Kconfig                                       |    4 
 drivers/dma/sh/shdma-base.c                                      |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                          |    2 
 drivers/gpu/drm/drm_edid.c                                       |    8 
 drivers/gpu/drm/imx/parallel-display.c                           |    4 
 drivers/gpu/drm/tegra/dsi.c                                      |    4 
 drivers/gpu/ipu-v3/ipu-di.c                                      |    5 
 drivers/hid/i2c-hid/i2c-hid-core.c                               |   32 +-
 drivers/hwmon/pmbus/pmbus.h                                      |    1 
 drivers/hwmon/pmbus/pmbus_core.c                                 |   18 -
 drivers/hwmon/sch56xx-common.c                                   |    2 
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c              |    8 
 drivers/i2c/busses/i2c-pasemi.c                                  |    6 
 drivers/i2c/busses/i2c-xiic.c                                    |    3 
 drivers/i2c/muxes/i2c-demux-pinctrl.c                            |    5 
 drivers/iio/adc/twl6030-gpadc.c                                  |    2 
 drivers/iio/inkern.c                                             |   34 +-
 drivers/input/input.c                                            |    6 
 drivers/iommu/arm-smmu-v3.c                                      |    1 
 drivers/irqchip/irq-nvic.c                                       |    2 
 drivers/md/dm-ioctl.c                                            |    2 
 drivers/media/pci/cx88/cx88-mpeg.c                               |    3 
 drivers/media/platform/davinci/vpif.c                            |    1 
 drivers/media/usb/go7007/s2250-board.c                           |   10 
 drivers/media/usb/hdpvr/hdpvr-video.c                            |    4 
 drivers/memory/emif.c                                            |    8 
 drivers/mfd/asic3.c                                              |   10 
 drivers/mfd/mc13xxx-core.c                                       |    4 
 drivers/misc/kgdbts.c                                            |    4 
 drivers/mmc/core/host.c                                          |   15 
 drivers/mtd/onenand/generic.c                                    |    7 
 drivers/mtd/ubi/fastmap.c                                        |   28 +
 drivers/net/can/usb/ems_usb.c                                    |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    4 
 drivers/net/ethernet/micrel/Kconfig                              |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                  |   10 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c               |    8 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h               |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c              |   13 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c            |    3 
 drivers/net/ethernet/sun/sunhme.c                                |    6 
 drivers/net/hamradio/6pack.c                                     |    4 
 drivers/net/phy/broadcom.c                                       |   21 +
 drivers/net/slip/slip.c                                          |    2 
 drivers/net/veth.c                                               |    2 
 drivers/net/wireless/ath/ath5k/eeprom.c                          |    3 
 drivers/net/wireless/ath/ath9k/htc_hst.c                         |    5 
 drivers/net/wireless/ath/carl9170/main.c                         |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c          |   48 ---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c                |    2 
 drivers/net/wireless/ray_cs.c                                    |    6 
 drivers/pci/hotplug/pciehp_hpc.c                                 |    2 
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c                    |    2 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                        |    4 
 drivers/pinctrl/pinconf-generic.c                                |    6 
 drivers/pinctrl/pinctrl-rockchip.c                               |    2 
 drivers/power/supply/ab8500_fg.c                                 |    4 
 drivers/power/supply/wm8350_power.c                              |   97 +++++-
 drivers/ptp/ptp_sysfs.c                                          |    4 
 drivers/pwm/pwm-lpc18xx-sct.c                                    |   20 -
 drivers/remoteproc/qcom_wcnss.c                                  |    1 
 drivers/rtc/rtc-wm8350.c                                         |   11 
 drivers/scsi/aha152x.c                                           |    6 
 drivers/scsi/bfa/bfad_attr.c                                     |   26 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c                         |    2 
 drivers/scsi/libfc/fc_exch.c                                     |    1 
 drivers/scsi/libsas/sas_ata.c                                    |    2 
 drivers/scsi/mvsas/mv_init.c                                     |    5 
 drivers/scsi/pm8001/pm8001_hwi.c                                 |   13 
 drivers/scsi/pm8001/pm80xx_hwi.c                                 |   11 
 drivers/scsi/qla2xxx/qla_isr.c                                   |    1 
 drivers/scsi/zorro7xx.c                                          |    2 
 drivers/soc/ti/wkup_m3_ipc.c                                     |    4 
 drivers/spi/spi-tegra114.c                                       |    4 
 drivers/spi/spi-tegra20-slink.c                                  |    8 
 drivers/thermal/int340x_thermal/int3400_thermal.c                |    2 
 drivers/tty/hvc/hvc_iucv.c                                       |    4 
 drivers/tty/mxser.c                                              |   15 
 drivers/tty/serial/kgdboc.c                                      |    6 
 drivers/tty/serial/samsung.c                                     |    5 
 drivers/usb/dwc3/dwc3-omap.c                                     |    2 
 drivers/usb/serial/Kconfig                                       |    1 
 drivers/usb/serial/pl2303.c                                      |    1 
 drivers/usb/serial/pl2303.h                                      |    3 
 drivers/usb/serial/usb-serial-simple.c                           |    7 
 drivers/usb/storage/ene_ub6250.c                                 |  155 ++++------
 drivers/usb/storage/realtek_cr.c                                 |    2 
 drivers/video/fbdev/atafb.c                                      |   12 
 drivers/video/fbdev/cirrusfb.c                                   |   16 -
 drivers/video/fbdev/core/fbcvt.c                                 |   53 +--
 drivers/video/fbdev/nvidia/nv_i2c.c                              |    2 
 drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c        |    1 
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c         |    8 
 drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c |    2 
 drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c |    4 
 drivers/video/fbdev/sm712fb.c                                    |   46 --
 drivers/video/fbdev/smscufx.c                                    |    3 
 drivers/video/fbdev/w100fb.c                                     |   15 
 drivers/w1/slaves/w1_therm.c                                     |    8 
 fs/cifs/link.c                                                   |    3 
 fs/ext2/super.c                                                  |    6 
 fs/ext4/inode.c                                                  |   25 +
 fs/gfs2/rgrp.c                                                   |    3 
 fs/jffs2/build.c                                                 |    4 
 fs/jffs2/fs.c                                                    |    2 
 fs/jffs2/scan.c                                                  |    6 
 fs/jfs/inode.c                                                   |    3 
 fs/jfs/jfs_dmap.c                                                |    7 
 fs/nfs/callback_xdr.c                                            |    4 
 fs/nfsd/nfsproc.c                                                |    2 
 fs/nfsd/xdr.h                                                    |    2 
 fs/ntfs/inode.c                                                  |    4 
 fs/ubifs/dir.c                                                   |    2 
 fs/ubifs/ioctl.c                                                 |    2 
 include/linux/blkdev.h                                           |    8 
 include/linux/netdevice.h                                        |    6 
 include/net/xfrm.h                                               |    9 
 init/main.c                                                      |    6 
 kernel/events/core.c                                             |    3 
 kernel/power/hibernate.c                                         |    2 
 kernel/power/suspend_test.c                                      |    8 
 kernel/printk/printk.c                                           |    6 
 kernel/ptrace.c                                                  |   47 ++-
 kernel/sched/debug.c                                             |   10 
 kernel/smp.c                                                     |    2 
 lib/raid6/test/test.c                                            |    1 
 mm/kmemleak.c                                                    |    8 
 mm/memcontrol.c                                                  |    2 
 mm/memory.c                                                      |   24 +
 mm/mempolicy.c                                                   |    9 
 mm/mmap.c                                                        |    2 
 mm/mremap.c                                                      |    3 
 mm/page_alloc.c                                                  |   11 
 mm/rmap.c                                                        |   35 +-
 net/bluetooth/hci_event.c                                        |    3 
 net/key/af_key.c                                                 |    6 
 net/netfilter/nf_conntrack_proto_tcp.c                           |   17 -
 net/netlink/af_netlink.c                                         |    2 
 net/nfc/nci/core.c                                               |    4 
 net/openvswitch/flow_netlink.c                                   |    4 
 net/sunrpc/sched.c                                               |    4 
 net/sunrpc/xprt.c                                                |    7 
 net/sunrpc/xprtrdma/transport.c                                  |    4 
 net/x25/af_x25.c                                                 |   11 
 net/xfrm/xfrm_policy.c                                           |   24 -
 net/xfrm/xfrm_user.c                                             |   14 
 scripts/gcc-plugins/latent_entropy_plugin.c                      |   44 +-
 security/selinux/xfrm.c                                          |    2 
 security/smack/smack_lsm.c                                       |    2 
 security/tomoyo/load_policy.c                                    |    4 
 sound/core/pcm_misc.c                                            |    2 
 sound/firewire/fcp.c                                             |    4 
 sound/isa/cs423x/cs4236.c                                        |    8 
 sound/soc/atmel/atmel_ssc_dai.c                                  |    5 
 sound/soc/atmel/sam9g20_wm8731.c                                 |    1 
 sound/soc/codecs/wm8350.c                                        |   28 +
 sound/soc/davinci/davinci-i2s.c                                  |    5 
 sound/soc/fsl/imx-es8328.c                                       |    1 
 sound/soc/mxs/mxs-saif.c                                         |    5 
 sound/soc/mxs/mxs-sgtl5000.c                                     |    3 
 sound/soc/sh/fsi.c                                               |   19 +
 sound/soc/soc-core.c                                             |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                            |    6 
 sound/soc/soc-topology.c                                         |    3 
 sound/spi/at73c213.c                                             |   27 +
 tools/build/feature/Makefile                                     |    2 
 tools/testing/selftests/x86/check_cc.sh                          |    2 
 virt/kvm/kvm_main.c                                              |   13 
 222 files changed, 1284 insertions(+), 728 deletions(-)

Adrian Hunter (2):
      perf/core: Fix address filter parser for multiple filters
      perf/x86/intel/pt: Fix address filter config for 32-bit kernel

Alan Stern (1):
      USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c

Alexander Lobakin (1):
      MIPS: fix fortify panic when copying asm exception handlers

Alexey Galakhov (1):
      scsi: mvsas: Add PCI ID of RocketRaid 2640

Alexey Khoroshilov (1):
      NFS: remove unneeded check in decode_devicenotify_args()

Alistair Popple (1):
      mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

Amadeusz Sławiński (1):
      ASoC: topology: Allow TLV control to be either read or write

Andrew Price (1):
      gfs2: Make sure FITRIM minlen is rounded up to fs block size

Armin Wolf (1):
      hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING

Arnaldo Carvalho de Melo (1):
      tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Baokun Li (3):
      jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
      jffs2: fix memory leak in jffs2_do_mount_fs
      jffs2: fix memory leak in jffs2_scan_medium

Bharata B Rao (1):
      sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa

Brandon Wyman (1):
      hwmon: (pmbus) Add Vin unit off handling

Casey Schaufler (1):
      Fix incorrect type in assignment of ipv6 port for audit

Chaitanya Kulkarni (1):
      loop: use sysfs_emit() in the sysfs xxx show()

Chen-Yu Tsai (2):
      pinctrl: pinconf-generic: Print arguments for bias-pull-*
      net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

Christian Göttsche (1):
      selinux: use correct type for context length

Christophe JAILLET (1):
      scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

Codrin Ciubotariu (1):
      ASoC: dmaengine: do not use a NULL prepare_slave_config() callback

Colin Ian King (2):
      carl9170: fix missing bit-wise or operator for tx_params
      iwlwifi: Fix -EIO error code that is never returned

Damien Le Moal (6):
      scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
      scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
      scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
      scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
      scsi: pm8001: Fix abort all task initialization
      scsi: pm8001: Fix pm8001_mpi_task_abort_resp()

Dan Carpenter (4):
      NFSD: prevent underflow in nfssvc_decode_writeargs()
      video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()
      media: usb: go7007: s2250-board: fix leak in probe()
      USB: storage: ums-realtek: fix error code in rts51x_read_mem()

Daniel González Cabanelas (1):
      media: cx88-mpeg: clear interrupt status register before streaming video

Darren Hart (1):
      ACPI/APEI: Limit printable size of BERT table data

David Heidelberg (1):
      ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960

David Matlack (1):
      KVM: Prevent module exit until all VMs are freed

Dinh Nguyen (1):
      net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Dirk Müller (1):
      lib/raid6/test: fix multiple definition linking error

Dmitry Baryshkov (1):
      PM: core: keep irq flags in device_pm_check_callbacks()

Dmitry Torokhov (1):
      HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports

Dongliang Mu (2):
      ntfs: add sanity check on allocation size
      media: hdpvr: initialize dev->worker at hdpvr_register_videodev

Duoming Zhou (3):
      drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
      net/x25: Fix null-ptr-deref caused by x25_disconnect
      drivers: net: slip: fix NPD bug in sl_tx_timeout()

Dāvis Mosāns (1):
      crypto: ccp - ccp_dmaengine_unregister release dma channels

Eddie James (1):
      USB: serial: pl2303: add IBM device IDs

Evgeny Novikov (1):
      video: fbdev: w100fb: Reset global state

Fabio M. De Francesco (1):
      ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Fangrui Song (1):
      arm64: module: remove (NOLOAD) from linker script

Florian Fainelli (1):
      net: phy: broadcom: Fix brcm_fet_config_init()

Frank Wunderlich (1):
      arm64: dts: broadcom: Fix sata nodename

George Kennedy (1):
      video: fbdev: cirrusfb: check pixclock to avoid divide by zero

Greg Kroah-Hartman (1):
      Linux 4.9.311

Guillaume Nault (1):
      veth: Ensure eth header is in skb's linear part

Guo Ren (1):
      arm64: patch_text: Fixup last cpu should be master

H. Nikolaus Schaller (1):
      usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Haimin Zhang (2):
      af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
      jfs: prevent NULL deref in diFree

Hangyu Hua (1):
      can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path

Harshit Mogalapalli (1):
      cifs: potential buffer overflow in handling symlinks

Hector Martin (2):
      brcmfmac: firmware: Allocate space for default boardrev in nvram
      brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio

Helge Deller (1):
      video: fbdev: sm712fb: Fix crash in smtcfb_read()

Herbert Xu (1):
      crypto: authenc - Fix sleep in atomic context in decrypt_tail

Hou Wenlong (1):
      KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()

Hugh Dickins (1):
      mempolicy: mbind_range() set_policy() after vma_merge()

Jakob Koschel (1):
      powerpc/sysdev: fix incorrect use to determine if list is empty

James Clark (1):
      coresight: Fix TRCCONFIGR.QE sysfs interface

Jann Horn (1):
      ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE

Jason A. Donenfeld (1):
      gcc-plugins: latent_entropy: use /dev/urandom

Jia-Ju Bai (1):
      memory: emif: check the pointer temp in get_device_details()

Jianglei Nie (1):
      scsi: libfc: Fix use after free in fc_exch_abts_resp()

Jiasheng Jiang (14):
      ASoC: ti: davinci-i2s: Add check for clk_enable()
      ALSA: spi: Add check for clk_enable()
      ASoC: mxs-saif: Handle errors for clk_enable
      ASoC: atmel_ssc_dai: Handle errors for clk_enable
      memory: emif: Add check for setup_interrupts
      ASoC: wm8350: Handle error for wm8350_register_irq
      ASoC: fsi: Add check for clk_enable
      mtd: onenand: Check for error irq
      ray_cs: Check ioremap return value
      power: supply: wm8350-power: Handle error for wm8350_register_irq
      power: supply: wm8350-power: Add missing free in free_charger_irq
      mfd: mc13xxx: Add check for mc13xxx_irq_request
      iio: adc: Add check for devm_request_threaded_irq
      rtc: wm8350: Handle error for wm8350_register_irq

Jim Mattson (1):
      KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Jing Yao (2):
      video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()
      video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()

Jiri Slaby (2):
      mxser: fix xmit_buf leak in activate when LSR == 0xff
      serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

Johan Hovold (2):
      USB: serial: simple: add Nokia phone driver
      media: davinci: vpif: fix unbalanced runtime PM get

Jonathan Neuschäfer (2):
      clk: loongson1: Terminate clk_div_table with sentinel element
      clk: clps711x: Terminate clk_div_table with sentinel element

Jordy Zomer (1):
      dm ioctl: prevent potential spectre v1 gadget

José Expósito (2):
      Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
      drm/imx: Fix memory leak in imx_pd_connector_get_modes

Juergen Gross (1):
      mm, page_alloc: fix build_zonerefs_node()

Krzysztof Kozlowski (3):
      ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5420

Kuldeep Singh (3):
      arm64: dts: ns2: Fix spi-cpol and spi-cpha property
      ARM: dts: spear1340: Update serial node properties
      ARM: dts: spear13xx: Update SPI dma properties

Kunihiko Hayashi (1):
      clk: uniphier: Fix fixed-rate initialization

Leo Ruan (1):
      gpu: ipu-v3: Fix dev_dbg frequency output

Liam Beguin (2):
      iio: inkern: apply consumer scale on IIO_VAL_INT cases
      iio: inkern: make a best effort on offset calculation

Liguang Zhang (1):
      PCI: pciehp: Clear cmd_busy bit in polling mode

Lin Ma (1):
      nfc: nci: add flush_workqueue to prevent uaf

Lucas Denefle (1):
      w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Luiz Augusto von Dentz (1):
      Bluetooth: Fix use after free in hci_send_acl

Lv Yunlong (1):
      drbd: Fix five use after free bugs in get_initial_state

Maciej W. Rozycki (1):
      DEC: Limit PMAX memory probing to R3k systems

Martin Povišer (1):
      i2c: pasemi: Wait for write xfers to finish

Martin Varghese (1):
      openvswitch: Fixed nd target mask field in the flow dump.

Mauricio Faria de Oliveira (1):
      mm: fix race between MADV_FREE reclaim and blkdev direct IO read

Max Filippov (1):
      xtensa: fix DTC warning unit_address_format

Maxim Kiselev (1):
      powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Maxime Ripard (1):
      drm/edid: Don't clear formats if using deep color

Miaohe Lin (1):
      mm/mempolicy: fix mpol_new leak in shared_policy_replace

Miaoqian Lin (13):
      spi: tegra114: Add missing IRQ check in tegra_spi_probe
      soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe
      ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe
      video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
      ASoC: mxs: Fix error handling in mxs_sgtl5000_probe
      power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init
      drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
      mfd: asic3: Add missing iounmap() on error asic3_mfd_probe
      remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region
      clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver
      pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init
      pinctrl: nomadik: Add missing of_node_put() in nmk_pinctrl_probe
      pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe

Michael Chan (1):
      bnxt_en: Eliminate unintended link toggle during FW reset

Michael S. Tsirkin (1):
      virtio_console: break out of buf poll on remove

Michael Schmitz (1):
      video: fbdev: atari: Atari 2 bpp (STe) palette bugfix

Minghao Chi (1):
      spi: tegra20: Use of_device_get_match_data()

Muhammad Usama Anjum (1):
      selftests/x86: Add validity check and allow field splitting

Nadav Amit (1):
      smp: Fix offline cpu check in flush_smp_call_function_queue()

Nathan Chancellor (1):
      ARM: davinci: da850-evm: Avoid NULL pointer dereference

NeilBrown (2):
      SUNRPC: avoid race between mod_timer() and del_timer_sync()
      SUNRPC/call_alloc: async tasks mustn't block waiting for memory

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Paolo Bonzini (1):
      mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Patrick Rudolph (1):
      hwmon: (pmbus) Add mutex to regulator ops

Patrick Wang (1):
      mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Pavel Kubelun (1):
      ARM: dts: qcom: ipq4019: fix sleep clock

Pavel Skripkin (2):
      ath9k_htc: fix uninit value bugs
      jfs: fix divide error in dbNextAG

Pawan Gupta (2):
      x86/pm: Save the MSR validity status at context setup
      x86/speculation: Restore speculation related MSRs during S3 resume

Peter Rosin (1):
      i2c: mux: demux-pinctrl: do not deactivate a master that is not active

Peter Xu (1):
      mm: don't skip swap entry even if zap_details specified

Petr Machata (1):
      af_netlink: Fix shift out of bounds in group mask calculation

Petr Vorel (1):
      crypto: vmx - add missing dependencies

QintaoShen (1):
      drm/amdkfd: Check for potential null return of kmalloc_array()

Quinn Tran (1):
      scsi: qla2xxx: Fix incorrect reporting of task management failure

Rafael J. Wysocki (2):
      ACPICA: Avoid walking the ACPI Namespace if it is not there
      ACPI: CPPC: Avoid out of bounds access when parsing _CPC data

Randy Dunlap (16):
      PM: hibernate: fix __setup handler error handling
      PM: suspend: fix return value of __setup handler
      clocksource: acpi_pm: fix return value of __setup handler
      printk: fix return value of printk.devkmsg __setup handler
      TOMOYO: fix __setup handlers return values
      MIPS: RB532: fix return value of __setup handler
      tty: hvc: fix return value of __setup handler
      kgdboc: fix return value of __setup handler
      kgdbts: fix return value of __setup handler
      mm/mmap: return 1 from stack_guard_gap __setup() handler
      mm/memcontrol: return 1 from cgroup.memory __setup() handler
      ARM: 9187/1: JIVE: fix return value of __setup handler
      scsi: aha152x: Fix aha152x_setup() __setup handler return value
      init/main.c: return 1 from handled __setup() functions
      virtio_console: eliminate anonymous module_init & module_exit
      net: micrel: fix KS8851_MLL Kconfig

Richard Leitner (1):
      ARM: tegra: tamonten: Fix I2C3 pad setting

Richard Schleich (1):
      ARM: dts: bcm2837: Add the missing L1/L2 cache information

Robert Hancock (1):
      i2c: xiic: Make bus names unique

Shengjiu Wang (1):
      ASoC: soc-core: skip zero num_dai component in searching dai name

Souptick Joarder (HPE) (1):
      irqchip/nvic: Release nvic_base upon failure

Srinivas Pandruvada (1):
      thermal: int340x: Increase bitmap size

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction

Taniya Das (1):
      clk: qcom: clk-rcg2: Update the frac table for pixel clock

Theodore Ts'o (1):
      ext4: don't BUG if someone dirty pages without asking ext4 first

Tim Gardner (1):
      video: fbdev: nvidiafb: Use strscpy() to prevent buffer overflow

Tom Rix (1):
      qlcnic: dcb: default to returning -EOPNOTSUPP

Tomas Paukrt (1):
      crypto: mxs-dcp - Fix scatterlist processing

Tyrel Datwyler (1):
      scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

Ulf Hansson (1):
      mmc: host: Return an error when ->enable_sdio_irq() ops is missing

Uwe Kleine-König (2):
      pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()
      ARM: mmp: Fix failure to remove sram device

Vinod Koul (1):
      dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Vitaly Kuznetsov (1):
      KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Wang Hai (1):
      video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()

Wang Wensheng (1):
      ASoC: imx-es8328: Fix error return code in imx_es8328_probe()

Xiaomeng Tong (1):
      ALSA: cs4236: fix an incorrect NULL check on list iterator

Xie Yongji (2):
      block: Add a helper to validate the block size
      virtio-blk: Use blk_validate_block_size() to validate block size

Xin Long (1):
      xfrm: policy: match with both mark and mask on user interfaces

Yajun Deng (1):
      netdevice: add the case if dev is NULL

Yang Guang (4):
      video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit
      ptp: replace snprintf with sysfs_emit
      scsi: mvsas: Replace snprintf() with sysfs_emit()
      scsi: bfa: Replace snprintf() with sysfs_emit()

Zekun Shen (1):
      ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Zhang Yi (1):
      ext2: correct max file size computing

Zhenzhong Duan (1):
      KVM: x86: Fix emulation in writing cr8

Zheyu Ma (2):
      ethernet: sun: Free the coherent when failing in probing
      video: fbdev: sm712fb: Fix crash in smtcfb_write()

Zhihao Cheng (3):
      ubifs: Add missing iput if do_tmpfile() failed in rename whiteout
      ubifs: setflags: Make dirtied_ino_d 8 bytes aligned
      ubi: fastmap: Return error code if memory allocation fails in add_aeb()

Zhou Guanghui (1):
      iommu/arm-smmu-v3: fix event handling soft lockup

