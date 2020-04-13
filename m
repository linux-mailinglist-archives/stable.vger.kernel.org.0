Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0271A6817
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbgDMOYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730650AbgDMOYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:24:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E62220786;
        Mon, 13 Apr 2020 14:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787843;
        bh=XwjaU8G0T1LgzlcwBXrSR9R3Ijs8UK29rMYyBAMmFb0=;
        h=Date:From:To:Cc:Subject:From;
        b=plN3nBzXftwz9fam6dLSrOqI+Iv3IljiJ5w0oAmNBp7bQQGQs9uVQcfxirAcZ/fxh
         sSGhW0pU5uSXN90H5iSKd5GhJLQG78X22LoEiIvRgoPsNv4c81MwJNp96fwihDDvwS
         s4g49dtDIRmiEeZa/9f+da5Qy1q27iW7U2tRf+Nk=
Date:   Mon, 13 Apr 2020 16:24:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.4
Message-ID: <20200413142401.GA3548491@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.4 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/s390/include/asm/lowcore.h                       |    4=20
 arch/s390/include/asm/processor.h                     |    1=20
 arch/s390/include/asm/setup.h                         |    7=20
 arch/s390/kernel/asm-offsets.c                        |    2=20
 arch/s390/kernel/entry.S                              |   65 +++++---
 arch/s390/kernel/process.c                            |    1=20
 arch/s390/kernel/setup.c                              |    3=20
 arch/s390/kernel/smp.c                                |    2=20
 arch/s390/mm/vmem.c                                   |    4=20
 block/blk-mq.c                                        |    8 +
 drivers/acpi/sleep.c                                  |    4=20
 drivers/acpi/sleep.h                                  |    1=20
 drivers/acpi/wakeup.c                                 |   81 ++++++++++
 drivers/base/core.c                                   |    8 -
 drivers/char/hw_random/imx-rngc.c                     |    4=20
 drivers/char/random.c                                 |   20 --
 drivers/infiniband/core/cma.c                         |   14 +
 drivers/infiniband/core/ucma.c                        |   49 ++++++
 drivers/infiniband/hw/hfi1/sysfs.c                    |   26 ++-
 drivers/infiniband/hw/mlx5/main.c                     |    6=20
 drivers/infiniband/sw/siw/siw_cm.c                    |  137 ++++---------=
-----
 drivers/mtd/ubi/fastmap-wl.c                          |   15 +
 drivers/net/can/slcan.c                               |    4=20
 drivers/net/dsa/bcm_sf2.c                             |    9 -
 drivers/net/dsa/mt7530.c                              |    3=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c       |    5=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   23 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |    1=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |    9 -
 drivers/net/ethernet/realtek/r8169_main.c             |   34 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c  |    2=20
 drivers/net/phy/at803x.c                              |    4=20
 drivers/net/phy/micrel.c                              |    7=20
 drivers/net/tun.c                                     |   10 -
 drivers/platform/x86/intel_int0002_vgpio.c            |   10 +
 drivers/usb/dwc3/gadget.c                             |    2=20
 drivers/video/fbdev/core/fbcon.c                      |    3=20
 fs/io_uring.c                                         |   13 -
 include/linux/acpi.h                                  |    5=20
 include/linux/mlx5/mlx5_ifc.h                         |    6=20
 mm/slub.c                                             |    2=20
 net/bluetooth/rfcomm/tty.c                            |    4=20
 net/ipv6/addrconf.c                                   |    4=20
 net/sched/cls_tcindex.c                               |   45 +++++
 sound/soc/codecs/tas2562.c                            |    2=20
 sound/soc/jz4740/jz4740-i2s.c                         |    2=20
 tools/accounting/getdelays.c                          |    2=20
 48 files changed, 450 insertions(+), 225 deletions(-)

Alex Vesker (1):
      IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Bart Van Assche (1):
      blk-mq: Keep set->nr_hw_queues and set->map[].nr_queues in sync

Bernard Metzler (1):
      RDMA/siw: Fix passive connection establishment

Chuanhong Guo (1):
      net: dsa: mt7530: fix null pointer dereferencing in port5 setup

Cong Wang (2):
      net_sched: add a temporary refcnt for struct tcindex_data
      net_sched: fix a missing refcnt in tcindex_init()

David Ahern (1):
      tools/accounting/getdelays.c: fix netlink attribute length

Florian Fainelli (2):
      net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
      net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Greg Kroah-Hartman (1):
      Linux 5.6.4

Hans de Goede (2):
      ACPI: PM: Add acpi_[un]register_wakeup_handler()
      platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()

Heiner Kallweit (1):
      r8169: change back SG and TSO to be disabled by default

Herat Ramani (1):
      cxgb4: fix MPS index overwrite when setting MAC address

Hillf Danton (1):
      io-uring: drop completion when removing file

Hou Tao (1):
      ubi: fastmap: Free unused fastmap anchor peb during detach

Jarod Wilson (1):
      ipv6: don't auto-add link-local address to lag ports

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jason Gunthorpe (2):
      RDMA/ucma: Put a lock around every call to the rdma_cm layer
      RDMA/cma: Teach lockdep about the order of rtnl and lock

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Jonghwan Choi (1):
      ASoC: tas2562: Fixed incorrect amp_level setting.

Kaike Wan (2):
      IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
      IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Kees Cook (1):
      slub: improve bit diffusion for freelist ptr obfuscation

Martin Kaiser (1):
      hwrng: imx-rngc - fix an error path

Oleksij Rempel (2):
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() be=
fore accessing PHY registers
      net: phy: at803x: fix clock sink configuration on ATH8030 and ATH8035

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Petr Machata (1):
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Qiujun Huang (2):
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl
      fbcon: fix null-ptr-deref in fbcon_switch

Rahul Lakkireddy (1):
      cxgb4: free MQPRIO resources in shutdown path

Richard Palethorpe (1):
      slcan: Don't transmit uninitialized stack data in padding

Saravana Kannan (1):
      driver core: Reevaluate dev->links.need_for_probe as suppliers are ad=
ded

Sven Schnelle (1):
      s390: prevent leaking kernel address in BEAR

Thinh Nguyen (1):
      usb: dwc3: gadget: Wrap around when skip TRBs

Will Deacon (1):
      tun: Don't put_page() for all negative return values from XDP program


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6UdgEACgkQONu9yGCS
aT6d0A//XfPK2A277RQ5CBjK0zAWMtryoEtN+B0H7RIpaQHE3YsIy47vMzOeEwL6
8MdzDq8odEY5AZcw3BvRK+QnP46qRpS9SFGXJAx0cim0V6EOpQ17kRanDHoyhKGX
wFgjcQTGLKgDAj1cSFUzSR8xWWHA2gMl9Zk3wNQsdZVD2UW8Km+udYZnOH6VnDoG
sx8g3cSw3DgELc0k57iGg/kJBoSwfzUCAUgPTXAnohreX5F+wweI1o6Mt3hlpXBD
Zofx/mGuZaziQ6JSKF1utfYSRMXWrFqkQZ9/Urk691BMLR6qcjDORE9EMsg0cRJ7
MOvB0ktoUsWO+uTQ7RVzipICFl0BDV4VPROFjhOHlLfrt6M5SzgqRBWGSY6fAYYF
NLaO7T5iLgyoQMysPYn0lOUysaKQEdmacF7x63UHGZiu5842D0JxkrrmHOuJXDPm
PDiFRX4VVf2sEpFKGndvA162Iwk8MKUsOhQpFc3tcEfM4pXtjpmNnxQwqENk1Wwp
iBgQXViUI/Mb48SWJnhUadtTF5PIEVB2Zoc+q/GGdzqzRZ/MuU4c/dMUQ9SMFqsU
PE9wtbwRqhd1viLMQWYS42JAPB0Sy91OV7Rbyo+AcfqmE4QZhFzb0U44pxKK9fGq
7VzvQJPmgy1UETn/HQKvgXOTQ5CrFnkpLmDpWU4Yb2qvCbVh784=
=IwR5
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
