Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19538813C
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 19:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407317AbfHIRdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 13:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfHIRdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 13:33:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B6C20B7C;
        Fri,  9 Aug 2019 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565371983;
        bh=V/8zexr6V2DWvVb2uVXkDqVqFA02Nq9c2+jeKrzE1VU=;
        h=Date:From:To:Cc:Subject:From;
        b=qIFk4xj5e9sCXzae7bxpFVyMfX9L51PgFzm/wzv0lRMcef9LfF+iUZ+9bSf4oU+C0
         iqAEaX6LOMYYzZFOqfW6HkKWitm/rQLMT5OZdd9BBzLLZSOapGwr9c7SR46QqE81ng
         qp623Dg1rDUWYkK31Kn4IUYX4l25DPDsDb4J1d7A=
Date:   Fri, 9 Aug 2019 19:33:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.66
Message-ID: <20190809173300.GA18827@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.66 kernel.

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

 Makefile                                              |    2=20
 drivers/atm/iphase.c                                  |    8 +
 drivers/base/base.h                                   |    4=20
 drivers/base/core.c                                   |   22 +++
 drivers/base/dd.c                                     |   22 +--
 drivers/hid/hid-ids.h                                 |    1=20
 drivers/hid/hid-quirks.c                              |    1=20
 drivers/hid/wacom_wac.c                               |   12 +-
 drivers/i2c/i2c-core-base.c                           |    2=20
 drivers/infiniband/core/sa_query.c                    |    9 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c       |    3=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       |   46 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/dev.c         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c |    5=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |    2=20
 drivers/net/ethernet/mscc/ocelot.c                    |    1=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h       |    2=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c  |   13 +-
 drivers/net/ethernet/realtek/r8169.c                  |    9 +
 drivers/net/phy/phylink.c                             |    2=20
 drivers/net/ppp/pppoe.c                               |    3=20
 drivers/net/ppp/pppox.c                               |   13 ++
 drivers/net/ppp/pptp.c                                |    3=20
 drivers/net/tun.c                                     |    1=20
 drivers/nfc/nfcmrvl/main.c                            |    4=20
 drivers/nfc/nfcmrvl/uart.c                            |    4=20
 drivers/nfc/nfcmrvl/usb.c                             |    1=20
 drivers/nvdimm/bus.c                                  |   98 ++++++++++++-=
---
 drivers/nvdimm/region.c                               |   22 +--
 drivers/nvdimm/region_devs.c                          |    4=20
 drivers/scsi/fcoe/fcoe_ctlr.c                         |   51 +++-----
 drivers/scsi/libfc/fc_rport.c                         |    5=20
 drivers/spi/spi-bcm2835.c                             |    3=20
 fs/compat_ioctl.c                                     |    3=20
 include/linux/cgroup-defs.h                           |    1=20
 include/linux/cgroup.h                                |    4=20
 include/linux/device.h                                |    1=20
 include/linux/if_pppox.h                              |    3=20
 include/linux/mlx5/fs.h                               |    1=20
 include/linux/mlx5/mlx5_ifc.h                         |    7 +
 include/scsi/libfcoe.h                                |    1=20
 kernel/cgroup/cgroup.c                                |  106 ++++++++++++-=
-----
 kernel/exit.c                                         |    2=20
 net/bridge/br_multicast.c                             |    3=20
 net/bridge/br_vlan.c                                  |    5=20
 net/core/dev.c                                        |    2=20
 net/ipv4/ipip.c                                       |    3=20
 net/ipv6/ip6_gre.c                                    |    3=20
 net/ipv6/ip6_tunnel.c                                 |    6 -
 net/l2tp/l2tp_ppp.c                                   |    3=20
 net/sched/act_bpf.c                                   |    9 -
 net/sched/act_connmark.c                              |    9 -
 net/sched/act_csum.c                                  |    9 -
 net/sched/act_gact.c                                  |    8 -
 net/sched/act_ife.c                                   |   13 +-
 net/sched/act_mirred.c                                |   13 +-
 net/sched/act_nat.c                                   |    9 -
 net/sched/act_pedit.c                                 |   10 +
 net/sched/act_police.c                                |    8 -
 net/sched/act_sample.c                                |   10 -
 net/sched/act_simple.c                                |   10 +
 net/sched/act_skbedit.c                               |   11 +
 net/sched/act_skbmod.c                                |   11 +
 net/sched/act_tunnel_key.c                            |    8 -
 net/sched/act_vlan.c                                  |   25 +++-
 net/sched/sch_codel.c                                 |    6 -
 net/smc/af_smc.c                                      |    8 +
 net/tipc/netlink_compat.c                             |   11 +
 70 files changed, 470 insertions(+), 261 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: fix bit shift for Cintiq Companion 2

Alexander Duyck (1):
      driver core: Establish order of operations for device_add and device_=
del via bitflag

Alexis Bauvin (1):
      tun: mark small packets as owned by the tap sock

Ariel Levkovich (1):
      net/mlx5e: Prevent encap flow counter update async to user query

Arnd Bergmann (1):
      compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Claudiu Manoil (1):
      ocelot: Cancel delayed work before wq destruction

Cong Wang (1):
      ife: error out when nla attributes are empty

Dan Williams (5):
      drivers/base: Introduce kill_device()
      libnvdimm/bus: Prevent duplicate device_unregister() calls
      libnvdimm/region: Register badblocks before namespaces
      libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant
      libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock

Dmytro Linkin (1):
      net: sched: use temporary variable for actions indexes

Edward Srouji (1):
      net/mlx5: Fix modify_cq_in alignment

Greg Kroah-Hartman (2):
      IB: directly cast the sockaddr union to aockaddr
      Linux 4.19.66

Gustavo A. R. Silva (1):
      atm: iphase: Fix Spectre v1 vulnerability

Haishuang Yan (3):
      ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
      ip6_tunnel: fix possible use-after-free on xmit
      ipip: validate header length in ipip_tunnel_xmit

Hannes Reinecke (1):
      scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure

Heiner Kallweit (1):
      r8169: don't use MSI before RTL8168d

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()

Jiri Pirko (2):
      mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()
      net: fix ifindex collision during namespace removal

Johan Hovold (1):
      NFC: nfcmrvl: fix gpio-handling regression

Linus Torvalds (1):
      gcc-9: don't warn about uninitialized variable

Lukas Wunner (1):
      spi: bcm2835: Fix 3-wire mode if DMA is enabled

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Matteo Croce (2):
      mvpp2: fix panic on module removal
      mvpp2: refactor MTU change code

Nikolay Aleksandrov (2):
      net: bridge: delete local fdb on device init failure
      net: bridge: mcast: don't delete permanent entries when fast leave is=
 enabled

Qian Cai (1):
      net/mlx5e: always initialize frag->last_in_page

Ren=E9 van Dorst (1):
      net: phylink: Fix flow control for fixed-link

Roman Mashak (1):
      net sched: update vlan action for batched events operations

Sebastian Parschauer (1):
      HID: Add quirk for HP X1200 PIXART OEM mouse

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Fix incorrect UL checksum offload logic

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

Ursula Braun (1):
      net/smc: do not schedule tx_work in SMC_CLOSED state


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1NrkwACgkQONu9yGCS
aT70ehAAgjL+vEuxrWpdfvJUYver3mzx0O+wdFPrBNSZn6n5jIjWGkFc79hJgJxz
9MBZpMwazwx8JTAMXv/sCJdqib13kU5pKCcSTAShPLwXZ1pNqYq7B5PljosetOv1
JDQniq/+YMSMEU/BaCZRu313BK8k8p2VVVipyfH2CjQjH4ZBUiguzrfiBVWWLc50
nOt06SLYoZqcX3vRzS6iQl4vlOF73rEwiukYWB126DDj7JaGV1lSqs77JDmVHFCT
4klzvwOvhCdidyP9a/5biRbKZwhNxX3RE+urrJfj09smgxLnunpOfk75KTXSSikA
ZCVOGYXiDZENH6Pjag3shTcy0wzN+R5seqErbJMDCFk9ycccp3p2x491xw7PF7ME
BJtIKlpfAC+2J67oAvzM/KORTCzxNA/8trK7OpYGrHXZhC8wjEI8Zkscl3lBY2rm
QBEir3KMmhl6WtBMgSHQjNYzWEbsjSHXWzSqbLXovPfDNKQnb8hldom0/lEoR/rr
9qm/0xOjpNDVSYN4jeM836o4y6/fbgNNp64nwyuiJO45hi53SRRhL59J7Ql6g0y9
hxXti3tjI+5qIlDkTvO93XAUa80LPdXk9QN0ImGxO/Q3pbye1tqGsSUg/FCMDXeS
qGFpUB64n5axZ5qlGj5IyvxauS8oQTAMsq96kLu0rTqgVg2PxLU=
=y6tu
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
