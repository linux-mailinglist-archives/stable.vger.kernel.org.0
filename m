Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54A95AB0A7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbiIBMzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238305AbiIBMyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:54:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E338860C3;
        Fri,  2 Sep 2022 05:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90AC56217F;
        Fri,  2 Sep 2022 12:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B7C433D7;
        Fri,  2 Sep 2022 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122330;
        bh=pn2LAye3ZY5+c6PtSoqfqpDYlDmfad9MXAsXq3C3Gu0=;
        h=From:To:Cc:Subject:Date:From;
        b=w1CXBL8BtTnSm9Xyd8EQ3JYjw1e9aknC9jG5812INGN2QbR7E95LfXzw0cIdoOOSo
         HOBtNQkC1HE4BAOcqMfc4ud48/gpsdFGhrkp2gyP6bwnJXv8xlyHzmUKNSNXAi50nq
         xWgp3SjXQtVE2kRu7o6lva8FbrYbvLiHLJMhdYjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/37] 5.10.141-rc1 review
Date:   Fri,  2 Sep 2022 14:19:22 +0200
Message-Id: <20220902121359.177846782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.141-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.141-rc1
X-KernelTest-Deadline: 2022-09-04T12:14+00:00
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

This is the start of the stable review cycle for the 5.10.141 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.141-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.141-rc1

Yang Yingliang <yangyingliang@huawei.com>
    net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    net/af_packet: check len when min_header_len equals to 0

Eric Sandeen <sandeen@redhat.com>
    xfs: revert "xfs: actually bump warning counts when we send warnings"

Brian Foster <bfoster@redhat.com>
    xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong <djwong@kernel.org>
    xfs: fix overfilling of reserve pool

Darrick J. Wong <djwong@kernel.org>
    xfs: always succeed at setting the reserve pool size

Darrick J. Wong <djwong@kernel.org>
    xfs: remove infinite loop when reserving free block pool

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: disable polling pollfree files

Kuniyuki Iwashima <kuniyu@amazon.com>
    kprobes: don't call disarm_kprobe() for disabled kprobes

Christophe Leroy <christophe.leroy@csgroup.eu>
    lib/vdso: Mark do_hres_timens() and do_coarse_timens() __always_inline()

Geert Uytterhoeven <geert@linux-m68k.org>
    netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Dusica Milinkovic <Dusica.Milinkovic@amd.com>
    drm/amdgpu: Increase tlb flush timeout for sriov

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix pixel clock programming

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add missing ->fini_microcode interface for Sienna Cichlid

Juergen Gross <jgross@suse.com>
    s390/hypfs: avoid error message under KVM

Denis V. Lunev <den@openvz.org>
    neigh: fix possible DoS due to net iface start/stop loop

Fudong Wang <Fudong.Wang@amd.com>
    drm/amd/display: clear optc underflow before turn off odm clock

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: For stereo keep "FLIP_ANY_FRAME"

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: Avoid MPC infinite loop

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: mtk-sd: Clear interrupts when cqe off/disable

Jann Horn <jannh@google.com>
    mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Zhengchao Shao <shaozhengchao@huawei.com>
    bpf: Don't redirect packets with invalid pkt_len

Yang Jihong <yangjihong1@huawei.com>
    ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Letu Ren <fantasquex@gmail.com>
    fbdev: fb_pm2fb: Avoid potential divide by zero error

Hawkins Jiawei <yin31149@gmail.com>
    net: fix refcount bug in sk_psock_get (2)

Karthik Alapati <mail@karthek.com>
    HID: hidraw: fix memory leak in hidraw_release()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: pvrusb2: fix memory leak in pvr_probe

Vivek Kasireddy <vivek.kasireddy@intel.com>
    udmabuf: Set the DMA mask for the udmabuf device (v2)

Lee Jones <lee.jones@linaro.org>
    HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix build errors in some archs

Jing Leng <jleng@ambarella.com>
    kbuild: Fix include path in scripts/Makefile.modpost

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Eric Biggers <ebiggers@google.com>
    crypto: lib - remove unneeded selection of XOR_BLOCKS

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Fix i386 RSB stuffing

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Unwreck the RSB stuffing

Jann Horn <jannh@google.com>
    mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/s390/hypfs/hypfs_diag.c                       |  2 +-
 arch/s390/hypfs/inode.c                            |  2 +-
 arch/s390/mm/fault.c                               |  4 +-
 arch/x86/include/asm/nospec-branch.h               | 92 ++++++++++++----------
 drivers/android/binder.c                           |  1 +
 drivers/dma-buf/udmabuf.c                          | 18 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |  3 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  3 +-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |  2 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c   |  6 ++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c  |  5 ++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c   |  6 ++
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c  |  2 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  1 +
 drivers/hid/hid-steam.c                            | 10 +++
 drivers/hid/hidraw.c                               |  3 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  1 +
 drivers/mmc/host/mtk-sd.c                          |  6 ++
 drivers/pci/pcie/portdrv_core.c                    |  9 ++-
 drivers/video/fbdev/pm2fb.c                        |  5 ++
 fs/io_uring.c                                      |  5 ++
 fs/signalfd.c                                      |  1 +
 fs/xfs/xfs_filestream.c                            |  7 +-
 fs/xfs/xfs_fsops.c                                 | 52 +++++-------
 fs/xfs/xfs_mount.h                                 |  8 ++
 fs/xfs/xfs_trans_dquot.c                           |  1 -
 include/linux/fs.h                                 |  1 +
 include/linux/rmap.h                               |  7 +-
 include/linux/skbuff.h                             |  8 ++
 include/linux/skmsg.h                              |  3 +-
 include/net/sock.h                                 | 68 +++++++++++-----
 kernel/kprobes.c                                   |  9 ++-
 kernel/trace/ftrace.c                              | 10 +++
 lib/crypto/Kconfig                                 |  1 -
 lib/vdso/gettimeofday.c                            | 16 ++--
 mm/mmap.c                                          | 12 +++
 mm/rmap.c                                          | 29 ++++---
 net/bluetooth/l2cap_core.c                         | 10 +--
 net/bpf/test_run.c                                 |  3 +
 net/core/dev.c                                     |  1 +
 net/core/neighbour.c                               | 27 +++++--
 net/core/skmsg.c                                   |  4 +-
 net/netfilter/Kconfig                              |  1 -
 net/packet/af_packet.c                             |  4 +-
 scripts/Makefile.modpost                           |  3 +-
 47 files changed, 325 insertions(+), 153 deletions(-)


