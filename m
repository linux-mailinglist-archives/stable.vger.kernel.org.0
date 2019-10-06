Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47594CD405
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfJFRVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfJFRVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:21:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E646222D0;
        Sun,  6 Oct 2019 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382473;
        bh=VcowBUGyIltEVL8tzZOAPeDpf4++RgjiFuFlM9pCv/M=;
        h=From:To:Cc:Subject:Date:From;
        b=Mphdgov8Vs6Z8PXSt4R1eJOKFjiHvHg9K/LSRxRyDYKuaB3M+sVEdFxaMBiWkjYnk
         vwgZL+8LK9kxIktFuthIPbw8XW+pbo+5bz6eOEMGIAQ/f+Tx1jeYQNQYGX7meTBiji
         L7AgNkYRBCVDWw062P3QajyD+wuLzyfZYeZxRUbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/36] 4.4.196-stable review
Date:   Sun,  6 Oct 2019 19:18:42 +0200
Message-Id: <20191006171038.266461022@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.196-rc1
X-KernelTest-Deadline: 2019-10-08T17:11+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.196 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.196-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.196-rc1

Andrey Konovalov <andreyknvl@google.com>
    NFC: fix attrs checks in netlink interface

Eric Biggers <ebiggers@google.com>
    smack: use GFP_NOFS while holding inode_smack::smk_lock

Jann Horn <jannh@google.com>
    Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is set

Eric Dumazet <edumazet@google.com>
    sch_cbq: validate TCA_CBQ_WRROPT to avoid crash

Dotan Barak <dotanb@dev.mellanox.co.il>
    net/rds: Fix error handling in rds_ib_add_one()

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not use ~0U as error return value for xennet_fill_frags()

Eric Dumazet <edumazet@google.com>
    sch_dsmark: fix potential NULL deref in dsmark_init()

Eric Dumazet <edumazet@google.com>
    nfc: fix memory leak in llcp_sock_bind()

Navid Emamdoost <navid.emamdoost@gmail.com>
    net: qlogic: Fix memory leak in ql_alloc_large_buffers

Paolo Abeni <pabeni@redhat.com>
    net: ipv4: avoid mixed n_redirects and rate_tokens usage

Eric Dumazet <edumazet@google.com>
    ipv6: drop incoming packets having a v4mapped source address

Johan Hovold <johan@kernel.org>
    hso: fix NULL-deref on tty open

Martijn Coenen <maco@android.com>
    ANDROID: binder: synchronize_rcu() when using POLLFREE.

Martijn Coenen <maco@android.com>
    ANDROID: binder: remove waitqueue when thread exits.

Nicolas Boichat <drinkcat@chromium.org>
    kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

Changwei Ge <gechangwei@live.cn>
    ocfs2: wait for recovering done after direct unlock request

David Howells <dhowells@redhat.com>
    hypfs: Fix error number left in struct pointer member

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: work around race with userspace's read via blockdev while mounting

Jia-Ju Bai <baijiaju1990@gmail.com>
    security: smack: Fix possible null-pointer dereferences in smack_socket_sock_rcv_skb()

Joao Moreno <mail@joaomoreno.com>
    HID: apple: Fix stuck function keys when using FN

Will Deacon <will@kernel.org>
    ARM: 8898/1: mm: Don't treat faults reported from cache maintenance as writes

Kai-Heng Feng <kai.heng.feng@canonical.com>
    mfd: intel-lpss: Remove D3cold delay

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Reduce memory required for SCSI logging

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: correctly track irq state in default idle

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/exception: machine check use correct cfar for late handler

hexin <hexin.op@gmail.com>
    vfio_pci: Restore original state on release

Sam Bobroff <sbobroff@linux.ibm.com>
    powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag

Sowjanya Komatineni <skomatineni@nvidia.com>
    pinctrl: tegra: Fix write barrier placement in pmx_writel

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: use cond_resched when updating device tree

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/futex: Fix warning: 'oldval' may be used uninitialized in this function

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: use device model APIs and serialization during LPM

Stephen Boyd <sboyd@kernel.org>
    clk: sirf: Don't reference clk_init_data after registration

Nathan Huckleberry <nhuck@google.com>
    clk: qoriq: Fix -Wunused-const-variable

Corey Minyard <cminyard@mvista.com>
    ipmi_si: Only schedule continuously in the thread in maintenance mode

Jia-Ju Bai <baijiaju1990@gmail.com>
    gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_connector_set_property()

Marko Kohtala <marko.kohtala@okoko.fi>
    video: ssd1307fb: Start page range at page_offset


-------------

Diffstat:

 Makefile                                   |  4 +--
 arch/arm/mm/fault.c                        |  4 +--
 arch/arm/mm/fault.h                        |  1 +
 arch/powerpc/include/asm/futex.h           |  3 +-
 arch/powerpc/kernel/eeh_driver.c           | 11 ++++++-
 arch/powerpc/kernel/exceptions-64s.S       |  4 +++
 arch/powerpc/kernel/rtas.c                 | 11 +++++--
 arch/powerpc/platforms/pseries/mobility.c  |  9 ++++++
 arch/powerpc/platforms/pseries/setup.c     |  3 ++
 arch/s390/hypfs/inode.c                    |  9 +++---
 drivers/android/binder.c                   | 26 +++++++++++++++-
 drivers/char/ipmi/ipmi_si_intf.c           | 24 ++++++++++++---
 drivers/clk/clk-qoriq.c                    |  2 +-
 drivers/clk/sirf/clk-common.c              | 12 +++++---
 drivers/gpu/drm/radeon/radeon_connectors.c |  2 +-
 drivers/hid/hid-apple.c                    | 49 +++++++++++++++++-------------
 drivers/mfd/intel-lpss-pci.c               |  2 ++
 drivers/net/ethernet/qlogic/qla3xxx.c      |  1 +
 drivers/net/usb/hso.c                      | 12 +++++---
 drivers/net/xen-netfront.c                 | 17 ++++++-----
 drivers/pinctrl/pinctrl-tegra.c            |  4 ++-
 drivers/scsi/scsi_logging.c                | 48 ++---------------------------
 drivers/vfio/pci/vfio_pci.c                | 17 ++++++++---
 drivers/video/fbdev/ssd1307fb.c            |  2 +-
 fs/fat/dir.c                               | 13 ++++++--
 fs/fat/fatent.c                            |  3 ++
 fs/ocfs2/dlm/dlmunlock.c                   | 23 +++++++++++---
 include/scsi/scsi_dbg.h                    |  2 --
 lib/Kconfig.debug                          |  2 +-
 net/ipv4/route.c                           |  5 ++-
 net/ipv6/ip6_input.c                       | 10 ++++++
 net/nfc/llcp_sock.c                        |  7 ++++-
 net/nfc/netlink.c                          |  6 ++--
 net/rds/ib.c                               |  6 ++--
 net/sched/sch_cbq.c                        | 27 +++++++++++++---
 net/sched/sch_dsmark.c                     |  2 ++
 security/smack/smack_access.c              |  4 +--
 security/smack/smack_lsm.c                 |  7 +++--
 38 files changed, 257 insertions(+), 137 deletions(-)


