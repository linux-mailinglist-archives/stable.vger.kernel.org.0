Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2DD1EAF37
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgFATAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 15:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbgFAR4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC432073B;
        Mon,  1 Jun 2020 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034202;
        bh=szISi4dIy17RLUtwXaRBPYeRV8Cya9mP010a1Dmw7SY=;
        h=From:To:Cc:Subject:Date:From;
        b=ALjvVt1GjTJDIT6aHHtkgrpQlC/6vOGKfdNtrpXOtV2AFhnQFepez5hq+xMvU3S2q
         qHdqp+R30dNqramgF72MH/UHAcjXyec2H+b4QmhMKB0iM4hTsxaC56+g3NyWQqUMb4
         JNKu6ottuJNVpyAoKs2TgQixDScBMBI1dIUfqW58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/48] 4.4.226-rc1 review
Date:   Mon,  1 Jun 2020 19:53:10 +0200
Message-Id: <20200601173952.175939894@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.226-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.226-rc1
X-KernelTest-Deadline: 2020-06-03T17:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.226 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Jun 2020 17:38:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.226-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.226-rc1

Ben Hutchings <ben.hutchings@codethink.co.uk>
    drm/msm: Fix possible null dereference on failure of get_pages()

Guoqing Jiang <gqjiang@suse.com>
    sc16is7xx: move label 'err_spi' to correct section

Michal Marek <mmarek@suse.com>
    asm-prototypes: Clear any CPP defines before declaring the functions

Liviu Dudau <liviu@dudau.co.uk>
    mm/vmalloc.c: don't dereference possible NULL pointer in __vunmap()

Roopa Prabhu <roopa@cumulusnetworks.com>
    net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags

Sudip Mukherjee <sudip@vectorindia.org>
    mac80211: fix memory leak

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: gadget: fix spin_lock_init() for &uep->lock

Thomas Gleixner <tglx@linutronix.de>
    genirq/generic_pending: Do not lose pending affinity update

Matt Roper <matthew.d.roper@intel.com>
    drm/fb-helper: Use proper plane mask for fb cleanup

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "Input: i8042 - add ThinkPad S230u to i8042 nomux list"

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

Helge Deller <deller@gmx.de>
    parisc: Fix kernel panic in mem_init()

Qiushi Wu <wu000273@umn.edu>
    iommu: Fix reference count leak in iommu_group_alloc.

Arnd Bergmann <arnd@arndb.de>
    include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Alexander Potapenko <glider@google.com>
    fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Eric W. Biederman <ebiederm@xmission.com>
    exec: Always set cap_ambient in cap_bprm_set_creds

Chris Chiu <chiu@endlessm.com>
    ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Changming Liu <liu.changm@northeastern.edu>
    ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Kaike Wan <kaike.wan@intel.com>
    IB/qib: Call kobject_put() when kobject_init_and_add() fails

Kevin Locke <kevin@kevinlocke.name>
    Input: i8042 - add ThinkPad S230u to i8042 reset list

Łukasz Patron <priv.luk@gmail.com>
    Input: xpad - add custom init packet for Xbox One S controllers

Brendan Shanks <bshanks@codeweavers.com>
    Input: evdev - call input_flush_device() on release(), not flush()

Kevin Locke <kevin@kevinlocke.name>
    Input: i8042 - add ThinkPad S230u to i8042 nomux list

James Hilliard <james.hilliard1@gmail.com>
    Input: usbtouchscreen - add support for BonXeon TP

Steve French <stfrench@microsoft.com>
    cifs: Fix null pointer check in cifs_read

Masahiro Yamada <masahiroy@kernel.org>
    usb: gadget: legacy: fix redundant initialization warnings

Lei Xue <carmark.dlut@gmail.com>
    cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Bob Peterson <rpeterso@redhat.com>
    gfs2: don't call quota_unhold if quotas are not locked

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

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Yuqi Jin <jinyuqi@huawei.com>
    net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Eric Dumazet <edumazet@google.com>
    ax25: fix setsockopt(SO_BINDTODEVICE)


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/parisc/mm/init.c                              |  2 +-
 arch/x86/include/asm/dma.h                         |  2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  2 +-
 drivers/gpu/drm/msm/msm_gem.c                      | 20 +++---
 drivers/infiniband/hw/qib/qib_sysfs.c              |  9 +--
 drivers/input/evdev.c                              | 19 ++----
 drivers/input/joystick/xpad.c                      | 12 ++++
 drivers/input/serio/i8042-x86ia64io.h              |  7 ++
 drivers/input/touchscreen/usbtouchscreen.c         |  1 +
 drivers/iommu/iommu.c                              |  2 +-
 drivers/net/bonding/bond_sysfs_slave.c             |  4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 15 +++++
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  4 +-
 drivers/net/ethernet/sun/cassini.c                 |  3 +-
 drivers/tty/serial/sc16is7xx.c                     |  2 +
 drivers/usb/gadget/legacy/inode.c                  |  3 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |  2 +-
 fs/binfmt_elf.c                                    |  2 +-
 fs/cachefiles/rdwr.c                               |  2 +-
 fs/cifs/file.c                                     |  2 +-
 fs/gfs2/quota.c                                    |  3 +-
 include/asm-generic/asm-prototypes.h               |  6 ++
 include/asm-generic/topology.h                     |  2 +-
 include/linux/mlx5/driver.h                        |  1 +
 include/linux/mm.h                                 |  1 -
 include/linux/netfilter/nf_conntrack_pptp.h        |  2 +-
 include/rdma/ib_addr.h                             |  6 +-
 include/uapi/linux/l2tp.h                          |  7 +-
 kernel/irq/migration.c                             | 26 ++++++--
 mm/vmalloc.c                                       |  2 +-
 net/ax25/af_ax25.c                                 |  6 +-
 net/bridge/netfilter/nft_reject_bridge.c           |  6 ++
 net/core/rtnetlink.c                               |  2 +-
 net/ipv4/ip_vti.c                                  | 75 ++++++++++++----------
 net/ipv4/netfilter/nf_nat_pptp.c                   |  7 +-
 net/ipv4/route.c                                   | 14 ++--
 net/mac80211/sta_info.c                            |  1 +
 net/netfilter/ipset/ip_set_list_set.c              |  2 +-
 net/netfilter/nf_conntrack_pptp.c                  | 62 ++++++++++--------
 net/sctp/sm_statefuns.c                            |  9 +--
 net/xfrm/xfrm_input.c                              |  2 +-
 net/xfrm/xfrm_output.c                             |  3 +-
 net/xfrm/xfrm_policy.c                             |  7 +-
 security/commoncap.c                               |  1 +
 sound/core/hwdep.c                                 |  4 +-
 sound/usb/mixer.c                                  |  8 +++
 48 files changed, 229 insertions(+), 157 deletions(-)


