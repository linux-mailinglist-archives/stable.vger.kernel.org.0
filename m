Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E77D311BE
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 17:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfEaPzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 11:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfEaPzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 11:55:24 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15D8D26AB1;
        Fri, 31 May 2019 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559318123;
        bh=HZs6nVy6F/WTPojjc/no+5eqf5/0yj9KRshUVWL9qiU=;
        h=Date:From:To:Cc:Subject:From;
        b=XfsgTc581qVvL1UuVnOPd2oTHpGleYi/q3Bz0rD9Iahz6y3uyl0qOMu6o8f9zIwtm
         2QUwvdcI85+sqvDWlej0YM9KzJR4u8DnIRUJq8XTzFfORcCzfmJzQzAIk/ZvvSTqnI
         YipPFlyDwW7QOFpjHkyvJy8QaTIukyBzJV8MY6fc=
Date:   Fri, 31 May 2019 08:55:22 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.180
Message-ID: <20190531155522.GA12584@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.180 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    2=20
 arch/arm/include/asm/cp15.h                                 |    2=20
 arch/arm/vdso/vgettimeofday.c                               |    5 -
 arch/arm64/include/asm/pgtable.h                            |    3=20
 arch/arm64/include/asm/vdso_datapage.h                      |    1=20
 arch/arm64/kernel/asm-offsets.c                             |    2=20
 arch/arm64/kernel/cpu_ops.c                                 |    1=20
 arch/arm64/kernel/vdso.c                                    |    3=20
 arch/arm64/kernel/vdso/gettimeofday.S                       |    7 -
 arch/arm64/mm/proc.S                                        |   26 +++----
 arch/powerpc/boot/addnote.c                                 |    6 +
 arch/powerpc/mm/numa.c                                      |   18 +++-
 arch/x86/Makefile                                           |    2=20
 arch/x86/ia32/ia32_signal.c                                 |   29 ++++---
 arch/x86/kernel/cpu/mcheck/mce.c                            |   44 +++++++=
+++--
 arch/x86/kernel/irq_64.c                                    |   19 +++--
 arch/x86/kernel/signal.c                                    |   29 ++++---
 arch/x86/kernel/vmlinux.lds.S                               |    6 -
 arch/x86/kvm/svm.c                                          |    6 +
 arch/x86/kvm/x86.c                                          |    2=20
 arch/x86/mm/fault.c                                         |    2=20
 drivers/base/power/main.c                                   |    4 +
 drivers/char/virtio_console.c                               |    3=20
 drivers/cpufreq/cpufreq.c                                   |    1=20
 drivers/cpufreq/cpufreq_governor.c                          |    2=20
 drivers/cpufreq/pasemi-cpufreq.c                            |    1=20
 drivers/cpufreq/pmac32-cpufreq.c                            |    2=20
 drivers/cpufreq/ppc_cbe_cpufreq.c                           |    1=20
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                     |    5 +
 drivers/crypto/vmx/aesp8-ppc.pl                             |    2=20
 drivers/dma/at_xdmac.c                                      |    6 +
 drivers/dma/pl330.c                                         |   10 +-
 drivers/dma/tegra210-adma.c                                 |   28 +++----
 drivers/extcon/extcon-arizona.c                             |   10 ++
 drivers/gpu/drm/drm_fops.c                                  |    1=20
 drivers/hid/hid-core.c                                      |   36 ++++++-=
--
 drivers/hid/hid-logitech-hidpp.c                            |   17 +++-
 drivers/hwmon/f71805f.c                                     |   15 +++-
 drivers/hwmon/pc87427.c                                     |   14 +++
 drivers/hwmon/smsc47b397.c                                  |   13 +++
 drivers/hwmon/smsc47m1.c                                    |   28 +++++--
 drivers/hwmon/vt1211.c                                      |   15 +++-
 drivers/iio/adc/ad_sigma_delta.c                            |   16 +++-
 drivers/iio/common/ssp_sensors/ssp_iio.c                    |    2=20
 drivers/iio/magnetometer/hmc5843_i2c.c                      |    7 +
 drivers/iio/magnetometer/hmc5843_spi.c                      |    7 +
 drivers/infiniband/hw/cxgb4/cm.c                            |    2=20
 drivers/md/bcache/alloc.c                                   |    5 -
 drivers/md/bcache/journal.c                                 |   26 ++++++-
 drivers/md/bcache/super.c                                   |   17 +++-
 drivers/media/dvb-frontends/m88ds3103.c                     |    9 +-
 drivers/media/i2c/ov2659.c                                  |    6 +
 drivers/media/i2c/soc_camera/ov6650.c                       |   25 +++---
 drivers/media/pci/saa7146/hexium_gemini.c                   |    5 -
 drivers/media/pci/saa7146/hexium_orion.c                    |    5 -
 drivers/media/platform/coda/coda-bit.c                      |    3=20
 drivers/media/platform/vivid/vivid-vid-cap.c                |    2=20
 drivers/media/radio/wl128x/fmdrv_common.c                   |    7 +
 drivers/media/usb/au0828/au0828-video.c                     |   16 +++-
 drivers/media/usb/cpia2/cpia2_v4l.c                         |    3=20
 drivers/media/usb/go7007/go7007-fw.c                        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                     |    2=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                     |    1=20
 drivers/mmc/core/pwrseq_emmc.c                              |   38 +++++--=
---
 drivers/mmc/core/sd.c                                       |    8 ++
 drivers/mmc/host/mmc_spi.c                                  |    4 +
 drivers/mmc/host/sdhci-of-esdhc.c                           |    5 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c                |    2=20
 drivers/net/ethernet/chelsio/cxgb3/l2t.h                    |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c             |   15 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    8 ++
 drivers/net/wireless/atmel/at76c50x-usb.c                   |    4 -
 drivers/net/wireless/broadcom/b43/phy_lp.c                  |    6 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    4 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     |   10 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      |   27 ++++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c   |    5 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                |    7 +
 drivers/net/wireless/marvell/mwifiex/cfg80211.c             |    6 +
 drivers/net/wireless/marvell/mwifiex/cfp.c                  |    3=20
 drivers/net/wireless/realtek/rtlwifi/base.c                 |    5 +
 drivers/net/wireless/st/cw1200/main.c                       |    5 +
 drivers/nvdimm/label.c                                      |   29 ++++---
 drivers/nvdimm/namespace_devs.c                             |   15 ++++
 drivers/nvdimm/nd.h                                         |    4 +
 drivers/pinctrl/pinctrl-pistachio.c                         |    2=20
 drivers/rtc/rtc-88pm860x.c                                  |    2=20
 drivers/s390/cio/cio.h                                      |    2=20
 drivers/scsi/libsas/sas_expander.c                          |    5 +
 drivers/scsi/lpfc/lpfc_ct.c                                 |    3=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                            |   11 ++-
 drivers/scsi/qla2xxx/qla_isr.c                              |    6 +
 drivers/scsi/qla4xxx/ql4_os.c                               |    2=20
 drivers/scsi/sd.c                                           |    3=20
 drivers/scsi/ufs/ufshcd.c                                   |   28 +++++--
 drivers/spi/spi-pxa2xx.c                                    |    8 +-
 drivers/spi/spi-rspi.c                                      |    9 +-
 drivers/spi/spi-tegra114.c                                  |   32 ++++----
 drivers/spi/spi-topcliff-pch.c                              |   15 +++-
 drivers/spi/spi.c                                           |    2=20
 drivers/ssb/bridge_pcmcia_80211.c                           |    9 +-
 drivers/tty/ipwireless/main.c                               |    8 ++
 drivers/usb/core/hcd.c                                      |    3=20
 drivers/usb/core/hub.c                                      |    5 +
 drivers/video/fbdev/core/fbcmap.c                           |    2=20
 drivers/video/fbdev/core/modedb.c                           |    3=20
 drivers/w1/w1_io.c                                          |    3=20
 fs/btrfs/extent-tree.c                                      |   25 +-----
 fs/btrfs/file.c                                             |   12 +++
 fs/btrfs/root-tree.c                                        |    4 -
 fs/btrfs/sysfs.c                                            |    7 +
 fs/char_dev.c                                               |    6 +
 fs/ext4/inode.c                                             |    2=20
 fs/gfs2/glock.c                                             |   22 +++---
 fs/gfs2/lock_dlm.c                                          |    9 +-
 fs/hugetlbfs/inode.c                                        |    8 --
 include/linux/bio.h                                         |    2=20
 include/linux/hid.h                                         |    1=20
 include/linux/hugetlb.h                                     |    4 -
 include/linux/iio/adc/ad_sigma_delta.h                      |    1=20
 include/linux/smpboot.h                                     |    2=20
 kernel/auditfilter.c                                        |   12 +--
 kernel/rcu/rcuperf.c                                        |    5 +
 kernel/rcu/rcutorture.c                                     |    5 +
 kernel/sched/core.c                                         |    9 ++
 lib/strncpy_from_user.c                                     |    5 -
 lib/strnlen_user.c                                          |    4 -
 mm/hugetlb.c                                                |   19 +----
 net/mac80211/mlme.c                                         |    3=20
 net/wireless/nl80211.c                                      |    5 +
 sound/soc/codecs/hdmi-codec.c                               |    6 +
 sound/soc/davinci/davinci-mcasp.c                           |    2=20
 sound/soc/fsl/Kconfig                                       |    9 +-
 sound/soc/fsl/eukrea-tlv320.c                               |    4 -
 sound/soc/fsl/fsl_sai.c                                     |    2=20
 sound/soc/fsl/fsl_utils.c                                   |    1=20
 tools/include/linux/bitops.h                                |    7 -
 tools/include/linux/bits.h                                  |   26 +++++++
 tools/perf/check-headers.sh                                 |    1=20
 tools/perf/util/util.h                                      |    1=20
 140 files changed, 835 insertions(+), 370 deletions(-)

Aditya Pakki (1):
      spi : spi-topcliff-pch: Fix to handle empty DMA buffers

Akinobu Mita (1):
      media: ov2659: make S_FMT succeed even if requested format doesn't ma=
tch

Alan Stern (1):
      USB: core: Don't unbind interfaces following device reset failure

Alexander Potapenko (1):
      media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

Andrea Merello (1):
      mmc: core: make pwrseq_emmc (partially) support sleepy GPIO controlle=
rs

Andrea Parri (1):
      bio: fix improper use of smp_mb__before_atomic()

Andreas Gruenbacher (1):
      gfs2: Fix sign extension bug in gfs2_update_stats

Arnaldo Carvalho de Melo (2):
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

Bart Van Assche (1):
      scsi: qla2xxx: Fix a qla24xx_enable_msix() error path

Bo YU (1):
      powerpc/boot: Fix missing check of lseek() return value

Charles Keepax (1):
      extcon: arizona: Disable mic detect if running when driver is removed

Chengguang Xu (1):
      chardev: add additional check for minor range overlap

Chris Lesiak (1):
      spi: Fix zero length xfer bug

Chris Wilson (1):
      drm: Wake up next in drm_read() chain if we are forced to putback the=
 event

Colin Ian King (1):
      RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Coly Li (2):
      bcache: return error immediately in bch_journal_replay()
      bcache: add failure check to run_cache_set() for journal replay

Corentin Labbe (1):
      crypto: sun4i-ss - Fix invalid calculation of hash end

Dan Carpenter (4):
      brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcm=
d_handler()
      mwifiex: prevent an array overflow
      media: pvrusb2: Prevent a buffer overflow
      media: wl128x: prevent two potential buffer overflows

Dan Williams (1):
      libnvdimm/namespace: Fix label tracking error

Daniel Axtens (1):
      crypto: vmx - CTR: always increment IV as quadword

Daniel Baluta (1):
      ASoC: fsl_sai: Update is_slave_mode with correct value

David Sterba (1):
      Revert "btrfs: Honour FITRIM range constraints during free space trim"

Filipe Manana (2):
      Btrfs: do not abort transaction at btrfs_update_root() after failure =
to COW path
      Btrfs: fix race between ranged fsync and writeback of adjacent ranges

Flavio Suligoi (1):
      spi: pxa2xx: fix SCR (divisor) calculation

Geert Uytterhoeven (1):
      spi: rspi: Fix sequencer reset during initialization

Greg Kroah-Hartman (1):
      Linux 4.9.180

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
      HID: logitech-hidpp: use RAP instead of FAP to get the protocol versi=
on

James Hutchinson (1):
      media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

James Smart (2):
      scsi: lpfc: Fix FDMI manufacturer attribute value
      scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices

Jan Kara (1):
      ext4: do not delete unlinked inode from orphan list on failed truncate

Janusz Krzysztofik (1):
      media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper

Jean-Philippe Brucker (1):
      arm64: Save and restore OSDLR_EL1 across suspend/resume

Jerome Brunet (1):
      ASoC: hdmi-codec: unlock the device on startup errors

Jiri Kosina (1):
      x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc=
_fault()

Jiufei Xue (1):
      fbdev: fix WARNING in __alloc_pages_nodemask bug

Johannes Berg (1):
      iwlwifi: pcie: don't crash on invalid RX interrupt

John Garry (1):
      scsi: libsas: Do discovery on empty PHY to update PHY info

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

Konstantin Khlebnikov (2):
      sched/core: Check quota and period overflow at usec to nsec conversion
      sched/core: Handle overflow in cpu_shares_write_u64

Lars-Peter Clausen (1):
      iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Marc Zyngier (1):
      ARM: vdso: Remove dependency with the arch_timer driver internals

Mariusz Bialonczyk (1):
      w1: fix the resume command API

Martin K. Petersen (1):
      Revert "scsi: sd: Keep disk read-only when re-reading partition"

Mike Kravetz (1):
      hugetlb: use same fault hash key for shared and private mappings

Nathan Chancellor (1):
      iio: common: ssp_sensors: Initialize calculated_time in ssp_common_pr=
ocess_data

Nathan Lynch (1):
      powerpc/numa: improve control of topology updates

Nicholas Nunley (1):
      i40e: don't allow changes to HW VLAN stripping on active port VLANs

Nicolas Ferre (1):
      dmaengine: at_xdmac: remove BUG_ON macro in tasklet

Nicolas Saenz Julienne (1):
      HID: core: move Usage Page concatenation to Main item

Pankaj Gupta (1):
      virtio_console: initialize vtermno value for ports

Paolo Bonzini (1):
      KVM: x86: fix return value for reserved EFER

Paul E. McKenney (2):
      rcutorture: Fix cleanup path for invalid torture_type strings
      rcuperf: Fix cleanup path for invalid perf_type strings

Peter Zijlstra (3):
      mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GC=
C versions
      x86/uaccess, signal: Fix AC=3D1 bloat
      x86/ia32: Fix ia32_restore_sigcontext() AC leak

Philipp Zabel (1):
      media: coda: clear error return value before picture run

Piotr Figiel (3):
      brcmfmac: convert dev_init_lock mutex to completion
      brcmfmac: fix race during disconnect when USB completion is in progre=
ss
      brcmfmac: fix Oops when bringing up interface during USB disconnect

Qian Cai (1):
      arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-va=
riable

Raul E Rangel (1):
      mmc: core: Verify SD bus width

Ross Lagerwall (1):
      gfs2: Fix lru_count going negative

Sameeh Jubran (1):
      net: ena: gcc 8: fix compilation warning

Sameer Pujar (2):
      dmaengine: tegra210-dma: free dma controller in remove()
      dmaengine: tegra210-adma: use devm_clk_*() helpers

Sebastian Andrzej Siewior (1):
      smpboot: Place the __percpu annotation correctly

Sergey Matyukevich (1):
      mac80211/cfg80211: update bss channel on channel switch

Shile Zhang (1):
      fbdev: fix divide error in fb_var_to_videomode

Shuah Khan (1):
      media: au0828: Fix NULL pointer dereference in au0828_analog_stream_e=
nable()

Sowjanya Komatineni (1):
      spi: tegra114: reset controller on probe

Stanley Chu (2):
      scsi: ufs: Fix regulator load and icc-level configuration
      scsi: ufs: Avoid configuring regulator with undefined voltage range

Sugar Zhang (1):
      dmaengine: pl330: _stop: clear interrupt status

Suthikulpanit, Suravee (1):
      kvm: svm/avic: fix off-by-one in checking host APIC ID

Sven Van Asbroeck (1):
      rtc: 88pm860x: prevent use-after-free on device remove

Tang Junhui (1):
      bcache: fix failure in journal relplay

Thomas Gleixner (1):
      x86/irq/64: Limit IST stack overflow check to #DB stack

Tobin C. Harding (1):
      btrfs: sysfs: don't leak memory when failing add fsid

Tony Lindgren (1):
      usb: core: Add PM runtime calls to usb_hcd_platform_shutdown

Tony Luck (1):
      x86/mce: Fix machine_check_poll() tests for error types

Ulf Hansson (1):
      PM / core: Propagate dev->power.wakeup_path when no callbacks

Vincenzo Frascino (1):
      arm64: vdso: Fix clock_getres() for CLOCK_REALTIME

Viresh Kumar (1):
      sched/cpufreq: Fix kobject memleak

Wen Yang (7):
      pinctrl: pistachio: fix leaked of_node references
      cpufreq: ppc_cbe: fix possible object reference leak
      cpufreq/pasemi: fix possible object reference leak
      cpufreq: pmac32: fix possible object reference leak
      arm64: cpu_ops: fix a leaked reference by adding missing of_node_put
      ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node=
_put
      ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wenwen Wang (1):
      audit: fix a memory leak bug

Yinbo Zhu (2):
      mmc: sdhci-of-esdhc: add erratum eSDHC5 support
      mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

YueHaibing (5):
      media: cpia2: Fix use-after-free in cpia2_exit
      ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit
      at76c50x-usb: Don't register led_trigger if usb_register_driver failed
      cxgb4: Fix error path in cxgb4_init_module
      mwifiex: Fix mem leak in mwifiex_tm_cmd


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzxTmoACgkQONu9yGCS
aT5pUhAAyOD52rz8gldpjYZuwnPb++isbL/T9J2dTmYHfQxW4vqzCKH8qzB5+n5P
dlcLC/gzuumgEBfqgeouPfH0+xQPdLcCfAcL53gUApAvjr0oWLV/c6ts0sh94iKU
AJj8pI+lZAkU/xj23QrsqUMaeSMtjpx9relyROHrUmeuImr8nlImBwN7CLlFHmRI
EDXB88HKzLETYI6bwgXbE9PRVOW1gDCCXeYSS05Dq+gjafwKjXmwyiTufCGwVR3n
H9tQyY27aRvZh7ecp8ooV9ELQmo9iVUfo8INJACrICCOPs2jL3PNLWwWi9QoY5i4
UepzkY/j3dOkelRPuHDdx97SzjUIAI3juNDBOOpLx3h7TvLFYDrrAOnYmpGxD/c1
ugbLtpIUJJl4eCGyTfKNOXqJx5AI6SKXvRoWmu/8v8yY/7gv/btO+u/HghS85PtT
AVrVXQTiegf3oEiiu9f3M/fdbc4LkD3j0tWKR6xzMGSlQVttctvro/3YKJaKrJi8
z7sgatHqpQnEb1HgkmzWsD+igXpUjw7bhO4pOjtqP6Nyd9qEroSidhENGWDPKbcY
gimYizfSsRPYp7SrqDajxlyMh+9Spi50EADh+2KlCnLTiQLO7XmZSD56G5/RnXSN
n6ys17zIg4+4DWI40rlHzgkNvEGtwHgHRs7j1tw8Yi0BlWSuDdc=
=xA+1
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
