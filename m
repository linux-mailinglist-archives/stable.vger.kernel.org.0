Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4521C1423
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgEANgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730826AbgEANgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2F42495D;
        Fri,  1 May 2020 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340171;
        bh=FJHsBQhdNAqF+ef/PqLfGwOHAub/of2UxMYVAXvHH7k=;
        h=From:To:Cc:Subject:Date:From;
        b=v1vgIWOs2IOBBObzCnEuVrhTRma1hLIbEmJ2KXJeCwSTCXP0lot8nC7CTZgm3cmm/
         +lDAFUebS5wWo0vMuYKJI20opnR9tEViriaONDP7vyRCEnvJj13d1+8mPrkeNcXgVF
         e5t4xJFr1cCU77CauQ8slAW1lLqgUo0Lb/kfXOkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/46] 4.19.120-rc1 review
Date:   Fri,  1 May 2020 15:22:25 +0200
Message-Id: <20200501131457.023036302@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.120-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.120-rc1
X-KernelTest-Deadline: 2020-05-03T13:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.120 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.120-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.120-rc1

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: check for non-zero journal inum in ext4_calculate_overhead

Yuval Basson <ybason@marvell.com>
    qed: Fix use after free in qed_chain_free

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86_32: Fix clobbering of dst for BPF_JSET

Sascha Hauer <s.hauer@pengutronix.de>
    hwmon: (jc42) Fix name to have no illegal characters

Theodore Ts'o <tytso@mit.edu>
    ext4: convert BUG_ON's to WARN_ON's in mballoc.c

Theodore Ts'o <tytso@mit.edu>
    ext4: increase wait time needed before reuse of deleted inode numbers

yangerkun <yangerkun@huawei.com>
    ext4: use matching invalidatepage in ext4_writepage

Fangrui Song <maskray@google.com>
    arm64: Delete the space separator in __emit_inst

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: call runtime_allow() for all hda controllers

Juergen Gross <jgross@suse.com>
    xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant status

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support Clang non-section symbols in ORC dump

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: fix PR IN / READ FULL STATUS for FC

Roy Spliet <nouveau@spliet.org>
    ALSA: hda: Explicitly permit using autosuspend if runtime PM is supported

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Keep the controller initialization even if no codecs found

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

Olaf Hering <olaf@aepfle.de>
    x86: hyperv: report value of misc_features

Martin Fuzzey <martin.fuzzey@flowbird.group>
    net: fec: set GPR bit on suspend by DT configuration.

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Eric Biggers <ebiggers@google.com>
    xfs: clear PF_MEMALLOC before exiting xfsaild thread

Yang Shi <yang.shi@linux.alibaba.com>
    mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension

Ian Rogers <irogers@google.com>
    perf/core: fix parent pid/tid in task exit events

Niklas Schnelle <schnelle@linux.ibm.com>
    net/mlx5: Fix failing fw tracer allocation on s390

Toke Høiland-Jørgensen <toke@redhat.com>
    cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    ARM: dts: bcm283x: Disable dsi0 node

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Move Apex Edge TPU class quirk to fix BAR assignment

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Avoid ASMedia XHCI USB PME# from D0 defect

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix leak of svc_rdma_recv_ctxt objects

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix trace point use-after-free race

Brian Foster <bfoster@redhat.com>
    xfs: acquire superblock freeze protection on eofblocks scans

Jason Gunthorpe <jgg@ziepe.ca>
    net/cxgb4: Check the return from t4_query_params properly

David Howells <dhowells@redhat.com>
    rxrpc: Fix DATA Tx to disable nofrag for UDP on AF_INET6 socket

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: altera: use proper variable to hold errno

Vasily Averin <vvs@virtuozzo.com>
    nfsd: memory corruption in nfsd4_lock()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix wrong clock after suspend & resume

Philipp Puschmann <p.puschmann@pironex.de>
    ASoC: tas571x: disable regulators on failed probe

Stephan Gerhold <stephan@gerhold.net>
    ASoC: q6dsp6: q6afe-dai: add missing channels to MI2S DAIs

YueHaibing <yuehaibing@huawei.com>
    iio:ad7797: Use correct attribute_group

Nathan Chancellor <natechancellor@gmail.com>
    usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_complete

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Do link recovery for SS and SSP

Tyler Hicks <tyhicks@canonical.com>
    binder: take read mode of mmap_sem in binder_alloc_free_page()

Christian Borntraeger <borntraeger@de.ibm.com>
    include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

Liu Jian <liujian56@huawei.com>
    mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer

Clement Leger <cleger@kalray.eu>
    remoteproc: Fix wrong rvring index computation


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm283x.dtsi                     |   1 +
 arch/arm64/include/asm/sysreg.h                    |   4 +-
 arch/x86/kernel/cpu/mshyperv.c                     |   4 +-
 arch/x86/net/bpf_jit_comp.c                        |  18 ++-
 arch/x86/net/bpf_jit_comp32.c                      |  24 +++-
 drivers/android/binder_alloc.c                     |   8 +-
 drivers/hwmon/jc42.c                               |   2 +-
 drivers/i2c/busses/i2c-altera.c                    |   9 +-
 drivers/iio/adc/ad7793.c                           |   2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   2 +-
 drivers/net/ethernet/freescale/fec.h               |   7 +
 drivers/net/ethernet/freescale/fec_main.c          | 149 +++++++++++++++++----
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  38 +++---
 drivers/pci/quirks.c                               |  18 +++
 drivers/remoteproc/remoteproc_core.c               |   2 +-
 drivers/staging/gasket/apex_driver.c               |   7 -
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/target/target_core_user.c                  |   1 +
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/udc/bdc/bdc_ep.c                |   2 +-
 drivers/xen/xenbus/xenbus_client.c                 |   9 +-
 fs/ext4/ialloc.c                                   |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |   6 +-
 fs/ext4/super.c                                    |   3 +-
 fs/nfsd/nfs4state.c                                |   2 +
 fs/xfs/xfs_icache.c                                |  10 ++
 fs/xfs/xfs_ioctl.c                                 |   5 +-
 fs/xfs/xfs_reflink.c                               |   1 +
 fs/xfs/xfs_trans_ail.c                             |   4 +-
 include/linux/qed/qed_chain.h                      |  24 ++--
 include/linux/sunrpc/svc_rdma.h                    |   1 +
 include/trace/events/rpcrdma.h                     |  50 +++++--
 include/uapi/linux/swab.h                          |   4 +-
 kernel/bpf/cpumap.c                                |   2 +-
 kernel/events/core.c                               |  13 +-
 mm/shmem.c                                         |   4 +-
 net/rxrpc/local_object.c                           |   9 --
 net/rxrpc/output.c                                 |  44 ++----
 net/sunrpc/svc_xprt.c                              |   3 -
 net/sunrpc/svcsock.c                               |   4 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |  22 +++
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |  29 ++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   5 -
 sound/pci/hda/hda_intel.c                          |  17 ++-
 sound/soc/codecs/tas571x.c                         |  20 ++-
 sound/soc/codecs/wm8960.c                          |   3 +-
 sound/soc/qcom/qdsp6/q6afe-dai.c                   |  16 +++
 tools/objtool/check.c                              |  17 ++-
 tools/objtool/orc_dump.c                           |  44 +++---
 54 files changed, 467 insertions(+), 235 deletions(-)


