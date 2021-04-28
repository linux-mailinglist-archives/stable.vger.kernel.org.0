Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C9136D7C0
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbhD1Myq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 08:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239640AbhD1Myp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 08:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6236561407;
        Wed, 28 Apr 2021 12:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619614440;
        bh=7nfeQ6FMGKj403XWTWjlp3iXNEqoO5RSDwAf6KwNjCg=;
        h=From:To:Cc:Subject:Date:From;
        b=Rg2lf4Chb9sOwrCN2vCp1oy0DP5zvH0SNRS0kAFFhBip6dlG7YZ2uouC+gdTnvvm9
         LS0eDz3t2XkPdBUuH8O254rRLuwJd72sCq60XgAIzdALiCQNel4uOUGhxIBX6wQ5CS
         eFLPid+TrsrxBeajlnNFhrR8yz9mB2m4T7mEyWMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.17
Date:   Wed, 28 Apr 2021 14:53:49 +0200
Message-Id: <1619614430116137@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.17 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/omap3.dtsi                            |    3 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts |    2 
 arch/arm64/kernel/probes/kprobes.c                      |    6 
 arch/csky/Kconfig                                       |    2 
 arch/csky/include/asm/page.h                            |    2 
 arch/ia64/mm/discontig.c                                |    6 
 arch/m68k/include/asm/page_mm.h                         |    2 
 arch/s390/kernel/entry.S                                |    1 
 arch/x86/events/intel/core.c                            |    2 
 arch/x86/events/intel/uncore_snbep.c                    |   61 -
 arch/x86/kernel/crash.c                                 |    2 
 block/ioctl.c                                           |    2 
 drivers/dma/tegra20-apb-dma.c                           |    4 
 drivers/dma/xilinx/xilinx_dpdma.c                       |   31 
 drivers/gpio/gpio-omap.c                                |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                  |   10 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                  |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |   11 
 drivers/hid/hid-alps.c                                  |    1 
 drivers/hid/hid-asus.c                                  |    3 
 drivers/hid/hid-cp2112.c                                |   22 
 drivers/hid/hid-google-hammer.c                         |    2 
 drivers/hid/hid-ids.h                                   |    2 
 drivers/hid/wacom_wac.c                                 |    2 
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h      |    2 
 drivers/net/geneve.c                                    |    6 
 drivers/net/usb/hso.c                                   |    2 
 drivers/net/xen-netback/xenbus.c                        |   12 
 drivers/pinctrl/core.c                                  |   14 
 drivers/pinctrl/intel/pinctrl-lewisburg.c               |    6 
 drivers/soc/qcom/qcom-geni-se.c                         |    3 
 drivers/usb/class/cdc-acm.c                             |    3 
 drivers/vdpa/mlx5/core/mr.c                             |    4 
 drivers/vhost/vdpa.c                                    |    6 
 fs/coda/file.c                                          |    6 
 fs/overlayfs/file.c                                     |   11 
 include/linux/bpf.h                                     |    5 
 include/linux/bpf_verifier.h                            |    3 
 include/linux/platform_data/gpio-omap.h                 |    3 
 kernel/bpf/verifier.c                                   |  771 ++++++++++++----
 kernel/locking/qrwlock.c                                |    7 
 security/keys/trusted-keys/trusted_tpm2.c               |    2 
 tools/arch/ia64/include/asm/barrier.h                   |    3 
 tools/perf/util/auxtrace.c                              |    2 
 tools/perf/util/map.c                                   |    7 
 46 files changed, 758 insertions(+), 312 deletions(-)

Ali Saidi (1):
      locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Andre Przywara (1):
      arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS

Andrei Matei (1):
      bpf: Allow variable-offset stack access

Andy Shevchenko (1):
      pinctrl: core: Show pin numbers for the controllers with base = 0

Angelo Dureghello (1):
      m68k: fix flatmem memory model setup

Christian König (2):
      ovl: fix reference counting in ovl_mmap error path
      coda: fix reference counting in coda_file_mmap error path

Christoph Hellwig (1):
      block: return -EBUSY when there are open partitions in blkdev_reread_part

Daniel Borkmann (2):
      bpf: Refactor and streamline bounds check into helper
      bpf: Tighten speculative pointer arithmetic mask

Dinghao Liu (1):
      dmaengine: tegra20: Fix runtime PM imbalance on error

Douglas Gilbert (1):
      HID cp2112: fix support for multiple gpiochips

Eli Cohen (1):
      vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails

Greg Kroah-Hartman (1):
      Linux 5.11.17

James Bottomley (1):
      KEYS: trusted: Fix TPM reservation for seal/unseal

Jia-Ju Bai (1):
      HID: alps: fix error return code in alps_input_configured()

Jiansong Chen (1):
      drm/amdgpu: fix GCR_GENERAL_CNTL offset for dimgrey_cavefish

Jiapeng Zhong (1):
      HID: wacom: Assign boolean values to a bool variable

Jim Mattson (1):
      perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]

Jisheng Zhang (1):
      arm64: kprobes: Restore local irqflag if kprobes is cancelled

Johan Hovold (1):
      net: hso: fix NULL-deref on disconnect regression

John Paul Adrian Glaubitz (1):
      ia64: tools: remove duplicate definition of ia64_mf() on ia64

Kan Liang (1):
      perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Laurent Pinchart (2):
      dmaengine: xilinx: dpdma: Fix descriptor issuing on video group
      dmaengine: xilinx: dpdma: Fix race condition in done IRQ

Leo Yan (1):
      perf auxtrace: Fix potential NULL pointer dereference

Luke D Jones (1):
      HID: asus: Add support for 2021 ASUS N-Key keyboard

Michael Brown (1):
      xen-netback: Check for hotplug-status existence before watching

Mike Galbraith (1):
      x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Oliver Neukum (1):
      USB: CDC-ACM: fix poison/unpoison imbalance

Philip Yang (1):
      drm/amdgpu: reserve fence slot to update page table

Phillip Potter (1):
      net: geneve: check skb is large enough for IPv4/IPv6 header

Randy Dunlap (2):
      csky: change a Kconfig symbol name to fix e1000 build error
      ia64: fix discontig.c section mismatches

Shawn Guo (1):
      soc: qcom: geni: shield geni_icc_get() for ACPI boot

Shou-Chieh Hsu (1):
      HID: google: add don USB id

Simon Ser (1):
      amd/display: allow non-linear multi-planar formats

Tony Lindgren (2):
      gpio: omap: Save and restore sysconfig
      ARM: dts: Fix swapped mmc order for omap3

Vasily Gorbik (1):
      s390/entry: save the caller of psw_idle

Wan Jiabing (1):
      cavium/liquidio: Fix duplicate argument

Xie Yongji (1):
      vhost-vdpa: protect concurrent access to vhost device iotlb

Yuanyuan Zhong (1):
      pinctrl: lewisburg: Update number of pins in community

Zhen Lei (1):
      perf map: Fix error return code in maps__clone()

