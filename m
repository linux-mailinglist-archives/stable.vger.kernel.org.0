Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A955011729
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 12:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfEBKYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 06:24:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43571 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfEBKYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 06:24:37 -0400
Received: by mail-pl1-f195.google.com with SMTP id n8so801935plp.10;
        Thu, 02 May 2019 03:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zz6Z14O0a/ywY+dR4viYX1u5Y7UbHljrqh5p/QXiX4g=;
        b=b0WBprhdaAioLXnxFf9cJ7jgCm4W/Tbp1clOvZf8mzPrym3gYUAF7HOYxZOGEC/piT
         zBh/ZfPbyqs844ONBnjpGN1S3DW3dv+e7TmLupL/SV/hVdCcv8Coofwc0yGOkgeSkHwc
         XCviEelixhdFK+DGlcPVlPFSO/xezpFMw/tY4quF/k+rfFeU0nw2j6vT2mhMAAequkQ1
         9X0RDkkKhRw66ze4vc2s5s3bXOh5rBFKioQhPiJWxMzxUbAullayYpXV2dTmgQOY8cyA
         tEbwOemEhAUQtK2mJw0u6FXUlxaQbdtOOmLwVz6NykS1GxKVMDAR9560Wtw/lhBfevZB
         dTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zz6Z14O0a/ywY+dR4viYX1u5Y7UbHljrqh5p/QXiX4g=;
        b=ces/y6biJB9UADFchNapwH+7a5+28b60ENjhyfl6TFwy1vO/Cy+c8B06Sd59pUJzDC
         GX4PgScjVkdQ++2+tWjfVDiw00F89XQfJxStGyZCz2klt492YW9pJqVY9OO/6XJTzlHK
         fPlOwniZ3E2+vVG64ZLg9JvDfz/l3NIotp8oNAMRqvrpciQXVc0Q+yv7rYeTihNKyLAe
         T4+bv9d80UA1plyOfpz+b0PLXikaUaMvfJJO4bnHYNXddkbLRG2N0L7Ua3jbioMzsX8y
         31ZU1xbiKsXkTX9XKilG0uotjr0MeIZV4cCkMCXu3AaO1kTBnJrmmjsQjS4OZgHj0eLj
         7iEA==
X-Gm-Message-State: APjAAAWQsHUY54WU9Aswrr+coJyGeRrY6tIKQdAcE4UG96Px2SMKpjrR
        8w53J0o3DIOogMYZ/7ljx7oHDaQWRTA=
X-Google-Smtp-Source: APXvYqwEoz0krwUQRAq4FZ4/6qVxLnifcA+1puyiYiyE+TLPmf/NhF04ky5GapqHCRONgzy9K58/Uw==
X-Received: by 2002:a17:902:be07:: with SMTP id r7mr2771991pls.213.1556792676773;
        Thu, 02 May 2019 03:24:36 -0700 (PDT)
Received: from Gentoo ([103.231.90.174])
        by smtp.gmail.com with ESMTPSA id o81sm86649012pfa.156.2019.05.02.03.24.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 03:24:35 -0700 (PDT)
Date:   Thu, 2 May 2019 15:54:20 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.0.11
Message-ID: <20190502102420.GA9692@Gentoo>
References: <20190502101453.GA16617@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20190502101453.GA16617@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch!

On 12:14 Thu 02 May , Greg KH wrote:
>I'm announcing the release of the 5.0.11 kernel.
>
>All users of the 5.0 kernel series must upgrade.
>
>The updated 5.0.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.0.y
>and can be browsed at the normal kernel.org git web browser:
>	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary
>
>thanks,
>
>greg k-h
>
>------------
>
> Documentation/networking/ip-sysctl.txt               |    1
> Documentation/sysctl/vm.txt                          |   16 -
> Makefile                                             |    2
> arch/arm/boot/compressed/head.S                      |   16 +
> arch/arm64/mm/init.c                                 |    2
> arch/mips/kernel/scall64-o32.S                       |    2
> arch/powerpc/configs/skiroot_defconfig               |    1
> arch/powerpc/kernel/vdso32/gettimeofday.S            |    2
> arch/powerpc/platforms/Kconfig.cputype               |    2
> arch/x86/Makefile                                    |    9
> arch/x86/events/intel/cstate.c                       |   10
> block/bfq-iosched.c                                  |   15 -
> block/bfq-iosched.h                                  |    2
> block/bfq-wf2q.c                                     |   17 +
> crypto/lrw.c                                         |    6
> crypto/xts.c                                         |    6
> drivers/android/binder_alloc.c                       |   18 -
> drivers/block/loop.c                                 |    5
> drivers/block/zram/zram_drv.c                        |    5
> drivers/dma/mediatek/mtk-cqdma.c                     |    2
> drivers/dma/sh/rcar-dmac.c                           |   30 ++
> drivers/gpio/gpio-eic-sprd.c                         |    1
> drivers/gpu/drm/i915/intel_fbdev.c                   |   12 -
> drivers/gpu/drm/ttm/ttm_bo.c                         |   10
> drivers/gpu/drm/ttm/ttm_memory.c                     |    5
> drivers/gpu/drm/vc4/vc4_crtc.c                       |    2
> drivers/hwtracing/intel_th/gth.c                     |    2
> drivers/infiniband/core/uverbs.h                     |    1
> drivers/infiniband/core/uverbs_main.c                |   52 ++++
> drivers/infiniband/hw/mlx5/main.c                    |   10
> drivers/infiniband/sw/rdmavt/mr.c                    |   17 -
> drivers/input/rmi4/rmi_f11.c                         |    2
> drivers/net/ethernet/intel/fm10k/fm10k_main.c        |    2
> drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c     |   24 ++
> drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h     |    3
> drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    5
> drivers/net/ethernet/mellanox/mlx5/core/port.c       |    4
> drivers/net/ethernet/mellanox/mlxsw/pci_hw.h         |    2
> drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |    6
> drivers/net/ethernet/socionext/netsec.c              |   11 -
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    4
> drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c     |    8
> drivers/net/slip/slhc.c                              |    2
> drivers/net/team/team.c                              |    7
> drivers/net/wireless/mac80211_hwsim.c                |   19 +
> drivers/usb/core/driver.c                            |   23 +-
> drivers/usb/core/hub.c                               |   16 -
> drivers/usb/core/message.c                           |    3
> drivers/usb/core/sysfs.c                             |    5
> drivers/usb/core/usb.h                               |   10
> drivers/vfio/vfio_iommu_type1.c                      |   14 +
> fs/aio.c                                             |  200 ++++++++-----=
------
> fs/ceph/dir.c                                        |    6
> fs/ceph/mds_client.c                                 |   70 +++++-
> fs/ceph/snap.c                                       |    7
> fs/cifs/file.c                                       |   15 -
> fs/cifs/inode.c                                      |    4
> fs/cifs/misc.c                                       |   23 ++
> fs/cifs/smb2pdu.c                                    |    1
> fs/ext4/xattr.c                                      |    3
> fs/nfs/super.c                                       |    3
> fs/nfsd/nfs4callback.c                               |    8
> fs/nfsd/nfs4state.c                                  |   12 -
> fs/nfsd/state.h                                      |    1
> fs/proc/proc_sysctl.c                                |    6
> fs/splice.c                                          |    4
> include/drm/ttm/ttm_bo_driver.h                      |    1
> include/linux/etherdevice.h                          |   12 +
> include/linux/pipe_fs_i.h                            |    1
> include/net/netfilter/nf_tables.h                    |    6
> include/net/netrom.h                                 |    2
> kernel/sched/deadline.c                              |    3
> kernel/sched/fair.c                                  |    4
> kernel/trace/ring_buffer.c                           |    2
> kernel/trace/trace.c                                 |   33 +--
> kernel/workqueue.c                                   |    3
> lib/Kconfig.debug                                    |    1
> mm/page_alloc.c                                      |   13 +
> net/bridge/netfilter/ebtables.c                      |    3
> net/ipv4/route.c                                     |   32 ++-
> net/ipv4/sysctl_net_ipv4.c                           |    5
> net/ncsi/ncsi-rsp.c                                  |    6
> net/netfilter/nf_tables_api.c                        |   28 ++
> net/netfilter/nft_dynset.c                           |   13 -
> net/netfilter/nft_lookup.c                           |   13 -
> net/netfilter/nft_objref.c                           |   32 ++-
> net/netrom/af_netrom.c                               |   76 +++++--
> net/netrom/nr_loopback.c                             |    2
> net/netrom/nr_route.c                                |    2
> net/netrom/sysctl_net_netrom.c                       |    5
> net/rds/af_rds.c                                     |    3
> net/rds/bind.c                                       |    2
> net/rds/ib_fmr.c                                     |   11 +
> net/rds/ib_rdma.c                                    |    3
> net/rose/rose_loopback.c                             |   27 +-
> net/rxrpc/input.c                                    |   12 -
> net/rxrpc/local_object.c                             |    3
> net/sunrpc/cache.c                                   |    3
> net/tipc/netlink_compat.c                            |   24 +-
> net/tls/tls_device.c                                 |    4
> net/tls/tls_device_fallback.c                        |   13 -
> net/tls/tls_main.c                                   |    5
> net/tls/tls_sw.c                                     |    3
> sound/pci/hda/patch_realtek.c                        |   41 ++-
> 105 files changed, 873 insertions(+), 395 deletions(-)
>
>Achim Dahlhoff (1):
>      dmaengine: sh: rcar-dmac: Fix glitch in dmaengine_tx_status
>
>Al Viro (4):
>      aio: fold lookup_kiocb() into its sole caller
>      aio: keep io_event in aio_kiocb
>      aio: store event at final iocb_put()
>      Fix aio_poll() races
>
>Alex Williamson (1):
>      vfio/type1: Limit DMA mappings per container
>
>Alexander Shishkin (1):
>      intel_th: gth: Fix an off-by-one in output unassigning
>
>Amit Cohen (1):
>      mlxsw: spectrum: Fix autoneg status in ethtool
>
>Ard Biesheuvel (1):
>      ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the c=
ache
>
>Aurelien Jarno (1):
>      MIPS: scall64-o32: Fix indirect syscall number load
>
>Baolin Wang (1):
>      gpio: eic: sprd: Fix incorrect irq type setting for the sync EIC
>
>Bjorn Andersson (1):
>      arm64: mm: Ensure tail of unaligned initrd is reserved
>
>Christian K=F6nig (1):
>      drm/ttm: fix re-init of global structures
>
>Christophe Leroy (1):
>      powerpc/vdso32: fix CLOCK_MONOTONIC on PPC64
>
>Dan Carpenter (1):
>      ext4: fix some error pointer dereferences
>
>Daniel Borkmann (2):
>      x86, retpolines: Raise limit for generating indirect calls from swit=
ch-case
>      x86/retpolines: Disable switch jump tables when retpolines are enabl=
ed
>
>Dave Airlie (1):
>      Revert "drm/i915/fbdev: Actually configure untiled displays"
>
>Dirk Behme (1):
>      dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid
>
>Dongli Zhang (1):
>      loop: do not print warn message if partition scan is successful
>
>Erez Alfasi (1):
>      net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query
>
>Eric Dumazet (3):
>      rxrpc: fix race condition in rxrpc_input_packet()
>      ipv4: add sanity checks in ipv4_link_failure()
>      net/rose: fix unbound loop in rose_loopback_timer()
>
>Florian Westphal (1):
>      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
>
>Frank Sorenson (1):
>      cifs: do not attempt cifs operation on smb2+ rename error
>
>Greg Kroah-Hartman (1):
>      Linux 5.0.11
>
>Hangbin Liu (1):
>      team: fix possible recursive locking when add slaves
>
>Harry Pan (1):
>      perf/x86/intel: Update KBL Package C-state events to also include PC=
8/PC9/PC10 counters
>
>Herbert Xu (2):
>      crypto: xts - Fix atomic sleep when walking skcipher
>      crypto: lrw - Fix atomic sleep when walking skcipher
>
>Ido Schimmel (1):
>      mlxsw: pci: Reincrease PCI reset timeout
>
>Ilias Apalodimas (1):
>      net: socionext: replace napi_alloc_frag with the netdev variant on i=
nit
>
>Jakub Kicinski (3):
>      net/tls: fix refcount adjustment in fallback
>      net/tls: avoid potential deadlock in tls_set_device_offload_rx()
>      net/tls: don't leak IV and record seq when offload fails
>
>Jann Horn (1):
>      tracing: Fix buffer_ref pipe ops
>
>Jason Gunthorpe (3):
>      RDMA/mlx5: Do not allow the user to write to the clock page
>      RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
>      RDMA/ucontext: Fix regression with disassociate
>
>Jeff Layton (4):
>      ceph: only use d_name directly when parent is locked
>      ceph: ensure d_name stability in ceph_dentry_hash()
>      nfsd: wake waiters blocked on file_lock before deleting it
>      nfsd: wake blocked file lock waiters before sending callback
>
>Johannes Berg (1):
>      mac80211_hwsim: calculate if_combination.max_interfaces
>
>Josh Collier (1):
>      IB/rdmavt: Fix frwr memory registration
>
>J=E9r=F4me Glisse (2):
>      cifs: fix page reference leak with readv/writev
>      zram: pass down the bvec we need to read into in the work struct
>
>Kai-Heng Feng (2):
>      USB: Add new USB LPM helpers
>      USB: Consolidate LPM checks to avoid enabling LPM twice
>
>Kailang Yang (1):
>      ALSA: hda/realtek - Move to ACT_INIT state
>
>Linus Torvalds (3):
>      slip: make slhc_free() silently accept an error pointer
>      pin iocb through aio.
>      rdma: fix build errors on s390 and MIPS due to bad ZERO_PAGE use
>
>Lucas Stach (1):
>      Input: synaptics-rmi4 - write config register values to the right of=
fset
>
>Maarten Lankhorst (2):
>      drm/vc4: Fix memory leak during gpu reset.
>      drm/vc4: Fix compilation error reported by kbuild test bot
>
>Maxim Mikityanskiy (2):
>      net/mlx5e: Fix the max MTU check in case of XDP
>      net/mlx5e: Fix use-after-free after xdp_return_frame
>
>Mel Gorman (1):
>      mm: do not boost watermarks to avoid fragmentation for the DISCONTIG=
 memory model
>
>Michael Ellerman (1):
>      powerpc/mm/radix: Make Radix require HUGETLB_PAGE
>
>NeilBrown (1):
>      sunrpc: don't mark uninitialised items as VALID.
>
>Pablo Neira Ayuso (2):
>      netfilter: nf_tables: bogus EBUSY when deleting set after flush
>      netfilter: nf_tables: bogus EBUSY in helper removal from transaction
>
>Paolo Valente (1):
>      block, bfq: fix use after free in bfq_bfqq_expire
>
>Peter Zijlstra (1):
>      trace: Fix preempt_enable_no_resched() abuse
>
>Petr Machata (1):
>      mlxsw: spectrum: Put MC TCs into DWRR mode
>
>Ronnie Sahlberg (1):
>      cifs: fix memory leak in SMB2_read
>
>Shun-Chih Yu (1):
>      dmaengine: mediatek-cqdma: fix wrong register usage in mtk_cqdma_sta=
rt
>
>Su Bao Cheng (1):
>      stmmac: pci: Adjust IOT2000 matching
>
>Tao Ren (1):
>      net/ncsi: handle overflow when incrementing mac address
>
>Tetsuo Handa (3):
>      workqueue: Try to catch flush_work() without INIT_WORK().
>      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.
>      net/rds: Check address length before reading address family
>
>Todd Kjos (1):
>      binder: fix handling of misaligned binder object
>
>Trond Myklebust (1):
>      nfsd: Don't release the callback slot unless it was actually held
>
>Vinod Koul (1):
>      net: stmmac: move stmmac_check_ether_addr() to driver probe
>
>Wenwen Wang (1):
>      tracing: Fix a memory leak by early error exit in trace_pid_write()
>
>Xie XiuQi (1):
>      sched/numa: Fix a possible divide-by-zero
>
>Xin Long (3):
>      tipc: handle the err returned from cmd header function
>      tipc: check bearer name with right length in tipc_nl_compat_bearer_e=
nable
>      tipc: check link name with right length in tipc_nl_compat_link_set
>
>Yan, Zheng (1):
>      ceph: fix ci->i_head_snapc leak
>
>Yue Haibing (1):
>      fm10k: Fix a potential NULL pointer dereference
>
>YueHaibing (3):
>      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
>      lib/Kconfig.debug: fix build error without CONFIG_BLOCK
>      net: netrom: Fix error cleanup path of nr_proto_init
>
>ZhangXiaoxu (1):
>      ipv4: set the tcp_min_rtt_wlen range from 0 to one day
>
>Zhu Yanjun (1):
>      net: rds: exchange of 8K and 1M pool
>
>luca abeni (1):
>      sched/deadline: Correctly handle active 0-lag timers
>



--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzKxVAACgkQsjqdtxFL
KRVMIQgAw9XAJDrwf5vIMENpRiyLK4/icVnS9Jpx/pHuU9PkPboL3FkbWaFPlT+c
aER/MZD7jd3o3l/0VIb+AKp7XjSTWLIguSAbZxpgV2avwIbKv1ASIc7wgDl3nENl
s2VvrsXfqT2957JsB/2HHNPB/n+Q5/ZFK0boa3KKypp1dkBs2oxiwZu7Hyc/7qz6
84JEoszdyuxbMelUtBlU2cs5S/AJue3dPfqZfMJ+clgiD6F7yZXQ3qyI4Z369x+1
xXMeb6OaPr8ZNAxN3KVGXO2Yk1sf1oowQrKnHY2zgOdT5CoF6/JJ3lnP3wWNZjYj
9OkdJhl1ZLSuWojyt3JOidmz+OnPsw==
=gBF6
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
