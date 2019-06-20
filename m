Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729CE4D7A0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbfFTSNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfFTSNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9892205F4;
        Thu, 20 Jun 2019 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054414;
        bh=0oHAs9d5sYYsFNgGneAgcb8AjcEr9/cnWz15J9fKqWM=;
        h=From:To:Cc:Subject:Date:From;
        b=2jpdnjZQBjGYhsCEKzg+ccUeMfa/iDm6qro7dWmp+t2OoTOcruVTrcWZ0NSVdi22O
         4C+2h5ZujuwgVNNKB5C6StcGpoXjWW2oACyG8Q5YTfRMsnYVRIUGjtN13Y1gu/1tjt
         7azEOqpL5vRwzhAyd6QP9327JiYYiLLzTBlF9Lm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 00/98] 5.1.13-stable review
Date:   Thu, 20 Jun 2019 19:56:27 +0200
Message-Id: <20190620174349.443386789@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.13-rc1
X-KernelTest-Deadline: 2019-06-22T17:43+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.13 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.13-rc1

Andrea Arcangeli <aarcange@redhat.com>
    coredump: fix race condition between collapse_huge_page() and core dumping

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix queue mapping when queue count is limited

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible null deref on a timed out io queue connect

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: rename function to have nvme_tcp prefix

Yang Shi <yang.shi@linux.alibaba.com>
    mm: mmu_gather: remove __tlb_reset_range() for force flush

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

Max Uvarov <muvarov@gmail.com>
    net: phy: dp83867: increase SGMII autoneg timer duration

Max Uvarov <muvarov@gmail.com>
    net: phy: dp83867: fix speed 10 in sgmii mode

Russell King <rmk+kernel@armlinux.org.uk>
    net: phylink: ensure consistent phy interface mode

Jes Sorensen <jsorensen@fb.com>
    blk-mq: Fix memory leak in error handling

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs

Sami Tolvanen <samitolvanen@google.com>
    arm64: use the correct function type for __arm64_sys_ni_syscall

Sami Tolvanen <samitolvanen@google.com>
    arm64: use the correct function type in SYSCALL_DEFINE0

Sami Tolvanen <samitolvanen@google.com>
    arm64: fix syscall_fn_t type

Geert Uytterhoeven <geert@linux-m68k.org>
    ALSA: fireface: Use ULL suffixes for 64-bit constants

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Use new mutex to synchronize MMU setup

Gen Zhang <blackgod016574@gmail.com>
    dfs_cache: fix a wrong use of kfree in flush_cache_ent()

Ross Lagerwall <ross.lagerwall@citrix.com>
    xenbus: Avoid deadlock during suspend due to open transactions

YueHaibing <yuehaibing@huawei.com>
    xen/pvcalls: Remove set but not used variable

Madalin Bucur <madalin.bucur@nxp.com>
    dpaa_eth: use only online CPU portals

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix build errors by exporting paddr_to_nid()

Thomas Richter <tmricht@linux.ibm.com>
    perf record: Fix s390 missing module symbol and warning for non-root users

Namhyung Kim <namhyung@kernel.org>
    perf namespace: Protect reading thread's namespace

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix wrong dispatching for control domain CPRBs

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

Ioana Radulescu <ruxandra.radulescu@nxp.com>
    dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate

Ioana Radulescu <ruxandra.radulescu@nxp.com>
    dpaa2-eth: Fix potential spectre issue

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: Fix __io_uring_register() false success

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio read/write fail

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: fix csr_clk can't be zero issue

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

Phil Sutter <phil@nwl.cc>
    netfilter: nft_fib: Fix existence check support

Jagdish Motwani <jagdish.motwani@sophos.com>
    netfilter: nf_queue: fix reinject verdict handling

Stephane Eranian <eranian@google.com>
    perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix oops during rule dump

Kai-Heng Feng <kai.heng.feng@canonical.com>
    pinctrl: intel: Clear interrupt status in mask/unmask callback

Dan Carpenter <dan.carpenter@oracle.com>
    staging: wilc1000: Fix some double unlock bugs in wilc_wlan_cleanup()

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: vc04_services: Fix a couple error codes

Chengguang Xu <cgxu519@gmail.com>
    staging: erofs: set sb->s_root to NULL when failing from __getname()

Steve Moskovchenko <stevemo@skydio.com>
    iio: imu: mpu6050: Fix FIFO layout for ICM20602

Alaa Hleihel <alaa@mellanox.com>
    net/mlx5e: Avoid detaching non-existing netdev under switchdev mode

Willem de Bruijn <willemb@google.com>
    net: correct udp zerocopy refcnt also when zerocopy only on append

Eli Britstein <elibr@mellanox.com>
    net/mlx5e: Support tagged tunnel over bond

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2

Raed Salem <raeds@mellanox.com>
    net/mlx5e: Fix source port matching in fdb peer flow rule

Jiri Pirko <jiri@mellanox.com>
    mlxsw: spectrum_flower: Fix TOS matching

Chris Mi <chrism@mellanox.com>
    net/mlx5e: Add ndo_set_feature for uplink representor

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead

Edward Srouji <edwards@mellanox.com>
    net/mlx5: Update pci error handler entries and command translation

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: ethtool: Allow matching on vlan DEI bit

Robert Hancock <hancock@sedsystems.ca>
    net: dsa: microchip: Don't try to read stats for unused ports

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: prs: Use the correct helpers when removing all VID filters

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: prs: Fix parser range for VID filtering

Stefano Brivio <sbrivio@redhat.com>
    geneve: Don't assume linear buffers in error handler

Stefano Brivio <sbrivio@redhat.com>
    vxlan: Don't assume linear buffers in error handler

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

John Fastabend <john.fastabend@gmail.com>
    net: tls, correctly account for copied bytes with multiple sk_msgs

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

Florian Westphal <fw@strlen.de>
    netfilter: nat: fix udp checksum corruption


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/include/asm/syscall.h                   |  2 +-
 arch/arm64/include/asm/syscall_wrapper.h           | 18 +++---
 arch/arm64/kernel/sys.c                            | 14 +++--
 arch/arm64/kernel/sys32.c                          |  7 +--
 arch/ia64/mm/numa.c                                |  1 +
 arch/powerpc/include/asm/kvm_host.h                |  2 +
 arch/powerpc/kvm/book3s.c                          |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c                | 36 +++++------
 arch/powerpc/kvm/book3s_hv.c                       | 40 +++++++-----
 arch/powerpc/kvm/book3s_rtas.c                     | 14 ++---
 arch/powerpc/platforms/powernv/opal-imc.c          |  4 ++
 arch/s390/include/asm/ap.h                         |  4 +-
 arch/x86/events/intel/ds.c                         | 28 ++++-----
 arch/x86/kernel/cpu/amd.c                          |  7 ++-
 block/blk-mq.c                                     |  5 +-
 drivers/acpi/device_pm.c                           |  4 +-
 drivers/clk/ti/clkctrl.c                           |  8 +--
 drivers/gpio/Kconfig                               |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |  5 ++
 drivers/i2c/i2c-dev.c                              |  1 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         | 46 ++++++++++++--
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          | 20 +++++-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |  3 +
 drivers/isdn/mISDN/socket.c                        |  5 +-
 drivers/net/dsa/microchip/ksz_common.c             |  3 +
 drivers/net/dsa/rtl8366.c                          |  7 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  7 ++-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  | 61 +++++++++---------
 drivers/net/ethernet/dec/tulip/de4x5.c             |  1 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  9 ++-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  3 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     | 23 +++----
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  8 +++
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 25 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 11 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  8 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  3 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 73 +++++++++++++++++++++-
 drivers/net/ethernet/renesas/sh_eth.c              |  4 ++
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |  2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  7 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  5 +-
 drivers/net/geneve.c                               |  2 +-
 drivers/net/hyperv/netvsc_drv.c                    |  2 +-
 drivers/net/phy/dp83867.c                          | 39 +++++++++++-
 drivers/net/phy/phylink.c                          | 10 ++-
 drivers/net/vxlan.c                                |  2 +-
 drivers/nvme/host/tcp.c                            | 70 ++++++++++++++++-----
 drivers/pci/pci-acpi.c                             |  3 +-
 drivers/pinctrl/intel/pinctrl-intel.c              | 37 ++---------
 drivers/s390/crypto/ap_bus.c                       | 26 ++++++--
 drivers/s390/crypto/ap_bus.h                       |  3 +
 drivers/s390/crypto/zcrypt_api.c                   | 17 ++++-
 drivers/scsi/cxgbi/libcxgbi.c                      |  4 ++
 drivers/scsi/device_handler/scsi_dh_alua.c         |  6 +-
 drivers/scsi/libsas/sas_expander.c                 |  2 +
 drivers/scsi/smartpqi/smartpqi_init.c              |  2 +-
 drivers/staging/erofs/super.c                      |  1 +
 .../vc04_services/bcm2835-camera/controls.c        |  4 +-
 drivers/staging/wilc1000/wilc_wlan.c               |  8 ++-
 drivers/tty/serial/sunhv.c                         |  2 +-
 drivers/usb/host/xhci-debugfs.c                    |  3 +
 drivers/xen/pvcalls-front.c                        |  4 --
 drivers/xen/xenbus/xenbus.h                        |  3 +
 drivers/xen/xenbus/xenbus_dev_frontend.c           | 18 ++++++
 drivers/xen/xenbus/xenbus_xs.c                     |  7 ++-
 fs/cifs/dfs_cache.c                                |  4 +-
 fs/configfs/dir.c                                  | 14 ++---
 fs/io_uring.c                                      |  2 +-
 fs/ocfs2/filecheck.c                               |  1 +
 include/linux/sched/mm.h                           |  4 ++
 include/net/flow_dissector.h                       |  1 +
 include/net/netfilter/nft_fib.h                    |  2 +-
 kernel/events/ring_buffer.c                        | 39 +++++++++---
 mm/khugepaged.c                                    |  3 +
 mm/mmu_gather.c                                    | 24 +++++--
 net/ax25/ax25_route.c                              |  2 +
 net/core/ethtool.c                                 |  5 ++
 net/core/neighbour.c                               |  7 +++
 net/ipv4/ip_output.c                               |  2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  | 23 +------
 net/ipv6/ip6_flowlabel.c                           |  7 ++-
 net/ipv6/ip6_output.c                              |  2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  | 16 +----
 net/lapb/lapb_iface.c                              |  1 +
 net/netfilter/ipvs/ip_vs_core.c                    |  2 +-
 net/netfilter/nf_nat_helper.c                      |  2 +-
 net/netfilter/nf_queue.c                           |  1 +
 net/netfilter/nf_tables_api.c                      | 20 +++---
 net/netfilter/nft_fib.c                            |  6 +-
 net/nfc/netlink.c                                  |  3 +-
 net/openvswitch/vport-internal_dev.c               | 18 ++++--
 net/sctp/sm_make_chunk.c                           |  8 +++
 net/tipc/group.c                                   |  1 +
 net/tls/tls_sw.c                                   |  1 -
 net/vmw_vsock/virtio_transport_common.c            |  4 +-
 sound/firewire/fireface/ff-protocol-latter.c       | 10 +--
 sound/pci/hda/hda_intel.c                          |  5 +-
 tools/perf/arch/s390/util/machine.c                |  9 ++-
 tools/perf/util/data-convert-bt.c                  |  2 +-
 tools/perf/util/thread.c                           | 15 ++++-
 tools/testing/selftests/netfilter/nft_nat.sh       |  6 +-
 111 files changed, 760 insertions(+), 360 deletions(-)


