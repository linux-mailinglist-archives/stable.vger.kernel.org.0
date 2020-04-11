Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B61A513C
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgDKMYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728527AbgDKMSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:18:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46DF720673;
        Sat, 11 Apr 2020 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607486;
        bh=s81TSmpTOG4bhU/ILdyEKeh6e3ZwxH9byRcniPoQtmY=;
        h=From:To:Cc:Subject:Date:From;
        b=osthnl/vm5LV187+s0UM9gWwxVjSV7dpLLsaPSVGybQ5QA/JVrjxyxsEh22eg4zOk
         GNMT5VQh6wTrMvsbm4xdVUdjaGvZrvCVIuP1ljKPtB5XljisJ5GKleuoeV0riOmLhq
         YmJA99MWEWtC3LMhcQovOOjGBqyCbH6CO4pQWl5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/41] 5.4.32-rc1 review
Date:   Sat, 11 Apr 2020 14:09:09 +0200
Message-Id: <20200411115504.124035693@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.32-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.32-rc1
X-KernelTest-Deadline: 2020-04-13T11:55+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.32 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.32-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.32-rc1

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Allow devices with RMRRs to use identity domain

Sultan Alsawaf <sultan@kerneltoast.com>
    drm/i915: Fix ref->mutex deadlock in i915_active_wait()

Qiujun Huang <hqjagain@gmail.com>
    fbcon: fix null-ptr-deref in fbcon_switch

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Keep set->nr_hw_queues and set->map[].nr_queues in sync

Avihai Horon <avihaih@mellanox.com>
    RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Qiujun Huang <hqjagain@gmail.com>
    Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix passive connection establishment

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Teach lockdep about the order of rtnl and lock

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ucma: Put a lock around every call to the rdma_cm layer

Christian Borntraeger <borntraeger@de.ibm.com>
    include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

Ilya Dryomov <idryomov@gmail.com>
    ceph: canonicalize server path in place

Xiubo Li <xiubli@redhat.com>
    ceph: remove the extra slashes in the server path

Arnd Bergmann <arnd@arndb.de>
    ARM: imx: only select ARM_ERRATA_814220 for ARMv7-A

Anson Huang <Anson.Huang@nxp.com>
    ARM: imx: Enable ARM_ERRATA_814220 for i.MX6UL and i.MX7D

Alex Vesker <valex@mellanox.com>
    IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Call kobject_put() when kobject_init_and_add() fails

Paul Cercueil <paul@crapouillou.net>
    ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()

Hans de Goede <hdegoede@redhat.com>
    ACPI: PM: Add acpi_[un]register_wakeup_handler()

Martin Kaiser <martin@kaiser.cx>
    hwrng: imx-rngc - fix an error path

David Ahern <dsahern@kernel.org>
    tools/accounting/getdelays.c: fix netlink attribute length

Kees Cook <keescook@chromium.org>
    slub: improve bit diffusion for freelist ptr obfuscation

Yury Norov <yury.norov@gmail.com>
    uapi: rename ext2_swab() to swab() and share globally in swab.h

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Wrap around when skip TRBs

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always use batched entropy for get_random_u{32,64}

Sven Schnelle <svens@linux.ibm.com>
    s390: prevent leaking kernel address in BEAR

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: change back SG and TSO to be disabled by default

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Will Deacon <will@kernel.org>
    tun: Don't put_page() for all negative return values from XDP program

Richard Palethorpe <rpalethorpe@suse.com>
    slcan: Don't transmit uninitialized stack data in padding

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a missing refcnt in tcindex_init()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: add a temporary refcnt for struct tcindex_data

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: micrel: kszphy_resume(): add delay after genphy_resume() before accessing PHY registers

Chuanhong Guo <gch981213@gmail.com>
    net: dsa: mt7530: fix null pointer dereferencing in port5 setup

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Do not register slave MDIO bus with OF

Jarod Wilson <jarod@redhat.com>
    ipv6: don't auto-add link-local address to lag ports

Herat Ramani <herat@chelsio.com>
    cxgb4: fix MPS index overwrite when setting MAC address

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: realtek: fix handling of RTL8105e-integrated PHY


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-imx/Kconfig                          |   2 +
 arch/s390/include/asm/lowcore.h                    |   4 +-
 arch/s390/include/asm/processor.h                  |   1 +
 arch/s390/include/asm/setup.h                      |   7 +
 arch/s390/kernel/asm-offsets.c                     |   2 +
 arch/s390/kernel/entry.S                           |  65 +++++----
 arch/s390/kernel/process.c                         |   1 +
 arch/s390/kernel/setup.c                           |   3 +
 arch/s390/kernel/smp.c                             |   2 +
 arch/s390/mm/vmem.c                                |   4 +
 block/blk-mq.c                                     |   8 ++
 drivers/acpi/sleep.c                               |   4 +
 drivers/acpi/sleep.h                               |   1 +
 drivers/acpi/wakeup.c                              |  81 ++++++++++++
 drivers/char/hw_random/imx-rngc.c                  |   4 +-
 drivers/char/random.c                              |  20 +--
 drivers/gpu/drm/i915/i915_active.c                 |  29 +++--
 drivers/gpu/drm/i915/i915_active.h                 |   4 +-
 drivers/infiniband/core/cma.c                      |  14 ++
 drivers/infiniband/core/ucma.c                     |  49 ++++++-
 drivers/infiniband/hw/hfi1/sysfs.c                 |  26 +++-
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/infiniband/sw/siw/siw_cm.c                 | 145 +++++----------------
 drivers/iommu/intel-iommu.c                        |  15 +--
 drivers/net/can/slcan.c                            |   4 +-
 drivers/net/dsa/bcm_sf2.c                          |   9 +-
 drivers/net/dsa/mt7530.c                           |   3 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   1 -
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  34 +++--
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   2 +-
 drivers/net/phy/micrel.c                           |   7 +
 drivers/net/phy/realtek.c                          |   9 ++
 drivers/net/tun.c                                  |  10 +-
 drivers/platform/x86/intel_int0002_vgpio.c         |  10 ++
 drivers/usb/dwc3/gadget.c                          |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   3 +
 fs/ceph/super.c                                    |  56 +++++---
 fs/ceph/super.h                                    |   2 +-
 include/linux/acpi.h                               |   5 +
 include/linux/mlx5/mlx5_ifc.h                      |   6 +-
 include/linux/swab.h                               |   1 +
 include/uapi/linux/swab.h                          |  10 ++
 lib/find_bit.c                                     |  16 +--
 mm/slub.c                                          |   2 +-
 net/bluetooth/rfcomm/tty.c                         |   4 +-
 net/ipv6/addrconf.c                                |   4 +
 net/sched/cls_tcindex.c                            |  45 ++++++-
 sound/soc/jz4740/jz4740-i2s.c                      |   2 +-
 tools/accounting/getdelays.c                       |   2 +-
 51 files changed, 481 insertions(+), 278 deletions(-)


