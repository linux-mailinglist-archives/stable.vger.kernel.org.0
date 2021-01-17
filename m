Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9642F929A
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbhAQNj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:39:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbhAQNjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:39:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC118206B7;
        Sun, 17 Jan 2021 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610890736;
        bh=Iti4g44/QVOJQT4yyhb3xEiqNZY1yo3swuP/NDJMCZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=0bHuivl3TcsjsQTcgLJ8GOkvrRWf8RKZGmfqeKGQ04MOTKcARPtVRJ3k5zNck58FX
         Qk0JLmedRZ4gkcsEMXlJNDI7hKUBZ3ZPYvGaIhU4V9vRWKwCGkKhMrze476VTV5OmQ
         Y9yFRrNbQUusEYIQhVzhyjUUu2Res99edvRJpgfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.216
Date:   Sun, 17 Jan 2021 14:38:50 +0100
Message-Id: <161089073191184@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.216 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/mach-omap2/omap_device.c               |    8 +
 arch/arm64/kvm/sys_regs.c                       |    4 
 arch/powerpc/include/asm/book3s/32/pgtable.h    |    4 
 arch/powerpc/include/asm/nohash/pgtable.h       |    4 
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c        |  110 ++++++++++--------------
 block/genhd.c                                   |    9 +
 drivers/block/Kconfig                           |    1 
 drivers/cpufreq/powernow-k8.c                   |    9 -
 drivers/dma/xilinx/xilinx_dma.c                 |    8 +
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |    2 
 drivers/i2c/busses/i2c-sprd.c                   |    8 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c  |   26 ++++-
 drivers/iommu/intel_irq_remapping.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |    3 
 drivers/net/usb/cdc_ncm.c                       |    8 +
 drivers/net/wan/Kconfig                         |    1 
 drivers/net/wireless/ath/wil6210/Kconfig        |    1 
 drivers/spi/spi-pxa2xx.c                        |    3 
 drivers/spi/spi-stm32.c                         |    4 
 fs/ubifs/io.c                                   |   13 ++
 include/asm-generic/vmlinux.lds.h               |    5 -
 net/8021q/vlan.c                                |    3 
 net/core/skbuff.c                               |    6 +
 net/ipv4/ip_output.c                            |    2 
 net/ipv4/ip_tunnel.c                            |   10 +-
 26 files changed, 152 insertions(+), 104 deletions(-)

Andreas Kemnade (1):
      ARM: OMAP2+: omap_device: fix idling of devices during probe

Arnd Bergmann (3):
      wil6210: select CONFIG_CRC32
      block: rsxx: select CONFIG_CRC32
      wan: ds26522: select CONFIG_BITREVERSE

Chris Wilson (1):
      drm/i915: Fix mismatch between misplaced vma check and vma insert

Chunyan Zhang (1):
      i2c: sprd: use a specific timeout to avoid system hang up issue

Colin Ian King (1):
      cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Dinghao Liu (3):
      iommu/intel: Fix memleak in intel_irq_remapping_alloc
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
      net/mlx5e: Fix two double free cases

Fenghua Yu (2):
      x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR
      x86/resctrl: Don't move a task to the same resource group

Florian Westphal (2):
      net: ip: always refragment ip defragmented packets
      net: fix pmtu check in nopmtudisc mode

Greg Kroah-Hartman (1):
      Linux 4.14.216

Jakub Kicinski (1):
      net: vlan: avoid leaks on register_vlan_dev() failures

Jouni K. Seppänen (1):
      net: cdc_ncm: correct overhead in delayed_ndp_size

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Lukas Wunner (1):
      spi: pxa2xx: Fix use-after-free on unbind

Marc Zyngier (1):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Mathieu Desnoyers (1):
      powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

Ming Lei (1):
      block: fix use-after-free in disk_part_iter_next

Nick Desaulniers (1):
      vmlinux.lds.h: Add PGO and AutoFDO input sections

Richard Weinberger (1):
      ubifs: wbuf: Don't leak kernel memory to flash

Roman Guskov (1):
      spi: stm32: FIFO threshold level - fix align packet size

Sean Nyekjaer (1):
      iio: imu: st_lsm6dsx: flip irq return logic

Shravya Kumbham (2):
      dmaengine: xilinx_dma: check dma_async_device_register return value
      dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

