Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E83316171
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBJIsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230246AbhBJIn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:43:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD68F64E08;
        Wed, 10 Feb 2021 08:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612946579;
        bh=fm/1iBUuELZAZD+DQ40wwlDUQ+v8zTJmcc49QnMkCu0=;
        h=From:To:Cc:Subject:Date:From;
        b=UxjtaTMzJ1ozyHdYDjmzgu0CnvIdD7iFbzWnEwSKxkZ1Ed9yS+C2cM4K7VHC5Vp4S
         FnO7xeX1TLyJhdCgWLE2AjEAqglXcXNEYahBvvh+KCoqd0BCiOSWONAoDL7U1palmg
         6stlhSAM5P2HGJ5dKqVsPZdBStcTxux5s2vTYX6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.221
Date:   Wed, 10 Feb 2021 09:42:54 +0100
Message-Id: <1612946575884@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.221 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    8 -----
 arch/arm/mach-footbridge/dc21285.c             |   12 +++----
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi |    2 -
 arch/x86/Makefile                              |    3 +
 arch/x86/include/asm/apic.h                    |   10 ------
 arch/x86/include/asm/barrier.h                 |   18 +++++++++++
 arch/x86/kernel/apic/apic.c                    |    4 ++
 arch/x86/kernel/apic/x2apic_cluster.c          |    6 ++-
 arch/x86/kernel/apic/x2apic_phys.c             |    6 ++-
 drivers/input/joystick/xpad.c                  |   17 ++++++++++-
 drivers/input/serio/i8042-x86ia64io.h          |    2 +
 drivers/iommu/intel-iommu.c                    |    6 +++
 drivers/mmc/core/sdio_cis.c                    |    6 +++
 drivers/net/dsa/mv88e6xxx/chip.c               |    6 +++
 drivers/nvme/host/pci.c                        |    2 +
 drivers/usb/class/usblp.c                      |   19 +++++++-----
 drivers/usb/dwc2/gadget.c                      |    8 -----
 drivers/usb/gadget/legacy/ether.c              |    4 +-
 drivers/usb/host/xhci-ring.c                   |   31 +++++++++++++-------
 drivers/usb/serial/cp210x.c                    |    2 +
 drivers/usb/serial/option.c                    |    6 +++
 fs/cifs/dir.c                                  |   22 +++++++++++++-
 fs/cifs/smb2pdu.h                              |    2 -
 fs/hugetlbfs/inode.c                           |    3 +
 fs/overlayfs/dir.c                             |    2 -
 include/linux/elfcore.h                        |   22 ++++++++++++++
 include/linux/hugetlb.h                        |    3 +
 kernel/Makefile                                |    1 
 kernel/elfcore.c                               |   26 -----------------
 kernel/kprobes.c                               |    4 ++
 mm/huge_memory.c                               |   37 +++++++++++++++---------
 mm/hugetlb.c                                   |    9 ++---
 net/ipv4/route.c                               |   38 ++++++++++++-------------
 net/lapb/lapb_out.c                            |    3 +
 net/mac80211/driver-ops.c                      |    5 ++-
 net/mac80211/rate.c                            |    3 +
 tools/objtool/orc_gen.c                        |   33 +++++++++++++++++----
 37 files changed, 254 insertions(+), 137 deletions(-)

Alexey Dobriyan (1):
      Input: i8042 - unbreak Pegatron C15B

Arnd Bergmann (1):
      elfcore: fix building with clang

Aurelien Aptel (1):
      cifs: report error instead of invalid when revalidating a dentry fails

Benjamin Valentin (1):
      Input: xpad - sync supported devices with fork on GitHub

Chenxin Jin (1):
      USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Christoph Schemmel (1):
      USB: serial: option: Adding support for Cinterion MV31

DENG Qingfang (1):
      net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Dan Carpenter (1):
      USB: gadget: legacy: fix an error code in eth_bind()

Dave Hansen (1):
      x86/apic: Add extra serialization for non-serializing MSRs

Felix Fietkau (1):
      mac80211: fix station rate table updates on assoc

Fengnan Chang (1):
      mmc: core: Limit retries when analyse of SDIO tuples fails

Greg Kroah-Hartman (1):
      Linux 4.14.221

Gustavo A. R. Silva (1):
      smb3: Fix out-of-bounds bug in SMB2_negotiate()

Heiko Stuebner (1):
      usb: dwc2: Fix endpoint direction check in ep_from_windex

Hugh Dickins (1):
      mm: thp: fix MADV_REMOVE deadlock on shmem THP

Jeremy Figgins (1):
      USB: usblp: don't call usb_set_interface if there's a single alt

Josh Poimboeuf (2):
      objtool: Support Clang non-section symbols in ORC generation
      x86/build: Disable CET instrumentation in the kernel

Liangyan (1):
      ovl: fix dentry leak in ovl_get_redirect

Mathias Nyman (1):
      xhci: fix bounce buffer usage for non-sg list case

Muchun Song (3):
      mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
      mm: hugetlb: fix a race between isolating and freeing page
      mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Nadav Amit (1):
      iommu/vt-d: Do not use flush-queue when caching-mode is on

Pho Tran (1):
      USB: serial: cp210x: add pid/vid for WSDA-200-USB

Russell King (1):
      ARM: footbridge: fix dc21285 PCI configuration accessors

Thorsten Leemhuis (1):
      nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs

Wang ShaoBo (1):
      kretprobe: Avoid re-registration of the same kretprobe earlier

Wei Wang (1):
      ipv4: fix race condition between route lookup and invalidation

Xie He (1):
      net: lapb: Copy the skb before sending a packet

Zyta Szpak (1):
      arm64: dts: ls1046a: fix dcfg address range

