Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01866183C21
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCLWNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgCLWNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:13:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72928206CD;
        Thu, 12 Mar 2020 22:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584051223;
        bh=qSZcLjDS0/ZoFuHTN5mCe9pjG0D2y1tHjxMq1BZrFF8=;
        h=Date:From:To:Cc:Subject:From;
        b=HiBSR8FN8Y/KHQLeRXKA5R8VaiIxK5wVk3QAU1+Zp3gvKHHd+biNMsWZmhXBM4uNh
         iqcKfcpffKt9pGxc7YEA+YzqAMExEp9aTccMIxcbXf6tfARb9iFNs55Dh4g7YmAsS9
         JJIqSesTV/9S9XOiO9uexZz5kQ1sgUqALFjGhQuM=
Date:   Thu, 12 Mar 2020 23:13:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.216
Message-ID: <20200312221341.GA616537@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.216 kernel.

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

 Makefile                                         |    2=20
 arch/arm/boot/dts/ls1021a.dtsi                   |    4=20
 arch/arm/mach-imx/Makefile                       |    2=20
 arch/arm/mach-imx/common.h                       |    4=20
 arch/arm/mach-imx/resume-imx6.S                  |   24 +++++
 arch/arm/mach-imx/suspend-imx6.S                 |   14 ---
 arch/mips/kernel/vpe.c                           |    2=20
 arch/powerpc/kernel/cputable.c                   |    4=20
 arch/x86/kernel/cpu/common.c                     |    2=20
 crypto/algif_skcipher.c                          |    2=20
 drivers/acpi/acpi_watchdog.c                     |    3=20
 drivers/char/ipmi/ipmi_ssif.c                    |   10 +-
 drivers/dma/coh901318.c                          |    4=20
 drivers/dma/tegra20-apb-dma.c                    |    6 -
 drivers/gpu/drm/msm/dsi/dsi_manager.c            |    7 +
 drivers/gpu/drm/msm/msm_drv.c                    |    8 +
 drivers/hid/hid-core.c                           |    4=20
 drivers/hid/usbhid/hiddev.c                      |    2=20
 drivers/hwmon/adt7462.c                          |    2=20
 drivers/i2c/busses/i2c-jz4780.c                  |   36 --------
 drivers/infiniband/core/cm.c                     |    1=20
 drivers/infiniband/core/iwcm.c                   |    4=20
 drivers/md/dm-cache-target.c                     |    4=20
 drivers/net/ethernet/amazon/ena/ena_com.c        |   48 ++++++++--
 drivers/net/ethernet/amazon/ena/ena_com.h        |    9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    |   42 +++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |    2=20
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |    2=20
 drivers/net/ethernet/micrel/ks8851_mll.c         |   53 ++---------
 drivers/net/phy/mdio-bcm-iproc.c                 |   20 ++++
 drivers/net/slip/slip.c                          |    1=20
 drivers/net/tun.c                                |   19 +++-
 drivers/net/usb/qmi_wwan.c                       |    1=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c     |    6 +
 drivers/nfc/pn544/i2c.c                          |    1=20
 drivers/s390/cio/blacklist.c                     |    5 -
 drivers/tty/serial/8250/8250_core.c              |    5 -
 drivers/tty/serial/8250/8250_port.c              |    4=20
 drivers/tty/serial/ar933x_uart.c                 |    8 +
 drivers/tty/serial/mvebu-uart.c                  |    2=20
 drivers/tty/sysrq.c                              |    8 -
 drivers/tty/vt/selection.c                       |   26 +++++
 drivers/tty/vt/vt.c                              |    2=20
 drivers/usb/core/hub.c                           |    6 +
 drivers/usb/core/port.c                          |   10 +-
 drivers/usb/core/quirks.c                        |    3=20
 drivers/usb/gadget/composite.c                   |   24 ++++-
 drivers/usb/gadget/function/f_fs.c               |    5 -
 drivers/usb/gadget/function/u_serial.c           |    4=20
 drivers/usb/storage/unusual_devs.h               |    6 +
 drivers/vhost/net.c                              |   13 --
 drivers/video/console/vgacon.c                   |    3=20
 drivers/watchdog/da9062_wdt.c                    |    7 -
 drivers/watchdog/wdat_wdt.c                      |    2=20
 fs/cifs/cifsacl.c                                |    4=20
 fs/cifs/connect.c                                |    2=20
 fs/cifs/inode.c                                  |    8 +
 fs/ecryptfs/keystore.c                           |    4=20
 fs/ext4/balloc.c                                 |   14 ++-
 fs/ext4/ext4.h                                   |   30 +++++-
 fs/ext4/ialloc.c                                 |   23 +++--
 fs/ext4/mballoc.c                                |   61 +++++++++----
 fs/ext4/resize.c                                 |   62 ++++++++++---
 fs/ext4/super.c                                  |  103 ++++++++++++++++--=
-----
 fs/fat/inode.c                                   |   19 +---
 fs/namei.c                                       |    2=20
 include/acpi/actypes.h                           |    2=20
 include/linux/bitops.h                           |    3=20
 include/linux/hid.h                              |    2=20
 include/net/flow_dissector.h                     |    9 ++
 kernel/audit.c                                   |   40 ++++----
 kernel/auditfilter.c                             |   71 ++++++++-------
 mm/huge_memory.c                                 |    2=20
 net/core/fib_rules.c                             |    2=20
 net/ipv6/ip6_fib.c                               |    7 -
 net/ipv6/route.c                                 |    1=20
 net/mac80211/util.c                              |   18 ++--
 net/netlink/af_netlink.c                         |    5 -
 net/sched/cls_flower.c                           |    1=20
 net/sctp/sm_statefuns.c                          |   27 ++++--
 net/wireless/ethtool.c                           |    8 +
 net/wireless/nl80211.c                           |    1=20
 sound/soc/codecs/pcm512x.c                       |    8 +
 sound/soc/soc-dapm.c                             |    2=20
 sound/soc/soc-pcm.c                              |   16 +--
 tools/perf/ui/browsers/hists.c                   |    1=20
 virt/kvm/kvm_main.c                              |   12 +-
 87 files changed, 688 insertions(+), 380 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: build v7_cpu_resume() unconditionally

Aleksa Sarai (1):
      namei: only return -ECHILD from follow_dotdot_rcu()

Andy Shevchenko (1):
      serial: 8250: Check UPF_IRQ_SHARED in advance

Arnaldo Carvalho de Melo (1):
      perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Arthur Kiyanovski (7):
      net: ena: fix potential crash when rxfh key is NULL
      net: ena: add missing ethtool TX timestamping indication
      net: ena: fix incorrect default RSS key
      net: ena: rss: store hash function as values and not bits
      net: ena: fix incorrectly saving queue numbers when setting RSS indir=
ection table
      net: ena: ena-com.c: prevent NULL pointer dereference
      net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Arun Parameswaran (1):
      net: phy: restore mdio regs in the iproc mdio driver

Benjamin Poirier (2):
      ipv6: Fix nlmsg_flags when splitting a multipath route
      ipv6: Fix route replacement with dev-only route

Bernard Metzler (1):
      RDMA/iwcm: Fix iwcm work deallocation

Bj=F8rn Mork (1):
      qmi_wwan: re-add DW5821e pre-production variant

Charles Keepax (1):
      ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Chris Wilson (1):
      include/linux/bitops.h: introduce BITS_PER_TYPE

Christophe JAILLET (2):
      MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'
      drivers: net: xgene: Fix the order of the arguments of 'alloc_etherde=
v_mqs()'

Corey Minyard (1):
      ipmi:ssif: Handle a possible NULL pointer reference

Dan Carpenter (3):
      ext4: potential crash on allocation error in ext4_alloc_flex_bg_array=
()
      hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
      dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Lazewatsky (1):
      usb: quirks: add NO_LPM quirk for Logitech Screen Share

Daniel Golle (1):
      serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Desnes A. Nunes do Rosario (1):
      powerpc: fix hardware PMU exception bug on PowerVM compatibility mode=
 systems

Dmitry Osipenko (3):
      nfc: pn544: Fix occasional HW initialization failure
      dmaengine: tegra-apb: Fix use-after-free
      dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Eugenio P=E9rez (1):
      vhost: Check docket sk_family instead of call getname

Eugeniu Rosca (2):
      usb: core: hub: do error out if usb_autopm_get_interface() fails
      usb: core: port: do error out if usb_autopm_get_interface() fails

Frank Sorenson (1):
      cifs: Fix mode output in debugging statements

Greg Kroah-Hartman (1):
      Linux 4.9.216

Harigovindan P (1):
      drm/msm/dsi: save pll state before dsi host is powered off

Jack Pham (1):
      usb: gadget: composite: Support more than 500mA MaxPower

Jason Baron (1):
      net: sched: correct flower port blocking

Jason Gunthorpe (1):
      RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Jason Wang (1):
      tuntap: correctly set SOCKWQ_ASYNC_NOSPACE

Jethro Beekman (1):
      net: fib_rules: Correctly set table field when table number exceeds 8=
 bits

Jim Lin (1):
      usb: storage: Add quirk for Samsung Fit flash

Jiri Slaby (3):
      vt: selection, close sel_buffer race
      vt: selection, push console lock down
      vt: selection, push sel_lock up

Johan Korsnes (2):
      HID: core: fix off-by-one memset in hid_report_raw_event()
      HID: core: increase HID report buffer size to 8KiB

Johannes Berg (2):
      iwlwifi: pcie: fix rb_allocator workqueue allocation
      mac80211: consider more elements in parsing CRC

John Stultz (1):
      drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Lars-Peter Clausen (1):
      usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Marco Felsch (1):
      watchdog: da9062: do not ping the hw during stop()

Marek Vasut (3):
      net: ks8851-ml: Remove 8-bit bus accessors
      net: ks8851-ml: Fix 16-bit data access
      net: ks8851-ml: Fix 16-bit IO operation

Matthias Reichl (1):
      ASoC: pcm512x: Fix unbalanced regulator enable call in probe error pa=
th

Mika Westerberg (2):
      ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro
      ACPI: watchdog: Fix gas->access_width usage

Mikulas Patocka (1):
      dm cache: fix a crash due to incorrect work item cancelling

Nathan Chancellor (1):
      ecryptfs: Fix up bad backport of fe2e082f5da5b4a0a92ae32978f81507ef37=
ec66

Nikolay Aleksandrov (1):
      net: netlink: cap max groups which will be considered in netlink_bind=
()

OGAWA Hirofumi (1):
      fat: fix uninit-memory access for partial initialized inode

Paul Moore (2):
      audit: fix error handling in audit_data_to_entry()
      audit: always check the netlink payload length in audit_receive_msg()

Petr Mladek (2):
      sysrq: Restore original console_loglevel when sysrq disabled
      sysrq: Remove duplicated sysrq message

Ronnie Sahlberg (1):
      cifs: don't leak -EAGAIN for stat() during reconnect

Sameeh Jubran (1):
      net: ena: rss: fix failure to get indirection table

Sean Christopherson (2):
      KVM: Check for a bad hva before dropping into the ghc slow path
      x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Sean Paul (1):
      drm/msm: Set dma maximum segment size for mdss

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Sergey Organov (1):
      usb: gadget: serial: fix Tx stall after buffer overflow

Suraj Jitindar Singh (2):
      ext4: fix potential race between s_flex_groups online resizing and ac=
cess
      ext4: fix potential race between s_group_info online resizing and acc=
ess

Takashi Iwai (1):
      ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Theodore Ts'o (1):
      ext4: fix potential race between online resizing and write operations

Vasily Averin (1):
      s390/cio: cio_ignore_proc_seq_next should increase position index

Vladimir Oltean (1):
      ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Wei Yang (1):
      mm/huge_memory.c: use head to check huge zero page

Wolfram Sang (1):
      i2c: jz4780: silence log flood on txabrt

Xin Long (1):
      sctp: move the format error check out of __sctp_sf_do_9_1_abort

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region

dan.carpenter@oracle.com (1):
      HID: hiddev: Fix race in in hiddev_disconnect()

tangbin (1):
      tty:serial:mvebu-uart:fix a wrong return

yangerkun (2):
      slip: stop double free sl->dev in slip_open
      crypto: algif_skcipher - use ZERO_OR_NULL_PTR in skcipher_recvmsg_asy=
nc


--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5qtBUACgkQONu9yGCS
aT4/uRAAqiwn85gG8NfH8bvoFt7q9AW1YRiRkFnbftJdZPO7A+BAKbwTT4orRrUs
11R9oICJWxq2k+pgoxij6jv4GYxDvjsLvSgZDoY40trj3aTkbrY9qx3vtL4GX9hg
IcvcDyf347eo4e15vp6I3idpWRh+e+gbMq7ZKArlKpCsLpy2yKBvtei2CGLXl9f2
UpO9gQxneIT21yTqS+pa9P3yrukRwYbk1MOhDhGpYZ7eIyUUR2uhWQYWnOX5m9gq
kXfkrSGV1hdPONCGom5PM1rZ7u6TPNpQ/Tzdr3iiW9A14kZpIn5WQztjT1+Cqoo2
M0dq1t3j/5/n5WOaBOc5Kxyktzouk1fgQCpqNiFSPmCU8klg0Crl0dj3YknZE9RQ
2J5sSdK2fwdRk6SKW/LCQ9fdKBv2bgWya189pRs9fgOzN2P10a1zJEmrvBsoZ1Ft
dxhBzqhUFnlKC9juHZVHWTeaXcsr3GFgdalDiyuQLU4E1rp7ceKGwwplji7li4OA
LLAI7+I0TkIVkvX+6vrvUq5A0Qm4M0CwkiJGb3awgcCzsJqgMGZhV0eFBb8LoL9Z
bjAjWEBXvbYePGSU/BpE0D5vUZ0xFXuzMFCvUjetttXVseALZuwjZYUS9v3wUI9T
UUyUBP1BNTSaUgKNFQO5VNYSpte/MSgnoloDxtcjzJ7uPn+3jng=
=mgH3
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
