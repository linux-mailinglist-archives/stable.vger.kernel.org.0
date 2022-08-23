Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2341359D387
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiHWIHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241045AbiHWIHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:07:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1856B8C8;
        Tue, 23 Aug 2022 01:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67E18611DD;
        Tue, 23 Aug 2022 08:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE852C433C1;
        Tue, 23 Aug 2022 08:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241882;
        bh=/NZrIRl/rP8oYB4FaFjhuNandBsbY+4a83u7zS3hTrs=;
        h=From:To:Cc:Subject:Date:From;
        b=N2lePFytEybEBwUPL6IFVj+wDNf4E0mx6pRZO43lL8E8NCpFVStgjtBNxXhUzfHBU
         xRveq02ZfjiVPvbA1DDSYHxvoC1EDC64izrfl5tS3vksHxzBCQ0jEuytMynwfu89Fj
         ARefL1156I9SWEwL0arYgn/ml+tiP9dE9L2Bs0YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 000/365] 5.19.4-rc1 review
Date:   Tue, 23 Aug 2022 09:58:21 +0200
Message-Id: <20220823080118.128342613@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.4-rc1
X-KernelTest-Deadline: 2022-08-25T08:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.19.4 release.
There are 365 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.4-rc1

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda: Fix page fault in snd_hda_codec_shutdown()"

Ren Zhijie <renzhijie2@huawei.com>
    scsi: ufs: ufs-mediatek: Fix build error and type mismatch

Ye Bin <yebin10@huawei.com>
    f2fs: fix null-ptr-deref in f2fs_get_dnode_of_data

Daeho Jeong <daehojeong@google.com>
    f2fs: revive F2FS_IOC_ABORT_VOLATILE_WRITE

Nathan Chancellor <nathan@kernel.org>
    MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    venus: pm_helpers: Fix warning in OPP during probe

Zhouyi Zhou <zhouzhouyi@gmail.com>
    powerpc/64: Init jump labels before parse_early_param()

Steve French <stfrench@microsoft.com>
    smb3: check xattr value length earlier

Chao Yu <chao.yu@oppo.com>
    f2fs: fix to do sanity check on segment type in build_sit_entries()

Chao Yu <chao.yu@oppo.com>
    f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Use deferred fasync helper

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Use deferred fasync helper

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Use deferred fasync helper

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add async signal helpers

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/ioda/iommu/debugfs: Generate unique debugfs entries

Miklos Szeredi <mszeredi@redhat.com>
    ovl: warn if trusted xattr creation fails

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: va-macro: use fsgen as clock

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Don't always pass -mcpu=powerpc to the compiler

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Set an IBAT covering up to _einittext during init

Laurent Dufour <ldufour@linux.ibm.com>
    powerpc/pseries/mobility: set NMI watchdog factor during an LPM

Laurent Dufour <ldufour@linux.ibm.com>
    powerpc/watchdog: introduce a NMI watchdog's factor

Laurent Dufour <ldufour@linux.ibm.com>
    watchdog: export lockup_detector_reconfigure

Yong Zhi <yong.zhi@intel.com>
    ASoC: Intel: sof_nau8825: Move quirk check to the front in late probe

Andrey Turkin <andrey.turkin@gmail.com>
    ASoC: Intel: sof_es8336: ignore GpioInt when looking for speaker/headset GPIO lines

Andrey Turkin <andrey.turkin@gmail.com>
    ASoC: Intel: sof_es8336: Fix GPIO quirks set via module option

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda: add sanity check on SSP index reported by NHLT

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable speaker and mute LEDs for HP laptops

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Add fast call path of crash_kexec()

Celeste Liu <coelacanthus@outlook.com>
    riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Mark Brown <broonie@kernel.org>
    ASoC: nau8821: Don't unconditionally free interrupt

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: canaan: Add k210 topology information

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: sifive: Add fu740 topology information

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: sifive: Add fu540 topology information

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: care default case on rsnd_ssiu_busif_err_irq_ctrl()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: sof-client-probes: Only load the driver if IPC3 is used

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-ipc: Do not process IPC reply before firmware boot

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: cnl: Do not process IPC reply before firmware boot

Helge Deller <deller@gmx.de>
    modules: Ensure natural alignment for .altinstructions and __bug_table sections

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Fix page fault in snd_hda_codec_shutdown()

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Set max DMA segment size

Yunfei Wang <yf.wang@mediatek.com>
    iommu/io-pgtable-arm-v7s: Add a quirk to allow pgtable PA up to 35bit

Liang He <windhl@126.com>
    mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Schspa Shi <schspa@gmail.com>
    vfio: Clear the caps->buf to NULL after free

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings

Liang He <windhl@126.com>
    tty: serial: Fix refcount leak bug in ucc_uart.c

Dongli Zhang <dongli.zhang@oracle.com>
    swiotlb: panic if nslabs is too small

Guenter Roeck <linux@roeck-us.net>
    lib/list_debug.c: Detect uninitialized lists

Kiselev, Oleg <okiselev@amazon.com>
    ext4: avoid resizing to a partial cluster size

Lukas Czerner <lczerner@redhat.com>
    ext4: block range must be validated before use in ext4_mb_clear_bb()

Ye Bin <yebin10@huawei.com>
    ext4: avoid remove directory when directory is corrupted

Wentao_Liang <Wentao_Liang_g@163.com>
    drivers:md:fix a potential use-after-free bug

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix lockdep complaint on nvmet_tcp_wq flush during queue teardown

Logan Gunthorpe <logang@deltatee.com>
    md/raid5: Make logic blocking check consistent with logic that blocks

Logan Gunthorpe <logang@deltatee.com>
    md: Notify sysfs sync_completed in md_reap_sync_thread()

Marek Szyprowski <m.szyprowski@samsung.com>
    phy: samsung: phy-exynos-pcie: sanitize init/power_on callbacks

Stafford Horne <shorne@gmail.com>
    openrisc: io: Define iounmap argument as volatile

Li Zhijian <lizhijian@fujitsu.com>
    Revert "RDMA/rxe: Create duplicate mapping tables for FMRs"

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Akhil R <akhilrajeev@nvidia.com>
    dmaengine: tegra: Add terminate() for Tegra234

Steven Rostedt (Google) <rostedt@goodmis.org>
    selftests/kprobe: Do not test for GRP/ without event failures

Liao Chang <liaochang1@huawei.com>
    csky/kprobe: reclaim insn_slot on kprobe unregistration

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Limit the number of calls to each tasklet

Sudeep Holla <sudeep.holla@arm.com>
    ACPI: PPTT: Leave the table mapped for the runtime usage

Takeshi Saito <takeshi.saito.xv@renesas.com>
    mmc: renesas_sdhi: newer SoCs don't need manual tap correction

Ben Dooks <ben.dooks@sifive.com>
    dmaengine: dw-axi-dmac: ignore interrupt if no descriptor

Ben Dooks <ben.dooks@sifive.com>
    dmaengine: dw-axi-dmac: do not print NULL LLI during error

Geert Uytterhoeven <geert+renesas@glider.be>
    of: overlay: Move devicetree_corrupt() check up

Jason A. Donenfeld <Jason@zx2c4.com>
    um: add "noreboot" command line option for PANIC_TIMEOUT=-1 setups

Huacai Chen <chenhuacai@kernel.org>
    PCI/ACPI: Guard ARM64-specific mcfg_quirks

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cxl: Fix a memory leak in an error handling path

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Check against matching data instead of ACPI companion

Chanho Park <chanho61.park@samsung.com>
    scsi: ufs: ufs-exynos: Change ufs phy control sequence

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: tmio: avoid glitches when resetting

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: mask constant value before cast

Ofir Bitton <obitton@habana.ai>
    habanalabs/gaudi: fix shift out of bounds

Tal Cohen <talcohen@habana.ai>
    habanalabs/gaudi: invoke device reset from one code block

Dafna Hirschfeld <dhirschfeld@habana.ai>
    habanalabs: add terminating NULL to attrs arrays

Nick Desaulniers <ndesaulniers@google.com>
    coresight: etm4x: avoid build failure with unrolled loops

Jozef Martiniak <jomajm@gmail.com>
    gadgetfs: ep_io - wait until IRQ finishes

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix possible memory leak when failing to issue CMF WQE

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Prevent buffer overflow crashes in debugfs with malformed user input

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: clk-alpha-pll: fix clk_trion_pll_configure description

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not lookup algorithm in backends table

Jean-Philippe Brucker <jean-philippe@linaro.org>
    uacce: Handle parent device removal or parent driver module rmmod

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: dont disable gcc_sleep_clk_src

Pascal Terjan <pterjan@google.com>
    vboxguest: Do not use devm for irq

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix HW conn removal use after free

Liang He <windhl@126.com>
    usb: renesas: Fix refcount leak bug

Liang He <windhl@126.com>
    usb: host: ohci-ppc-of: Fix refcount leak bug

Prashant Malani <pmalani@chromium.org>
    usb: typec: mux: Add CONFIG guards for functions

Po-Wen Kao <powen.kao@mediatek.com>
    scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators

Tony Lindgren <tony@atomide.com>
    clk: ti: Stop using legacy clkctrl names for omap4 and 5

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    drm/meson: Fix overflow implicit truncation warnings

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    irqchip/tegra: Fix overflow implicit truncation warnings

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    scsi: ufs: core: Add UFSHCD_QUIRK_HIBERN_FASTAUTO

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting Slot capabilities on emulated bridge

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: calculate the number of request depending on framesize

Frank Li <Frank.Li@nxp.com>
    usb: cdns3 fix use-after-free at workaround 2

Pavel Skripkin <paskripkin@gmail.com>
    staging: r8188eu: add error handling of rtw_read32

Pavel Skripkin <paskripkin@gmail.com>
    staging: r8188eu: add error handling of rtw_read16

Pavel Skripkin <paskripkin@gmail.com>
    staging: r8188eu: add error handling of rtw_read8

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_proto: don't show MKBP version if unsupported

Pavan Chebbi <pavan.chebbi@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM5750x NICs

Tao Jin <tao-j@outlook.com>
    HID: multitouch: new device class fix Lenovo X12 trackpad sticky

Gil Fine <gil.fine@intel.com>
    thunderbolt: Change downstream router's TMU rate in both TMU uni/bidir mode

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/kvm: Fix "missing ENDBR" BUG for fastop functions

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/ibt, objtool: Add IBT_NOSEAL()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: report ndo_get_stats64 from the wraparound-resistant ocelot->stats

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: make struct ocelot_stat_layout array indexable

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix race between ndo_get_stats64 and ocelot_check_stats_work

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: turn stats_lock into a spinlock

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems

Maíra Canal <mairacanal@riseup.net>
    drm/amdgpu: Fix use-after-free on amdgpu_bo_list mutex

Samuel Holland <samuel@sholland.org>
    drm/sun4i: dsi: Prevent underflow when computing packet sizes

Marek Vasut <marex@denx.de>
    drm/bridge: lvds-codec: Fix error checking of drm_of_lvds_get_data_mapping()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Avoid another list of reset devices

Matthew Auld <matthew.auld@intel.com>
    drm/i915/ttm: don't leak the ccs state

Liang He <windhl@126.com>
    drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    drm/imx/dcss: get rid of HPD warning message

Fedor Pchelkin <pchelkin@ispras.ru>
    can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()

Andrew Donnellan <ajd@linux.ibm.com>
    gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix the modules order between drivers and libs

Lin Ma <linma@zju.edu.cn>
    igb: Add lock to avoid data race

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()

Samuel Holland <samuel@sholland.org>
    dt-bindings: display: sun4i: Add D1 TCONs to conditionals

Csókás Bence <csokas.bence@prolan.hu>
    fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Ben Hutchings <benh@debian.org>
    tools/rtla: Fix command symlinks

Yufen Yu <yuyufen@huawei.com>
    blk-mq: run queue no matter whether the request is the last request

Alan Brady <alan.brady@intel.com>
    i40e: Fix to stop tx_timeout recovery if GLOBR fails

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Remove restrictions for regulator-name

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Fix tunnel checksum offload with fragmented traffic

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    i2c: imx: Make sure to unregister adapter on remove()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix module versioning when a symbol lacks valid CRC

Benjamin Mikailenko <benjamin.mikailenko@intel.com>
    ice: Ignore error message when setting same promiscuous mode

Grzegorz Siwik <grzegorz.siwik@intel.com>
    ice: Fix clearing of promisc mode with bridge over bond

Grzegorz Siwik <grzegorz.siwik@intel.com>
    ice: Ignore EEXIST when setting promisc mode

Grzegorz Siwik <grzegorz.siwik@intel.com>
    ice: Fix double VLAN error when entering promisc mode

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    ice: Fix VF not able to send tagged traffic with no VLAN filters

Michal Jaron <michalx.jaron@intel.com>
    ice: Fix call trace with null VSI during VF reset

Benjamin Mikailenko <benjamin.mikailenko@intel.com>
    ice: Fix VSI rebuild WARN_ON check for VF

Rustam Subkhankulov <subkhankulov@ispras.ru>
    net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it

Jakub Kicinski <kuba@kernel.org>
    net: genl: fix error path memory leak in policy dumping

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: fix misuse of qcpu->backlog in gnet_stats_add_queue_cpu

Zhengchao Shao <shaozhengchao@huawei.com>
    net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg

Xin Xiong <xiongx18@fudan.edu.cn>
    net: fix potential refcount leak in ndisc_router_discovery()

Sergei Antonov <saproj@gmail.com>
    net: moxa: pass pdev instead of ndev to DMA functions

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix endian-ness for RSS

Maxim Kochetkov <fido_max@inbox.ru>
    net: qrtr: start MHI channel after endpoit creation

Sergei Antonov <saproj@gmail.com>
    net: dsa: mv88e6060: prevent crash on an unused port

Xin Xiong <xiongx18@fudan.edu.cn>
    net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()

Neil Armstrong <narmstrong@baylibre.com>
    spi: meson-spicc: add local pow2 clock ops to preserve rate between messages

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pci: Fix get_phb_number() locking

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix scheduling-while-atomic splat

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: really skip inactive sets when allocating name

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: possible module reference underflow in error path

Florian Westphal <fw@strlen.de>
    netfilter: nf_ct_irc: cap packet search space to 4k

Florian Westphal <fw@strlen.de>
    netfilter: nf_ct_ftp: prefer skb_linearize

Florian Westphal <fw@strlen.de>
    netfilter: nf_ct_h323: cap packet size at 64k

Florian Westphal <fw@strlen.de>
    netfilter: nf_ct_sane: remove pseudo skb linearization

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag

Dan Carpenter <dan.carpenter@oracle.com>
    fs/ntfs3: uninitialized variable in ntfs_set_acl_ex()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink: re-enable conntrack expectation events

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: fix accept failure due to increased cpl_t5_pass_accept_rpl size

Mark Bloch <mbloch@nvidia.com>
    RDMA/mlx5: Use the proper number of ports

Sergey Gorenko <sergeygo@nvidia.com>
    IB/iser: Fix login with authentication

Philipp Zabel <p.zabel@pengutronix.de>
    ASoC: codec: tlv320aic32x4: fix mono playback via I2S

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Fix handling of mute/unmute

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Drop conflicting set_bias_level power setting

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Allow mono streams

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Set correct FSYNC polarity

Takashi Iwai <tiwai@suse.de>
    ASoC: DPCM: Don't pick up BE without substream

Takashi Iwai <tiwai@suse.de>
    ASoC: SOF: Intel: hda: Fix potential buffer overflow by snprintf()

Takashi Iwai <tiwai@suse.de>
    ASoC: SOF: debug: Fix potential buffer overflow by snprintf()

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: avs: Fix potential buffer overflow by snprintf()

Ivan Vecera <ivecera@redhat.com>
    iavf: Fix deadlock in initialization

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix reset error handling

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix NULL pointer dereference in iavf_get_link_ksettings

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix adminq error handling

Al Viro <viro@zeniv.linux.org.uk>
    nios2: add force_successful_syscall_return()

Al Viro <viro@zeniv.linux.org.uk>
    nios2: restarts apply only to the first sigframe we build...

Al Viro <viro@zeniv.linux.org.uk>
    nios2: fix syscall restart checks

Al Viro <viro@zeniv.linux.org.uk>
    nios2: traced syscall does need to check the syscall number

Al Viro <viro@zeniv.linux.org.uk>
    nios2: don't leave NULLs in sys_call_table[]

Al Viro <viro@zeniv.linux.org.uk>
    nios2: page fault et.al. are *not* restartable syscalls...

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix missing i_op in ntfs_read_mft

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do not change mode if ntfs_set_ea failed

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix double free on remount

Dan Carpenter <dan.carpenter@oracle.com>
    fs/ntfs3: Don't clear upper bits accidentally in log_replay()

Pavel Skripkin <paskripkin@gmail.com>
    fs/ntfs3: Fix NULL deref in ntfs_update_mftmirr

Yan Lei <chinayanlei2002@163.com>
    fs/ntfs3: Fix using uninitialized value n when calling indx_read

Chen Lin <chen45464546@163.com>
    dpaa2-eth: trace the allocated address instead of page struct

Adrian Hunter <adrian.hunter@intel.com>
    perf tests: Fix Track with sched_switch test for hybrid case

Adrian Hunter <adrian.hunter@intel.com>
    perf parse-events: Fix segfault when event parser gets an error

Robin Reckmann <robin.reckmann@googlemail.com>
    i2c: qcom-geni: Fix GPI DMA buffer sync-back

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    perf probe: Fix an error handling path in 'parse_perf_probe_command()'

Christoph Hellwig <hch@lst.de>
    nvme-fc: fix the fc_appid_store return value

Matthias May <matthias.may@westermo.com>
    geneve: fix TOS inheriting for ipv4

Jeff Layton <jlayton@kernel.org>
    fscache: don't leak cookie access refs if invalidation is in progress or failed

Duoming Zhou <duoming@zju.edu.cn>
    atm: idt77252: fix use-after-free bugs caused by tst_timer

Gerhard Engleder <gerhard@engleder-embedded.com>
    tsnep: Fix tsnep_tx_unmap() error path usage

Dan Carpenter <dan.carpenter@oracle.com>
    xen/xenbus: fix return type in xenbus_file_read()

Yu Xiao <yu.xiao@corigine.com>
    nfp: ethtool: fix the display error of `ethtool -m DEVNAME`

Dan Carpenter <dan.carpenter@oracle.com>
    NTB: ntb_tool: uninitialized heap data in tool_fn_write()

Roberto Sassu <roberto.sassu@huawei.com>
    tools build: Switch to new openssl API for test-libcrypto

Ondrej Mosnacek <omosnace@redhat.com>
    kbuild: dummy-tools: avoid tmpdir leak in dummy gcc

Dan Williams <dan.j.williams@intel.com>
    tools/testing/cxl: Fix cxl_hdm_decode_init() calling convention

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim_blk: set number of address spaces and virtqueue groups

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: use max_iotlb_entries as a limit in vhost_iotlb_init

Jacky Bai <ping.bai@nxp.com>
    clk: imx93: Correct the edma1's parent clock

Jeff Layton <jlayton@kernel.org>
    ceph: don't leak snap_rwsem in handle_cap_grant

Yuanzheng Song <songyuanzheng@huawei.com>
    tools/vm/slabinfo: use alphabetic order when two values are equal

Dan Williams <dan.j.williams@intel.com>
    tools/testing/cxl: Fix decoder default state

Luís Henriques <lhenriques@suse.de>
    ceph: use correct index when encoding client supported features

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: dt-bindings: qcom,spi-geni-qcom: allow three interconnects

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: opp: opp-v2-kryo-cpu: Fix example binding checks

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: dt-bindings: zynqmp-qspi: add missing 'required'

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: dt-bindings: cadence: add missing 'required'

Johan Hovold <johan+linaro@kernel.org>
    dt-bindings: PCI: qcom: Fix reset conditional

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    dt-bindings: clock: qcom,gcc-msm8996: add more GCC clock sources

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: arm: qcom: fix MSM8994 boards compatibles

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: arm: qcom: fix MSM8916 MTP compatibles

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: arm: qcom: fix Longcheer L8150 compatibles

Michal Simek <michal.simek@xilinx.com>
    dt-bindings: gpio: zynq: Add missing compatible strings

Peilin Ye <peilin.ye@bytedance.com>
    vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Peilin Ye <peilin.ye@bytedance.com>
    vsock: Fix memory leak in vsock_connect()

Florian Westphal <fw@strlen.de>
    plip: avoid rcu debug splat

Matthias May <matthias.may@westermo.com>
    ipv6: do not use RT_TOS for IPv6 flowlabel

Matthias May <matthias.may@westermo.com>
    mlx5: do not use RT_TOS for IPv6 flowlabel

Matthias May <matthias.may@westermo.com>
    vxlan: do not use RT_TOS for IPv6 flowlabel

Matthias May <matthias.may@westermo.com>
    geneve: do not use RT_TOS for IPv6 flowlabel

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Fix key checking for source mac

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Fix mcam entry resource leak

Harman Kalra <hkalra@marvell.com>
    octeontx2-af: suppress external profile loading warning

Stanislaw Kardach <skardach@marvell.com>
    octeontx2-af: Apply tx nibble fixup always

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration

Peter Zijlstra <peterz@infradead.org>
    um: Add missing apply_returns()

Jeff LaBundy <jeff@labundy.com>
    dt-bindings: input: iqs7222: Extend slider-mapped GPIO to IQS7222C

Jeff LaBundy <jeff@labundy.com>
    dt-bindings: input: iqs7222: Correct bottom speed step size

Jeff LaBundy <jeff@labundy.com>
    dt-bindings: input: iqs7222: Remove support for RF filter

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - remove support for RF filter

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - handle reset during ATI

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - acknowledge reset before writing registers

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - protect volatile registers

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - fortify slider event reporting

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - correct slider event disable logic

Mattijs Korpershoek <mkorpershoek@baylibre.com>
    Input: mt6779-keypad - match hardware matrix organization

Miaoqian Lin <linmq006@gmail.com>
    Input: exc3000 - fix return value check of wait_for_completion_timeout

Zeng Jingxiang <linuszeng@tencent.com>
    rtc: spear: set range max

Jianhua Lu <lujianhua000@gmail.com>
    pinctrl: qcom: sm8250: Fix PDC map

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    dt-bindings: pinctrl: mt8186: Add and use drive-strength-microamp

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: Add I/O bias setting for H6 R-PIO

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    dt-bindings: pinctrl: mt8195: Add and use drive-strength-microamp

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    dt-bindings: pinctrl: mt8195: Fix name for mediatek,rsel-resistance-in-si-unit

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    pinctrl: amd: Don't save/restore interrupt status and wake status bits

Nikita Travkin <nikita@trvn.ru>
    pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    dt-bindings: pinctrl: mt8192: Use generic bias instead of pull-*-adv

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    dt-bindings: pinctrl: mt8192: Add drive-strength-microamp

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Return -EINVAL for pins which have input disabled

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: arm: qcom: fix Alcatel OneTouch Idol 3 compatibles

Ido Schimmel <idosch@nvidia.com>
    selftests: forwarding: Fix failing tests with old libnet

Jakub Kicinski <kuba@kernel.org>
    net: atm: bring back zatm uAPI

Sandor Bodo-Merle <sbodomerle@gmail.com>
    net: bgmac: Fix a BUG triggered by wrong bytes_compl

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: suppress non-changes to the tagging protocol

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: c45 baset1: do not skip aneg configuration if clock role is not specified

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Indicate MAC is in charge of PHY PM

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Warn about incorrect mdio_bus_phy_resume() state

Ido Schimmel <idosch@nvidia.com>
    devlink: Fix use-after-free after a failed reload

Shigeru Yoshida <syoshida@redhat.com>
    virtio-blk: Avoid use-after-free on suspend/resume

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_net: fix memory leak inside XPD_TX with mergeable

Michael S. Tsirkin <mst@redhat.com>
    virtio: VIRTIO_HARDEN_NOTIFICATION is broken

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6apm-dai: unprepare stream if its already prepared

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Don't reuse bvec on retransmission of the request

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Reinitialise the backchannel request buffers before reuse

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix xdr_encode_bool()

Dan Aloni <dan.aloni@vastdata.com>
    sunrpc: fix expiry of auth creds

Randy Dunlap <rdunlap@infradead.org>
    m68k: coldfire/device.c: protect FLEXCAN blocks

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    net: atlantic: fix aq_vec index out of range error

Fedor Pchelkin <pchelkin@ispras.ru>
    can: j1939: j1939_session_destroy(): fix memory leak of skbs

Sebastian Würl <sebastian.wuerl@ororatech.com>
    can: mcp251x: Fix race condition on receive interrupt

Hou Tao <houtao1@huawei.com>
    bpf: Check the validity of max_rdwr_access for sock local storage map iterator

Hou Tao <houtao1@huawei.com>
    bpf: Acquire map uref in .init_seq_private for sock{map,hash} iterator

Hou Tao <houtao1@huawei.com>
    bpf: Acquire map uref in .init_seq_private for sock local storage map iterator

Hou Tao <houtao1@huawei.com>
    bpf: Acquire map uref in .init_seq_private for hash map iterator

Hou Tao <houtao1@huawei.com>
    bpf: Acquire map uref in .init_seq_private for array map iterator

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Don't reinit map value in prealloc_lru_pop

Alexei Starovoitov <ast@kernel.org>
    bpf: Disallow bpf programs call prog_run command.

Jinghao Jia <jinghao@linux.ibm.com>
    BPF: Fix potential bad pointer dereference in bpf_sys_bpf()

Florian Westphal <fw@strlen.de>
    selftests: mptcp: make sendfile selftest work

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not queue data on closed subflows

Paolo Abeni <pabeni@redhat.com>
    mptcp: move subflow cleanup in mptcp_destroy_common()

Jiri Olsa <jolsa@kernel.org>
    mptcp, btf: Add struct mptcp_sock definition when CONFIG_MPTCP is disabled

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Fix a use-after-free bug in open

Zhang Xianwei <zhang.xianwei8@zte.com.cn>
    NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix races in the legacy idmapper upcall

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Don't decrease the value of seq_nr_highest_sent

Cezar Bulinaru <cbulinaru@gmail.com>
    net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix crash when nf_trace is enabled

Qifu Zhang <zhangqifu@bytedance.com>
    Documentation: ACPI: EINJ: Fix obsolete example

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Fix memleak in aa_simple_write_to_buffer()

Xin Xiong <xiongx18@fudan.edu.cn>
    apparmor: fix reference count leak in aa_pivotroot()

John Johansen <john.johansen@canonical.com>
    apparmor: fix overlapping attachment computation

John Johansen <john.johansen@canonical.com>
    apparmor: fix setting unconfined mode on a loaded profile

Tom Rix <trix@redhat.com>
    apparmor: fix aa_label_asxprint return check

John Johansen <john.johansen@canonical.com>
    apparmor: Fix failed mount permission check error message

John Johansen <john.johansen@canonical.com>
    apparmor: fix absroot causing audited secids to begin with =

John Johansen <john.johansen@canonical.com>
    apparmor: fix quiet_denied for file rules

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ems_usb: fix clang's -Wunaligned-access warning

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    dt-bindings: usb: mtk-xhci: Allow wakeup interrupt-names to be optional

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Fix crash due to jack poll in suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: More comprehensive mixer map for ASUS ROG Zenith II

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have filter accept "common_cpu" to be consistent

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/probes: Have kprobes and uprobes use $COMM too

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/eprobes: Have event probes be consistent with kprobes and uprobes

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/eprobes: Fix reading of string fields

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/eprobes: Do not hardcode $comm as a string

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/eprobes: Do not allow eprobes to use $stack, or % for regs

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/perf: Fix double put of trace event when init fails

Nadav Amit <namit@vmware.com>
    x86/kprobes: Fix JNG/JNLE emulation

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix memory leak on the deferred close

Mauro Carvalho Chehab <mchehab@kernel.org>
    drm/i915: pass a pointer for tlb seqno at vma_invalidate_tlb()

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Batch TLB invalidations

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Skip TLB invalidations once wedged

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Invalidate TLB of the OA unit at TLB invalidations

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Ignore TLB invalidations on idle engines

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: change vram width algorithm for vram_info v3_0

Filipe Manana <fdmanana@suse.com>
    btrfs: fix warning during log replay when bumping inode link count

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when looking up extended ref on log replay

Josef Bacik <josef@toxicpanda.com>
    btrfs: reset RO counter on block group if we fail to relocate

Zixuan Fu <r33s3n6@gmail.com>
    btrfs: unset reloc control if transaction commit fails in prepare_to_relocate()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: meson-gx: Fix an error handling path in meson_mmc_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: pxamci: Fix an error handling path in pxamci_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: pxamci: Fix another error handling path in pxamci_probe()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata-eh: Add missing command name

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: fix crash on older machines based on QCI info missing

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Check correct bounds for stream encoder instances for DCN303

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Only disable prefer_shadow on hawaii

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/ttm: Fix dummy res NULL ptr deref bug

Karol Herbst <kherbst@redhat.com>
    drm/nouveau: recognise GA103

Hector Martin <marcan@marcan.st>
    locking/atomic: Make test_and_*_bit() ordered on failure

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Remove shared locking on freeing objects

Mikulas Patocka <mpatocka@redhat.com>
    rds: add missing barrier to release_refill

Aaron Lu <aaron.lu@intel.com>
    x86/mm: Use proper mask when setting PUD mapping

Sean Christopherson <seanjc@google.com>
    KVM: Unconditionally get a ref to /dev/kvm module when creating a VM

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA: Handle the return code from dma_resv_wait_timeout() properly

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/realtek: Add quirk for Clevo NS50PU, NS70PU

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: info: Fix llseek return value when using callback


-------------

Diffstat:

 Documentation/admin-guide/sysctl/kernel.rst        |  12 +
 Documentation/atomic_bitops.txt                    |   2 +-
 Documentation/devicetree/bindings/arm/qcom.yaml    |  18 +-
 .../bindings/clock/qcom,gcc-msm8996.yaml           |  16 +
 .../bindings/display/allwinner,sun4i-a10-tcon.yaml |   4 +
 .../devicetree/bindings/gpio/gpio-zynq.yaml        |   6 +-
 .../devicetree/bindings/input/azoteq,iqs7222.yaml  |  28 +-
 .../devicetree/bindings/opp/opp-v2-kryo-cpu.yaml   |  15 +
 .../devicetree/bindings/pci/qcom,pcie.yaml         |   2 +-
 .../bindings/pinctrl/pinctrl-mt8186.yaml           |  29 +-
 .../bindings/pinctrl/pinctrl-mt8192.yaml           |  58 +--
 .../bindings/pinctrl/pinctrl-mt8195.yaml           |  37 +-
 .../bindings/regulator/nxp,pca9450-regulator.yaml  |  11 -
 .../bindings/spi/qcom,spi-geni-qcom.yaml           |   5 +-
 .../devicetree/bindings/spi/spi-cadence.yaml       |   7 +
 .../devicetree/bindings/spi/spi-zynqmp-qspi.yaml   |   7 +
 .../devicetree/bindings/usb/mediatek,mtk-xhci.yaml |   1 +
 Documentation/firmware-guide/acpi/apei/einj.rst    |   2 +-
 Makefile                                           |  10 +-
 arch/arm64/include/asm/kvm_host.h                  |   4 +
 arch/arm64/kvm/arm.c                               |   3 +-
 arch/arm64/kvm/guest.c                             |   2 +-
 arch/arm64/kvm/sys_regs.c                          |   4 +-
 arch/csky/kernel/probes/kprobes.c                  |   4 +
 arch/m68k/coldfire/device.c                        |   6 +-
 arch/mips/cavium-octeon/octeon-platform.c          |   3 +-
 arch/mips/mm/tlbex.c                               |   4 +-
 arch/nios2/include/asm/entry.h                     |   3 +-
 arch/nios2/include/asm/ptrace.h                    |   2 +
 arch/nios2/kernel/entry.S                          |  22 +-
 arch/nios2/kernel/signal.c                         |   3 +-
 arch/nios2/kernel/syscall_table.c                  |   1 +
 arch/openrisc/include/asm/io.h                     |   2 +-
 arch/openrisc/mm/ioremap.c                         |   2 +-
 arch/powerpc/Makefile                              |  26 +-
 arch/powerpc/include/asm/nmi.h                     |   2 +
 arch/powerpc/kernel/head_book3s_32.S               |   4 +-
 arch/powerpc/kernel/pci-common.c                   |  16 +-
 arch/powerpc/kernel/prom.c                         |   7 +
 arch/powerpc/kernel/watchdog.c                     |  21 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c              |  13 +-
 arch/powerpc/mm/book3s32/mmu.c                     |  10 +-
 arch/powerpc/platforms/Kconfig.cputype             |  21 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   2 +
 arch/powerpc/platforms/pseries/mobility.c          |  43 ++
 arch/riscv/boot/dts/canaan/k210.dtsi               |  12 +
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi         |  24 +
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi         |  24 +
 arch/riscv/kernel/sys_riscv.c                      |   5 +-
 arch/riscv/kernel/traps.c                          |   4 +
 arch/um/kernel/um_arch.c                           |   4 +
 arch/um/os-Linux/skas/process.c                    |  17 +-
 arch/x86/include/asm/ibt.h                         |  11 +
 arch/x86/kernel/kprobes/core.c                     |   2 +-
 arch/x86/kvm/emulate.c                             |   3 +-
 arch/x86/mm/init_64.c                              |   2 +-
 block/blk-mq.c                                     |   2 +-
 drivers/acpi/pci_mcfg.c                            |   3 +
 drivers/acpi/pptt.c                                | 102 ++---
 drivers/acpi/property.c                            |   8 +-
 drivers/ata/libata-eh.c                            |   1 +
 drivers/atm/idt77252.c                             |   1 +
 drivers/block/virtio_blk.c                         |  24 +-
 drivers/block/zram/zcomp.c                         |  11 +-
 drivers/clk/imx/clk-imx93.c                        |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |   1 +
 drivers/clk/ti/clk-44xx.c                          | 210 ++++-----
 drivers/clk/ti/clk-54xx.c                          | 160 +++----
 drivers/clk/ti/clkctrl.c                           |   4 -
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  11 +
 drivers/dma/sprd-dma.c                             |   5 +-
 drivers/dma/tegra186-gpc-dma.c                     |  26 +-
 drivers/gpu/drm/amd/amdgpu/aldebaran.c             |  45 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h          |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |   3 +-
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +-
 .../drm/amd/display/dc/dcn303/dcn303_resource.c    |   2 +-
 drivers/gpu/drm/bridge/lvds-codec.c                |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |  16 +-
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h   |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_pages.c          |  25 +-
 drivers/gpu/drm/i915/gt/intel_gt.c                 |  77 +++-
 drivers/gpu/drm/i915/gt/intel_gt.h                 |  12 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.h              |   3 +
 drivers/gpu/drm/i915/gt/intel_gt_types.h           |  18 +-
 drivers/gpu/drm/i915/gt/intel_migrate.c            |  23 +-
 drivers/gpu/drm/i915/gt/intel_ppgtt.c              |   8 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   4 +-
 drivers/gpu/drm/i915/i915_vma.c                    |  33 +-
 drivers/gpu/drm/i915/i915_vma.h                    |   1 +
 drivers/gpu/drm/i915/i915_vma_resource.c           |   5 +-
 drivers/gpu/drm/i915/i915_vma_resource.h           |   6 +-
 drivers/gpu/drm/imx/dcss/dcss-kms.c                |   2 -
 drivers/gpu/drm/meson/meson_drv.c                  |   5 +-
 drivers/gpu/drm/meson/meson_viu.c                  |  22 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  22 +
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |  10 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/hid/hid-multitouch.c                       |  13 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   3 +-
 drivers/i2c/busses/i2c-imx.c                       |  20 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   5 +-
 drivers/infiniband/core/umem_dmabuf.c              |   8 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  25 +-
 drivers/infiniband/hw/mlx5/main.c                  |  34 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   1 -
 drivers/infiniband/sw/rxe/rxe_mr.c                 | 199 +++------
 drivers/infiniband/sw/rxe/rxe_mw.c                 |   6 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |   6 +
 drivers/infiniband/sw/rxe/rxe_task.c               |  16 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |  39 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |  21 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   7 +-
 drivers/input/keyboard/mt6779-keypad.c             |   8 +-
 drivers/input/misc/iqs7222.c                       | 178 +++++---
 drivers/input/touchscreen/exc3000.c                |   7 +-
 drivers/iommu/io-pgtable-arm-v7s.c                 |  75 +++-
 drivers/irqchip/irq-tegra.c                        |  10 +-
 drivers/md/md.c                                    |   1 +
 drivers/md/raid5.c                                 |   4 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |  10 +-
 drivers/misc/cxl/irq.c                             |   1 +
 drivers/misc/habanalabs/common/sysfs.c             |   2 +
 drivers/misc/habanalabs/gaudi/gaudi.c              |  50 ++-
 drivers/misc/habanalabs/goya/goya_hwmgr.c          |   2 +
 drivers/misc/uacce/uacce.c                         | 133 ++++--
 drivers/mmc/host/meson-gx-mmc.c                    |   6 +-
 drivers/mmc/host/pxamci.c                          |   4 +-
 drivers/mmc/host/renesas_sdhi.h                    |   1 +
 drivers/mmc/host/renesas_sdhi_core.c               |  34 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   6 +
 drivers/mmc/host/tmio_mmc.c                        |   2 +-
 drivers/mmc/host/tmio_mmc.h                        |   6 +-
 drivers/mmc/host/tmio_mmc_core.c                   |  28 +-
 drivers/net/can/spi/mcp251x.c                      |  18 +-
 drivers/net/can/usb/ems_usb.c                      |   2 +-
 drivers/net/dsa/microchip/ksz9477.c                |   3 +
 drivers/net/dsa/mv88e6060.c                        |   3 +
 drivers/net/dsa/ocelot/felix.c                     |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 491 ++++++++++++++++-----
 drivers/net/dsa/ocelot/seville_vsc9953.c           | 484 +++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_devlink.c          |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  21 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   3 +
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |   2 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |   8 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.c      |  15 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  22 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  12 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  15 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  57 ++-
 drivers/net/ethernet/intel/igb/igb.h               |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  12 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  15 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  19 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |  20 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  51 ++-
 drivers/net/ethernet/mscc/ocelot_net.c             |  55 +--
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         | 468 ++++++++++++++++----
 drivers/net/ethernet/mscc/vsc7514_regs.c           |  26 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   1 +
 drivers/net/geneve.c                               |  15 +-
 drivers/net/phy/phy-c45.c                          |  34 +-
 drivers/net/phy/phy_device.c                       |   6 +
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/tap.c                                  |  20 +-
 drivers/net/virtio_net.c                           |   9 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/ntb/test/ntb_tool.c                        |   8 +-
 drivers/nvme/host/fc.c                             |   3 +-
 drivers/nvme/target/tcp.c                          |   3 +-
 drivers/of/overlay.c                               |  11 +-
 drivers/pci/controller/pci-aardvark.c              |  33 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/phy/samsung/phy-exynos-pcie.c              |  25 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  14 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   4 +-
 drivers/pinctrl/pinctrl-amd.c                      |  11 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c             |   4 +-
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   2 +
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c        |   1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   7 +-
 drivers/platform/chrome/cros_ec_proto.c            |   8 +-
 drivers/rtc/rtc-spear.c                            |   2 +-
 drivers/s390/crypto/ap_bus.c                       |   3 +
 drivers/s390/crypto/ap_bus.h                       |   4 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  20 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 -
 drivers/spi/spi-meson-spicc.c                      | 129 ++++--
 drivers/staging/r8188eu/core/rtw_cmd.c             |  15 +-
 drivers/staging/r8188eu/core/rtw_efuse.c           |  33 +-
 drivers/staging/r8188eu/core/rtw_fw.c              |  72 ++-
 drivers/staging/r8188eu/core/rtw_led.c             |  16 +-
 drivers/staging/r8188eu/core/rtw_mlme_ext.c        |  62 ++-
 drivers/staging/r8188eu/core/rtw_pwrctrl.c         |   9 +-
 drivers/staging/r8188eu/core/rtw_wlan_util.c       |  20 +-
 drivers/staging/r8188eu/hal/Hal8188ERateAdaptive.c |  21 +-
 drivers/staging/r8188eu/hal/HalPhyRf_8188e.c       |  21 +-
 drivers/staging/r8188eu/hal/HalPwrSeqCmd.c         |   9 +-
 drivers/staging/r8188eu/hal/hal_com.c              |  27 +-
 drivers/staging/r8188eu/hal/rtl8188e_cmd.c         |  37 +-
 drivers/staging/r8188eu/hal/rtl8188e_dm.c          |   6 +-
 drivers/staging/r8188eu/hal/rtl8188e_hal_init.c    | 136 ++++--
 drivers/staging/r8188eu/hal/rtl8188e_phycfg.c      |  30 +-
 drivers/staging/r8188eu/hal/usb_halinit.c          | 251 +++++++++--
 drivers/staging/r8188eu/hal/usb_ops_linux.c        |  33 +-
 drivers/staging/r8188eu/include/rtw_io.h           |   6 +-
 drivers/staging/r8188eu/os_dep/ioctl_linux.c       |  47 +-
 drivers/staging/r8188eu/os_dep/os_intfs.c          |  19 +-
 drivers/thunderbolt/tmu.c                          |  13 +-
 drivers/tty/serial/ucc_uart.c                      |   2 +
 drivers/ufs/core/ufshcd.c                          |  11 +-
 drivers/ufs/host/ufs-exynos.c                      |  17 +-
 drivers/ufs/host/ufs-mediatek.c                    |  60 ++-
 drivers/usb/cdns3/cdns3-gadget.c                   |   2 +-
 drivers/usb/dwc2/gadget.c                          |   3 +-
 drivers/usb/gadget/function/uvc_queue.c            |  17 +-
 drivers/usb/gadget/function/uvc_video.c            |   2 +-
 drivers/usb/gadget/legacy/inode.c                  |   1 +
 drivers/usb/host/ohci-ppc-of.c                     |   1 +
 drivers/usb/renesas_usbhs/rza.c                    |   4 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   6 +
 drivers/vfio/vfio.c                                |   1 +
 drivers/video/fbdev/i740fb.c                       |   9 +-
 drivers/virt/vboxguest/vboxguest_linux.c           |   9 +-
 drivers/virtio/Kconfig                             |   3 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   4 +-
 fs/btrfs/block-group.c                             |   4 +-
 fs/btrfs/relocation.c                              |   7 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/ceph/caps.c                                     |  27 +-
 fs/ceph/mds_client.c                               |   7 +-
 fs/ceph/mds_client.h                               |   6 -
 fs/cifs/misc.c                                     |   6 +
 fs/cifs/smb2ops.c                                  |   5 +-
 fs/ext4/mballoc.c                                  |  21 +-
 fs/ext4/namei.c                                    |   7 +-
 fs/ext4/resize.c                                   |  10 +
 fs/f2fs/f2fs.h                                     |   6 +
 fs/f2fs/file.c                                     |  32 +-
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/segment.c                                  |  17 +-
 fs/fscache/cookie.c                                |   7 +-
 fs/nfs/nfs4idmap.c                                 |  46 +-
 fs/nfs/nfs4proc.c                                  |  20 +-
 fs/ntfs3/fslog.c                                   |   2 +-
 fs/ntfs3/fsntfs.c                                  |   7 +-
 fs/ntfs3/index.c                                   |   2 +-
 fs/ntfs3/inode.c                                   |   1 +
 fs/ntfs3/super.c                                   |   8 +-
 fs/ntfs3/xattr.c                                   |  22 +-
 fs/overlayfs/super.c                               |   7 +-
 include/asm-generic/bitops/atomic.h                |   6 -
 include/linux/bpfptr.h                             |   8 +-
 include/linux/io-pgtable.h                         |  15 +-
 include/linux/nmi.h                                |   2 +
 include/linux/sunrpc/xdr.h                         |   4 +-
 include/linux/sunrpc/xprt.h                        |   3 +-
 include/linux/uacce.h                              |   6 +-
 include/linux/usb/typec_mux.h                      |  44 +-
 include/net/mptcp.h                                |   4 +
 include/net/netns/conntrack.h                      |   2 +-
 include/soc/mscc/ocelot.h                          | 113 ++++-
 include/sound/control.h                            |   2 +-
 include/sound/core.h                               |   8 +
 include/sound/pcm.h                                |   2 +-
 include/uapi/linux/atm_zatm.h                      |  47 ++
 include/uapi/linux/f2fs.h                          |   2 +-
 include/ufs/ufshcd.h                               |  12 +
 kernel/bpf/arraymap.c                              |   6 +
 kernel/bpf/hashtab.c                               |   8 +-
 kernel/bpf/syscall.c                               |  20 +-
 kernel/dma/swiotlb.c                               |   6 +-
 kernel/trace/trace_eprobe.c                        |  91 +++-
 kernel/trace/trace_event_perf.c                    |   7 +-
 kernel/trace/trace_events.c                        |   1 +
 kernel/trace/trace_probe.c                         |  29 +-
 kernel/watchdog.c                                  |  21 +-
 lib/list_debug.c                                   |  12 +-
 net/can/j1939/socket.c                             |   5 +-
 net/can/j1939/transport.c                          |   8 +-
 net/core/bpf_sk_storage.c                          |  12 +-
 net/core/devlink.c                                 |   4 +-
 net/core/gen_stats.c                               |   2 +-
 net/core/rtnetlink.c                               |   1 +
 net/core/sock_map.c                                |  20 +-
 net/dsa/port.c                                     |   7 +-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/ndisc.c                                   |   3 +
 net/mptcp/protocol.c                               |  47 +-
 net/mptcp/protocol.h                               |  13 +-
 net/mptcp/subflow.c                                |   3 +-
 net/netfilter/nf_conntrack_ftp.c                   |  24 +-
 net/netfilter/nf_conntrack_h323_main.c             |  10 +-
 net/netfilter/nf_conntrack_irc.c                   |  12 +-
 net/netfilter/nf_conntrack_sane.c                  |  68 ++-
 net/netfilter/nf_tables_api.c                      |  74 +++-
 net/netfilter/nf_tables_core.c                     |  21 +-
 net/netfilter/nfnetlink.c                          |  83 +++-
 net/netlink/genetlink.c                            |   6 +-
 net/netlink/policy.c                               |  14 +-
 net/qrtr/mhi.c                                     |  12 +-
 net/rds/ib_recv.c                                  |   1 +
 net/sunrpc/auth.c                                  |   2 +-
 net/sunrpc/backchannel_rqst.c                      |  14 +
 net/sunrpc/clnt.c                                  |   1 -
 net/sunrpc/sysfs.c                                 |   6 +-
 net/sunrpc/xprt.c                                  |  27 +-
 net/sunrpc/xprtsock.c                              |  12 +-
 net/vmw_vsock/af_vsock.c                           |  10 +-
 scripts/Makefile.gcc-plugins                       |   2 +-
 scripts/dummy-tools/gcc                            |   8 +-
 scripts/mod/modpost.c                              |   4 +-
 scripts/module.lds.S                               |   2 +
 security/apparmor/apparmorfs.c                     |   2 +-
 security/apparmor/audit.c                          |   2 +-
 security/apparmor/domain.c                         |   2 +-
 security/apparmor/include/lib.h                    |   5 +
 security/apparmor/include/policy.h                 |   2 +-
 security/apparmor/label.c                          |  13 +-
 security/apparmor/mount.c                          |   8 +-
 security/apparmor/policy_unpack.c                  |  12 +-
 sound/core/control.c                               |   7 +-
 sound/core/info.c                                  |   6 +-
 sound/core/misc.c                                  |  94 ++++
 sound/core/pcm.c                                   |   1 +
 sound/core/pcm_lib.c                               |   2 +-
 sound/core/pcm_native.c                            |   2 +-
 sound/core/timer.c                                 |  11 +-
 sound/pci/hda/hda_codec.c                          |  14 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/codecs/lpass-va-macro.c                  |  11 +-
 sound/soc/codecs/nau8821.c                         |  10 -
 sound/soc/codecs/tas2770.c                         |  98 ++--
 sound/soc/codecs/tas2770.h                         |   5 +
 sound/soc/codecs/tlv320aic32x4.c                   |   9 +
 sound/soc/intel/avs/core.c                         |   1 +
 sound/soc/intel/avs/pcm.c                          |   4 +-
 sound/soc/intel/boards/sof_es8336.c                |  35 +-
 sound/soc/intel/boards/sof_nau8825.c               |  10 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   6 +
 sound/soc/sh/rcar/ssiu.c                           |   2 +
 sound/soc/soc-pcm.c                                |   3 +
 sound/soc/sof/debug.c                              |   6 +-
 sound/soc/sof/intel/cnl.c                          |  37 +-
 sound/soc/sof/intel/hda-ipc.c                      |  39 +-
 sound/soc/sof/intel/hda.c                          |   9 +-
 sound/soc/sof/sof-client-probes.c                  |   4 +
 sound/usb/card.c                                   |   8 +
 sound/usb/mixer_maps.c                             |  34 +-
 tools/build/feature/test-libcrypto.c               |  15 +-
 tools/lib/bpf/skel_internal.h                      |   4 +-
 tools/objtool/check.c                              |   3 +-
 tools/perf/tests/switch-tracking.c                 |  18 +-
 tools/perf/util/parse-events.c                     |  14 +-
 tools/perf/util/probe-event.c                      |   6 +-
 tools/testing/cxl/test/cxl.c                       |   1 -
 tools/testing/cxl/test/mock.c                      |   8 +-
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |   1 -
 .../net/forwarding/custom_multipath_hash.sh        |  24 +-
 .../net/forwarding/gre_custom_multipath_hash.sh    |  24 +-
 .../net/forwarding/ip6gre_custom_multipath_hash.sh |  24 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  26 +-
 tools/tracing/rtla/Makefile                        |   4 +-
 tools/vm/slabinfo.c                                |  32 +-
 virt/kvm/kvm_main.c                                |  14 +-
 391 files changed, 5480 insertions(+), 2432 deletions(-)


