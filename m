Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC463FFC94
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348612AbhICJCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348621AbhICJCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B0EF60E9B;
        Fri,  3 Sep 2021 09:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659700;
        bh=AuOCB3NCRgVVItmcZrvdGGmk7E68Ny+FfyZsU9N7yO8=;
        h=From:To:Cc:Subject:Date:From;
        b=NmHrY+KbS4w+B9mWYA5gtKQo4j+lZmQILkPhRhYJ4+wYOOXzoXN1WoBc4AC98Eozs
         MF0eyXBowauV/jLCOMETYtgvAZfj2KWqRk+szeVlblaSvGIv8UNsq57A9AQXp+70hr
         MfiCGf06DpxJZde2o3PvprSFshO295vc9KlYvvVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.144
Date:   Fri,  3 Sep 2021 11:01:29 +0200
Message-Id: <163065969091227@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.144 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arc/kernel/vmlinux.lds.S                           |    2 
 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts     |    4 
 arch/parisc/include/asm/string.h                        |   15 -
 arch/parisc/kernel/parisc_ksyms.c                       |    4 
 arch/parisc/lib/Makefile                                |    4 
 arch/parisc/lib/memset.c                                |   72 ++++++++
 arch/parisc/lib/string.S                                |  136 ----------------
 arch/x86/events/intel/uncore_snbep.c                    |    2 
 arch/x86/kvm/mmu.c                                      |   10 +
 drivers/block/floppy.c                                  |   27 +--
 drivers/gpu/drm/drm_ioc32.c                             |    4 
 drivers/gpu/drm/i915/gt/intel_timeline.c                |    8 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c           |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h           |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c         |    9 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                |    1 
 drivers/infiniband/hw/efa/efa_main.c                    |    1 
 drivers/infiniband/hw/hfi1/sdma.c                       |    9 -
 drivers/mmc/host/sdhci-msm.c                            |   18 ++
 drivers/net/can/usb/esd_usb2.c                          |    4 
 drivers/net/dsa/mt7530.c                                |    5 
 drivers/net/ethernet/apm/xgene-v2/main.c                |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  |   13 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   32 +++
 drivers/net/ethernet/intel/e1000e/ich8lan.c             |   14 +
 drivers/net/ethernet/intel/e1000e/ich8lan.h             |    3 
 drivers/net/ethernet/marvell/mvneta.c                   |    2 
 drivers/net/ethernet/qlogic/qed/qed_ll2.c               |   20 ++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c              |    3 
 drivers/opp/of.c                                        |    5 
 drivers/scsi/scsi_sysfs.c                               |    9 -
 drivers/tty/vt/vt_ioctl.c                               |   11 -
 drivers/usb/dwc3/gadget.c                               |   23 +-
 drivers/usb/gadget/function/u_audio.c                   |    5 
 drivers/usb/serial/ch341.c                              |    1 
 drivers/usb/serial/option.c                             |    2 
 drivers/vhost/vringh.c                                  |    2 
 drivers/virtio/virtio_pci_common.c                      |    7 
 drivers/virtio/virtio_ring.c                            |    6 
 fs/btrfs/btrfs_inode.h                                  |   15 +
 fs/btrfs/file.c                                         |   10 -
 fs/btrfs/inode.c                                        |    4 
 fs/btrfs/transaction.h                                  |    2 
 fs/btrfs/volumes.c                                      |    2 
 fs/overlayfs/export.c                                   |    2 
 fs/proc/base.c                                          |   11 +
 include/linux/netdevice.h                               |    4 
 include/linux/once.h                                    |    4 
 include/linux/oom.h                                     |    4 
 kernel/audit_tree.c                                     |    2 
 kernel/bpf/verifier.c                                   |   57 ++++++
 lib/once.c                                              |   11 -
 mm/oom_kill.c                                           |   22 +-
 net/core/rtnetlink.c                                    |    3 
 net/ipv4/ip_gre.c                                       |    2 
 net/netfilter/nf_conntrack_core.c                       |   71 ++------
 net/qrtr/qrtr.c                                         |    2 
 net/rds/ib_frmr.c                                       |    4 
 net/socket.c                                            |    6 
 61 files changed, 418 insertions(+), 325 deletions(-)

Andrey Ignatov (1):
      rtnetlink: Return correct error on changing device netns

Andrii Nakryiko (2):
      bpf: Track contents of read-only maps as scalars
      bpf: Fix cast to pointer from integer of different size warning

Ben Skeggs (1):
      drm/nouveau/disp: power down unused DP links during init

Christophe JAILLET (1):
      xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

Colin Ian King (1):
      perf/x86/intel/uncore: Fix integer overflow on 23 bit left shift of a u32

DENG Qingfang (1):
      net: dsa: mt7530: fix VLAN traffic leaks again

Denis Efremov (1):
      Revert "floppy: reintroduce O_NDELAY fix"

Filipe Manana (1):
      btrfs: fix race between marking inode needs to be logged and log syncing

Florian Westphal (1):
      netfilter: conntrack: collect all entries in one cycle

Gal Pressman (1):
      RDMA/efa: Free IRQ vectors on error flow

Gerd Rausch (1):
      net/rds: dma_map_sg is entitled to merge entries

Greg Kroah-Hartman (1):
      Linux 5.4.144

Guangbin Huang (1):
      net: hns3: fix get wrong pfc_en when query PFC configuration

Guenter Roeck (1):
      ARC: Fix CONFIG_STACKDEPOT

Guojia Liao (1):
      net: hns3: fix duplicate node in VLAN list

Helge Deller (1):
      Revert "parisc: Add assembly implementations for memset, strlen, strcpy, strncpy and strcat"

Jerome Brunet (1):
      usb: gadget: u_audio: fix race condition on endpoint stop

Johan Hovold (1):
      Revert "USB: serial: ch341: fix character loss at high transfer rates"

Kefeng Wang (1):
      once: Fix panic when module unload

Li Jinlin (1):
      scsi: core: Fix hang of freezing queue between blocking and running device

Linus Torvalds (1):
      vt_kdsetmode: extend console locking

Mark Yacoub (1):
      drm: Copy drm_wait_vblank to user before returning

Matthew Brost (1):
      drm/i915: Fix syncmap memory leak

Maxim Kiselev (1):
      net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Michał Mirosław (1):
      opp: remove WARN when no valid OPPs remain

Miklos Szeredi (1):
      ovl: fix uninitialized pointer read in ovl_lookup_real_one()

Naresh Kumar PBS (1):
      RDMA/bnxt_re: Add missing spin lock initialization

Neeraj Upadhyay (1):
      vringh: Use wiov->used to check for read/write desc order

Parav Pandit (2):
      virtio: Improve vq->broken access to avoid any compiler optimization
      virtio_pci: Support surprise removal of virtio pci device

Peter Collingbourne (1):
      net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Petr Vorel (1):
      arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88

Qu Wenruo (1):
      btrfs: fix NULL pointer dereference when deleting device by invalid id

Richard Guy Briggs (1):
      audit: move put_tree() to avoid trim_trees refcount underflow and UAF

Sasha Neftin (1):
      e1000e: Fix the max snoop/no-snoop latency for 10M

Sean Christopherson (1):
      KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs

Shai Malin (2):
      qed: qed ll2 race condition fixes
      qed: Fix null-pointer dereference in qed_rdma_create_qp()

Shaik Sajida Bhanu (1):
      mmc: sdhci-msm: Update the software timeout value for sdhc

Shreyansh Chouhan (1):
      ip_gre: add validation for csum_start

Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Tuo Li (1):
      IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Wesley Cheng (1):
      usb: dwc3: gadget: Stop EP0 transfers during pullup disable

Xiaolong Huang (1):
      net: qrtr: fix another OOB Read in qrtr_endpoint_post

Yafang Shao (1):
      mm, oom: make the calculation of oom badness more accurate

Yufeng Mo (1):
      net: hns3: clear hardware resource when loading driver

Zhengjun Zhang (1):
      USB: serial: option: add new VID/PID to support Fibocom FG150

