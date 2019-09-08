Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6156ACD0B
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbfIHMpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbfIHMpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:45:07 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19210218AF;
        Sun,  8 Sep 2019 12:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946706;
        bh=k4hjebs/uUf3jvaMMdAe0vCKrtxgMQ31qkqp6YxsfKI=;
        h=From:To:Cc:Subject:Date:From;
        b=lQCIOgbE544nhE3gbMHOMc2aATqCTBhMUftaAdRgjUN8TuJ431Av6BFzkLN6k+0sc
         SXTIKCZthI4twn58Yx4p4xljsM9JtC5WAEP53lnvKfeVCdTtqQZ08oLSSYj7OlBSpk
         Sv6ZKwAgS7p3dzPNmiiEGZozyDHewK43Fn036JK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/40] 4.14.143-stable review
Date:   Sun,  8 Sep 2019 13:41:33 +0100
Message-Id: <20190908121114.260662089@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.143-rc1
X-KernelTest-Deadline: 2019-09-10T12:11+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.143 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.143-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.143-rc1

John S. Gruber <JohnSGruber@gmail.com>
    x86/boot: Preserve boot_params.secure_boot from sanitizing

Eric Dumazet <edumazet@google.com>
    mld: fix memory leak in mld_del_delrec()

Vlad Buslov <vladbu@mellanox.com>
    net: sched: act_sample: fix psample group handling on overwrite

Eric Dumazet <edumazet@google.com>
    tcp: remove empty skb from write queue in error cases

Willem de Bruijn <willemb@google.com>
    tcp: inherit timestamp on mtu probe

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a NULL pointer deref in ipt action

Feng Sun <loyou85@gmail.com>
    net: fix skb use after free in netpoll

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "x86/apic: Include the LDR when clearing out APIC registers"

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: fix corruptions for longer spi transfers

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: remove dangerous uncontrolled read of fifo

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: unifying code between polling and interrupt driven code

Luis Henriques <lhenriques@suse.com>
    libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Only skip MMIO insn once

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in fill_inode()

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in __ceph_build_xattrs_blob()

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()

Wenwen Wang <wenwen@cs.uga.edu>
    IB/mlx4: Fix memory leaks

Vitaly Kuznetsov <vkuznets@redhat.com>
    Tools: hv: kvp: eliminate 'may be used uninitialized' warning

Dexuan Cui <decui@microsoft.com>
    Input: hyperv-keyboard: Use in-place iterator API in the channel callback

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: cp2112: prevent sleeping function called from invalid context

Andrea Righi <andrea.righi@canonical.com>
    kprobes: Fix potential deadlock in kprobe_optimizer()

Tho Vu <tho.vu.wh@rvc.renesas.com>
    ravb: Fix use-after-free ravb_tstamp_skb

Wenwen Wang <wenwen@cs.uga.edu>
    wimax/i2400m: fix a memory leak bug

Wenwen Wang <wenwen@cs.uga.edu>
    net: kalmia: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    cx82310_eth: fix a memory leak bug

Darrick J. Wong <darrick.wong@oracle.com>
    vfs: fix page locking deadlocks when deduping files

Wenwen Wang <wenwen@cs.uga.edu>
    lan78xx: Fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    net: myri10ge: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    liquidio: add cleanup in octeon_setup_iq()

Wenwen Wang <wenwen@cs.uga.edu>
    cxgb4: fix a memory leak bug

Alexandre Courbot <acourbot@chromium.org>
    drm/mediatek: set DMA max segment size

Alexandre Courbot <acourbot@chromium.org>
    drm/mediatek: use correct device to import PRIME buffers

YueHaibing <yuehaibing@huawei.com>
    gpio: Fix build error of function redefinition

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmveth: Convert multicast list size for little-endian system

Fabian Henneke <fabian.henneke@gmail.com>
    Bluetooth: hidp: Let hidp_send_message return number of queued bytes

Matthias Kaehlcke <mka@chromium.org>
    Bluetooth: btqca: Add a short delay before downloading the NVM

Nathan Chancellor <natechancellor@gmail.com>
    net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Dexuan Cui <decui@microsoft.com>
    hv_netvsc: Fix a warning of suspicious RCU usage

Fuqian Huang <huangfq.daxian@gmail.com>
    net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/include/asm/bootparam_utils.h             |  1 +
 arch/x86/kernel/apic/apic.c                        |  4 --
 drivers/bluetooth/btqca.c                          |  3 ++
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             | 49 +++++++++++++++--
 drivers/gpu/drm/mediatek/mtk_drm_drv.h             |  2 +
 drivers/hid/hid-cp2112.c                           |  8 ++-
 drivers/infiniband/hw/mlx4/mad.c                   |  4 +-
 drivers/input/serio/hyperv-keyboard.c              | 35 +++---------
 .../net/ethernet/cavium/liquidio/request_manager.c |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  9 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  8 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  6 +--
 drivers/net/ethernet/toshiba/tc35815.c             |  2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |  5 +-
 drivers/net/hyperv/netvsc_drv.c                    |  9 +++-
 drivers/net/usb/cx82310_eth.c                      |  3 +-
 drivers/net/usb/kalmia.c                           |  6 +--
 drivers/net/usb/lan78xx.c                          |  8 +--
 drivers/net/wimax/i2400m/fw.c                      |  4 +-
 drivers/spi/spi-bcm2835aux.c                       | 62 +++++++---------------
 fs/ceph/caps.c                                     |  5 +-
 fs/ceph/inode.c                                    |  7 +--
 fs/ceph/snap.c                                     |  4 +-
 fs/ceph/super.h                                    |  2 +-
 fs/ceph/xattr.c                                    | 19 +++++--
 fs/read_write.c                                    | 49 ++++++++++++++---
 include/linux/ceph/buffer.h                        |  3 +-
 include/linux/gpio.h                               | 24 ---------
 include/net/act_api.h                              |  4 +-
 include/net/psample.h                              |  1 +
 kernel/kprobes.c                                   |  8 +--
 net/bluetooth/hidp/core.c                          |  9 +++-
 net/core/netpoll.c                                 |  6 +--
 net/ipv4/tcp.c                                     | 29 ++++++----
 net/ipv4/tcp_output.c                              |  3 +-
 net/ipv6/mcast.c                                   |  5 +-
 net/psample/psample.c                              |  2 +-
 net/sched/act_bpf.c                                |  2 +-
 net/sched/act_connmark.c                           |  2 +-
 net/sched/act_csum.c                               |  2 +-
 net/sched/act_gact.c                               |  2 +-
 net/sched/act_ife.c                                |  2 +-
 net/sched/act_ipt.c                                | 11 ++--
 net/sched/act_mirred.c                             |  2 +-
 net/sched/act_nat.c                                |  2 +-
 net/sched/act_pedit.c                              |  2 +-
 net/sched/act_police.c                             |  2 +-
 net/sched/act_sample.c                             |  7 ++-
 net/sched/act_simple.c                             |  2 +-
 net/sched/act_skbedit.c                            |  2 +-
 net/sched/act_skbmod.c                             |  2 +-
 net/sched/act_tunnel_key.c                         |  2 +-
 net/sched/act_vlan.c                               |  2 +-
 tools/hv/hv_kvp_daemon.c                           |  2 +-
 virt/kvm/arm/mmio.c                                |  7 +++
 58 files changed, 278 insertions(+), 199 deletions(-)


