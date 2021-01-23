Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9026301644
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbhAWPVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbhAWPVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:21:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F32233EF;
        Sat, 23 Jan 2021 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611415231;
        bh=oU5ZEBLIavdSN3S2/yMu7Cbmm7cPcObUbriP4fUJ6JI=;
        h=From:To:Cc:Subject:Date:From;
        b=rBEKIeC+jrJReyeE91lW32dxq+e5TycUv/UIxU57tpInpdOUtwRD/6fgJUd0vdZQJ
         QF6dwupNub/Y051pVqWoCEtYE3AajBBAggV4eLAZ8V5TaUTWu9asvWoN1lm60P9+HG
         ysyMteg5l974QVJAHF9rvA3yfg2G9MLICdrpkRNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.217
Date:   Sat, 23 Jan 2021 16:20:24 +0100
Message-Id: <1611415225185227@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.217 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arc/Makefile                                    |    9 ----
 arch/arc/include/asm/page.h                          |    1 
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi               |    4 +
 arch/mips/boot/compressed/decompress.c               |    3 -
 arch/mips/kernel/relocate.c                          |   10 +++-
 drivers/acpi/internal.h                              |    2 
 drivers/acpi/scan.c                                  |   15 ++++++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c         |    3 +
 drivers/isdn/mISDN/Kconfig                           |    1 
 drivers/md/dm-snap.c                                 |   24 +++++++++++
 drivers/md/dm.c                                      |    2 
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c |    1 
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c     |    1 
 drivers/net/ethernet/freescale/ucc_geth.h            |    9 +++-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    7 ---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    3 -
 drivers/net/usb/cdc_ether.c                          |    7 +++
 drivers/net/usb/r8152.c                              |    1 
 drivers/net/usb/rndis_host.c                         |    2 
 drivers/spi/spi-cadence.c                            |    6 +-
 drivers/usb/host/ohci-hcd.c                          |    2 
 fs/btrfs/qgroup.c                                    |   13 ++++--
 fs/btrfs/super.c                                     |    8 +++
 fs/ext4/ioctl.c                                      |    3 +
 fs/ext4/namei.c                                      |   16 ++++---
 fs/nfs/internal.h                                    |   12 +++--
 fs/nfs/nfs4proc.c                                    |    2 
 fs/nfs/pnfs.c                                        |    6 ++
 fs/nfsd/nfs3xdr.c                                    |    7 ++-
 include/linux/acpi.h                                 |    7 +++
 include/linux/skbuff.h                               |   16 +++++++
 mm/hugetlb.c                                         |    2 
 mm/slub.c                                            |    2 
 net/core/skbuff.c                                    |    9 +++-
 net/dcb/dcbnl.c                                      |    2 
 net/ipv4/esp4.c                                      |    7 ---
 net/ipv6/esp6.c                                      |    7 ---
 net/ipv6/ip6_output.c                                |   40 ++++++++++++++++++-
 net/ipv6/sit.c                                       |    5 +-
 net/netfilter/nf_conntrack_standalone.c              |    3 +
 net/rxrpc/key.c                                      |    6 +-
 net/sunrpc/addr.c                                    |    2 
 net/tipc/link.c                                      |    9 +++-
 security/lsm_audit.c                                 |    7 ++-
 sound/firewire/fireface/ff-transaction.c             |    2 
 sound/firewire/tascam/tascam-transaction.c           |    2 
 sound/soc/intel/skylake/cnl-sst.c                    |    1 
 sound/soc/soc-dapm.c                                 |    1 
 49 files changed, 242 insertions(+), 70 deletions(-)

Akilesh Kailash (1):
      dm snapshot: flush merged data before committing metadata

Al Viro (1):
      dump_common_audit_data(): fix racy accesses to ->d_name

Alexander Lobakin (1):
      MIPS: relocatable: fix possible boot hangup with KASLR enabled

Andrey Zhizhikin (1):
      rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Arnd Bergmann (2):
      misdn: dsp: select CONFIG_BITREVERSE
      ARM: picoxcell: fix missing interrupt-parent properties

Aya Levin (1):
      net: ipv6: Validate GSO SKB before finish IPv6 processing

Dan Carpenter (1):
      ASoC: Intel: fix error code cnl_set_dsp_D0()

Dave Wysochanski (1):
      NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock

David Howells (1):
      rxrpc: Fix handling of an unsupported token type in rxrpc_read()

David Wu (1):
      net: stmmac: Fixed mtu channged by cache aligned

Dexuan Cui (1):
      ACPI: scan: Harden acpi_device_add() against device ID overflows

Dinghao Liu (1):
      RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp

Edward Cree (1):
      net: use skb_list_del_init() to remove from RX sublists

Eric Dumazet (1):
      net: avoid 32 x truesize under-estimation for tiny skbs

Filipe Manana (1):
      btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan

Geert Uytterhoeven (2):
      ALSA: firewire-tascam: Fix integer overflow in midi_port_work()
      ALSA: fireface: Fix integer overflow in transmit_midi_msg()

Greg Kroah-Hartman (1):
      Linux 4.14.217

Hamish Martin (1):
      usb: ohci: Make distrust_firmware param default to false

Hoang Le (1):
      tipc: fix NULL deref in tipc_link_xmit()

J. Bruce Fields (1):
      nfsd4: readdirplus shouldn't return parent of export

Jakub Kicinski (1):
      net: sit: unregister_netdevice on newlink's error path

Jan Kara (1):
      ext4: fix superblock checksum failure when setting password salt

Jann Horn (1):
      mm, slub: consider rest of partial list if acquire_slab() fails

Jason A. Donenfeld (2):
      net: introduce skb_list_walk_safe for skb segment walking
      net: skbuff: disambiguate argument and member for skb_list_walk_safe helper

Jesper Dangaard Brouer (1):
      netfilter: conntrack: fix reading nf_conntrack_buckets

Leon Schuermann (1):
      r8152: Add Lenovo Powered USB-C Travel Hub

Manish Chopra (1):
      netxen_nic: fix MSI/MSI-x interrupts

Masahiro Yamada (3):
      ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
      ARC: build: add uImage.lzma to the top-level target
      ARC: build: add boot_targets to PHONY

Miaohe Lin (1):
      mm/hugetlb: fix potential missing huge page size info

Michael Ellerman (1):
      net: ethernet: fs_enet: Add missing MODULE_LICENSE

Michael Hennerich (1):
      spi: cadence: cache reference clock rate during probe

Mike Snitzer (1):
      dm: eliminate potential source of excessive kernel log noise

Paul Cercueil (1):
      MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Petr Machata (2):
      net: dcb: Validate netlink message in DCB handler
      net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Randy Dunlap (1):
      arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Rasmus Villemoes (1):
      ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Shawn Guo (1):
      ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Thomas Hebb (1):
      ASoC: dapm: remove widget from dirty list on free

Trond Myklebust (2):
      pNFS: Mark layout for return if return-on-close was not sent
      NFS: nfs_igrab_and_active must first reference the superblock

Willem de Bruijn (1):
      esp: avoid unneeded kmap_atomic call

j.nixdorf@avm.de (1):
      net: sunrpc: interpret the return value of kstrtou32 correctly

yangerkun (1):
      ext4: fix bug for rename with RENAME_WHITEOUT

