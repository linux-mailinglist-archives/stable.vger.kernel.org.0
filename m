Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEACB4D7C9
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbfFTSK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbfFTSK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1AF52082C;
        Thu, 20 Jun 2019 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054226;
        bh=W7SsqSxmtCDPm7d215z2eV0oQtZimkaPgCfTdP+4uzc=;
        h=From:To:Cc:Subject:Date:From;
        b=ckFcFrVIA6mI6hlLdU9hHw+5rKTG4ZDEWxkzYLoCCwEm5qlz0+64M1uIj7Bu26c6Z
         wSnYfLmUBXjDRE1s+Eb0S2hL6aTeedq4xgxGnhAwmORPGRY7vk+d++fpV0sd5297Gc
         DrQJzhf5Sn51/25NT6qiU3PBBABC34RnOIhQRJlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/61] 4.19.54-stable review
Date:   Thu, 20 Jun 2019 19:56:55 +0200
Message-Id: <20190620174336.357373754@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.54-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.54-rc1
X-KernelTest-Deadline: 2019-06-22T17:43+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.54 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.54-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.54-rc1

Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
    Abort file_remove_privs() for non-reg. files

Andrea Arcangeli <aarcange@redhat.com>
    coredump: fix race condition between collapse_huge_page() and core dumping

Tobin C. Harding <tobin@kernel.org>
    ocfs2: fix error path kobject memory leak

Amit Cohen <amitc@mellanox.com>
    mlxsw: spectrum: Prevent force of 56G

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: delete sas port if expander discover failed

YueHaibing <yuehaibing@huawei.com>
    scsi: scsi_dh_alua: Fix possible null-ptr-deref

Lianbo Jiang <lijiang@redhat.com>
    scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask

Varun Prakash <varun@chelsio.com>
    scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

Max Uvarov <muvarov@gmail.com>
    net: phy: dp83867: Set up RGMII TX delay

Russell King <rmk+kernel@armlinux.org.uk>
    net: phylink: ensure consistent phy interface mode

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs

Sami Tolvanen <samitolvanen@google.com>
    arm64: use the correct function type for __arm64_sys_ni_syscall

Sami Tolvanen <samitolvanen@google.com>
    arm64: use the correct function type in SYSCALL_DEFINE0

Sami Tolvanen <samitolvanen@google.com>
    arm64: fix syscall_fn_t type

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list

Ross Lagerwall <ross.lagerwall@citrix.com>
    xenbus: Avoid deadlock during suspend due to open transactions

YueHaibing <yuehaibing@huawei.com>
    xen/pvcalls: Remove set but not used variable

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix build errors by exporting paddr_to_nid()

Thomas Richter <tmricht@linux.ibm.com>
    perf record: Fix s390 missing module symbol and warning for non-root users

Namhyung Kim <namhyung@kernel.org>
    perf namespace: Protect reading thread's namespace

Shawn Landden <shawn@git.icu>
    perf data: Fix 'strncat may truncate' build failure with recent gcc

Sahitya Tummala <stummala@codeaurora.org>
    configfs: Fix use-after-free when accessing sd->s_dentry

Bard Liao <yung-chuan.liao@linux.intel.com>
    ALSA: hda - Force polling mode on CNL for fixing codec communication

Yingjoe Chen <yingjoe.chen@mediatek.com>
    i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix LRO with FCS error

Igor Russkikh <Igor.Russkikh@aquantia.com>
    net: aquantia: tx clean budget logic error

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: lock MMU while dumping core

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI/PCI: PM: Add missing wakeup.flags.valid checks

Kees Cook <keescook@chromium.org>
    net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: update rx tail pointer register to fix rx dma hang issue.

Randy Dunlap <rdunlap@infradead.org>
    gpio: fix gpio-adp5588 build errors

Peter Zijlstra <peterz@infradead.org>
    perf/ring-buffer: Always use {READ,WRITE}_ONCE() for rb->user_page data

Peter Zijlstra <peterz@infradead.org>
    perf/ring_buffer: Add ordering to rb->nest increment

Yabin Cui <yabinc@google.com>
    perf/ring_buffer: Fix exposing a temporarily decreased data_head

Frank van der Linden <fllinden@amazon.com>
    x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Dan Carpenter <dan.carpenter@oracle.com>
    mISDN: make sure device name is NUL terminated

Jia-Ju Bai <baijiaju1990@gmail.com>
    usb: xhci: Fix a potential null pointer dereference in xhci_debugfs_create_endpoint()

Anju T Sudhakar <anju@linux.vnet.ibm.com>
    powerpc/powernv: Return for invalid IMC domain

Tony Lindgren <tony@atomide.com>
    clk: ti: clkctrl: Fix clkdm_clk handling

Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
    selftests: netfilter: missing error check when setting up veth interface

YueHaibing <yuehaibing@huawei.com>
    ipvs: Fix use-after-free in ip_vs_in

Jagdish Motwani <jagdish.motwani@sophos.com>
    netfilter: nf_queue: fix reinject verdict handling

Stephane Eranian <eranian@google.com>
    perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: vc04_services: Fix a couple error codes

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: prs: Use the correct helpers when removing all VID filters

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: prs: Fix parser range for VID filtering

Alaa Hleihel <alaa@mellanox.com>
    net/mlx5: Avoid reloading already removed devices

Stephen Barber <smbarber@chromium.org>
    vsock/virtio: set SOCK_DONE on peer shutdown

Xin Long <lucien.xin@gmail.com>
    tipc: purge deferredq list for each grp member in tipc_group_delete

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    sunhv: Fix device naming inconsistency between sunhv_console and sunhv_reg

Neil Horman <nhorman@tuxdriver.com>
    sctp: Free cookie before we memdup a new one

Young Xiao <92siuyang@gmail.com>
    nfc: Ensure presence of required attributes in the deactivate_target handler

Taehee Yoo <ap420073@gmail.com>
    net: openvswitch: do not free vport if register_netdevice() is failed.

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Fix up VLAN filtering

Eric Dumazet <edumazet@google.com>
    neigh: fix use-after-free read in pneigh_get_next

Jeremy Sowden <jeremy@azazel.net>
    lapb: fixed leak of control-blocks.

Eric Dumazet <edumazet@google.com>
    ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Set probe mode to sync

Ivan Vecera <ivecera@redhat.com>
    be2net: Fix number of Rx queues used for flow hashing

Eric Dumazet <edumazet@google.com>
    ax25: fix inconsistent lock state in ax25_destroy_timer


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/include/asm/syscall.h                   |  2 +-
 arch/arm64/include/asm/syscall_wrapper.h           | 18 +++----
 arch/arm64/kernel/sys.c                            | 14 +++--
 arch/arm64/kernel/sys32.c                          |  7 +--
 arch/ia64/mm/numa.c                                |  1 +
 arch/powerpc/include/asm/kvm_host.h                |  1 +
 arch/powerpc/kvm/book3s.c                          |  1 +
 arch/powerpc/kvm/book3s_hv.c                       |  9 +---
 arch/powerpc/kvm/book3s_rtas.c                     | 14 +++--
 arch/powerpc/platforms/powernv/opal-imc.c          |  4 ++
 arch/x86/events/intel/ds.c                         | 28 +++++-----
 arch/x86/kernel/cpu/amd.c                          |  7 ++-
 drivers/acpi/device_pm.c                           |  4 +-
 drivers/clk/ti/clkctrl.c                           |  8 +--
 drivers/gpio/Kconfig                               |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |  5 ++
 drivers/i2c/i2c-dev.c                              |  1 +
 drivers/isdn/mISDN/socket.c                        |  5 +-
 drivers/net/dsa/rtl8366.c                          |  7 +--
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  7 +--
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  | 61 ++++++++++++----------
 drivers/net/ethernet/dec/tulip/de4x5.c             |  1 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     | 23 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 25 ++++++++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 ++
 drivers/net/ethernet/renesas/sh_eth.c              |  4 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  1 +
 drivers/net/hyperv/netvsc_drv.c                    |  2 +-
 drivers/net/phy/dp83867.c                          |  4 +-
 drivers/net/phy/phylink.c                          | 10 ++--
 drivers/pci/pci-acpi.c                             |  3 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |  4 ++
 drivers/scsi/device_handler/scsi_dh_alua.c         |  6 +--
 drivers/scsi/libsas/sas_expander.c                 |  2 +
 drivers/scsi/smartpqi/smartpqi_init.c              |  2 +-
 .../vc04_services/bcm2835-camera/controls.c        |  4 +-
 drivers/tty/serial/sunhv.c                         |  2 +-
 drivers/usb/host/xhci-debugfs.c                    |  3 ++
 drivers/xen/pvcalls-front.c                        |  4 --
 drivers/xen/xenbus/xenbus.h                        |  3 ++
 drivers/xen/xenbus/xenbus_dev_frontend.c           | 18 +++++++
 drivers/xen/xenbus/xenbus_xs.c                     |  7 ++-
 fs/configfs/dir.c                                  | 14 +++--
 fs/inode.c                                         |  9 +++-
 fs/ocfs2/filecheck.c                               |  1 +
 include/linux/sched/mm.h                           |  4 ++
 kernel/events/ring_buffer.c                        | 39 +++++++++++---
 mm/khugepaged.c                                    |  3 ++
 net/ax25/ax25_route.c                              |  2 +
 net/core/neighbour.c                               |  7 +++
 net/ipv6/ip6_flowlabel.c                           |  7 +--
 net/lapb/lapb_iface.c                              |  1 +
 net/netfilter/ipvs/ip_vs_core.c                    |  2 +-
 net/netfilter/nf_queue.c                           |  1 +
 net/nfc/netlink.c                                  |  3 +-
 net/openvswitch/vport-internal_dev.c               | 18 ++++---
 net/sctp/sm_make_chunk.c                           |  8 +++
 net/tipc/group.c                                   |  1 +
 net/vmw_vsock/virtio_transport_common.c            |  4 +-
 sound/pci/hda/hda_intel.c                          |  5 +-
 tools/perf/arch/s390/util/machine.c                |  9 ++--
 tools/perf/util/data-convert-bt.c                  |  2 +-
 tools/perf/util/thread.c                           | 15 +++++-
 tools/testing/selftests/netfilter/nft_nat.sh       |  6 ++-
 66 files changed, 332 insertions(+), 172 deletions(-)


