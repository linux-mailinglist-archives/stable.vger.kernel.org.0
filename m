Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954A523C97B
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgHEJrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgHEJqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:46:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4E2322B40;
        Wed,  5 Aug 2020 09:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620759;
        bh=fZbr2xfPMcdkv2V5Z4xB+ygx4eaTMvIV9OtjYUtDitA=;
        h=From:To:Cc:Subject:Date:From;
        b=P7tVDNlrlmLlrylIOSosMj33z4grU1EPmviAneoh23vO1CgPWZPhQpI5k867ECbmP
         5RHizrsNSa6koW5NVQ4+IJCqJF9n7f2XhbvR7Nj8ijQkHSeF6iZv/Z02sk3NuTI1OD
         +PmjjnP6/pQ/wyB8q8Eqi/89VxBFlLPiTwagPtvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.137
Date:   Wed,  5 Aug 2020 11:46:04 +0200
Message-Id: <1596620764104213@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.137 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
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
 arch/x86/kvm/lapic.c                                          |    2 
 drivers/crypto/ccp/ccp-ops.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c                       |   34 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                       |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                        |    9 -
 drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c         |    1 
 drivers/gpu/drm/drm_gem.c                                     |   10 -
 drivers/i2c/busses/i2c-cadence.c                              |    9 -
 drivers/iio/imu/adis16400_buffer.c                            |    5 
 drivers/media/pci/cx23885/cx23888-ir.c                        |    5 
 drivers/net/ethernet/chelsio/cxgb4/sge.c                      |    1 
 drivers/net/ethernet/cortina/gemini.c                         |    5 
 drivers/net/ethernet/ibm/ibmvnic.c                            |    2 
 drivers/net/ethernet/mellanox/mlx4/main.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c             |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c           |   23 +++
 drivers/net/ethernet/mellanox/mlxsw/core.c                    |    8 -
 drivers/net/ethernet/qlogic/qed/qed_int.c                     |    3 
 drivers/net/ethernet/renesas/ravb_main.c                      |   26 +++-
 drivers/net/usb/hso.c                                         |    5 
 drivers/net/usb/lan78xx.c                                     |    6 
 drivers/net/wireless/ath/ath9k/htc_hst.c                      |    3 
 drivers/net/wireless/ath/ath9k/wmi.c                          |    1 
 drivers/net/xen-netfront.c                                    |   64 ++++++----
 drivers/nfc/s3fwrn5/core.c                                    |    1 
 drivers/pci/quirks.c                                          |   13 ++
 fs/btrfs/inode.c                                              |   41 +++++-
 fs/btrfs/tests/btrfs-tests.c                                  |    8 +
 fs/btrfs/tests/inode-tests.c                                  |    1 
 fs/xfs/xfs_log.c                                              |    9 -
 include/net/xfrm.h                                            |    4 
 include/uapi/linux/wireless.h                                 |    5 
 kernel/bpf/hashtab.c                                          |   12 +
 kernel/trace/trace_events_filter.c                            |    6 
 net/9p/trans_fd.c                                             |   15 ++
 net/bluetooth/hci_event.c                                     |   26 ++--
 net/mac80211/cfg.c                                            |    1 
 net/mac80211/mesh_pathtbl.c                                   |    1 
 net/rds/recv.c                                                |    3 
 net/sctp/socket.c                                             |   10 +
 net/x25/x25_subr.c                                            |    6 
 tools/testing/selftests/net/psock_fanout.c                    |    3 
 tools/testing/selftests/networking/timestamping/rxtimestamp.c |    3 
 56 files changed, 353 insertions(+), 121 deletions(-)

Alain Michaud (1):
      Bluetooth: fix kernel oops in store_pending_adv_report

Alex Deucher (1):
      Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"

Andrea Righi (1):
      xen-netfront: fix potential deadlock in xennet_remove()

Andrii Nakryiko (1):
      bpf: Fix map leak in HASH_OF_MAPS map

Eran Ben Elisha (1):
      net/mlx5: Verify Hardware supports requested ptp function on a given pin

Filipe Manana (1):
      Btrfs: fix selftests failure due to uninitialized i_mode in test inodes

Geert Uytterhoeven (1):
      usb: hso: Fix debug compile warning on sparc32

Greg Kroah-Hartman (1):
      Linux 4.19.137

Ido Schimmel (2):
      mlxsw: core: Increase scope of RCU read-side critical section
      mlxsw: core: Free EMAD transactions using kfree_rcu()

Jakub Kicinski (1):
      mlx4: disable device on shutdown

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

Navid Emamdoost (9):
      crypto: ccp - Release all allocated memory if sha type is invalid
      media: rc: prevent memory leak in cx23888_ir_probe
      drm/amdgpu: fix multiple memory leaks in acp_hw_init
      tracing: Have error path in predicate_parse() free its allocated memory
      ath9k_htc: release allocated buffer if timed out
      ath9k: release allocated buffer if timed out
      drm/amd/display: prevent memory leak
      nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
      cxgb4: add missing release on skb in uld_send()

Peilin Ye (2):
      drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()
      rds: Prevent kernel-infoleak in rds_notify_queue_get()

Pi-Hsun Shih (1):
      wireless: Use offsetof instead of custom macro.

Qu Wenruo (1):
      btrfs: inode: Verify inode mode to avoid NULL pointer dereference

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

Sami Tolvanen (1):
      arm64/alternatives: move length validation inside the subsection

Sasha Levin (1):
      iio: imu: adis16400: fix memory leak

Steffen Klassert (1):
      xfrm: Fix crash when the hold queue is used.

Steve Cohen (1):
      drm: hold gem reference until object is no longer accessed

Tanner Love (2):
      selftests/net: rxtimestamp: fix clang issues for target arch PowerPC
      selftests/net: psock_fanout: fix clang issues for target arch PowerPC

Thomas Falcon (1):
      ibmvnic: Fix IRQ mapping disposal in error path

Thomas Gleixner (1):
      x86/i8259: Use printk_deferred() to prevent deadlock

Wang Hai (2):
      9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work
      net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()

Wanpeng Li (1):
      KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled

Will Deacon (1):
      ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Xin Long (1):
      sctp: implement memory accounting on tx path

Xin Xiong (1):
      net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq

Xiyu Yang (1):
      net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Yoshihiro Shimoda (1):
      net: ethernet: ravb: exit if re-initialization fails in tx timeout

YueHaibing (1):
      net/x25: Fix null-ptr-deref in x25_disconnect

