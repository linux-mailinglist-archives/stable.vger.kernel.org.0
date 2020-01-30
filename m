Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E6914D78A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 09:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgA3Iau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 03:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgA3Iau (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 03:30:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1115A2082E;
        Thu, 30 Jan 2020 08:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580373049;
        bh=nRMfIkLZ7iuxO+beJ4K043JMk2fJH/+jJbevKn1T2Uw=;
        h=Date:From:To:Cc:Subject:From;
        b=btLC/WtsXRwAUg+nWdcmAxI/OlMNmYfuECnnat3/5ij0gSORZ0MFtRgTHz6d0tun+
         gMlMre5XZqrPjPzrfGU3dnBiTTFXG7tT1ZVazvu8b+BhIZWWtdllIwWkyDML/3SCnZ
         wyXK9KaQXAHzoovRZz55IDCCMOXS1XSdbgNFQRHk=
Date:   Thu, 30 Jan 2020 09:30:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.169
Message-ID: <20200130083047.GA646131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.169 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt |    6 +
 Makefile                                        |    2=20
 drivers/atm/firestream.c                        |    3=20
 drivers/hwmon/adt7475.c                         |    5 -
 drivers/hwmon/hwmon.c                           |   83 +++++++++++++++----=
-----
 drivers/hwmon/nct7802.c                         |    4 -
 drivers/hwtracing/coresight/coresight-etb10.c   |    4 -
 drivers/hwtracing/coresight/coresight-tmc-etf.c |    4 -
 drivers/infiniband/ulp/isert/ib_isert.c         |   12 ---
 drivers/input/misc/keyspan_remote.c             |    9 +-
 drivers/input/misc/pm8xxx-vibrator.c            |    2=20
 drivers/input/rmi4/rmi_smbus.c                  |    2=20
 drivers/input/tablet/aiptek.c                   |    6 -
 drivers/input/tablet/gtco.c                     |   10 --
 drivers/input/tablet/pegasus_notetaker.c        |    2=20
 drivers/input/touchscreen/sun4i-ts.c            |    6 +
 drivers/input/touchscreen/sur40.c               |    2=20
 drivers/md/bitmap.c                             |   10 +-
 drivers/md/bitmap.h                             |    2=20
 drivers/md/md-cluster.c                         |    6 -
 drivers/media/v4l2-core/v4l2-ioctl.c            |   24 +++---
 drivers/mmc/host/sdhci-tegra.c                  |    2=20
 drivers/mmc/host/sdhci.c                        |   10 +-
 drivers/net/can/slcan.c                         |   12 ++-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |    2=20
 drivers/net/gtp.c                               |   10 +-
 drivers/net/slip/slip.c                         |   12 ++-
 drivers/net/usb/lan78xx.c                       |   15 ++++
 drivers/net/wireless/marvell/libertas/cfg.c     |   16 +++-
 drivers/scsi/scsi_transport_iscsi.c             |    7 ++
 drivers/scsi/sd.c                               |    8 +-
 drivers/target/iscsi/iscsi_target.c             |    6 -
 fs/namei.c                                      |   17 ++--
 include/linux/bitmap.h                          |    8 ++
 include/linux/netdevice.h                       |    1=20
 include/linux/netfilter/ipset/ip_set.h          |    7 --
 include/trace/events/xen.h                      |    6 +
 lib/bitmap.c                                    |   20 +++++
 net/core/dev.c                                  |   36 ++++++----
 net/core/net-sysfs.c                            |   39 ++++++-----
 net/core/rtnetlink.c                            |   13 +++
 net/ipv4/ip_tunnel.c                            |    4 -
 net/ipv4/tcp_bbr.c                              |    3=20
 net/ipv6/ip6_tunnel.c                           |    4 -
 net/ipv6/seg6_local.c                           |    4 -
 net/netfilter/ipset/ip_set_bitmap_gen.h         |    2=20
 net/netfilter/ipset/ip_set_bitmap_ip.c          |    6 -
 net/netfilter/ipset/ip_set_bitmap_ipmac.c       |    6 -
 net/netfilter/ipset/ip_set_bitmap_port.c        |    6 -
 net/sched/ematch.c                              |    2=20
 net/x25/af_x25.c                                |    6 +
 scripts/recordmcount.c                          |   17 ++++
 52 files changed, 335 insertions(+), 176 deletions(-)

Al Viro (1):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types

Andy Shevchenko (2):
      md: Avoid namespace collision with bitmap API
      bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()

Bart Van Assche (1):
      scsi: RDMA/isert: Fix a recently introduced regression related to log=
out

Bo Wu (1):
      scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Changbin Du (1):
      tracing: xen: Ordered comparison of function pointers

Chuhong Yuan (1):
      Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register

Cong Wang (1):
      net_sched: fix datalen for ematch

Dmitry Osipenko (1):
      hwmon: (core) Fix double-free in __hwmon_device_register()

Eric Dumazet (3):
      gtp: make sure only SOCK_DGRAM UDP sockets are accepted
      net-sysfs: fix netdev_queue_add_kobject() breakage
      net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()

Gilles Buloz (1):
      hwmon: (nct7802) Fix voltage limits to wrong registers

Greg Kroah-Hartman (1):
      Linux 4.14.169

Guenter Roeck (1):
      hwmon: (core) Do not use device managed functions for memory allocati=
ons

Hans Verkuil (2):
      Revert "Input: synaptics-rmi4 - don't increment rmiaddr for SMBus tra=
nsfers"
      media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT

James Hughes (1):
      net: usb: lan78xx: Add .ndo_features_check

Jeremy Linton (1):
      Documentation: Document arm64 kpti control

Johan Hovold (5):
      Input: keyspan-remote - fix control-message timeouts
      Input: sur40 - fix interface sanity checks
      Input: gtco - fix endpoint sanity check
      Input: aiptek - fix endpoint sanity check
      Input: pegasus_notetaker - fix endpoint sanity check

Jouni Hogander (4):
      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
      net-sysfs: Call dev_hold always in netdev_queue_add_kobject
      net-sysfs: Call dev_hold always in rx_queue_add_kobject
      net-sysfs: Fix reference count leak

Kadlecsik J=C3=B3zsef (1):
      netfilter: ipset: use bitmap infrastructure completely

Linus Walleij (1):
      hwmon: Deal with errors from the thermal subsystem

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Martin Schiller (1):
      net/x25: fix nonblocking connect

Masato Suzuki (1):
      sd: Fix REQ_OP_ZONE_REPORT completion handling

Michael Ellerman (1):
      net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Micha=C5=82 Miros=C5=82aw (2):
      mmc: tegra: fix SDR50 tuning override
      mmc: sdhci: fix minimum clock rate for v3 controller

Richard Palethorpe (1):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Stephan Gerhold (1):
      Input: pm8xxx-vib - fix handling of separate enable register

Suzuki K Poulose (2):
      coresight: etb10: Do not call smp_processor_id from preemptible
      coresight: tmc-etf: Do not call smp_processor_id from preemptible

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (1):
      tcp_bbr: improve arithmetic division in bbr_update_bw()

Wenwen Wang (1):
      firestream: fix memory leaks

William Dauchy (2):
      net, ip6_tunnel: fix namespaces move
      net, ip_tunnel: fix namespaces move

Yuki Taguchi (1):
      ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4ylDcACgkQONu9yGCS
aT7WuxAAmTrtihyahy0W1l+2lMmieTGUdaLj2yms8aorOhc20QvHtEoBWQC2NGaI
wVmlgbco6KZA3Z0rHi870h3ISs1Bql5Q7HGmT2fmQQG12GRVKpBW+MHFgPfmlWC1
3Zdt2wBCJI0h2egA9MwNOTYxPZj/95u7eCGS9ynejTtkX4ibzkoDXe9orPEQXOO6
JKDVHKkuBjy5iwl6zWL2A3xvPiDm0ZdJl9Nl8RC53clfor4ojxslkGmGSv0xifaF
/lGlJ9waUdE15v5GbyR+23FQsFnZFVPKaza8uYOHMU/h0xuKBmomS+/9G2IkPKWZ
7loqKaUHFEM8s26nZEHFk+6dL7j6s1VXSibwG0mMdvNjLf2MxEWMriyJx5MMONMu
1df+x0y5QMASpRz1GYqwqDqBFzoUdJ1tZo9JO/yi8cNSdSQloCv8ZlPpERUIu+JD
ne6G+NyHD7pPREl6KZ7eT08oKMjEqePmpjWs0CvBkLYR6gKjx8jc8uf7lIz9qxMH
/FWSyDoNH9cFV/3Ljs22Vp8nhl8cv9ZvBl4TKxyHa7J58dNb16+pU6eLshV0sXQ1
4AfedoEh6x2nKrYnX7h4lDR+J3Qoc/9OumtleVDhtbgcJu6P8zmpVa/2e7ixXUmi
RZZ15WKSP2Y6lyo/ffrwVm4hpb67kqyYI4pmXzdBAIV33oVN2Mo=
=4JQf
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
