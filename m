Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E281463C7
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAWIpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWIpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 03:45:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C75207FF;
        Thu, 23 Jan 2020 08:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579769151;
        bh=a4RU366gB9eIB33vgmO5nc9ZTbgRXDB6OPASmENM7hw=;
        h=Date:From:To:Cc:Subject:From;
        b=EpFxoaaHlLliMV126l8ZUcC/lAB9sldfrOTsOCvtmXIcn5jbF6FmRPUl2YvK7XAjw
         VOERUby9WcRQ7ElzH7YmLGjZ23f1oPm3/YgRHrPqi9XnuUMmL5w7Fb6G9T/+rVZ0lA
         EG6x57UOI/bGyWCJCzb8ir3gyOdwrC8ama3WVNHc=
Date:   Thu, 23 Jan 2020 09:45:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.211
Message-ID: <20200123084548.GA435203@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.211 kernel.

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

 Documentation/ABI/testing/sysfs-bus-mei            |    2=20
 Makefile                                           |    2=20
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |    8=20
 arch/arm64/include/asm/kvm_mmu.h                   |    5=20
 arch/arm64/include/asm/pgtable.h                   |    1=20
 arch/arm64/kernel/hibernate.c                      |    3=20
 arch/arm64/mm/mmu.c                                |  102 ++++++----
 arch/hexagon/include/asm/atomic.h                  |    8=20
 arch/hexagon/include/asm/bitops.h                  |    8=20
 arch/hexagon/include/asm/cmpxchg.h                 |    2=20
 arch/hexagon/include/asm/futex.h                   |    6=20
 arch/hexagon/include/asm/spinlock.h                |   20 -
 arch/hexagon/kernel/stacktrace.c                   |    4=20
 arch/hexagon/kernel/vm_entry.S                     |    2=20
 arch/mips/boot/compressed/Makefile                 |    3=20
 arch/powerpc/platforms/powernv/pci.c               |   17 +
 arch/x86/boot/compressed/head_64.S                 |    5=20
 block/blk-settings.c                               |    2=20
 drivers/block/xen-blkfront.c                       |    4=20
 drivers/clk/clk.c                                  |   10=20
 drivers/clk/samsung/clk-exynos5420.c               |    2=20
 drivers/dma/ioat/dma.c                             |    3=20
 drivers/gpio/gpio-mpc8xxx.c                        |    1=20
 drivers/gpio/gpiolib.c                             |    5=20
 drivers/hid/hidraw.c                               |    7=20
 drivers/hid/uhid.c                                 |    5=20
 drivers/iio/imu/adis16480.c                        |    6=20
 drivers/iio/industrialio-buffer.c                  |    6=20
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   24 ++
 drivers/iommu/iommu.c                              |    1=20
 drivers/md/dm-snap-persistent.c                    |    2=20
 drivers/md/raid0.c                                 |    2=20
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2=20
 drivers/media/usb/zr364xx/zr364xx.c                |    3=20
 drivers/message/fusion/mptctl.c                    |  213 ++++------------=
-----
 drivers/misc/enclosure.c                           |    3=20
 drivers/mtd/spi-nor/spi-nor.c                      |    2=20
 drivers/net/ethernet/stmicro/stmmac/common.h       |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    4=20
 drivers/net/macvlan.c                              |    5=20
 drivers/net/usb/lan78xx.c                          |    1=20
 drivers/net/usb/r8152.c                            |    3=20
 drivers/net/wan/fsl_ucc_hdlc.c                     |    2=20
 drivers/net/wimax/i2400m/op-rfkill.c               |    1=20
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    2=20
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    1=20
 drivers/net/wireless/st/cw1200/fwio.c              |    6=20
 drivers/pci/pcie/ptm.c                             |    2=20
 drivers/platform/x86/asus-wmi.c                    |    8=20
 drivers/rtc/rtc-msm6242.c                          |    3=20
 drivers/rtc/rtc-mt6397.c                           |   47 +++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2=20
 drivers/scsi/cxgbi/libcxgbi.c                      |    3=20
 drivers/scsi/esas2r/esas2r_flash.c                 |    1=20
 drivers/scsi/fnic/vnic_dev.c                       |   30 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    3=20
 drivers/scsi/scsi_trace.c                          |  113 +++--------
 drivers/scsi/sd.c                                  |    4=20
 drivers/spi/spi-atmel.c                            |   10=20
 drivers/target/target_core_fabric_lib.c            |    2=20
 drivers/tty/serial/imx.c                           |    2=20
 drivers/tty/serial/pch_uart.c                      |    5=20
 drivers/usb/core/hub.c                             |    1=20
 drivers/usb/serial/ch341.c                         |    6=20
 drivers/usb/serial/io_edgeport.c                   |   33 +--
 drivers/usb/serial/keyspan.c                       |    4=20
 drivers/usb/serial/opticon.c                       |    2=20
 drivers/usb/serial/quatech2.c                      |    6=20
 drivers/usb/serial/usb-serial-simple.c             |    2=20
 drivers/usb/serial/usb-serial.c                    |    3=20
 firmware/Makefile                                  |    2=20
 fs/cifs/smb2file.c                                 |    2=20
 fs/ext4/inode.c                                    |   15 +
 fs/ext4/super.c                                    |   60 +++--
 fs/f2fs/data.c                                     |    2=20
 fs/f2fs/file.c                                     |    2=20
 fs/ocfs2/journal.c                                 |    8=20
 fs/reiserfs/xattr.c                                |    8=20
 include/dt-bindings/reset/amlogic,meson8b-reset.h  |    6=20
 include/linux/blkdev.h                             |    8=20
 include/linux/poll.h                               |    4=20
 include/linux/regulator/ab8500.h                   |    2=20
 include/net/cfg80211.h                             |   11 +
 mm/page-writeback.c                                |    4=20
 net/batman-adv/distributed-arp-table.c             |    4=20
 net/core/ethtool.c                                 |   16 -
 net/dccp/feat.c                                    |    7=20
 net/dsa/tag_qca.c                                  |    3=20
 net/hsr/hsr_device.c                               |    2=20
 net/ipv4/netfilter/arp_tables.c                    |   19 -
 net/ipv4/tcp_input.c                               |    7=20
 net/mac80211/cfg.c                                 |   55 -----
 net/mac80211/sta_info.c                            |    4=20
 net/netfilter/ipset/ip_set_bitmap_gen.h            |    2=20
 net/socket.c                                       |    1=20
 net/wireless/rdev-ops.h                            |    4=20
 net/wireless/util.c                                |   47 ++++
 sound/core/seq/seq_timer.c                         |   14 -
 tools/perf/builtin-report.c                        |    5=20
 tools/perf/util/hist.h                             |    4=20
 tools/perf/util/probe-finder.c                     |   32 ---
 tools/testing/selftests/rseq/settings              |    1=20
 102 files changed, 619 insertions(+), 564 deletions(-)

Alexander Lobakin (1):
      net: dsa: tag_qca: fix doubled Tx statistics

Alexander Usyskin (1):
      mei: fix modalias documentation

Alexander.Barabash@dell.com (1):
      ioat: ioat_alloc_ring() failure handling.

Alexandru Ardelean (1):
      iio: imu: adis16480: assign bias value only if operation succeeded

Andy Shevchenko (1):
      scsi: fnic: use kernel's '%pM' format option to print MAC

Ard Biesheuvel (2):
      arm64: mm: BUG on unsupported manipulations of live kernel mappings
      x86/efistub: Disable paging at mixed mode entry

Arnd Bergmann (4):
      ethtool: reduce stack usage with clang
      fs/select: avoid clang stack usage warning
      compat_ioctl: handle SIOCOUTQNSD
      scsi: fnic: fix invalid stack access

Barret Rhoden (1):
      ext4: fix use-after-free race with debug_want_extra_isize

Bart Van Assche (3):
      RDMA/srpt: Report the SCSI residual to the initiator
      scsi: target: core: Fix a pr_debug() argument
      scsi: core: scsi_trace: Use get_unaligned_be*()

Ben Hutchings (1):
      arm64: mm: Change page table pointer name in p[md]_set_huge()

Bjorn Helgaas (1):
      PCI/PTM: Remove spurious "d" from granularity message

Chao Yu (1):
      f2fs: fix potential overflow

Colin Ian King (1):
      net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Cong Wang (1):
      netfilter: fix a use-after-free in mtype_destroy()

Dan Carpenter (3):
      scsi: mptfusion: Fix double fetch bug in ioctl
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Dedy Lansky (1):
      cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Dinh Nguyen (1):
      arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Eric Dumazet (2):
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
      net: usb: lan78xx: limit size of local TSO packets

Fabian Henneke (1):
      hidraw: Return EPOLLOUT from hidraw_poll

Felix Fietkau (1):
      cfg80211: fix page refcount issue in A-MSDU decap

Florian Westphal (1):
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Geert Uytterhoeven (1):
      gpio: Fix error message on out-of-range GPIO in lookup table

Greg Kroah-Hartman (1):
      Linux 4.9.211

Guenter Roeck (1):
      clk: Don't try to enable critical clocks if prepare failed

James Bottomley (1):
      scsi: enclosure: Fix stale device oops with hot replug

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment

Jeff Mahoney (1):
      reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr

Jer=C3=B3nimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Jian-Hong Pan (1):
      platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Jin Yao (1):
      perf report: Fix incorrectly added dimensions as switch perf data file

Jiri Kosina (1):
      HID: hidraw, uhid: Always report EPOLLOUT

Johan Hovold (8):
      USB: serial: opticon: fix control-message timeouts
      USB: serial: suppress driver bind attributes
      USB: serial: ch341: handle unbound port at reset_resume
      USB: serial: io_edgeport: add missing active-port sanity check
      USB: serial: quatech2: handle unbound ports
      USB: serial: io_edgeport: handle unbound ports on URB completion
      USB: serial: keyspan: handle unbound ports
      r8152: add missing endpoint sanity check

Johannes Berg (1):
      cfg80211: check for set_wiphy_params

John Ogness (1):
      USB: serial: io_edgeport: use irqsave() in USB's complete callback

Johnson CH Chen (=E9=99=B3=E6=98=AD=E5=8B=B3) (1):
      gpio: mpc8xxx: Add platform device to gpiochip->parent

Jon Derrick (1):
      iommu: Remove device link to group on failure

Jose Abreu (2):
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size

Jouni Hogander (1):
      MIPS: Prevent link failure with kcov instrumentation

Jouni Malinen (1):
      mac80211: Do not send Layer 2 Update frame before authorization

Kai Li (1):
      ocfs2: call journal flush to mark journal as empty after journal reco=
very when mount

Kars de Jong (1):
      rtc: msm6242: Fix reading of 10-hour digit

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup

Kristina Martsenko (1):
      arm64: don't open code page table entry creation

Lars M=C3=B6llendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest elem=
ent

Laura Abbott (1):
      arm64: Make sure permission updates happen for pmd/pud

Mans Rullgard (1):
      spi: atmel: fix handling of cs_change set on non-last xfer

Marcel Holtmann (1):
      HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Marian Mihailescu (1):
      clk: samsung: exynos5420: Preserve CPU clocks configuration during su=
spend/resume

Martin Blumenstingl (1):
      dt-bindings: reset: meson8b: fix duplicate reset IDs

Masami Hiramatsu (1):
      perf probe: Fix wrong address verification

Mathieu Desnoyers (1):
      rseq/selftests: Turn off timeout setting

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size

Nathan Chancellor (3):
      cifs: Adjust indentation in smb2_open_file
      rtlwifi: Remove unnecessary NULL check in rtl_regd_init
      xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Navid Emamdoost (2):
      wimax: i2400: fix memory leak
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Nick Desaulniers (2):
      hexagon: parenthesize registers in asm predicates
      hexagon: work around compiler crash

Oliver O'Halloran (1):
      powerpc/powernv: Disable native PCIe port management

Pan Bian (2):
      scsi: qla4xxx: fix double free bug
      scsi: bnx2i: fix potential use after free

Peng Fan (2):
      tty: serial: imx: use the sg count from dma_map_sg
      tty: serial: pch_uart: correct usage of dma_unmap_sg

Pengcheng Yang (1):
      tcp: fix marked lost packets not being retransmitted

Ran Bi (1):
      rtc: mt6397: fix alarm register overwrite

Sanjay Konduri (1):
      rsi: add fix for crash during assertions

Sergei Shtylyov (1):
      mtd: spi-nor: fix silent truncation in spi_nor_read()

Seung-Woo Kim (1):
      media: exynos4-is: Fix recursive locking in isp_video_release()

Stephan Gerhold (1):
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Taehee Yoo (1):
      hsr: reset network header when supervision frame is created

Takashi Iwai (1):
      ALSA: seq: Fix racy access for queue timer in proc read

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Vandana BN (1):
      media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_qu=
erycap

Varun Prakash (1):
      scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Wen Yang (1):
      mm/page-writeback.c: avoid potential division by zero in wb_min_max_r=
atio()

Will Deacon (1):
      arm64: Enforce BBM for huge IO/VMAP mappings

Xiang Chen (1):
      scsi: sd: Clear sdkp->protection_type if disk is reformatted without =
PI

YueHaibing (1):
      dccp: Fix memleak in __feat_register_sp

Yuya Fujita (1):
      perf hists: Fix variable name's inconsistency in hists__for_each() ma=
cro


--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4pXToACgkQONu9yGCS
aT5NFg//UFcV5s16Q2FuAA+DzrPCnzcp90+cSr3FyHHRB+L1wDiu28H2X3ZxHN8P
q/x0Nc76WvcwfRTORrRyKZOI2Ot+oxFnsyh40FG9NcO6sRZbS6STZIhQr1NVLAlU
2jky8FIgaIE0k+/ObhtiZP4kmp/FONEbdNESAGPUbWln9qe6MtF1mMUfjx6DHhVB
dfcf+pbxPGhVxnDnQxwnw/ZeI67Swg5rNl3ZrzzfzEKboOeVQm4v+/VUxR1V7ffF
JgRhqQ3Nuu2QABVJSKske/SCK7YbGgyI9BXsb5oKpg0RZpTbKQJBaEOXft6c5M+n
rshLzIO4cfZ8tq4g0Ty43ewp398KNWx0HXLscUs5d5GSohh5gSpi6QH6KISz3ro0
hNdVTjPUxFLeD+gAWJG9vrzuRJ+E39F5hzWo/9gb1aCYxEUmcSBwmpCtGWglb8Pj
EkjQr6xddXRZb8qaDkHx3ASVrMI0YwwMcmWdgdYTalOViqvUaH++KS0yCmkn9lLE
S3JgmDO3/UwpzY9OQJA6VLzHfH96xbSLm5wx3FWr0Gi8I7mak9ft162nbu2FfHMY
VCLPsZBdNtzZZ4fWLEey5Z8i6FrkTCSO3Yeu+y+H6dnIOUpxnoHRSDnO2OrxuEhk
T8l/GxC/tI6kyxsG3sf98IfdlJmmoSbHQd1y5dUHkWmUcMHKAj8=
=aQ5s
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
