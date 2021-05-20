Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37E138B31E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhETPZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232338AbhETPYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE4F961355;
        Thu, 20 May 2021 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621524211;
        bh=QrE46utVIX7kzC/tkMpgx+FTSdomngoTTyDd+BOYU7g=;
        h=From:To:Cc:Subject:Date:From;
        b=C8iGc5hAP993ely3dVWsrZP7wqRtjAJWTIvrnsxIsWB2uHLAWelEeF4/tGJnaWadD
         RFqx7gmPsTtGSswyIz4HhGf7wFk/vxEdhvW1VzA0Zy6BQbjdJCm0MU3eJk04HCUlhr
         p+lozBXPFslZp/lrm2QD87MJEuoAq03TnkzYYeV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 00/43] 5.12.6-rc2 review
Date:   Thu, 20 May 2021 17:23:29 +0200
Message-Id: <20210520152254.218537944@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.6-rc2
X-KernelTest-Deadline: 2021-05-22T15:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.6 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.6-rc2

Eric Dumazet <edumazet@google.com>
    ipv6: remove extra dev_hold() for fallback tunnels

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    ip6_gre: proper dev_{hold|put} in ndo_[un]init methods

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: Do not enable RX FIFO overflow interrupts

Zqiang <qiang.zhang@windriver.com>
    lib: stackdepot: turn depot_lock spinlock to raw_spinlock

yangerkun <yangerkun@huawei.com>
    block: reexpand iov_iter after read/write

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

Íñigo Huguet <ihuguet@redhat.com>
    net:CXGB4: fix leak if sk_buff is not used

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Fix two cursor duplication when using overlay

Keith Busch <kbusch@kernel.org>
    nvmet: remove unsupported command noise

Phillip Potter <phil@philpotter.co.uk>
    net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info

Zhang Zhengming <zhangzhengming@huawei.com>
    bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit

Darren Powell <darren.powell@amd.com>
    amdgpu/pm: Prevent force of DCEFCLK on NAVI10 and SIENNA_CICHLID

Bodo Stroesser <bostroesser@gmail.com>
    scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Jeff Layton <jlayton@kernel.org>
    ceph: don't allow access to MDS-private inodes

Jeff Layton <jlayton@kernel.org>
    ceph: don't clobber i_snap_caps on non-I_NEW inode

Jeff Layton <jlayton@kernel.org>
    ceph: fix fscache invalidation

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix illegal memory access on Abort IOCBs

Nathan Chancellor <nathan@kernel.org>
    riscv: Workaround mcount name prior to clang-13

Nathan Chancellor <nathan@kernel.org>
    scripts/recordmcount.pl: Fix RISC-V regex for clang

Nathan Chancellor <nathan@kernel.org>
    riscv: Use $(LD) instead of $(CC) to link vDSO

Prashant Malani <pmalani@chromium.org>
    platform/chrome: cros_ec_typec: Add DP mode check

Manivannan Sadhasivam <mani@kernel.org>
    ARM: 9075/1: kernel: Fix interrupted SMC calls

Johannes Berg <johannes.berg@intel.com>
    um: Disable CONFIG_GCOV with MODULES

Johannes Berg <johannes.berg@intel.com>
    um: Mark all kernel symbols as local

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Don't leak send_ctxt on Send errors

Yi Chen <chenyi77@huawei.com>
    f2fs: fix to avoid NULL pointer dereference

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid

Hans de Goede <hdegoede@redhat.com>
    Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state

Hans de Goede <hdegoede@redhat.com>
    Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices

Dinghao Liu <dinghao.liu@zju.edu.cn>
    PCI: tegra: Fix runtime PM imbalance in pex_ep_event_pex_rst_deassert()

Feilong Lin <linfeilong@huawei.com>
    ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix fscache invalidation in nfs_set_cache_invalid()

louis.wang <liang26812@gmail.com>
    ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    dmaengine: dw-edma: Fix crash on loading/unloading driver

Arnd Bergmann <arnd@arndb.de>
    PCI: thunder: Fix compile testing

Arnd Bergmann <arnd@arndb.de>
    usb: sl811-hcd: improve misleading indentation

Arnd Bergmann <arnd@arndb.de>
    kgdb: fix gcc-11 warning on indentation

Arnd Bergmann <arnd@arndb.de>
    airo: work around stack usage warning

Linus Torvalds <torvalds@linux-foundation.org>
    drm/i915/display: fix compiler warning about array overrun

Arnd Bergmann <arnd@arndb.de>
    x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kernel/asm-offsets.c                      |   3 +
 arch/arm/kernel/smccc-call.S                       |  11 +-
 arch/arm/kernel/suspend.c                          |  19 +++-
 arch/riscv/include/asm/ftrace.h                    |  14 ++-
 arch/riscv/kernel/mcount.S                         |  10 +-
 arch/riscv/kernel/vdso/Makefile                    |  12 +--
 arch/um/Kconfig.debug                              |   1 +
 arch/um/kernel/Makefile                            |   1 -
 arch/um/kernel/dyn.lds.S                           |   6 ++
 arch/um/kernel/gmon_syms.c                         |  16 ---
 arch/um/kernel/uml.lds.S                           |   6 ++
 arch/x86/lib/msr-smp.c                             |   4 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  11 +-
 drivers/gpio/gpiolib-acpi.c                        |  14 +++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  51 +++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |   5 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   4 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |  13 ++-
 drivers/input/touchscreen/elants_i2c.c             |  44 +++++++-
 drivers/input/touchscreen/silead.c                 |  44 +++++++-
 drivers/misc/kgdbts.c                              |  26 ++---
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  16 +--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  14 +--
 drivers/net/wireless/cisco/airo.c                  | 117 ++++++++++++---------
 drivers/nvme/target/admin-cmd.c                    |   6 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   2 +-
 drivers/pci/controller/pci-thunder-ecam.c          |   2 +-
 drivers/pci/controller/pci-thunder-pem.c           |  13 +--
 drivers/pci/hotplug/acpiphp_glue.c                 |   1 +
 drivers/pci/pci.h                                  |   6 ++
 drivers/platform/chrome/cros_ec_typec.c            |   5 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  11 +-
 drivers/target/target_core_user.c                  |   4 +-
 drivers/usb/host/sl811-hcd.c                       |   9 +-
 fs/block_dev.c                                     |  20 +++-
 fs/ceph/caps.c                                     |   1 +
 fs/ceph/export.c                                   |   8 ++
 fs/ceph/inode.c                                    |  13 ++-
 fs/ceph/mds_client.c                               |   7 ++
 fs/ceph/super.h                                    |  24 +++++
 fs/f2fs/segment.c                                  |   5 +-
 fs/nfs/inode.c                                     |   7 +-
 lib/stackdepot.c                                   |   6 +-
 net/bridge/br_netlink.c                            |   5 +-
 net/hsr/hsr_forward.c                              |   4 +
 net/ipv6/ip6_gre.c                                 |   7 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/ipv6/ip6_vti.c                                 |   1 -
 net/ipv6/sit.c                                     |   5 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   8 +-
 scripts/recordmcount.pl                            |   2 +-
 sound/pci/hda/hda_generic.c                        |  16 ++-
 54 files changed, 473 insertions(+), 201 deletions(-)


