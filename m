Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E1088137
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 19:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406219AbfHIRcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 13:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfHIRcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 13:32:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8699620B7C;
        Fri,  9 Aug 2019 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565371936;
        bh=nKtquqpuBswHHe3M9vYfEcgyY9mTt3OC4sC8Acqz9S0=;
        h=Date:From:To:Cc:Subject:From;
        b=Sft2YIQACYCduRbRTnneckix2VbtG9Hhl98cCy0c2qnQRhsE9jrv8FxeZL9aU5Fyl
         BkG8Ao47QYkBp81HCpLNUvIyhO0+YDyDBdPtD8PfwV5ADp5FtlrsOhd0tJFAuP4K+3
         XShYTyJ6CZMt2j+uVEr/Gf3AGxdWe3X9Gu3ZoZ7A=
Date:   Fri, 9 Aug 2019 19:32:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.138
Message-ID: <20190809173213.GA18653@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.138 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm/boot/dts/logicpd-som-lv.dtsi                 |   16 ++
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi            |   16 ++
 arch/arm64/include/asm/cpufeature.h                   |    7 -
 arch/arm64/kernel/cpufeature.c                        |    8 +
 drivers/atm/iphase.c                                  |    8 +
 drivers/hid/hid-ids.h                                 |    1=20
 drivers/hid/usbhid/hid-quirks.c                       |    1=20
 drivers/hid/wacom_wac.c                               |   12 +-
 drivers/infiniband/core/addr.c                        |   15 +-
 drivers/infiniband/core/sa_query.c                    |   10 -
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c              |    5=20
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c              |    5=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c       |    2=20
 drivers/net/ethernet/marvell/mvpp2.c                  |   41 ++----
 drivers/net/ethernet/mellanox/mlx5/core/dev.c         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c |    5=20
 drivers/net/phy/phylink.c                             |    2=20
 drivers/net/ppp/pppoe.c                               |    3=20
 drivers/net/ppp/pppox.c                               |   13 ++
 drivers/net/ppp/pptp.c                                |    3=20
 drivers/net/tun.c                                     |    1=20
 drivers/nfc/nfcmrvl/main.c                            |    4=20
 drivers/nfc/nfcmrvl/uart.c                            |    4=20
 drivers/nfc/nfcmrvl/usb.c                             |    1=20
 drivers/scsi/fcoe/fcoe_ctlr.c                         |   51 +++-----
 drivers/scsi/libfc/fc_rport.c                         |    5=20
 drivers/spi/spi-bcm2835.c                             |    3=20
 fs/compat_ioctl.c                                     |    3=20
 include/linux/cgroup-defs.h                           |    1=20
 include/linux/cgroup.h                                |    4=20
 include/linux/if_pppox.h                              |    3=20
 include/linux/mlx5/fs.h                               |    1=20
 include/net/tcp.h                                     |   17 ++
 include/scsi/libfcoe.h                                |    1=20
 kernel/cgroup/cgroup.c                                |  106 ++++++++++++-=
-----
 kernel/exit.c                                         |    2=20
 net/bridge/br_multicast.c                             |    3=20
 net/bridge/br_vlan.c                                  |    5=20
 net/core/dev.c                                        |    2=20
 net/ipv4/tcp_output.c                                 |   11 +
 net/ipv6/ip6_tunnel.c                                 |    6 -
 net/l2tp/l2tp_ppp.c                                   |    3=20
 net/sched/act_ife.c                                   |    3=20
 net/sched/sch_codel.c                                 |    6 -
 net/tipc/netlink_compat.c                             |   11 +
 tools/objtool/check.c                                 |    2=20
 48 files changed, 292 insertions(+), 148 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: fix bit shift for Cintiq Companion 2

Adam Ford (2):
      ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV
      ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo

Alexis Bauvin (1):
      tun: mark small packets as owned by the tap sock

Ariel Levkovich (1):
      net/mlx5e: Prevent encap flow counter update async to user query

Arnd Bergmann (1):
      compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Cong Wang (1):
      ife: error out when nla attributes are empty

Eric Dumazet (1):
      tcp: be more careful in tcp_fragment()

Greg Kroah-Hartman (2):
      IB: directly cast the sockaddr union to aockaddr
      Linux 4.14.138

Gustavo A. R. Silva (1):
      atm: iphase: Fix Spectre v1 vulnerability

Haishuang Yan (1):
      ip6_tunnel: fix possible use-after-free on xmit

Hannes Reinecke (1):
      scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure

Jason Gunthorpe (1):
      RDMA: Directly cast the sockaddr union to sockaddr

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()

Jiri Pirko (1):
      net: fix ifindex collision during namespace removal

Johan Hovold (1):
      NFC: nfcmrvl: fix gpio-handling regression

Josh Poimboeuf (2):
      objtool: Add machine_real_restart() to the noreturn list
      objtool: Add rewind_stack_do_exit() to the noreturn list

Lukas Wunner (1):
      spi: bcm2835: Fix 3-wire mode if DMA is enabled

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Matteo Croce (1):
      mvpp2: refactor MTU change code

Nikolay Aleksandrov (2):
      net: bridge: delete local fdb on device init failure
      net: bridge: mcast: don't delete permanent entries when fast leave is=
 enabled

Ren=E9 van Dorst (1):
      net: phylink: Fix flow control for fixed-link

Sebastian Parschauer (1):
      HID: Add quirk for HP X1200 PIXART OEM mouse

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.

Taras Kondratiuk (1):
      tipc: compat: allow tipc commands without arguments

Tejun Heo (5):
      cgroup: Call cgroup_release() before __exit_signal()
      cgroup: Implement css_task_iter_skip()
      cgroup: Include dying leaders with live threads in PROCS iterations
      cgroup: css_task_iter_skip()'d iterators must be advanced before acce=
ssed
      cgroup: Fix css_task_iter_advance_css_set() cset skip condition

Will Deacon (1):
      arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1NrhkACgkQONu9yGCS
aT6TpBAAvtcYmWi9MtC+pEpE4H8v45/SE+eKilRCMMjeAu+O2+8zAW56xGNG3ts9
Zg96DqtHoSC8vIX0kEjBMoAUCaa9lbeZE4W5jkncTf+b9SIN4NXOVWPKO4FZBhcV
jWYs05FQ0D0whYWtmHj4H5rdyBwzf05/l46Ij1HRYYMKAAftQB7gJmmG6k5m0PEd
SB8goxHyLmF9PSoDHy10l7htmQ9jVTLH+cuDoMf5yKr3ZvmE5vbQRC4hCEjOaf6j
Rt/aG/EgLm+LYAYB3GwaA4GDes0YiCLmXeCfrnb8tWc63OY1py/LwSinPxEFvBaM
uDNs0oD+NFNLbyP9HgqT0Bg9Y3XEZI6WqvMs0YJ77dYeC5x6bzhBYWF3xUGWPxBH
KGAwlrpoOcSsxnmjGlao5QjUeZK0Zy9hPjA5KIsyxD0LrL0Hvil19RH0gM3IVTkh
xNi3mZ209cg2PVTBH5Gh2BcHAKKEGtDE1UpL+FqFJJfJZjwjwcJc5/+mccJoaRPw
x/WAYV8hnCf2MFNc0ZrxF82nV+sqmKJFOWTFLYlKFad5q1BGDTz74IvW1SgFz8PY
PuurTzVns1hQ7bgJs73eJ32Z9zqcOfeqVBmpNHEvLygeTBGy0DnH39qxg1gsnGJL
CdRhF5GqP65fZop+yB4BiJ48PikWoWJhl6S1A+m8QKJAqykv+5c=
=N+Wd
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
