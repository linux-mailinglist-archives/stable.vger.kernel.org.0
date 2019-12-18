Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0729C125005
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 19:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfLRSDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 13:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfLRSDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 13:03:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF4B5218AC;
        Wed, 18 Dec 2019 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576692204;
        bh=FLXNDrzZdaxGkvzIEz0RnCFXmw+5khmRpY0c7YzoPn4=;
        h=Date:From:To:Cc:Subject:From;
        b=qPnu82jnpe5o9Pj2NqfCONBufSMCMFi63xP11SIBN+rLjoXQU+PbvPc3Kle/l0iLh
         HlBldv9/OUghhfIWp/LYEyfUNacUEWNjmNQqmGWXYfCTF5KpNDVbFLSvAq3IM1o3xm
         lh6VXqUubslB9X7KVID8+eWWhQkFsFtb5CNti3Uo=
Date:   Wed, 18 Dec 2019 19:03:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.5
Message-ID: <20191218180321.GA869477@kroah.com>
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

I'm announcing the release of the 5.4.5 kernel.

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

 Makefile                                                 |    2=20
 drivers/infiniband/core/addr.c                           |    7=20
 drivers/infiniband/sw/rxe/rxe_net.c                      |    8=20
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c        |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c |   27 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c      |    8=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c     |   15 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |   31 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c       |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c          |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c          |    2=20
 drivers/net/ethernet/mscc/ocelot.c                       |   14 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c          |   16 +
 drivers/net/ethernet/realtek/r8169_main.c                |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |    4=20
 drivers/net/ethernet/ti/cpsw.c                           |    2=20
 drivers/net/geneve.c                                     |    4=20
 drivers/net/vxlan.c                                      |    8=20
 include/linux/netdevice.h                                |    5=20
 include/linux/skbuff.h                                   |    5=20
 include/linux/time.h                                     |   13 +
 include/net/flow_dissector.h                             |    1=20
 include/net/flow_offload.h                               |   15 -
 include/net/ip.h                                         |    5=20
 include/net/ipv6.h                                       |    2=20
 include/net/ipv6_stubs.h                                 |    6=20
 include/net/page_pool.h                                  |   52 +-----
 include/net/tcp.h                                        |   27 ++-
 include/net/xdp_priv.h                                   |    4=20
 include/trace/events/xdp.h                               |   19 --
 net/bridge/br_device.c                                   |    6=20
 net/core/dev.c                                           |    3=20
 net/core/flow_dissector.c                                |   42 +++--
 net/core/flow_offload.c                                  |   45 ++---
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
 net/netfilter/nf_tables_offload.c                        |    6=20
 net/openvswitch/actions.c                                |    6=20
 net/openvswitch/conntrack.c                              |   11 +
 net/sched/act_ct.c                                       |   13 +
 net/sched/act_mpls.c                                     |    7=20
 net/sched/cls_api.c                                      |   60 ++++---
 net/sched/cls_flower.c                                   |  118 ++++++++--=
----
 net/sched/sch_mq.c                                       |    1=20
 net/sched/sch_mqprio.c                                   |    3=20
 net/sctp/ipv6.c                                          |    4=20
 net/tipc/core.c                                          |   29 +--
 net/tipc/udp_media.c                                     |    9 -
 net/tls/tls_device.c                                     |    8=20
 net/tls/tls_main.c                                       |    4=20
 net/tls/tls_sw.c                                         |    8=20
 tools/testing/selftests/net/tls.c                        |    8=20
 72 files changed, 575 insertions(+), 468 deletions(-)

Aaron Conole (2):
      openvswitch: support asymmetric conntrack
      act_ct: support asymmetric conntrack

Alexander Lobakin (1):
      net: dsa: fix flow dissection on Tx path

Aya Levin (2):
      net/mlx5e: Fix translation of link mode into speed
      net/mlx5e: ethtool, Fix analysis of speed setting

Cong Wang (1):
      gre: refetch erspan header from skb->data after pskb_may_pull()

Dust Li (1):
      net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues

Eran Ben Elisha (2):
      net/mlx5e: Fix TXQ indices to be sequential
      net/mlx5e: Fix SFF 8472 eeprom length

Eric Dumazet (3):
      inet: protect against too small mtu values.
      net_sched: validate TCA_KIND attribute in tc_chain_tmplt_add()
      tcp: md5: fix potential overestimation of TCP option space

Greg Kroah-Hartman (1):
      Linux 5.4.5

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix extra rx interrupt

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Heiner Kallweit (1):
      r8169: add missing RX enabling for WoL on RTL8125

Huy Nguyen (1):
      net/mlx5e: Query global pause state before setting prio2buffer

John Hurley (2):
      net: core: rename indirect block ingress cb function
      net: sched: allow indirect blocks to bind to clsact in TC

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

Roi Dayan (1):
      net/mlx5e: Fix freeing flow with kfree() and not kvfree()

Sabrina Dubroca (2):
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Shannon Nelson (1):
      ionic: keep users rss hash across lif reset

Taehee Yoo (2):
      tipc: fix ordering of tipc module init and exit routine
      hsr: fix a NULL pointer dereference in hsr_dev_xmit()

Valentin Vidic (1):
      net/tls: Fix return values to avoid ENOTSUPP

Vladimir Oltean (1):
      net: mscc: ocelot: unregister the PTP clock on deinit

Vladyslav Tarasiuk (1):
      mqprio: Fix out-of-bounds access in mqprio_dump

Yoshiki Komachi (1):
      cls_flower: Fix the behavior using port ranges with hw-offload


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl36aekACgkQONu9yGCS
aT6nLw//VFQkHXHR8b+HC6PEnnffsGdMbE0itA05Dq2XjsOYhSHKwzVVzieaLxn2
fH6kGtFfcs00tDS5Fs2eWmTFlNw+VWXrD6r9srnlSZ1Vk7d7ydjCGUf2kyNalwJG
HEwnheS+oAMDzz5QrwA7D7wHOci6p5bFfa7bsUzXB4jD8FRzNKoGF/O2gjv9tp6a
SoHZeiGB0/I4iuTQWYxg5EG0L5OTiuaXFz2JJuAvYwa3NRy40p6n1R7RtFoIw6EB
tDovInWuOfWsDgpeUOoaT/EhFi6/wkdP52GPUgpEz1nfDVoYpp84cr3HblvTqvru
DYxiveJUZVosIv3hp1VH4RQOC/dUilqnAwr5tjLi6RyMQHiaXFtKnXCMmO/OjbhR
upJDdcygLPr/Myp8pnytCSMLMSty7Wun5GA9fypOZKV0SUZkR7IHt5shWwnVvVup
crxhSZLJLwGMunQav7mcp6rZm9IsaJsBXniR4g3loRJWXgf9q1V6vmDTuyMvTeIx
4TLESu0RB3SxtQeviIYRpG7r2pOuraDES3IgvQRn6nmRgmEzpWKVJb9bgds1fyb6
T5TVTmHCLh1TWgO0kz28hOc9kCcgAMYc9EiGHbbqhWfRyIOKtbhy4GD+y5QoHg3D
J337GyXANpfUTq2vs4vM9hRN5lqcTTHef/uVwb9FPr2XgghVNW0=
=1qJ+
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
