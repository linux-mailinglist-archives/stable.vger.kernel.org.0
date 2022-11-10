Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4AA6247FA
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 18:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiKJRKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 12:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiKJRJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 12:09:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B24345A00;
        Thu, 10 Nov 2022 09:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0824661CEC;
        Thu, 10 Nov 2022 17:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A95C433D6;
        Thu, 10 Nov 2022 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668100182;
        bh=1xTuYnKxv1YX4mtJg6Ixn1B6MauUGcvfNWKWLldEIh0=;
        h=From:To:Cc:Subject:Date:From;
        b=yjPiXYDLSocPlNPbvwjlIRL6JhERhZ28hXb/Ai7nYS67dQ8+w2P2Kaok48PSMgMWG
         zoXaD7TBFCHEKOO8H/j48lmtTgbXSjieDUFI0+WRrGqhvZVmMqBGq9YqD57mliePlk
         1ccN5KNlXhzmyj15KGS46+XsKUzNQlJo7TsDboNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.224
Date:   Thu, 10 Nov 2022 18:09:30 +0100
Message-Id: <166810017114170@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.224 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/trace/histogram.rst                       |    2 
 Makefile                                                |    2 
 arch/parisc/include/asm/hardware.h                      |   12 -
 arch/parisc/kernel/drivers.c                            |   14 -
 arch/x86/events/intel/core.c                            |    1 
 arch/x86/events/intel/ds.c                              |    9 
 arch/x86/kvm/cpuid.c                                    |    4 
 arch/x86/kvm/emulate.c                                  |  102 +++++++---
 block/bfq-iosched.c                                     |    4 
 drivers/android/binder_alloc.c                          |    6 
 drivers/ata/pata_legacy.c                               |    5 
 drivers/firmware/efi/efi.c                              |    2 
 drivers/gpu/drm/i915/display/intel_sdvo.c               |   58 +++--
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c         |    6 
 drivers/hid/hid-ids.h                                   |    1 
 drivers/hid/hid-quirks.c                                |    1 
 drivers/hid/hid-saitek.c                                |    2 
 drivers/i2c/busses/i2c-xiic.c                           |    1 
 drivers/infiniband/core/cma.c                           |    2 
 drivers/infiniband/core/device.c                        |   10 
 drivers/infiniband/core/nldev.c                         |    2 
 drivers/infiniband/hw/hfi1/pio.c                        |    3 
 drivers/infiniband/hw/qedr/main.c                       |    9 
 drivers/isdn/hardware/mISDN/netjet.c                    |    2 
 drivers/isdn/mISDN/core.c                               |    5 
 drivers/media/dvb-frontends/drxk_hard.c                 |    2 
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c        |    2 
 drivers/media/platform/s5p-cec/s5p_cec.c                |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c              |    6 
 drivers/net/dsa/dsa_loop.c                              |   25 +-
 drivers/net/ethernet/freescale/fec_main.c               |    4 
 drivers/net/phy/mdio_bus.c                              |    2 
 drivers/net/tun.c                                       |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c |    4 
 drivers/nfc/nfcmrvl/i2c.c                               |    7 
 drivers/nfc/s3fwrn5/core.c                              |    8 
 drivers/parisc/iosapic.c                                |    1 
 drivers/scsi/scsi_sysfs.c                               |    8 
 drivers/staging/media/meson/vdec/vdec.c                 |    2 
 drivers/tty/serial/8250/Kconfig                         |    2 
 fs/btrfs/backref.c                                      |   54 +++--
 fs/btrfs/export.c                                       |    2 
 fs/btrfs/export.h                                       |    2 
 fs/btrfs/tests/qgroup-tests.c                           |   20 +
 fs/ext4/migrate.c                                       |    3 
 fs/ext4/namei.c                                         |   10 
 fs/fuse/file.c                                          |    4 
 fs/nfs/nfs4client.c                                     |    1 
 fs/nfs/nfs4state.c                                      |    2 
 fs/xfs/libxfs/xfs_attr_leaf.c                           |    8 
 fs/xfs/libxfs/xfs_defer.c                               |   10 
 fs/xfs/xfs_dquot.c                                      |   56 ++++-
 fs/xfs/xfs_inode.c                                      |    4 
 fs/xfs/xfs_iomap.c                                      |    2 
 fs/xfs/xfs_trans.c                                      |  163 +---------------
 fs/xfs/xfs_trans_dquot.c                                |    3 
 include/linux/efi.h                                     |    2 
 include/net/protocol.h                                  |    4 
 include/net/tcp.h                                       |    2 
 include/net/udp.h                                       |    1 
 ipc/msg.c                                               |    2 
 ipc/sem.c                                               |    6 
 ipc/shm.c                                               |    2 
 kernel/kprobes.c                                        |    5 
 net/bluetooth/l2cap_core.c                              |   52 ++++-
 net/core/neighbour.c                                    |    2 
 net/ipv4/af_inet.c                                      |   14 -
 net/ipv4/ip_input.c                                     |   37 ++-
 net/ipv4/sysctl_net_ipv4.c                              |   59 -----
 net/ipv6/ip6_input.c                                    |   26 +-
 net/ipv6/ipv6_sockglue.c                                |    7 
 net/ipv6/route.c                                        |   14 -
 net/ipv6/tcp_ipv6.c                                     |    9 
 net/ipv6/udp.c                                          |    9 
 net/netfilter/ipvs/ip_vs_app.c                          |   10 
 net/netfilter/ipvs/ip_vs_conn.c                         |   30 ++
 net/netfilter/nf_tables_api.c                           |    6 
 net/rose/rose_link.c                                    |    3 
 net/sched/sch_red.c                                     |    4 
 security/commoncap.c                                    |    6 
 sound/usb/quirks-table.h                                |   58 +++++
 sound/usb/quirks.c                                      |    1 
 tools/include/nolibc/nolibc.h                           |    4 
 83 files changed, 610 insertions(+), 452 deletions(-)

Ard Biesheuvel (1):
      efi: random: reduce seed size to 32 bytes

Brian Foster (1):
      xfs: don't fail verifier on empty attr3 leaf block

Brian Norris (1):
      drm/rockchip: dsi: Force synchronous probe

Carlos Llamas (1):
      binder: fix UAF of alloc->vma in race with munmap()

Chen Zhongjin (3):
      net: dsa: Fix possible memory leaks in dsa_loop_init()
      RDMA/core: Fix null-ptr-deref in ib_core_cleanup()
      net, neigh: Fix null-ptr-deref in neigh_table_clear()

Chuhong Yuan (1):
      xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()

Dan Carpenter (2):
      RDMA/qedr: clean up work queue on failure in qedr_alloc_resources()
      net: sched: Fix use after free in red_enqueue()

Darrick J. Wong (2):
      xfs: use ordered buffers to initialize dquot buffers during quotacheck
      xfs: don't fail unwritten extent conversion on writeback due to edquot

Dave Chinner (1):
      xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()

David Sterba (1):
      btrfs: fix type of parameter generation in btrfs_get_dentry

Dean Luick (1):
      IB/hfi1: Correctly move list in sc_disable()

Dokyung Song (1):
      wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Eric Sandeen (1):
      xfs: group quota should return EDQUOT when prj quota enabled

Filipe Manana (3):
      btrfs: fix inode list leak during backref walking at resolve_indirect_refs()
      btrfs: fix inode list leak during backref walking at find_parent_nodes()
      btrfs: fix ulist leaks in error paths of qgroup self tests

Gaosheng Cui (2):
      net: mdio: fix undefined behavior in bit shift for __mdiobus_register
      capabilities: fix potential memleak on error path from vfs_getxattr_alloc()

Greg Kroah-Hartman (1):
      Linux 5.4.224

Hangyu Hua (1):
      media: meson: vdec: fix possible refcount leak in vdec_probe()

Hans Verkuil (3):
      media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE
      media: cros-ec-cec: limit msg.len to CEC_MAX_MSG_SIZE
      media: dvb-frontends/drxk: initialize err to 0

Helge Deller (3):
      parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
      parisc: Export iosapic_serial_irq() symbol for serial port driver
      parisc: Avoid printing the hardware path twice

Håkon Bugge (1):
      RDMA/cma: Use output interface for net_dev check

Jason A. Donenfeld (1):
      ipvs: use explicitly signed chars

Jim Mattson (2):
      KVM: x86: Mask off reserved bits in CPUID.8000001AH
      KVM: x86: Mask off reserved bits in CPUID.80000008H

John Veness (1):
      ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

Kan Liang (2):
      perf/x86/intel: Fix pebs event constraints for ICL
      perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]

Kuniyuki Iwashima (2):
      tcp/udp: Fix memory leak in ipv6_renew_options().
      tcp/udp: Make early_demux back namespacified.

Li Qiang (1):
      kprobe: reverse kp->flags when arm_kprobe failed

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Luís Henriques (1):
      ext4: fix BUG_ON() when directory entry has invalid rec_len

Martin Tůma (1):
      i2c: xiic: Add platform module alias

Maxim Levitsky (3):
      KVM: x86: emulator: em_sysexit should update ctxt->mode
      KVM: x86: emulator: introduce emulator_recalc_and_set_mode
      KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Mikityanskiy (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Miklos Szeredi (1):
      fuse: add file_modified() to fallocate

Pablo Neira Ayuso (1):
      netfilter: nf_tables: release flow rule object from commit path

Rasmus Villemoes (1):
      tools/nolibc/string: Fix memcmp() implementation

Samuel Bailey (1):
      HID: saitek: add madcatz variant of MMO7 mouse device ID

Sascha Hauer (1):
      mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times

Sergey Shtylyov (1):
      ata: pata_legacy: fix pdc20230_set_piomode()

Shang XiaoJing (2):
      nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
      nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Trond Myklebust (2):
      NFSv4.1: Handle RECLAIM_COMPLETE trunking errors
      NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot

Uday Shankar (1):
      scsi: core: Restrict legal sdev_state transitions via sysfs

Vasily Averin (2):
      memcg: enable accounting of ipc resources
      ipc: remove memcg accounting for sops objects in do_semtimedop()

Ville Syrjälä (2):
      drm/i915/sdvo: Filter out invalid outputs more sensibly
      drm/i915/sdvo: Setup DDC fully before output init

Yang Yingliang (2):
      mISDN: fix possible memory leak in mISDN_register_device()
      isdn: mISDN: netjet: fix wrong check of device registration

Ye Bin (1):
      ext4: fix warning in 'ext4_da_release_space'

Yu Kuai (1):
      block, bfq: protect 'bfqd->queued' by 'bfqd->lock'

Zhang Changzhong (1):
      net: fec: fix improper use of NETDEV_TX_BUSY

Zhang Qilong (1):
      rose: Fix NULL pointer dereference in rose_send_frame()

Zhang Xiaoxu (1):
      nfs4: Fix kmemleak when allocate slot failed

Zheng Yejian (1):
      tracing/histogram: Update document for KEYS_MAX size

Zhengchao Shao (4):
      ipvs: fix WARNING in __ip_vs_cleanup_batch()
      ipvs: fix WARNING in ip_vs_app_net_cleanup()
      Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()
      ipv6: fix WARNING in ip6_route_net_exit_late()

Ziyang Xuan (1):
      net: tun: fix bugs for oversize packet when napi frags enabled

