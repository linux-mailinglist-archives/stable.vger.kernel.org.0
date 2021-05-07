Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80FA37650F
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhEGMZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236482AbhEGMZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 08:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60836144F;
        Fri,  7 May 2021 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620390250;
        bh=S6/t0miC2nkuU1eLxdltbIoUkmhZaYD0kby8VhdTEww=;
        h=From:To:Cc:Subject:Date:From;
        b=t4moXxv859Gb/KnQBgQE0e/WQHMBOb3iZsVVOky+zcGRx98O0fjZU30YmkRA02Tt6
         gdFOMkgSxhuJxs0rOI9zdU4sWbYFC/P5vSliCFPg/+VWke+AhjXbMzwA6E8g+B0PbU
         Yl4QHjPRv88xBZiA2vwLVqryPjNM4ueVZ9SdPbkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.19
Date:   Fri,  7 May 2021 14:24:01 +0200
Message-Id: <16203902415188@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.19 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/mips/include/asm/vdso/gettimeofday.h |   26 ++-
 drivers/gpu/drm/i915/i915_drv.c           |   10 +
 drivers/net/ethernet/intel/igb/igb_main.c |    3 
 drivers/net/usb/ax88179_178a.c            |    6 
 drivers/nvme/host/pci.c                   |    1 
 drivers/platform/x86/thinkpad_acpi.c      |   31 ++-
 drivers/usb/core/quirks.c                 |    4 
 drivers/vfio/Kconfig                      |    2 
 fs/overlayfs/namei.c                      |    1 
 fs/overlayfs/super.c                      |   12 -
 include/linux/bpf_verifier.h              |    5 
 include/linux/device.h                    |    1 
 include/linux/dma-mapping.h               |   16 +
 include/linux/swiotlb.h                   |    1 
 include/linux/user_namespace.h            |    3 
 include/uapi/linux/capability.h           |    3 
 kernel/bpf/verifier.c                     |   33 ++-
 kernel/dma/swiotlb.c                      |  259 ++++++++++++++++--------------
 kernel/events/core.c                      |   12 -
 kernel/user_namespace.c                   |   65 +++++++
 net/netfilter/nf_conntrack_standalone.c   |   10 -
 net/qrtr/mhi.c                            |    8 
 sound/usb/endpoint.c                      |    8 
 sound/usb/quirks-table.h                  |   10 +
 tools/cgroup/memcg_slabinfo.py            |    8 
 tools/perf/builtin-ftrace.c               |    2 
 tools/perf/util/data.c                    |    5 
 28 files changed, 359 insertions(+), 188 deletions(-)

Bjorn Andersson (1):
      net: qrtr: Avoid potential use after free in MHI send

Chris Chiu (1):
      USB: Add reset-resume quirk for WD19's Realtek Hub

Daniel Borkmann (2):
      bpf: Fix masking negation logic upon negative dst register
      bpf: Fix leakage of uninitialized bpf stack under speculation

Greg Kroah-Hartman (1):
      Linux 5.11.19

Imre Deak (1):
      drm/i915: Disable runtime power management during shutdown

Jason Gunthorpe (1):
      vfio: Depend on MMU

Jianxiong Gao (9):
      driver core: add a min_align_mask field to struct device_dma_parameters
      swiotlb: add a IO_TLB_SIZE define
      swiotlb: factor out an io_tlb_offset helper
      swiotlb: factor out a nr_slots helper
      swiotlb: clean up swiotlb_tbl_unmap_single
      swiotlb: refactor swiotlb_tbl_map_single
      swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
      swiotlb: respect min_align_mask
      nvme-pci: set min_align_mask

Jonathon Reinhart (1):
      netfilter: conntrack: Make global sysctls readonly in non-init netns

Kai-Heng Feng (1):
      USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Mickaël Salaün (1):
      ovl: fix leaked dentry

Miklos Szeredi (1):
      ovl: allow upperdir inside lowerdir

Nick Lowe (1):
      igb: Enable RSS for Intel I211 Ethernet Controller

Ondrej Mosnacek (1):
      perf/core: Fix unconditional security_locked_down() call

Phillip Potter (1):
      net: usb: ax88179_178a: initialize local variables before use

Romain Naour (1):
      mips: Do not include hi and lo in clobber list for R6

Serge E. Hallyn (1):
      capabilities: require CAP_SETFCAP to map uid 0

Takashi Iwai (2):
      ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX
      ALSA: usb-audio: Fix implicit sync clearance at stopping stream

Thomas Richter (1):
      perf ftrace: Fix access to pid in array when setting a pid filter

Vasily Averin (1):
      tools/cgroup/slabinfo.py: updated to work on current kernel

Zhen Lei (1):
      perf data: Fix error return code in perf_data__create_dir()

