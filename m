Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C926C174FA
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfEHJVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfEHJVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:21:49 -0400
Received: from localhost (unknown [84.241.196.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C0320656;
        Wed,  8 May 2019 09:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557307308;
        bh=8w6gYGf3eDXDr0V3X9QNFb6e+Bwz9Pgm7KM/CKRmSIk=;
        h=Date:From:To:Cc:Subject:From;
        b=oCV4Nn7dWBk/v5eyepRYefphDSeHK66ZDUawXiBurv9bwlBN3Sfaxu8W22JYuuHAN
         J7pizRG+ClaXsqJl3cUQZKWbODLJfzwxO+FSvXtde2nJIe7ElcaVURJoCzXMfmVlL5
         SsXHmOPB1Tj7yN+vBWDrylh/DaXljjfIioyBB2jM=
Date:   Wed, 8 May 2019 11:21:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.174
Message-ID: <20190508092145.GA2106@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.174 kernel.

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

 Documentation/usb/power-management.txt            |   14 +-
 Makefile                                          |    2=20
 arch/arm/mach-iop13xx/setup.c                     |    8 -
 arch/arm/mach-iop13xx/tpmi.c                      |   10 -
 arch/arm/plat-iop/adma.c                          |    6 -
 arch/arm/plat-orion/common.c                      |    4=20
 arch/arm64/include/asm/system_misc.h              |    2=20
 arch/arm64/mm/fault.c                             |   35 ++++--
 arch/arm64/mm/kasan_init.c                        |    2=20
 arch/arm64/mm/proc.S                              |   14 +-
 arch/sh/boards/of-generic.c                       |    4=20
 arch/x86/events/amd/core.c                        |  111 +++++++++++++++++=
++++-
 arch/x86/include/asm/stacktrace.h                 |    5=20
 arch/x86/kernel/acpi/wakeup_64.S                  |    9 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c         |    5=20
 arch/x86/kernel/unwind_frame.c                    |   20 +++
 drivers/block/xsysace.c                           |    2=20
 drivers/hid/hid-debug.c                           |    5=20
 drivers/hid/hid-logitech-hidpp.c                  |    8 +
 drivers/infiniband/ulp/srpt/ib_srpt.c             |   11 ++
 drivers/input/keyboard/snvs_pwrkey.c              |    6 -
 drivers/media/i2c/ov7670.c                        |   16 +--
 drivers/net/bonding/bond_sysfs_slave.c            |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |    9 +
 drivers/net/ethernet/hisilicon/hns/hnae.c         |    4=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c     |   12 --
 drivers/net/ethernet/intel/igb/e1000_defines.h    |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c         |   57 +----------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c |    6 -
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c    |   12 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c   |    2=20
 drivers/net/phy/marvell.c                         |    6 -
 drivers/nvme/target/core.c                        |   20 +--
 drivers/rtc/rtc-da9063.c                          |    7 +
 drivers/rtc/rtc-sh.c                              |    2=20
 drivers/scsi/scsi_devinfo.c                       |    1=20
 drivers/scsi/scsi_dh.c                            |    1=20
 drivers/scsi/storvsc_drv.c                        |   13 ++
 drivers/staging/iio/addac/adt7316.c               |   22 +++-
 drivers/usb/core/driver.c                         |   13 --
 drivers/usb/core/message.c                        |    4=20
 drivers/usb/misc/yurex.c                          |    1=20
 drivers/usb/storage/realtek_cr.c                  |   13 --
 drivers/usb/usbip/stub_rx.c                       |   12 --
 drivers/usb/usbip/usbip_common.h                  |    7 +
 drivers/vfio/pci/vfio_pci.c                       |    4=20
 drivers/w1/masters/ds2490.c                       |    6 -
 fs/debugfs/inode.c                                |   13 +-
 fs/hugetlbfs/inode.c                              |   20 ++-
 fs/jffs2/readinode.c                              |    5=20
 fs/jffs2/super.c                                  |    5=20
 include/linux/kasan.h                             |    1=20
 include/linux/usb.h                               |    2=20
 include/net/caif/cfpkt.h                          |   27 +++++
 lib/Makefile                                      |    1=20
 lib/test_kasan.c                                  |    2=20
 mm/kasan/kasan.c                                  |    9 +
 mm/kasan/kasan_init.c                             |   15 +-
 mm/kasan/report.c                                 |    1=20
 net/batman-adv/bridge_loop_avoidance.c            |   16 ++-
 net/batman-adv/translation-table.c                |   32 ++++--
 net/caif/cfctrl.c                                 |   50 ++++-----
 net/ipv4/ip_output.c                              |    1=20
 net/ipv6/ip6_flowlabel.c                          |   22 ++--
 net/packet/af_packet.c                            |   24 ++--
 security/selinux/hooks.c                          |   40 ++++++-
 sound/usb/line6/driver.c                          |   60 ++++++-----
 sound/usb/line6/podhd.c                           |   21 ++--
 sound/usb/line6/toneport.c                        |   24 +++-
 69 files changed, 612 insertions(+), 318 deletions(-)

Aaro Koskinen (3):
      net: stmmac: don't overwrite discard_frame status
      net: stmmac: fix dropping of multi-descriptor RX frames
      net: stmmac: don't log oversized frames

Al Viro (2):
      jffs2: fix use-after-free on symlink traversal
      debugfs: fix use-after-free on symlink traversal

Alan Stern (4):
      USB: yurex: Fix protection fault after device removal
      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
      USB: core: Fix unterminated string returned by usb_string()
      USB: core: Fix bug caused by duplicate interface PM usage counter

Alexandre Belloni (1):
      rtc: da9063: set uie_unsupported when relevant

Andrew Lunn (1):
      net: phy: marvell: Fix buffer overrun with stats counters

Andrey Konovalov (1):
      kasan: prevent compiler from optimizing away memset in tests

Anson Huang (1):
      Input: snvs_pwrkey - initialize necessary driver data before enabling=
 IRQ

Arnd Bergmann (4):
      kasan: avoid -Wmaybe-uninitialized warning
      caif: reduce stack size with KASAN
      ARM: orion: don't use using 64-bit DMA masks
      ARM: iop: don't use using 64-bit DMA masks

Arvind Sankar (1):
      igb: Fix WARN_ONCE on runtime suspend

Bart Van Assche (1):
      scsi: RDMA/srpt: Fix a credit leak for aborted commands

Colin Ian King (1):
      kasan: remove redundant initialization of variable 'real_size'

Eric Dumazet (1):
      ipv6/flowlabel: wait rcu grace period before put_pid()

Geert Uytterhoeven (1):
      rtc: sh: Fix invalid alarm warning for non-enabled alarm

Greg Kroah-Hartman (2):
      ALSA: line6: use dynamic buffers
      Linux 4.9.174

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup

He, Bo (1):
      HID: debug: fix race condition with between rdesc_show() and device r=
emoval

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jeremy Fertic (3):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix the dac write calculation

Josh Poimboeuf (2):
      x86/suspend: fix false positive KASAN warning on suspend/resume
      x86/unwind: Disable KASAN checks for non-current tasks

Kangjie Lu (1):
      HID: logitech: check the return value of create_singlethread_workqueue

Kim Phillips (1):
      perf/x86/amd: Update generic hardware cache events for Family 17h

Konstantin Khorenko (1):
      bonding: show full hw address in sysfs for slave entries

Kristina Martsenko (2):
      arm64: mm: print out correct page table entries
      arm64: mm: don't print out page table entries on EL0 faults

Laura Abbott (1):
      mm/kasan: Switch to using __pa_symbol and lm_alias

Liubin Shu (1):
      net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Louis Taylor (1):
      vfio/pci: use correct format characters

Malte Leip (1):
      usb: usbip: fix isoc packet num validation in get_pipe

Mark Rutland (1):
      arm64: kasan: avoid bad virt_to_pfn()

Masami Hiramatsu (1):
      kasan: add a prototype of task_struct to avoid warning

Michael Chan (1):
      bnxt_en: Improve multicast address setup logic.

Michael Kelley (1):
      scsi: storvsc: Fix calculation of sub-channel count

Mike Kravetz (1):
      hugetlbfs: fix memory leak for resv_map

Omri Kahalon (1):
      net/mlx5: E-Switch, Fix esw manager vport indication for more vport c=
ommands

Ondrej Mosnacek (1):
      selinux: never allow relabeling on context mounts

Randy Dunlap (1):
      sh: fix multiple function definition build errors

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Sven Eckelmann (3):
      batman-adv: Reduce claim hash refcnt only for removed entry
      batman-adv: Reduce tt_local hash refcnt only for removed entry
      batman-adv: Reduce tt_global hash refcnt only for removed entry

Tony Luck (1):
      x86/mce: Improve error message when kernel cannot recover, p2

Will Deacon (1):
      arm64: proc: Set PTE_NG for table entries to avoid traversing them tw=
ice

Willem de Bruijn (2):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: validate msg_namelen in send directly

Xose Vazquez Perez (1):
      scsi: core: add new RDAC LENOVO/DE_Series device

Yonglong Liu (2):
      net: hns: Use NAPI_POLL_WEIGHT for hns driver
      net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yufen Yu (1):
      nvme-loop: init nvmet_ctrl fatal_err_work when allocate


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzSn6UACgkQONu9yGCS
aT5ncw/+NalXWJWDbEHGxwgt40HCzf/h3Rdbu4A9e0mS3M9+ZrpJVznd1PnPig8K
+uLBI9nRlVGz3TztvBAqomtDEomH8klhvt7BmH+05KZUNHzYeFgD+S5C5ZmzqET6
BwESWUZczwwyE8Pcv2urGKb6udHMpATTKe5ZCyeHjrbRhVukFqGEjS8TGuxa2DmW
ymXIDBl6Akg8/UKTcBX/yxXyZ3jQNjh6Gvs/3yFS/psJqIAP72M6BejHX6aAuwLh
yuJOoz2RACdMgbslVC4IiEV8YbFzC2urtOEXEUfbSJLmyWb7OJzsFqX+uphfDaT3
6oXRB+lQsqAS1NPeuyZodeyjLiXvBOfaELipw7UY3JyAye8FPOFUoupuxlFgCJfM
N4902B1/+p0yqqjPYO6YBE9vDWd3aJXz3WrM36g/bcnwml4/jK1QADrjptTg1u3P
kvtC1b4vG7oQkUVw6+A8wVU0dOggBRYzExQJIQWm3ajLTM9QbETUYy7IBVgEKu/M
lKXin295LL3oW+RK+LXcYMtX1q5dy9VVKBRl+98uR0uuRCY738kVPe32NED9qBsc
J+EYjK9Jpr9t8OEBGtKAcCxnlCWsK/FO4QRFsgqdl5Y4lR+7ILaVXnTG56++O5h2
Qryx3c13Zr2ksDE5A+VloyB3GUqYHLECcG016Eur8i0Ep/BgH8o=
=yc21
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
