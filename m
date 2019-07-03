Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E55B5E492
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfGCMxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:53:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39467 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGCMxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 08:53:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so1243256pfe.6;
        Wed, 03 Jul 2019 05:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RUaigmt8PCXBA7GOdVIK8Qfrj8sZUiuVyrudreMT5Os=;
        b=AeebKWev2yMIQ13iO631hZVWwX7irkmJl4K3QMDzgqNb/EuHHoA1ZJ7d7Mmh3SfNFa
         hN7B9CDJNWU1f4x+JIAQRzj8UaYLgpc8c9SSgywnshUiGs0nvGkj3tSvn9GeeK9czpbt
         7VBdTFUgbvPXN5832RRjtl4nvKwZMKBTDBeDfb0p+OCTImAd3s2mMmKrsbnPwsk8bq6C
         fWqEkYxshuPR0/McjQge2rP2AHglx2S6nyvgo8gu50ohIk3kCWgXeLc/vD5ixstFojRj
         HviQMVP6g2Gen3kqHQDqbjZvrTiH0vgkDsAnjfuTwam3zxQzNOFufrB85HdkNaF4IF/s
         LKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RUaigmt8PCXBA7GOdVIK8Qfrj8sZUiuVyrudreMT5Os=;
        b=NQtSd7Aj6ETmxVqhluT/T1+1cfLwbvBKmCnhOFKAOsTSrkWSbic+45F0IHCztX1xmv
         02/Xb7DQsW4yfNXNbWpmmamx4N7G+GSd+tyy7GXJxZbKVkR8DtUhlbw+s5SK+iGgRlrz
         QH/I0vBNtH5MXWfbuZhj2TUGOOTbgF+rfVFV0cIZMuRWxj0psUmof6Eo1D5u7tkI38Ew
         phaYAfCID0FY4HgEA75woBSJoMxzU7+hmK5jmrhS+bkrNOz4sbX+cCbwVm6ZWlSnsGIW
         tG9qZodqVSzcsN2hyrjgNLWnYBJrPSIX7jmT2sYNIShjikt12g/U0EY30trxQyfyqktE
         chMg==
X-Gm-Message-State: APjAAAWFrcIrBPuxO97viomf1Wntv2aZBCB6us9ZrD1emleGHglsI4s0
        kqX7Dzj3J11fx4Azh+7q7EjxLS96RZO1FQ==
X-Google-Smtp-Source: APXvYqyvsqJU4CMXnbMjNBTkVHvql7YxC2Qp+J5Y2x/ygCYhGlLAggBlFmNQmt1wohRflLS40GLl5w==
X-Received: by 2002:a63:3d0f:: with SMTP id k15mr37214608pga.343.1562158426252;
        Wed, 03 Jul 2019 05:53:46 -0700 (PDT)
Received: from Gentoo ([103.231.91.69])
        by smtp.gmail.com with ESMTPSA id s66sm5463683pfs.8.2019.07.03.05.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:53:44 -0700 (PDT)
Date:   Wed, 3 Jul 2019 18:23:33 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.16
Message-ID: <20190703125333.GA18955@Gentoo>
References: <20190703123008.GA4102@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20190703123008.GA4102@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Greg!=20

On 14:30 Wed 03 Jul , Greg KH wrote:
>I'm announcing the release of the 5.1.16 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Documentation/robust-futexes.txt                          |    3
> Makefile                                                  |    2
> arch/arm64/Makefile                                       |    2
> arch/arm64/include/asm/futex.h                            |    4
> arch/arm64/include/asm/insn.h                             |    8
> arch/arm64/kernel/insn.c                                  |   40 +++
> arch/arm64/net/bpf_jit.h                                  |    4
> arch/arm64/net/bpf_jit_comp.c                             |   28 +-
> arch/mips/include/asm/mips-gic.h                          |   30 ++
> arch/x86/kernel/cpu/bugs.c                                |   11
> arch/x86/kernel/cpu/microcode/core.c                      |   15 -
> arch/x86/kernel/cpu/resctrl/rdtgroup.c                    |   35 +-
> drivers/clk/socfpga/clk-s10.c                             |    4
> drivers/clk/tegra/clk-tegra210.c                          |    2
> drivers/firmware/efi/efi.c                                |   12
> drivers/gpu/drm/i915/i915_drv.h                           |    6
> drivers/gpu/drm/i915/intel_audio.c                        |   62 ++++
> drivers/gpu/drm/i915/intel_cdclk.c                        |  185 ++++++++=
++----
> drivers/gpu/drm/i915/intel_display.c                      |   57 +++-
> drivers/gpu/drm/i915/intel_drv.h                          |   21 +
> drivers/infiniband/core/addr.c                            |   16 -
> drivers/infiniband/hw/ocrdma/ocrdma_ah.c                  |    5
> drivers/infiniband/hw/ocrdma/ocrdma_hw.c                  |    5
> drivers/irqchip/irq-mips-gic.c                            |    4
> drivers/md/dm-init.c                                      |    6
> drivers/md/dm-log-writes.c                                |   23 +
> drivers/net/bonding/bond_main.c                           |    2
> drivers/net/ethernet/aquantia/atlantic/aq_filters.c       |   10
> drivers/net/ethernet/aquantia/atlantic/aq_nic.c           |    1
> drivers/net/ethernet/aquantia/atlantic/aq_nic.h           |    1
> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   19 -
> drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c     |    2
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |   22 +
> drivers/net/team/team.c                                   |    2
> drivers/net/tun.c                                         |   19 -
> drivers/net/usb/qmi_wwan.c                                |    2
> drivers/scsi/vmw_pvscsi.c                                 |    6
> fs/binfmt_flat.c                                          |   23 -
> fs/inode.c                                                |    2
> fs/io_uring.c                                             |    5
> fs/nfs/flexfilelayout/flexfilelayoutdev.c                 |    2
> fs/notify/fanotify/fanotify.c                             |    4
> fs/notify/mark.c                                          |   14 -
> fs/proc/array.c                                           |    2
> include/asm-generic/futex.h                               |    8
> include/linux/bpf-cgroup.h                                |    8
> include/linux/fsnotify_backend.h                          |    4
> include/linux/xarray.h                                    |    1
> include/net/tls.h                                         |   15 -
> include/uapi/linux/bpf.h                                  |    6
> kernel/bpf/lpm_trie.c                                     |    9
> kernel/bpf/syscall.c                                      |    8
> kernel/bpf/verifier.c                                     |   12
> kernel/cpu.c                                              |    3
> kernel/trace/bpf_trace.c                                  |  100 ++++++-
> kernel/trace/trace_branch.c                               |    4
> lib/xarray.c                                              |   12
> mm/hugetlb.c                                              |   29 +-
> mm/memory-failure.c                                       |    7
> mm/mempolicy.c                                            |    2
> mm/page_idle.c                                            |    4
> mm/page_io.c                                              |    7
> net/core/filter.c                                         |    2
> net/core/sock.c                                           |    3
> net/ipv4/raw.c                                            |    2
> net/ipv4/udp.c                                            |   10
> net/ipv6/udp.c                                            |    8
> net/packet/af_packet.c                                    |   23 +
> net/packet/internal.h                                     |    1
> net/sctp/endpointola.c                                    |    8
> net/sunrpc/xprtsock.c                                     |   16 -
> net/tipc/core.c                                           |   12
> net/tipc/netlink_compat.c                                 |   18 +
> net/tipc/udp_media.c                                      |    8
> net/tls/tls_main.c                                        |    3
> tools/testing/selftests/bpf/test_lpm_map.c                |   41 ++-
> 76 files changed, 829 insertions(+), 293 deletions(-)
>
>Alejandro Jimenez (1):
>      x86/speculation: Allow guests to use SSBD even if host does not
>
>Amir Goldstein (1):
>      fanotify: update connector fsid cache on add mark
>
>Ard Biesheuvel (1):
>      efi/memreserve: deal with memreserve entries in unmapped memory
>
>Bj=F8rn Mork (1):
>      qmi_wwan: Fix out-of-bounds read
>
>Colin Ian King (1):
>      mm/page_idle.c: fix oops because end_pfn is larger than max_pfn
>
>Daniel Borkmann (2):
>      bpf: fix unconnected udp hooks
>      bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd
>
>Dinh Nguyen (1):
>      clk: socfpga: stratix10: fix divider entry for the emac clocks
>
>Dirk van der Merwe (1):
>      net/tls: fix page double free on TX cleanup
>
>Dmitry Bogdanov (1):
>      net: aquantia: fix vlans not working over bridged network
>
>Eric Dumazet (1):
>      net/packet: fix memory leak in packet_set_ring()
>
>Fei Li (1):
>      tun: wake up waitqueues after IFF_UP is set
>
>Geert Uytterhoeven (1):
>      cpu/speculation: Warn on unsupported mitigations=3D parameter
>
>Gen Zhang (1):
>      dm init: fix incorrect uses of kstrndup()
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.16
>
>Huang Ying (1):
>      mm, swap: fix THP swap out
>
>Imre Deak (2):
>      drm/i915: Save the old CDCLK atomic state
>      drm/i915: Remove redundant store of logical CDCLK state
>
>Jan Kara (1):
>      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
>
>Jann Horn (1):
>      fs/binfmt_flat.c: make load_flat_shared_library() work
>
>Jason Gunthorpe (1):
>      RDMA: Directly cast the sockaddr union to sockaddr
>
>Jean-Philippe Brucker (1):
>      arm64: insn: Fix ldadd instruction encoding
>
>Jens Axboe (1):
>      io_uring: ensure req->file is cleared on allocation
>
>JingYi Hou (1):
>      net: remove duplicate fetch in sock_getsockopt
>
>Johannes Weiner (1):
>      mm: fix page cache convergence regression
>
>John Ogness (1):
>      fs/proc/array.c: allow reporting eip/esp for all coredumping threads
>
>Jon Hunter (1):
>      clk: tegra210: Fix default rates for HDA clocks
>
>Jonathan Lemon (1):
>      bpf: lpm_trie: check left child of last leftmost node for NULL
>
>Martin KaFai Lau (2):
>      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
>      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_e=
rr
>
>Martynas Pumputis (1):
>      bpf: simplify definition of BPF_FIB_LOOKUP related flags
>
>Matt Mullins (1):
>      bpf: fix nested bpf tracepoints with per-cpu data
>
>Naoya Horiguchi (2):
>      mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fa=
ils
>      mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero on =
!PageHuge
>
>Nathan Chancellor (1):
>      arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS
>
>Neil Horman (1):
>      af_packet: Block execution of tasks waiting for transmit to complete=
 in AF_PACKET
>
>Paul Burton (1):
>      irqchip/mips-gic: Use the correct local interrupt map registers
>
>Reinette Chatre (1):
>      x86/resctrl: Prevent possible overrun during bitmap operations
>
>Roland Hii (2):
>      net: stmmac: fixed new system time seconds value calculation
>      net: stmmac: set IC bit when transmitting frames with HW timestamp
>
>Sasha Levin (1):
>      Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"
>
>Stephen Suryaputra (1):
>      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the whil=
e loop
>
>Thomas Gleixner (1):
>      x86/microcode: Fix the microcode load on CPU hotplug for real
>
>Trond Myklebust (2):
>      NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O
>      SUNRPC: Fix up calculation of client message length
>
>Ville Syrj=E4l=E4 (2):
>      drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is enabled
>      drm/i915: Skip modeset for cdclk changes if possible
>
>Will Deacon (2):
>      arm64: futex: Avoid copying out uninitialised stack in failed cmpxch=
g()
>      futex: Update comments and docs about return values of arch futex co=
de
>
>Xin Long (4):
>      sctp: change to hold sk after auth shkey is created successfully
>      tipc: change to use register_pernet_device
>      tipc: check msg->req data len in tipc_nl_compat_bearer_disable
>      tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb
>
>YueHaibing (2):
>      bonding: Always enable vlan tx offload
>      team: Always enable vlan tx offload
>
>zhangyi (F) (1):
>      dm log writes: make sure super sector log updates are written in ord=
er
>
>zhong jiang (1):
>      mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask
>



--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0cpUkACgkQsjqdtxFL
KRXTSAf9GEeIySCcywuzQMwvJz+l6BlGB7sR4WVId3fMynJo/7YkR6XEpCe5ugoP
hgCCkV2lHH6OPK59sLH7azgHnj26hK23qoPMyyVz8oVNokzMHuThw9IZUFTb15+b
1gNkve3xfkJznyqLfqmXxLJZnx9Kg0OsuXHly2ZlTBxG9b4oZVatk4tJ074hremJ
/ilEciPbHjkM8ZTwYtUnZ8dHKMCfft7waZO6Z+BzrmaXXNC49Ijul+VLcOs13NUR
Ad8/gP4nw2tBXd6/ZGOSwHP1t8LN/p+arJjk83QEYYa45HaUFcWHrGLpH2iUZXmJ
jVcUzux4pxLTm69ULxGgGBscLCUX7Q==
=bAEO
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
