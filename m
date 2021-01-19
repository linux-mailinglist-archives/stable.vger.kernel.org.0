Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3923A2FC04B
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 20:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbhASTq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 14:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbhASTo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 14:44:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B807230FE;
        Tue, 19 Jan 2021 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611085426;
        bh=79vhQIf6gbbZOYaxmyDna1ucaWKzRDifHOqFBJbDNvo=;
        h=From:To:Cc:Subject:Date:From;
        b=FWNX+iW9Hn2S+uEnINR9umuHvYPH7mXIyKstJ05iWLPO20RJXuDrXI6dPipMHJjIe
         d7oayUwPo9e5blkpnpWTmTlE15py5WHFu0ja9vOAQyU9P7AtaekeTvJq/3peowT+46
         MHYXm99UktpGVU0T0+gWpI+ARP1sj0U3xeCtkbPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.169
Date:   Tue, 19 Jan 2021 20:43:42 +0100
Message-Id: <1611085422217146@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.169 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    4 +--
 arch/arc/Makefile                                    |    9 +------
 arch/arc/include/asm/page.h                          |    1 
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi               |    4 +++
 arch/mips/boot/compressed/decompress.c               |    3 +-
 arch/mips/kernel/relocate.c                          |   10 ++++++-
 arch/x86/hyperv/mmu.c                                |   12 +++++++--
 block/bfq-iosched.c                                  |    8 +++---
 drivers/acpi/internal.h                              |    2 -
 drivers/acpi/scan.c                                  |   15 +++++++++++
 drivers/gpu/drm/msm/msm_drv.c                        |    8 +++---
 drivers/infiniband/hw/mlx5/main.c                    |    2 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c         |    3 ++
 drivers/isdn/mISDN/Kconfig                           |    1 
 drivers/md/dm-integrity.c                            |    2 -
 drivers/md/dm-snap.c                                 |   24 +++++++++++++++++++
 drivers/md/dm.c                                      |    2 -
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c |    1 
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c     |    1 
 drivers/net/ethernet/freescale/ucc_geth.h            |    9 ++++++-
 drivers/net/usb/cdc_ether.c                          |    7 +++++
 drivers/net/usb/r8152.c                              |    1 
 fs/btrfs/qgroup.c                                    |   13 +++++++---
 fs/btrfs/super.c                                     |    8 ++++++
 fs/ext4/ioctl.c                                      |    3 ++
 fs/ext4/namei.c                                      |   16 +++++++-----
 fs/nfs/internal.h                                    |   12 +++++----
 fs/nfs/nfs4proc.c                                    |    2 -
 fs/nfs/pnfs.c                                        |    7 +++++
 include/linux/acpi.h                                 |    7 +++++
 kernel/trace/Kconfig                                 |    2 -
 kernel/trace/trace_kprobe.c                          |    2 -
 mm/hugetlb.c                                         |    2 -
 mm/slub.c                                            |    2 -
 net/netfilter/nf_conntrack_standalone.c              |    3 ++
 net/netfilter/nf_nat_core.c                          |    1 
 net/sunrpc/addr.c                                    |    2 -
 security/integrity/ima/ima_crypto.c                  |    2 -
 security/lsm_audit.c                                 |    7 +++--
 sound/firewire/fireface/ff-transaction.c             |    2 -
 sound/firewire/tascam/tascam-transaction.c           |    2 -
 sound/soc/intel/skylake/cnl-sst.c                    |    1 
 sound/soc/meson/axg-tdm-interface.c                  |   14 ++++++++++-
 sound/soc/soc-dapm.c                                 |    1 
 44 files changed, 184 insertions(+), 56 deletions(-)

Akilesh Kailash (1):
      dm snapshot: flush merged data before committing metadata

Al Viro (1):
      dump_common_audit_data(): fix racy accesses to ->d_name

Alexander Lobakin (1):
      MIPS: relocatable: fix possible boot hangup with KASLR enabled

Arnd Bergmann (2):
      misdn: dsp: select CONFIG_BITREVERSE
      ARM: picoxcell: fix missing interrupt-parent properties

Craig Tatlor (1):
      drm/msm: Call msm_init_vram before binding the gpu

Dan Carpenter (1):
      ASoC: Intel: fix error code cnl_set_dsp_D0()

Dave Wysochanski (1):
      NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock

Dexuan Cui (1):
      ACPI: scan: Harden acpi_device_add() against device ID overflows

Dinghao Liu (2):
      RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
      netfilter: nf_nat: Fix memleak in nf_nat_init

Filipe Manana (1):
      btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan

Geert Uytterhoeven (2):
      ALSA: firewire-tascam: Fix integer overflow in midi_port_work()
      ALSA: fireface: Fix integer overflow in transmit_midi_msg()

Greg Kroah-Hartman (1):
      Linux 4.19.169

Jan Kara (2):
      bfq: Fix computation of shallow depth
      ext4: fix superblock checksum failure when setting password salt

Jann Horn (1):
      mm, slub: consider rest of partial list if acquire_slab() fails

Jerome Brunet (1):
      ASoC: meson: axg-tdm-interface: fix loopback

Jesper Dangaard Brouer (1):
      netfilter: conntrack: fix reading nf_conntrack_buckets

Leon Schuermann (1):
      r8152: Add Lenovo Powered USB-C Travel Hub

Mark Bloch (1):
      RDMA/mlx5: Fix wrong free of blue flame register on error

Masahiro Yamada (3):
      ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
      ARC: build: add uImage.lzma to the top-level target
      ARC: build: add boot_targets to PHONY

Masami Hiramatsu (1):
      tracing/kprobes: Do the notrace functions check without kprobes on ftrace

Miaohe Lin (1):
      mm/hugetlb: fix potential missing huge page size info

Michael Ellerman (1):
      net: ethernet: fs_enet: Add missing MODULE_LICENSE

Mike Snitzer (1):
      dm: eliminate potential source of excessive kernel log noise

Mikulas Patocka (1):
      dm integrity: fix the maximum number of arguments

Olaf Hering (1):
      kbuild: enforce -Werror=return-type

Paul Cercueil (1):
      MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Randy Dunlap (1):
      arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Rasmus Villemoes (1):
      ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Roberto Sassu (1):
      ima: Remove __init annotation from ima_pcrread()

Shawn Guo (1):
      ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Thomas Hebb (1):
      ASoC: dapm: remove widget from dirty list on free

Trond Myklebust (3):
      pNFS: Mark layout for return if return-on-close was not sent
      NFS/pNFS: Fix a leak of the layout 'plh_outstanding' counter
      NFS: nfs_igrab_and_active must first reference the superblock

Wei Liu (1):
      x86/hyperv: check cpu mask after interrupt has been disabled

j.nixdorf@avm.de (1):
      net: sunrpc: interpret the return value of kstrtou32 correctly

yangerkun (1):
      ext4: fix bug for rename with RENAME_WHITEOUT

