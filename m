Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BF03CD18
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403962AbfFKNgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 09:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403965AbfFKNgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 09:36:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB43208E3;
        Tue, 11 Jun 2019 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560260158;
        bh=x3nM6CxzbWZs1/MgAHfxPI8nRRfWLvYm38SLCZYfxnw=;
        h=Date:From:To:Cc:Subject:From;
        b=eD374CLQHCZcy3gikxT9SGFxVojgo4NhjJ9oHpYrTobLnooJ90POr0z3VRQyz43rL
         1sqGXuHqvljiE5VhcBT6wHNjNWLkkFlc8pBUSF9dTE8RDVs3B2VrDcqpnisnTaAWLA
         W7uokSunlWZhep9deCjMC5xQUi+BGrv2mC43APrE=
Date:   Tue, 11 Jun 2019 15:35:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.181
Message-ID: <20190611133555.GA5973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.181 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/x86/mds.rst                           |   44 --
 Makefile                                            |    2 
 arch/arm/crypto/aesbs-glue.c                        |    4 
 arch/arm/kvm/arm.c                                  |   11 
 arch/arm/mach-exynos/firmware.c                     |    1 
 arch/arm/mach-exynos/suspend.c                      |    2 
 arch/arm64/kernel/cpu_ops.c                         |    1 
 arch/mips/pistachio/Platform                        |    1 
 arch/powerpc/boot/addnote.c                         |    6 
 arch/powerpc/mm/numa.c                              |   18 
 arch/sparc/mm/ultra.S                               |    4 
 arch/x86/Makefile                                   |    2 
 arch/x86/crypto/crct10dif-pclmul_glue.c             |   13 
 arch/x86/ia32/ia32_signal.c                         |   29 -
 arch/x86/kernel/irq_64.c                            |   19 -
 arch/x86/kernel/traps.c                             |    8 
 arch/x86/kvm/x86.c                                  |   31 +
 arch/x86/mm/fault.c                                 |    2 
 crypto/chacha20poly1305.c                           |    4 
 crypto/crct10dif_generic.c                          |   11 
 crypto/gcm.c                                        |   36 -
 crypto/salsa20_generic.c                            |    2 
 drivers/android/binder.c                            |   36 -
 drivers/base/power/main.c                           |    4 
 drivers/char/ipmi/ipmi_ssif.c                       |    6 
 drivers/char/virtio_console.c                       |    3 
 drivers/clk/tegra/clk-pll.c                         |    4 
 drivers/cpufreq/pasemi-cpufreq.c                    |    1 
 drivers/cpufreq/pmac32-cpufreq.c                    |    2 
 drivers/cpufreq/ppc_cbe_cpufreq.c                   |    1 
 drivers/crypto/vmx/aesp8-ppc.pl                     |    6 
 drivers/crypto/vmx/ghash.c                          |  218 ++++--------
 drivers/dma/at_xdmac.c                              |    6 
 drivers/dma/pl330.c                                 |   10 
 drivers/extcon/extcon-arizona.c                     |   10 
 drivers/gpu/drm/gma500/cdv_intel_lvds.c             |    3 
 drivers/gpu/drm/gma500/intel_bios.c                 |    3 
 drivers/gpu/drm/gma500/psb_drv.h                    |    1 
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h   |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c       |   26 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h       |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c      |   15 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c       |   21 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h       |    1 
 drivers/hid/hid-core.c                              |   36 +
 drivers/hid/hid-logitech-hidpp.c                    |   17 
 drivers/hwmon/f71805f.c                             |   15 
 drivers/hwmon/pc87427.c                             |   14 
 drivers/hwmon/smsc47b397.c                          |   13 
 drivers/hwmon/smsc47m1.c                            |   28 +
 drivers/hwmon/vt1211.c                              |   15 
 drivers/hwtracing/intel_th/msu.c                    |   35 +
 drivers/hwtracing/stm/core.c                        |    2 
 drivers/iio/adc/ad_sigma_delta.c                    |   16 
 drivers/iio/common/ssp_sensors/ssp_iio.c            |    2 
 drivers/infiniband/hw/cxgb4/cm.c                    |    2 
 drivers/iommu/tegra-smmu.c                          |   25 -
 drivers/md/bcache/alloc.c                           |    5 
 drivers/md/bcache/journal.c                         |   37 +-
 drivers/md/bcache/super.c                           |   19 -
 drivers/md/dm-delay.c                               |    3 
 drivers/md/md.c                                     |    6 
 drivers/md/raid5.c                                  |   29 +
 drivers/media/dvb-frontends/m88ds3103.c             |    9 
 drivers/media/i2c/ov2659.c                          |    6 
 drivers/media/i2c/soc_camera/ov6650.c               |   27 -
 drivers/media/pci/saa7146/hexium_gemini.c           |    5 
 drivers/media/pci/saa7146/hexium_orion.c            |    5 
 drivers/media/platform/coda/coda-bit.c              |    3 
 drivers/media/platform/vivid/vivid-vid-cap.c        |    2 
 drivers/media/radio/wl128x/fmdrv_common.c           |    7 
 drivers/media/usb/au0828/au0828-video.c             |   16 
 drivers/media/usb/cpia2/cpia2_v4l.c                 |    3 
 drivers/media/usb/go7007/go7007-fw.c                |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c             |    2 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h             |    1 
 drivers/media/usb/siano/smsusb.c                    |   33 +
 drivers/media/usb/uvc/uvc_driver.c                  |    2 
 drivers/memory/tegra/mc.c                           |    2 
 drivers/misc/genwqe/card_dev.c                      |    2 
 drivers/misc/genwqe/card_utils.c                    |    4 
 drivers/mmc/core/sd.c                               |    8 
 drivers/mmc/host/mmc_spi.c                          |    4 
 drivers/mmc/host/sdhci-of-esdhc.c                   |    5 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c    |   18 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |    2 
 drivers/net/ethernet/chelsio/cxgb3/l2t.h            |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     |   15 
 drivers/net/ethernet/intel/i40e/i40e_main.c         |    8 
 drivers/net/ethernet/marvell/mvpp2.c                |   10 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c     |    4 
 drivers/net/ethernet/mellanox/mlx4/mcg.c            |    2 
 drivers/net/ethernet/mellanox/mlx4/port.c           |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c   |    3 
 drivers/net/ppp/ppp_deflate.c                       |   20 -
 drivers/net/usb/cdc_ncm.c                           |    4 
 drivers/net/usb/usbnet.c                            |    6 
 drivers/net/wireless/at76c50x-usb.c                 |    4 
 drivers/net/wireless/b43/phy_lp.c                   |    6 
 drivers/net/wireless/brcm80211/brcmfmac/bus.h       |    4 
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c  |   23 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c      |   45 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c      |   57 ---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h      |   82 +++-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c    |   42 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c       |   10 
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c      |   32 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c       |   29 -
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c    |    5 
 drivers/net/wireless/cw1200/main.c                  |    5 
 drivers/net/wireless/mwifiex/cfp.c                  |    3 
 drivers/net/wireless/realtek/rtlwifi/base.c         |    5 
 drivers/parisc/ccio-dma.c                           |    4 
 drivers/parisc/sba_iommu.c                          |    3 
 drivers/pci/quirks.c                                |    1 
 drivers/pinctrl/pinctrl-pistachio.c                 |    2 
 drivers/power/power_supply_sysfs.c                  |    6 
 drivers/rtc/rtc-88pm860x.c                          |    2 
 drivers/s390/cio/cio.h                              |    2 
 drivers/s390/scsi/zfcp_ext.h                        |    1 
 drivers/s390/scsi/zfcp_scsi.c                       |    9 
 drivers/s390/scsi/zfcp_sysfs.c                      |   55 ++-
 drivers/s390/scsi/zfcp_unit.c                       |    8 
 drivers/scsi/libsas/sas_expander.c                  |    5 
 drivers/scsi/lpfc/lpfc_hbadisc.c                    |   11 
 drivers/scsi/qla4xxx/ql4_os.c                       |    2 
 drivers/scsi/sd.c                                   |    3 
 drivers/scsi/ufs/ufshcd.c                           |   28 +
 drivers/spi/spi-pxa2xx.c                            |    8 
 drivers/spi/spi-rspi.c                              |    9 
 drivers/spi/spi-tegra114.c                          |   32 -
 drivers/spi/spi-topcliff-pch.c                      |   15 
 drivers/spi/spi.c                                   |    2 
 drivers/ssb/bridge_pcmcia_80211.c                   |    9 
 drivers/staging/iio/magnetometer/hmc5843_i2c.c      |    7 
 drivers/staging/iio/magnetometer/hmc5843_spi.c      |    7 
 drivers/tty/ipwireless/main.c                       |    8 
 drivers/tty/serial/max310x.c                        |    2 
 drivers/tty/serial/msm_serial.c                     |    5 
 drivers/tty/vt/keyboard.c                           |   33 +
 drivers/usb/core/config.c                           |    4 
 drivers/usb/core/hcd.c                              |    3 
 drivers/usb/core/hub.c                              |    5 
 drivers/usb/core/quirks.c                           |    3 
 drivers/usb/host/xhci.c                             |   24 -
 drivers/usb/misc/rio500.c                           |   41 +-
 drivers/usb/misc/sisusbvga/sisusb.c                 |   15 
 drivers/video/fbdev/core/fbcmap.c                   |    2 
 drivers/video/fbdev/core/modedb.c                   |    3 
 drivers/video/fbdev/sm712.h                         |   12 
 drivers/video/fbdev/sm712fb.c                       |  243 ++++++++++---
 drivers/w1/w1_io.c                                  |    3 
 drivers/xen/xen-pciback/pciback_ops.c               |    2 
 drivers/xen/xenbus/xenbus_dev_frontend.c            |    2 
 fs/btrfs/backref.c                                  |   18 
 fs/btrfs/extent-tree.c                              |   25 +
 fs/btrfs/file.c                                     |   12 
 fs/btrfs/sysfs.c                                    |    7 
 fs/btrfs/tree-log.c                                 |    8 
 fs/ceph/super.c                                     |    7 
 fs/char_dev.c                                       |    6 
 fs/cifs/file.c                                      |    4 
 fs/cifs/smb2ops.c                                   |   14 
 fs/ext4/extents.c                                   |   17 
 fs/ext4/inode.c                                     |    2 
 fs/ext4/ioctl.c                                     |    2 
 fs/ext4/super.c                                     |    2 
 fs/fs-writeback.c                                   |   51 ++
 fs/fuse/file.c                                      |   13 
 fs/gfs2/glock.c                                     |   22 -
 fs/gfs2/lock_dlm.c                                  |    9 
 fs/hugetlbfs/inode.c                                |    8 
 fs/nfs/nfs4state.c                                  |    4 
 fs/ocfs2/export.c                                   |   30 +
 fs/open.c                                           |   18 
 fs/read_write.c                                     |    5 
 fs/ufs/util.h                                       |    2 
 fs/userfaultfd.c                                    |   41 +-
 include/linux/backing-dev-defs.h                    |    1 
 include/linux/bio.h                                 |    2 
 include/linux/bitops.h                              |   16 
 include/linux/fs.h                                  |    4 
 include/linux/hid.h                                 |    1 
 include/linux/hugetlb.h                             |    4 
 include/linux/iio/adc/ad_sigma_delta.h              |    1 
 include/linux/list_lru.h                            |    1 
 include/linux/mfd/da9063/registers.h                |    6 
 include/linux/of.h                                  |    4 
 include/linux/rcupdate.h                            |    6 
 include/linux/sched.h                               |    7 
 include/linux/skbuff.h                              |   30 +
 include/linux/smpboot.h                             |    2 
 include/linux/usb/gadget.h                          |    4 
 include/net/arp.h                                   |    8 
 include/uapi/linux/fuse.h                           |    2 
 include/uapi/linux/tipc_config.h                    |   10 
 kernel/auditfilter.c                                |   12 
 kernel/rcu/rcutorture.c                             |    5 
 kernel/sched/core.c                                 |    9 
 kernel/signal.c                                     |    2 
 kernel/trace/trace_events.c                         |    3 
 lib/strncpy_from_user.c                             |    5 
 lib/strnlen_user.c                                  |    4 
 mm/backing-dev.c                                    |    1 
 mm/hugetlb.c                                        |   19 -
 mm/list_lru.c                                       |    8 
 mm/mincore.c                                        |   23 +
 net/core/dev.c                                      |    4 
 net/core/ethtool.c                                  |   17 
 net/core/neighbour.c                                |    9 
 net/core/pktgen.c                                   |   11 
 net/ipv4/ip_vti.c                                   |    5 
 net/ipv4/xfrm4_policy.c                             |   24 -
 net/ipv6/raw.c                                      |    2 
 net/ipv6/xfrm6_tunnel.c                             |    4 
 net/llc/llc_output.c                                |    2 
 net/mac80211/mlme.c                                 |    3 
 net/rds/ib_rdma.c                                   |   10 
 net/sched/sch_tbf.c                                 |   10 
 net/tipc/core.c                                     |   32 +
 net/tipc/subscr.c                                   |   14 
 net/tipc/subscr.h                                   |    5 
 net/wireless/nl80211.c                              |    5 
 net/xfrm/xfrm_user.c                                |    2 
 scripts/coccinelle/api/stream_open.cocci            |  363 ++++++++++++++++++++
 sound/pci/hda/patch_hdmi.c                          |    6 
 sound/pci/hda/patch_realtek.c                       |    7 
 sound/soc/codecs/max98090.c                         |   12 
 sound/soc/codecs/rt5677-spi.c                       |   35 -
 sound/soc/davinci/davinci-mcasp.c                   |    2 
 sound/soc/fsl/Kconfig                               |    9 
 sound/soc/fsl/eukrea-tlv320.c                       |    4 
 sound/soc/fsl/fsl_sai.c                             |    2 
 sound/soc/fsl/fsl_utils.c                           |    1 
 sound/usb/mixer.c                                   |    2 
 tools/include/linux/bitops.h                        |    7 
 tools/include/linux/bits.h                          |   26 +
 tools/perf/bench/numa.c                             |    4 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   31 +
 tools/perf/util/string.c                            |    1 
 tools/perf/util/util.h                              |    1 
 241 files changed, 2441 insertions(+), 951 deletions(-)

Aditya Pakki (1):
      spi : spi-topcliff-pch: Fix to handle empty DMA buffers

Adrian Hunter (3):
      perf intel-pt: Fix instructions sampling rate
      perf intel-pt: Fix improved sample timestamp
      perf intel-pt: Fix sample timestamp wrt non-taken branches

Akinobu Mita (1):
      media: ov2659: make S_FMT succeed even if requested format doesn't match

Al Viro (1):
      ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Alan Stern (4):
      USB: core: Don't unbind interfaces following device reset failure
      USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor
      media: usb: siano: Fix general protection fault in smsusb
      media: usb: siano: Fix false-positive "uninitialized variable" warning

Alexander Potapenko (1):
      media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

Alexander Shishkin (1):
      intel_th: msu: Fix single mode with IOMMU

Andrea Parri (1):
      bio: fix improper use of smp_mb__before_atomic()

Andreas Gruenbacher (1):
      gfs2: Fix sign extension bug in gfs2_update_stats

Andrew Jones (1):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Andrey Smirnov (2):
      power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_SUPPLY_DEBUG
      xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

Andy Lutomirski (2):
      x86/speculation/mds: Revert CPU buffer clear on double fault exit
      x86/speculation/mds: Improve CPU buffer clear documentation

Antoine Tenart (1):
      net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Arend Van Spriel (1):
      brcmfmac: add length checks in scheduled scan result handler

Arend van Spriel (2):
      brcmfmac: revise handling events in receive path
      brcmfmac: add subtype check for event handling in data path

Arnaldo Carvalho de Melo (3):
      perf bench numa: Add define for RUSAGE_THREAD if not present
      perf tools: No need to include bitops.h in util.h
      tools include: Adopt linux/bits.h

Arnd Bergmann (8):
      ASoC: imx: fix fiq dependencies
      bcache: avoid clang -Wunintialized warning
      s390: cio: fix cio_irb declaration
      b43: shut up clang -Wuninitialized variable warning
      scsi: qla4xxx: avoid freeing unallocated dma memory
      media: go7007: avoid clang frame overflow warning with KASAN
      media: saa7146: avoid high stack usage with clang
      ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM

Ben Hutchings (1):
      binder: Replace "%p" with "%pK" for stable

Bjørn Mork (1):
      net: cdc_ncm: GetNtbFormat endian fix

Bo YU (1):
      powerpc/boot: Fix missing check of lseek() return value

Carsten Schmid (1):
      usb: xhci: avoid null pointer deref when bos field is NULL

Charles Keepax (1):
      extcon: arizona: Disable mic detect if running when driver is removed

Chengguang Xu (1):
      chardev: add additional check for minor range overlap

Chris Lesiak (1):
      spi: Fix zero length xfer bug

Chris Packham (1):
      tipc: Avoid copying bytes beyond the supplied data

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()

Colin Ian King (1):
      RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Coly Li (3):
      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()
      bcache: return error immediately in bch_journal_replay()
      bcache: add failure check to run_cache_set() for journal replay

Curtis Malainey (1):
      ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Dan Carpenter (5):
      brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()
      mwifiex: prevent an array overflow
      media: pvrusb2: Prevent a buffer overflow
      media: wl128x: prevent two potential buffer overflows
      genwqe: Prevent an integer overflow in the ioctl

Daniel Axtens (5):
      crypto: vmx - fix copy-paste error in CTR mode
      crypto: vmx - CTR: always increment IV as quadword
      crypto: vmx - ghash: do nosimd fallback manually
      net: create skb_gso_validate_mac_len()
      bnx2x: disable GSO where gso_size is too big for hardware

Daniel Baluta (1):
      ASoC: fsl_sai: Update is_slave_mode with correct value

David Ahern (2):
      neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
      ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled

David S. Miller (1):
      Revert "tipc: fix modprobe tipc failed after switch order of device registration"

Debabrata Banerjee (1):
      ext4: fix ext4_show_options for file systems w/o journal

Dmitry Osipenko (3):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divider
      iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
      memory: tegra: Fix integer overflow on tick value calculation

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file

Erez Alfasi (1):
      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Eric Biggers (6):
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
      crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
      crypto: chacha20poly1305 - set cra_name correctly
      crypto: salsa20 - don't access already-freed walk.iv
      crypto: arm/aes-neonbs - don't access already-freed walk.iv

Eric Dumazet (3):
      net: avoid weird emergency message
      llc: fix skb leak in llc_build_and_send_ui_pkt()
      net-gro: fix use-after-free read in napi_gro_frags()

Filipe Manana (3):
      Btrfs: do not start a transaction at iterate_extent_inodes()
      Btrfs: fix race between ranged fsync and writeback of adjacent ranges
      Btrfs: fix race updating log root item during fsync

Flavio Suligoi (1):
      spi: pxa2xx: fix SCR (divisor) calculation

Franky Lin (1):
      brcmfmac: screening firmware event packet

Gavin Li (1):
      brcmfmac: fix incorrect event channel deduction

Geert Uytterhoeven (1):
      spi: rspi: Fix sequencer reset during initialization

Greg Kroah-Hartman (2):
      Revert "x86/build: Move _etext to actual end of .text"
      Linux 4.4.181

Guenter Roeck (5):
      hwmon: (vt1211) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
      hwmon: (pc87427) Use request_muxed_region for Super-IO accesses
      hwmon: (f71805f) Use request_muxed_region for Super-IO accesses

Gustavo A. R. Silva (1):
      cxgb3/l2t: Fix undefined behaviour

Hans Verkuil (1):
      media: au0828: stop video streaming only when last user stops

Hans de Goede (1):
      HID: logitech-hidpp: use RAP instead of FAP to get the protocol version

Hante Meuleman (1):
      brcmfmac: Add length checks on firmware events

Hui Wang (1):
      ALSA: hda/hdmi - Consider eld_valid when reporting jack event

James Clarke (1):
      sparc64: Fix regression in non-hypervisor TLB flush xcall

James Hutchinson (1):
      media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset

James Smart (1):
      scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices

Jan Kara (1):
      ext4: do not delete unlinked inode from orphan list on failed truncate

Janusz Krzysztofik (2):
      media: ov6650: Fix sensor possibly not detected on probe
      media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount

Jeremy Sowden (1):
      vti4: ipip tunnel deregistration fixes.

Jiri Kosina (2):
      mm/mincore.c: make mincore() more conservative
      x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc_fault()

Jiri Slaby (1):
      memcg: make it work on sparse non-0-node systems

Jisheng Zhang (1):
      net: stmmac: fix reset gpio free missing

Jiufei Xue (2):
      fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount
      fbdev: fix WARNING in __alloc_pages_nodemask bug

Joe Burmeister (1):
      tty: max310x: Fix external crystal register setup

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coherence index of I/O pdirs

John Garry (1):
      scsi: libsas: Do discovery on empty PHY to update PHY info

Jon Hunter (1):
      ASoC: max98090: Fix restore of DAPM Muxes

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: Fix XON/XOFF

Junwei Hu (3):
      tipc: switch order of device registration to fix a crash
      tipc: fix modprobe tipc failed after switch order of device registration
      tipc: fix modprobe tipc failed after switch order of device registration -v2

Kailang Yang (2):
      ALSA: hda/realtek - EAPD turn on later
      ALSA: hda/realtek - Set default power save node to 0

Kamlakant Patel (1):
      ipmi:ssif: compare block number correctly for multi-part return messages

Kangjie Lu (6):
      net: cw1200: fix a NULL pointer dereference
      mmc_spi: add a status check for spi_sync_locked
      iio: hmc5843: fix potential NULL pointer dereferences
      rtlwifi: fix a potential NULL pointer dereference
      brcmfmac: fix missing checks for kmemdup
      tty: ipwireless: fix missing checks for ioremap

Kees Cook (2):
      x86/build: Move _etext to actual end of .text
      x86/build: Keep local relocations with ld.lld

Kirill Smelkov (2):
      fs: stream_open - opener for stream-like files so that read and write can run simultaneously without deadlock
      fuse: Add FOPEN_STREAM to use stream_open()

Kirill Tkhai (1):
      ext4: actually request zeroing of inode table after grow

Kloetzke Jan (1):
      usbnet: fix kernel crash after disconnect

Konrad Rzeszutek Wilk (1):
      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Konstantin Khlebnikov (2):
      sched/core: Check quota and period overflow at usec to nsec conversion
      sched/core: Handle overflow in cpu_shares_write_u64

Lars-Peter Clausen (1):
      iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Liang Chen (1):
      bcache: fix a race between cache register and cacheset unregister

Linus Torvalds (1):
      rcu: locking and unlocking need to always be at least barriers

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Lyude Paul (1):
      drm/nouveau/i2c: Disable i2c bus access after ->fini()

Mariusz Bialonczyk (1):
      w1: fix the resume command API

Martin K. Petersen (1):
      Revert "scsi: sd: Keep disk read-only when re-reading partition"

Mauro Carvalho Chehab (1):
      media: smsusb: better handle optional alignment

Maximilian Luz (1):
      USB: Add LPM quirk for Surface Dock GigE adapter

Michael Chan (1):
      bnxt_en: Fix aggregation buffer leak under OOM condition.

Michał Wadowski (1):
      ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug

Mike Kravetz (1):
      hugetlb: use same fault hash key for shared and private mappings

Mike Manning (1):
      ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Miklos Szeredi (2):
      fuse: fix writepages on 32bit
      fuse: fallocate: fix return with locked inode

Mikulas Patocka (1):
      dm delay: fix a crash when invalid device is specified

Nadav Amit (1):
      media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Nathan Chancellor (1):
      iio: common: ssp_sensors: Initialize calculated_time in ssp_common_process_data

Nathan Lynch (1):
      powerpc/numa: improve control of topology updates

Nicholas Nunley (1):
      i40e: don't allow changes to HW VLAN stripping on active port VLANs

Nicolas Ferre (1):
      dmaengine: at_xdmac: remove BUG_ON macro in tasklet

Nicolas Saenz Julienne (1):
      HID: core: move Usage Page concatenation to Main item

Nigel Croxon (1):
      md/raid: raid5 preserve the writeback action after the parity check

Nikolay Borisov (1):
      btrfs: Honour FITRIM range constraints during free space trim

Oleg Nesterov (1):
      userfaultfd: don't pin the user memory in userfaultfd_file_create()

Oliver Neukum (3):
      USB: sisusbvga: fix oops in error path of sisusb_probe
      USB: rio500: refuse more than one device at a time
      USB: rio500: fix memory leak in close after disconnect

Pankaj Gupta (1):
      virtio_console: initialize vtermno value for ports

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.

Paolo Bonzini (1):
      KVM: x86: fix return value for reserved EFER

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Paul Burton (1):
      MIPS: pistachio: Build uImage.gz by default

Paul E. McKenney (1):
      rcutorture: Fix cleanup path for invalid torture_type strings

Peter Chen (1):
      usb: gadget: fix request length error for isoc transfer

Peter Zijlstra (2):
      mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GCC versions
      x86/ia32: Fix ia32_restore_sigcontext() AC leak

Philipp Zabel (1):
      media: coda: clear error return value before picture run

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()

Piotr Figiel (2):
      brcmfmac: convert dev_init_lock mutex to completion
      brcmfmac: fix race during disconnect when USB completion is in progress

Rasmus Villemoes (1):
      include/linux/bitops.h: sanitize rotate primitives

Raul E Rangel (1):
      mmc: core: Verify SD bus width

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page array on ENOMEM

Ross Lagerwall (1):
      gfs2: Fix lru_count going negative

Sean Christopherson (1):
      KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes

Sebastian Andrzej Siewior (1):
      smpboot: Place the __percpu annotation correctly

Sergei Trofimovich (1):
      tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Sergey Matyukevich (1):
      mac80211/cfg80211: update bss channel on channel switch

Shile Zhang (1):
      fbdev: fix divide error in fb_var_to_videomode

Shuah Khan (1):
      media: au0828: Fix NULL pointer dereference in au0828_analog_stream_enable()

Shuning Zhang (1):
      ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Song Liu (1):
      Revert "Don't jump to compute_result state from check_result state"

Sowjanya Komatineni (1):
      spi: tegra114: reset controller on probe

Sriram Rajagopalan (1):
      ext4: zero out the unused memory region in the extent tree block

Stanley Chu (2):
      scsi: ufs: Fix regulator load and icc-level configuration
      scsi: ufs: Avoid configuring regulator with undefined voltage range

Steffen Klassert (1):
      xfrm4: Fix uninitialized memory read in _decode_session4

Steffen Maier (2):
      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove
      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)

Steve Twiss (1):
      mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L

Su Yanjun (1):
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

Sugar Zhang (1):
      dmaengine: pl330: _stop: clear interrupt status

Sven Van Asbroeck (1):
      rtc: 88pm860x: prevent use-after-free on device remove

Tang Junhui (1):
      bcache: fix failure in journal relplay

Tejun Heo (1):
      writeback: synchronize sync(2) against cgroup writeback membership switches

Thomas Gleixner (1):
      x86/irq/64: Limit IST stack overflow check to #DB stack

Tingwei Zhang (1):
      stm class: Fix channel free in stm output free path

Tobin C. Harding (1):
      btrfs: sysfs: don't leak memory when failing add fsid

Todd Kjos (1):
      binder: replace "%p" with "%pK"

Tony Lindgren (1):
      usb: core: Add PM runtime calls to usb_hcd_platform_shutdown

Ulf Hansson (1):
      PM / core: Propagate dev->power.wakeup_path when no callbacks

Vivien Didelot (1):
      ethtool: fix potential userspace buffer overflow

Wei Yongjun (1):
      crypto: gcm - Fix error return code in crypto_gcm_create_common()

Wen Yang (8):
      ARM: exynos: Fix a leaked reference by adding missing of_node_put
      pinctrl: pistachio: fix leaked of_node references
      cpufreq: ppc_cbe: fix possible object reference leak
      cpufreq/pasemi: fix possible object reference leak
      cpufreq: pmac32: fix possible object reference leak
      arm64: cpu_ops: fix a leaked reference by adding missing of_node_put
      ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node_put
      ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wenwen Wang (2):
      ALSA: usb-audio: Fix a memory leak bug
      audit: fix a memory leak bug

Yifeng Li (9):
      fbdev: sm712fb: fix brightness control on reboot, don't set SR30
      fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75
      fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-CR3F
      fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA
      fbdev: sm712fb: fix crashes during framebuffer writes by correctly mapping VRAM
      fbdev: sm712fb: fix support for 1024x768-16 mode
      fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled display
      fbdev: sm712fb: fix crashes and garbled display during DPMS modesetting
      fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallthrough

Yinbo Zhu (2):
      mmc: sdhci-of-esdhc: add erratum eSDHC5 support
      mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

YueHaibing (6):
      ppp: deflate: Fix possible crash in deflate_init
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink
      media: cpia2: Fix use-after-free in cpia2_exit
      ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit
      at76c50x-usb: Don't register led_trigger if usb_register_driver failed
      cxgb4: Fix error path in cxgb4_init_module

Yufen Yu (1):
      md: add mddev->pers to avoid potential NULL pointer dereference

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

Yunsheng Lin (1):
      ethtool: check the return value of get_regs_len

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount

Zhenliang Wei (1):
      kernel/signal.c: trace_signal_deliver when signal_group_exit

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool

