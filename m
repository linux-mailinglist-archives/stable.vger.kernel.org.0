Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EFD23C976
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHEJqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgHEJpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:45:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FBB2206B6;
        Wed,  5 Aug 2020 09:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620739;
        bh=5ty3xhBsiVWRK8fnohCpiXYdrOIgvzG5fBAaTE8TGIM=;
        h=From:To:Cc:Subject:Date:From;
        b=iULkHLC9ah6+5Y3NhGEMXRudO6a8ckzZPwUEqxT4FYsBGBaQR9ITQkiZ4Y7qZvJxw
         VbXOu6Vkk3AfZ0YgA+auL+o6whFkZjlrT0eB4I6hpbZOj28xY2K+BdoFiZ5CR9Ne1v
         2wmR7ZQJltmTeJ/fES8YPqs25AWLx09lM2t3ANwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.192
Date:   Wed,  5 Aug 2020 11:45:55 +0200
Message-Id: <15966207552249@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.192 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm/kernel/hw_breakpoint.c                               |   27 +++-
 arch/arm64/include/asm/alternative.h                          |    4 
 arch/arm64/include/asm/checksum.h                             |    5 
 arch/parisc/include/asm/cmpxchg.h                             |    2 
 arch/parisc/lib/bitops.c                                      |   12 +
 arch/sh/kernel/entry-common.S                                 |    6 
 arch/x86/kernel/i8259.c                                       |    2 
 arch/x86/kernel/unwind_orc.c                                  |    8 -
 arch/x86/kernel/vmlinux.lds.S                                 |    3 
 arch/x86/kvm/lapic.c                                          |    2 
 arch/x86/kvm/x86.c                                            |    3 
 drivers/crypto/ccp/ccp-ops.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                       |    3 
 drivers/gpu/drm/drm_gem.c                                     |   10 -
 drivers/i2c/busses/i2c-cadence.c                              |    9 -
 drivers/iio/imu/adis16400_buffer.c                            |    5 
 drivers/media/pci/cx23885/cx23888-ir.c                        |    5 
 drivers/net/ethernet/chelsio/cxgb4/sge.c                      |    1 
 drivers/net/ethernet/ibm/ibmvnic.c                            |    2 
 drivers/net/ethernet/mellanox/mlx4/main.c                     |    2 
 drivers/net/ethernet/mellanox/mlxsw/core.c                    |    8 -
 drivers/net/ethernet/qlogic/qed/qed_int.c                     |    3 
 drivers/net/ethernet/renesas/ravb_main.c                      |   26 +++-
 drivers/net/phy/mdio-bcm-unimac.c                             |    2 
 drivers/net/usb/hso.c                                         |    5 
 drivers/net/usb/lan78xx.c                                     |    6 
 drivers/net/wireless/ath/ath9k/htc_hst.c                      |    3 
 drivers/net/wireless/ath/ath9k/wmi.c                          |    1 
 drivers/net/xen-netfront.c                                    |   64 ++++++----
 drivers/nfc/s3fwrn5/core.c                                    |    1 
 drivers/pci/quirks.c                                          |   13 ++
 drivers/scsi/libsas/sas_ata.c                                 |    1 
 drivers/scsi/libsas/sas_discover.c                            |   32 ++---
 drivers/scsi/libsas/sas_expander.c                            |    8 -
 drivers/scsi/libsas/sas_internal.h                            |    1 
 drivers/scsi/libsas/sas_port.c                                |    3 
 fs/f2fs/dir.c                                                 |   12 +
 fs/xfs/xfs_log.c                                              |    9 -
 include/asm-generic/vmlinux.lds.h                             |    5 
 include/scsi/libsas.h                                         |    3 
 include/scsi/scsi_transport_sas.h                             |    1 
 include/uapi/linux/wireless.h                                 |    5 
 kernel/bpf/hashtab.c                                          |   12 +
 net/9p/trans_fd.c                                             |   32 +++--
 net/mac80211/cfg.c                                            |    1 
 net/mac80211/mesh_pathtbl.c                                   |    1 
 net/rds/recv.c                                                |    3 
 net/x25/x25_subr.c                                            |    6 
 tools/testing/selftests/networking/timestamping/rxtimestamp.c |    3 
 50 files changed, 276 insertions(+), 110 deletions(-)

Andrea Righi (1):
      xen-netfront: fix potential deadlock in xennet_remove()

Andrii Nakryiko (1):
      bpf: Fix map leak in HASH_OF_MAPS map

Dominique Martinet (1):
      9p/trans_fd: abort p9_read_work if req status changed

Geert Uytterhoeven (1):
      usb: hso: Fix debug compile warning on sparc32

Greg Kroah-Hartman (1):
      Linux 4.14.192

Ido Schimmel (2):
      mlxsw: core: Increase scope of RCU read-side critical section
      mlxsw: core: Free EMAD transactions using kfree_rcu()

Jaegeuk Kim (1):
      f2fs: check memory boundary by insane namelen

Jakub Kicinski (1):
      mlx4: disable device on shutdown

Jason Yan (1):
      scsi: libsas: direct call probe and destruct

Joerg Roedel (1):
      x86, vmlinux.lds: Page-align end of ..page_aligned sections

Johan Hovold (2):
      net: lan78xx: add missing endpoint sanity check
      net: lan78xx: fix transfer-buffer memory leak

Josh Poimboeuf (1):
      x86/unwind/orc: Fix ORC for newly forked tasks

Laurence Oberman (1):
      qed: Disable "MFW indication via attention" SPAM every 5 minutes

Liam Beguin (1):
      parisc: add support for cmpxchg on u8 pointers

Michael Karcher (1):
      sh: Fix validation of system call number

Navid Emamdoost (6):
      crypto: ccp - Release all allocated memory if sha type is invalid
      media: rc: prevent memory leak in cx23888_ir_probe
      ath9k_htc: release allocated buffer if timed out
      ath9k: release allocated buffer if timed out
      nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
      cxgb4: add missing release on skb in uld_send()

Peilin Ye (2):
      drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()
      rds: Prevent kernel-infoleak in rds_notify_queue_get()

Pi-Hsun Shih (1):
      wireless: Use offsetof instead of custom macro.

Raviteja Narayanam (1):
      Revert "i2c: cadence: Fix the hold bit setting"

Remi Pommarel (2):
      mac80211: mesh: Free ie data when leaving mesh
      mac80211: mesh: Free pending skb when destroying a mpath

Rik van Riel (1):
      xfs: fix missed wakeup on l_flush_wait

Robert Hancock (1):
      PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

Robin Murphy (1):
      arm64: csum: Fix handling of bad packets

Sami Tolvanen (2):
      x86/build/lto: Fix truncated .bss with -fdata-sections
      arm64/alternatives: move length validation inside the subsection

Sasha Levin (2):
      iio: imu: adis16400: fix memory leak
      x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit

Sheng Yong (1):
      f2fs: check if file namelen exceeds max value

Steve Cohen (1):
      drm: hold gem reference until object is no longer accessed

Tanner Love (1):
      selftests/net: rxtimestamp: fix clang issues for target arch PowerPC

Thomas Falcon (1):
      ibmvnic: Fix IRQ mapping disposal in error path

Thomas Gleixner (1):
      x86/i8259: Use printk_deferred() to prevent deadlock

Wang Hai (1):
      9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work

Wanpeng Li (1):
      KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled

Wei Yongjun (1):
      net: phy: mdio-bcm-unimac: fix potential NULL dereference in unimac_mdio_probe()

Will Deacon (1):
      ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Xiyu Yang (1):
      net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Yoshihiro Shimoda (1):
      net: ethernet: ravb: exit if re-initialization fails in tx timeout

YueHaibing (1):
      net/x25: Fix null-ptr-deref in x25_disconnect

