Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882FD6247F2
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 18:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKJRJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 12:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiKJRJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 12:09:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D12843865;
        Thu, 10 Nov 2022 09:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95A461C30;
        Thu, 10 Nov 2022 17:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD221C433C1;
        Thu, 10 Nov 2022 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668100166;
        bh=oLts5/x+WOhsKjbGWls4EP7V74G/56B1ljiTy/bBvVg=;
        h=From:To:Cc:Subject:Date:From;
        b=cr1bINHdYu+bDz0iZE+PVjBjvmQpepb3Hfvc4Lk6IxzzGXTcglamIomOhVo4Fmgmi
         Qe1u5ZC1BAF60ch26r3I1AdUNonDGBy1QLbzA4utBlOt6Jlhco9rDnQemFIdwvykdq
         eFBmwRWL69xPEPqxdH3dQWkcot3m5hzypi0jt2Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.299
Date:   Thu, 10 Nov 2022 18:09:19 +0100
Message-Id: <16681001598861@kroah.com>
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

I'm announcing the release of the 4.14.299 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/include/asm/memory.h                           |    6 
 arch/arm64/include/asm/memory.h                         |    6 
 arch/unicore32/include/asm/memory.h                     |    6 
 arch/x86/kvm/cpuid.c                                    |    1 
 arch/x86/kvm/emulate.c                                  |  102 +++++++++++-----
 block/bfq-iosched.c                                     |    4 
 drivers/ata/pata_legacy.c                               |    5 
 drivers/firmware/efi/efi.c                              |    2 
 drivers/i2c/busses/i2c-xiic.c                           |    1 
 drivers/isdn/hardware/mISDN/netjet.c                    |    2 
 drivers/isdn/mISDN/core.c                               |    5 
 drivers/media/dvb-frontends/drxk_hard.c                 |    2 
 drivers/media/platform/s5p-cec/s5p_cec.c                |    2 
 drivers/net/dsa/dsa_loop.c                              |   25 ++-
 drivers/net/ethernet/freescale/fec_main.c               |    4 
 drivers/net/phy/mdio_bus.c                              |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c |    4 
 drivers/nfc/nfcmrvl/i2c.c                               |    7 -
 drivers/nfc/s3fwrn5/core.c                              |    8 -
 drivers/parisc/iosapic.c                                |    1 
 drivers/tty/serial/8250/Kconfig                         |    2 
 fs/btrfs/backref.c                                      |   36 ++---
 fs/btrfs/export.c                                       |    2 
 fs/btrfs/export.h                                       |    2 
 fs/btrfs/tests/qgroup-tests.c                           |   20 ++-
 fs/ext4/migrate.c                                       |    3 
 fs/nfs/nfs4client.c                                     |    1 
 fs/nfs/nfs4state.c                                      |    2 
 include/linux/bits.h                                    |   17 +-
 include/linux/const.h                                   |    9 +
 include/linux/efi.h                                     |    2 
 include/net/protocol.h                                  |    4 
 include/net/tcp.h                                       |    2 
 include/net/udp.h                                       |    1 
 include/uapi/linux/const.h                              |    9 -
 net/bluetooth/l2cap_core.c                              |   52 ++++++--
 net/core/neighbour.c                                    |    2 
 net/ipv4/af_inet.c                                      |   14 --
 net/ipv4/ip_input.c                                     |   32 +++--
 net/ipv4/sysctl_net_ipv4.c                              |   59 ---------
 net/ipv6/ip6_input.c                                    |   23 ++-
 net/ipv6/tcp_ipv6.c                                     |    9 -
 net/ipv6/udp.c                                          |    9 -
 net/netfilter/ipvs/ip_vs_conn.c                         |    4 
 net/rose/rose_link.c                                    |    3 
 net/sched/sch_red.c                                     |    4 
 security/commoncap.c                                    |    6 
 sound/usb/quirks-table.h                                |   58 +++++++++
 sound/usb/quirks.c                                      |    1 
 50 files changed, 357 insertions(+), 228 deletions(-)

Ard Biesheuvel (1):
      efi: random: reduce seed size to 32 bytes

Chen Zhongjin (2):
      net: dsa: Fix possible memory leaks in dsa_loop_init()
      net, neigh: Fix null-ptr-deref in neigh_table_clear()

Dan Carpenter (1):
      net: sched: Fix use after free in red_enqueue()

David Sterba (1):
      btrfs: fix type of parameter generation in btrfs_get_dentry

Dokyung Song (1):
      wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Filipe Manana (2):
      btrfs: fix inode list leak during backref walking at resolve_indirect_refs()
      btrfs: fix ulist leaks in error paths of qgroup self tests

Gaosheng Cui (2):
      net: mdio: fix undefined behavior in bit shift for __mdiobus_register
      capabilities: fix potential memleak on error path from vfs_getxattr_alloc()

Greg Kroah-Hartman (1):
      Linux 4.14.299

Hans Verkuil (2):
      media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE
      media: dvb-frontends/drxk: initialize err to 0

Helge Deller (2):
      parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
      parisc: Export iosapic_serial_irq() symbol for serial port driver

Jason A. Donenfeld (1):
      ipvs: use explicitly signed chars

Jim Mattson (1):
      KVM: x86: Mask off reserved bits in CPUID.80000008H

John Veness (1):
      ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

Kuniyuki Iwashima (1):
      tcp/udp: Make early_demux back namespacified.

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Martin Tůma (1):
      i2c: xiic: Add platform module alias

Masahiro Yamada (3):
      linux/const.h: prefix include guard of uapi/linux/const.h with _UAPI
      linux/const.h: move UL() macro to include/linux/const.h
      linux/bits.h: make BIT(), GENMASK(), and friends available in assembly

Maxim Levitsky (3):
      KVM: x86: emulator: em_sysexit should update ctxt->mode
      KVM: x86: emulator: introduce emulator_recalc_and_set_mode
      KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Mikityanskiy (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Sergey Shtylyov (1):
      ata: pata_legacy: fix pdc20230_set_piomode()

Shang XiaoJing (2):
      nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
      nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Trond Myklebust (2):
      NFSv4.1: Handle RECLAIM_COMPLETE trunking errors
      NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot

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

Zhengchao Shao (1):
      Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

