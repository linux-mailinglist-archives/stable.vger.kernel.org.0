Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDBE1EB97B
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 12:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgFBKXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 06:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgFBKXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 06:23:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24723206C3;
        Tue,  2 Jun 2020 10:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591093394;
        bh=8ZAJGnkLnmIwLg9sd8J+pJnruwfnglIoaLEiO+TU+xA=;
        h=From:To:Cc:Subject:Date:From;
        b=KseuSdFCm078OuwE2rsLJdsFwiEyb9dXoVcXTEGTINJWf8VZnEwTbwFAu/HuyTQyi
         +ewylLZkod1u9kLlS6p0mGCczApSueWFfM7d50dvGrJIvP+IC0gkwrxGZsNqU8QPB0
         HSUcGYby8hlePRwJB4JDRccy3cKVVjUEzAJ3SLsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/59] 4.9.226-rc2 review
Date:   Tue,  2 Jun 2020 12:23:11 +0200
Message-Id: <20200602101841.662517961@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.226-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.226-rc2
X-KernelTest-Deadline: 2020-06-04T10:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.226 release.
There are 59 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.226-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.226-rc2

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix request object use-after-free in send path causing wrong traces

Salil Mehta <salil.mehta@huawei.com>
    net: hns: Fixes the missing put_device in positive leg for roce reset

Guoqing Jiang <gqjiang@suse.com>
    sc16is7xx: move label 'err_spi' to correct section

Liviu Dudau <liviu@dudau.co.uk>
    mm/vmalloc.c: don't dereference possible NULL pointer in __vunmap()

Roopa Prabhu <roopa@cumulusnetworks.com>
    net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags

Thomas Gleixner <tglx@linutronix.de>
    genirq/generic_pending: Do not lose pending affinity update

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Qiushi Wu <wu000273@umn.edu>
    bonding: Fix reference count leak in bond_sysfs_slave_add.

Qiushi Wu <wu000273@umn.edu>
    qlcnic: fix missing release in qlcnic_83xx_interrupt_test.

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Fix subcounter update skip

Michael Braun <michael-dev@fami-braun.de>
    netfilter: nft_reject_bridge: enable reject with bridge vlan

Xin Long <lucien.xin@gmail.com>
    ip_vti: receive ipip packet by calling ip_tunnel_rcv

Jeremy Sowden <jeremy@azazel.net>
    vti4: eliminated some duplicate code.

Xin Long <lucien.xin@gmail.com>
    xfrm: fix a NULL-ptr deref in xfrm_local_error

Xin Long <lucien.xin@gmail.com>
    xfrm: fix a warning in xfrm_policy_insert_list

Xin Long <lucien.xin@gmail.com>
    xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input

Alexander Dahl <post@lespocky.de>
    x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: mesh: fix discovery timer re-arming issue / crash

Helge Deller <deller@gmx.de>
    parisc: Fix kernel panic in mem_init()

Qiushi Wu <wu000273@umn.edu>
    iommu: Fix reference count leak in iommu_group_alloc.

Arnd Bergmann <arnd@arndb.de>
    include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Alexander Potapenko <glider@google.com>
    fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Jerry Lee <leisurelysw24@gmail.com>
    libceph: ignore pool overlay and cache logic on redirects

Eric W. Biederman <ebiederm@xmission.com>
    exec: Always set cap_ambient in cap_bprm_set_creds

Chris Chiu <chiu@endlessm.com>
    ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Changming Liu <liu.changm@northeastern.edu>
    ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Robert Beckett <bob.beckett@collabora.com>
    ARM: dts/imx6q-bx50v3: Set display interface clock parents

Sebastian Reichel <sebastian.reichel@collabora.co.uk>
    ARM: dts: imx6q-bx50v3: Add internal switch

Martyn Welch <martyn.welch@collabora.co.uk>
    ARM: dts: imx: Correct B850v3 clock assignment

Kaike Wan <kaike.wan@intel.com>
    IB/qib: Call kobject_put() when kobject_init_and_add() fails

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: fix DACR mismatch with nested exceptions

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: integrate uaccess_save and uaccess_restore

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h

Stefan Agner <stefan@agner.ch>
    ARM: 8843/1: use unified assembler in headers

Wei Yongjun <weiyongjun1@huawei.com>
    Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()

Kevin Locke <kevin@kevinlocke.name>
    Input: i8042 - add ThinkPad S230u to i8042 reset list

Łukasz Patron <priv.luk@gmail.com>
    Input: xpad - add custom init packet for Xbox One S controllers

Brendan Shanks <bshanks@codeweavers.com>
    Input: evdev - call input_flush_device() on release(), not flush()

James Hilliard <james.hilliard1@gmail.com>
    Input: usbtouchscreen - add support for BonXeon TP

Steve French <stfrench@microsoft.com>
    cifs: Fix null pointer check in cifs_read

Masahiro Yamada <masahiroy@kernel.org>
    usb: gadget: legacy: fix redundant initialization warnings

Lei Xue <carmark.dlut@gmail.com>
    cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Bob Peterson <rpeterso@redhat.com>
    gfs2: move privileged user check to gfs2_quota_lock_check

Chuhong Yuan <hslester96@gmail.com>
    net: microchip: encx24j600: add missed kthread_stop

Stephen Warren <swarren@nvidia.com>
    gpio: tegra: mask GPIO IRQs during IRQ shutdown

Kalderon, Michal <Michal.Kalderon@cavium.com>
    IB/cma: Fix reference count leak when no ipv4 addresses are set

Dmitry V. Levin <ldv@altlinux.org>
    uapi: fix linux/if_pppol2tp.h userspace compilation errors

Qiushi Wu <wu000273@umn.edu>
    net/mlx4_core: fix a memory leak bug.

Qiushi Wu <wu000273@umn.edu>
    net: sun: fix missing release regions in cas_init_one().

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Add command entry handling completion

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5e: Update netdev txq on completions during closure

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Roman Mashak <mrv@mojatatu.com>
    net sched: fix reporting the first-time use timestamp

Yuqi Jin <jinyuqi@huawei.com>
    net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipip: fix wrong address family in init error path

Eric Dumazet <edumazet@google.com>
    ax25: fix setsockopt(SO_BINDTODEVICE)


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6q-b450v3.dts                 |   7 --
 arch/arm/boot/dts/imx6q-b650v3.dts                 |   7 --
 arch/arm/boot/dts/imx6q-b850v3.dts                 |  11 --
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                |  77 ++++++++++++++
 arch/arm/include/asm/assembler.h                   |  83 +--------------
 arch/arm/include/asm/uaccess-asm.h                 | 117 +++++++++++++++++++++
 arch/arm/include/asm/vfpmacros.h                   |   8 +-
 arch/arm/kernel/entry-armv.S                       |  11 +-
 arch/arm/kernel/entry-header.S                     |   9 +-
 arch/arm/lib/bitops.h                              |   8 +-
 arch/parisc/mm/init.c                              |   2 +-
 arch/x86/include/asm/dma.h                         |   2 +-
 drivers/gpio/gpio-tegra.c                          |   1 +
 drivers/infiniband/hw/qib/qib_sysfs.c              |   9 +-
 drivers/input/evdev.c                              |  19 +---
 drivers/input/joystick/xpad.c                      |  12 +++
 drivers/input/rmi4/rmi_driver.c                    |   3 +-
 drivers/input/serio/i8042-x86ia64io.h              |   7 ++
 drivers/input/touchscreen/usbtouchscreen.c         |   1 +
 drivers/iommu/iommu.c                              |   2 +-
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |   3 +
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  15 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +-
 drivers/net/ethernet/microchip/encx24j600.c        |   5 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/sun/cassini.c                 |   3 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  10 +-
 drivers/tty/serial/sc16is7xx.c                     |   2 +
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 fs/binfmt_elf.c                                    |   2 +-
 fs/cachefiles/rdwr.c                               |   2 +-
 fs/cifs/file.c                                     |   2 +-
 fs/gfs2/quota.c                                    |   3 +-
 fs/gfs2/quota.h                                    |   3 +-
 include/asm-generic/topology.h                     |   2 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |  15 ++-
 include/linux/netfilter/nf_conntrack_pptp.h        |   2 +-
 include/net/act_api.h                              |   3 +-
 include/rdma/ib_addr.h                             |   6 +-
 include/uapi/linux/l2tp.h                          |   7 +-
 kernel/irq/migration.c                             |  26 +++--
 mm/vmalloc.c                                       |   2 +-
 net/ax25/af_ax25.c                                 |   6 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   6 ++
 net/ceph/osd_client.c                              |   4 +-
 net/core/rtnetlink.c                               |   2 +-
 net/ipv4/ip_vti.c                                  |  75 +++++++------
 net/ipv4/ipip.c                                    |   2 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   7 +-
 net/ipv4/route.c                                   |  14 ++-
 net/mac80211/mesh_hwmp.c                           |   7 ++
 net/netfilter/ipset/ip_set_list_set.c              |   2 +-
 net/netfilter/nf_conntrack_pptp.c                  |  62 ++++++-----
 net/qrtr/qrtr.c                                    |   2 +-
 net/sctp/sm_statefuns.c                            |   9 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 net/xfrm/xfrm_output.c                             |   3 +-
 net/xfrm/xfrm_policy.c                             |   7 +-
 security/commoncap.c                               |   1 +
 sound/core/hwdep.c                                 |   4 +-
 sound/usb/mixer.c                                  |   8 ++
 65 files changed, 473 insertions(+), 283 deletions(-)


