Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0B21387D3
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbgALTDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 14:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgALTDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 14:03:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 874CC214D8;
        Sun, 12 Jan 2020 19:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578855817;
        bh=DUHEvPQQI/Rxp62H64mo/osUXIh4fT0IfW8kfp+NWUk=;
        h=Date:From:To:Cc:Subject:From;
        b=akQOcKigAWJ+qfNd0H0tvN955yXiXDaFK3BaoHZSZKDlZw9W+FF3wWfG4WX2dtWAi
         cVVvvZMIT5vRll42VXpYGHdlQ1Itb33B4joWDJn5GbXQ/gAyqaAVIWIEyT68LCT81p
         //5NkMF2HvWJsoD/1dmmZBNJ43v1/2t0U8A+e4Ms=
Date:   Sun, 12 Jan 2020 20:03:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.164
Message-ID: <20200112190334.GA1364444@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.164 kernel.

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

 Makefile                                          |    2=20
 arch/arm/boot/dts/am437x-gp-evm.dts               |    2=20
 arch/arm/boot/dts/am43x-epos-evm.dts              |    2=20
 arch/arm/boot/dts/bcm-cygnus.dtsi                 |    4=20
 arch/arm/boot/dts/bcm283x.dtsi                    |    2=20
 arch/arm/mach-vexpress/spc.c                      |   12=20
 arch/mips/net/ebpf_jit.c                          |    9=20
 arch/parisc/include/asm/cmpxchg.h                 |   10=20
 arch/powerpc/mm/mem.c                             |    8=20
 arch/x86/events/core.c                            |    9=20
 arch/x86/platform/efi/quirks.c                    |    6=20
 block/blk-map.c                                   |    2=20
 drivers/firmware/efi/libstub/gop.c                |   80 +----
 drivers/mmc/core/block.c                          |  300 +++++++++++++++++=
++---
 drivers/mmc/core/queue.c                          |    2=20
 drivers/mmc/core/queue.h                          |    4=20
 drivers/net/dsa/mv88e6xxx/global1.c               |    5=20
 drivers/net/dsa/mv88e6xxx/global1.h               |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   12=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |   12=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |    3=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   14 -
 drivers/net/gtp.c                                 |    5=20
 drivers/net/hyperv/hyperv_net.h                   |    3=20
 drivers/net/hyperv/netvsc_drv.c                   |    4=20
 drivers/net/hyperv/rndis_filter.c                 |   10=20
 drivers/net/macvlan.c                             |    2=20
 drivers/net/usb/lan78xx.c                         |   11=20
 drivers/net/vxlan.c                               |    4=20
 drivers/net/wireless/marvell/mwifiex/tdls.c       |   70 ++++-
 drivers/pci/switch/switchtec.c                    |    4=20
 drivers/regulator/rn5t618-regulator.c             |    1=20
 drivers/s390/block/dasd_eckd.c                    |   28 --
 drivers/s390/cio/device_ops.c                     |    2=20
 drivers/spi/spi-cavium-thunderx.c                 |    2=20
 drivers/usb/core/config.c                         |   70 ++++-
 drivers/usb/gadget/udc/dummy_hcd.c                |   10=20
 drivers/usb/serial/option.c                       |    2=20
 fs/drop_caches.c                                  |    2=20
 fs/inode.c                                        |    7=20
 fs/notify/fsnotify.c                              |    1=20
 fs/quota/dquot.c                                  |    1=20
 include/linux/if_ether.h                          |    8=20
 include/uapi/linux/netfilter/xt_sctp.h            |    6=20
 kernel/bpf/verifier.c                             |   54 ++-
 kernel/locking/spinlock_debug.c                   |   32 +-
 net/8021q/vlan.h                                  |    1=20
 net/8021q/vlan_dev.c                              |    3=20
 net/8021q/vlan_netlink.c                          |   19 -
 net/ipv4/tcp_input.c                              |    5=20
 net/llc/llc_station.c                             |    4=20
 net/netfilter/nf_conntrack_netlink.c              |    3=20
 net/netfilter/nf_tables_api.c                     |   12=20
 net/rfkill/core.c                                 |    7=20
 net/sched/sch_fq.c                                |    2=20
 net/sched/sch_prio.c                              |   10=20
 net/sctp/sm_sideeffect.c                          |   28 +-
 samples/bpf/syscall_tp_kern.c                     |   18 +
 samples/bpf/trace_event_user.c                    |    4=20
 scripts/kconfig/expr.c                            |    7=20
 sound/soc/codecs/wm8962.c                         |    4=20
 sound/soc/soc-topology.c                          |    8=20
 tools/lib/traceevent/Makefile                     |    1=20
 tools/testing/selftests/bpf/test_verifier.c       |   58 ++++
 67 files changed, 777 insertions(+), 262 deletions(-)

Aditya Pakki (1):
      rfkill: Fix incorrect check to avoid NULL pointer dereference

Alexander Kappner (1):
      mmc: core: Prevent bus reference leak in mmc_blk_init()

Alexander Shishkin (1):
      perf/x86/intel: Fix PT PMI handling

Andreas Kemnade (1):
      regulator: rn5t618: fix module aliases

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Preserve priority when setting CPU port.

Andrey Konovalov (2):
      USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein
      USB: dummy-hcd: increase max number of devices to 32

Arvind Sankar (3):
      efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
      efi/gop: Return EFI_SUCCESS if a usable GOP was found
      efi/gop: Fix memory leak in __gop_query32/64()

Chan Shu Tak, Alex (1):
      llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _te=
st_c)

Chen-Yu Tsai (2):
      net: stmmac: dwmac-sun8i: Allow all RGMII modes
      net: stmmac: dwmac-sunxi: Allow all RGMII modes

Chuhong Yuan (1):
      spi: spi-cavium-thunderx: Add missing pci_release_regions()

Cristian Birsan (1):
      net: usb: lan78xx: Fix error message format specifier

Daniel Borkmann (2):
      bpf: reject passing modified ctx to helper functions
      bpf: Fix passing modified ctx to ld/abs/ind instruction

Daniel T. Lee (2):
      samples: bpf: Replace symbol compare of trace_event
      samples: bpf: fix syscall_tp due to unused syscall

Daniele Palmas (1):
      USB: serial: option: add Telit ME910G1 0x110a composition

Dave Young (1):
      x86/efi: Update e820 with reserved EFI boot services data to fix kexe=
c breakage

Dragos Tarcatu (1):
      ASoC: topology: Check return value for soc_tplg_pcm_create()

Eric Dumazet (6):
      gtp: fix bad unlock balance in gtp_encap_enable_socket
      macvlan: do not assume mac_header is set in macvlan_broadcast()
      net: usb: lan78xx: fix possible skb leak
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      vlan: vlan_changelink() should propagate errors
      vlan: fix memory leak in vlan_dev_set_egress_priority

Eric Sandeen (1):
      fs: avoid softlockups in s_inodes iterators

Florian Fainelli (1):
      ARM: dts: Cygnus: Fix MDIO node address/size cells

Florian Westphal (1):
      netfilter: ctnetlink: netns exit must wait for callbacks

Greg Kroah-Hartman (1):
      Linux 4.14.164

Haiyang Zhang (1):
      hv_netvsc: Fix unwanted rx_table reset

Hangbin Liu (1):
      vxlan: fix tos value before xmit

Helge Deller (1):
      parisc: Fix compiler warnings in debug_core.c

Jan H=F6ppner (1):
      s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly

Johan Hovold (1):
      USB: core: fix check for duplicate endpoints

Jose Abreu (2):
      net: stmmac: Do not accept invalid MTU values
      net: stmmac: RX buffer size must be 16 byte aligned

Linus Walleij (3):
      mmc: block: Convert RPMB to a character device
      mmc: block: Delete mmc_access_rpmb()
      mmc: block: Fix bug when removing RPMB chardev

Logan Gunthorpe (1):
      PCI/switchtec: Read all 64 bits of part_event_bitmap

Manish Chopra (2):
      bnx2x: Do not handle requests from VFs after parity
      bnx2x: Fix logic to get total no. of PFs per engine

Marco Elver (1):
      locking/spinlock/debug: Fix various data races

Mathieu Malaterre (1):
      mmc: block: propagate correct returned value in mmc_rpmb_ioctl

Mike Rapoport (1):
      powerpc: Ensure that swiotlb buffer is allocated from low memory

Pablo Neira Ayuso (1):
      netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END

Paul Chaignon (1):
      bpf, mips: Limit to 33 tail calls

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Petr Machata (1):
      net: sch_prio: When ungrafting, replace with FIFO

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value

Stefan Haberland (1):
      s390/dasd: fix memleak in path handling error case

Stefan Wahren (1):
      ARM: dts: bcm283x: Fix critical trip point

Sudeep Holla (1):
      ARM: vexpress: Set-up shared OPP table instead of individual for each=
 CPU

Sudip Mukherjee (1):
      libtraceevent: Fix lib installation with O=3D

Thomas Hebb (1):
      kconfig: don't crash on NULL expressions in expr_eq()

Tomi Valkeinen (1):
      ARM: dts: am437x-gp/epos-evm: fix panel compatible

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Yang Yingliang (1):
      block: fix memleak when __blk_rq_map_user_iov() is failed

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4bbYYACgkQONu9yGCS
aT5SFA/7Bg9PVux3QYb7469WipJ2lRteDbSdiCIuCK6qzQKRJ3CxwyFIBXGsyQLW
qeWZ8SdPh17ooJHA4jTu5qyvAsu5OYmhXfTeF/mdo9smHrBw3nxcugx3RunV+RPa
yElGzHNeWB2Sb/vPTdhLwqwf40chUEGqeqawvNtZDeKY1pM6c6OE0G3nJ/sKsaXj
G+EarLkhkElwhMsfq7BlJo00yAcumf3D3IwdglTQ4xxSW164fBSmAtqW1dF2opdj
+koMytpMGXxBZp/6kYarPgdcBK3P+I7LhZkBNEMBJr3K9Hs/0jsKESxPggI0vgX+
jgQCCyLRpqP0qMsUzjQU4RU/Ebog8BGtkCIGEYRA1TeHWktUtlB2M6KpCoVlcCLJ
VLPf4SVQ0+D93quIui80GDLMbw7lr6ArDYoYG0RmTyDQ/Zg0nmnWqncBgWPjmZjK
QqafJmbP5E6fcACv6/MzVl+4qw3M85iGHFun9xDlpIGmM5/499Wqal/nSgwzt3rJ
7ea2JtI6Qxj9Du9nXpXqZ8elvBSur/C12OYLSi7ZUNRtfm700Q7/K2pCJ64KUFKI
QPSxoeNLHZxXHJ3jqLsuVllOyJShJXaKr6ezlU6DP6fC/1zhZZrbjItVs8DrI8MO
ptDcSu/ccJ7+VvrIfw6dlRmNBYg7Tn99L3Hxz3iC/H4P4TBWmn0=
=hmhO
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
