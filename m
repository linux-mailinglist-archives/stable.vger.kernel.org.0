Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515A977E70
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 09:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfG1HTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 03:19:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33258 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfG1HTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 03:19:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so26449971pfq.0;
        Sun, 28 Jul 2019 00:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=srI6YeZfBqvwHJlCpgQQAXP3LK1Hdp5YqfUlLtYCl0I=;
        b=nuFnhAiVKOAVC2mw+yUjsC7q2Br/8XixFndl/NVTMSKJDFBiR8bFB/Q+xUFneSpHmj
         INJA5OQ5lOYry8XawfUT8mIXtB4cXXTi8R+X68cd3/j5P7rWK3QWeabZ/+YwDjcULfkc
         zKehXxt2sRtsbwNOibOw9phMbdCf6sFM48gF31l+ONRCOCZ6QdghCFMrQxZC5R2EJ5Un
         jPzR8cR6+fVBQ3Ig5uw9WS6atJvipJvHJDYdv8MFYAcBjGUf6RJHASmpRXmJ4oC7XKLl
         yC/rotmRxjYRL0InGux6OyfLqC2UsGBg+WZXIl+EM2iF/nR7ZyDz0fKjN5Wxj8esFDuf
         FpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=srI6YeZfBqvwHJlCpgQQAXP3LK1Hdp5YqfUlLtYCl0I=;
        b=F/HrvHpoFdhxVq8hW19rG77aTarKYoOysqnIEox8vWGs70/aaY1OiHsZdBwV8lZcLc
         i/85GwCCMiWwDCWV06MTGrc2fltApqY00ZBoOvWyqj28BedvReUTg0DefU5N6EJAASv5
         Fa6ntpvyTzKFtDlS8P/jTEZCA/6jzMr52cKTQzfDS2ppzFxgOq7GUm66r9qnEQU34hS9
         j79wZpusg2sTDt94dMVOO1bBDo7PdItikmwDah0Y0h+QxoWaP+ojTBtEekTlh/mE9f/b
         ZJWIK5x3r7CLFjYtuz8w7bL60uim/lzYCsPRA8yicqfYh9S9EypfBa+0jJBCtjeJIz0M
         ymhA==
X-Gm-Message-State: APjAAAXft3EoyG86tQGMz1NFF4dNXHy8ELzXGby4ZcETbPNmosBTW19j
        Qmi0b7xB8gYZ6IxwqeOGo4wrY7nT/vz11A==
X-Google-Smtp-Source: APXvYqw3b/9YSeluVXw12OebCYRngldi96PWqeeRVizCUQF3uZg0D1p+niQBhaxrI3dAiTwsTxvZZw==
X-Received: by 2002:a62:1456:: with SMTP id 83mr30625916pfu.228.1564298371976;
        Sun, 28 Jul 2019 00:19:31 -0700 (PDT)
Received: from Gentoo ([103.231.91.69])
        by smtp.gmail.com with ESMTPSA id f72sm78188464pjg.10.2019.07.28.00.19.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 00:19:30 -0700 (PDT)
Date:   Sun, 28 Jul 2019 12:49:19 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.4
Message-ID: <20190728071917.GA4039@Gentoo>
References: <20190728065847.GA31061@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20190728065847.GA31061@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Greg! :)


On 08:58 Sun 28 Jul 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.4 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.2.y
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
> Makefile                                                   |    2
> arch/mips/jz4740/board-qi_lb60.c                           |   16 -
> arch/x86/include/asm/kvm_host.h                            |    7
> arch/x86/kvm/vmx/nested.c                                  |   10
> arch/x86/kvm/x86.c                                         |    4
> block/blk-zoned.c                                          |   46 ++--
> drivers/dma-buf/dma-buf.c                                  |    1
> drivers/dma-buf/reservation.c                              |    4
> drivers/gpio/gpio-davinci.c                                |    5
> drivers/gpio/gpiolib-of.c                                  |   10
> drivers/net/caif/caif_hsi.c                                |    2
> drivers/net/dsa/mv88e6xxx/chip.c                           |    2
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c            |    3
> drivers/net/ethernet/broadcom/bnxt/bnxt.c                  |    7
> drivers/net/ethernet/broadcom/genet/bcmgenet.c             |   57 ++---
> drivers/net/ethernet/marvell/sky2.c                        |    7
> drivers/net/ethernet/mellanox/mlx5/core/en.h               |    1
> drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   10
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c          |    3
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c            |    7
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |    5
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    7
> drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c      |    9
> drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c     |   23 --
> drivers/net/ethernet/mellanox/mlxsw/spectrum.h             |    1
> drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c         |   16 -
> drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c         |   10
> drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   |    6
> drivers/net/ethernet/realtek/r8169.c                       |  137 +++++++=
++++++
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |   28 +-
> drivers/net/hyperv/netvsc_drv.c                            |    1
> drivers/net/macsec.c                                       |    6
> drivers/net/phy/sfp.c                                      |    2
> drivers/net/vrf.c                                          |   58 +++--
> drivers/scsi/sd_zbc.c                                      |  104 +++++++=
--
> fs/ext4/dir.c                                              |   19 -
> fs/ext4/ext4_jbd2.h                                        |   12 -
> fs/ext4/file.c                                             |    4
> fs/ext4/inode.c                                            |   24 +-
> fs/ext4/ioctl.c                                            |   46 ++++
> fs/ext4/move_extent.c                                      |    3
> fs/ext4/namei.c                                            |   45 +++-
> fs/jbd2/commit.c                                           |   23 +-
> fs/jbd2/journal.c                                          |    4
> fs/jbd2/transaction.c                                      |   49 ++--
> include/linux/blkdev.h                                     |    5
> include/linux/fs.h                                         |    2
> include/linux/jbd2.h                                       |   22 ++
> include/linux/mlx5/mlx5_ifc.h                              |    3
> include/linux/perf_event.h                                 |    5
> include/net/dst.h                                          |    5
> include/net/tcp.h                                          |    8
> include/net/tls.h                                          |    1
> kernel/events/core.c                                       |   83 +++++--
> mm/filemap.c                                               |   22 ++
> net/bridge/br_input.c                                      |    8
> net/bridge/br_multicast.c                                  |   23 +-
> net/bridge/br_stp_bpdu.c                                   |    3
> net/core/filter.c                                          |    2
> net/core/neighbour.c                                       |    2
> net/ipv4/devinet.c                                         |    8
> net/ipv4/igmp.c                                            |    8
> net/ipv4/tcp.c                                             |    6
> net/ipv4/tcp_cong.c                                        |    6
> net/ipv4/tcp_output.c                                      |   13 +
> net/ipv6/ip6_fib.c                                         |   18 +
> net/ipv6/route.c                                           |    2
> net/netfilter/nf_queue.c                                   |    6
> net/netrom/af_netrom.c                                     |    4
> net/nfc/nci/data.c                                         |    2
> net/openvswitch/actions.c                                  |    6
> net/rxrpc/af_rxrpc.c                                       |    4
> net/sched/cls_api.c                                        |    3
> net/sched/sch_fq_codel.c                                   |    2
> net/sched/sch_sfq.c                                        |    2
> net/sctp/socket.c                                          |   24 --
> net/sctp/stream.c                                          |    9
> net/tls/tls_device.c                                       |   10
> net/tls/tls_main.c                                         |    4
> net/tls/tls_sw.c                                           |    3
> tools/perf/builtin-script.c                                |    3
> tools/testing/selftests/net/txring_overwrite.c             |    2
> 82 files changed, 851 insertions(+), 334 deletions(-)
>
>Alexander Shishkin (1):
>      perf/core: Fix exclusive events' grouping
>
>Andreas Steinmetz (2):
>      macsec: fix use-after-free of skb during RX
>      macsec: fix checksumming after decryption
>
>Andrew Lunn (1):
>      net: phy: sfp: hwmon: Fix scaling of RX power
>
>Aya Levin (3):
>      net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn
>      net/mlx5e: Fix return value from timeout recover function
>      net/mlx5e: Fix error flow in tx reporter diagnose
>
>Baruch Siach (1):
>      net: dsa: mv88e6xxx: wait after reset deactivation
>
>Brian King (1):
>      bnx2x: Prevent load reordering in tx completion processing
>
>Chris Wilson (1):
>      dma-buf: Discard old fence_excl on retrying get_fences_rcu for reall=
oc
>
>Christoph Paasch (1):
>      tcp: Reset bytes_acked and bytes_received when disconnecting
>
>Cong Wang (3):
>      net_sched: unset TCQ_F_CAN_BYPASS when adding filters
>      netrom: fix a memory leak in nr_rx_frame()
>      netrom: hold sock when setting skb->destructor
>
>Damien Le Moal (2):
>      sd_zbc: Fix report zones buffer allocation
>      block: Limit zone array allocation size
>
>Darrick J. Wong (1):
>      ext4: don't allow any modifications to an immutable file
>
>David Ahern (1):
>      ipv6: rt6_check should return NULL if 'from' is NULL
>
>David Howells (1):
>      rxrpc: Fix send on a connected, but unbound socket
>
>Eli Britstein (1):
>      net/mlx5e: Fix port tunnel GRE entropy control
>
>Eric Dumazet (3):
>      igmp: fix memory leak in igmpv3_del_delrec()
>      tcp: be more careful in tcp_fragment()
>      tcp: fix tcp_set_congestion_control() use from bpf hook
>
>Florian Westphal (1):
>      net: make skb_dst_force return true when dst is refcounted
>
>Frank de Brabander (1):
>      selftests: txring_overwrite: fix incorrect test of mmap() return val=
ue
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.4
>
>Haiyang Zhang (1):
>      hv_netvsc: Fix extra rcu_read_unlock in netvsc_recv_callback()
>
>Heiner Kallweit (1):
>      r8169: fix issue with confused RX unit after PHY power-down on RTL84=
11b
>
>Ido Schimmel (2):
>      ipv6: Unlink sibling route in case of failure
>      mlxsw: spectrum: Do not process learned records with a dummy FID
>
>Jakub Kicinski (3):
>      net/tls: make sure offload also gets the keys wiped
>      net/tls: fix poll ignoring partially copied records
>      net/tls: reject offload of TLS 1.3
>
>Jan Kiszka (1):
>      KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
>
>John Hurley (1):
>      net: openvswitch: fix csum updates for MPLS actions
>
>Jose Abreu (1):
>      net: stmmac: Re-work the queue selection for TSO packets
>
>Justin Chen (1):
>      net: bcmgenet: use promisc for unsupported filters
>
>J=E9r=F4me Glisse (1):
>      dma-buf: balance refcount inbalance
>
>Keerthy (1):
>      gpio: davinci: silence error prints in case of EPROBE_DEFER
>
>Linus Walleij (1):
>      Revert "gpio/spi: Fix spi-gpio regression on active high CS"
>
>Lorenzo Bianconi (1):
>      net: neigh: fix multiple neigh timer scheduling
>
>Maor Gottlieb (1):
>      net/mlx5: E-Switch, Fix default encap mode
>
>Marcelo Ricardo Leitner (1):
>      sctp: fix error handling on stream scheduler initialization
>
>Matteo Croce (1):
>      ipv4: don't set IPv6 only flags to IPv4 addresses
>
>Michael Chan (1):
>      bnxt_en: Fix VNIC accounting when enabling aRFS on 57500 chips.
>
>Nikolay Aleksandrov (4):
>      net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report han=
dling
>      net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
>      net: bridge: don't cache ether dest pointer on input
>      net: bridge: stp: don't cache eth dest pointer before skb pull
>
>Nishka Dasgupta (1):
>      gpiolib: of: fix a memory leak in of_gpio_flags_quirks()
>
>Paolo Bonzini (2):
>      KVM: nVMX: do not use dangling shadow VMCS after guest reset
>      Revert "kvm: x86: Use task structs fpu field for user"
>
>Paul Cercueil (1):
>      MIPS: lb60: Fix pin mappings
>
>Peter Kosyh (1):
>      vrf: make sure skb->data contains ip header to make routing
>
>Peter Zijlstra (1):
>      perf/core: Fix race between close() and fork()
>
>Petr Machata (1):
>      mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed
>
>Ross Zwisler (3):
>      mm: add filemap_fdatawait_range_keep_errors()
>      jbd2: introduce jbd2_inode dirty range scoping
>      ext4: use jbd2_inode dirty range scoping
>
>Saeed Mahameed (1):
>      net/mlx5e: Rx, Fix checksum calculation for new hardware
>
>Song Liu (1):
>      perf script: Assume native_arch for pipe mode
>
>Taehee Yoo (1):
>      caif-hsi: fix possible deadlock in cfhsi_exit_module()
>
>Takashi Iwai (1):
>      sky2: Disable MSI on ASUS P6T
>
>Theodore Ts'o (2):
>      ext4: enforce the immutable flag on open files
>      ext4: allow directory holes
>
>Vlad Buslov (1):
>      net: sched: verify that q!=3DNULL before setting q->flags
>
>Xin Long (1):
>      sctp: not bind the socket in sctp_connect
>
>Yang Wei (1):
>      nfc: fix potential illegal memory access
>



--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl09THEACgkQsjqdtxFL
KRUcAwf5AWnTiZo48WM/frEkZkoRSaQGj2Y/wOrlLOb3jJAd1kPF+DknVgSfp5Kw
Fs0PT6UiKsGZYxrawwRkiWIN0UvwUUarYko7nO5JAOdi14/l7mKmUNpMgc1TWeTa
NsPq8rOoZUChkCZ9BExroSFcmgDiUgnwbqnz339BWW8JKeoIbYsxo6LWCpoTAx+I
Z7VkGua30Oa6bOelG7qmY9Mv01OFiMV0rZimsCCJk0CarR1GHqB7CsByEYe8GUKa
9QpMPwU/rHhntpf95VSgw5rm02rXpAqAysSU+zjsVf565UeJGIzQiakjKhUDSbHk
mJ/STwEXcR8+shp5sngBWBDi7xPVtQ==
=WTqn
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
