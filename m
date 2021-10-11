Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1C742937B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhJKPgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 11:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239180AbhJKPgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 11:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C57FE60E52;
        Mon, 11 Oct 2021 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633966487;
        bh=wn8zZVlGaJORSwrMHkgO+AMa97wo3gTUnmqqaewD8qE=;
        h=From:To:Cc:Subject:Date:From;
        b=msS60elVgZl/xxX2i9nx7xJfWqMO2IuQ5WFVpFNuL1+vymrNvTLbSsFl8bEOteRZ9
         t09/JLx5Xb4M6tRyAHCVICOrXX9n7DQlygJ0dRaf2Uniu/YtJ6cDh23BfwUSxt++H0
         WT4B66xWyEgiZ+wocKoVlUzbjMZS2+OmsAFxZ9Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/82] 5.10.73-rc2 review
Date:   Mon, 11 Oct 2021 17:34:39 +0200
Message-Id: <20211011153306.939942789@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.73-rc2
X-KernelTest-Deadline: 2021-10-13T15:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.73 release.
There are 82 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Oct 2021 15:32:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.73-rc2

Thomas Gleixner <tglx@linutronix.de>
    x86/hpet: Use another crystalball to evaluate HPET usability

Vegard Nossum <vegard.nossum@oracle.com>
    x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/entry: Correct reference to intended CONFIG_64_BIT

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/Kconfig: Correct reference to MWINCHIP3D

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    pseries/eeh: Fix the kdump kernel crash during eeh_pseries_init

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: fix program check interrupt emergency stack path

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_SUB when imm == 0x80000000

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_MOD when imm == 1

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Include clone3() on rv32

Tiezhu Yang <yangtiezhu@loongson.cn>
    bpf, s390: Fix potential memory leak about jit_data

Tong Tiangen <tongtiangen@huawei.com>
    riscv/vdso: make arch_setup_additional_pages wait for mmap_sem for write killable

Kewei Xu <kewei.xu@mediatek.com>
    i2c: mediatek: Add OFFSET_EXT_CONF setting back

Jamie Iles <quic_jiles@quicinc.com>
    i2c: acpi: fix resource leak in reconfiguration device addition

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Report the correct most efficient DMA mask for PCI devices

Mike Manning <mvrmanning@gmail.com>
    net: prefer socket bound to interface when not in VRF

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix freeing of uninitialized misc IRQ vector

Jiri Benc <jbenc@redhat.com>
    i40e: fix endless loop under rtnl

Eric Dumazet <edumazet@google.com>
    gve: report 64bit tx_bytes counter from gve_handle_report_stats()

Eric Dumazet <edumazet@google.com>
    gve: fix gve_get_stats()

Eric Dumazet <edumazet@google.com>
    rtnetlink: fix if_nlmsg_stats_size() under estimation

Tao Liu <xliutaox@google.com>
    gve: Avoid freeing NULL pointer

Catherine Sullivan <csully@google.com>
    gve: Correct available tx qpl check

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/debugfs: fix file release memory leak

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/kms/nv50-: fix file release memory leak

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: avoid a use-after-free when BO init fails

Mark Brown <broonie@kernel.org>
    video: fbdev: gbefb: Only instantiate device when built for IP32

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: dw-hdmi: Fix HDMI PHY clock setup

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893

John Garry <john.garry@huawei.com>
    perf jevents: Tidy error handling

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->bound

Sean Anderson <sean.anderson@seco.com>
    net: sfp: Fix typo in state machine debug string

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: properly cancel timer from taprio_destroy()

Eric Dumazet <edumazet@google.com>
    net: bridge: fix under estimation in br_get_linkxstats_size()

Eric Dumazet <edumazet@google.com>
    net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()

Oleksij Rempel <linux@rempel-privat.de>
    ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: drm/bridge: ti-sn65dsi86: Fix reg value

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: add missing CAN nodes

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ptp_pch: Load module automatically if ID matches

Pali Rohár <pali@kernel.org>
    powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Eric Dumazet <edumazet@google.com>
    net_sched: fix NULL deref in fifo_set_limit()

Pavel Skripkin <paskripkin@gmail.com>
    phy: mdio: fix memory leak

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: E-Switch, Fix double allocation of acl flow counter

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPSEC RX, enable checksum complete

Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
    bpf: Fix integer overflow in prealloc_elems_and_freelist()

Tony Lindgren <tony@atomide.com>
    soc: ti: omap-prm: Fix external abort for am335x pruss

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf, arm: Fix register clobbering in div/mod implementation

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Randy Dunlap <rdunlap@infradead.org>
    xtensa: use CONFIG_USE_OF instead of CONFIG_OF

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding

Arnd Bergmann <arnd@arndb.de>
    ath5k: fix building with LEDS=m

Long Li <longli@microsoft.com>
    PCI: hv: Fix sleep while in non-sleep context when removing child devices from the bus

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-pico: Fix Ethernet support

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Fix USB host power regulator polarity on M53Menlo

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Add missing pinctrl-names for panel on M53Menlo

Shawn Guo <shawn.guo@linaro.org>
    soc: qcom: mdt_loader: Drop PT_LOAD check on hash segment

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: do not panic if ram controllers are not enabled

Marijn Suijten <marijn.suijten@somainline.org>
    ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference

Antonio Martorana <amartora@codeaurora.org>
    soc: qcom: socinfo: Fixed argument passed to platform_set_data()

Nathan Chancellor <nathan@kernel.org>
    bus: ti-sysc: Add break in switch statement in sysc_init_soc()

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Flush current cpu icache before other cpus

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: apq8064: use compatible which contains chipid

Michal Vokáč <michal.vokac@ysoft.com>
    ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap3430-sdp: Fix NAND device node

Juergen Gross <jgross@suse.com>
    xen/balloon: fix cancelled balloon action

J. Bruce Fields <bfields@redhat.com>
    SUNRPC: fix sign error causing rpcsec_gss drops

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Patrick Ho <Patrick.Ho@netapp.com>
    nfsd: fix error handling of register_pernet_subsys() in init_nfsd()

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix IOCB_DIRECT if underlying fs doesn't support direct IO

Zheng Liang <zhengliang6@huawei.com>
    ovl: fix missing negative dentry check in ovl_rename()

Claudiu Beznea <claudiu.beznea@microchip.com>
    mmc: sdhci-of-at91: replace while loop with read_poll_timeout

Claudiu Beznea <claudiu.beznea@microchip.com>
    mmc: sdhci-of-at91: wait for calibration done before proceed

Neil Armstrong <narmstrong@baylibre.com>
    mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk

Jan Beulich <jbeulich@suse.com>
    xen/privcmd: fix error handling in mmap-resource processing

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/tu102-: delay enabling cursor until after assign_windows

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: handle SRC_STARTUP state if cc changes

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix break reporting

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy tty buffer accesses

Fabio Estevam <festevam@gmail.com>
    usb: chipidea: ci_hdrc_imx: Also search for 'phys' phandle

Ben Hutchings <ben@decadent.org.uk>
    Partially revert "usb: Kconfig: using select for USB_COMMON dependency"


-------------

Diffstat:

 .../bindings/display/bridge/ti,sn65dsi86.yaml      |  2 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx53-m53menlo.dts               |  4 +-
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi         |  5 ++
 arch/arm/boot/dts/imx6qdl-pico.dtsi                | 11 +++
 arch/arm/boot/dts/omap3430-sdp.dts                 |  2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |  7 +-
 arch/arm/mach-at91/pm.c                            | 58 ++++++++++---
 arch/arm/mach-imx/pm-imx6.c                        |  2 +
 arch/arm/mach-omap2/omap_hwmod.c                   |  2 +
 arch/arm/net/bpf_jit_32.c                          | 19 +++++
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     | 18 ++++
 arch/arm64/boot/dts/qcom/pm8150.dtsi               |  2 +-
 arch/powerpc/boot/dts/fsl/t1023rdb.dts             |  2 +-
 arch/powerpc/kernel/dma-iommu.c                    |  9 ++
 arch/powerpc/kernel/exceptions-64s.S               | 17 ++--
 arch/powerpc/net/bpf_jit_comp64.c                  | 37 ++++++---
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  4 +
 arch/riscv/include/uapi/asm/unistd.h               |  3 +-
 arch/riscv/kernel/vdso.c                           |  4 +-
 arch/riscv/mm/cacheflush.c                         |  2 +
 arch/s390/net/bpf_jit_comp.c                       |  2 +-
 arch/x86/Kconfig                                   |  2 +-
 arch/x86/include/asm/entry-common.h                |  2 +-
 arch/x86/kernel/cpu/common.c                       |  1 +
 arch/x86/kernel/early-quirks.c                     |  6 --
 arch/x86/kernel/hpet.c                             | 81 ++++++++++++++++++
 arch/x86/kernel/sev-es-shared.c                    |  2 +
 arch/x86/platform/olpc/olpc.c                      |  2 +-
 arch/xtensa/include/asm/kmem_layout.h              |  2 +-
 arch/xtensa/kernel/irq.c                           |  2 +-
 arch/xtensa/kernel/setup.c                         | 12 +--
 arch/xtensa/mm/mmu.c                               |  2 +-
 drivers/bus/ti-sysc.c                              |  4 +
 drivers/gpu/drm/nouveau/dispnv50/crc.c             |  1 +
 drivers/gpu/drm/nouveau/dispnv50/head.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |  1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  4 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |  7 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h              |  4 +-
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             | 97 ++++++++++++----------
 drivers/i2c/busses/i2c-mt65xx.c                    | 11 ++-
 drivers/i2c/i2c-core-acpi.c                        |  1 +
 drivers/mmc/host/meson-gx-mmc.c                    | 73 ++++++++++++----
 drivers/mmc/host/sdhci-of-at91.c                   | 22 ++---
 drivers/net/ethernet/google/gve/gve.h              |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c         | 45 ++++++----
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  7 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       | 12 ++-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  4 +-
 drivers/net/phy/mdio_bus.c                         |  7 ++
 drivers/net/phy/sfp.c                              |  2 +-
 drivers/net/wireless/ath/ath5k/Kconfig             |  4 +-
 drivers/net/wireless/ath/ath5k/led.c               | 10 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  2 +
 drivers/pci/controller/pci-hyperv.c                | 13 ++-
 drivers/ptp/ptp_pch.c                              |  1 +
 drivers/soc/qcom/mdt_loader.c                      |  2 +-
 drivers/soc/qcom/socinfo.c                         |  2 +-
 drivers/soc/ti/omap_prm.c                          | 27 +++---
 drivers/usb/chipidea/ci_hdrc_imx.c                 | 15 ++--
 drivers/usb/class/cdc-acm.c                        |  8 ++
 drivers/usb/common/Kconfig                         |  3 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  1 +
 drivers/video/fbdev/gbefb.c                        |  2 +-
 drivers/xen/balloon.c                              | 21 +++--
 drivers/xen/privcmd.c                              |  7 +-
 fs/nfsd/nfs4xdr.c                                  | 19 +++--
 fs/nfsd/nfsctl.c                                   |  2 +-
 fs/overlayfs/dir.c                                 | 10 ++-
 fs/overlayfs/file.c                                | 15 +++-
 kernel/bpf/stackmap.c                              |  3 +-
 net/bridge/br_netlink.c                            |  3 +-
 net/core/rtnetlink.c                               |  2 +-
 net/ipv4/inet_hashtables.c                         |  4 +-
 net/ipv4/udp.c                                     |  3 +-
 net/ipv6/inet6_hashtables.c                        |  2 +-
 net/ipv6/udp.c                                     |  3 +-
 net/netlink/af_netlink.c                           | 14 +++-
 net/sched/sch_fifo.c                               |  3 +
 net/sched/sch_taprio.c                             |  4 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |  2 +-
 tools/perf/pmu-events/jevents.c                    | 83 ++++++++----------
 84 files changed, 646 insertions(+), 285 deletions(-)


