Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC2116F4
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfEBKMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 06:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfEBKMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 06:12:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15CC20652;
        Thu,  2 May 2019 10:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556791954;
        bh=vkNKOY9AI5Znnh1G8TWnt8heszOH3v6DaO8h/mjySiI=;
        h=Date:From:To:Cc:Subject:From;
        b=NAkta2F1h8ZUxT+Sa/Zm7DrZkh5z6edycOjGyvTqGUiKpNFl22sutCm3zO/VC6/qI
         hb7d+azXy1Jo1iNOmJtGnf/yBXRWJJD1drdjaXjTO/E/IG0IiTIrkCB8XyjNw7K+kt
         6WZ2Dr9Cm2O2GLvrcgzxX/DklaaL5/rZmUxhcrE4=
Date:   Thu, 2 May 2019 12:12:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.172
Message-ID: <20190502101231.GA6962@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.172 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt                  |    6=20
 Documentation/networking/ip-sysctl.txt               |    1=20
 Makefile                                             |    2=20
 arch/arm/boot/compressed/head.S                      |   16=20
 arch/mips/kernel/scall64-o32.S                       |    2=20
 drivers/block/loop.c                                 |   42 +-
 drivers/block/loop.h                                 |    1=20
 drivers/dma/sh/rcar-dmac.c                           |    4=20
 drivers/gpu/drm/vc4/vc4_crtc.c                       |    2=20
 drivers/hwtracing/intel_th/gth.c                     |    2=20
 drivers/infiniband/sw/rdmavt/mr.c                    |   17=20
 drivers/input/rmi4/rmi_f11.c                         |    2=20
 drivers/net/ethernet/intel/fm10k/fm10k_main.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/port.c       |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    4=20
 drivers/net/slip/slhc.c                              |    2=20
 drivers/net/team/team.c                              |    6=20
 drivers/usb/core/driver.c                            |   23 +
 drivers/usb/core/hub.c                               |   16=20
 drivers/usb/core/message.c                           |    3=20
 drivers/usb/core/sysfs.c                             |    5=20
 drivers/usb/core/usb.h                               |   10=20
 fs/ceph/dir.c                                        |    6=20
 fs/ceph/mds_client.c                                 |    9=20
 fs/ceph/snap.c                                       |    7=20
 fs/cifs/inode.c                                      |    4=20
 fs/nfs/super.c                                       |    3=20
 fs/nfsd/nfs4callback.c                               |    8=20
 fs/nfsd/state.h                                      |    1=20
 fs/proc/proc_sysctl.c                                |    6=20
 include/net/inet_frag.h                              |   16=20
 include/net/ipv6.h                                   |   29 -
 include/net/ipv6_frag.h                              |  111 +++++
 kernel/sched/fair.c                                  |    4=20
 kernel/trace/ring_buffer.c                           |    2=20
 kernel/trace/trace.c                                 |    5=20
 net/bridge/netfilter/ebtables.c                      |    3=20
 net/ieee802154/6lowpan/reassembly.c                  |    2=20
 net/ipv4/inet_fragment.c                             |  293 +++++++++++++++
 net/ipv4/ip_fragment.c                               |  295 +--------------
 net/ipv4/route.c                                     |   32 +
 net/ipv4/sysctl_net_ipv4.c                           |    5=20
 net/ipv6/netfilter/nf_conntrack_reasm.c              |  273 ++++----------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c            |    3=20
 net/ipv6/reassembly.c                                |  361 ++++----------=
-----
 net/openvswitch/conntrack.c                          |    1=20
 net/rds/ib_fmr.c                                     |   11=20
 net/rds/ib_rdma.c                                    |    3=20
 net/sunrpc/cache.c                                   |    3=20
 net/tipc/netlink_compat.c                            |   24 +
 net/vmw_vsock/virtio_transport_common.c              |   22 -
 scripts/Kbuild.include                               |    4=20
 54 files changed, 870 insertions(+), 854 deletions(-)

Adalbert Laz=C4=83r (1):
      vsock/virtio: fix kernel panic from virtio_transport_reset_no_sock

Alexander Shishkin (1):
      intel_th: gth: Fix an off-by-one in output unassigning

Amit Cohen (1):
      mlxsw: spectrum: Fix autoneg status in ethtool

Ard Biesheuvel (1):
      ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the ca=
che

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load

Diana Craciun (2):
      powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2 bo=
ot arg
      Documentation: Add nospectre_v1 parameter

Dirk Behme (1):
      dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid

Erez Alfasi (1):
      net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query

Eric Dumazet (2):
      ipv4: add sanity checks in ipv4_link_failure()
      ipv6: frags: fix a lockdep false positive

Florian Westphal (2):
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
      ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module

Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error

Greg Kroah-Hartman (2):
      Revert "block/loop: Use global lock for ioctl() operation."
      Linux 4.9.172

Hangbin Liu (1):
      team: fix possible recursive locking when add slaves

Jeff Layton (1):
      ceph: ensure d_name stability in ceph_dentry_hash()

Josh Collier (1):
      IB/rdmavt: Fix frwr memory registration

Kai-Heng Feng (2):
      USB: Add new USB LPM helpers
      USB: Consolidate LPM checks to avoid enabling LPM twice

Linus Torvalds (1):
      slip: make slhc_free() silently accept an error pointer

Lucas Stach (1):
      Input: synaptics-rmi4 - write config register values to the right off=
set

Maarten Lankhorst (2):
      drm/vc4: Fix memory leak during gpu reset.
      drm/vc4: Fix compilation error reported by kbuild test bot

Masahiro Yamada (1):
      kbuild: simplify ld-option implementation

NeilBrown (1):
      sunrpc: don't mark uninitialised items as VALID.

Peter Oskolkov (3):
      net: IP defrag: encapsulate rbtree defrag code into callable functions
      net: IP6 defrag: use rbtrees for IPv6 defrag
      net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c

Peter Zijlstra (1):
      trace: Fix preempt_enable_no_resched() abuse

Tetsuo Handa (1):
      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

Trond Myklebust (1):
      nfsd: Don't release the callback slot unless it was actually held

Vinod Koul (1):
      net: stmmac: move stmmac_check_ether_addr() to driver probe

Wenwen Wang (1):
      tracing: Fix a memory leak by early error exit in trace_pid_write()

Xie XiuQi (1):
      sched/numa: Fix a possible divide-by-zero

Xin Long (3):
      tipc: handle the err returned from cmd header function
      tipc: check bearer name with right length in tipc_nl_compat_bearer_en=
able
      tipc: check link name with right length in tipc_nl_compat_link_set

Yan, Zheng (1):
      ceph: fix ci->i_head_snapc leak

Yue Haibing (1):
      fm10k: Fix a potential NULL pointer dereference

YueHaibing (1):
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference

ZhangXiaoxu (1):
      ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Zhu Yanjun (1):
      net: rds: exchange of 8K and 1M pool


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzKwooACgkQONu9yGCS
aT7AsBAAtH3AnwXNA2Czi95JWwXnJbXy7oa/EXJ2PivpoTrxztdc8vJNK7UcpP8e
TaKzr5prlEcoKT9dfJ1IwZ4Muo0Luu7Pl++EHEgXH7SPa6gcmLzJ6OKR3Z/+oAF2
HKAnzqvkyUnVtYnYAmRTOfYL7B0MxXBQUU6taStbS8eKNnzW+CideB5pDgyJvh8o
FPYwp1ZoEIQM/K/RHUGHzqpnBVCBzpVcTTP2oWn6ljWxlqs+XIKBraqHzQAmPHXZ
XBikbmJnAERDOVg3JPcNL98S8JltFn37asvhK1/EljkK+PPNKsoFbGiVwZ9moxyw
sjkT6Qs4QwZ8bRzcHnB4Gk2C6UOjzL6W2rId2bJASordKHjuFV24Gy+L8d+d/H+N
47AdkATp7e7DwsSvipoRM4siX5n+NWwtk4ENvANKABOG5AJYfU1jPyNLRkNRcMbr
8NqgVL4MNtIyMuOZbX79odqOKUzW8Vi5OBVHmKg34vDlq8DaMRQCYdreQhMFxS0b
7YucJBft1FiA+txqmUBUdl9VljpX+7gUNHcyONBvLtyabx9vH9i+EC7cfl9N6PuC
XWDZSvHGVLXEyXcqM4pJwDa39OD9gmYHwjrVRkwE2PCyDPVPsWy1iwUyYiKTi2LO
H15a6oDLEZyT0m/KL3J/F3H1Hbupji1kvMRg1/KID+GplLTf/S0=
=NwB3
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
