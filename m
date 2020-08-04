Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAD123B5C5
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgHDHdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 03:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgHDHdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 03:33:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0CF2076C;
        Tue,  4 Aug 2020 07:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596526387;
        bh=eFC7rGona/PKnHBCNpAvkQepm2BwfDQx6Jewa0S1pBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=UOFom0g/9pWPFBEYyTyDN3cIf3yWYzrZifM/Dq04gjWeqQDQSd1S84E+hf3xGIoQA
         dsUjf0obPN+4cd59WkmRAumjbQxrLlDMvZ0H5v/CaszL7dliDinrz6caW+rwSbA1J9
         oJ0UK3QRgJ/ZGSoGtv3W0piowcbNdxoWARsak1P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/52] 4.14.192-rc2 review
Date:   Tue,  4 Aug 2020 09:32:47 +0200
Message-Id: <20200804072410.858718934@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.192-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.192-rc2
X-KernelTest-Deadline: 2020-08-06T07:24+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.192 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 06 Aug 2020 07:23:45 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.192-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.192-rc2

Linus Torvalds <torvalds@linux-foundation.org>
    random32: move the pseudo-random 32-bit definitions to prandom.h

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Use printk_deferred() to prevent deadlock

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled

Andrea Righi <andrea.righi@canonical.com>
    xen-netfront: fix potential deadlock in xennet_remove()

Navid Emamdoost <navid.emamdoost@gmail.com>
    cxgb4: add missing release on skb in uld_send()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix ORC for newly forked tasks

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    Revert "i2c: cadence: Fix the hold bit setting"

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: ravb: exit if re-initialization fails in tx timeout

Liam Beguin <liambeguin@gmail.com>
    parisc: add support for cmpxchg on u8 pointers

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame

Laurence Oberman <loberman@redhat.com>
    qed: Disable "MFW indication via attention" SPAM every 5 minutes

Geert Uytterhoeven <geert@linux-m68k.org>
    usb: hso: Fix debug compile warning on sparc32

Robin Murphy <robin.murphy@arm.com>
    arm64: csum: Fix handling of bad packets

Sami Tolvanen <samitolvanen@google.com>
    arm64/alternatives: move length validation inside the subsection

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free pending skb when destroying a mpath

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free ie data when leaving mesh

Andrii Nakryiko <andriin@fb.com>
    bpf: Fix map leak in HASH_OF_MAPS map

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Fix IRQ mapping disposal in error path

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Free EMAD transactions using kfree_rcu()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Increase scope of RCU read-side critical section

Jakub Kicinski <kuba@kernel.org>
    mlx4: disable device on shutdown

Johan Hovold <johan@kernel.org>
    net: lan78xx: fix transfer-buffer memory leak

Johan Hovold <johan@kernel.org>
    net: lan78xx: add missing endpoint sanity check

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: Fix validation of system call number

Tanner Love <tannerlove@google.com>
    selftests/net: rxtimestamp: fix clang issues for target arch PowerPC

YueHaibing <yuehaibing@huawei.com>
    net/x25: Fix null-ptr-deref in x25_disconnect

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Rik van Riel <riel@surriel.com>
    xfs: fix missed wakeup on l_flush_wait

Peilin Ye <yepeilin.cs@gmail.com>
    rds: Prevent kernel-infoleak in rds_notify_queue_get()

Joerg Roedel <jroedel@suse.de>
    x86, vmlinux.lds: Page-align end of ..page_aligned sections

Sami Tolvanen <samitolvanen@google.com>
    x86/build/lto: Fix truncated .bss with -fdata-sections

Wang Hai <wanghai38@huawei.com>
    9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work

Dominique Martinet <dominique.martinet@cea.fr>
    9p/trans_fd: abort p9_read_work if req status changed

Linus Torvalds <torvalds@linux-foundation.org>
    random32: remove net_rand_state from the latent entropy gcc plugin

Willy Tarreau <w@1wt.eu>
    random: fix circular include dependency on arm64 after addition of percpu.h

Sheng Yong <shengyong1@huawei.com>
    f2fs: check if file namelen exceeds max value

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check memory boundary by insane namelen

Steve Cohen <cohens@codeaurora.org>
    drm: hold gem reference until object is no longer accessed

Peilin Ye <yepeilin.cs@gmail.com>
    drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: percpu.h: fix build error

Willy Tarreau <w@1wt.eu>
    random32: update the net random state on interrupt and activity

Will Deacon <will@kernel.org>
    ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Pi-Hsun Shih <pihsun@chromium.org>
    wireless: Use offsetof instead of custom macro.

Robert Hancock <hancockrwd@gmail.com>
    PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

Sasha Levin <sashal@kernel.org>
    x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath9k: release allocated buffer if timed out

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath9k_htc: release allocated buffer if timed out

Sasha Levin <sashal@kernel.org>
    iio: imu: adis16400: fix memory leak

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: rc: prevent memory leak in cx23888_ir_probe

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: ccp - Release all allocated memory if sha type is invalid

Wei Yongjun <weiyongjun1@huawei.com>
    net: phy: mdio-bcm-unimac: fix potential NULL dereference in unimac_mdio_probe()

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: direct call probe and destruct


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/percpu.h                      |  2 +
 arch/arm/kernel/hw_breakpoint.c                    | 27 ++++++--
 arch/arm64/include/asm/alternative.h               |  4 +-
 arch/arm64/include/asm/checksum.h                  |  5 +-
 arch/parisc/include/asm/cmpxchg.h                  |  2 +
 arch/parisc/lib/bitops.c                           | 12 ++++
 arch/sh/kernel/entry-common.S                      |  6 +-
 arch/x86/kernel/i8259.c                            |  2 +-
 arch/x86/kernel/unwind_orc.c                       |  8 ++-
 arch/x86/kernel/vmlinux.lds.S                      |  3 +-
 arch/x86/kvm/lapic.c                               |  2 +-
 arch/x86/kvm/x86.c                                 |  3 +
 drivers/char/random.c                              |  1 +
 drivers/crypto/ccp/ccp-ops.c                       |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  3 +-
 drivers/gpu/drm/drm_gem.c                          | 10 ++-
 drivers/i2c/busses/i2c-cadence.c                   |  9 +--
 drivers/iio/imu/adis16400_buffer.c                 |  5 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |  5 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  8 ++-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |  3 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 26 +++++++-
 drivers/net/phy/mdio-bcm-unimac.c                  |  2 +
 drivers/net/usb/hso.c                              |  5 +-
 drivers/net/usb/lan78xx.c                          |  6 ++
 drivers/net/wireless/ath/ath9k/htc_hst.c           |  3 +
 drivers/net/wireless/ath/ath9k/wmi.c               |  1 +
 drivers/net/xen-netfront.c                         | 64 ++++++++++++------
 drivers/nfc/s3fwrn5/core.c                         |  1 +
 drivers/pci/quirks.c                               | 13 ++++
 drivers/scsi/libsas/sas_ata.c                      |  1 -
 drivers/scsi/libsas/sas_discover.c                 | 32 +++++----
 drivers/scsi/libsas/sas_expander.c                 |  8 +--
 drivers/scsi/libsas/sas_internal.h                 |  1 +
 drivers/scsi/libsas/sas_port.c                     |  3 +
 fs/f2fs/dir.c                                      | 12 +++-
 fs/xfs/xfs_log.c                                   |  9 ++-
 include/asm-generic/vmlinux.lds.h                  |  5 +-
 include/linux/prandom.h                            | 78 ++++++++++++++++++++++
 include/linux/random.h                             | 63 ++---------------
 include/scsi/libsas.h                              |  3 +-
 include/scsi/scsi_transport_sas.h                  |  1 +
 include/uapi/linux/wireless.h                      |  5 +-
 kernel/bpf/hashtab.c                               | 12 +++-
 kernel/time/timer.c                                |  8 +++
 lib/random32.c                                     |  2 +-
 net/9p/trans_fd.c                                  | 32 +++++++--
 net/mac80211/cfg.c                                 |  1 +
 net/mac80211/mesh_pathtbl.c                        |  1 +
 net/rds/recv.c                                     |  3 +-
 net/x25/x25_subr.c                                 |  6 ++
 .../networking/timestamping/rxtimestamp.c          |  3 +-
 56 files changed, 371 insertions(+), 171 deletions(-)


