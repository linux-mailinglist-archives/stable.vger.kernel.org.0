Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBECF123725
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfLQUUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbfLQUUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:20:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC230206D8;
        Tue, 17 Dec 2019 20:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576614033;
        bh=gRrhaEkN8fN/0LDU49G+EuzXm/gFOqsZPT/2qVQ1o+4=;
        h=Date:From:To:Cc:Subject:From;
        b=YcCO8Vf6/nqv/86Fgi9PwYIg4ruGlwUEW0xedApqF+54Nvs2qtTD4YwGv5YPoI/bA
         oYlbB2eJTjO1/w4+ozM2GkLH/AK7h6pIKwTdvD/RnzvMhtqjsOjgsf+uf5Pq49vrEX
         e6PbGxvYaAxr35DcKagWU81gdv/cXCnQPsPrqOQQ=
Date:   Tue, 17 Dec 2019 21:20:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.4
Message-ID: <20191217202031.GA4140233@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.4 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt               |   22 -
 Makefile                                                      |    2=20
 arch/arm/boot/dts/omap3-pandora-common.dtsi                   |   36 ++
 arch/arm/boot/dts/omap3-tao3530.dtsi                          |    2=20
 arch/arm/mach-omap2/pdata-quirks.c                            |  104 -----=
---
 arch/powerpc/include/asm/sections.h                           |   14 +
 arch/powerpc/include/asm/vdso_datapage.h                      |    2=20
 arch/powerpc/kernel/Makefile                                  |    4=20
 arch/powerpc/kernel/asm-offsets.c                             |    2=20
 arch/powerpc/kernel/misc_64.S                                 |    4=20
 arch/powerpc/kernel/time.c                                    |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S                     |    7=20
 arch/powerpc/kernel/vdso64/cacheflush.S                       |    4=20
 arch/powerpc/kernel/vdso64/gettimeofday.S                     |    7=20
 arch/powerpc/platforms/powernv/opal-imc.c                     |    9=20
 arch/powerpc/sysdev/xive/common.c                             |    9=20
 arch/powerpc/sysdev/xive/spapr.c                              |   12=20
 arch/powerpc/xmon/Makefile                                    |    4=20
 arch/s390/boot/startup.c                                      |    5=20
 arch/s390/include/asm/pgtable.h                               |    4=20
 arch/s390/kernel/machine_kexec.c                              |    2=20
 arch/s390/kernel/smp.c                                        |    5=20
 block/blk-mq-sysfs.c                                          |   15 -
 drivers/acpi/acpi_lpss.c                                      |   27 +-
 drivers/acpi/bus.c                                            |    2=20
 drivers/acpi/device_pm.c                                      |   12=20
 drivers/acpi/ec.c                                             |   36 +-
 drivers/acpi/osl.c                                            |   28 +-
 drivers/android/binder.c                                      |    4=20
 drivers/char/hw_random/omap-rng.c                             |    9=20
 drivers/char/ppdev.c                                          |   16 -
 drivers/char/tpm/tpm2-cmd.c                                   |    4=20
 drivers/char/tpm/tpm_tis.c                                    |    2=20
 drivers/cpufreq/powernv-cpufreq.c                             |   17 +
 drivers/cpuidle/cpuidle.c                                     |    1=20
 drivers/cpuidle/driver.c                                      |   15 -
 drivers/cpuidle/governors/teo.c                               |   78 ++++--
 drivers/devfreq/devfreq.c                                     |   12=20
 drivers/edac/altera_edac.c                                    |    1=20
 drivers/edac/ghes_edac.c                                      |    4=20
 drivers/firmware/qcom_scm-64.c                                |    2=20
 drivers/gpu/drm/panfrost/panfrost_drv.c                       |    2=20
 drivers/gpu/drm/panfrost/panfrost_gem.c                       |    4=20
 drivers/gpu/drm/panfrost/panfrost_gem.h                       |    4=20
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c                   |   23 +
 drivers/gpu/drm/panfrost/panfrost_perfcnt.h                   |    2=20
 drivers/hwtracing/coresight/coresight-funnel.c                |   36 ++
 drivers/hwtracing/coresight/coresight-replicator.c            |   35 ++
 drivers/hwtracing/coresight/coresight-tmc-etf.c               |   26 +-
 drivers/hwtracing/coresight/coresight.c                       |   45 +--
 drivers/hwtracing/intel_th/core.c                             |    8=20
 drivers/hwtracing/intel_th/pci.c                              |   10=20
 drivers/hwtracing/stm/policy.c                                |    4=20
 drivers/iio/adc/ad7124.c                                      |    7=20
 drivers/iio/adc/ad7606.c                                      |    2=20
 drivers/iio/adc/ad7949.c                                      |   49 +--
 drivers/iio/humidity/hdc100x.c                                |    2=20
 drivers/iio/imu/adis16480.c                                   |   78 +++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c                    |   23 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h                     |   16 -
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                  |    9=20
 drivers/interconnect/qcom/qcs404.c                            |    8=20
 drivers/interconnect/qcom/sdm845.c                            |    4=20
 drivers/md/dm-writecache.c                                    |    3=20
 drivers/md/dm-zoned-metadata.c                                |   29 +-
 drivers/md/dm-zoned-reclaim.c                                 |    8=20
 drivers/md/dm-zoned-target.c                                  |   54 ++--
 drivers/md/dm-zoned.h                                         |    2=20
 drivers/md/md-linear.c                                        |    5=20
 drivers/md/md-multipath.c                                     |    5=20
 drivers/md/md.c                                               |   11=20
 drivers/md/md.h                                               |    4=20
 drivers/md/raid0.c                                            |    5=20
 drivers/md/raid1.c                                            |    5=20
 drivers/md/raid10.c                                           |    5=20
 drivers/md/raid5.c                                            |    4=20
 drivers/media/platform/qcom/venus/vdec.c                      |    3=20
 drivers/media/platform/qcom/venus/venc.c                      |    3=20
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                 |    3=20
 drivers/media/platform/vimc/vimc-sensor.c                     |    5=20
 drivers/media/radio/radio-wl1273.c                            |    3=20
 drivers/mmc/host/omap_hsmmc.c                                 |   30 ++
 drivers/mtd/devices/spear_smi.c                               |   38 ++
 drivers/mtd/nand/raw/nand_base.c                              |    8=20
 drivers/mtd/nand/raw/nand_micron.c                            |    4=20
 drivers/net/ethernet/realtek/r8169_main.c                     |    2=20
 drivers/net/wireless/ath/ar5523/ar5523.c                      |    3=20
 drivers/net/wireless/ath/wil6210/wmi.c                        |    6=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c             |   14 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c           |    9=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c           |    1=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c          |   25 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h          |    2=20
 drivers/net/wireless/virt_wifi.c                              |    4=20
 drivers/nvme/host/core.c                                      |   12=20
 drivers/pci/hotplug/acpiphp_glue.c                            |   12=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                      |    5=20
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                   |    6=20
 drivers/pinctrl/pinctrl-rza2.c                                |    4=20
 drivers/pinctrl/samsung/pinctrl-exynos.c                      |   14 -
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c                     |    6=20
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c                     |    6=20
 drivers/pinctrl/samsung/pinctrl-samsung.c                     |   10=20
 drivers/rtc/interface.c                                       |   19 +
 drivers/s390/scsi/zfcp_dbf.c                                  |    8=20
 drivers/scsi/lpfc/lpfc_scsi.c                                 |   11=20
 drivers/scsi/lpfc/lpfc_sli.c                                  |    5=20
 drivers/scsi/lpfc/lpfc_sli.h                                  |    3=20
 drivers/scsi/qla2xxx/qla_def.h                                |    6=20
 drivers/scsi/qla2xxx/qla_gs.c                                 |    2=20
 drivers/scsi/qla2xxx/qla_init.c                               |   31 +-
 drivers/scsi/qla2xxx/qla_isr.c                                |    5=20
 drivers/scsi/qla2xxx/qla_mbx.c                                |    4=20
 drivers/scsi/qla2xxx/qla_mid.c                                |   11=20
 drivers/scsi/qla2xxx/qla_nvme.c                               |    4=20
 drivers/scsi/qla2xxx/qla_os.c                                 |  127 +++++=
-----
 drivers/staging/exfat/exfat.h                                 |    4=20
 drivers/staging/exfat/exfat_core.c                            |    4=20
 drivers/staging/exfat/exfat_super.c                           |    4=20
 drivers/staging/isdn/gigaset/usb-gigaset.c                    |   23 +
 drivers/staging/media/hantro/hantro_g1_h264_dec.c             |   10=20
 drivers/staging/media/hantro/hantro_v4l2.c                    |   28 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                   |    2=20
 drivers/staging/rtl8712/usb_intf.c                            |    2=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    2=20
 drivers/usb/atm/ueagle-atm.c                                  |   18 -
 drivers/usb/common/usb-conn-gpio.c                            |    3=20
 drivers/usb/core/hub.c                                        |    5=20
 drivers/usb/core/urb.c                                        |    1=20
 drivers/usb/dwc3/dwc3-pci.c                                   |    6=20
 drivers/usb/dwc3/ep0.c                                        |    8=20
 drivers/usb/dwc3/gadget.c                                     |    5=20
 drivers/usb/gadget/configfs.c                                 |    1=20
 drivers/usb/gadget/udc/dummy_hcd.c                            |    2=20
 drivers/usb/gadget/udc/pch_udc.c                              |    1=20
 drivers/usb/host/xhci-hub.c                                   |   22 +
 drivers/usb/host/xhci-mem.c                                   |    4=20
 drivers/usb/host/xhci-pci.c                                   |   13 +
 drivers/usb/host/xhci-ring.c                                  |    6=20
 drivers/usb/host/xhci-tegra.c                                 |   25 +
 drivers/usb/host/xhci.c                                       |    9=20
 drivers/usb/host/xhci.h                                       |    1=20
 drivers/usb/misc/adutux.c                                     |    2=20
 drivers/usb/misc/idmouse.c                                    |    2=20
 drivers/usb/mon/mon_bin.c                                     |   32 +-
 drivers/usb/roles/class.c                                     |    2=20
 drivers/usb/serial/io_edgeport.c                              |   10=20
 drivers/usb/storage/uas.c                                     |   10=20
 drivers/usb/typec/class.c                                     |    6=20
 drivers/video/hdmi.c                                          |    8=20
 drivers/virtio/virtio_balloon.c                               |   11=20
 fs/btrfs/block-group.c                                        |    2=20
 fs/btrfs/delayed-inode.c                                      |   13 -
 fs/btrfs/extent_io.c                                          |   12=20
 fs/btrfs/file.c                                               |    2=20
 fs/btrfs/free-space-cache.c                                   |    6=20
 fs/btrfs/inode.c                                              |    9=20
 fs/btrfs/send.c                                               |   25 +
 fs/btrfs/volumes.h                                            |    1=20
 fs/ceph/dir.c                                                 |    1=20
 fs/ceph/file.c                                                |    2=20
 fs/erofs/xattr.c                                              |    2=20
 fs/ext2/inode.c                                               |    7=20
 fs/ext4/ialloc.c                                              |    5=20
 fs/ext4/inode.c                                               |   25 +
 fs/ext4/namei.c                                               |   11=20
 fs/ext4/super.c                                               |    2=20
 fs/ioctl.c                                                    |   35 ++
 fs/ocfs2/quota_global.c                                       |    2=20
 fs/overlayfs/dir.c                                            |    2=20
 fs/overlayfs/inode.c                                          |    8=20
 fs/overlayfs/namei.c                                          |    8=20
 fs/overlayfs/ovl_entry.h                                      |    2=20
 fs/overlayfs/super.c                                          |   24 +
 fs/quota/dquot.c                                              |   11=20
 fs/reiserfs/inode.c                                           |   12=20
 fs/reiserfs/namei.c                                           |    7=20
 fs/reiserfs/reiserfs.h                                        |    2=20
 fs/reiserfs/super.c                                           |    2=20
 fs/reiserfs/xattr.c                                           |   19 -
 fs/reiserfs/xattr_acl.c                                       |    4=20
 fs/splice.c                                                   |   14 -
 include/acpi/acpi_bus.h                                       |    6=20
 include/linux/fs.h                                            |    7=20
 include/linux/mfd/rk808.h                                     |    2=20
 include/linux/quotaops.h                                      |   10=20
 include/rdma/ib_verbs.h                                       |    4=20
 include/uapi/linux/cec.h                                      |    4=20
 kernel/cgroup/pids.c                                          |   11=20
 kernel/workqueue.c                                            |   38 ++
 lib/raid6/unroll.awk                                          |    2=20
 mm/shmem.c                                                    |   13 -
 mm/slab_common.c                                              |   12=20
 sound/firewire/fireface/ff-pcm.c                              |    2=20
 sound/firewire/oxfw/oxfw-pcm.c                                |    2=20
 sound/pci/hda/patch_realtek.c                                 |    8=20
 sound/soc/codecs/rt5645.c                                     |    6=20
 sound/soc/fsl/fsl_audmix.c                                    |    6=20
 sound/soc/fsl/fsl_audmix.h                                    |    1=20
 sound/soc/soc-jack.c                                          |    3=20
 tools/perf/tests/backward-ring-buffer.c                       |    9=20
 tools/testing/selftests/seccomp/seccomp_bpf.c                 |    3=20
 203 files changed, 1478 insertions(+), 799 deletions(-)

Alastair D'Silva (2):
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges=
 >4GB
      powerpc: Allow flush_icache_range to work across ranges >4GB

Aleksa Sarai (1):
      cgroup: pids: use atomic64_t for pids->limit

Alexander Shishkin (4):
      intel_th: Fix a double put_device() in error path
      intel_th: pci: Add Ice Lake CPU support
      intel_th: pci: Add Tiger Lake CPU support
      stm class: Lose the protocol driver when dropping its reference

Alexandre Belloni (1):
      rtc: disable uie before setting time and enable after

Amir Goldstein (3):
      ovl: fix lookup failure on multi lower squashfs
      ovl: fix corner case of non-unique st_dev;st_ino
      ovl: relax WARN_ON() on rename to self

Andrea Merello (2):
      iio: ad7949: kill pointless "readback"-handling code
      iio: ad7949: fix channels mixups

Andrey Konovalov (1):
      USB: dummy-hcd: increase max number of devices to 32

Andy Shevchenko (1):
      ACPI / utils: Move acpi_dev_get_first_match_dev() under CONFIG_ACPI

Arnd Bergmann (4):
      compat_ioctl: add compat_ptr_ioctl()
      ceph: fix compat_ioctl for ceph_dir_operations
      media: venus: remove invalid compat_ioctl32 handler
      ppdev: fix PPGETTIME/PPSETTIME ioctls

Arun Easi (1):
      scsi: qla2xxx: Fix memory leak when sending I/O fails

Bart Van Assche (2):
      RDMA/core: Fix ib_dma_max_seg_size()
      scsi: qla2xxx: Fix a dma_pool_free() call

Beniamin Bia (1):
      iio: adc: ad7606: fix reading unnecessary data from device

Boris Brezillon (1):
      drm/panfrost: Open/close the perfcnt BO

Brendan Higgins (1):
      staging: exfat: fix multiple definition error of `rename_file'

Bryan O'Donoghue (1):
      usb: common: usb-conn-gpio: Don't log an error on probe deferral

Chen Jun (1):
      mm/shmem.c: cast the type of unmap_start to u64

Chengguang Xu (1):
      ext2: check err when partial !=3D NULL

Chris Brandt (1):
      pinctrl: rza2: Fix gpio name typos

Chris Lesiak (1):
      iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Christian Brauner (1):
      seccomp: avoid overflow in implicit constant conversion

C=C3=A9dric Le Goater (2):
      powerpc/xive: Prevent page fault issues in the machine crash handler
      powerpc/xive: Skip ioremap() of ESB pages for LSI interrupts

Dafna Hirschfeld (1):
      media: vimc: sen: remove unused kthread_sen field

Daniel Schultz (1):
      mfd: rk808: Fix RK818 ID template

Darrick J. Wong (1):
      splice: only read in as much information as there is pipe buffer space

David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between =
zones

David Jeffery (1):
      md: improve handling of bio with REQ_PREFLUSH in md_flush_request()

Denis Efremov (2):
      wil6210: check len before memcpy() calls
      ar5523: check NULL before memcpy() in ar5523_cmd()

Dmitry Fomichev (1):
      dm zoned: reduce overhead of backing device checks

Dmitry Monakhov (2):
      quota: Check that quota is not dirty before release
      quota: fix livelock in dquot_writeback_dquots

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function

Ezequiel Garcia (1):
      media: hantro: Fix s_fmt for dynamic resolution changes

Filipe Manana (3):
      Btrfs: fix metadata space leak on fixup worker failure to set range a=
s delalloc
      Btrfs: fix negative subv_writers counter and data space leak after bu=
ffered write
      Btrfs: send, skip backreference walking for extents with many referen=
ces

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c

Francois Buergisser (2):
      media: hantro: Fix motion vectors usage condition
      media: hantro: Fix picture order count table enable

Gao Xiang (1):
      erofs: zero out when listxattr is called with no xattr

Georgi Djakov (2):
      interconnect: qcom: sdm845: Walk the list safely on node removal
      interconnect: qcom: qcs404: Walk the list safely on node removal

Gerald Schaefer (2):
      s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported
      s390/kaslr: store KASLR offset for early dumps

Greg Kroah-Hartman (2):
      lib: raid6: fix awk build warnings
      Linux 5.4.4

Gregory CLEMENT (1):
      pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type=
()

Gustavo A. R. Silva (1):
      usb: gadget: pch_udc: fix use after free

H. Nikolaus Schaller (4):
      ARM: dts: pandora-common: define wl1251 as child node of mmc3
      mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid=
 of pandora_wl1251_init_card
      omap: pdata-quirks: revert pandora specific gpiod additions
      omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Hans Verkuil (1):
      media: cec.h: CEC_OP_REC_FLAG_ values were swapped

Hans de Goede (4):
      tpm: Switch to platform_get_irq_optional()
      ACPI: LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links
      ACPI: LPSS: Add LNXVIDEO -> BYT I2C1 to lpss_device_links
      ACPI: LPSS: Add dmi quirk for skipping _DEP check for some device-lin=
ks

Heikki Krogerus (1):
      usb: dwc3: pci: add ID for the Intel Comet Lake -H variant

Heiko Carstens (1):
      s390/smp,vdso: fix ASCE handling

Heiner Kallweit (1):
      r8169: fix rtl_hw_jumbo_disable for RTL8168evl

Henry Lin (1):
      usb: xhci: only set D3hot for pci device

Hui Wang (1):
      ALSA: hda/realtek - Line-out jack doesn't work on a Dell AIO

Jacob Rasmussen (2):
      ASoC: rt5645: Fixed buddy jack support.
      ASoC: rt5645: Fixed typo for buddy jack support.

James Smart (1):
      scsi: lpfc: Fix bad ndlp ptr in xri aborted handling

Jan Kara (2):
      ext4: Fix credit estimate for final inode freeing
      ext4: fix leak of quota reservations

Jarkko Nikula (1):
      ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polari=
ty

Jean-Baptiste Maneyrol (1):
      iio: imu: inv_mpu6050: fix temperature reporting using bad unit

Jeff Mahoney (1):
      reiserfs: fix extended attributes on the root directory

Jian-Hong Pan (1):
      Revert "nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T"

Johan Hovold (11):
      staging: rtl8188eu: fix interface sanity check
      staging: rtl8712: fix interface sanity check
      staging: gigaset: fix general protection fault on probe
      staging: gigaset: fix illegal free on probe errors
      staging: gigaset: add endpoint-type sanity check
      USB: atm: ueagle-atm: add missing endpoint check
      USB: idmouse: fix interface sanity checks
      USB: serial: io_edgeport: fix epic endpoint lookup
      USB: adutux: fix interface sanity check
      media: bdisp: fix memleak on release
      media: radio: wl1273: fix interrupt masking on release

Johannes Berg (1):
      iwlwifi: pcie: fix support for transmitting SKBs with fraglist

John Hubbard (1):
      cpufreq: powernv: fix stack bloat and hard limit on number of CPUs

Josef Bacik (4):
      btrfs: check page->mapping when loading free space cache
      btrfs: use btrfs_block_group_cache_done in update_block_group
      btrfs: use refcount_inc_not_zero in kill_all_nodes
      btrfs: record all roots for rename exchange on a subvol

Kai-Heng Feng (2):
      usb: Allow USB device to be warm reset in suspended state
      xhci: Increase STS_HALT timeout in xhci_suspend()

Keith Busch (1):
      nvme: Namepace identification descriptor list is optional

Krzysztof Kozlowski (4):
      pinctrl: samsung: Fix device node refcount leaks in Exynos wakeup con=
troller init
      pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup co=
ntroller init
      pinctrl: samsung: Fix device node refcount leaks in init code
      pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup co=
ntroller init

Larry Finger (3):
      rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
      rtlwifi: rtl8192de: Fix missing callback that tests for hw release of=
 buffer
      rtlwifi: rtl8192de: Fix missing enable interrupt flag

Leo Yan (1):
      perf tests: Fix out of bounds memory access

Leonard Crestez (1):
      PM / devfreq: Lock devfreq in trans_stat_show

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw

Madhavan Srinivasan (1):
      powerpc/perf: Disable trace_imc pmu

Maged Mokhtar (1):
      dm writecache: handle REQ_FUA

Marcelo Diop-Gonzalez (1):
      staging: vchiq: call unregister_chrdev_region() when driver registrat=
ion fails

Marcelo Tosatti (1):
      cpuidle: use first valid target residency as poll time

Martin K. Petersen (1):
      Revert "scsi: qla2xxx: Fix memory leak when sending I/O fails"

Mathias Nyman (3):
      xhci: fix USB3 device initiated resume race with roothub autosuspend
      xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behavi=
our.
      xhci: make sure interrupts are restored to correct state

Meng Li (1):
      EDAC/altera: Use fast register IO for S10 IRQs

Michael Ellerman (1):
      powerpc: Define arch_is_kernel_initmem_freed() for lockdep

Mika Westerberg (2):
      xhci: Fix memory leak in xhci_add_in_port()
      ACPI / hotplug / PCI: Allocate resources directly under the non-hotpl=
ug bridge

Ming Lei (2):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
      blk-mq: make sure that line break can be printed

Miquel Raynal (1):
      mtd: spear_smi: Fix Write Burst mode

Mircea Caprioru (1):
      iio: adc: ad7124: Enable internal reference

Nagarjuna Kristam (1):
      usb: host: xhci-tegra: Correct phy enable sequence

Nathan Chancellor (1):
      powerpc: Avoid clang warnings around setjmp and longjmp

Nicolas Geoffray (1):
      mm, memfd: fix COW issue on MAP_PRIVATE and F_SEAL_FUTURE_WRITE mappi=
ngs

Nishka Dasgupta (1):
      pinctrl: samsung: Add of_node_put() before return in error path

Nuno S=C3=A1 (2):
      iio: adis16480: Add debugfs_reg_access entry
      iio: adis16480: Fix scales factors

Oliver Neukum (3):
      USB: uas: honor flag to avoid CAPACITY16
      USB: uas: heed CAPACITY_HEURISTICS
      USB: documentation: flags on usb-storage versus UAS

Pawel Harlozinski (1):
      ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read

Piotr Sroka (1):
      mtd: rawnand: Change calculating of position page containing BBM

Qu Wenruo (1):
      btrfs: Remove btrfs_bio::flags member

Quinn Tran (4):
      scsi: qla2xxx: Do command completion on abort timeout
      scsi: qla2xxx: Fix driver unload hang
      scsi: qla2xxx: Fix double scsi_done for abort path
      scsi: qla2xxx: Fix SRB leak on switch command timeout

Rafael J. Wysocki (6):
      cpuidle: teo: Ignore disabled idle states that are too deep
      cpuidle: teo: Rename local variable in teo_select()
      cpuidle: teo: Consider hits and misses metrics of disabled states
      cpuidle: teo: Fix "early hits" handling for disabled idle states
      ACPI: EC: Rework flushing of pending work
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: disable PCIe interrupts before bus reset

Robert Richter (1):
      EDAC/ghes: Do not warn when incrementing refcount on 0

Roman Gushchin (1):
      mm: memcg/slab: wait for !root kmem_cache refcnt killing on root kmem=
_cache destruction

Shengjiu Wang (1):
      ASoC: fsl_audmix: Add spin lock to protect tdms

Steffen Maier (1):
      scsi: zfcp: trace channel log even for FCP command responses

Sumit Garg (1):
      hwrng: omap - Fix RNG wait loop timeout

Tadeusz Struk (1):
      tpm: add check after commands attribs tab allocation

Taehee Yoo (1):
      virt_wifi: fix use-after-free in virt_wifi_newlink()

Takashi Sakamoto (2):
      ALSA: fireface: fix return value in error path of isochronous resourc=
es reservation
      ALSA: oxfw: fix return value in error path of isochronous resources r=
eservation

Tejas Joglekar (1):
      usb: dwc3: gadget: Fix logical condition

Tejun Heo (4):
      btrfs: Avoid getting stuck during cyclic writebacks
      workqueue: Fix spurious sanity check failures in destroy_workqueue()
      workqueue: Fix pwq ref leak in rescuer_thread()
      workqueue: Fix missing kfree(rescuer) in destroy_workqueue()

Theodore Ts'o (1):
      ext4: work around deleting a file with i_nlink =3D=3D 0 safely

Thinh Nguyen (2):
      usb: dwc3: gadget: Clear started flag for non-IOC
      usb: dwc3: ep0: Clear started flag on completion

Todd Kjos (1):
      binder: fix incorrect calculation for num_valid

Vamshi K Sthambamkadi (1):
      ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Ville Syrj=C3=A4l=C3=A4 (1):
      video/hdmi: Fix AVI bar unpack

Vincenzo Frascino (1):
      powerpc: Fix vDSO clock_getres()

Wei Yongjun (1):
      usb: gadget: configfs: Fix missing spin_lock_init()

Wen Yang (2):
      usb: roles: fix a potential use after free
      usb: typec: fix use after free in typec_register_port()

Will Deacon (1):
      firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Yabin Cui (1):
      coresight: Serialize enabling/disabling a link device.

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already

yangerkun (1):
      ext4: fix a bug in ext4_wait_for_tail_page_commit


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl35OI8ACgkQONu9yGCS
aT4zRQ//adgJ82KX+958HPnIcBiA3nFTrW8PS/RG/ScxJfSb/ptc0LByFLPkuriw
H6HgY0GV1N2AxhWDdEeIxHTpBPy3Js/ld5IX9dkjkzCAhy13V8c1/lipAShKOZBp
4XWvJv5WIDRfbx6fwTNL8WS+Sr/Mfe9WqOucIpLNAUPL49aytXaGNcwEpK6gPiZG
yEimmLaCqlInlkDOrYyXNbXCxxaYBfqiLNlfwMJxKTtLKG0zwqN3DRpT0vOFs+CE
S9tJyadySYs57H4LogW8A3vMFMrSqR4oBfd2+dzfSI07MgpuBhM5LEQuFLj6MS9s
U1zsKa1eCOFY0t8cwdv0zRDqJCEHz3HIhLY8IQZRxMdoI4TmuJzaOR/P7jEJGqYA
bp/90iKy6Ze2vV3y/J+Z1YH2eqYu9gleSnOvw4O5GLQdAdHehKE8xhbGeihqJsCL
HGnFObaDyqjswdly+pFGXW0HqqTapyQPZ/j2AJ1ncJZE/sQ8T/Ho6/e8HWzf10eS
1X13HapND3jllpTu22+rJbHwsy6FDLdeNu6xzXMSgRVW+2PN8G2awtIuQ3FpmGIv
xp30GgSuMyc1UW2z6capEMKZPk0zqN6hrdQVdErs2azcWUjmuZGJVIcUz+GyJipz
Ro9YsMlwRahJp4E0d9vjqo7dcoDraAYEImnnCx0kr5EATJJwKoo=
=oay7
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
