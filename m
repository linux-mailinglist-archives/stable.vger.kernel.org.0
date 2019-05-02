Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4394111703
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 12:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfEBKO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 06:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfEBKO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 06:14:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A9820873;
        Thu,  2 May 2019 10:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556792095;
        bh=1d9O5c1OtC+i1sChUk+nWNBSOK25Teo6Q4jtw08C4Kw=;
        h=Date:From:To:Cc:Subject:From;
        b=bA8afSh28PUAlTMMF4M5Ga4lAHk72rTPckxHvEBQ8UPc5g36IuJc1cFpvh7EXLfBo
         wN0Rsv5XHr9ZrgWMifZC1jCbOlgCSaMp1lW5+UvFIWkTDXaBBDBKq/UJEHovp7V2Cs
         1Z/A6HqphvLWPGRhM1222C7FBanFVyCxQBWWyLb8=
Date:   Thu, 2 May 2019 12:14:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.11
Message-ID: <20190502101453.GA16617@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.11 kernel.

All users of the 5.0 kernel series must upgrade.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt               |    1=20
 Documentation/sysctl/vm.txt                          |   16 -
 Makefile                                             |    2=20
 arch/arm/boot/compressed/head.S                      |   16 +
 arch/arm64/mm/init.c                                 |    2=20
 arch/mips/kernel/scall64-o32.S                       |    2=20
 arch/powerpc/configs/skiroot_defconfig               |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S            |    2=20
 arch/powerpc/platforms/Kconfig.cputype               |    2=20
 arch/x86/Makefile                                    |    9=20
 arch/x86/events/intel/cstate.c                       |   10=20
 block/bfq-iosched.c                                  |   15 -
 block/bfq-iosched.h                                  |    2=20
 block/bfq-wf2q.c                                     |   17 +
 crypto/lrw.c                                         |    6=20
 crypto/xts.c                                         |    6=20
 drivers/android/binder_alloc.c                       |   18 -
 drivers/block/loop.c                                 |    5=20
 drivers/block/zram/zram_drv.c                        |    5=20
 drivers/dma/mediatek/mtk-cqdma.c                     |    2=20
 drivers/dma/sh/rcar-dmac.c                           |   30 ++
 drivers/gpio/gpio-eic-sprd.c                         |    1=20
 drivers/gpu/drm/i915/intel_fbdev.c                   |   12 -
 drivers/gpu/drm/ttm/ttm_bo.c                         |   10=20
 drivers/gpu/drm/ttm/ttm_memory.c                     |    5=20
 drivers/gpu/drm/vc4/vc4_crtc.c                       |    2=20
 drivers/hwtracing/intel_th/gth.c                     |    2=20
 drivers/infiniband/core/uverbs.h                     |    1=20
 drivers/infiniband/core/uverbs_main.c                |   52 ++++
 drivers/infiniband/hw/mlx5/main.c                    |   10=20
 drivers/infiniband/sw/rdmavt/mr.c                    |   17 -
 drivers/input/rmi4/rmi_f11.c                         |    2=20
 drivers/net/ethernet/intel/fm10k/fm10k_main.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c     |   24 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h     |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/port.c       |    4=20
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h         |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |    6=20
 drivers/net/ethernet/socionext/netsec.c              |   11 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c     |    8=20
 drivers/net/slip/slhc.c                              |    2=20
 drivers/net/team/team.c                              |    7=20
 drivers/net/wireless/mac80211_hwsim.c                |   19 +
 drivers/usb/core/driver.c                            |   23 +-
 drivers/usb/core/hub.c                               |   16 -
 drivers/usb/core/message.c                           |    3=20
 drivers/usb/core/sysfs.c                             |    5=20
 drivers/usb/core/usb.h                               |   10=20
 drivers/vfio/vfio_iommu_type1.c                      |   14 +
 fs/aio.c                                             |  200 ++++++++------=
-----
 fs/ceph/dir.c                                        |    6=20
 fs/ceph/mds_client.c                                 |   70 +++++-
 fs/ceph/snap.c                                       |    7=20
 fs/cifs/file.c                                       |   15 -
 fs/cifs/inode.c                                      |    4=20
 fs/cifs/misc.c                                       |   23 ++
 fs/cifs/smb2pdu.c                                    |    1=20
 fs/ext4/xattr.c                                      |    3=20
 fs/nfs/super.c                                       |    3=20
 fs/nfsd/nfs4callback.c                               |    8=20
 fs/nfsd/nfs4state.c                                  |   12 -
 fs/nfsd/state.h                                      |    1=20
 fs/proc/proc_sysctl.c                                |    6=20
 fs/splice.c                                          |    4=20
 include/drm/ttm/ttm_bo_driver.h                      |    1=20
 include/linux/etherdevice.h                          |   12 +
 include/linux/pipe_fs_i.h                            |    1=20
 include/net/netfilter/nf_tables.h                    |    6=20
 include/net/netrom.h                                 |    2=20
 kernel/sched/deadline.c                              |    3=20
 kernel/sched/fair.c                                  |    4=20
 kernel/trace/ring_buffer.c                           |    2=20
 kernel/trace/trace.c                                 |   33 +--
 kernel/workqueue.c                                   |    3=20
 lib/Kconfig.debug                                    |    1=20
 mm/page_alloc.c                                      |   13 +
 net/bridge/netfilter/ebtables.c                      |    3=20
 net/ipv4/route.c                                     |   32 ++-
 net/ipv4/sysctl_net_ipv4.c                           |    5=20
 net/ncsi/ncsi-rsp.c                                  |    6=20
 net/netfilter/nf_tables_api.c                        |   28 ++
 net/netfilter/nft_dynset.c                           |   13 -
 net/netfilter/nft_lookup.c                           |   13 -
 net/netfilter/nft_objref.c                           |   32 ++-
 net/netrom/af_netrom.c                               |   76 +++++--
 net/netrom/nr_loopback.c                             |    2=20
 net/netrom/nr_route.c                                |    2=20
 net/netrom/sysctl_net_netrom.c                       |    5=20
 net/rds/af_rds.c                                     |    3=20
 net/rds/bind.c                                       |    2=20
 net/rds/ib_fmr.c                                     |   11 +
 net/rds/ib_rdma.c                                    |    3=20
 net/rose/rose_loopback.c                             |   27 +-
 net/rxrpc/input.c                                    |   12 -
 net/rxrpc/local_object.c                             |    3=20
 net/sunrpc/cache.c                                   |    3=20
 net/tipc/netlink_compat.c                            |   24 +-
 net/tls/tls_device.c                                 |    4=20
 net/tls/tls_device_fallback.c                        |   13 -
 net/tls/tls_main.c                                   |    5=20
 net/tls/tls_sw.c                                     |    3=20
 sound/pci/hda/patch_realtek.c                        |   41 ++-
 105 files changed, 873 insertions(+), 395 deletions(-)

Achim Dahlhoff (1):
      dmaengine: sh: rcar-dmac: Fix glitch in dmaengine_tx_status

Al Viro (4):
      aio: fold lookup_kiocb() into its sole caller
      aio: keep io_event in aio_kiocb
      aio: store event at final iocb_put()
      Fix aio_poll() races

Alex Williamson (1):
      vfio/type1: Limit DMA mappings per container

Alexander Shishkin (1):
      intel_th: gth: Fix an off-by-one in output unassigning

Amit Cohen (1):
      mlxsw: spectrum: Fix autoneg status in ethtool

Ard Biesheuvel (1):
      ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the ca=
che

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load

Baolin Wang (1):
      gpio: eic: sprd: Fix incorrect irq type setting for the sync EIC

Bjorn Andersson (1):
      arm64: mm: Ensure tail of unaligned initrd is reserved

Christian K=F6nig (1):
      drm/ttm: fix re-init of global structures

Christophe Leroy (1):
      powerpc/vdso32: fix CLOCK_MONOTONIC on PPC64

Dan Carpenter (1):
      ext4: fix some error pointer dereferences

Daniel Borkmann (2):
      x86, retpolines: Raise limit for generating indirect calls from switc=
h-case
      x86/retpolines: Disable switch jump tables when retpolines are enabled

Dave Airlie (1):
      Revert "drm/i915/fbdev: Actually configure untiled displays"

Dirk Behme (1):
      dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid

Dongli Zhang (1):
      loop: do not print warn message if partition scan is successful

Erez Alfasi (1):
      net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query

Eric Dumazet (3):
      rxrpc: fix race condition in rxrpc_input_packet()
      ipv4: add sanity checks in ipv4_link_failure()
      net/rose: fix unbound loop in rose_loopback_timer()

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error

Greg Kroah-Hartman (1):
      Linux 5.0.11

Hangbin Liu (1):
      team: fix possible recursive locking when add slaves

Harry Pan (1):
      perf/x86/intel: Update KBL Package C-state events to also include PC8=
/PC9/PC10 counters

Herbert Xu (2):
      crypto: xts - Fix atomic sleep when walking skcipher
      crypto: lrw - Fix atomic sleep when walking skcipher

Ido Schimmel (1):
      mlxsw: pci: Reincrease PCI reset timeout

Ilias Apalodimas (1):
      net: socionext: replace napi_alloc_frag with the netdev variant on in=
it

Jakub Kicinski (3):
      net/tls: fix refcount adjustment in fallback
      net/tls: avoid potential deadlock in tls_set_device_offload_rx()
      net/tls: don't leak IV and record seq when offload fails

Jann Horn (1):
      tracing: Fix buffer_ref pipe ops

Jason Gunthorpe (3):
      RDMA/mlx5: Do not allow the user to write to the clock page
      RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
      RDMA/ucontext: Fix regression with disassociate

Jeff Layton (4):
      ceph: only use d_name directly when parent is locked
      ceph: ensure d_name stability in ceph_dentry_hash()
      nfsd: wake waiters blocked on file_lock before deleting it
      nfsd: wake blocked file lock waiters before sending callback

Johannes Berg (1):
      mac80211_hwsim: calculate if_combination.max_interfaces

Josh Collier (1):
      IB/rdmavt: Fix frwr memory registration

J=E9r=F4me Glisse (2):
      cifs: fix page reference leak with readv/writev
      zram: pass down the bvec we need to read into in the work struct

Kai-Heng Feng (2):
      USB: Add new USB LPM helpers
      USB: Consolidate LPM checks to avoid enabling LPM twice

Kailang Yang (1):
      ALSA: hda/realtek - Move to ACT_INIT state

Linus Torvalds (3):
      slip: make slhc_free() silently accept an error pointer
      pin iocb through aio.
      rdma: fix build errors on s390 and MIPS due to bad ZERO_PAGE use

Lucas Stach (1):
      Input: synaptics-rmi4 - write config register values to the right off=
set

Maarten Lankhorst (2):
      drm/vc4: Fix memory leak during gpu reset.
      drm/vc4: Fix compilation error reported by kbuild test bot

Maxim Mikityanskiy (2):
      net/mlx5e: Fix the max MTU check in case of XDP
      net/mlx5e: Fix use-after-free after xdp_return_frame

Mel Gorman (1):
      mm: do not boost watermarks to avoid fragmentation for the DISCONTIG =
memory model

Michael Ellerman (1):
      powerpc/mm/radix: Make Radix require HUGETLB_PAGE

NeilBrown (1):
      sunrpc: don't mark uninitialised items as VALID.

Pablo Neira Ayuso (2):
      netfilter: nf_tables: bogus EBUSY when deleting set after flush
      netfilter: nf_tables: bogus EBUSY in helper removal from transaction

Paolo Valente (1):
      block, bfq: fix use after free in bfq_bfqq_expire

Peter Zijlstra (1):
      trace: Fix preempt_enable_no_resched() abuse

Petr Machata (1):
      mlxsw: spectrum: Put MC TCs into DWRR mode

Ronnie Sahlberg (1):
      cifs: fix memory leak in SMB2_read

Shun-Chih Yu (1):
      dmaengine: mediatek-cqdma: fix wrong register usage in mtk_cqdma_start

Su Bao Cheng (1):
      stmmac: pci: Adjust IOT2000 matching

Tao Ren (1):
      net/ncsi: handle overflow when incrementing mac address

Tetsuo Handa (3):
      workqueue: Try to catch flush_work() without INIT_WORK().
      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.
      net/rds: Check address length before reading address family

Todd Kjos (1):
      binder: fix handling of misaligned binder object

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

YueHaibing (3):
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
      lib/Kconfig.debug: fix build error without CONFIG_BLOCK
      net: netrom: Fix error cleanup path of nr_proto_init

ZhangXiaoxu (1):
      ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Zhu Yanjun (1):
      net: rds: exchange of 8K and 1M pool

luca abeni (1):
      sched/deadline: Correctly handle active 0-lag timers


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzKwx0ACgkQONu9yGCS
aT5fdg//fDQRXFLnTWaai3YihJLjpEQ9wWEGZA1m7GWulZbxJmgJDYGEejjrrEd0
8B7JuTIvNn6FO5wSqaS/5WvggRluaHPVLajtWxhciZFXfdixlQVUY531/L5fEe3d
NTVZYZgAjuktyVN+lILyvdzC5zNvMt0/JM7s4N1S7IuvaIqT3U0YIr6KOUKhXJMP
zyCZ7rb4lRbMtWY/mfyRCIwowSuCRc6JfwmHFEYoSD914lQEFkSI/o+q+vg3EAXx
uL0ruPUYr4t3qH4OAIHo51Fjg09T4dap7McV0mn/feg2RtWrWJErHJv7ZfAK67KI
KaGzVPJjVTGsszdIpGNRLZtLcuBxI22qT3wLYjCZjRSWJDeVgEiG05iTcGSu3plU
CDudjwTv+ONFsPN+Tj7C4JPzgDwUidUCS5dNvcP9CzWF3hofNREyhfQkqg+ks7IL
OQV2b6oOWPV8Ek0zGy+67rCORm03GrT1vs0GFDx20I4hc1ufLhR7Xpemd24JDX+K
/eX9mcCJvVY7t2fmIjClP2xCAyw0utoLLjGvEsGqeM78Kz9A1KNS7N+ntG3SeYgU
Z1sGo51Pp/SbeuXFFvDKBnoQx1AHC9agerSGja0yNTT6t+aMr2C4fBpTPETHWnKV
qlT5D74OUUf6sbGd8gO3cZpHiW+vrQqkWRL9+DDreCHVAhmvTt0=
=17zb
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
