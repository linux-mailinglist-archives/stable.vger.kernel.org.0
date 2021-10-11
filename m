Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DE142900F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbhJKOEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238257AbhJKOC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87401611C7;
        Mon, 11 Oct 2021 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960676;
        bh=atKu7Ui7sHJSyoc9kjvKFKKMxIsSPlH9Ji0P3mviwA4=;
        h=From:To:Cc:Subject:Date:From;
        b=Z6z4oFYI44yF3DH+AdpWjEq9Oq5RgDktHr2Hspa55PMQYUg5gbuuljJqy75SQKSQd
         PjypuWx7ACF+N6n5Iu3Rr2TowbI/iWM8QfvUdWABWOM+F86QBZLGGii+LIsTMOLCUE
         p4hEjOvKHvQt/D+eyrysRTx3+jn8QpONResEFSiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/151] 5.14.12-rc1 review
Date:   Mon, 11 Oct 2021 15:44:32 +0200
Message-Id: <20211011134517.833565002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.12-rc1
X-KernelTest-Deadline: 2021-10-13T13:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.12 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.12-rc1

Andrew Lunn <andrew@lunn.ch>
    dsa: tag_dsa: Fix mask for trunked packets

Thomas Gleixner <tglx@linutronix.de>
    x86/hpet: Use another crystalball to evaluate HPET usability

Vegard Nossum <vegard.nossum@oracle.com>
    x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/entry: Correct reference to intended CONFIG_64_BIT

Borislav Petkov <bp@suse.de>
    x86/fpu: Restore the masking out of reserved MXCSR bits

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/Kconfig: Correct reference to MWINCHIP3D

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    pseries/eeh: Fix the kdump kernel crash during eeh_pseries_init

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix kuap_kernel_restore()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix unrecoverable MCE calling async handler from NMI

Nicholas Piggin <npiggin@gmail.com>
    powerpc/traps: do not enable irqs in _exception

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: fix program check interrupt emergency stack path

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf ppc32: Fix BPF_SUB when imm == 0x80000000

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf ppc32: Do not emit zero extend instruction for 64-bit BPF_END

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf ppc32: Fix JMP32_JSET_K

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf ppc32: Fix ALU32 BPF_ARSH operation

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_SUB when imm == 0x80000000

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_MOD when imm == 1

Joe Lawrence <joe.lawrence@redhat.com>
    objtool: Make .altinstructions section entry size consistent

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Remove reloc symbol type checks in get_alt_entry()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix iscsi_task use after free

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Include clone3() on rv32

Vadim Pasternak <vadimp@nvidia.com>
    i2c: mlxcpld: Modify register setting for 400KHz frequency

Vadim Pasternak <vadimp@nvidia.com>
    i2c: mlxcpld: Fix criteria for frequency setting

Tiezhu Yang <yangtiezhu@loongson.cn>
    bpf, s390: Fix potential memory leak about jit_data

Tong Tiangen <tongtiangen@huawei.com>
    riscv/vdso: make arch_setup_additional_pages wait for mmap_sem for write killable

Tong Tiangen <tongtiangen@huawei.com>
    riscv/vdso: Move vdso data page up front

Tong Tiangen <tongtiangen@huawei.com>
    riscv/vdso: Refactor asm/vdso.h

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Fix VDSO build for !MMU

Saleem Abdulrasool <abdulras@google.com>
    riscv: explicitly use symbol offsets for VDSO

Kewei Xu <kewei.xu@mediatek.com>
    i2c: mediatek: Add OFFSET_EXT_CONF setting back

Jamie Iles <quic_jiles@quicinc.com>
    i2c: acpi: fix resource leak in reconfiguration device addition

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Report the correct most efficient DMA mask for PCI devices

Mike Manning <mvrmanning@gmail.com>
    net: prefer socket bound to interface when not in VRF

Stefan Assmann <sassmann@kpanic.de>
    iavf: fix double unlock of crit_lock

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

Catherine Sullivan <csully@google.com>
    gve: Properly handle errors in gve_assign_qpl

Tao Liu <xliutaox@google.com>
    gve: Avoid freeing NULL pointer

Catherine Sullivan <csully@google.com>
    gve: Correct available tx qpl check

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: stmmac: trigger PCS EEE to turn off on link down

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: pcs: xpcs: fix incorrect steps on disable EEE

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/debugfs: fix file release memory leak

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/kms/nv50-: fix file release memory leak

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: avoid a use-after-free when BO init fails

Mark Brown <broonie@kernel.org>
    video: fbdev: gbefb: Only instantiate device when built for IP32

Christophe Branchereau <cbranchereau@gmail.com>
    drm/panel: abt-y030xx067a: yellow tint fix

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fifo/ga102: initialise chid on return from channel creation

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: dw-hdmi: Fix HDMI PHY clock setup

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893

Like Xu <likexu@tencent.com>
    perf jevents: Free the sys_event_tables list after processing entries

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: handle the case of pci_channel_io_frozen only in amdgpu_pci_resume

Lang Yu <lang.yu@amd.com>
    drm/amdkfd: fix a potential ttm->sg memory leak

Linus Walleij <linus.walleij@linaro.org>
    ARM: defconfig: gemini: Restore framebuffer

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->bound

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: pcs: xpcs: fix incorrect CL37 AN sequence

Sean Anderson <sean.anderson@seco.com>
    net: sfp: Fix typo in state machine debug string

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: properly cancel timer from taprio_destroy()

Eric Dumazet <edumazet@google.com>
    net: bridge: fix under estimation in br_get_linkxstats_size()

Eric Dumazet <edumazet@google.com>
    net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()

David Howells <dhowells@redhat.com>
    afs: Fix afs_launder_page() to set correct start file position

David Howells <dhowells@redhat.com>
    netfs: Fix READ/WRITE confusion when calling iov_iter_xarray()

Lukasz Majczak <lma@semihalf.com>
    drm/i915/bdb: Fix version check

Imre Deak <imre.deak@intel.com>
    drm/i915/tc: Fix TypeC port init/resume time sanitization

Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
    drm/i915/jsl: Add W/A 1409054076 for JSL

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/i915/audio: Use BIOS provided value for RKL HDA link

Oleksij Rempel <linux@rempel-privat.de>
    ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: drm/bridge: ti-sn65dsi86: Fix reg value

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: fix eSDHC2 node

Heiko Thiery <heiko.thiery@gmail.com>
    arm64: dts: imx8mm-kontron-n801x-som: do not allow to switch off buck2

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: imx8: change the spi-nor tx

Haibo Chen <haibo.chen@nxp.com>
    ARM: dts: imx: change the spi-nor tx

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ptp_pch: Load module automatically if ID matches

Pali Rohár <pali@kernel.org>
    powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: Revert "add support for buggy MT7621S core detection"

Punit Agrawal <punitagrawal@gmail.com>
    net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix VCAP filters remaining active after being deleted

Eric Dumazet <edumazet@google.com>
    net_sched: fix NULL deref in fifo_set_limit()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix memory leak in strset

Pavel Skripkin <paskripkin@gmail.com>
    phy: mdio: fix memory leak

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Fix segfault in light skeleton for objects without BTF

Lama Kayal <lkayal@nvidia.com>
    net/mlx5e: Fix the presented RQ index in PTP stats

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix setting number of EQs of SFs

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix length of irq_index in chars

Aya Levin <ayal@nvidia.com>
    net/mlx5: Avoid generating event after PPS out in Real time mode

Aya Levin <ayal@nvidia.com>
    net/mlx5: Force round second at 1PPS out start time

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: E-Switch, Fix double allocation of acl flow counter

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: Keep the value for maximum number of channels in-sync

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPSEC RX, enable checksum complete

Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
    bpf: Fix integer overflow in prealloc_elems_and_freelist()

Tony Lindgren <tony@atomide.com>
    soc: ti: omap-prm: Fix external abort for am335x pruss

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf, arm: Fix register clobbering in div/mod implementation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reverse order in rule replacement expansion

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: add position handle in event notification

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1

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

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Fix possible NULL dereference

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: do not panic if ram controllers are not enabled

Douglas Anderson <dianders@chromium.org>
    Revert "arm64: dts: qcom: sc7280: Fixup the cpufreq node"

Marijn Suijten <marijn.suijten@somainline.org>
    ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference

Antonio Martorana <amartora@codeaurora.org>
    soc: qcom: socinfo: Fixed argument passed to platform_set_data()

Nathan Chancellor <nathan@kernel.org>
    bus: ti-sysc: Add break in switch statement in sysc_init_soc()

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Flush current cpu icache before other cpus

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Fix task management completion

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

Arnd Bergmann <arnd@arndb.de>
    fbdev: simplefb: fix Kconfig dependencies

Claudiu Beznea <claudiu.beznea@microchip.com>
    mmc: sdhci-of-at91: replace while loop with read_poll_timeout

Claudiu Beznea <claudiu.beznea@microchip.com>
    mmc: sdhci-of-at91: wait for calibration done before proceed

Neil Armstrong <narmstrong@baylibre.com>
    mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk

Jan Beulich <jbeulich@suse.com>
    xen/privcmd: fix error handling in mmap-resource processing

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Extend the async flip VT-d w/a to skl/bxt

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/i915: Fix runtime pm handling in i915_gem_shrink

Liu, Zhan <Zhan.Liu@amd.com>
    drm/amd/display: Fix DCN3 B0 DP Alt Mapping

Hansen <Hansen.Dsouza@amd.com>
    drm/amd/display: Fix detection of 4 lane for DPALT

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Limit display scaling to up to 4k for DCN 3.1

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/ga102-: support ttm buffer moves via copy engine

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/tu102-: delay enabling cursor until after assign_windows

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: During s0ix don't wait to signal GFXOFF

Jude Shih <shenshih@amd.com>
    drm/amd/display: USB4 bring up set correct address

Liu, Zhan <Zhan.Liu@amd.com>
    drm/amd/display: Fix B0 USB-C DP Alt mode

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: tipd: Remove dependency on "connector" child fwnode

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: handle SRC_STARTUP state if cc changes

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpci: don't handle vSafe0V event if it's not enabled

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix break reporting

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy tty buffer accesses

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: gadget: f_uac2: fixed EP-IN wMaxPacketSize

Fabio Estevam <festevam@gmail.com>
    usb: chipidea: ci_hdrc_imx: Also search for 'phys' phandle

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    usb: cdc-wdm: Fix check for WWAN

Ben Hutchings <ben@decadent.org.uk>
    Partially revert "usb: Kconfig: using select for USB_COMMON dependency"


-------------

Diffstat:

 .../bindings/display/bridge/ti,sn65dsi86.yaml      |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx53-m53menlo.dts               |   4 +-
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi         |   5 +
 arch/arm/boot/dts/imx6qdl-pico.dtsi                |  11 +
 arch/arm/boot/dts/imx6sx-sdb.dts                   |   4 +-
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |   2 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |   2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   7 +-
 arch/arm/configs/gemini_defconfig                  |   1 +
 arch/arm/mach-at91/pm.c                            |  58 +++-
 arch/arm/mach-imx/pm-imx6.c                        |   2 +
 arch/arm/mach-omap2/omap_hwmod.c                   |   2 +
 arch/arm/net/bpf_jit_32.c                          |  19 ++
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   4 +-
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   2 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts       |   2 +-
 .../dts/freescale/imx8mm-kontron-n801x-som.dtsi    |   1 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   2 +-
 .../boot/dts/freescale/imx8mp-phycore-som.dtsi     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq-evk.dts       |   2 +
 .../dts/freescale/imx8mq-kontron-pitx-imx8m.dts    |   2 +-
 arch/arm64/boot/dts/qcom/pm8150.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   6 +-
 arch/mips/include/asm/mips-cps.h                   |  23 +-
 arch/powerpc/boot/dts/fsl/t1023rdb.dts             |   2 +-
 arch/powerpc/include/asm/book3s/32/kup.h           |   8 +
 arch/powerpc/include/asm/interrupt.h               |   5 +-
 arch/powerpc/kernel/dma-iommu.c                    |   9 +
 arch/powerpc/kernel/exceptions-64s.S               |  25 +-
 arch/powerpc/kernel/traps.c                        |  43 +--
 arch/powerpc/net/bpf_jit_comp32.c                  |   8 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  37 ++-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   4 +
 arch/riscv/Makefile                                |   6 +
 arch/riscv/include/asm/syscall.h                   |   1 +
 arch/riscv/include/asm/vdso.h                      |  37 +--
 arch/riscv/include/uapi/asm/unistd.h               |   3 +-
 arch/riscv/kernel/syscall_table.c                  |   1 -
 arch/riscv/kernel/vdso.c                           |  53 ++--
 arch/riscv/kernel/vdso/Makefile                    |  25 +-
 arch/riscv/kernel/vdso/gen_vdso_offsets.sh         |   5 +
 arch/riscv/kernel/vdso/so2s.sh                     |   6 -
 arch/riscv/kernel/vdso/vdso.lds.S                  |   3 +-
 arch/riscv/mm/cacheflush.c                         |   2 +
 arch/s390/net/bpf_jit_comp.c                       |   2 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/entry-common.h                |   2 +-
 arch/x86/kernel/cpu/common.c                       |   1 +
 arch/x86/kernel/early-quirks.c                     |   6 -
 arch/x86/kernel/fpu/signal.c                       |  11 +-
 arch/x86/kernel/hpet.c                             |  81 ++++++
 arch/x86/kernel/sev-shared.c                       |   2 +
 arch/x86/platform/olpc/olpc.c                      |   2 +-
 arch/xtensa/include/asm/kmem_layout.h              |   2 +-
 arch/xtensa/kernel/irq.c                           |   2 +-
 arch/xtensa/kernel/setup.c                         |  12 +-
 arch/xtensa/mm/mmu.c                               |   2 +-
 drivers/bus/ti-sysc.c                              |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  14 +-
 .../drm/amd/display/dc/dcn10/dcn10_link_encoder.h  |   1 +
 .../amd/display/dc/dcn31/dcn31_dio_link_encoder.c  |  66 ++++-
 .../amd/display/dc/dcn31/dcn31_dio_link_encoder.h  |  14 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   8 +-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h  |   2 +-
 .../amd/include/asic_reg/dpcs/dpcs_4_2_0_offset.h  |  27 ++
 drivers/gpu/drm/i915/display/icl_dsi.c             |  48 ++++
 drivers/gpu/drm/i915/display/intel_audio.c         |   5 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |  22 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |   8 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  20 +-
 drivers/gpu/drm/i915/display/intel_vbt_defs.h      |   5 +
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c       |   7 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   6 +
 drivers/gpu/drm/i915/intel_pm.c                    |  12 +
 drivers/gpu/drm/nouveau/dispnv50/crc.c             |   1 +
 drivers/gpu/drm/nouveau/dispnv50/head.c            |   2 +-
 drivers/gpu/drm/nouveau/include/nvif/class.h       |   2 +
 drivers/gpu/drm/nouveau/include/nvkm/engine/fifo.h |   1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   1 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   6 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   1 +
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   4 +-
 drivers/gpu/drm/nouveau/nv84_fence.c               |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |   3 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/Kbuild    |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c   | 311 +++++++++++++++++++++
 drivers/gpu/drm/nouveau/nvkm/subdev/top/ga100.c    |   7 +-
 drivers/gpu/drm/panel/panel-abt-y030xx067a.c       |   4 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |   7 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h              |   4 +-
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |  97 ++++---
 drivers/i2c/busses/i2c-mlxcpld.c                   |   4 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |  11 +-
 drivers/i2c/i2c-core-acpi.c                        |   1 +
 drivers/mmc/host/meson-gx-mmc.c                    |  73 ++++-
 drivers/mmc/host/sdhci-of-at91.c                   |  22 +-
 drivers/net/ethernet/google/gve/gve.h              |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  45 +--
 drivers/net/ethernet/google/gve/gve_rx.c           |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  11 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  59 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  11 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  12 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  37 ++-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   9 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/pcs/pcs-xpcs.c                         |  45 ++-
 drivers/net/phy/mdio_bus.c                         |   7 +
 drivers/net/phy/sfp.c                              |   2 +-
 drivers/net/wireless/ath/ath5k/Kconfig             |   4 +-
 drivers/net/wireless/ath/ath5k/led.c               |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   2 +
 drivers/of/base.c                                  |   1 +
 drivers/pci/controller/pci-hyperv.c                |  13 +-
 drivers/ptp/ptp_pch.c                              |   1 +
 drivers/scsi/libiscsi.c                            |  15 +-
 drivers/scsi/ufs/ufshcd.c                          |  52 ++--
 drivers/scsi/ufs/ufshcd.h                          |   1 +
 drivers/soc/qcom/mdt_loader.c                      |   2 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/soc/ti/omap_prm.c                          |  27 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  15 +-
 drivers/usb/class/cdc-acm.c                        |   8 +
 drivers/usb/class/cdc-wdm.c                        |   6 +-
 drivers/usb/common/Kconfig                         |   3 +-
 drivers/usb/gadget/function/f_uac2.c               |  14 +-
 drivers/usb/typec/tcpm/tcpci.c                     |   2 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   1 +
 drivers/usb/typec/tipd/core.c                      |   8 +-
 drivers/video/fbdev/Kconfig                        |   5 +-
 drivers/video/fbdev/gbefb.c                        |   2 +-
 drivers/xen/balloon.c                              |  21 +-
 drivers/xen/privcmd.c                              |   7 +-
 fs/afs/write.c                                     |   3 +-
 fs/netfs/read_helper.c                             |   2 +-
 fs/nfsd/nfs4xdr.c                                  |  19 +-
 fs/nfsd/nfsctl.c                                   |   2 +-
 fs/overlayfs/dir.c                                 |  10 +-
 fs/overlayfs/file.c                                |  15 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h        |   1 -
 include/net/netfilter/nf_tables.h                  |   2 +-
 include/net/netns/netfilter.h                      |   6 +
 include/soc/mscc/ocelot_vcap.h                     |   4 +-
 kernel/bpf/stackmap.c                              |   3 +-
 net/bridge/br_netlink.c                            |   3 +-
 net/core/rtnetlink.c                               |   2 +-
 net/dsa/tag_dsa.c                                  |   2 +-
 net/ipv4/inet_hashtables.c                         |   4 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |  30 +-
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |  25 +-
 net/ipv6/udp.c                                     |   3 +-
 net/netfilter/nf_tables_api.c                      |  91 ++++--
 net/netfilter/nft_quota.c                          |   2 +-
 net/netlink/af_netlink.c                           |  14 +-
 net/sched/sch_fifo.c                               |   3 +
 net/sched/sch_taprio.c                             |   4 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |   2 +-
 tools/lib/bpf/libbpf.c                             |   3 +-
 tools/lib/bpf/strset.c                             |   1 +
 tools/objtool/arch/x86/decode.c                    |   2 +-
 tools/objtool/special.c                            |  36 +--
 tools/perf/pmu-events/jevents.c                    |   2 +
 182 files changed, 1620 insertions(+), 633 deletions(-)


