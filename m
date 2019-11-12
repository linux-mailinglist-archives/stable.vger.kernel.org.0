Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369DAF98B4
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKLSeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:34:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfKLSeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:34:24 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F4C8214E0;
        Tue, 12 Nov 2019 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583662;
        bh=+vhIZ0c0ncblMMFXs8HX5L6XA77TCUAaj/ugCP6VukI=;
        h=Date:From:To:Cc:Subject:From;
        b=SoVt7/5emu+NBJp38Z5ykc+OKI1aomZElD4JK8HHv3QWKbHxcMyg4e5dKE3yUCtxB
         B8ljejoIvOJMR4fJkoadBCJRxJYgen/9CKOhb1+F/iTrCKenPmrt5c8lrwhOKS9Pby
         QBtWX6DTj83GCr8rCJItD9+HCM6TMlKk5shR2Lkw=
Date:   Tue, 12 Nov 2019 19:29:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.201
Message-ID: <20191112182956.GA1827802@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.201 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/x86/kernel/cpu/perf_event_amd_ibs.c         |    2 
 drivers/gpu/drm/i915/i915_cmd_parser.c           |  418 +++++++++++++++--------
 drivers/gpu/drm/i915/i915_dma.c                  |    4 
 drivers/gpu/drm/i915/i915_drv.c                  |    4 
 drivers/gpu/drm/i915/i915_drv.h                  |   31 +
 drivers/gpu/drm/i915/i915_gem_context.c          |    5 
 drivers/gpu/drm/i915/i915_gem_execbuffer.c       |  118 ++++--
 drivers/gpu/drm/i915/i915_gem_gtt.c              |   53 +-
 drivers/gpu/drm/i915/i915_gem_gtt.h              |    3 
 drivers/gpu/drm/i915/i915_reg.h                  |   11 
 drivers/gpu/drm/i915/intel_display.c             |    9 
 drivers/gpu/drm/i915/intel_drv.h                 |    3 
 drivers/gpu/drm/i915/intel_pm.c                  |  173 ++++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c          |   10 
 drivers/gpu/drm/i915/intel_ringbuffer.h          |    3 
 drivers/gpu/drm/radeon/si_dpm.c                  |    1 
 drivers/iio/imu/adis16480.c                      |    5 
 drivers/net/bonding/bond_main.c                  |    6 
 drivers/net/can/c_can/c_can.c                    |   25 +
 drivers/net/can/c_can/c_can.h                    |    1 
 drivers/net/can/flexcan.c                        |    1 
 drivers/net/can/usb/gs_usb.c                     |    1 
 drivers/net/can/usb/peak_usb/pcan_usb.c          |   17 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |    2 
 drivers/net/can/usb/usb_8dev.c                   |    3 
 drivers/net/ethernet/hisilicon/hip04_eth.c       |    1 
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    7 
 drivers/net/ethernet/intel/igb/igb_main.c        |    3 
 drivers/net/ethernet/qlogic/qede/qede_main.c     |   12 
 drivers/net/usb/cdc_ncm.c                        |    6 
 drivers/nfc/fdp/i2c.c                            |    2 
 drivers/nfc/st21nfca/core.c                      |    1 
 drivers/pci/host/pci-tegra.c                     |    7 
 drivers/scsi/lpfc/lpfc_nportdisc.c               |    4 
 drivers/scsi/qla2xxx/qla_bsg.c                   |    6 
 drivers/scsi/qla2xxx/qla_os.c                    |    4 
 drivers/usb/core/config.c                        |    5 
 drivers/usb/gadget/composite.c                   |    4 
 drivers/usb/gadget/configfs.c                    |  110 +++++-
 drivers/usb/gadget/udc/atmel_usba_udc.c          |    6 
 drivers/usb/gadget/udc/fsl_udc_core.c            |    2 
 drivers/usb/usbip/vhci_hcd.c                     |    1 
 fs/ceph/caps.c                                   |   10 
 fs/configfs/symlink.c                            |   33 +
 fs/fs-writeback.c                                |    9 
 fs/nfs/delegation.c                              |   10 
 fs/nfs/delegation.h                              |    1 
 fs/nfs/nfs4proc.c                                |    7 
 include/net/ip_vs.h                              |    1 
 include/net/neighbour.h                          |    4 
 include/net/netfilter/nf_tables.h                |    3 
 include/net/sock.h                               |    4 
 lib/dump_stack.c                                 |    7 
 mm/filemap.c                                     |    3 
 mm/vmstat.c                                      |    2 
 net/netfilter/ipset/ip_set_core.c                |    8 
 net/netfilter/ipvs/ip_vs_ctl.c                   |   15 
 net/nfc/netlink.c                                |    2 
 sound/firewire/bebob/bebob_focusrite.c           |    3 
 sound/pci/hda/patch_ca0132.c                     |    2 
 tools/perf/util/hist.c                           |    2 
 62 files changed, 928 insertions(+), 290 deletions(-)

Al Viro (1):
      configfs: fix a deadlock in configfs_symlink()

Alan Stern (1):
      USB: Skip endpoints with 0 maxpacket length

Alex Deucher (1):
      drm/radeon: fix si_enable_smc_cac() failed issue

Alexandru Ardelean (1):
      iio: imu: adis16480: make sure provided frequency is positive

Ben Hutchings (1):
      drm/i915/cmdparser: Fix jump whitelist clearing

Chandana Kishori Chiluveru (1):
      usb: gadget: composite: Fix possible double free memory bug

Chris Wilson (1):
      drm/i915/gtt: Disable read-only support under GVT

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Dan Carpenter (1):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Daniel Wagner (1):
      scsi: lpfc: Honor module parameter lpfc_use_adisc

Eric Dumazet (3):
      net: fix data-race in neigh_event_send()
      ipvs: move old_secure_tcp into struct netns_ipvs
      net: prevent load/store tearing on sk->sk_stamp

Greg Kroah-Hartman (1):
      Linux 4.4.201

Gustavo A. R. Silva (1):
      drivers: usb: usbip: Add missing break statement to switch

Hannes Reinecke (1):
      scsi: qla2xxx: fixup incorrect usage of host_byte

Imre Deak (1):
      drm/i915/gen8+: Add RC6 CTX corruption WA

Jiangfeng Xiao (1):
      net: hisilicon: Fix "Trying to free already-free IRQ"

Jiri Olsa (1):
      perf tools: Fix time sorting

Joakim Zhang (1):
      can: flexcan: disable completely the ECC mechanism

Johan Hovold (2):
      can: usb_8dev: fix use-after-free on disconnect
      can: peak_usb: fix slab info leak

Jon Bloomfield (11):
      drm/i915/gtt: Add read only pages to gen8_pte_encode
      drm/i915/gtt: Read-only pages for insert_entries on bdw+
      drm/i915: Rename gen7 cmdparser tables
      drm/i915: Disable Secure Batches for gen6+
      drm/i915: Remove Master tables from cmdparser
      drm/i915: Add support for mandatory cmdparsing
      drm/i915: Support ro ppgtt mapped cmdparser shadow buffers
      drm/i915: Allow parsing of unsized batches
      drm/i915: Add gen9 BCS cmdparsing
      drm/i915/cmdparser: Add support for backward jumps
      drm/i915/cmdparser: Ignore Length operands during command matching

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock

Kim Phillips (1):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity

Konstantin Khlebnikov (1):
      mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Luis Henriques (1):
      ceph: fix use-after-free in __ceph_remove_cap()

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Manfred Rudigier (1):
      igb: Fix constant media auto sense switching when no cable is connected

Manish Chopra (1):
      qede: fix NULL pointer deref in __qede_remove()

Michal Hocko (1):
      mm, vmstat: hide /proc/pagetypeinfo from normal users

Navid Emamdoost (1):
      can: gs_usb: gs_can_open(): prevent memory leak

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Nikhil Badola (1):
      usb: fsl: Check memory resource before releasing it

Oliver Neukum (1):
      CDC-NCM: handle incomplete transfer of MTU

Pan Bian (3):
      NFC: fdp: fix incorrect free object
      NFC: st21nfca: fix double free
      nfc: netlink: fix double device reference drop

Peter Chen (1):
      usb: gadget: configfs: fix concurrent issue between composite APIs

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Taehee Yoo (1):
      bonding: fix unexpected IFF_BONDING bit unset

Takashi Iwai (1):
      ALSA: hda/ca0132 - Fix possible workqueue stall

Takashi Sakamoto (1):
      ALSA: bebob: fix to detect configured source of sampling clock for Focusrite Saffire Pro i/o series

Tejun Heo (1):
      cgroup,writeback: don't switch wbs immediately on dead wbs if the memcg is dead

Trond Myklebust (1):
      NFSv4: Don't allow a cached open with a revoked delegation

Uma Shankar (1):
      drm/i915: Lower RM timeout to avoid DSI hard hangs

Vidya Sagar (1):
      PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Wenwen Wang (1):
      e1000: fix memory leaks

