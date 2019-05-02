Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34B2116FD
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 12:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfEBKOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 06:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfEBKOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 06:14:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3697B20652;
        Thu,  2 May 2019 10:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556792077;
        bh=L80Xqm14mpzZnAPcM4Y8u7qA3Yi8DGuTi716/sHnVMw=;
        h=Date:From:To:Cc:Subject:From;
        b=q3DVP9fPHX22fQxviqo+mGYOmQg5mj7zrCQCHPAhH30R5yC0nHv9PU610yTmF/rUp
         S2Df0rOPVvudvzQhqJdhf1WeC/e2sfgqJjVzN7sCJn068mmjPL7nGMhhkXSgnhHJoT
         iMvdm9E5Mf5ENp77bh64wz/8c9qvW5GSA2eRddR8=
Date:   Thu, 2 May 2019 12:14:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.38
Message-ID: <20190502101435.GA15434@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.38 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt      |    2=20
 Documentation/networking/ip-sysctl.txt               |    1=20
 Makefile                                             |    2=20
 arch/arm/boot/compressed/head.S                      |   16=20
 arch/mips/kernel/scall64-o32.S                       |    2=20
 arch/powerpc/configs/skiroot_defconfig               |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S            |    2=20
 arch/powerpc/platforms/Kconfig.cputype               |    2=20
 arch/x86/Makefile                                    |    9=20
 arch/x86/events/intel/cstate.c                       |   10=20
 arch/x86/include/asm/efi.h                           |    6=20
 arch/x86/include/asm/fpu/api.h                       |   15=20
 arch/x86/kernel/fpu/core.c                           |    6=20
 drivers/android/binder_alloc.c                       |   18=20
 drivers/block/loop.c                                 |    5=20
 drivers/block/zram/zram_drv.c                        |    5=20
 drivers/dma/sh/rcar-dmac.c                           |   30 +
 drivers/gpio/gpio-eic-sprd.c                         |    1=20
 drivers/gpu/drm/i915/intel_fbdev.c                   |   12=20
 drivers/gpu/drm/rockchip/cdn-dp-reg.c                |    2=20
 drivers/gpu/drm/vc4/vc4_crtc.c                       |    2=20
 drivers/hwtracing/intel_th/gth.c                     |    2=20
 drivers/infiniband/hw/mlx5/main.c                    |    2=20
 drivers/infiniband/sw/rdmavt/mr.c                    |   17=20
 drivers/input/rmi4/rmi_f11.c                         |    2=20
 drivers/net/dsa/mv88e6xxx/chip.c                     |    1=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c        |   15=20
 drivers/net/ethernet/ibm/ibmvnic.c                   |    2=20
 drivers/net/ethernet/intel/fm10k/fm10k_main.c        |    2=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c     |   24 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h     |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/port.c       |    4=20
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h         |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |    6=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c     |    8=20
 drivers/net/slip/slhc.c                              |    2=20
 drivers/net/team/team.c                              |    7=20
 drivers/usb/core/driver.c                            |   23 -
 drivers/usb/core/hub.c                               |   16=20
 drivers/usb/core/message.c                           |    3=20
 drivers/usb/core/sysfs.c                             |    5=20
 drivers/usb/core/usb.h                               |   10=20
 drivers/vfio/vfio_iommu_type1.c                      |   14=20
 fs/aio.c                                             |  366 +++++++++-----=
-----
 fs/ceph/dir.c                                        |    6=20
 fs/ceph/mds_client.c                                 |   70 +++
 fs/ceph/snap.c                                       |    7=20
 fs/cifs/inode.c                                      |    4=20
 fs/cifs/smb2pdu.c                                    |    1=20
 fs/ext4/xattr.c                                      |    3=20
 fs/nfs/super.c                                       |    3=20
 fs/nfsd/nfs4callback.c                               |    8=20
 fs/nfsd/state.h                                      |    1=20
 fs/proc/proc_sysctl.c                                |    6=20
 fs/splice.c                                          |    4=20
 include/linux/fs.h                                   |    8=20
 include/linux/pipe_fs_i.h                            |    1=20
 include/net/netfilter/nf_tables.h                    |   29 +
 include/net/netrom.h                                 |    2=20
 kernel/sched/deadline.c                              |    3=20
 kernel/sched/fair.c                                  |    4=20
 kernel/trace/ring_buffer.c                           |    2=20
 kernel/trace/trace.c                                 |   33 -
 kernel/workqueue.c                                   |    3=20
 lib/Kconfig.debug                                    |    1=20
 mm/memory.c                                          |    9=20
 net/bridge/netfilter/ebtables.c                      |    3=20
 net/ipv4/route.c                                     |   32 +
 net/ipv4/sysctl_net_ipv4.c                           |    5=20
 net/netfilter/ipvs/ip_vs_ctl.c                       |    3=20
 net/netfilter/nf_tables_api.c                        |  108 ++++-
 net/netfilter/nft_compat.c                           |  192 ++-------
 net/netfilter/nft_dynset.c                           |   22 +
 net/netfilter/nft_immediate.c                        |    6=20
 net/netfilter/nft_lookup.c                           |   21 +
 net/netfilter/nft_objref.c                           |   40 +-
 net/netrom/af_netrom.c                               |   76 ++-
 net/netrom/nr_loopback.c                             |    2=20
 net/netrom/nr_route.c                                |    2=20
 net/netrom/sysctl_net_netrom.c                       |    5=20
 net/rds/af_rds.c                                     |    3=20
 net/rds/bind.c                                       |    2=20
 net/rds/ib_fmr.c                                     |   11=20
 net/rds/ib_rdma.c                                    |    3=20
 net/rose/rose_loopback.c                             |   27 -
 net/rxrpc/input.c                                    |   12=20
 net/rxrpc/local_object.c                             |    3=20
 net/sunrpc/cache.c                                   |    3=20
 net/tipc/netlink_compat.c                            |   24 +
 net/tls/tls_device.c                                 |    4=20
 net/tls/tls_device_fallback.c                        |   13=20
 net/tls/tls_main.c                                   |    5=20
 net/tls/tls_sw.c                                     |    3=20
 net/vmw_vsock/virtio_transport_common.c              |   22 -
 sound/pci/hda/patch_ca0132.c                         |    4=20
 99 files changed, 969 insertions(+), 593 deletions(-)

Achim Dahlhoff (1):
      dmaengine: sh: rcar-dmac: Fix glitch in dmaengine_tx_status

Adalbert Laz=C4=83r (1):
      vsock/virtio: fix kernel panic from virtio_transport_reset_no_sock

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

Andrea Claudi (1):
      ipvs: fix warning on unused variable

Antoine Tenart (1):
      net: mvpp2: fix validate for PPv2.1

Ard Biesheuvel (1):
      ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the ca=
che

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load

Baolin Wang (1):
      gpio: eic: sprd: Fix incorrect irq type setting for the sync EIC

Christoph Hellwig (2):
      aio: clear IOCB_HIPRI
      aio: separate out ring reservation from req allocation

Christophe Leroy (1):
      powerpc/vdso32: fix CLOCK_MONOTONIC on PPC64

Damian Kos (1):
      drm/rockchip: fix for mailbox read validation.

Dan Carpenter (1):
      ext4: fix some error pointer dereferences

Daniel Borkmann (2):
      x86, retpolines: Raise limit for generating indirect calls from switc=
h-case
      x86/retpolines: Disable switch jump tables when retpolines are enabled

Dave Airlie (1):
      Revert "drm/i915/fbdev: Actually configure untiled displays"

Diana Craciun (1):
      powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2 bo=
ot arg

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

Florian Westphal (7):
      netfilter: nft_compat: use refcnt_t type for nft_xt reference count
      netfilter: nft_compat: make lists per netns
      netfilter: nf_tables: split set destruction in deactivate and destroy=
 phase
      netfilter: nft_compat: destroy function must not have side effects
      netfilter: nf_tables: warn when expr implements only one of activate/=
deactivate
      netfilter: nft_compat: don't use refcount_inc on newly allocated entry
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error

Greg Kroah-Hartman (1):
      Linux 4.19.38

Hangbin Liu (1):
      team: fix possible recursive locking when add slaves

Harry Pan (1):
      perf/x86/intel: Update KBL Package C-state events to also include PC8=
/PC9/PC10 counters

Heiner Kallweit (1):
      net: dsa: mv88e6xxx: add call to mv88e6xxx_ports_cmode_init to probe =
for new DSA framework

Ido Schimmel (1):
      mlxsw: pci: Reincrease PCI reset timeout

Jakub Kicinski (3):
      net/tls: fix refcount adjustment in fallback
      net/tls: avoid potential deadlock in tls_set_device_offload_rx()
      net/tls: don't leak IV and record seq when offload fails

Jan Kara (1):
      mm: Fix warning in insert_pfn()

Jann Horn (1):
      tracing: Fix buffer_ref pipe ops

Jason Gunthorpe (1):
      RDMA/mlx5: Do not allow the user to write to the clock page

Jeff Layton (2):
      ceph: only use d_name directly when parent is locked
      ceph: ensure d_name stability in ceph_dentry_hash()

Jens Axboe (5):
      aio: use assigned completion handler
      aio: don't zero entire aio_kiocb aio_get_req()
      aio: use iocb_put() instead of open coding it
      aio: split out iocb copy from io_submit_one()
      aio: abstract out io_event filler helper

Josh Collier (1):
      IB/rdmavt: Fix frwr memory registration

Jun Xiao (1):
      net: hns: Fix WARNING when hns modules installed

J=C3=A9r=C3=B4me Glisse (1):
      zram: pass down the bvec we need to read into in the work struct

Kai-Heng Feng (2):
      USB: Add new USB LPM helpers
      USB: Consolidate LPM checks to avoid enabling LPM twice

Linus Torvalds (3):
      slip: make slhc_free() silently accept an error pointer
      aio: simplify - and fix - fget/fput for io_submit()
      pin iocb through aio.

Lucas Stach (1):
      Input: synaptics-rmi4 - write config register values to the right off=
set

Maarten Lankhorst (2):
      drm/vc4: Fix memory leak during gpu reset.
      drm/vc4: Fix compilation error reported by kbuild test bot

Maxim Mikityanskiy (2):
      net/mlx5e: Fix the max MTU check in case of XDP
      net/mlx5e: Fix use-after-free after xdp_return_frame

Michael Ellerman (1):
      powerpc/mm/radix: Make Radix require HUGETLB_PAGE

Mike Marshall (1):
      aio: initialize kiocb private in case any filesystems expect it.

NeilBrown (1):
      sunrpc: don't mark uninitialised items as VALID.

Pablo Neira Ayuso (5):
      netfilter: nf_tables: unbind set in rule from commit path
      netfilter: nft_compat: use .release_ops and remove list of extension
      netfilter: nf_tables: fix set double-free in abort path
      netfilter: nf_tables: bogus EBUSY when deleting set after flush
      netfilter: nf_tables: bogus EBUSY in helper removal from transaction

Peter Zijlstra (1):
      trace: Fix preempt_enable_no_resched() abuse

Petr Machata (1):
      mlxsw: spectrum: Put MC TCs into DWRR mode

Ronnie Sahlberg (1):
      cifs: fix memory leak in SMB2_read

Sebastian Andrzej Siewior (1):
      x86/fpu: Don't export __kernel_fpu_{begin,end}()

Su Bao Cheng (1):
      stmmac: pci: Adjust IOT2000 matching

Takashi Iwai (1):
      ALSA: hda/ca0132 - Fix build error without CONFIG_PCI

Tetsuo Handa (3):
      workqueue: Try to catch flush_work() without INIT_WORK().
      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.
      net/rds: Check address length before reading address family

Thomas Falcon (1):
      net/ibmvnic: Fix RTNL deadlock during device reset

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
      lib/Kconfig.debug: fix build error without CONFIG_BLOCK
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
      net: netrom: Fix error cleanup path of nr_proto_init

ZhangXiaoxu (1):
      ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Zhu Yanjun (1):
      net: rds: exchange of 8K and 1M pool

luca abeni (1):
      sched/deadline: Correctly handle active 0-lag timers


--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzKwwoACgkQONu9yGCS
aT557w/8DMtw6hxgjiAqkxb5HXWyrnqKGTQ2A0rkrsD03l5p/zpxqAo/pdTM1Erv
XbTWJAjqP3UgQ8u5DPNtuKQlo07IV5u1mG6ZDXdfzyNmw3L+y1aFUC8EVaPppjKh
GGUudSlQ1DkOhzlKsHqQwmFYeJgfelGkjODrDuc1mE3kztQwAP0poybb/8h1GoOq
vf6zoofArEfxEoQy4Bd+60tXEvnhKO17A2yN8tIQSFOSAqwEKI8yTibGPCkfcmHU
Id6D1aiMddmqA95SxkmOggIhwJ7BUkGVD3J67TIFsmg4YjZKYPDVUnMIm1/WFl5a
U6NxNFhJIpx7ADJfKU/EG/SGhnuY5uDoBQ7pdwoUHeoI3muKahqrlndjxZ3DXpa7
sdRqshNWb8zXeNc02Igc0hXqMQUb0RM/LQaV0LXwwRQ+Rp+zLalmyERUtrFrjYUG
CEqJM9ZM1jG1E3LLe+G5/0Gz13Li0b2BKhUTLBYYpXPvqBG8Pucq/0rz+Kkl+s30
TXLpHgNbC35O3k2mfheYy6/GK8ePmYhVobxAujiIqAsB9Z5QGRyUdZDQLgWU9hHP
kRUKRW/6AVLRAQAI8nzIlBUZ7VDP9bsOJ0JfYCpbJ3pEh4lFQJwRwnEROdEqXtM2
eiNmKU/K+stWVZxiQcUVXMcIwtb8q8S7wP19MJJVVWyzthGlblk=
=4Q5F
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
