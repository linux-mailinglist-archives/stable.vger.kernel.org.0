Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A881F5E3EB
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfGCM3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfGCM3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:29:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F323218A0;
        Wed,  3 Jul 2019 12:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156955;
        bh=1k8nq4Q0NeVILTBK4iUOGo3VkIXJAUuSe1jLV0Lo4K4=;
        h=Date:From:To:Cc:Subject:From;
        b=0QzbESUe9CoR1drJzAlRUR9FQm64ewc4vYgUjmgRvi7zQazG7CSGYTNQa1tgmISpH
         KYxtTDsbGa65HAi8bKJqh8eE4R7i2/R0B/T1WaBkiFLKAOpNijC6z5Sjkaj347OCQY
         kOPqDEp6kGEn35ErqF/CiLqQ3m5UvbUHY0NEHTp4=
Date:   Wed, 3 Jul 2019 14:29:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.132
Message-ID: <20190703122912.GA3831@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.132 kernel.

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

 Documentation/robust-futexes.txt                      |    3=20
 Makefile                                              |    2=20
 arch/arm64/include/asm/futex.h                        |    4=20
 arch/arm64/include/asm/insn.h                         |    8 +
 arch/arm64/kernel/insn.c                              |   40 +++++
 arch/arm64/net/bpf_jit.h                              |    4=20
 arch/arm64/net/bpf_jit_comp.c                         |   28 ++-
 arch/x86/kernel/cpu/bugs.c                            |   11 +
 arch/x86/kernel/cpu/microcode/core.c                  |   15 +-
 block/bio.c                                           |  131 +++++++++++++=
-----
 drivers/infiniband/hw/hfi1/user_sdma.c                |   12 -
 drivers/infiniband/hw/hfi1/user_sdma.h                |    1=20
 drivers/md/dm-log-writes.c                            |   23 ++-
 drivers/misc/eeprom/at24.c                            |  107 ++++++++++----
 drivers/net/bonding/bond_main.c                       |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |    2=20
 drivers/net/team/team.c                               |    2=20
 drivers/net/tun.c                                     |   19 +-
 drivers/net/usb/qmi_wwan.c                            |    4=20
 drivers/scsi/vmw_pvscsi.c                             |    6=20
 fs/9p/acl.c                                           |    2=20
 fs/binfmt_flat.c                                      |   23 ---
 fs/nfs/flexfilelayout/flexfilelayoutdev.c             |    2=20
 fs/proc/array.c                                       |    2=20
 include/asm-generic/futex.h                           |    8 -
 include/linux/bio.h                                   |    9 +
 include/linux/compiler.h                              |    5=20
 kernel/cpu.c                                          |    3=20
 kernel/trace/trace_branch.c                           |    4=20
 mm/mempolicy.c                                        |    2=20
 mm/page_idle.c                                        |    4=20
 net/9p/protocol.c                                     |   12 +
 net/9p/trans_common.c                                 |    1=20
 net/9p/trans_rdma.c                                   |    7=20
 net/9p/trans_xen.c                                    |    4=20
 net/core/sock.c                                       |    3=20
 net/ipv4/raw.c                                        |    2=20
 net/ipv4/udp.c                                        |    6=20
 net/ipv6/udp.c                                        |    4=20
 net/packet/af_packet.c                                |   23 ++-
 net/packet/internal.h                                 |    1=20
 net/sctp/endpointola.c                                |    8 -
 net/tipc/core.c                                       |   12 -
 net/tipc/netlink_compat.c                             |   18 ++
 net/tipc/udp_media.c                                  |    8 -
 tools/perf/builtin-help.c                             |    2=20
 tools/perf/ui/tui/helpline.c                          |    2=20
 tools/perf/util/header.c                              |    2=20
 48 files changed, 417 insertions(+), 186 deletions(-)

Adeodato Sim=F3 (1):
      net/9p: include trans_common.h to fix missing prototype warning.

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not

Arnaldo Carvalho de Melo (3):
      perf ui helpline: Use strlcpy() as a shorter form of strncpy() + expl=
icit set nul
      perf help: Remove needless use of strncpy()
      perf header: Fix unchecked usage of strncpy()

Christoph Hellwig (1):
      block: add a lower-level bio_add_page interface

Colin Ian King (1):
      mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Daniel Borkmann (1):
      bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd

Dominique Martinet (5):
      9p/xen: fix check for xenbus_read error in front_probe
      9p/rdma: do not disconnect on down_interruptible EAGAIN
      9p: acl: fix uninitialized iattr access
      9p/rdma: remove useless check in cm_event_handler
      9p: p9dirent_read: check network-provided name length

Eric Dumazet (1):
      net/packet: fix memory leak in packet_set_ring()

Fei Li (1):
      tun: wake up waitqueues after IFF_UP is set

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations=3D parameter

Greg Kroah-Hartman (1):
      Linux 4.14.132

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Jann Horn (1):
      fs/binfmt_flat.c: make load_flat_shared_library() work

Jean-Philippe Brucker (1):
      arm64: insn: Fix ldadd instruction encoding

JingYi Hou (1):
      net: remove duplicate fetch in sock_getsockopt

John Ogness (1):
      fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Kristian Evensen (1):
      qmi_wwan: Fix out-of-bounds read

Martin KaFai Lau (2):
      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err

Martin Wilck (1):
      block: bio_iov_iter_get_pages: pin more pages for multi-segment IOs

Mike Marciniszyn (1):
      IB/hfi1: Close PSM sdma_progress sleep window

Neil Horman (1):
      af_packet: Block execution of tasks waiting for transmit to complete =
in AF_PACKET

Roland Hii (1):
      net: stmmac: fixed new system time seconds value calculation

Sasha Levin (2):
      Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"
      Revert "compiler.h: update definition of unreachable()"

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while=
 loop

Thomas Gleixner (1):
      x86/microcode: Fix the microcode load on CPU hotplug for real

Trond Myklebust (1):
      NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O

Wang Xin (1):
      eeprom: at24: fix unexpected timeout under high load

Will Deacon (2):
      arm64: futex: Avoid copying out uninitialised stack in failed cmpxchg=
()
      futex: Update comments and docs about return values of arch futex code

Xin Long (4):
      sctp: change to hold sk after auth shkey is created successfully
      tipc: change to use register_pernet_device
      tipc: check msg->req data len in tipc_nl_compat_bearer_disable
      tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

YueHaibing (2):
      team: Always enable vlan tx offload
      bonding: Always enable vlan tx offload

zhangyi (F) (1):
      dm log writes: make sure super sector log updates are written in order

zhong jiang (1):
      mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0cn5UACgkQONu9yGCS
aT7vTBAAzrEzYZei2btZ1BU/bv1RTJWI9/BZk6jOC+U+Boy8Io61TuzvGvvGidzR
CGA2b1R5bwQdY71MhdbHIz5AdhJvbSc/Tcj0mwU+aZ4F9f466lKDW4dfT6lvCMBm
wxKUsV08f6xTcqYSCMPsQJT9t4oIakakxUM5gWtAga7euQSoaaXltOxWaPDWbNrm
oOvfYfE1cDjcxL3rdQYPuOcdbAGfJ/yLwQ4ErSkMYw9GiHTmlqjoDkcXuY98ziJC
LUL1D0HKwR5RO6OmpResqKGGVKMNvNdKijCjVtqAcRnH6K1tduEFx+XtNAucxMWq
pr5i1EuyJZiwVBHw7qgZiawA3Eg9185eiG9NMAle4TRVD7gaZDcsVwszMBSyRZUZ
Ogk34aPfROG9MCS9ujxQHNL0UnEv3yz2XU0pP9tiejRavvuYmHLW8jZoYOqRW/HC
l6sWz+j/iigesfkn1ZdIPIr1988vfOYmmw+CPnj1yALE/JlzQq4Sz6q0ajl3eOub
NhPHsEGvl2nYk/wcdv24mskTRX5mbt4fYOsiZfqU4KRNcnKIQEhsriZJF9yFUpf8
cLLD7FVdWxEkLlfXVNeon9QmYZFglyG+6BoL4Ea7QOkCotqgq28nVbi47EfZDpMG
pQ9E6Zc8X3K51afx5p9QuOlN3VnSqSmJbfL2QNkswGbTRGe5zOw=
=ofAN
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
