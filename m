Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A20CCFF9
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 11:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfJFJVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 05:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfJFJVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 05:21:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C73E2133F;
        Sun,  6 Oct 2019 09:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570353705;
        bh=E9wyNRjuzK3AVOSHcUFQAYDqOGHaR5h389vHA3Qd/k4=;
        h=Date:From:To:Cc:Subject:From;
        b=1iMlXpGsieE2ivjWtiOJ3UlX8iAOO74f3joVpuSP4X1EflW3lRyc59mydUmD0A0i0
         lJa3TG9aw0nUJrmXGqwiSDljqv892VlIwxLt36pp3qnGri8LEjXa1PQ3cG70gP80vG
         vY2zNb4b5bjh4zK2K8ubkUlY18im0B3V1QXg2J9Y=
Date:   Sun, 6 Oct 2019 11:21:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.77
Message-ID: <20191006092143.GA2765453@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.77 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/exynos5420-peach-pit.dts        |    1=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts         |    1=20
 arch/arm/boot/dts/imx7-colibri.dtsi               |    1=20
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts           |    4=20
 arch/arm/mach-zynq/platsmp.c                      |    2=20
 arch/arm/plat-samsung/watchdog-reset.c            |    1=20
 arch/arm64/boot/dts/rockchip/rk3328.dtsi          |    3=20
 arch/arm64/include/asm/cputype.h                  |   21 -
 arch/arm64/include/asm/pgtable.h                  |    6=20
 arch/arm64/include/asm/tlbflush.h                 |    1=20
 arch/arm64/kernel/cpufeature.c                    |    2=20
 arch/arm64/mm/proc.S                              |    9=20
 arch/ia64/kernel/module.c                         |    8=20
 arch/m68k/include/asm/atarihw.h                   |    9=20
 arch/m68k/include/asm/io_mm.h                     |    6=20
 arch/m68k/include/asm/macintosh.h                 |    1=20
 arch/powerpc/platforms/powernv/opal-imc.c         |   12=20
 arch/s390/crypto/aes_s390.c                       |    6=20
 arch/x86/include/asm/intel-family.h               |    3=20
 arch/x86/kernel/apic/apic.c                       |  115 ++++---
 arch/x86/kernel/apic/vector.c                     |   11=20
 arch/x86/kernel/smp.c                             |   46 +--
 arch/x86/kvm/emulate.c                            |    2=20
 arch/x86/kvm/x86.c                                |   21 +
 arch/x86/mm/pti.c                                 |    8=20
 block/blk-flush.c                                 |   10=20
 block/blk-mq.c                                    |    5=20
 block/blk.h                                       |    7=20
 drivers/acpi/acpi_processor.c                     |   10=20
 drivers/acpi/cppc_acpi.c                          |    6=20
 drivers/acpi/custom_method.c                      |    5=20
 drivers/acpi/pci_irq.c                            |    4=20
 drivers/ata/ahci.c                                |  116 ++++---
 drivers/ata/ahci.h                                |    2=20
 drivers/base/soc.c                                |    2=20
 drivers/block/loop.c                              |    1=20
 drivers/block/nbd.c                               |    4=20
 drivers/char/hw_random/core.c                     |    2=20
 drivers/char/mem.c                                |   21 +
 drivers/devfreq/exynos-bus.c                      |   31 +-
 drivers/devfreq/governor_passive.c                |    7=20
 drivers/dma/bcm2835-dma.c                         |    4=20
 drivers/dma/iop-adma.c                            |   18 -
 drivers/dma/ti/edma.c                             |    9=20
 drivers/edac/altera_edac.c                        |    4=20
 drivers/edac/amd64_edac.c                         |   28 +
 drivers/edac/edac_mc.c                            |    8=20
 drivers/edac/pnd2_edac.c                          |    7=20
 drivers/firmware/arm_scmi/driver.c                |    8=20
 drivers/firmware/efi/cper.c                       |   15=20
 drivers/firmware/qcom_scm.c                       |    7=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |    5=20
 drivers/hwmon/acpi_power_meter.c                  |    4=20
 drivers/i2c/busses/i2c-riic.c                     |    1=20
 drivers/infiniband/hw/hfi1/mad.c                  |   45 +-
 drivers/infiniband/hw/mlx5/main.c                 |    1=20
 drivers/iommu/Makefile                            |    2=20
 drivers/iommu/amd_iommu.c                         |    4=20
 drivers/iommu/amd_iommu.h                         |   14=20
 drivers/iommu/amd_iommu_init.c                    |    5=20
 drivers/iommu/amd_iommu_quirks.c                  |   92 ++++++
 drivers/iommu/iova.c                              |    4=20
 drivers/isdn/mISDN/socket.c                       |    2=20
 drivers/leds/led-triggers.c                       |    1=20
 drivers/leds/leds-lp5562.c                        |    6=20
 drivers/md/bcache/closure.c                       |   10=20
 drivers/md/dm-rq.c                                |    1=20
 drivers/md/md.c                                   |   28 +
 drivers/md/md.h                                   |    3=20
 drivers/md/raid0.c                                |   33 ++
 drivers/md/raid0.h                                |   14=20
 drivers/md/raid1.c                                |   39 +-
 drivers/md/raid5.c                                |   10=20
 drivers/media/cec/cec-notifier.c                  |    2=20
 drivers/media/dvb-core/dvb_frontend.c             |    4=20
 drivers/media/dvb-core/dvbdev.c                   |    4=20
 drivers/media/dvb-frontends/dvb-pll.c             |   40 +-
 drivers/media/i2c/ov5640.c                        |    5=20
 drivers/media/i2c/ov5645.c                        |   26 +
 drivers/media/i2c/ov9650.c                        |    5=20
 drivers/media/pci/saa7134/saa7134-i2c.c           |   12=20
 drivers/media/pci/saa7146/hexium_gemini.c         |    3=20
 drivers/media/platform/exynos4-is/fimc-is.c       |    1=20
 drivers/media/platform/exynos4-is/media-dev.c     |    2=20
 drivers/media/platform/fsl-viu.c                  |    2=20
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c     |    4=20
 drivers/media/platform/omap3isp/isp.c             |    8=20
 drivers/media/platform/omap3isp/ispccdc.c         |    1=20
 drivers/media/platform/omap3isp/ispccp2.c         |    1=20
 drivers/media/platform/omap3isp/ispcsi2.c         |    1=20
 drivers/media/platform/omap3isp/isppreview.c      |    1=20
 drivers/media/platform/omap3isp/ispresizer.c      |    1=20
 drivers/media/platform/omap3isp/ispstat.c         |    2=20
 drivers/media/platform/rcar_fdp1.c                |    2=20
 drivers/media/platform/vsp1/vsp1_dl.c             |    4=20
 drivers/media/radio/si470x/radio-si470x-usb.c     |    5=20
 drivers/media/rc/iguanair.c                       |   15=20
 drivers/media/rc/imon.c                           |    7=20
 drivers/media/rc/mceusb.c                         |  334 ++++++++++++-----=
-----
 drivers/media/rc/mtk-cir.c                        |    8=20
 drivers/media/usb/cpia2/cpia2_usb.c               |    4=20
 drivers/media/usb/dvb-usb/dib0700_devices.c       |    8=20
 drivers/media/usb/dvb-usb/pctv452e.c              |    8=20
 drivers/media/usb/em28xx/em28xx-cards.c           |    1=20
 drivers/media/usb/gspca/konica.c                  |    5=20
 drivers/media/usb/gspca/nw80x.c                   |    5=20
 drivers/media/usb/gspca/ov519.c                   |   10=20
 drivers/media/usb/gspca/ov534.c                   |    5=20
 drivers/media/usb/gspca/ov534_9.c                 |    1=20
 drivers/media/usb/gspca/se401.c                   |    5=20
 drivers/media/usb/gspca/sn9c20x.c                 |   12=20
 drivers/media/usb/gspca/sonixb.c                  |    5=20
 drivers/media/usb/gspca/sonixj.c                  |    5=20
 drivers/media/usb/gspca/spca1528.c                |    5=20
 drivers/media/usb/gspca/sq930x.c                  |    5=20
 drivers/media/usb/gspca/sunplus.c                 |    5=20
 drivers/media/usb/gspca/vc032x.c                  |    5=20
 drivers/media/usb/gspca/w996Xcf.c                 |    5=20
 drivers/media/usb/hdpvr/hdpvr-core.c              |   13=20
 drivers/media/usb/ttusb-dec/ttusb_dec.c           |    2=20
 drivers/mmc/core/sdio_irq.c                       |    9=20
 drivers/mmc/host/dw_mmc.c                         |    4=20
 drivers/mmc/host/sdhci.c                          |    4=20
 drivers/net/arcnet/arcnet.c                       |   31 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c       |   10=20
 drivers/net/ethernet/intel/e1000e/ich8lan.h       |    2=20
 drivers/net/ethernet/intel/i40e/i40e_main.c       |    5=20
 drivers/net/ethernet/marvell/skge.c               |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |    1=20
 drivers/net/ethernet/netronome/nfp/flower/main.c  |    6=20
 drivers/net/ethernet/nxp/lpc_eth.c                |   13=20
 drivers/net/macsec.c                              |    1=20
 drivers/net/phy/national.c                        |    9=20
 drivers/net/ppp/ppp_generic.c                     |    2=20
 drivers/net/usb/cdc_ncm.c                         |    6=20
 drivers/net/usb/usbnet.c                          |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |    8=20
 drivers/net/wireless/marvell/libertas/if_usb.c    |    3=20
 drivers/nvme/host/multipath.c                     |    8=20
 drivers/nvme/target/admin-cmd.c                   |   14=20
 drivers/parisc/dino.c                             |   24 +
 drivers/platform/x86/intel_pmc_core.c             |    8=20
 drivers/regulator/core.c                          |   42 ++
 drivers/regulator/lm363x-regulator.c              |    2=20
 drivers/scsi/device_handler/scsi_dh_rdac.c        |    2=20
 drivers/scsi/qla2xxx/qla_init.c                   |   25 +
 drivers/scsi/qla2xxx/qla_os.c                     |    1=20
 drivers/scsi/qla2xxx/qla_target.c                 |    1=20
 drivers/scsi/scsi_lib.c                           |   13=20
 drivers/staging/media/imx/imx6-mipi-csi2.c        |   12=20
 drivers/video/fbdev/efifb.c                       |   27 -
 fs/binfmt_elf.c                                   |    3=20
 fs/btrfs/ctree.c                                  |    5=20
 fs/btrfs/ctree.h                                  |    1=20
 fs/btrfs/extent-tree.c                            |    8=20
 fs/btrfs/free-space-cache.c                       |   18 -
 fs/btrfs/inode.c                                  |    8=20
 fs/btrfs/qgroup.c                                 |   38 +-
 fs/ceph/inode.c                                   |    3=20
 fs/ceph/super.c                                   |    1=20
 fs/ceph/super.h                                   |    1=20
 fs/cifs/cifsfs.c                                  |    2=20
 fs/cifs/cifsglob.h                                |    2=20
 fs/cifs/connect.c                                 |    9=20
 fs/cifs/smb2ops.c                                 |    5=20
 fs/cifs/smb2pdu.c                                 |    2=20
 fs/cifs/xattr.c                                   |    2=20
 fs/ext4/extents.c                                 |    4=20
 fs/ext4/inode.c                                   |    9=20
 fs/fuse/dev.c                                     |   91 +++--
 fs/fuse/file.c                                    |    1=20
 fs/fuse/fuse_i.h                                  |    3=20
 fs/fuse/inode.c                                   |    1=20
 fs/gfs2/bmap.c                                    |    1=20
 fs/overlayfs/export.c                             |    3=20
 fs/overlayfs/inode.c                              |    3=20
 include/linux/blk-mq.h                            |   13=20
 include/linux/bug.h                               |    5=20
 include/linux/mmc/host.h                          |    9=20
 include/linux/quotaops.h                          |    2=20
 kernel/kprobes.c                                  |    3=20
 kernel/printk/printk.c                            |    2=20
 kernel/sched/core.c                               |   61 +++-
 kernel/sched/cpufreq_schedutil.c                  |    7=20
 kernel/sched/deadline.c                           |   33 ++
 kernel/sched/fair.c                               |   11=20
 kernel/sched/idle.c                               |    5=20
 kernel/time/alarmtimer.c                          |    4=20
 kernel/time/posix-cpu-timers.c                    |   20 -
 mm/compaction.c                                   |   35 --
 mm/memcontrol.c                                   |   10=20
 mm/oom_kill.c                                     |    5=20
 net/appletalk/ddp.c                               |    5=20
 net/ax25/af_ax25.c                                |    2=20
 net/ieee802154/socket.c                           |    3=20
 net/ipv4/tcp_timer.c                              |    5=20
 net/nfc/llcp_sock.c                               |    7=20
 net/openvswitch/datapath.c                        |    2=20
 net/qrtr/qrtr.c                                   |    1=20
 net/sched/act_sample.c                            |    1=20
 net/sched/cls_api.c                               |    6=20
 net/sched/sch_api.c                               |    3=20
 net/sched/sch_netem.c                             |    2=20
 net/wireless/util.c                               |    1=20
 scripts/gcc-plugins/randomize_layout_plugin.c     |   10=20
 sound/firewire/motu/motu.c                        |   12=20
 sound/firewire/tascam/tascam-pcm.c                |    3=20
 sound/firewire/tascam/tascam-stream.c             |   42 +-
 sound/hda/hdac_controller.c                       |    2=20
 sound/i2c/other/ak4xxx-adda.c                     |    7=20
 sound/pci/hda/hda_controller.c                    |    5=20
 sound/pci/hda/hda_intel.c                         |    2=20
 sound/pci/hda/patch_hdmi.c                        |    9=20
 sound/pci/hda/patch_realtek.c                     |   16 +
 sound/soc/codecs/es8316.c                         |    7=20
 sound/soc/codecs/sgtl5000.c                       |   21 -
 sound/soc/codecs/tlv320aic31xx.c                  |    7=20
 sound/soc/fsl/fsl_ssi.c                           |   18 -
 sound/soc/intel/common/sst-ipc.c                  |    2=20
 sound/soc/intel/skylake/skl-debug.c               |    2=20
 sound/soc/intel/skylake/skl-nhlt.c                |    2=20
 sound/soc/sh/rcar/adg.c                           |   21 -
 sound/soc/soc-generic-dmaengine-pcm.c             |    6=20
 sound/soc/sunxi/sun4i-i2s.c                       |    9=20
 sound/soc/uniphier/aio-cpu.c                      |   31 +-
 sound/soc/uniphier/aio.h                          |    1=20
 sound/usb/pcm.c                                   |    1=20
 tools/include/uapi/asm/bitsperlong.h              |   18 -
 tools/lib/traceevent/Makefile                     |    6=20
 tools/lib/traceevent/event-plugin.c               |    2=20
 tools/perf/perf.c                                 |    3=20
 tools/perf/tests/shell/trace+probe_vfs_getname.sh |    4=20
 tools/perf/trace/beauty/ioctl.c                   |    2=20
 tools/perf/util/header.c                          |    4=20
 tools/perf/util/xyarray.h                         |    3=20
 237 files changed, 1874 insertions(+), 776 deletions(-)

A Sun (1):
      media: mceusb: fix (eliminate) TX IR signal length limit

Ahzo (1):
      drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)

Al Cooper (1):
      mmc: sdhci: Fix incorrect switch to HS mode

Al Stone (1):
      ACPI / CPPC: do not require the _PSD method

Alessio Balsini (1):
      loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Amadeusz S=C5=82awi=C5=84ski (3):
      ASoC: Intel: NHLT: Fix debug print format
      ASoC: Intel: Skylake: Use correct function to access iomem space
      ASoC: Intel: Fix use of potentially uninitialized variable

Andr=C3=A9 Draszik (1):
      ARM: dts: imx7d: cl-som-imx7: make ethernet work again

Anton Eidelman (1):
      nvme-multipath: fix ana log nsid lookup when nsid is not found

Ard van Breemen (1):
      ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Arnaldo Carvalho de Melo (3):
      perf config: Honour $PERF_CONFIG env var to specify alternate .perfco=
nfig
      perf test vfs_getname: Disable ~/.perfconfig to get default output
      tools headers: Fixup bitsperlong per arch includes

Arnd Bergmann (4):
      media: dib0700: fix link error for dibx000_i2c_set_speed
      dmaengine: iop-adma: use correct printk format strings
      net: lpc-enet: fix printk format strings
      media: don't drop front-end reference count for ->detach

Axel Lin (1):
      regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_=
vneg

Benjamin Peterson (1):
      perf trace beauty ioctl: Fix off-by-one error in cmd->string table

Bjorn Andersson (1):
      net: qrtr: Stop rx_worker before freeing node

Bj=C3=B8rn Mork (2):
      cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
      usbnet: ignore endpoints with invalid wMaxPacketSize

Bob Peterson (1):
      gfs2: clear buf_in_tr when ending a transaction in sweep_bh_for_rgrps

Bodong Wang (1):
      net/mlx5: Add device ID of upcoming BlueField-2

Chao Yu (1):
      quota: fix wrong condition in is_quota_modification()

Chris Brandt (1):
      i2c: riic: Clear NACK in tend isr

Chris Wilson (1):
      ALSA: hda: Flush interrupts on disabling

Christophe Leroy (1):
      btrfs: fix allocation of free space cache v1 bitmap pages

Colin Ian King (1):
      media: vsp1: fix memory leak of dl on error return path

Cong Wang (1):
      net_sched: add max len check for TCA_KIND

Dan Carpenter (1):
      EDAC/altera: Use the proper type for the IRQ status bits

Dan Williams (1):
      libata/ahci: Drop PCS quirk for Denverton and beyond

Danit Goldberg (1):
      IB/mlx5: Free mpi in mp_slave mode

Darius Rad (1):
      media: rc: imon: Allow iMON RC protocol for ffdc 7e device

Davide Caratti (1):
      net/sched: act_sample: don't push mac header on ip6gre ingress

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Ding Xiang (1):
      ovl: Fix dereferencing possible ERR_PTR()

Douglas RAILLARD (1):
      sched/cpufreq: Align trace event behavior of fast switching

Eric Biggers (1):
      fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock

Eric Dumazet (4):
      sch_netem: fix a divide by zero in tabledist()
      net: sched: fix possible crash in tcf_action_destroy()
      tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
      iommu/iova: Avoid false sharing on fq_timer_on

Ezequiel Garcia (2):
      media: i2c: ov5645: Fix power sequence
      media: imx: mipi csi-2: Don't fail if initial state times-out

Fabio Estevam (1):
      media: i2c: ov5640: Check for devm_gpiod_get_optional() error

Filipe Manana (2):
      Btrfs: fix use-after-free when using the tree modification log
      Btrfs: fix race setting up and completing qgroup rescan workers

Finn Thain (1):
      m68k: Prevent some compiler warnings in Coldfire builds

Gayatri Kammela (1):
      x86/cpu: Add Tiger Lake to Intel family

Geert Uytterhoeven (1):
      media: fdp1: Reduce FCP not found message level to debug

Gerald BAEZA (1):
      libperf: Fix alignment trap with xyarray contents in 'perf stat'

Greg Kroah-Hartman (1):
      Linux 4.19.77

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector I=
PI fails

Guoqing Jiang (3):
      md: don't call spare_active in md_reap_sync_thread if all member devi=
ces can't work
      md: don't set In_sync if array is frozen
      raid5: don't set STRIPE_HANDLE to stripe which is in batch list

Hans Verkuil (4):
      media: gspca: zero usb_buf on error
      media: radio/si470x: kill urb on error
      media: hdpvr: add terminating 0 at end of string
      media: cec-notifier: clear cec_adap in cec_notifier_unregister

Hans de Goede (2):
      media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
      efifb: BGRT: Improve efifb_bgrt_sanity_check

Harald Freudenberger (1):
      s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding

Helge Deller (1):
      parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Ira Weiny (1):
      IB/hfi1: Define variables as unsigned long to fix KASAN warning

Jan Dakinevich (2):
      KVM: x86: always stop emulation on page fault
      KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jan-Marek Glogowski (1):
      ALSA: hda/realtek - PCI quirk for Medion E4254

Jia-Ju Bai (1):
      ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in bu=
ild_adc_controls()

Jiri Slaby (1):
      ACPI / processor: don't print errors for processorIDs =3D=3D 0xff

Joonwon Kang (1):
      randstruct: Check member structs in is_pure_ops_struct()

Juri Lelli (2):
      sched/core: Fix CPU controller for !RT_GROUP_SCHED
      sched/deadline: Fix bandwidth accounting at all levels after offline =
migration

Kai-Heng Feng (3):
      e1000e: add workaround for possible stalled packet
      iommu/amd: Override wrong IVRS IOAPIC on Raven Ridge systems
      drm/amd/display: Restore backlight brightness after system resume

Kamil Konieczny (1):
      PM / devfreq: exynos-bus: Correct clock enable sequence

Katsuhiro Suzuki (1):
      ASoC: es8316: fix headphone mixer volume table

Kees Cook (1):
      binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Kent Overstreet (1):
      closures: fix a race on wakeup from closure_sync

Kevin Easton (1):
      libertas: Add missing sentinel at end of if_usb.c fw_table

Kunihiko Hayashi (1):
      ASoC: uniphier: Fix double reset assersion when transitioning to susp=
end state

Kuninori Morimoto (1):
      ASoC: rsnd: don't call clk_get_rate() under atomic context

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Leonard Crestez (1):
      PM / devfreq: passive: Use non-devm notifiers

Li RongQing (1):
      openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Lihua Yao (1):
      ARM: samsung: Fix system restart on S3C6410

Luca Coelho (1):
      iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 36

Lucas Stach (1):
      ASoC: tlv320aic31xx: suppress error message for EPROBE_DEFER

Luis Araneda (1):
      ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Luke Nowakowski-Krijger (1):
      media: hdpvr: Add device num check and handling

M. Vefa Bicakci (1):
      platform/x86: intel_pmc_core: Do not ioremap RAM

Maciej S. Szmigiero (1):
      media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate=
()

Madhavan Srinivasan (1):
      powerpc/imc: Dont create debugfs files for cpu-less nodes

Marek Szyprowski (1):
      ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks

Mark Brown (1):
      regulator: Defer init completion for a while after late_initcall

Mark Rutland (1):
      arm64: kpti: ensure patched kernel text is fetched from PoU

Mark Salyzyn (1):
      ovl: filter of trusted xattr results in audit

Martin Wilck (1):
      scsi: scsi_dh_rdac: zero cdb in send_mode_select()

Masami Hiramatsu (1):
      kprobes: Prohibit probing on BUG() and WARN() address

Matthias Brugger (1):
      media: mtk-mdp: fix reference count on old device tree

Mauro Carvalho Chehab (1):
      media: ov9650: add a sanity check

Maxime Ripard (1):
      ASoC: sun4i-i2s: Don't use the oversample to calculate BCLK

Michal Hocko (1):
      memcg, kmem: do not fail __GFP_NOFAIL charges

Mike Christie (1):
      nbd: add missing config put

Ming Lei (2):
      blk-mq: add callback of .cleanup_rq
      scsi: implement .cleanup_rq callback

Murphy Zhou (1):
      CIFS: fix max ea value size

MyungJoo Ham (1):
      PM / devfreq: passive: fix compiler warning

Navid Emamdoost (2):
      nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
      nfp: flower: prevent memory leak in nfp_flower_spawn_phy_reprs

Neil Horman (1):
      x86/apic/vector: Warn when vector space exhaustion breaks affinity

NeilBrown (3):
      md: don't report active array_state until after revalidate_disk() com=
pletes.
      md: only call set_in_sync() when it is expected to succeed.
      md/raid0: avoid RAID0 data corruption due to layout confusion.

Nick Stoughton (1):
      leds: leds-lp5562 allow firmware files up to the maximum length

Nigel Croxon (1):
      raid5: don't increment read_errors on EILSEQ return

Nikolay Borisov (1):
      btrfs: Relinquish CPUs in btrfs_compare_trees

Oleksandr Suvorov (2):
      ASoC: sgtl5000: Fix of unmute outputs on probe
      ASoC: sgtl5000: Fix charge pump source assignment

Oliver Neukum (2):
      usbnet: sanity checking of packet sizes and device mtu
      media: iguanair: add sanity checks

Ori Nimron (5):
      mISDN: enforce CAP_NET_RAW for raw sockets
      appletalk: enforce CAP_NET_RAW for raw sockets
      ax25: enforce CAP_NET_RAW for raw sockets
      ieee802154: enforce CAP_NET_RAW for raw sockets
      nfc: enforce CAP_NET_RAW for raw sockets

Paul E. McKenney (1):
      time/tick-broadcast: Fix tick_broadcast_offline() lockdep complaint

Pavel Shilovsky (1):
      CIFS: Fix oplock handling for SMB 2.1+ protocols

Peter Mamonov (1):
      net/phy: fix DP83865 10 Mbps HDX loopback disable function

Peter Ujfalusi (2):
      dmaengine: ti: edma: Do not reset reserved paRAM slots
      ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is n=
ot set

Peter Zijlstra (1):
      idle: Prevent late-arriving interrupts from disrupting offline

Phil Auld (1):
      sched/fair: Use rq_lock/unlock in online_fair_sched_group

Qian Cai (2):
      arm64/prefetch: fix a -Wtype-limits warning
      iommu/amd: Silence warnings under memory pressure

Qu Wenruo (3):
      btrfs: extent-tree: Make sure we only allocate extents from block gro=
ups with the same type
      btrfs: qgroup: Fix the wrong target io_tree when freeing reserved dat=
a space
      btrfs: qgroup: Fix reserved data space leak if we have multiple reser=
ve calls

Quinn Tran (1):
      scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag

Rakesh Pandit (1):
      ext4: fix warning inside ext4_convert_unwritten_extents_endio

Randy Dunlap (1):
      media: media/platform: fsl-viu.c: fix build for MICROBLAZE

Robert Richter (1):
      EDAC/mc: Fix grain_bits calculation

Sakari Ailus (2):
      media: omap3isp: Don't set streaming state on random subdevs
      media: omap3isp: Set device on omap3isp subdevs

Sasha Levin (1):
      Revert "ceph: use ceph_evict_inode to cleanup inode's resource"

Sean Christopherson (1):
      KVM: x86: Manually calculate reserved bits when loading PDPTRS

Sean Young (3):
      media: mtk-cir: lower de-glitch counter for rc-mm protocol
      media: em28xx: modules workqueue not inited for 2nd device
      media: dvb-frontends: use ida for pll number

Shawn Lin (1):
      arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328

Shengjiu Wang (1):
      ASoC: fsl_ssi: Fix clock control issue in master mode

Song Liu (1):
      x86/mm/pti: Handle unaligned address gracefully in pti_clone_pagetabl=
e()

Stefan Agner (1):
      ARM: dts: imx7-colibri: disable HS400

Stefan Assmann (1):
      i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask

Stefan Wahren (1):
      dmaengine: bcm2835: Print error in case setting DMA mask fails

Stephen Boyd (1):
      firmware: qcom_scm: Use proper types for dma mappings

Stephen Douthit (1):
      EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()

Stephen Hemminger (1):
      skge: fix checksum byte order

Steve French (1):
      smb3: allow disabling requesting leases

Sudeep Holla (1):
      firmware: arm_scmi: Check if platform has released shmem before using

Takashi Iwai (3):
      ALSA: hda - Show the fatal CORB/RIRB error more clearly
      ALSA: hda - Drop unsol event handler for Intel HDMI codecs
      ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Takashi Sakamoto (3):
      ALSA: firewire-motu: add support for MOTU 4pre
      ALSA: firewire-tascam: handle error code when getting current source =
of clock
      ALSA: firewire-tascam: check intermediate state of clock status and r=
etry

Takeshi Misawa (1):
      ppp: Fix memory leak in ppp_write

Tan Xiaojun (1):
      perf record: Support aarch64 random socket_id assignment

Tetsuo Handa (2):
      memcg, oom: don't require __GFP_FS when invoking memcg OOM killer
      /dev/mem: Bail out upon SIGKILL.

Thadeu Lima de Souza Cascardo (1):
      alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Theodore Ts'o (1):
      ext4: fix punch hole for inline_data file systems

Thomas Gleixner (4):
      x86/apic: Make apic_pending_intr_clear() more robust
      x86/apic: Soft disable APIC before initializing it
      posix-cpu-timers: Sanitize bogus WARNONS
      x86/mm/pti: Do not invoke PTI functions when PTI is disabled

Tom Wu (1):
      nvmet: fix data units read and written counters in SMART log

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Tzvetomir Stoyanov (1):
      libtraceevent: Change users plugin directory

Ulf Hansson (3):
      mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHRE=
AD
      mmc: core: Add helper function to indicate if SDIO IRQs is enabled
      mmc: dw_mmc: Re-store SDIO IRQs mask at system resume

Uwe Kleine-K=C3=B6nig (1):
      arcnet: provide a buffer big enough to actually receive packets

Vasily Averin (1):
      fuse: fix missing unlock_page in fuse_writepage()

Vincent Guittot (1):
      sched/fair: Fix imbalance due to CPU affinity

Vincent Whitchurch (1):
      printk: Do not lose last line in kmsg buffer dump

Vinod Koul (1):
      base: soc: Export soc_device_register/unregister APIs

Wang Shenran (1):
      hwmon: (acpi_power_meter) Change log level for 'unsafe software power=
 cap'

Wen Yang (1):
      media: exynos4-is: fix leaked of_node references

Wenwen Wang (6):
      led: triggers: Fix a memory leak bug
      media: dvb-core: fix a memory leak bug
      media: saa7146: add cleanup in hexium_attach()
      media: cpia2_usb: fix memory leaks
      ACPI: custom_method: fix memory leaks
      ACPI / PCI: fix acpi_pci_irq_enable() memory leak

Will Deacon (2):
      Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"
      arm64: tlb: Ensure we execute an ISB following walk cache invalidation

Xiao Ni (1):
      md/raid6: Set R5_ReadError when there is read failure on parity disk

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error

Xin Long (1):
      macsec: drop skb sk before calling gro_cells_receive

Yafang Shao (1):
      mm/compaction.c: clear total_{migrate,free}_scanned before scanning a=
 new zone

Yan, Zheng (1):
      ceph: use ceph_evict_inode to cleanup inode's resource

Yazen Ghannam (2):
      EDAC/amd64: Recognize DRAM device type ECC capability
      EDAC/amd64: Decode syndrome before translating address

Yufen Yu (3):
      md/raid1: end bio when the device faulty
      md/raid1: fail run raid1 array when active disk less than one
      block: fix null pointer dereference in blk_mq_rq_timed_out()

chenzefeng (1):
      ia64:unwind: fix double free for mod->arch.init_unw_table


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2ZsiYACgkQONu9yGCS
aT4SIw//TeCsoXxTJQOdWvtYYGmUu6IfI17GU7gL2WVeARCSgM+cpFOd9AOYz0HC
raDUfimzj7dzQQjlyzx3DdZ1587uSoegNJnHSa25ye+UE4lF6Zb3ksOChx4ruJpa
m+OKX0gZDULGlO1YuWYJBNTIN5iun8XkfH0tj0wLAU7Xn/y1x7VEMstLPZWGam4U
ofa8W1V3z2L4Q3ySiStiTzMfLjeFSn+AupvDvtCsRu36AEsCF7mSmKeSn7cJ+bH3
P9EdpPPYqrWSQi/hb4Bo+foTt054PPfvjcHpUgpkjEOMRhzAdoSmGpYLiZZ3uRIT
PvPU+T03hRsBpJSZy3xe1P04GCOZnz67jSozO/f95ub96lGsggUAqvbloDhkqm4X
IxzwCnpJa3hqPa9cUFQS/WRKg5BcL+Q6dhYMMCD0mMrFJKqkm28tpt+hn9YpeXD0
8oQH3LpawziLvFpUyhib6BxC/o+Ws4CqcdmnLqTz8r9Zz0qhP6df5hXnJ5cxL0t5
TJ8+Z31TZhrTIh7daeGLMWiuj6h45BDMMjQyJob4DkSTnQK2MFEwHPMCn8+zY58P
eaz2hpZZ5Yl5s6D23ka9VEpPHP8ZVTHvCowV101LbvmlH+OhjU2tZjYrTHafL2y/
Qe0MRWjUGlLQdxLRD/dur/ikWmLxOS216hjwCM1isOksYdfFslU=
=10w4
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
