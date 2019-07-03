Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA895E3F5
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfGCMaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfGCMaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:30:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410A8218A0;
        Wed,  3 Jul 2019 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562157010;
        bh=QoEVWobWH6Ft2lzYEf/5PDNDWCIe6CtlQY47wSk1wmE=;
        h=Date:From:To:Cc:Subject:From;
        b=RUTE/KwBNsbhMAS3zyJCdYJQzDukC4uSLh/FqVMY6/NcGBbj+mLLY4Zfry1QyIQD9
         RkfrovuMqnwzkTNmp+6mO028do4hQmvNjdCPzqV2ZrQidHvvHWpZsHhCckJREZljQx
         KfaVxwu9Mh5KOnCTgF0sF/Tup1ThW9Cg5UoHOLRQ=
Date:   Wed, 3 Jul 2019 14:30:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.16
Message-ID: <20190703123008.GA4102@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.16 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/robust-futexes.txt                          |    3=20
 Makefile                                                  |    2=20
 arch/arm64/Makefile                                       |    2=20
 arch/arm64/include/asm/futex.h                            |    4=20
 arch/arm64/include/asm/insn.h                             |    8=20
 arch/arm64/kernel/insn.c                                  |   40 +++
 arch/arm64/net/bpf_jit.h                                  |    4=20
 arch/arm64/net/bpf_jit_comp.c                             |   28 +-
 arch/mips/include/asm/mips-gic.h                          |   30 ++
 arch/x86/kernel/cpu/bugs.c                                |   11=20
 arch/x86/kernel/cpu/microcode/core.c                      |   15 -
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                    |   35 +-
 drivers/clk/socfpga/clk-s10.c                             |    4=20
 drivers/clk/tegra/clk-tegra210.c                          |    2=20
 drivers/firmware/efi/efi.c                                |   12=20
 drivers/gpu/drm/i915/i915_drv.h                           |    6=20
 drivers/gpu/drm/i915/intel_audio.c                        |   62 ++++
 drivers/gpu/drm/i915/intel_cdclk.c                        |  185 +++++++++=
+----
 drivers/gpu/drm/i915/intel_display.c                      |   57 +++-
 drivers/gpu/drm/i915/intel_drv.h                          |   21 +
 drivers/infiniband/core/addr.c                            |   16 -
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c                  |    5=20
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c                  |    5=20
 drivers/irqchip/irq-mips-gic.c                            |    4=20
 drivers/md/dm-init.c                                      |    6=20
 drivers/md/dm-log-writes.c                                |   23 +
 drivers/net/bonding/bond_main.c                           |    2=20
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c       |   10=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           |    1=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h           |    1=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   19 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c     |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |   22 +
 drivers/net/team/team.c                                   |    2=20
 drivers/net/tun.c                                         |   19 -
 drivers/net/usb/qmi_wwan.c                                |    2=20
 drivers/scsi/vmw_pvscsi.c                                 |    6=20
 fs/binfmt_flat.c                                          |   23 -
 fs/inode.c                                                |    2=20
 fs/io_uring.c                                             |    5=20
 fs/nfs/flexfilelayout/flexfilelayoutdev.c                 |    2=20
 fs/notify/fanotify/fanotify.c                             |    4=20
 fs/notify/mark.c                                          |   14 -
 fs/proc/array.c                                           |    2=20
 include/asm-generic/futex.h                               |    8=20
 include/linux/bpf-cgroup.h                                |    8=20
 include/linux/fsnotify_backend.h                          |    4=20
 include/linux/xarray.h                                    |    1=20
 include/net/tls.h                                         |   15 -
 include/uapi/linux/bpf.h                                  |    6=20
 kernel/bpf/lpm_trie.c                                     |    9=20
 kernel/bpf/syscall.c                                      |    8=20
 kernel/bpf/verifier.c                                     |   12=20
 kernel/cpu.c                                              |    3=20
 kernel/trace/bpf_trace.c                                  |  100 ++++++-
 kernel/trace/trace_branch.c                               |    4=20
 lib/xarray.c                                              |   12=20
 mm/hugetlb.c                                              |   29 +-
 mm/memory-failure.c                                       |    7=20
 mm/mempolicy.c                                            |    2=20
 mm/page_idle.c                                            |    4=20
 mm/page_io.c                                              |    7=20
 net/core/filter.c                                         |    2=20
 net/core/sock.c                                           |    3=20
 net/ipv4/raw.c                                            |    2=20
 net/ipv4/udp.c                                            |   10=20
 net/ipv6/udp.c                                            |    8=20
 net/packet/af_packet.c                                    |   23 +
 net/packet/internal.h                                     |    1=20
 net/sctp/endpointola.c                                    |    8=20
 net/sunrpc/xprtsock.c                                     |   16 -
 net/tipc/core.c                                           |   12=20
 net/tipc/netlink_compat.c                                 |   18 +
 net/tipc/udp_media.c                                      |    8=20
 net/tls/tls_main.c                                        |    3=20
 tools/testing/selftests/bpf/test_lpm_map.c                |   41 ++-
 76 files changed, 829 insertions(+), 293 deletions(-)

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not

Amir Goldstein (1):
      fanotify: update connector fsid cache on add mark

Ard Biesheuvel (1):
      efi/memreserve: deal with memreserve entries in unmapped memory

Bj=F8rn Mork (1):
      qmi_wwan: Fix out-of-bounds read

Colin Ian King (1):
      mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Daniel Borkmann (2):
      bpf: fix unconnected udp hooks
      bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd

Dinh Nguyen (1):
      clk: socfpga: stratix10: fix divider entry for the emac clocks

Dirk van der Merwe (1):
      net/tls: fix page double free on TX cleanup

Dmitry Bogdanov (1):
      net: aquantia: fix vlans not working over bridged network

Eric Dumazet (1):
      net/packet: fix memory leak in packet_set_ring()

Fei Li (1):
      tun: wake up waitqueues after IFF_UP is set

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations=3D parameter

Gen Zhang (1):
      dm init: fix incorrect uses of kstrndup()

Greg Kroah-Hartman (1):
      Linux 5.1.16

Huang Ying (1):
      mm, swap: fix THP swap out

Imre Deak (2):
      drm/i915: Save the old CDCLK atomic state
      drm/i915: Remove redundant store of logical CDCLK state

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Jann Horn (1):
      fs/binfmt_flat.c: make load_flat_shared_library() work

Jason Gunthorpe (1):
      RDMA: Directly cast the sockaddr union to sockaddr

Jean-Philippe Brucker (1):
      arm64: insn: Fix ldadd instruction encoding

Jens Axboe (1):
      io_uring: ensure req->file is cleared on allocation

JingYi Hou (1):
      net: remove duplicate fetch in sock_getsockopt

Johannes Weiner (1):
      mm: fix page cache convergence regression

John Ogness (1):
      fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Jon Hunter (1):
      clk: tegra210: Fix default rates for HDA clocks

Jonathan Lemon (1):
      bpf: lpm_trie: check left child of last leftmost node for NULL

Martin KaFai Lau (2):
      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err

Martynas Pumputis (1):
      bpf: simplify definition of BPF_FIB_LOOKUP related flags

Matt Mullins (1):
      bpf: fix nested bpf tracepoints with per-cpu data

Naoya Horiguchi (2):
      mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fai=
ls
      mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero on !=
PageHuge

Nathan Chancellor (1):
      arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS

Neil Horman (1):
      af_packet: Block execution of tasks waiting for transmit to complete =
in AF_PACKET

Paul Burton (1):
      irqchip/mips-gic: Use the correct local interrupt map registers

Reinette Chatre (1):
      x86/resctrl: Prevent possible overrun during bitmap operations

Roland Hii (2):
      net: stmmac: fixed new system time seconds value calculation
      net: stmmac: set IC bit when transmitting frames with HW timestamp

Sasha Levin (1):
      Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while=
 loop

Thomas Gleixner (1):
      x86/microcode: Fix the microcode load on CPU hotplug for real

Trond Myklebust (2):
      NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O
      SUNRPC: Fix up calculation of client message length

Ville Syrj=E4l=E4 (2):
      drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is enabled
      drm/i915: Skip modeset for cdclk changes if possible

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
      bonding: Always enable vlan tx offload
      team: Always enable vlan tx offload

zhangyi (F) (1):
      dm log writes: make sure super sector log updates are written in order

zhong jiang (1):
      mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0cn9AACgkQONu9yGCS
aT4ZNQ/7BaYE0fx8TZ8huxpBMdzC7dLNQhY7CjDq7c020HYPUcObtB1qQG9JoekM
qe9BiSlSTTbjyHgLaFbYCxZU+gK8XWM14mpo5Yd5Wx3oK7qWHVjkrGJ+DbSTCoYx
CxWzxvlLxdhzlO8aMxsCHBydfDFr504ElpgOkiVKrN+YJBeIz7RXrtsQVCuhQqKM
vk11Tlvy2HBpO5gjfaUwjTJywduVZLLFUv5ljR/rK9MgLsgzP6JEww5fdhhwUY1Z
nVwNiySnUYVwmjPC4a9JXiiVrPoFX8VyvJC1WipRBNbtfGt9sCDX4VxYT7L8jwNc
f00zxwcGPRGIFcLq4wSN3RtmZINgEWXzVfoW0nttGM616D7mFJI1SKAdF5jGxzDZ
F5YT/XiEWZo/g7NxExlk5nLeptCI0Myzh4AdIyTGBXqBAeO2oJhdTRPQ6267AnuH
ZwYpTtVNtrjwGs1x91WdRYGx0CjJVvQdiYNgOHWt0qeSC8DTpBXdojBEprs+T904
108+ZfdKuTfkdZvGDVmoOc0KLS1AHD0qg1o672S4xXaMpAwPv4FiZlOO4Ssqe3Bh
SI4sIAoaWoQp+tiPP29gIzRR7IJ7q56/IQUlbP6+7HTS8WYOcMTUmNPGb4wEYVEa
wX14/gqxYXFlqLdT2wofQg8Y0YROVX2JEdlvYN59eNJJFXBVlYM=
=hY/2
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
