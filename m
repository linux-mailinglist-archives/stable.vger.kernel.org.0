Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC71237B4
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfLQUlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbfLQUlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:41:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022492146E;
        Tue, 17 Dec 2019 20:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576615279;
        bh=vvi/Zqv6YR0MPPfwjzwtaYXhoZfVvE+jFxQKMnwOlvo=;
        h=Date:From:To:Cc:Subject:From;
        b=IHMt1PiUR+1HAUQEsL+t8MqeISWvPatJV7Lf38WxdklSM5NJDyQ6ATtQeTsViWsOI
         O7wEy2Ymp8NxjTy6EbQHgXuowf/n+r6QywGTIVsI9lb0bfWlK3cVUCbvCWnXmhsUqL
         0Iv8nJU1QygbWLAYQRFZa9AS121ONach6d6M0qeQ=
Date:   Tue, 17 Dec 2019 21:41:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.90
Message-ID: <20191217204117.GC4152841@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.90 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt       |   22 -
 Documentation/filesystems/proc.txt                    |    3=20
 Makefile                                              |    2=20
 arch/arm/boot/dts/omap3-pandora-common.dtsi           |   36 ++
 arch/arm/boot/dts/omap3-tao3530.dtsi                  |    2=20
 arch/arm/mach-omap2/pdata-quirks.c                    |   93 -----
 arch/powerpc/include/asm/vdso_datapage.h              |    2=20
 arch/powerpc/kernel/Makefile                          |    4=20
 arch/powerpc/kernel/asm-offsets.c                     |    2=20
 arch/powerpc/kernel/misc_64.S                         |    4=20
 arch/powerpc/kernel/time.c                            |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S             |    7=20
 arch/powerpc/kernel/vdso64/cacheflush.S               |    4=20
 arch/powerpc/kernel/vdso64/gettimeofday.S             |    7=20
 arch/powerpc/sysdev/xive/common.c                     |    9=20
 arch/powerpc/sysdev/xive/spapr.c                      |   12=20
 arch/powerpc/xmon/Makefile                            |    4=20
 arch/s390/include/asm/pgtable.h                       |    4=20
 arch/s390/kernel/smp.c                                |    5=20
 arch/x86/kernel/cpu/mcheck/mce.c                      |   30 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c                  |   36 ++
 block/blk-merge.c                                     |    2=20
 block/blk-mq-sysfs.c                                  |   15=20
 drivers/acpi/bus.c                                    |    2=20
 drivers/acpi/device_pm.c                              |   12=20
 drivers/acpi/osl.c                                    |   28 +
 drivers/block/drbd/drbd_state.c                       |    6=20
 drivers/block/drbd/drbd_state.h                       |    3=20
 drivers/char/hw_random/omap-rng.c                     |    9=20
 drivers/char/ppdev.c                                  |   16=20
 drivers/char/tpm/tpm2-cmd.c                           |    4=20
 drivers/cpufreq/powernv-cpufreq.c                     |   17 -
 drivers/cpuidle/driver.c                              |   15=20
 drivers/devfreq/devfreq.c                             |   12=20
 drivers/firmware/arm_scmi/bus.c                       |    8=20
 drivers/firmware/qcom_scm-64.c                        |    2=20
 drivers/gpio/gpiolib-acpi.c                           |   17 +
 drivers/hwtracing/intel_th/core.c                     |    8=20
 drivers/hwtracing/intel_th/pci.c                      |   10=20
 drivers/iio/humidity/hdc100x.c                        |    2=20
 drivers/iio/imu/adis16480.c                           |    1=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c            |   66 +++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h             |   16=20
 drivers/isdn/gigaset/usb-gigaset.c                    |   23 +
 drivers/leds/trigger/ledtrig-netdev.c                 |    5=20
 drivers/md/dm-writecache.c                            |    3=20
 drivers/md/dm-zoned-metadata.c                        |   29 +
 drivers/md/dm-zoned-reclaim.c                         |    8=20
 drivers/md/dm-zoned-target.c                          |   54 ++-
 drivers/md/dm-zoned.h                                 |    2=20
 drivers/md/md-linear.c                                |    5=20
 drivers/md/md-multipath.c                             |    5=20
 drivers/md/md.c                                       |   11=20
 drivers/md/md.h                                       |    4=20
 drivers/md/raid0.c                                    |    5=20
 drivers/md/raid1.c                                    |    5=20
 drivers/md/raid10.c                                   |    5=20
 drivers/md/raid5.c                                    |    6=20
 drivers/media/platform/qcom/venus/vdec.c              |    3=20
 drivers/media/platform/qcom/venus/venc.c              |    3=20
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c         |    3=20
 drivers/media/platform/vimc/vimc-core.c               |    7=20
 drivers/media/radio/radio-wl1273.c                    |    3=20
 drivers/mmc/host/omap_hsmmc.c                         |   30 +
 drivers/mtd/devices/spear_smi.c                       |   38 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.c           |   26 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h           |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       |    9=20
 drivers/net/ethernet/intel/e100.c                     |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c  |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |   73 ++++
 drivers/net/wireless/ath/ar5523/ar5523.c              |    3=20
 drivers/net/wireless/ath/ath10k/pci.c                 |    9=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c   |    9=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c   |    1=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c  |   25 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h  |    2=20
 drivers/of/overlay.c                                  |   37 +-
 drivers/of/unittest.c                                 |    4=20
 drivers/pci/controller/pcie-rcar.c                    |    6=20
 drivers/pci/hotplug/acpiphp_glue.c                    |   12=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c              |    5=20
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c           |    6=20
 drivers/pinctrl/samsung/pinctrl-exynos.c              |   14=20
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c             |    6=20
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c             |    6=20
 drivers/pinctrl/samsung/pinctrl-samsung.c             |   10=20
 drivers/power/supply/cpcap-battery.c                  |   11=20
 drivers/regulator/88pm800-regulator.c                 |  305 +++++++++++++=
+++++
 drivers/regulator/88pm800.c                           |  305 -------------=
-----
 drivers/regulator/Makefile                            |    2=20
 drivers/rtc/interface.c                               |   19 +
 drivers/s390/scsi/zfcp_dbf.c                          |    8=20
 drivers/scsi/hisi_sas/hisi_sas.h                      |    2=20
 drivers/scsi/hisi_sas/hisi_sas_main.c                 |   15=20
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                |    4=20
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c                |    4=20
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                |    4=20
 drivers/scsi/lpfc/lpfc.h                              |    3=20
 drivers/scsi/lpfc/lpfc_attr.c                         |   17 -
 drivers/scsi/lpfc/lpfc_init.c                         |    3=20
 drivers/scsi/lpfc/lpfc_mbox.c                         |    6=20
 drivers/scsi/lpfc/lpfc_nvme.c                         |    2=20
 drivers/scsi/lpfc/lpfc_sli.c                          |   14=20
 drivers/scsi/qla2xxx/qla_attr.c                       |    3=20
 drivers/scsi/qla2xxx/qla_bsg.c                        |   15=20
 drivers/scsi/qla2xxx/qla_gs.c                         |    2=20
 drivers/scsi/qla2xxx/qla_init.c                       |   17 -
 drivers/scsi/qla2xxx/qla_isr.c                        |    6=20
 drivers/scsi/qla2xxx/qla_mbx.c                        |    4=20
 drivers/scsi/qla2xxx/qla_mid.c                        |   11=20
 drivers/scsi/qla2xxx/qla_os.c                         |    7=20
 drivers/scsi/qla2xxx/qla_target.c                     |   11=20
 drivers/scsi/zorro_esp.c                              |   11=20
 drivers/staging/erofs/xattr.c                         |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c           |    2=20
 drivers/staging/rtl8712/usb_intf.c                    |    2=20
 drivers/usb/atm/ueagle-atm.c                          |   18 -
 drivers/usb/core/hub.c                                |    5=20
 drivers/usb/core/urb.c                                |    1=20
 drivers/usb/dwc3/dwc3-pci.c                           |    6=20
 drivers/usb/dwc3/ep0.c                                |    8=20
 drivers/usb/dwc3/gadget.c                             |    2=20
 drivers/usb/gadget/configfs.c                         |    1=20
 drivers/usb/gadget/udc/pch_udc.c                      |    1=20
 drivers/usb/host/xhci-hub.c                           |    8=20
 drivers/usb/host/xhci-mem.c                           |    4=20
 drivers/usb/host/xhci-pci.c                           |   13=20
 drivers/usb/host/xhci-ring.c                          |    3=20
 drivers/usb/host/xhci.c                               |    9=20
 drivers/usb/host/xhci.h                               |    1=20
 drivers/usb/misc/adutux.c                             |    2=20
 drivers/usb/misc/idmouse.c                            |    2=20
 drivers/usb/mon/mon_bin.c                             |   32 +
 drivers/usb/roles/class.c                             |    2=20
 drivers/usb/serial/io_edgeport.c                      |   10=20
 drivers/usb/storage/uas.c                             |   10=20
 drivers/usb/typec/class.c                             |    6=20
 drivers/video/hdmi.c                                  |    8=20
 drivers/virtio/virtio_balloon.c                       |   11=20
 drivers/xen/pvcalls-front.c                           |    4=20
 fs/btrfs/delayed-inode.c                              |   13=20
 fs/btrfs/extent_io.c                                  |   12=20
 fs/btrfs/file.c                                       |    2=20
 fs/btrfs/free-space-cache.c                           |    6=20
 fs/btrfs/inode.c                                      |    9=20
 fs/btrfs/send.c                                       |   25 +
 fs/btrfs/volumes.h                                    |    1=20
 fs/cifs/smb2pdu.c                                     |   41 +-
 fs/ext2/inode.c                                       |    7=20
 fs/ext4/inode.c                                       |   25 +
 fs/ext4/namei.c                                       |   11=20
 fs/gfs2/log.c                                         |    8=20
 fs/gfs2/log.h                                         |    1=20
 fs/gfs2/lops.c                                        |    5=20
 fs/gfs2/trans.c                                       |    2=20
 fs/ocfs2/quota_global.c                               |    2=20
 fs/overlayfs/dir.c                                    |    2=20
 fs/overlayfs/inode.c                                  |    8=20
 fs/proc/task_mmu.c                                    |    2=20
 fs/quota/dquot.c                                      |   11=20
 fs/reiserfs/inode.c                                   |   12=20
 fs/reiserfs/namei.c                                   |    7=20
 fs/reiserfs/reiserfs.h                                |    2=20
 fs/reiserfs/super.c                                   |    2=20
 fs/reiserfs/xattr.c                                   |   19 -
 fs/reiserfs/xattr_acl.c                               |    4=20
 fs/splice.c                                           |   14=20
 include/linux/huge_mm.h                               |   13=20
 include/linux/mfd/rk808.h                             |    2=20
 include/linux/quotaops.h                              |   10=20
 include/uapi/linux/cec.h                              |    4=20
 kernel/cgroup/pids.c                                  |   11=20
 kernel/module.c                                       |    2=20
 kernel/workqueue.c                                    |   38 +-
 lib/idr.c                                             |   31 -
 lib/raid6/unroll.awk                                  |    2=20
 mm/huge_memory.c                                      |   12=20
 mm/memory.c                                           |    4=20
 mm/shmem.c                                            |    2=20
 net/ipv4/gre_demux.c                                  |    2=20
 net/sched/sch_cake.c                                  |    5=20
 net/smc/smc_tx.c                                      |   10=20
 net/sunrpc/cache.c                                    |    6=20
 sound/soc/codecs/rt5645.c                             |    6=20
 sound/soc/soc-jack.c                                  |    3=20
 tools/perf/util/machine.c                             |    2=20
 187 files changed, 1550 insertions(+), 940 deletions(-)

Adrian Hunter (1):
      perf callchain: Fix segfault in thread__resolve_callchain_sample()

Alastair D'Silva (2):
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges=
 >4GB
      powerpc: Allow flush_icache_range to work across ranges >4GB

Aleksa Sarai (1):
      cgroup: pids: use atomic64_t for pids->limit

Alexander Shishkin (3):
      intel_th: Fix a double put_device() in error path
      intel_th: pci: Add Ice Lake CPU support
      intel_th: pci: Add Tiger Lake CPU support

Alexandre Belloni (1):
      rtc: disable uie before setting time and enable after

Amir Goldstein (2):
      ovl: fix corner case of non-unique st_dev;st_ino
      ovl: relax WARN_ON() on rename to self

Anders Roxell (1):
      regulator: 88pm800: fix warning same module names

Arnd Bergmann (2):
      media: venus: remove invalid compat_ioctl32 handler
      ppdev: fix PPGETTIME/PPSETTIME ioctls

Bart Van Assche (3):
      scsi: qla2xxx: Fix session lookup in qlt_abort_work()
      scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
      scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return =
value

Bob Peterson (1):
      gfs2: fix glock reference problem in gfs2_trans_remove_revoke

Chen Jun (1):
      mm/shmem.c: cast the type of unmap_start to u64

Chengguang Xu (1):
      ext2: check err when partial !=3D NULL

Chris Lesiak (1):
      iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Cong Wang (1):
      gre: refetch erspan header from skb->data after pskb_may_pull()

C=E9dric Le Goater (2):
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

Denis Efremov (1):
      ar5523: check NULL before memcpy() in ar5523_cmd()

Dmitry Fomichev (1):
      dm zoned: reduce overhead of backing device checks

Dmitry Monakhov (2):
      quota: Check that quota is not dirty before release
      quota: fix livelock in dquot_writeback_dquots

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function

Eran Ben Elisha (1):
      net/mlx5e: Fix SFF 8472 eeprom length

Erhard Furtner (1):
      of: unittest: fix memory leak in attach_node_and_children

Filipe Manana (3):
      Btrfs: fix metadata space leak on fixup worker failure to set range a=
s delalloc
      Btrfs: fix negative subv_writers counter and data space leak after bu=
ffered write
      Btrfs: send, skip backreference walking for extents with many referen=
ces

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c

Frank Rowand (1):
      of: overlay: add_changeset_property() memory leak

Gao Xiang (1):
      erofs: zero out when listxattr is called with no xattr

Gerald Schaefer (1):
      s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported

Greg Kroah-Hartman (2):
      lib: raid6: fix awk build warnings
      Linux 4.19.90

Gregory CLEMENT (1):
      pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type=
()

Guoqing Jiang (1):
      raid5: need to set STRIPE_HANDLE for batch head

Gustavo A. R. Silva (1):
      usb: gadget: pch_udc: fix use after free

H. Nikolaus Schaller (3):
      ARM: dts: pandora-common: define wl1251 as child node of mmc3
      mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid=
 of pandora_wl1251_init_card
      omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Hans Verkuil (1):
      media: cec.h: CEC_OP_REC_FLAG_ values were swapped

Hans de Goede (1):
      gpiolib: acpi: Add Terra Pad 1061 to the run_edge_events_on_boot_blac=
klist

Heikki Krogerus (1):
      usb: dwc3: pci: add ID for the Intel Comet Lake -H variant

Heiko Carstens (1):
      s390/smp,vdso: fix ASCE handling

Helen Koike (1):
      media: vimc: fix component match compare

Henry Lin (1):
      usb: xhci: only set D3hot for pci device

Himanshu Madhani (2):
      scsi: qla2xxx: Fix DMA unmap leak
      scsi: qla2xxx: Fix message indicating vectors used by driver

Huazhong Tan (1):
      net: hns3: change hnae3_register_ae_dev() to int

Ido Schimmel (1):
      mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead

Jacob Rasmussen (2):
      ASoC: rt5645: Fixed buddy jack support.
      ASoC: rt5645: Fixed typo for buddy jack support.

James Smart (3):
      scsi: lpfc: Cap NPIV vports to 256
      scsi: lpfc: Correct code setting non existent bits in sli4 ABORT WQE
      scsi: lpfc: Correct topology type reporting on G7 adapters

Jan Kara (1):
      ext4: Fix credit estimate for final inode freeing

Jarkko Nikula (1):
      ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polari=
ty

Jean-Baptiste Maneyrol (2):
      iio: imu: inv_mpu6050: fix temperature reporting using bad unit
      iio: imu: mpu6050: add missing available scan masks

Jeff Mahoney (1):
      reiserfs: fix extended attributes on the root directory

Jian Shen (1):
      net: hns3: clear pci private data when unload hns3 driver

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

John Hubbard (1):
      cpufreq: powernv: fix stack bloat and hard limit on number of CPUs

Josef Bacik (3):
      btrfs: check page->mapping when loading free space cache
      btrfs: use refcount_inc_not_zero in kill_all_nodes
      btrfs: record all roots for rename exchange on a subvol

Kai-Heng Feng (2):
      usb: Allow USB device to be warm reset in suspended state
      xhci: Increase STS_HALT timeout in xhci_suspend()

Kars de Jong (1):
      scsi: zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastla=
ne)

Karsten Graul (1):
      net/smc: do not wait under send_lock

Konstantin Khorenko (1):
      kernel/module.c: wakeup processes in module_wq on module unload

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

Luo Jiaxing (1):
      scsi: hisi_sas: Reject setting programmed minimum linkrate > 1.5G

Maged Mokhtar (1):
      dm writecache: handle REQ_FUA

Martin Schiller (1):
      leds: trigger: netdev: fix handling on interface rename

Mathias Nyman (2):
      xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behavi=
our.
      xhci: make sure interrupts are restored to correct state

Matthew Wilcox (Oracle) (1):
      idr: Fix idr_get_next_ul race with idr_remove

Miaoqing Pan (1):
      ath10k: fix fw crash by moving chip reset after napi disabled

Michal Hocko (1):
      mm, thp, proc: report THP eligibility for each vma

Mika Westerberg (2):
      xhci: Fix memory leak in xhci_add_in_port()
      ACPI / hotplug / PCI: Allocate resources directly under the non-hotpl=
ug bridge

Ming Lei (3):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
      block: fix single range discard merge
      blk-mq: make sure that line break can be printed

Miquel Raynal (1):
      mtd: spear_smi: Fix Write Burst mode

Nathan Chancellor (2):
      drbd: Change drbd_request_detach_interruptible's return type to int
      powerpc: Avoid clang warnings around setjmp and longjmp

Nishka Dasgupta (1):
      pinctrl: samsung: Add of_node_put() before return in error path

Nuno S=E1 (1):
      iio: adis16480: Add debugfs_reg_access entry

Oliver Neukum (3):
      USB: uas: honor flag to avoid CAPACITY16
      USB: uas: heed CAPACITY_HEURISTICS
      USB: documentation: flags on usb-storage versus UAS

Paulo Alcantara (SUSE) (1):
      cifs: Fix potential softlockups while refreshing DFS cache

Pavel Tikhomirov (1):
      sunrpc: fix crash when cache_head become valid before update

Pawel Harlozinski (1):
      ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read

Qu Wenruo (1):
      btrfs: Remove btrfs_bio::flags member

Quinn Tran (3):
      scsi: qla2xxx: Fix driver unload hang
      scsi: qla2xxx: Fix hang in fcport delete path
      scsi: qla2xxx: Fix SRB leak on switch command timeout

Rafael J. Wysocki (1):
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Roman Bolshakov (1):
      scsi: qla2xxx: Change discovery state before PLOGI

Shirish S (2):
      x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models
      x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Stefano Stabellini (1):
      pvcalls-front: don't return error when the ring is full

Steffen Maier (1):
      scsi: zfcp: trace channel log even for FCP command responses

Sumit Garg (1):
      hwrng: omap - Fix RNG wait loop timeout

Tadeusz Struk (1):
      tpm: add check after commands attribs tab allocation

Tejas Joglekar (1):
      usb: dwc3: gadget: Fix logical condition

Tejun Heo (4):
      btrfs: Avoid getting stuck during cyclic writebacks
      workqueue: Fix spurious sanity check failures in destroy_workqueue()
      workqueue: Fix pwq ref leak in rescuer_thread()
      workqueue: Fix missing kfree(rescuer) in destroy_workqueue()

Theodore Ts'o (1):
      ext4: work around deleting a file with i_nlink =3D=3D 0 safely

Thinh Nguyen (1):
      usb: dwc3: ep0: Clear started flag on completion

Toke H=F8iland-J=F8rgensen (1):
      sch_cake: Correctly update parent qlen when splitting GSO packets

Tony Lindgren (1):
      power: supply: cpcap-battery: Fix signed counter sample register

Vamshi K Sthambamkadi (1):
      ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Ville Syrj=E4l=E4 (1):
      video/hdmi: Fix AVI bar unpack

Vincenzo Frascino (1):
      powerpc: Fix vDSO clock_getres()

Wei Yongjun (1):
      usb: gadget: configfs: Fix missing spin_lock_init()

Wen Yang (3):
      usb: roles: fix a potential use after free
      usb: typec: fix use after free in typec_register_port()
      firmware: arm_scmi: Avoid double free in error flow

Will Deacon (1):
      firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Xiang Chen (1):
      scsi: hisi_sas: send primitive NOTIFY to SSP situation only

Yonglong Liu (1):
      net: hns3: Check variable is valid before assigning it to another

Yoshihiro Shimoda (2):
      phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"
      PCI: rcar: Fix missing MACCTLR register setting in initialization seq=
uence

YueHaibing (1):
      e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already

yangerkun (1):
      ext4: fix a bug in ext4_wait_for_tail_page_commit


--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl35PW0ACgkQONu9yGCS
aT5ETBAAh0kwuKQKi9fLULlx/gZzou7Iwb0FQRVr7L31MJG67ZVS5qDogDYf4RlL
dVw5yt8WNf6UWTIJ+SGRSH/2CdP4Dc/gwdQthoWihet2XO3olo32e7HOXWJt7ICB
MKgR4NX0rqCpVkdJVh33bqgbdevvoMhce/EoXPs/JmsSSWqXW5URmiidvol1I2ab
KAPjyivW0UOtEMZ83Pk6SqnZ7DuxaAmc8UMyUXP1f+L0k0a1M4OSo0lxcDMLaPez
bkqk2gfn/hADQJ8G6AcpuA0df8oCkEXkIXrWwuai9hg8Ro1NcwsSOC6NDHnbd842
7odxdpuKM9h3TNnm1okkvEfw65DcKa0APOCmXjk2G6mKc3C2g+tk6GfdWukf75rn
sCDYYjJoJvHw1cfoETK7jTQD6XROfkt3JZjAo3iIyZdaffi9pQ7HBi1wKNCP4B/O
+QoU59R3vBF+QGpTMWLYPinL1VakgQWI8+W5Q1mKX2V1E1vD6AipjdNaxpCkwbu2
vhVg8CGmCRAIMO0sXnSio/PXfyaCqbA7vL1fFL7Syvcfni5pWUCvZ0q+/cVSBtv3
2MSlTg2HhmIGql+DMsHysy+dl7M8wiDXKrBT9QWF+Siv32DHQekx86hqrd6SgYve
yZhJ7hvR2ryT9goBCJpTFY0L4hnYszpxjzGQ4WoCL8QnqukLmek=
=tgRP
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
