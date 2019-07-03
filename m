Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E043D5E3EF
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGCM3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfGCM3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:29:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A66218A0;
        Wed,  3 Jul 2019 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156980;
        bh=oCMB+wNQC0o2I4iSodAcrcd0pCm5XdC20N6aFBcPd80=;
        h=Date:From:To:Cc:Subject:From;
        b=ATHcjehHL9eK1t9FZOXD3OKsPc1cxRltNymu3UUZzQd4aCJQKhKrrMAcy4hNy7bNK
         PBqQbNz6C4S9e48zqOix8QI2jN1rh8EhY2sGBMaq+nrrUSjBHD/1Be7Qt7L3tb6u8G
         PFAW8GWBk80psMFkyMse5nYsIUNzBfQ71SWPK7T8=
Date:   Wed, 3 Jul 2019 14:29:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.57
Message-ID: <20190703122937.GA3972@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.57 kernel.

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

 Documentation/robust-futexes.txt                      |    3=20
 Makefile                                              |    2=20
 arch/arm64/Makefile                                   |    2=20
 arch/arm64/include/asm/futex.h                        |    4=20
 arch/arm64/include/asm/insn.h                         |    8=20
 arch/arm64/kernel/insn.c                              |   40 +
 arch/arm64/net/bpf_jit.h                              |    4=20
 arch/arm64/net/bpf_jit_comp.c                         |   28=20
 arch/mips/include/asm/mips-gic.h                      |   30=20
 arch/x86/kernel/cpu/bugs.c                            |   11=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c              |   35 -
 arch/x86/kernel/cpu/microcode/core.c                  |   15=20
 arch/x86/kvm/mmu.c                                    |   11=20
 drivers/clk/socfpga/clk-s10.c                         |    4=20
 drivers/infiniband/core/addr.c                        |   10=20
 drivers/infiniband/hw/hfi1/user_sdma.c                |   12=20
 drivers/infiniband/hw/hfi1/user_sdma.h                |    1=20
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c              |    5=20
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c              |    5=20
 drivers/irqchip/irq-mips-gic.c                        |    4=20
 drivers/md/dm-log-writes.c                            |   23=20
 drivers/misc/eeprom/at24.c                            |   43 -
 drivers/net/bonding/bond_main.c                       |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |   22=20
 drivers/net/team/team.c                               |    2=20
 drivers/net/tun.c                                     |   19=20
 drivers/net/usb/qmi_wwan.c                            |    2=20
 drivers/scsi/vmw_pvscsi.c                             |    6=20
 drivers/usb/dwc3/core.h                               |   15=20
 drivers/usb/dwc3/gadget.c                             |  160 +----
 drivers/usb/dwc3/gadget.h                             |   15=20
 fs/9p/acl.c                                           |    2=20
 fs/binfmt_flat.c                                      |   23=20
 fs/nfs/flexfilelayout/flexfilelayoutdev.c             |    2=20
 fs/proc/array.c                                       |    2=20
 include/asm-generic/futex.h                           |    8=20
 include/linux/bpf-cgroup.h                            |    8=20
 include/linux/sunrpc/xprt.h                           |    1=20
 include/net/9p/9p.h                                   |    4=20
 include/net/9p/client.h                               |   71 --
 include/uapi/linux/bpf.h                              |    6=20
 kernel/bpf/lpm_trie.c                                 |    9=20
 kernel/bpf/syscall.c                                  |    8=20
 kernel/bpf/verifier.c                                 |   12=20
 kernel/cpu.c                                          |    3=20
 kernel/trace/bpf_trace.c                              |  100 ++-
 kernel/trace/trace_branch.c                           |    4=20
 mm/hugetlb.c                                          |   29=20
 mm/memory-failure.c                                   |    7=20
 mm/mempolicy.c                                        |    2=20
 mm/page_idle.c                                        |    4=20
 net/9p/client.c                                       |  551 +++++++++----=
-----
 net/9p/mod.c                                          |    9=20
 net/9p/protocol.c                                     |   12=20
 net/9p/trans_common.c                                 |    1=20
 net/9p/trans_fd.c                                     |   64 +-
 net/9p/trans_rdma.c                                   |   37 -
 net/9p/trans_virtio.c                                 |   44 +
 net/9p/trans_xen.c                                    |   17=20
 net/core/filter.c                                     |    2=20
 net/core/sock.c                                       |    3=20
 net/ipv4/raw.c                                        |    2=20
 net/ipv4/udp.c                                        |   10=20
 net/ipv6/udp.c                                        |    8=20
 net/packet/af_packet.c                                |   23=20
 net/packet/internal.h                                 |    1=20
 net/sctp/endpointola.c                                |    8=20
 net/sunrpc/clnt.c                                     |    1=20
 net/sunrpc/xprt.c                                     |   91 +-
 net/tipc/core.c                                       |   12=20
 net/tipc/netlink_compat.c                             |   18=20
 net/tipc/udp_media.c                                  |    8=20
 tools/perf/builtin-help.c                             |    2=20
 tools/perf/ui/tui/helpline.c                          |    2=20
 tools/perf/util/header.c                              |    2=20
 tools/testing/selftests/bpf/test_lpm_map.c            |   41 +
 77 files changed, 1073 insertions(+), 746 deletions(-)

Adeodato Sim=F3 (1):
      net/9p: include trans_common.h to fix missing prototype warning.

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not

Arnaldo Carvalho de Melo (3):
      perf ui helpline: Use strlcpy() as a shorter form of strncpy() + expl=
icit set nul
      perf help: Remove needless use of strncpy()
      perf header: Fix unchecked usage of strncpy()

Bj=F8rn Mork (1):
      qmi_wwan: Fix out-of-bounds read

Colin Ian King (1):
      mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Dan Carpenter (1):
      9p: potential NULL dereference

Daniel Borkmann (2):
      bpf: fix unconnected udp hooks
      bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd

Dinh Nguyen (1):
      clk: socfpga: stratix10: fix divider entry for the emac clocks

Dominique Martinet (9):
      9p/xen: fix check for xenbus_read error in front_probe
      9p: embed fcall in req to round down buffer allocs
      9p: add a per-client fcall kmem_cache
      9p/rdma: do not disconnect on down_interruptible EAGAIN
      9p: acl: fix uninitialized iattr access
      9p/rdma: remove useless check in cm_event_handler
      9p: p9dirent_read: check network-provided name length
      9p/trans_fd: abort p9_read_work if req status changed
      9p/trans_fd: put worker reqs on destroy

Eric Dumazet (1):
      net/packet: fix memory leak in packet_set_ring()

Fei Li (1):
      tun: wake up waitqueues after IFF_UP is set

Felipe Balbi (7):
      usb: dwc3: gadget: combine unaligned and zero flags
      usb: dwc3: gadget: track number of TRBs per request
      usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()
      usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()
      usb: dwc3: gadget: introduce cancelled_list
      usb: dwc3: gadget: move requests to cancelled_list
      usb: dwc3: gadget: remove wait_end_transfer

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations=3D parameter

Greg Kroah-Hartman (1):
      Linux 4.19.57

Jack Pham (1):
      usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Jann Horn (1):
      fs/binfmt_flat.c: make load_flat_shared_library() work

Jason Gunthorpe (1):
      RDMA: Directly cast the sockaddr union to sockaddr

Jean-Philippe Brucker (1):
      arm64: insn: Fix ldadd instruction encoding

JingYi Hou (1):
      net: remove duplicate fetch in sock_getsockopt

John Ogness (1):
      fs/proc/array.c: allow reporting eip/esp for all coredumping threads

John Stultz (1):
      Revert "usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup"

Jonathan Lemon (1):
      bpf: lpm_trie: check left child of last leftmost node for NULL

Martin KaFai Lau (2):
      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err

Martynas Pumputis (1):
      bpf: simplify definition of BPF_FIB_LOOKUP related flags

Matt Mullins (1):
      bpf: fix nested bpf tracepoints with per-cpu data

Matthew Wilcox (1):
      9p: Use a slab for allocating requests

Mike Marciniszyn (1):
      IB/hfi1: Close PSM sdma_progress sleep window

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

Sean Christopherson (1):
      KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while=
 loop

Thinh Nguyen (1):
      usb: dwc3: Reset num_trbs after skipping

Thomas Gleixner (1):
      x86/microcode: Fix the microcode load on CPU hotplug for real

Tomas Bortoli (3):
      9p: rename p9_free_req() function
      9p: Add refcount to p9_req_t
      9p: Rename req to rreq in trans_fd

Trond Myklebust (2):
      NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O
      SUNRPC: Clean up initialisation of the struct rpc_rqst

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
      bonding: Always enable vlan tx offload
      team: Always enable vlan tx offload

zhangyi (F) (1):
      dm log writes: make sure super sector log updates are written in order

zhong jiang (1):
      mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0cn7EACgkQONu9yGCS
aT72rRAA2FfLLzC3NglVIiS4kv5xE/u7MBwSf2wTU9aJhJ+V0IZPjl3aejlmCe2H
4zz74R/Pdy9LIR7hZoecqssZL+45pUhAL/20gqHqpHYKzyF/8x+ygntNTgr3Us3y
8kf4u4eUXDaFOW6QYT2MLTh2VD1HRrfnqyFxbqbYSgz8tzjwbUMRAA0tjJGdp4c/
BPnYTbjmMT+0Y3lccifM7VUBPpKyxtTyy1eMDkdkRvgWD/MJrQLF7Fa4Eh6lblMA
wYg5fLIusk0AvY+SWavwJqk+eMEcv+aVXBtRE3E13F0m1DX4fuaSs/gV90oaCTTa
Dx4tCvpkUI5ZYNU3auooLTygTI+A9YTkmEscn/3yMYSyPBkSCzmBzEvXs5gei0YB
+lF9DAItGD2bfZtxSsB/tDzWCw8F+zg2Ewqxmu4yMeCslnkDZ+ITlCwUh+/w1o0n
4bMhv8fdNWd2rpwOOGNpvcx484OTuNETnw6gs5feHhY9T5gNss/P7UaoBEhTVvJY
SRuyZ/c0kIYRKkLdXmCll6xf/lfMruppVA6UYoImYoIZJZKgAilN2O+niw7HTNlq
6LAR6KSai9jUyxR9JVta0zIeOwVFpu3EH9cT+oD/GUym7DERKv74B/j9KNrgEk6/
keTBPmGw3hXLa3D43cI9n3+NBv/Hk6mOt53goZ5ej8hQ5Q50nl4=
=13AU
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
