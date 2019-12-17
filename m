Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084B512372C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfLQUVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbfLQUVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:21:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3F4206D8;
        Tue, 17 Dec 2019 20:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576614062;
        bh=8jv+1msjUxbuBGzkA8XGKHn+EbQJqEROctFE7crzGQ8=;
        h=Date:From:To:Cc:Subject:From;
        b=gDg6B+hIaSTtUhaYMPg8hjTUejr4YiMlXbRPR4ysPZG/XtfgkBJ8a0muFdySAqdYC
         dRi3fLmw71muy0ixF0zAdCSPuyLNMm+D+4ygN0wxvSNAnCCEXz2tkIwVXN4dr7wpQO
         Qh1vUw1UH7R4z9HlqbTjMljJajqBQGB+j2jAquUY=
Date:   Tue, 17 Dec 2019 21:21:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.17
Message-ID: <20191217202100.GA4140359@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.17 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt               |   22 -
 Makefile                                                      |    2=20
 arch/arm/boot/dts/omap3-pandora-common.dtsi                   |   36 +
 arch/arm/boot/dts/omap3-tao3530.dtsi                          |    2=20
 arch/arm/mach-omap2/pdata-quirks.c                            |  104 -----
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                 |    9=20
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
 block/bio.c                                                   |    4=20
 block/blk-mq-sysfs.c                                          |   15=20
 drivers/acpi/acpi_lpss.c                                      |   27 +
 drivers/acpi/bus.c                                            |    2=20
 drivers/acpi/device_pm.c                                      |   12=20
 drivers/acpi/osl.c                                            |   28 -
 drivers/android/binder.c                                      |    4=20
 drivers/char/hw_random/omap-rng.c                             |    9=20
 drivers/char/ppdev.c                                          |   16=20
 drivers/char/tpm/tpm2-cmd.c                                   |    4=20
 drivers/cpufreq/powernv-cpufreq.c                             |   17=20
 drivers/cpuidle/driver.c                                      |   15=20
 drivers/cpuidle/governors/teo.c                               |   78 ++-
 drivers/devfreq/devfreq.c                                     |   12=20
 drivers/edac/altera_edac.c                                    |    1=20
 drivers/edac/ghes_edac.c                                      |    4=20
 drivers/firmware/qcom_scm-64.c                                |    2=20
 drivers/hwtracing/coresight/coresight-funnel.c                |   36 +
 drivers/hwtracing/coresight/coresight-replicator.c            |   35 +
 drivers/hwtracing/coresight/coresight-tmc-etf.c               |   26 -
 drivers/hwtracing/coresight/coresight.c                       |   45 --
 drivers/hwtracing/intel_th/core.c                             |    8=20
 drivers/hwtracing/intel_th/pci.c                              |   10=20
 drivers/hwtracing/stm/policy.c                                |    4=20
 drivers/iio/adc/ad7124.c                                      |    7=20
 drivers/iio/adc/ad7606.c                                      |    2=20
 drivers/iio/adc/ad7949.c                                      |   49 --
 drivers/iio/humidity/hdc100x.c                                |    2=20
 drivers/iio/imu/adis16480.c                                   |   78 ++-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c                    |   23 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h                     |   16=20
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h                       |    2=20
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                  |  205 +++++=
+++--
 drivers/interconnect/qcom/sdm845.c                            |    4=20
 drivers/md/dm-writecache.c                                    |    3=20
 drivers/md/dm-zoned-metadata.c                                |   29 -
 drivers/md/dm-zoned-reclaim.c                                 |    8=20
 drivers/md/dm-zoned-target.c                                  |   54 +-
 drivers/md/dm-zoned.h                                         |    2=20
 drivers/md/md-linear.c                                        |    5=20
 drivers/md/md-multipath.c                                     |    5=20
 drivers/md/md.c                                               |   11=20
 drivers/md/md.h                                               |    4=20
 drivers/md/raid0.c                                            |    5=20
 drivers/md/raid1.c                                            |    5=20
 drivers/md/raid10.c                                           |    5=20
 drivers/md/raid5.c                                            |    6=20
 drivers/media/platform/qcom/venus/vdec.c                      |    3=20
 drivers/media/platform/qcom/venus/venc.c                      |    3=20
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                 |    3=20
 drivers/media/radio/radio-wl1273.c                            |    3=20
 drivers/mmc/host/omap_hsmmc.c                                 |   30 +
 drivers/mtd/devices/spear_smi.c                               |   38 +
 drivers/mtd/nand/raw/nand_base.c                              |    8=20
 drivers/mtd/nand/raw/nand_micron.c                            |    4=20
 drivers/net/wireless/ath/ar5523/ar5523.c                      |    3=20
 drivers/net/wireless/ath/wil6210/wmi.c                        |    6=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c             |   14=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c           |    9=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c           |    1=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c          |   25 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h          |    2=20
 drivers/net/wireless/virt_wifi.c                              |    4=20
 drivers/nvme/host/core.c                                      |   10=20
 drivers/pci/hotplug/acpiphp_glue.c                            |   12=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                      |    5=20
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                   |    6=20
 drivers/pinctrl/pinctrl-rza2.c                                |    4=20
 drivers/pinctrl/samsung/pinctrl-exynos.c                      |   14=20
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c                     |    6=20
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c                     |    6=20
 drivers/pinctrl/samsung/pinctrl-samsung.c                     |   10=20
 drivers/rtc/interface.c                                       |   19=20
 drivers/s390/scsi/zfcp_dbf.c                                  |    8=20
 drivers/scsi/lpfc/lpfc_scsi.c                                 |   11=20
 drivers/scsi/lpfc/lpfc_sli.c                                  |    5=20
 drivers/scsi/lpfc/lpfc_sli.h                                  |    3=20
 drivers/scsi/qla2xxx/qla_attr.c                               |    3=20
 drivers/scsi/qla2xxx/qla_bsg.c                                |   15=20
 drivers/scsi/qla2xxx/qla_def.h                                |    9=20
 drivers/scsi/qla2xxx/qla_gs.c                                 |    9=20
 drivers/scsi/qla2xxx/qla_init.c                               |   94 +++-
 drivers/scsi/qla2xxx/qla_inline.h                             |   28 -
 drivers/scsi/qla2xxx/qla_iocb.c                               |    5=20
 drivers/scsi/qla2xxx/qla_isr.c                                |   11=20
 drivers/scsi/qla2xxx/qla_mbx.c                                |   20=20
 drivers/scsi/qla2xxx/qla_mid.c                                |   11=20
 drivers/scsi/qla2xxx/qla_nvme.c                               |    4=20
 drivers/scsi/qla2xxx/qla_nx.c                                 |    4=20
 drivers/scsi/qla2xxx/qla_os.c                                 |  144 +++--=
--
 drivers/scsi/qla2xxx/qla_sup.c                                |    8=20
 drivers/scsi/qla2xxx/qla_target.c                             |   24 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                            |    4=20
 drivers/staging/erofs/xattr.c                                 |    2=20
 drivers/staging/isdn/gigaset/usb-gigaset.c                    |   23 -
 drivers/staging/media/hantro/hantro_v4l2.c                    |   28 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                   |    2=20
 drivers/staging/rtl8712/usb_intf.c                            |    2=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    2=20
 drivers/usb/atm/ueagle-atm.c                                  |   18=20
 drivers/usb/core/hub.c                                        |    5=20
 drivers/usb/core/urb.c                                        |    1=20
 drivers/usb/dwc3/dwc3-pci.c                                   |    6=20
 drivers/usb/dwc3/ep0.c                                        |    8=20
 drivers/usb/dwc3/gadget.c                                     |    5=20
 drivers/usb/gadget/configfs.c                                 |    1=20
 drivers/usb/gadget/udc/pch_udc.c                              |    1=20
 drivers/usb/host/xhci-hub.c                                   |   22 -
 drivers/usb/host/xhci-mem.c                                   |    4=20
 drivers/usb/host/xhci-pci.c                                   |   13=20
 drivers/usb/host/xhci-ring.c                                  |    6=20
 drivers/usb/host/xhci-tegra.c                                 |   25 -
 drivers/usb/host/xhci.c                                       |    9=20
 drivers/usb/host/xhci.h                                       |    1=20
 drivers/usb/misc/adutux.c                                     |    2=20
 drivers/usb/misc/idmouse.c                                    |    2=20
 drivers/usb/mon/mon_bin.c                                     |   32 +
 drivers/usb/roles/class.c                                     |    2=20
 drivers/usb/serial/io_edgeport.c                              |   10=20
 drivers/usb/storage/uas.c                                     |   10=20
 drivers/usb/typec/class.c                                     |    6=20
 drivers/video/hdmi.c                                          |    8=20
 drivers/virtio/virtio_balloon.c                               |   11=20
 fs/btrfs/delayed-inode.c                                      |   13=20
 fs/btrfs/extent_io.c                                          |   12=20
 fs/btrfs/file.c                                               |    2=20
 fs/btrfs/free-space-cache.c                                   |    6=20
 fs/btrfs/inode.c                                              |    9=20
 fs/btrfs/send.c                                               |   25 +
 fs/btrfs/volumes.h                                            |    1=20
 fs/ext2/inode.c                                               |    7=20
 fs/ext4/inode.c                                               |   25 -
 fs/ext4/namei.c                                               |   11=20
 fs/ocfs2/quota_global.c                                       |    2=20
 fs/overlayfs/dir.c                                            |    2=20
 fs/overlayfs/inode.c                                          |    8=20
 fs/overlayfs/namei.c                                          |    8=20
 fs/overlayfs/ovl_entry.h                                      |    2=20
 fs/overlayfs/super.c                                          |   24 -
 fs/quota/dquot.c                                              |   11=20
 fs/reiserfs/inode.c                                           |   12=20
 fs/reiserfs/namei.c                                           |    7=20
 fs/reiserfs/reiserfs.h                                        |    2=20
 fs/reiserfs/super.c                                           |    2=20
 fs/reiserfs/xattr.c                                           |   19=20
 fs/reiserfs/xattr_acl.c                                       |    4=20
 fs/splice.c                                                   |   14=20
 include/acpi/acpi_bus.h                                       |    6=20
 include/linux/mfd/rk808.h                                     |    2=20
 include/linux/quotaops.h                                      |   10=20
 include/rdma/ib_verbs.h                                       |    4=20
 include/uapi/linux/cec.h                                      |    4=20
 kernel/cgroup/pids.c                                          |   11=20
 kernel/workqueue.c                                            |   38 +
 lib/raid6/unroll.awk                                          |    2=20
 mm/shmem.c                                                    |   13=20
 mm/slab_common.c                                              |   12=20
 net/sched/cls_api.c                                           |    8=20
 net/sunrpc/xdr.c                                              |   11=20
 sound/firewire/fireface/ff-pcm.c                              |    2=20
 sound/firewire/oxfw/oxfw-pcm.c                                |    2=20
 sound/soc/codecs/rt5645.c                                     |    6=20
 sound/soc/fsl/fsl_audmix.c                                    |    6=20
 sound/soc/fsl/fsl_audmix.h                                    |    1=20
 sound/soc/soc-jack.c                                          |    3=20
 tools/testing/selftests/seccomp/seccomp_bpf.c                 |    3=20
 189 files changed, 1650 insertions(+), 859 deletions(-)

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

Andre Przywara (1):
      arm64: dts: allwinner: a64: Re-add PMU node

Andrea Merello (2):
      iio: ad7949: kill pointless "readback"-handling code
      iio: ad7949: fix channels mixups

Andreas Gruenbacher (1):
      block: fix "check bi_size overflow before merge"

Andy Shevchenko (1):
      ACPI / utils: Move acpi_dev_get_first_match_dev() under CONFIG_ACPI

Arnd Bergmann (2):
      media: venus: remove invalid compat_ioctl32 handler
      ppdev: fix PPGETTIME/PPSETTIME ioctls

Arun Easi (2):
      scsi: qla2xxx: Fix memory leak when sending I/O fails
      scsi: qla2xxx: Fix NVMe port discovery after a short device port loss

Bart Van Assche (11):
      RDMA/core: Fix ib_dma_max_seg_size()
      scsi: qla2xxx: Make qla2x00_abort_srb() again decrease the sp referen=
ce count
      scsi: qla2xxx: Really fix qla2xxx_eh_abort()
      scsi: qla2xxx: Fix session lookup in qlt_abort_work()
      scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
      scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return =
value
      scsi: qla2xxx: Check secondary image if reading the primary image fai=
ls
      scsi: qla2xxx: Make sure that aborted commands are freed
      scsi: qla2xxx: Fix a dma_pool_free() call
      scsi: qla2xxx: Fix a race condition between aborting and completing a=
 SCSI command
      scsi: qla2xxx: Introduce the function qla2xxx_init_sp()

Beniamin Bia (1):
      iio: adc: ad7606: fix reading unnecessary data from device

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

Chuck Lever (1):
      SUNRPC: Fix another issue with MIC buffer space

C=C3=A9dric Le Goater (2):
      powerpc/xive: Prevent page fault issues in the machine crash handler
      powerpc/xive: Skip ioremap() of ESB pages for LSI interrupts

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

Eric Dumazet (1):
      net_sched: validate TCA_KIND attribute in tc_chain_tmplt_add()

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

Gao Xiang (1):
      erofs: zero out when listxattr is called with no xattr

Georgi Djakov (1):
      interconnect: qcom: sdm845: Walk the list safely on node removal

Gerald Schaefer (2):
      s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported
      s390/kaslr: store KASLR offset for early dumps

Greg Kroah-Hartman (2):
      lib: raid6: fix awk build warnings
      Linux 5.3.17

Gregory CLEMENT (1):
      pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type=
()

Guoqing Jiang (1):
      raid5: need to set STRIPE_HANDLE for batch head

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

Hans de Goede (3):
      ACPI: LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links
      ACPI: LPSS: Add LNXVIDEO -> BYT I2C1 to lpss_device_links
      ACPI: LPSS: Add dmi quirk for skipping _DEP check for some device-lin=
ks

Heikki Krogerus (1):
      usb: dwc3: pci: add ID for the Intel Comet Lake -H variant

Heiko Carstens (1):
      s390/smp,vdso: fix ASCE handling

Henry Lin (1):
      usb: xhci: only set D3hot for pci device

Himanshu Madhani (3):
      scsi: qla2xxx: Fix DMA unmap leak
      scsi: qla2xxx: Fix message indicating vectors used by driver
      scsi: qla2xxx: Fix driver reload for ISP82xx

Jacob Rasmussen (2):
      ASoC: rt5645: Fixed buddy jack support.
      ASoC: rt5645: Fixed typo for buddy jack support.

James Smart (1):
      scsi: lpfc: Fix bad ndlp ptr in xri aborted handling

Jan Kara (1):
      ext4: Fix credit estimate for final inode freeing

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

Josef Bacik (3):
      btrfs: check page->mapping when loading free space cache
      btrfs: use refcount_inc_not_zero in kill_all_nodes
      btrfs: record all roots for rename exchange on a subvol

Kai-Heng Feng (2):
      usb: Allow USB device to be warm reset in suspended state
      xhci: Increase STS_HALT timeout in xhci_suspend()

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

Leonard Crestez (1):
      PM / devfreq: Lock devfreq in trans_stat_show

Lorenzo Bianconi (2):
      iio: imu: st_lsm6dsx: move odr_table in st_lsm6dsx_sensor_settings
      iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw

Madhavan Srinivasan (1):
      powerpc/perf: Disable trace_imc pmu

Maged Mokhtar (1):
      dm writecache: handle REQ_FUA

Marcelo Diop-Gonzalez (1):
      staging: vchiq: call unregister_chrdev_region() when driver registrat=
ion fails

Martin K. Petersen (1):
      Revert "scsi: qla2xxx: Fix memory leak when sending I/O fails"

Martin Wilck (1):
      scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft

Mathias Nyman (3):
      xhci: fix USB3 device initiated resume race with roothub autosuspend
      xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behavi=
our.
      xhci: make sure interrupts are restored to correct state

Meng Li (1):
      EDAC/altera: Use fast register IO for S10 IRQs

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

Quinn Tran (11):
      scsi: qla2xxx: Fix driver unload hang
      scsi: qla2xxx: Fix abort timeout race condition.
      scsi: qla2xxx: Do command completion on abort timeout
      scsi: qla2xxx: Fix premature timer expiration
      scsi: qla2xxx: Fix different size DMA Alloc/Unmap
      scsi: qla2xxx: Fix hang in fcport delete path
      scsi: qla2xxx: Fix flash read for Qlogic ISPs
      scsi: qla2xxx: Fix stuck login session
      scsi: qla2xxx: Fix stale session
      scsi: qla2xxx: Fix SRB leak on switch command timeout
      scsi: qla2xxx: Fix double scsi_done for abort path

Rafael J. Wysocki (5):
      cpuidle: teo: Ignore disabled idle states that are too deep
      cpuidle: teo: Rename local variable in teo_select()
      cpuidle: teo: Consider hits and misses metrics of disabled states
      cpuidle: teo: Fix "early hits" handling for disabled idle states
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: disable PCIe interrupts before bus reset

Robert Richter (1):
      EDAC/ghes: Do not warn when incrementing refcount on 0

Roman Bolshakov (1):
      scsi: qla2xxx: Change discovery state before PLOGI

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


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl35OKwACgkQONu9yGCS
aT7DJQ/+PcatV3eW+buEQKWXrm2QsfxXKO04Hx/2X4o37HNiFVLGogZmYyMwU2zh
vv61js4J1RzEsuoiqLGAA7MGUE9f/9LiDzDJfwMyJQLmdKXGH3YyEF5WK5KgC1Yr
j0dAyjzl7afxLl8vkdbbapIvKdX3rr2qV4tCjLkknsJN+/0IipEKEuj/K2mjRbk1
2HRH4ciGHnZOoARLvLlHx8UgR76u5IKRmJ6cWxjmGUQGfH65i3LSENuwjaKIzRUK
GDTFewwJ7AWic3xZVvAFg75N8j8t5ZfZwFA5aIAwn4sseLyYu/86IbqMZFiET0da
bzEE3btAPPXIfc20uvkYQ1z0XHKOdpZQC/tnIHr16GGqPW8MIO8Rb2T881be8edM
Mkw9xHh4F8YugaGlfJ3pyy1/GQJPuHsVzG7NuAQnvP9otCogOqClC/1fxdr/swN1
n9AKFbSBrX9VMH0VAsG4F3zN4vyEF4ErU82D2nBtilRNfA2WJX3faUoIugwHGqAZ
bmItNI1aEY+gO95tleD7ELmvc0i2V6MG+PvnGD9g3zv2/cHtwdakvsTnrrVulY0x
devuC1+ayZ3cgkRpUIFruX3qbPKrS1Ke/9OwN0ZzfQCgpRTXRQPCPgLvFYJ0qAN3
eF/iDSGJHg4WRbbJcIAuy8DV9pBxg/Rn4usoWnC992sXN1TAzPk=
=S0gC
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
