Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0EB12376E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLQUj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfLQUj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:39:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86ED2053B;
        Tue, 17 Dec 2019 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576615196;
        bh=qBKX0j99CnS+OiB6Jyv+KPHtdDSzO7QNGkrz93+xLFE=;
        h=Date:From:To:Cc:Subject:From;
        b=wCGUcCT4IE0IuttUris7++U3D46Y1boXJ9FXBIwPO7CthnLW69SJh6QKbQHjOxQXl
         xKWjsJAgQTfPEJoKZfNSSlTnyiPrweYacVnxbHBCtgvoBfturKrV4P9cGtJvNCz9hz
         GFpAFcJ0NhdNpClGcMW4cn5m3sfvlrd73gqeR4VI=
Date:   Tue, 17 Dec 2019 21:39:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.90
Message-ID: <20191217203954.GA4152841@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
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

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl35PRcACgkQONu9yGCS
aT6mlRAA1RJc+wWSkPdjjjLVKudz0Mzpolhq+unZKHxeHoLU5dm1hgvzoOO9mcwN
e11LZ8BdkYyl2WV35MTpQ/JGcqQAn7rOdV7Ym3WQogk70rmF9Ui4ePs3brvFWHzd
BrJ9uxkRe+g8hwJdjaODUtZGoir3B4vw/ha/3sz0345ik4EHiDSArac634q2ZI5Y
mU2sv2TaZ7FJ4F0jF+ZUQnL+1uam3omOlyGmXDEG7Fg0Zp7ssmI6dauEfO7KEMkM
tMJ4jCudsjAcZrF0wNxY8m2Lf2xx39HoMhOZJokCYZ+OZYotZc6grnzPmqpi9dEq
KDe0EdynMpvU/ygu+k7MqqZgR/8yxf58b+JQpy3moJmStbdgTiC+Yrg0XdCdEeHz
KMr+YCVWdDLQMQO+WfksxodnxDPcoUJBFKcLlxgIZwbGpF7vXiTVZVL4egZApmqW
eHcLpmbqSXuq1PP1kP5r7sb1zMkK1SX7mOk66QcMjTshqfKmF9W2Iv2EiWx3ySXH
n3Jh5CzWgt0rfPr9SZMQ4Si7yCil5m/dbDemodgU29GdDNgl7wI/zJ3enjZHPnD+
99GgZgijztY/GGYTW2/vNCPsMmrsxl+JLPiQ1KgbzDErVCSFMAoS57CwVNSmVkNU
93/EOqv7gls9Q7RSigT2hkjfytFahK7aHK/qbRdqJfC6QJil+3Q=
=Um1V
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
