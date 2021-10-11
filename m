Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4A428EC6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhJKNvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237363AbhJKNvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B57D361054;
        Mon, 11 Oct 2021 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960143;
        bh=hq6L9blu5WH/fBhk/it/vXNPG3bdrM6nZZfonMBl4BU=;
        h=From:To:Cc:Subject:Date:From;
        b=kingAywxVsTSu1CkXKFkR/Z0yv1BQzwhNgAd2pJ28rxEmsTukpaPtghrXEnZk54AG
         nHYU+ToFwgf7ergWlKTyexx9fbejJ0bxteTE0kWNbL34CStdSdBno2M2h43ZDRFMMF
         cONIqT4ZYWM3gOEbqSq7YDKW42W9WvzC9P55M8js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/52] 5.4.153-rc1 review
Date:   Mon, 11 Oct 2021 15:45:29 +0200
Message-Id: <20211011134503.715740503@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.153-rc1
X-KernelTest-Deadline: 2021-10-13T13:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.153 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.153-rc1

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/Kconfig: Correct reference to MWINCHIP3D

Thomas Gleixner <tglx@linutronix.de>
    x86/hpet: Use another crystalball to evaluate HPET usability

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_MOD when imm == 1

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Include clone3() on rv32

Tiezhu Yang <yangtiezhu@loongson.cn>
    bpf, s390: Fix potential memory leak about jit_data

Jamie Iles <quic_jiles@quicinc.com>
    i2c: acpi: fix resource leak in reconfiguration device addition

Mike Manning <mvrmanning@gmail.com>
    net: prefer socket bound to interface when not in VRF

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix freeing of uninitialized misc IRQ vector

Jiri Benc <jbenc@redhat.com>
    i40e: fix endless loop under rtnl

Eric Dumazet <edumazet@google.com>
    gve: fix gve_get_stats()

Eric Dumazet <edumazet@google.com>
    rtnetlink: fix if_nlmsg_stats_size() under estimation

Catherine Sullivan <csully@google.com>
    gve: Correct available tx qpl check

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/debugfs: fix file release memory leak

Mark Brown <broonie@kernel.org>
    video: fbdev: gbefb: Only instantiate device when built for IP32

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->bound

Sean Anderson <sean.anderson@seco.com>
    net: sfp: Fix typo in state machine debug string

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: properly cancel timer from taprio_destroy()

Eric Dumazet <edumazet@google.com>
    net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()

Oleksij Rempel <linux@rempel-privat.de>
    ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: add missing CAN nodes

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: freescale: Fix SP805 clock-names

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ptp_pch: Load module automatically if ID matches

Pali Rohár <pali@kernel.org>
    powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Eric Dumazet <edumazet@google.com>
    net_sched: fix NULL deref in fifo_set_limit()

Pavel Skripkin <paskripkin@gmail.com>
    phy: mdio: fix memory leak

Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
    bpf: Fix integer overflow in prealloc_elems_and_freelist()

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf, arm: Fix register clobbering in div/mod implementation

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Randy Dunlap <rdunlap@infradead.org>
    xtensa: use CONFIG_USE_OF instead of CONFIG_OF

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: move XCHAL_KIO_* definitions to kmem_layout.h

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Fix USB host power regulator polarity on M53Menlo

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Add missing pinctrl-names for panel on M53Menlo

Shawn Guo <shawn.guo@linaro.org>
    soc: qcom: mdt_loader: Drop PT_LOAD check on hash segment

Marijn Suijten <marijn.suijten@somainline.org>
    ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference

Antonio Martorana <amartora@codeaurora.org>
    soc: qcom: socinfo: Fixed argument passed to platform_set_data()

Piotr Krysiuk <piotras@gmail.com>
    bpf, mips: Validate conditional branch offsets

Paul Burton <paulburton@kernel.org>
    MIPS: BPF: Restore MIPS32 cBPF JIT

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: apq8064: use compatible which contains chipid

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap3430-sdp: Fix NAND device node

Juergen Gross <jgross@suse.com>
    xen/balloon: fix cancelled balloon action

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Patrick Ho <Patrick.Ho@netapp.com>
    nfsd: fix error handling of register_pernet_subsys() in init_nfsd()

Zheng Liang <zhengliang6@huawei.com>
    ovl: fix missing negative dentry check in ovl_rename()

Neil Armstrong <narmstrong@baylibre.com>
    mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk

Jan Beulich <jbeulich@suse.com>
    xen/privcmd: fix error handling in mmap-resource processing

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: handle SRC_STARTUP state if cc changes

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix break reporting

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy tty buffer accesses

Ben Hutchings <ben@decadent.org.uk>
    Partially revert "usb: Kconfig: using select for USB_COMMON dependency"


-------------

Diffstat:

 Makefile                                       |    4 +-
 arch/arm/boot/dts/imx53-m53menlo.dts           |    4 +-
 arch/arm/boot/dts/omap3430-sdp.dts             |    2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi            |    7 +-
 arch/arm/mach-imx/pm-imx6.c                    |    2 +
 arch/arm/mach-omap2/omap_hwmod.c               |    2 +
 arch/arm/net/bpf_jit_32.c                      |   19 +
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi |   22 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi |   16 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi |   16 +-
 arch/arm64/boot/dts/qcom/pm8150.dtsi           |    2 +-
 arch/mips/Kconfig                              |    1 +
 arch/mips/net/Makefile                         |    1 +
 arch/mips/net/bpf_jit.c                        | 1299 ++++++++++++++++++++++++
 arch/mips/net/bpf_jit_asm.S                    |  285 ++++++
 arch/powerpc/boot/dts/fsl/t1023rdb.dts         |    2 +-
 arch/powerpc/net/bpf_jit_comp64.c              |   10 +-
 arch/riscv/include/uapi/asm/unistd.h           |    3 +-
 arch/s390/net/bpf_jit_comp.c                   |    2 +-
 arch/x86/Kconfig                               |    2 +-
 arch/x86/kernel/early-quirks.c                 |    6 -
 arch/x86/kernel/hpet.c                         |   81 ++
 arch/x86/platform/olpc/olpc.c                  |    2 +-
 arch/xtensa/include/asm/kmem_layout.h          |   29 +
 arch/xtensa/include/asm/vectors.h              |   42 +-
 arch/xtensa/kernel/irq.c                       |    2 +-
 arch/xtensa/kernel/setup.c                     |   12 +-
 arch/xtensa/mm/mmu.c                           |    2 +-
 drivers/bus/ti-sysc.c                          |    3 +
 drivers/gpu/drm/nouveau/nouveau_debugfs.c      |    1 +
 drivers/i2c/i2c-core-acpi.c                    |    1 +
 drivers/mmc/host/meson-gx-mmc.c                |   73 +-
 drivers/net/ethernet/google/gve/gve.h          |    2 +-
 drivers/net/ethernet/google/gve/gve_main.c     |   13 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    |    5 +-
 drivers/net/phy/mdio_bus.c                     |    7 +
 drivers/net/phy/sfp.c                          |    2 +-
 drivers/ptp/ptp_pch.c                          |    1 +
 drivers/soc/qcom/mdt_loader.c                  |    2 +-
 drivers/soc/qcom/socinfo.c                     |    2 +-
 drivers/usb/class/cdc-acm.c                    |    8 +
 drivers/usb/common/Kconfig                     |    3 +-
 drivers/usb/typec/tcpm/tcpm.c                  |    1 +
 drivers/video/fbdev/gbefb.c                    |    2 +-
 drivers/xen/balloon.c                          |   21 +-
 drivers/xen/privcmd.c                          |    7 +-
 fs/nfsd/nfs4xdr.c                              |   19 +-
 fs/nfsd/nfsctl.c                               |    2 +-
 fs/overlayfs/dir.c                             |   10 +-
 kernel/bpf/stackmap.c                          |    3 +-
 net/bridge/br_netlink.c                        |    2 +-
 net/core/rtnetlink.c                           |    2 +-
 net/ipv4/inet_hashtables.c                     |    4 +-
 net/ipv4/udp.c                                 |    3 +-
 net/ipv6/inet6_hashtables.c                    |    2 +-
 net/ipv6/udp.c                                 |    3 +-
 net/netlink/af_netlink.c                       |   14 +-
 net/sched/sch_fifo.c                           |    3 +
 net/sched/sch_taprio.c                         |    4 +
 59 files changed, 1955 insertions(+), 147 deletions(-)


