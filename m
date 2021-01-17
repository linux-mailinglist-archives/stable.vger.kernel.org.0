Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCA2F9297
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbhAQNji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbhAQNjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:39:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F62C20678;
        Sun, 17 Jan 2021 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610890730;
        bh=W6bBl/7b/ZMMKOSDyIz5pdYAILJwKRso+cq6CSgLVL0=;
        h=From:To:Cc:Subject:Date:From;
        b=YfBLWakVT3F1iMrto0KcN/CqVyep+9QZfcmwdmEbyhGZzPIZKkt8LceO4cK0ty1xi
         s3gAyd0Eu7Pppi3DxHAuUm9RKOtwh/b6wMamv2WUwslEmO5ghmZHohSvyHzeJ9v/LD
         Adl7FgOxIofCRTGb77jSk/1Ipf0aRDt/kb/uXSpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.252
Date:   Sun, 17 Jan 2021 14:38:45 +0100
Message-Id: <161089072586173@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.252 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/mach-omap2/omap_device.c               |    8 
 arch/arm64/kvm/sys_regs.c                       |    4 
 arch/powerpc/include/asm/book3s/32/pgtable.h    |    4 
 arch/powerpc/include/asm/nohash/pgtable.h       |    4 
 block/genhd.c                                   |    9 
 drivers/block/Kconfig                           |    1 
 drivers/cpufreq/powernow-k8.c                   |    9 
 drivers/dma/xilinx/xilinx_dma.c                 |    8 
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |    2 
 drivers/iommu/intel_irq_remapping.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |    1 
 drivers/net/wan/Kconfig                         |    1 
 drivers/net/wireless/ath/wil6210/Kconfig        |    1 
 drivers/spi/spi-pxa2xx.c                        |    3 
 drivers/target/target_core_transport.c          |   24 ++
 drivers/target/target_core_xcopy.c              |  220 ++++++++++++++----------
 drivers/target/target_core_xcopy.h              |    1 
 fs/ubifs/io.c                                   |   13 +
 include/asm-generic/vmlinux.lds.h               |    5 
 include/target/target_core_base.h               |    4 
 net/core/skbuff.c                               |    6 
 net/ipv4/ip_output.c                            |    2 
 net/ipv4/ip_tunnel.c                            |   10 -
 24 files changed, 228 insertions(+), 116 deletions(-)

Andreas Kemnade (1):
      ARM: OMAP2+: omap_device: fix idling of devices during probe

Arnd Bergmann (3):
      wil6210: select CONFIG_CRC32
      block: rsxx: select CONFIG_CRC32
      wan: ds26522: select CONFIG_BITREVERSE

Chris Wilson (1):
      drm/i915: Fix mismatch between misplaced vma check and vma insert

Colin Ian King (1):
      cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

David Disseldorp (5):
      target: bounds check XCOPY segment descriptor list
      target: simplify XCOPY wwn->se_dev lookup helper
      target: use XCOPY segment descriptor CSCD IDs
      scsi: target: Fix XCOPY NAA identifier lookup
      target: add XCOPY target/segment desc sense codes

Dinghao Liu (2):
      iommu/intel: Fix memleak in intel_irq_remapping_alloc
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Florian Westphal (2):
      net: ip: always refragment ip defragmented packets
      net: fix pmtu check in nopmtudisc mode

Greg Kroah-Hartman (1):
      Linux 4.9.252

Lukas Wunner (1):
      spi: pxa2xx: Fix use-after-free on unbind

Marc Zyngier (1):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Mathieu Desnoyers (1):
      powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

Mike Christie (1):
      xcopy: loop over devices using idr helper

Ming Lei (1):
      block: fix use-after-free in disk_part_iter_next

Nick Desaulniers (1):
      vmlinux.lds.h: Add PGO and AutoFDO input sections

Richard Weinberger (1):
      ubifs: wbuf: Don't leak kernel memory to flash

Shravya Kumbham (2):
      dmaengine: xilinx_dma: check dma_async_device_register return value
      dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

