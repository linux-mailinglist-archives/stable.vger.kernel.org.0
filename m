Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3F124FFF
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 19:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLRSCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 13:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfLRSCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 13:02:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E54CC206D7;
        Wed, 18 Dec 2019 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576692172;
        bh=07XNdCootq4GnW1ge3r31OFh8HoBIKH3/HdxwaHdyG8=;
        h=Date:From:To:Cc:Subject:From;
        b=PjtJWEBotV6ekO/wg+qADifJi52DCTU2EyU68e/Lle4i94NDxxjHTTWzPITuwFg23
         f3t5FPB1nh/8Mv7mDpmyy3jdw9LaYYlojBTTfXEyPVChf9H59+gYfOea/R8GYcI1Ls
         vF+JPZ5xFCxRDKx/mVlIJnqWv7UqWuSRCIPAsVys=
Date:   Wed, 18 Dec 2019 19:02:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.18
Message-ID: <20191218180250.GA865731@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.18 kernel.

Note, this is the LAST 5.3.y kernel release.  It is now end-of-life.
Please move to 5.4.y now.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                 |    2=20
 drivers/infiniband/core/addr.c                           |    7=20
 drivers/infiniband/sw/rxe/rxe_net.c                      |    8=20
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c |   27 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c      |    8=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |   31 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c       |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c          |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |    4=20
 drivers/net/ethernet/ti/cpsw.c                           |    2=20
 drivers/net/geneve.c                                     |    4=20
 drivers/net/vxlan.c                                      |    8=20
 include/linux/netdevice.h                                |    5=20
 include/linux/skbuff.h                                   |    5=20
 include/linux/time.h                                     |   13 +
 include/net/ip.h                                         |    5=20
 include/net/ipv6.h                                       |    2=20
 include/net/ipv6_stubs.h                                 |    6=20
 include/net/page_pool.h                                  |   52 +-----
 include/net/tcp.h                                        |   27 ++-
 include/net/xdp_priv.h                                   |    4=20
 include/trace/events/xdp.h                               |   19 --
 net/bridge/br_device.c                                   |    6=20
 net/core/dev.c                                           |    3=20
 net/core/flow_dissector.c                                |    5=20
 net/core/lwt_bpf.c                                       |    4=20
 net/core/page_pool.c                                     |  122 +++++++++-=
-----
 net/core/skbuff.c                                        |   10 -
 net/core/xdp.c                                           |  117 +++++-----=
----
 net/dccp/ipv6.c                                          |    6=20
 net/hsr/hsr_device.c                                     |    9 -
 net/ipv4/devinet.c                                       |    5=20
 net/ipv4/gre_demux.c                                     |    2=20
 net/ipv4/ip_output.c                                     |   13 -
 net/ipv4/tcp_output.c                                    |    5=20
 net/ipv6/addrconf_core.c                                 |   11 -
 net/ipv6/af_inet6.c                                      |    4=20
 net/ipv6/datagram.c                                      |    2=20
 net/ipv6/inet6_connection_sock.c                         |    4=20
 net/ipv6/ip6_output.c                                    |    8=20
 net/ipv6/raw.c                                           |    2=20
 net/ipv6/syncookies.c                                    |    2=20
 net/ipv6/tcp_ipv6.c                                      |    4=20
 net/l2tp/l2tp_ip6.c                                      |    2=20
 net/mpls/af_mpls.c                                       |    7=20
 net/openvswitch/actions.c                                |    6=20
 net/openvswitch/conntrack.c                              |   11 +
 net/sched/act_mpls.c                                     |    7=20
 net/sched/sch_mq.c                                       |    1=20
 net/sched/sch_mqprio.c                                   |    3=20
 net/sctp/ipv6.c                                          |    4=20
 net/tipc/core.c                                          |   29 +--
 net/tipc/udp_media.c                                     |    9 -
 net/tls/tls_device.c                                     |    8=20
 net/tls/tls_main.c                                       |    4=20
 net/tls/tls_sw.c                                         |    8=20
 tools/testing/selftests/net/tls.c                        |    8=20
 59 files changed, 369 insertions(+), 329 deletions(-)

Aaron Conole (1):
      openvswitch: support asymmetric conntrack

Alexander Lobakin (1):
      net: dsa: fix flow dissection on Tx path

Cong Wang (1):
      gre: refetch erspan header from skb->data after pskb_may_pull()

Dust Li (1):
      net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues

Eran Ben Elisha (1):
      net/mlx5e: Fix TXQ indices to be sequential

Eric Dumazet (2):
      inet: protect against too small mtu values.
      tcp: md5: fix potential overestimation of TCP option space

Greg Kroah-Hartman (1):
      Linux 5.3.18

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix extra rx interrupt

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Huy Nguyen (1):
      net/mlx5e: Query global pause state before setting prio2buffer

Jonathan Lemon (2):
      page_pool: do not release pool until inflight =3D=3D 0.
      xdp: obtain the mem_id mutex before trying to remove an entry.

Martin Varghese (2):
      Fixed updating of ethertype in function skb_mpls_pop
      net: Fixed updating of ethertype in skb_mpls_push()

Mian Yousaf Kaukab (1):
      net: thunderx: start phy before starting autonegotiation

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Sabrina Dubroca (2):
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Taehee Yoo (2):
      tipc: fix ordering of tipc module init and exit routine
      hsr: fix a NULL pointer dereference in hsr_dev_xmit()

Valentin Vidic (1):
      net/tls: Fix return values to avoid ENOTSUPP

Vladyslav Tarasiuk (1):
      mqprio: Fix out-of-bounds access in mqprio_dump


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl36accACgkQONu9yGCS
aT6vkhAAqQajWGyP8bYG01LqCPxFGLGdQp0hAzNRr3UavBaJzQhZuMdMltCStaM8
ngxIBi3uj7XU8Pq9g4V0+Ut+hCnK6rh4FbCpdk62WkYWZbplPki1ERfRuLoDbucg
rbDfdsLp+nsImxVHpqn2dIZ34Omv3zrZ09V/v0MtggwJAGFdfIb6NWG7Wf6ucHHr
1M2OdrsYxL2kOnA96ynUIJeI7QP8jjcwFUTFLjG3qMILysvR5wdkYcycc2ryiDB5
r0vb+65VnyOGSZWKNHSIz4RlvNpu12o/cl5tY95/wPJ/HzqwsAYIGCYsfoYjGZmb
BFFCfzC8gNa6sqJ9B6ii/TuVzAb7rVdCxYVwDYjJg7i2QaGlV5G6OvPQapbz6eYv
fTNY7e6fPrfO88QsxpibY3Tn1EERQM/ik+EEAvUvX8fYJby27ok+gv9inMJDcly8
D1FI1jk5JNhaJByvnZVpUAwZY8dEgtUbYJT5mIlkpniJvHsfxzz9mPEXSRsytzZW
XIpzNZhXUH1Z5ikQJ2ZZmPUD24SKEvAT9ilKvwCobFm2V0Y05ZyFdCpXqAMrPxuC
pa3io1WkQqp7uuOpIJCjWgYEoWUYDaD46wxaxYCvZD7XTB1g4JHQArp9a9U+6kiO
bE34ashqpiXwkglBvf0RE5ZgBvnixFbx72evPnJP3FsLumuxkJI=
=4Vce
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
