Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4718116F9
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 12:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfEBKOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 06:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfEBKOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 06:14:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDD920652;
        Thu,  2 May 2019 10:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556792056;
        bh=Y8IRlkxd6ErWWn211ilry3F/2Q8W4W0+xGjrrkfrNP4=;
        h=Date:From:To:Cc:Subject:From;
        b=SMh06PFL6G0BZQ8a/qJLD91yeR/C06klSpjJO+bSaSn5eBECS+KAFzdvSB++qhb9z
         h/eAOmuNlWqmRSmw7XX6+3nJtxB20C8o5ITMA1EEMkE3L6xyOiA5M4De35F8/d+D9T
         ZIE1cjfXT5CX9srmwvWNz+X9K+S/HQz/XXg6fmUE=
Date:   Thu, 2 May 2019 12:14:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.115
Message-ID: <20190502101413.GA14182@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.115 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt      |    6 +
 Documentation/networking/ip-sysctl.txt               |    1=20
 Makefile                                             |    2=20
 arch/arm/boot/compressed/head.S                      |   16 ++++
 arch/mips/kernel/scall64-o32.S                       |    2=20
 arch/x86/Makefile                                    |    9 ++
 drivers/android/binder_alloc.c                       |   18 ++--
 drivers/block/loop.c                                 |   58 +++++++--------
 drivers/block/loop.h                                 |    1=20
 drivers/block/zram/zram_drv.c                        |    5 -
 drivers/dma/sh/rcar-dmac.c                           |    4 -
 drivers/gpu/drm/i915/intel_fbdev.c                   |   12 +--
 drivers/gpu/drm/vc4/vc4_crtc.c                       |    2=20
 drivers/hwtracing/intel_th/gth.c                     |    2=20
 drivers/infiniband/sw/rdmavt/mr.c                    |   17 ++--
 drivers/input/rmi4/rmi_f11.c                         |    2=20
 drivers/md/dm-integrity.c                            |    6 -
 drivers/net/ethernet/intel/fm10k/fm10k_main.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/port.c       |    4 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |    4 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    4 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c     |    8 +-
 drivers/net/slip/slhc.c                              |    2=20
 drivers/net/team/team.c                              |    6 +
 drivers/usb/core/driver.c                            |   23 +++++-
 drivers/usb/core/hub.c                               |   16 +---
 drivers/usb/core/message.c                           |    3=20
 drivers/usb/core/sysfs.c                             |    5 +
 drivers/usb/core/usb.h                               |   10 ++
 drivers/vfio/vfio_iommu_type1.c                      |   14 +++
 fs/ceph/dir.c                                        |    6 +
 fs/ceph/mds_client.c                                 |   70 ++++++++++++++=
++---
 fs/ceph/snap.c                                       |    7 +
 fs/cifs/inode.c                                      |    4 +
 fs/ext4/xattr.c                                      |    3=20
 fs/nfs/super.c                                       |    3=20
 fs/nfsd/nfs4callback.c                               |    8 +-
 fs/nfsd/state.h                                      |    1=20
 fs/proc/proc_sysctl.c                                |    6 +
 fs/splice.c                                          |    4 -
 include/linux/pipe_fs_i.h                            |    1=20
 kernel/sched/deadline.c                              |    3=20
 kernel/sched/fair.c                                  |    4 +
 kernel/trace/ring_buffer.c                           |    2=20
 kernel/trace/trace.c                                 |   33 ++++----
 lib/Kconfig.debug                                    |    1=20
 mm/memory.c                                          |    9 +-
 net/bridge/netfilter/ebtables.c                      |    3=20
 net/ipv4/route.c                                     |   32 ++++++--
 net/ipv4/sysctl_net_ipv4.c                           |    5 +
 net/netfilter/ipvs/ip_vs_ctl.c                       |    3=20
 net/rds/ib_fmr.c                                     |   11 ++
 net/rds/ib_rdma.c                                    |    3=20
 net/rose/af_rose.c                                   |   17 ++--
 net/rose/rose_link.c                                 |   16 +---
 net/rose/rose_loopback.c                             |   36 +++++----
 net/rose/rose_route.c                                |    8 +-
 net/rose/rose_timer.c                                |   30 +++-----
 net/sunrpc/cache.c                                   |    3=20
 net/tipc/netlink_compat.c                            |   24 +++++-
 net/vmw_vsock/virtio_transport_common.c              |   22 ++++-
 scripts/Kbuild.include                               |    4 -
 63 files changed, 428 insertions(+), 220 deletions(-)

Adalbert Laz=C4=83r (1):
      vsock/virtio: fix kernel panic from virtio_transport_reset_no_sock

Alex Williamson (1):
      vfio/type1: Limit DMA mappings per container

Alexander Shishkin (1):
      intel_th: gth: Fix an off-by-one in output unassigning

Amit Cohen (1):
      mlxsw: spectrum: Fix autoneg status in ethtool

Andrea Claudi (1):
      ipvs: fix warning on unused variable

Ard Biesheuvel (1):
      ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the ca=
che

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load

Dan Carpenter (1):
      ext4: fix some error pointer dereferences

Daniel Borkmann (2):
      x86, retpolines: Raise limit for generating indirect calls from switc=
h-case
      x86/retpolines: Disable switch jump tables when retpolines are enabled

Dave Airlie (1):
      Revert "drm/i915/fbdev: Actually configure untiled displays"

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
      net/rose: fix unbound loop in rose_loopback_timer()

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error

Greg Kroah-Hartman (2):
      Revert "block/loop: Use global lock for ioctl() operation."
      Linux 4.14.115

Hangbin Liu (1):
      team: fix possible recursive locking when add slaves

Jan Kara (1):
      mm: Fix warning in insert_pfn()

Jann Horn (1):
      tracing: Fix buffer_ref pipe ops

Jeff Layton (2):
      ceph: only use d_name directly when parent is locked
      ceph: ensure d_name stability in ceph_dentry_hash()

Josh Collier (1):
      IB/rdmavt: Fix frwr memory registration

J=C3=A9r=C3=B4me Glisse (1):
      zram: pass down the bvec we need to read into in the work struct

Kai-Heng Feng (2):
      USB: Add new USB LPM helpers
      USB: Consolidate LPM checks to avoid enabling LPM twice

Kees Cook (1):
      net/rose: Convert timers to use timer_setup()

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

Mikulas Patocka (1):
      dm integrity: change memcmp to strncmp in dm_integrity_ctr

NeilBrown (1):
      sunrpc: don't mark uninitialised items as VALID.

Peter Zijlstra (1):
      trace: Fix preempt_enable_no_resched() abuse

Su Bao Cheng (1):
      stmmac: pci: Adjust IOT2000 matching

Tetsuo Handa (1):
      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

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

YueHaibing (2):
      lib/Kconfig.debug: fix build error without CONFIG_BLOCK
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference

ZhangXiaoxu (1):
      ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Zhu Yanjun (1):
      net: rds: exchange of 8K and 1M pool

luca abeni (1):
      sched/deadline: Correctly handle active 0-lag timers


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzKwvUACgkQONu9yGCS
aT7TvQ//RcYAbQh+b15DDrwplzW48bVDQP69oESKDXQfggKcA86r3wTPGRwxV8FW
6EYIGcAlnMGYqOVIDndLRJvUIfmay7ihzpeVpm645mrUbMUKc7UgksWxTy/hT9HH
AAkj0l59i/wOphu8O/muYhq57uvLtmOuw3w+gWDPl3q2MUBzJ+ZRHjT4kcJmYnND
1V1OASf6GslvZSY8kMkOFdlyppNyMEPGNdthWBUJvzRsMJgPQeTUE6MyxWnK7MY7
dfbUuC4HiHnST+7Im+fXlR/H/0NHY0e+yDn/QvRUYtI1LXRyYNsYHHpNkLtnPFCv
SGMCZrL4hwRIuecjvdpd/xeCO99G6lEfMmh30q6IKFyAjX2X6wn0b9iqVvJ3JvfW
xTLjmGkm0EpFvydeYA9L9gpd79pIIex80tCRsorjf1bopdCmTnPeep1UvKMRYv2h
iE/+QVtAo4SfXy8nJIo5uW9zwn5b9RaKO00mUcm92abFz1DvvlFeLjZb31S9wT4p
YTdhqQYZI/yL/HyRceCGrCQ00Qg8vD2CyrxCNz/F96nFIRZW1kaWRvR/vELMa/Vd
WyDokS8HnwqW9nEOwJaGRLlg81QFFwjlQ+R4G7UeY9n2YlQH7EWoUWU5jrQ8MVzn
NUkogKlPh4aPGSw3NsRy6EhTfMlkZs20GyN28yrFaoYVIw018FI=
=5SXW
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
