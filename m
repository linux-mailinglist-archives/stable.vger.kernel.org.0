Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A1A5ACFC3
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbiIEKNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbiIEKMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:12:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB12853D3F;
        Mon,  5 Sep 2022 03:12:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B016B611E2;
        Mon,  5 Sep 2022 10:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD91C433C1;
        Mon,  5 Sep 2022 10:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372758;
        bh=hIBtNQ6FQL4u1KyqSFdUbf7Qhq0TDHaXhB0zCcWPXAY=;
        h=From:To:Cc:Subject:Date:From;
        b=vrWmU/DRqEefDZIfE+G4/+bsBcyffabgBchUZPGCWRHA7hyhBm8T4e039wSjZLUI1
         hPCCiqPIBev3HXtibttSyrHfbyUT9q4wW2et/I1NSBdRmRZe47KJDL0AiN4paGkWgL
         os2wvcn5+aMG84LC8plCDfXlTdqxGNk9VE4A0u9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.141
Date:   Mon,  5 Sep 2022 12:12:20 +0200
Message-Id: <1662372740199248@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.141 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/s390/hypfs/hypfs_diag.c                            |    2 
 arch/s390/hypfs/inode.c                                 |    2 
 arch/s390/mm/fault.c                                    |    4 
 arch/x86/include/asm/nospec-branch.h                    |   92 ++++++++--------
 drivers/android/binder.c                                |    1 
 drivers/dma-buf/udmabuf.c                               |   18 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                     |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                  |    3 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                   |    3 
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c   |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c        |    6 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c       |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c        |    6 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c       |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    1 
 drivers/hid/hid-steam.c                                 |   10 +
 drivers/hid/hidraw.c                                    |    3 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                 |    1 
 drivers/mmc/host/mtk-sd.c                               |    6 +
 drivers/pci/pcie/portdrv_core.c                         |    9 +
 drivers/video/fbdev/pm2fb.c                             |    5 
 fs/io_uring.c                                           |    5 
 fs/signalfd.c                                           |    1 
 fs/xfs/xfs_filestream.c                                 |    7 -
 fs/xfs/xfs_fsops.c                                      |   52 +++------
 fs/xfs/xfs_mount.h                                      |    8 +
 fs/xfs/xfs_trans_dquot.c                                |    1 
 include/linux/fs.h                                      |    1 
 include/linux/rmap.h                                    |    7 -
 include/linux/skbuff.h                                  |    8 +
 include/linux/skmsg.h                                   |    3 
 include/net/sock.h                                      |   68 ++++++++---
 kernel/kprobes.c                                        |    9 -
 kernel/trace/ftrace.c                                   |   10 +
 lib/crypto/Kconfig                                      |    1 
 lib/vdso/gettimeofday.c                                 |   16 +-
 mm/mmap.c                                               |   12 ++
 mm/rmap.c                                               |   29 ++---
 net/bluetooth/l2cap_core.c                              |   10 -
 net/bpf/test_run.c                                      |    3 
 net/core/dev.c                                          |    1 
 net/core/neighbour.c                                    |   27 +++-
 net/core/skmsg.c                                        |    4 
 net/netfilter/Kconfig                                   |    1 
 net/packet/af_packet.c                                  |    4 
 scripts/Makefile.modpost                                |    3 
 47 files changed, 324 insertions(+), 152 deletions(-)

Alvin Lee (1):
      drm/amd/display: For stereo keep "FLIP_ANY_FRAME"

Brian Foster (1):
      xfs: fix soft lockup via spinning in filestream ag selection loop

Christophe Leroy (1):
      lib/vdso: Mark do_hres_timens() and do_coarse_timens() __always_inline()

Darrick J. Wong (3):
      xfs: remove infinite loop when reserving free block pool
      xfs: always succeed at setting the reserve pool size
      xfs: fix overfilling of reserve pool

Denis V. Lunev (1):
      neigh: fix possible DoS due to net iface start/stop loop

Dongliang Mu (1):
      media: pvrusb2: fix memory leak in pvr_probe

Dusica Milinkovic (1):
      drm/amdgpu: Increase tlb flush timeout for sriov

Eric Biggers (1):
      crypto: lib - remove unneeded selection of XOR_BLOCKS

Eric Sandeen (1):
      xfs: revert "xfs: actually bump warning counts when we send warnings"

Evan Quan (1):
      drm/amd/pm: add missing ->fini_microcode interface for Sienna Cichlid

Fudong Wang (1):
      drm/amd/display: clear optc underflow before turn off odm clock

Geert Uytterhoeven (1):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Gerald Schaefer (1):
      s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Greg Kroah-Hartman (2):
      Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"
      Linux 5.10.141

Hawkins Jiawei (1):
      net: fix refcount bug in sk_psock_get (2)

Ilya Bakoulin (1):
      drm/amd/display: Fix pixel clock programming

Jann Horn (2):
      mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()
      mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Jing Leng (1):
      kbuild: Fix include path in scripts/Makefile.modpost

Josip Pavic (1):
      drm/amd/display: Avoid MPC infinite loop

Juergen Gross (1):
      s390/hypfs: avoid error message under KVM

Karthik Alapati (1):
      HID: hidraw: fix memory leak in hidraw_release()

Kuniyuki Iwashima (1):
      kprobes: don't call disarm_kprobe() for disabled kprobes

Lee Jones (1):
      HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Letu Ren (1):
      fbdev: fb_pm2fb: Avoid potential divide by zero error

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix build errors in some archs

Pavel Begunkov (1):
      io_uring: disable polling pollfree files

Peter Zijlstra (2):
      x86/nospec: Unwreck the RSB stuffing
      x86/nospec: Fix i386 RSB stuffing

Vivek Kasireddy (1):
      udmabuf: Set the DMA mask for the udmabuf device (v2)

Wenbin Mei (1):
      mmc: mtk-sd: Clear interrupts when cqe off/disable

Yang Jihong (1):
      ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Yang Yingliang (1):
      net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao (2):
      bpf: Don't redirect packets with invalid pkt_len
      net/af_packet: check len when min_header_len equals to 0

