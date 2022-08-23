Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC259D6F0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349649AbiHWJ3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349619AbiHWJ1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19ED77556;
        Tue, 23 Aug 2022 01:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 537EC614DA;
        Tue, 23 Aug 2022 08:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9422C433C1;
        Tue, 23 Aug 2022 08:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243751;
        bh=owgVv++Gr2vyWaYkiDCArIfwh193zBoY3VrfioD9zN0=;
        h=From:To:Cc:Subject:Date:From;
        b=aGUH295cvs/nYWdwW2cN4rKdC5rP37TJIqXsroFOJ6g0ZX3Tpj+4/eNN9xKxXHWp3
         jwY/PDC2HVgF5deeYv0Wi1F4JW8W5q5F9KBI2IpD83Vlrknrw5f/Lv1IS5WOTRPq8L
         TlvwDTp8D2m3rPe0k3m8MRkt7ls3zsAswJl+x1Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/244] 5.15.63-rc1 review
Date:   Tue, 23 Aug 2022 10:22:39 +0200
Message-Id: <20220823080059.091088642@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.63-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.63-rc1
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

This is the start of the stable review cycle for the 5.15.63 release.
There are 244 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.63-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.63-rc1

Darrick J. Wong <djwong@kernel.org>
    xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*

Eric Sandeen <sandeen@redhat.com>
    xfs: revert "xfs: actually bump warning counts when we send warnings"

Brian Foster <bfoster@redhat.com>
    xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong <djwong@kernel.org>
    xfs: fix overfilling of reserve pool

Darrick J. Wong <djwong@kernel.org>
    xfs: always succeed at setting the reserve pool size

Darrick J. Wong <djwong@kernel.org>
    xfs: remove infinite loop when reserving free block pool

Darrick J. Wong <djwong@kernel.org>
    xfs: reserve quota for target dir expansion when renaming files

Darrick J. Wong <djwong@kernel.org>
    xfs: reserve quota for dir expansion when linking/unlinking files

Brian Foster <bfoster@redhat.com>
    xfs: flush inodegc workqueue tasks before cancel

Ren Zhijie <renzhijie2@huawei.com>
    scsi: ufs: ufs-mediatek: Fix build error and type mismatch

Fedor Pchelkin <pchelkin@ispras.ru>
    can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()

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
    ALSA: timer: Use deferred fasync helper

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add async signal helpers

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/ioda/iommu/debugfs: Generate unique debugfs entries

Miklos Szeredi <mszeredi@redhat.com>
    ovl: warn if trusted xattr creation fails

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Don't always pass -mcpu=powerpc to the compiler

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Set an IBAT covering up to _einittext during init

Laurent Dufour <ldufour@linux.ibm.com>
    watchdog: export lockup_detector_reconfigure

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Add fast call path of crash_kexec()

Celeste Liu <coelacanthus@outlook.com>
    riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: canaan: Add k210 topology information

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: sifive: Add fu740 topology information

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: sifive: Add fu540 topology information

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: care default case on rsnd_ssiu_busif_err_irq_ctrl()

Helge Deller <deller@gmx.de>
    modules: Ensure natural alignment for .altinstructions and __bug_table sections

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

Guenter Roeck <linux@roeck-us.net>
    lib/list_debug.c: Detect uninitialized lists

Kiselev, Oleg <okiselev@amazon.com>
    ext4: avoid resizing to a partial cluster size

Ye Bin <yebin10@huawei.com>
    ext4: avoid remove directory when directory is corrupted

Wentao_Liang <Wentao_Liang_g@163.com>
    drivers:md:fix a potential use-after-free bug

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix lockdep complaint on nvmet_tcp_wq flush during queue teardown

Logan Gunthorpe <logang@deltatee.com>
    md: Notify sysfs sync_completed in md_reap_sync_thread()

Marek Szyprowski <m.szyprowski@samsung.com>
    phy: samsung: phy-exynos-pcie: sanitize init/power_on callbacks

Stafford Horne <shorne@gmail.com>
    openrisc: io: Define iounmap argument as volatile

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Steven Rostedt (Google) <rostedt@goodmis.org>
    selftests/kprobe: Do not test for GRP/ without event failures

Liao Chang <liaochang1@huawei.com>
    csky/kprobe: reclaim insn_slot on kprobe unregistration

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Limit the number of calls to each tasklet

Ben Dooks <ben.dooks@sifive.com>
    dmaengine: dw-axi-dmac: ignore interrupt if no descriptor

Ben Dooks <ben.dooks@sifive.com>
    dmaengine: dw-axi-dmac: do not print NULL LLI during error

Jason A. Donenfeld <Jason@zx2c4.com>
    um: add "noreboot" command line option for PANIC_TIMEOUT=-1 setups

Huacai Chen <chenhuacai@kernel.org>
    PCI/ACPI: Guard ARM64-specific mcfg_quirks

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cxl: Fix a memory leak in an error handling path

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Check against matching data instead of ACPI companion

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: tmio: avoid glitches when resetting

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: mask constant value before cast

Ofir Bitton <obitton@habana.ai>
    habanalabs/gaudi: fix shift out of bounds

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

Liang He <windhl@126.com>
    usb: renesas: Fix refcount leak bug

Liang He <windhl@126.com>
    usb: host: ohci-ppc-of: Fix refcount leak bug

Po-Wen Kao <powen.kao@mediatek.com>
    scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators

Tony Lindgren <tony@atomide.com>
    clk: ti: Stop using legacy clkctrl names for omap4 and 5

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    drm/meson: Fix overflow implicit truncation warnings

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    irqchip/tegra: Fix overflow implicit truncation warnings

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting Slot capabilities on emulated bridge

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: calculate the number of request depending on framesize

Frank Li <Frank.Li@nxp.com>
    usb: cdns3: fix random warning message when driver load

Frank Li <Frank.Li@nxp.com>
    usb: cdns3 fix use-after-free at workaround 2

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_proto: don't show MKBP version if unsupported

Pavan Chebbi <pavan.chebbi@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM5750x NICs

Tao Jin <tao-j@outlook.com>
    HID: multitouch: new device class fix Lenovo X12 trackpad sticky

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems

Maxim Kochetkov <fido_max@inbox.ru>
    net: qrtr: start MHI channel after endpoit creation

Samuel Holland <samuel@sholland.org>
    drm/sun4i: dsi: Prevent underflow when computing packet sizes

Liang He <windhl@126.com>
    drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()

Takashi Iwai <tiwai@suse.de>
    ASoC: SOF: Intel: hda: Fix potential buffer overflow by snprintf()

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: Define rom_status_reg in sof_intel_dsp_desc

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    drm/imx/dcss: get rid of HPD warning message

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/eprobes: Fix reading of string fields

Andrew Donnellan <ajd@linux.ibm.com>
    gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix the modules order between drivers and libs

Lin Ma <linma@zju.edu.cn>
    igb: Add lock to avoid data race

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()

Csókás Bence <csokas.bence@prolan.hu>
    fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Alan Brady <alan.brady@intel.com>
    i40e: Fix to stop tx_timeout recovery if GLOBR fails

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Remove restrictions for regulator-name

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    i2c: imx: Make sure to unregister adapter on remove()

Grzegorz Siwik <grzegorz.siwik@intel.com>
    ice: Ignore EEXIST when setting promisc mode

Rustam Subkhankulov <subkhankulov@ispras.ru>
    net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it

Jakub Kicinski <kuba@kernel.org>
    net: genl: fix error path memory leak in policy dumping

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry

Xin Xiong <xiongx18@fudan.edu.cn>
    net: fix potential refcount leak in ndisc_router_discovery()

Sergei Antonov <saproj@gmail.com>
    net: moxa: pass pdev instead of ndev to DMA functions

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: really skip inactive sets when allocating name

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: possible module reference underflow in error path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag

Dan Carpenter <dan.carpenter@oracle.com>
    fs/ntfs3: uninitialized variable in ntfs_set_acl_ex()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access

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
    ASoC: SOF: debug: Fix potential buffer overflow by snprintf()

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix reset error handling

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    perf probe: Fix an error handling path in 'parse_perf_probe_command()'

Matthias May <matthias.may@westermo.com>
    geneve: fix TOS inheriting for ipv4

Duoming Zhou <duoming@zju.edu.cn>
    atm: idt77252: fix use-after-free bugs caused by tst_timer

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

Jeff Layton <jlayton@kernel.org>
    ceph: don't leak snap_rwsem in handle_cap_grant

Yuanzheng Song <songyuanzheng@huawei.com>
    tools/vm/slabinfo: use alphabetic order when two values are equal

Luís Henriques <lhenriques@suse.de>
    ceph: use correct index when encoding client supported features

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: dt-bindings: zynqmp-qspi: add missing 'required'

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: dt-bindings: cadence: add missing 'required'

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

Miaoqian Lin <linmq006@gmail.com>
    Input: exc3000 - fix return value check of wait_for_completion_timeout

Jianhua Lu <lujianhua000@gmail.com>
    pinctrl: qcom: sm8250: Fix PDC map

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: Add I/O bias setting for H6 R-PIO

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    pinctrl: amd: Don't save/restore interrupt status and wake status bits

Nikita Travkin <nikita@trvn.ru>
    pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: arm: qcom: fix Alcatel OneTouch Idol 3 compatibles

Ido Schimmel <idosch@nvidia.com>
    selftests: forwarding: Fix failing tests with old libnet

Sandor Bodo-Merle <sbodomerle@gmail.com>
    net: bgmac: Fix a BUG triggered by wrong bytes_compl

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Indicate MAC is in charge of PHY PM

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Warn about incorrect mdio_bus_phy_resume() state

Ido Schimmel <idosch@nvidia.com>
    devlink: Fix use-after-free after a failed reload

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_net: fix memory leak inside XPD_TX with mergeable

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

Jinghao Jia <jinghao@linux.ibm.com>
    BPF: Fix potential bad pointer dereference in bpf_sys_bpf()

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

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: More comprehensive mixer map for ASUS ROG Zenith II

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have filter accept "common_cpu" to be consistent

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/probes: Have kprobes and uprobes use $COMM too

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/eprobes: Have event probes be consistent with kprobes and uprobes

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

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Check correct bounds for stream encoder instances for DCN303

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/ttm: Fix dummy res NULL ptr deref bug

Karol Herbst <kherbst@redhat.com>
    drm/nouveau: recognise GA103

Hector Martin <marcan@marcan.st>
    locking/atomic: Make test_and_*_bit() ordered on failure

Mikulas Patocka <mpatocka@redhat.com>
    rds: add missing barrier to release_refill

Aaron Lu <aaron.lu@intel.com>
    x86/mm: Use proper mask when setting PUD mapping

Sean Christopherson <seanjc@google.com>
    KVM: Unconditionally get a ref to /dev/kvm module when creating a VM

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/realtek: Add quirk for Clevo NS50PU, NS70PU

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: info: Fix llseek return value when using callback


-------------

Diffstat:

 Documentation/atomic_bitops.txt                    |   2 +-
 Documentation/devicetree/bindings/arm/qcom.yaml    |  18 +-
 .../bindings/clock/qcom,gcc-msm8996.yaml           |  16 ++
 .../devicetree/bindings/gpio/gpio-zynq.yaml        |   6 +-
 .../bindings/regulator/nxp,pca9450-regulator.yaml  |  11 --
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
 arch/nios2/kernel/entry.S                          |  22 ++-
 arch/nios2/kernel/signal.c                         |   3 +-
 arch/nios2/kernel/syscall_table.c                  |   1 +
 arch/openrisc/include/asm/io.h                     |   2 +-
 arch/openrisc/mm/ioremap.c                         |   2 +-
 arch/powerpc/Makefile                              |  26 +--
 arch/powerpc/kernel/head_book3s_32.S               |   4 +-
 arch/powerpc/kernel/pci-common.c                   |  16 +-
 arch/powerpc/kernel/prom.c                         |   7 +
 arch/powerpc/kvm/book3s_hv_p9_entry.c              |  13 +-
 arch/powerpc/mm/book3s32/mmu.c                     |  10 +-
 arch/powerpc/platforms/Kconfig.cputype             |  21 ++-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   2 +
 arch/riscv/boot/dts/canaan/k210.dtsi               |  12 ++
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi         |  24 +++
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi         |  24 +++
 arch/riscv/kernel/sys_riscv.c                      |   5 +-
 arch/riscv/kernel/traps.c                          |   4 +
 arch/um/kernel/um_arch.c                           |   4 +
 arch/um/os-Linux/skas/process.c                    |  17 +-
 arch/x86/kernel/kprobes/core.c                     |   2 +-
 arch/x86/mm/init_64.c                              |   2 +-
 drivers/acpi/pci_mcfg.c                            |   3 +
 drivers/acpi/property.c                            |   8 +-
 drivers/ata/libata-eh.c                            |   1 +
 drivers/atm/idt77252.c                             |   1 +
 drivers/block/zram/zcomp.c                         |  11 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |   1 +
 drivers/clk/ti/clk-44xx.c                          | 210 ++++++++++-----------
 drivers/clk/ti/clk-54xx.c                          | 160 ++++++++--------
 drivers/clk/ti/clkctrl.c                           |   4 -
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  11 ++
 drivers/dma/sprd-dma.c                             |   5 +-
 .../drm/amd/display/dc/dcn303/dcn303_resource.c    |   2 +-
 drivers/gpu/drm/imx/dcss/dcss-kms.c                |   2 -
 drivers/gpu/drm/meson/meson_drv.c                  |   5 +-
 drivers/gpu/drm/meson/meson_viu.c                  |  22 +--
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  22 +++
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |  10 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/hid/hid-multitouch.c                       |  13 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   3 +-
 drivers/i2c/busses/i2c-imx.c                       |  20 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |   6 +
 drivers/infiniband/sw/rxe/rxe_task.c               |  16 +-
 drivers/input/touchscreen/exc3000.c                |   7 +-
 drivers/iommu/io-pgtable-arm-v7s.c                 |  75 ++++++--
 drivers/irqchip/irq-tegra.c                        |  10 +-
 drivers/md/md.c                                    |   1 +
 drivers/md/raid5.c                                 |   2 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |  10 +-
 drivers/misc/cxl/irq.c                             |   1 +
 drivers/misc/habanalabs/gaudi/gaudi.c              |  24 +--
 drivers/misc/uacce/uacce.c                         | 133 ++++++++-----
 drivers/mmc/host/meson-gx-mmc.c                    |   6 +-
 drivers/mmc/host/pxamci.c                          |   4 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  29 ++-
 drivers/mmc/host/tmio_mmc.c                        |   2 +-
 drivers/mmc/host/tmio_mmc.h                        |   6 +-
 drivers/mmc/host/tmio_mmc_core.c                   |  28 ++-
 drivers/net/can/spi/mcp251x.c                      |  18 +-
 drivers/net/can/usb/ems_usb.c                      |   2 +-
 drivers/net/dsa/microchip/ksz9477.c                |   3 +
 drivers/net/dsa/mv88e6060.c                        |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   3 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c          |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  21 +--
 drivers/net/ethernet/broadcom/bgmac.c              |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   3 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.c      |  15 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   2 +-
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
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   1 +
 drivers/net/geneve.c                               |  15 +-
 drivers/net/phy/phy_device.c                       |   6 +
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/virtio_net.c                           |   5 +-
 drivers/ntb/test/ntb_tool.c                        |   8 +-
 drivers/nvme/target/tcp.c                          |   3 +-
 drivers/pci/controller/pci-aardvark.c              |  33 +++-
 drivers/pci/quirks.c                               |   3 +
 drivers/phy/samsung/phy-exynos-pcie.c              |  25 +--
 drivers/pinctrl/intel/pinctrl-intel.c              |  14 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   4 +-
 drivers/pinctrl/pinctrl-amd.c                      |  11 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c             |   4 +-
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c        |   1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   7 +-
 drivers/platform/chrome/cros_ec_proto.c            |   8 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  20 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |  60 +++++-
 drivers/spi/spi-meson-spicc.c                      | 129 ++++++++++---
 drivers/tty/serial/ucc_uart.c                      |   2 +
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +-
 drivers/usb/dwc2/gadget.c                          |   3 +-
 drivers/usb/gadget/function/uvc_queue.c            |  17 +-
 drivers/usb/gadget/function/uvc_video.c            |   2 +-
 drivers/usb/gadget/legacy/inode.c                  |   1 +
 drivers/usb/host/ohci-ppc-of.c                     |   1 +
 drivers/usb/renesas_usbhs/rza.c                    |   4 +
 drivers/vfio/vfio.c                                |   1 +
 drivers/video/fbdev/i740fb.c                       |   9 +-
 drivers/virt/vboxguest/vboxguest_linux.c           |   9 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   4 +-
 fs/btrfs/block-group.c                             |   4 +-
 fs/btrfs/relocation.c                              |   7 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/ceph/caps.c                                     |  27 ++-
 fs/ceph/mds_client.c                               |   7 +-
 fs/ceph/mds_client.h                               |   6 -
 fs/cifs/misc.c                                     |   6 +
 fs/cifs/smb2ops.c                                  |   5 +-
 fs/ext4/namei.c                                    |   7 +-
 fs/ext4/resize.c                                   |  10 +
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/segment.c                                  |  13 ++
 fs/nfs/nfs4idmap.c                                 |  46 ++---
 fs/nfs/nfs4proc.c                                  |  20 +-
 fs/ntfs3/fslog.c                                   |   2 +-
 fs/ntfs3/fsntfs.c                                  |   7 +-
 fs/ntfs3/index.c                                   |   2 +-
 fs/ntfs3/inode.c                                   |   1 +
 fs/ntfs3/super.c                                   |   8 +-
 fs/ntfs3/xattr.c                                   |  22 +--
 fs/overlayfs/super.c                               |   7 +-
 fs/xfs/xfs_filestream.c                            |   7 +-
 fs/xfs/xfs_fsops.c                                 |  50 ++---
 fs/xfs/xfs_icache.c                                |  22 +--
 fs/xfs/xfs_inode.c                                 |  79 +++++---
 fs/xfs/xfs_ioctl.c                                 |   2 +-
 fs/xfs/xfs_trans.c                                 |  86 +++++++++
 fs/xfs/xfs_trans.h                                 |   3 +
 fs/xfs/xfs_trans_dquot.c                           |   1 -
 include/asm-generic/bitops/atomic.h                |   6 -
 include/linux/bpfptr.h                             |   8 +-
 include/linux/io-pgtable.h                         |  15 +-
 include/linux/nmi.h                                |   2 +
 include/linux/sunrpc/xdr.h                         |   4 +-
 include/linux/uacce.h                              |   6 +-
 include/sound/control.h                            |   2 +-
 include/sound/core.h                               |   8 +
 kernel/bpf/arraymap.c                              |   6 +
 kernel/bpf/hashtab.c                               |   8 +-
 kernel/trace/trace_eprobe.c                        |  88 ++++++++-
 kernel/trace/trace_event_perf.c                    |   7 +-
 kernel/trace/trace_events.c                        |   1 +
 kernel/trace/trace_probe.c                         |  29 +--
 kernel/watchdog.c                                  |  21 ++-
 lib/list_debug.c                                   |  12 +-
 net/can/j1939/socket.c                             |   5 +-
 net/can/j1939/transport.c                          |   8 +-
 net/core/bpf_sk_storage.c                          |  12 +-
 net/core/devlink.c                                 |   4 +-
 net/core/sock_map.c                                |  20 +-
 net/dsa/port.c                                     |   7 +-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/ndisc.c                                   |   3 +
 net/netfilter/nf_tables_api.c                      |  70 +++++--
 net/netlink/genetlink.c                            |   6 +-
 net/netlink/policy.c                               |  14 +-
 net/qrtr/mhi.c                                     |  12 +-
 net/rds/ib_recv.c                                  |   1 +
 net/sunrpc/auth.c                                  |   2 +-
 net/sunrpc/backchannel_rqst.c                      |  14 ++
 net/sunrpc/sysfs.c                                 |   6 +-
 net/vmw_vsock/af_vsock.c                           |  10 +-
 scripts/Makefile.gcc-plugins                       |   2 +-
 .../dummy-plugin-dir/include/plugin-version.h      |   0
 scripts/dummy-tools/gcc                            |   8 +-
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
 sound/core/misc.c                                  |  94 +++++++++
 sound/core/timer.c                                 |  11 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/tas2770.c                         |  98 +++++-----
 sound/soc/codecs/tas2770.h                         |   5 +
 sound/soc/codecs/tlv320aic32x4.c                   |   9 +
 sound/soc/sh/rcar/ssiu.c                           |   2 +
 sound/soc/sof/debug.c                              |   6 +-
 sound/soc/sof/intel/apl.c                          |   1 +
 sound/soc/sof/intel/cnl.c                          |   2 +
 sound/soc/sof/intel/hda-loader.c                   |  14 +-
 sound/soc/sof/intel/hda.c                          |  10 +-
 sound/soc/sof/intel/icl.c                          |   1 +
 sound/soc/sof/intel/shim.h                         |   1 +
 sound/soc/sof/intel/tgl.c                          |   4 +
 sound/usb/card.c                                   |   8 +
 sound/usb/mixer_maps.c                             |  34 +++-
 tools/build/feature/test-libcrypto.c               |  15 +-
 tools/perf/tests/switch-tracking.c                 |  18 +-
 tools/perf/util/parse-events.c                     |  14 +-
 tools/perf/util/probe-event.c                      |   6 +-
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |   1 -
 .../net/forwarding/custom_multipath_hash.sh        |  24 ++-
 .../net/forwarding/gre_custom_multipath_hash.sh    |  24 ++-
 .../net/forwarding/ip6gre_custom_multipath_hash.sh |  24 ++-
 tools/vm/slabinfo.c                                |  32 +++-
 virt/kvm/kvm_main.c                                |  14 +-
 244 files changed, 2188 insertions(+), 1064 deletions(-)


