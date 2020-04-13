Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBA1A67FF
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgDMOXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgDMOX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90B5C20774;
        Mon, 13 Apr 2020 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787806;
        bh=5XpkaRocw4KgPopL8ZNyEHrDLqKkOfQVOkKaMTvOnqM=;
        h=Date:From:To:Cc:Subject:From;
        b=j50kfFi1epZ+37kfURPdkn0GBJ2D4ew0Vg5ZfCkSrF2OFsKFF68lCqSlOWSStAjXU
         aGC8cyPl91kTGX3NnQ0NFIF+3PA8CmK0kai++Iov9CqV1phhbIMg3VDGhNXhCJpAN1
         B4Or3n+6meqb7+Lz+fWFpxvV8SrbFcetA50Sb6PA=
Date:   Mon, 13 Apr 2020 16:23:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.32
Message-ID: <20200413142323.GA3548304@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.32 kernel.

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

 Makefile                                              |    2=20
 arch/arm/mach-imx/Kconfig                             |    2=20
 arch/s390/include/asm/lowcore.h                       |    4=20
 arch/s390/include/asm/processor.h                     |    1=20
 arch/s390/include/asm/setup.h                         |    7=20
 arch/s390/kernel/asm-offsets.c                        |    2=20
 arch/s390/kernel/entry.S                              |   65 ++++----
 arch/s390/kernel/process.c                            |    1=20
 arch/s390/kernel/setup.c                              |    3=20
 arch/s390/kernel/smp.c                                |    2=20
 arch/s390/mm/vmem.c                                   |    4=20
 block/blk-mq.c                                        |    8=20
 drivers/acpi/sleep.c                                  |    4=20
 drivers/acpi/sleep.h                                  |    1=20
 drivers/acpi/wakeup.c                                 |   81 ++++++++++
 drivers/char/hw_random/imx-rngc.c                     |    4=20
 drivers/char/random.c                                 |   20 --
 drivers/gpu/drm/i915/i915_active.c                    |   29 ++-
 drivers/gpu/drm/i915/i915_active.h                    |    4=20
 drivers/infiniband/core/cma.c                         |   14 +
 drivers/infiniband/core/ucma.c                        |   49 +++++-
 drivers/infiniband/hw/hfi1/sysfs.c                    |   26 ++-
 drivers/infiniband/hw/mlx5/main.c                     |    6=20
 drivers/infiniband/sw/siw/siw_cm.c                    |  145 +++----------=
-----
 drivers/iommu/intel-iommu.c                           |   15 -
 drivers/net/can/slcan.c                               |    4=20
 drivers/net/dsa/bcm_sf2.c                             |    9 -
 drivers/net/dsa/mt7530.c                              |    3=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c       |    1=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |    9 -
 drivers/net/ethernet/realtek/r8169_main.c             |   34 +---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c  |    2=20
 drivers/net/phy/micrel.c                              |    7=20
 drivers/net/phy/realtek.c                             |    9 +
 drivers/net/tun.c                                     |   10 -
 drivers/platform/x86/intel_int0002_vgpio.c            |   10 +
 drivers/usb/dwc3/gadget.c                             |    2=20
 drivers/video/fbdev/core/fbcon.c                      |    3=20
 fs/ceph/super.c                                       |   56 ++++--
 fs/ceph/super.h                                       |    2=20
 include/linux/acpi.h                                  |    5=20
 include/linux/mlx5/mlx5_ifc.h                         |    6=20
 include/linux/swab.h                                  |    1=20
 include/uapi/linux/swab.h                             |   10 +
 lib/find_bit.c                                        |   16 -
 mm/slub.c                                             |    2=20
 net/bluetooth/rfcomm/tty.c                            |    4=20
 net/ipv6/addrconf.c                                   |    4=20
 net/sched/cls_tcindex.c                               |   45 ++++-
 sound/soc/jz4740/jz4740-i2s.c                         |    2=20
 tools/accounting/getdelays.c                          |    2=20
 51 files changed, 480 insertions(+), 277 deletions(-)

Alex Vesker (1):
      IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads

Anson Huang (1):
      ARM: imx: Enable ARM_ERRATA_814220 for i.MX6UL and i.MX7D

Arnd Bergmann (1):
      ARM: imx: only select ARM_ERRATA_814220 for ARMv7-A

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Bart Van Assche (1):
      blk-mq: Keep set->nr_hw_queues and set->map[].nr_queues in sync

Bernard Metzler (1):
      RDMA/siw: Fix passive connection establishment

Christian Borntraeger (1):
      include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LON=
G for swap

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
      Linux 5.4.32

Hans de Goede (2):
      ACPI: PM: Add acpi_[un]register_wakeup_handler()
      platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()

Heiner Kallweit (2):
      net: phy: realtek: fix handling of RTL8105e-integrated PHY
      r8169: change back SG and TSO to be disabled by default

Herat Ramani (1):
      cxgb4: fix MPS index overwrite when setting MAC address

Ilya Dryomov (1):
      ceph: canonicalize server path in place

Jarod Wilson (1):
      ipv6: don't auto-add link-local address to lag ports

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jason Gunthorpe (2):
      RDMA/ucma: Put a lock around every call to the rdma_cm layer
      RDMA/cma: Teach lockdep about the order of rtnl and lock

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Kaike Wan (2):
      IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
      IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Kees Cook (1):
      slub: improve bit diffusion for freelist ptr obfuscation

Lu Baolu (1):
      iommu/vt-d: Allow devices with RMRRs to use identity domain

Martin Kaiser (1):
      hwrng: imx-rngc - fix an error path

Oleksij Rempel (1):
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() be=
fore accessing PHY registers

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Petr Machata (1):
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Qiujun Huang (2):
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl
      fbcon: fix null-ptr-deref in fbcon_switch

Richard Palethorpe (1):
      slcan: Don't transmit uninitialized stack data in padding

Sultan Alsawaf (1):
      drm/i915: Fix ref->mutex deadlock in i915_active_wait()

Sven Schnelle (1):
      s390: prevent leaking kernel address in BEAR

Thinh Nguyen (1):
      usb: dwc3: gadget: Wrap around when skip TRBs

Will Deacon (1):
      tun: Don't put_page() for all negative return values from XDP program

Xiubo Li (1):
      ceph: remove the extra slashes in the server path

Yury Norov (1):
      uapi: rename ext2_swab() to swab() and share globally in swab.h


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6UddsACgkQONu9yGCS
aT5ufBAAuT5oltWM6arnVt2/psIvy+9aS1sZVwyV0+LfT2tBz86sBVDK1E4/zbg4
W6NCYMyU9bDA5fipO3SWdqvVJbPJpWQZpmP8Emv4sojLSpIjHfX1GQ2sRx4AAScn
k5GDOpgyeP5zH9Tbd4F2NdLXi4dvOxzSwBQf5p1QEp1RGeEFF2kKDDw8yP5QCrT3
5/BmqPLgYTpuLezk22W/th/OpddL5EhQDyqMIpKKMgcO1nph67CBGWoSQ3NkmgWC
0LW+okl866ST22bVJpoKCpl5T1tBocoxFfDnoHgLPbc3vZ4h7eWZahozLL3w0xV3
AMuchIKmE3vDKW96ariFquXNLrlT56WJANZy1O4J8C4rwh779FP8glbLPJ/ar6b1
TWsQy0KLLKbFD3pXTacIqixuPNg7+Ulskom4WzJAy4ZqBR3zWQwpXwToddkJYy3L
rNgVW+OsXxiMx3ayt2b6DgICze4bStff3ef+PKkCDE/XVRL9IHUgdJh9Jr0jSJFQ
uNL3EvyAdRtI+aHkJzAhcFplL7euTvmFSDJbyi0CFxVqbenGhQ7fGnNKW64puSOd
nlQiGloLAplSrVjMcHo2p4Wzr/5I72c/VH3og5W/yujU78s/A0tQBrSR1G2Vtc2P
OHdA3LvBMWT7pe5Q40reqBEAkhxE1bPzX9Czd6JD17UcUPbpovc=
=sS3F
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
