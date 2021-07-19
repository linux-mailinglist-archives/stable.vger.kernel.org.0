Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28493CED5D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 22:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357370AbhGSSWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 14:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351616AbhGSSF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 14:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48C1060232;
        Mon, 19 Jul 2021 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626720285;
        bh=bPfaO9N2974K/q7UwCpEJfOpXpint5LBaWXN8NKw77A=;
        h=From:To:Cc:Subject:Date:From;
        b=G17FVqTGaW2buCMUayC+cWyeEJo9VLwGd/Q6P1fP/O0dO1mQeCu1O9T06P+p8ia2g
         YMCijSE2ZSPbwHQZn1xgThkxb9Sr6AgUJHwGrmYVkHQJ1XKm3onu5hZq/DtGzptQI0
         XSDHDxTVBY3H08Vhj4RtAKagQKA/074MJs4lWImA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/349] 5.13.4-rc2 review
Date:   Mon, 19 Jul 2021 20:44:42 +0200
Message-Id: <20210719184345.989046417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.4-rc2
X-KernelTest-Deadline: 2021-07-21T18:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.4 release.
There are 349 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.4-rc2

Tong Zhang <ztong0001@gmail.com>
    misc: alcor_pci: fix inverted branch condition

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: scsi_dh_alua: Fix signedness bug in alua_rtpg()

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: CPPC: Fix potential memleak in cppc_cpufreq_cpu_init

Jin Yao <yao.jin@linux.intel.com>
    perf tools: Fix pattern matching for same substring in different PMU type

Martin Fäcknitz <faecknitz@hotsplots.de>
    MIPS: vdso: Invalid GIC access through VDSO

Sven Schnelle <svens@linux.ibm.com>
    s390/irq: remove HAVE_IRQ_EXIT_ON_IRQ_STACK

Kajol Jain <kjain@linux.ibm.com>
    perf script python: Fix buffer size to report iregs in perf script

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix --task and --stat with pipe input

Randy Dunlap <rdunlap@infradead.org>
    mips: disable branch profiling in boot/decompress.o

Arnd Bergmann <arnd@arndb.de>
    mips: always link byteswap helpers into decompressor

Peter Zijlstra <peterz@infradead.org>
    kprobe/static_call: Restore missing static_call_text_reserved()

Peter Zijlstra <peterz@infradead.org>
    static_call: Fix static_call_text_reserved() vs __init

Peter Zijlstra <peterz@infradead.org>
    jump_label: Fix jump_label_text_reserved() vs __init

Xuewen Yan <xuewen.yan@unisoc.com>
    sched/uclamp: Ignore max aggregation if rq is idle

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Re-add regulator-always-on for vcc_sdio for rk3399-roc-pc

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Re-add regulator-boot-on, regulator-always-on for vdd_gpu on rk3399-roc-pc

Pali Rohár <pali@kernel.org>
    firmware: turris-mox-rwtm: show message about HWRNG registration

Pali Rohár <pali@kernel.org>
    firmware: turris-mox-rwtm: fail probing when firmware does not support hwrng

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: report failures better

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: fix reply status decoding function

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: remove trailing slashes from $(KBUILD_EXTMOD)

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    thermal/drivers/rcar_gen3_thermal: Fix coefficient calculations

Aswath Govindraju <a-govindraju@ti.com>
    arm64: dts: ti: k3-am642-evm: align ti,pindir-d0-out-d1-in property with dt-shema

Aswath Govindraju <a-govindraju@ti.com>
    arm64: dts: ti: am65: align ti,pindir-d0-out-d1-in property with dt-shema

Grygorii Strashko <grygorii.strashko@ti.com>
    arm64: dts: ti: k3-am642-main: fix ports mac properties

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    ARM: dts: imx6q-dhcom: Add gpios pinctrl for i2c bus recovery

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    ARM: dts: imx6q-dhcom: Fix ethernet plugin detection problems

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    ARM: dts: imx6q-dhcom: Fix ethernet reset time properties

Chunyan Zhang <chunyan.zhang@unisoc.com>
    thermal/drivers/sprd: Add missing MODULE_DEVICE_TABLE

Aswath Govindraju <a-govindraju@ti.com>
    ARM: dts: am437x: align ti,pindir-d0-out-d1-in property with dt-shema

Aswath Govindraju <a-govindraju@ti.com>
    ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema

Gowtham Tammana <g-tammana@ti.com>
    ARM: dts: dra7: Fix duplicate USB4 target module node

Icenowy Zheng <icenowy@aosc.io>
    arm64: dts: allwinner: a64-sopine-baseboard: change RGMII mode to TXID

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: fsl_ifc: fix leak of private memory on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: fsl_ifc: fix leak of IO mapping on probe failure

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-common-proc-board: Re-name "link" name as "phy"

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-common-proc-board: Use external clock for SERDES

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-main: Fix external refclk input to SERDES

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add delayed response status check

Stefan Wahren <stefan.wahren@i2se.com>
    Revert "ARM: dts: bcm283x: increase dwc2's RX FIFO size"

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779a0: Drop power-domains property from GIC node

Philipp Zabel <p.zabel@pengutronix.de>
    reset: bail if try_module_get() fails

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fixup SPI binding

Nicolas Ferre <nicolas.ferre@microchip.com>
    dt-bindings: i2c: at91: fix example for scl-gpios

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Reset Rx buffer to max size during async commands

Weiyi Lu <weiyi.lu@mediatek.com>
    soc: mtk-pm-domains: Fix the clock prepared issue

Hsin-Yi Wang <hsinyi@chromium.org>
    soc: mtk-pm-domains: do not register smi node as syscon

Zhen Lei <thunder.leizhen@huawei.com>
    firmware: tegra: Fix error return code in tegra210_bpmp_init()

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sc7180: Fix sc7180-qmp-usb3-dp-phy reg sizes

Stephen Boyd <swboyd@chromium.org>
    arm64: dts: qcom: c630: Add no-hpd to DSI bridge node

Stephen Boyd <swboyd@chromium.org>
    arm64: dts: qcom: trogdor: Add no-hpd to DSI bridge node

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a7796[01]: Fix OPP table entry voltages

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: Add missing opp-suspend properties

Manivannan Sadhasivam <mani@kernel.org>
    ARM: dts: qcom: sdx55-telit: Represent secure-regions as 64-bit elements

Manivannan Sadhasivam <mani@kernel.org>
    ARM: dts: qcom: sdx55-t55: Represent secure-regions as 64-bit elements

Roger Quadros <rogerq@ti.com>
    arm64: dts: ti: j7200-main: Enable USB2 PHY RX sensitivity workaround

Aswath Govindraju <a-govindraju@ti.com>
    arm64: dts: ti: k3-j7200: Remove "#address-cells" property from GPIO DT nodes

Aswath Govindraju <a-govindraju@ti.com>
    arm64: dts: ti: k3-am64-mcu: Fix the compatible string in GPIO DT node

Caleb Connolly <caleb@connolly.tech>
    arm64: dts: qcom: sdm845-oneplus-common: guard rmtfs-mem

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7779, marzen: Fix DU clock names

Valentine Barshak <valentine.barshak@cogentembedded.com>
    arm64: dts: renesas: v3msk: Fix memory size

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: fix snprintf() checking in is_rtc_hctosys()

Arnd Bergmann <arnd@arndb.de>
    rtc: bd70528: fix BD71815 watchdog dependency

Salvatore Bonaccorso <carnil@debian.org>
    ARM: dts: sun8i: h3: orangepi-plus: Fix ethernet phy-mode

Zhen Lei <thunder.leizhen@huawei.com>
    memory: pl353: Fix error return code in pl353_smc_probe()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    arm64: defconfig: Do not override the MTK_PMIC_WRAP symbol

Zou Wei <zou_wei@huawei.com>
    reset: brcmstb: Add missing MODULE_DEVICE_TABLE

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: atmel-ebi: add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: stm32-fmc2-ebi: add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid HC1

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: exynos: add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    reset: a10sr: add missing of_match_table reference

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: RESET_INTEL_GW should depend on X86

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: RESET_BRCMSTB_RESCAL should depend on ARCH_BRCMSTB

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Drop fephy pinctrl from gmac2phy on rk3328 rock-pi-e

Tianling Shen <cnsztl@gmail.com>
    arm64: dts: rockchip: rename LED label for NanoPi R4S

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: gemini-rut1xx: remove duplicate ethernet node

Nathan Chancellor <nathan@kernel.org>
    hexagon: use common DISCARDS macro

Nathan Chancellor <nathan@kernel.org>
    hexagon: handle {,SOFT}IRQENTRY_TEXT in linker script

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Don't call _nfs4_pnfs_v3_ds_connect multiple times

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Fix layoutget behaviour after invalidation

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Fix the layout barrier update

Dave Wysochanski <dwysocha@redhat.com>
    NFS: Fix fscache read from NFS after cache error

David Hildenbrand <david@redhat.com>
    virtio-mem: don't read big block size in Sub Block Mode

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Clear vq ready indication upon device reset

Zhen Lei <thunder.leizhen@huawei.com>
    ALSA: isa: Fix error return code in snd_cmi8330_probe()

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix NULL dereference in nfs3svc_encode_getaclres

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a possible oops in the nfs_dirent() tracepoint

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Reduce contention for the nfsd_file nf_rwsem

J. Bruce Fields <bfields@redhat.com>
    nfsd: move fsnotify on client creation outside spinlock

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_clid_confirmed tracepoint

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix detecting BPF atomic instructions

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: can't set sk_user_data without write_lock

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: move tx vq operation under tx queue lock

Eli Cohen <elic@nvidia.com>
    vdp/mlx5: Fix setting the correct dma_device

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix possible failure in umem size calculation

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix umem sizes assignments on VQ create

Jason Wang <jasowang@redhat.com>
    vp_vdpa: correct the return value when fail to map notification

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove not needed PF_EXITING check

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: inline __tctx_task_work()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: move creds from io-wq work to io_kiocb

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't bounce submit_state cachelines

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: shuffle rarely used ctx fields

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: get rid of files in exit cancel

Christoph Hellwig <hch@lst.de>
    block: grab a device refcount in disk_uevent

Viresh Kumar <viresh.kumar@linaro.org>
    arch_topology: Avoid use-after-free for scale_freq_data

Jon Hunter <jonathanh@nvidia.com>
    PCI: tegra194: Fix tegra_pcie_ep_raise_msi_irq() ill-defined shift

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: remove false alarm on iget failure during GC

Scott Mayhew <smayhew@redhat.com>
    nfs: update has_sec_mnt_opts after cloning lsm options from parent

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: imx1: Don't disable clocks at device remove time

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    PCI: intel-gw: Fix INTx enable

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Limit xstate copy size in xstateregs_set()

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Fix copy_xstate_to_kernel() gap handling

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid adding tab before doc section

Sandor Bodo-Merle <sbodomerle@gmail.com>
    PCI: iproc: Support multi-MSI only on uniprocessor kernel

Sandor Bodo-Merle <sbodomerle@gmail.com>
    PCI: iproc: Fix multi-MSI base vector number allocation

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode

Gao Xiang <hsiangkao@linux.alibaba.com>
    nfs: fix acl memory leak of posix_acl_create()

NeilBrown <neilb@suse.de>
    SUNRPC: prevent port reuse on transports which don't request it.

Wei Yongjun <weiyongjun1@huawei.com>
    watchdog: jz4740: Fix return value check in jz4740_wdt_probe()

Tao Ren <rentao.bupt@gmail.com>
    watchdog: aspeed: fix hardware timeout calculation

Shruthi Sanil <shruthi.sanil@intel.com>
    watchdog: keembay: Removed timeout update in the TO ISR

Shruthi Sanil <shruthi.sanil@intel.com>
    watchdog: keembay: Remove timeout update in the WDT start function

Shruthi Sanil <shruthi.sanil@intel.com>
    watchdog: keembay: Clear either the TO or TH interrupt bit

Shruthi Sanil <shruthi.sanil@intel.com>
    watchdog: keembay: Update pretimeout to zero in the TH ISR

Shruthi Sanil <shruthi.sanil@intel.com>
    watchdog: keembay: Upadate WDT pretimeout for every update in timeout

Shruthi Sanil <shruthi.sanil@intel.com>
    watchdog: keembay: Update WDT pre-timeout during the initialization

Zhen Lei <thunder.leizhen@huawei.com>
    ubifs: journal: Fix error return code in ubifs_jnl_write_inode()

Zhen Lei <thunder.leizhen@huawei.com>
    um: fix error return code in winch_tramp()

Zhen Lei <thunder.leizhen@huawei.com>
    um: fix error return code in slip_open()

YiFei Zhu <zhuyifei1999@gmail.com>
    um: Fix stack pointer alignment

Anna Schumaker <Anna.Schumaker@Netapp.com>
    sunrpc: Avoid a KASAN slab-out-of-bounds bug in xdr_set_page_base()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix an Oops in pnfs_mark_request_commit() when doing O_DIRECT

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Initialise connection to the server in nfs4_alloc_client()

Stephan Gerhold <stephan@gerhold.net>
    power: supply: rt5033_battery: Fix device tree enumeration

Krzysztof Wilczyński <kw@linux.com>
    PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun

Maximilian Luz <luzmaximilian@gmail.com>
    power: supply: surface-charger: Fix type of integer variable

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    remoteproc: k3-r5: Fix an error message

Arnd Bergmann <arnd@arndb.de>
    remoteproc: stm32: fix phys_addr_t format string

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to disallow temp extension

Chao Yu <chao@kernel.org>
    f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs

Jon Mediero <jmdr@disroot.org>
    module: correctly exit module_kallsyms_on_each_symbol when fn() != 0

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: visconti: Fix and simplify period calculation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cpufreq: scmi: Fix an error message

Chang S. Bae <chang.seok.bae@intel.com>
    x86/signal: Detect and prevent an alternate signal stack overflow

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix TP_printk() format specifier in nfsd_clid_class

Chao Yu <chao@kernel.org>
    f2fs: atgc: fix to set default age threshold

Maximilian Luz <luzmaximilian@gmail.com>
    power: supply: surface_battery: Fix battery event handling

Chunguang Xu <brookxu@tencent.com>
    block: fix the problem of io_ticks becoming smaller

Xie Yongji <xieyongji@bytedance.com>
    virtio_console: Assure used length from device is limited

Xie Yongji <xieyongji@bytedance.com>
    virtio_net: Fix error handling in virtnet_restore()

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Fix memory leak among suspend/resume procedure

Ye Bin <yebin10@huawei.com>
    ext4: fix WARN_ON_ONCE(!buffer_uptodate) after an error writing the superblock

Javier Martinez Canillas <javierm@redhat.com>
    PCI: rockchip: Register IRQ handlers after device and data are ready

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add quirk for the Dell Vostro 3350

Liguang Zhang <zhangliguang@linux.alibaba.com>
    ACPI: AMBA: Fix resource name in /proc/iomem

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: tegra: Don't modify HW state in .remove callback

Zou Wei <zou_wei@huawei.com>
    pwm: img: Fix PM reference leak in img_pwm_enable()

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: fix sysfs kobj leak

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: fix Navi1x tcp power gating hang when issuing lightweight invalidaiton

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Make "T3 MRD" no_battery_list DMI entry more generic

Zou Wei <zou_wei@huawei.com>
    power: supply: ab8500: add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    power: supply: charger-manager: add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    power: reset: regulator-poweroff: add missing MODULE_DEVICE_TABLE

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_find_open_context() may only select open files

Jing Xiangfeng <jingxiangfeng@huawei.com>
    drm/gma500: Add the missed drm_gem_object_put() in psb_user_framebuffer_create()

Jeff Layton <jlayton@kernel.org>
    ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix orangefs df output.

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix handling of non-atomic change attrbute updates

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up inode attribute revalidation timeouts

Zou Wei <zou_wei@huawei.com>
    PCI: tegra: Add missing MODULE_DEVICE_TABLE

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    remoteproc: stm32: fix mbox_send_message call

Siddharth Gupta <sidgup@codeaurora.org>
    remoteproc: core: Fix cdev remove and rproc del

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Return proper error codes from user access functions

Zou Wei <zou_wei@huawei.com>
    PCI: mediatek-gen3: Add missing MODULE_DEVICE_TABLE

Amir Goldstein <amir73il@gmail.com>
    fuse: fix illegal access to inode with reused nodeid

Greg Kurz <groug@kaod.org>
    virtiofs: propagate sync() to file server

Jan Kiszka <jan.kiszka@siemens.com>
    watchdog: iTCO_wdt: Account for rebooting on second timeout

Stefan Eichenberger <eichest@gmail.com>
    watchdog: imx_sc_wdt: fix pretimeout

Zou Wei <zou_wei@huawei.com>
    watchdog: Fix possible use-after-free by calling del_timer_sync()

Zou Wei <zou_wei@huawei.com>
    watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()

Zou Wei <zou_wei@huawei.com>
    watchdog: Fix possible use-after-free in wdt_startup()

Russell King <rmk+kernel@armlinux.org.uk>
    PCI: Dynamically map ECAM regions

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Ignore Link Down/Up caused by DPC

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix delegation return in cases where we have to retry

Logan Gunthorpe <logang@deltatee.com>
    PCI/P2PDMA: Avoid pci_get_slot(), which may sleep

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1

Bixuan Cui <cuibixuan@huawei.com>
    power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: max17040: Do not enforce (incorrect) interrupt trigger type

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: max17042: Do not enforce (incorrect) interrupt trigger type

Clemens Gruber <clemens.gruber@pqgruber.com>
    pwm: pca9685: Restrict period change for enabled PWMs

Long Li <longli@microsoft.com>
    PCI: hv: Fix a race condition when removing the device

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Enable USB and AC

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Avoid NULL pointers

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Move to componentized binding

Randy Dunlap <rdunlap@infradead.org>
    PCI: ftpci100: Rename macro name collision

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: spear: Don't modify HW state in .remove callback

Zou Wei <zou_wei@huawei.com>
    power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE

Marco Elver <elver@google.com>
    kcov: add __no_sanitize_coverage to fix noinstr for all architectures

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Rashmi A <rashmi.a@intel.com>
    phy: intel: Fix for warnings due to EMMC clock 175Mhz change in FIP

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    i2c: core: Disable client irq on reboot/shutdown

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Wait until port is in reset before programming it

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: fix check allowing 5Ghz settings

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: fix macro value for 2.4Ghz only device

Zou Wei <zou_wei@huawei.com>
    leds: turris-omnia: add missing MODULE_DEVICE_TABLE

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: fix detection for S/PDIF source on optical interface in v2 protocol

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions

Jiajun Cao <jjcao20@fudan.edu.cn>
    ALSA: hda: Add IRQ check for platform_get_irq()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    backlight: lm3630a: Fix return code of .update_status() callback

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: fsl_xcvr: check return value after calling platform_get_resource_byname()

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/boot: Fixup device-tree on little endian

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: hid: fix error return code in hid_bind()

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_hid: fix endianness issue with descriptors

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix scarlett2_*_ctl_put() return values

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix data_mutex lock

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix missing LCD splash screen data initializer

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: add support for ToneWeal FW66

Yizhuo Zhai <yzhai003@ucr.edu>
    Input: hideep - fix the uninitialized use in hideep_nvm_unlock()

Heiko Carstens <hca@linux.ibm.com>
    s390/mem_detect: fix tprot() program check new psw handling

Heiko Carstens <hca@linux.ibm.com>
    s390/mem_detect: fix diag260() program check new psw handling

Heiko Carstens <hca@linux.ibm.com>
    s390/ipl_parm: fix program check new psw handling

Heiko Carstens <hca@linux.ibm.com>
    s390/processor: always inline stap() and __load_psw_mask()

Koby Elbaz <kelbaz@habana.ai>
    habanalabs/gaudi: set the correct rc in case of err

Koby Elbaz <kelbaz@habana.ai>
    habanalabs: remove node from list before freeing the node

Koby Elbaz <kelbaz@habana.ai>
    habanalabs: set rc as 'valid' in case of intentional func exit

Ohad Sharabi <osharabi@habana.ai>
    habanalabs: fix mask to obtain page offset

Koby Elbaz <kelbaz@habana.ai>
    habanalabs/gaudi: set the correct cpu_id on MME2_QM failure

Ohad Sharabi <osharabi@habana.ai>
    habanalabs: check if asic secured with asic type

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: handle failed buffer copy to URB sg list and fix a W=1 copiler warning

Zhen Lei <thunder.leizhen@huawei.com>
    ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/book3s64: Fix possible build error

Peter Robinson <pbrobinson@gmail.com>
    gpio: pca953x: Add support for the On Semi pca9655

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    selftests/powerpc: Fix "no_handler" EBB selftest

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ppc: fix error return code in snd_pmac_probe()

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Correctly handle multiple flags in srb_status

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/inst: Fix sparse detection on get_user_instr()

Gil Fine <gil.fine@intel.com>
    thunderbolt: Fix DROM handling for USB4 DROM

Srinivas Neeli <srinivas.neeli@xilinx.com>
    gpio: zynq: Check return value of irq_get_irq_data

Srinivas Neeli <srinivas.neeli@xilinx.com>
    gpio: zynq: Check return value of pm_runtime_get_sync

Jaroslav Kysela <perex@perex.cz>
    ASoC: soc-pcm: fix the return value in dpcm_apply_symmetry()

Jaroslav Kysela <perex@perex.cz>
    ALSA: control_led - fix initialization in the mode show callback

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: n64: check return value after calling platform_get_resource()

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails

Geoff Levand <geoff@infradead.org>
    powerpc/ps3: Add dma_mask to ps3_dma_region

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Fix potential double-free of CSP mixer elements

Eric Anholt <eric@anholt.net>
    iommu/arm-smmu-qcom: Skip the TTBR1 quirk for db820c.

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: timers: rtcpie: skip test if default RTC device does not exist

Fabrice Fontaine <fontaine.fabrice@gmail.com>
    s390: disable SSP when needed

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    s390/sclp_vt220: fix console name to match device

Daniel Mack <daniel@zonque.org>
    serial: tty: uartlite: fix console setup

Zou Wei <zou_wei@huawei.com>
    fsi: Add missing MODULE_DEVICE_TABLE

Al Viro <viro@zeniv.linux.org.uk>
    iov_iter_advance(): use consistent semantics for move past the end

Yufen Yu <yuyufen@huawei.com>
    ASoC: img: Fix PM reference leak in img_i2s_in_probe()

Tony Lindgren <tony@atomide.com>
    mfd: cpcap: Fix cpcap dmamask not set warnings

Zou Wei <zou_wei@huawei.com>
    mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix cleanup session block/unblock use

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix TMF session block/unblock use

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix race during abort timeouts

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix null ref during abort handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix shost->max_id use

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix conn use after free during resets

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Add iscsi_cls_conn refcount helpers

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs

Kashyap Desai <kashyap.desai@broadcom.com>
    scsi: megaraid_sas: Early detection of VD deletion through RaidMap update

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Fix resource leak in case of probe failure

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    fs/jfs: Fix missing error code in lmLogInit()

Hannes Reinecke <hare@suse.de>
    scsi: scsi_dh_alua: Check for negative result value

Hannes Reinecke <hare@suse.de>
    scsi: core: Fixup calling convention for scsi_mode_sense()

Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Fix deadlock while cancelling the running firmware event

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: 8250: serial_cs: Fix a memory leak in error handling path

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix 1536000 Bit Clock instability

Yufen Yu <yuyufen@huawei.com>
    ALSA: ac97: fix PM reference leak in ac97_bus_remove()

John Garry <john.garry@huawei.com>
    scsi: core: Cap scsi_host cmd_per_lun at can_queue

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology

Sergey Shtylyov <s.shtylyov@omp.ru>
    scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()

ching Huang <ching2048@areca.com.tw>
    scsi: arcmsr: Fix doorbell status being updated late on ARC-1886

Luiz Sampaio <sampaio.ime@gmail.com>
    w1: ds2438: fixing bug that would always get page0

Jaska Uimonen <jaska.uimonen@linux.intel.com>
    ASoC: SOF: topology: fix assignment to use le32_to_cpu

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: common: usb-conn-gpio: fix NULL pointer dereference of charger

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Don't call free_pages_exact() with NULL address

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Avoid camelCase

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().

Sean Nyekjaer <sean@geanix.com>
    iio: imu: st_lsm6dsx: correct ODR in header

Arnd Bergmann <arnd@arndb.de>
    partitions: msdos: fix one-byte get_unaligned()

Zou Wei <zou_wei@huawei.com>
    ASoC: intel/boards: add missing MODULE_DEVICE_TABLE

Tong Zhang <ztong0001@gmail.com>
    misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    misc/libmasm/module: Fix two use after free in ibmasm_init_one

Jim Quinlan <jim2101024@gmail.com>
    serial: 8250: of: Check for CONFIG_SERIAL_8250_BCM7271

Michael Walle <michael@walle.cc>
    serial: fsl_lpuart: disable DMA for console and fix sysrq

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero

Raymond Tan <raymond.tan@intel.com>
    usb: dwc3: pci: Fix DEFINE for Intel Elkhart Lake

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus: handle -ENODATA errors in clock stop/start sequences

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus: only use CLOCK_STOP_MODE0 and fix confusions

Paul E. McKenney <paulmck@kernel.org>
    rcu: Reject RCU_LOCKDEP_WARN() false positives

Frederic Weisbecker <frederic@kernel.org>
    srcu: Fix broken node geometry after early ssp init

ching Huang <ching2048@areca.com.tw>
    scsi: arcmsr: Fix the wrong CDB payload report to IOP

Robin Gong <yibin.gong@nxp.com>
    dmaengine: fsl-qdma: check dma_set_mask return value

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add mutual exclusion between PCH DMIC and RT715

Yang Yingliang <yangyingliang@huawei.com>
    leds: tlc591xx: fix return value check in tlc591xx_probe()

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: multicast: fix MRD advertisement router port marking race

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: multicast: fix PIM hello router port marking race

José Roberto de Souza <jose.souza@intel.com>
    drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Avoid to mess up payload table by ports in stale topology

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Do not set proposed vcpi directly

Filipe Manana <fdmanana@suse.com>
    btrfs: zoned: fix wrong mutex unlock on failure to allocate log root tree

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't block if we can't acquire the reclaim lock

Filipe Manana <fdmanana@suse.com>
    btrfs: rework chunk allocation to avoid exhaustion of the system chunk array

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock with concurrent chunk allocations involving system chunks

David Sterba <dsterba@suse.com>
    btrfs: zoned: fix types for u64 division in btrfs_reclaim_bgs_work

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: properly split extent_map for REQ_OP_ZONE_APPEND

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: use right task for exiting checks

Robin Murphy <robin.murphy@arm.com>
    arm64: Avoid premature usercopy failure

Joao Martins <joao.m.martins@oracle.com>
    mm/hugetlb: fix refs calculation from unaligned @vaddr

Randy Dunlap <rdunlap@infradead.org>
    EDAC/igen6: fix core dependency AGAIN

Zhen Lei <thunder.leizhen@huawei.com>
    fbmem: Do not delete the mode that is still in use

Christian Brauner <christian.brauner@ubuntu.com>
    cgroup: verify that source is a string

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/gt: Fix -EDEADLK handling regression

Matthew Auld <matthew.auld@intel.com>
    drm/i915/gtt: drop the page table optimisation

Jinzhou Su <Jinzhou.Su@amd.com>
    drm/amdgpu: add another Renoir DID

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not reference char * as a string in histograms

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix clearing real DMA device's scalable-mode context entries

Sanjay Kumar <sanjay.k.kumar@intel.com>
    iommu/vt-d: Global devTLB flush when present context entry changed

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Report port fc_security as unknown early during remote cable pull

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: core: Fix bad pointer dereference when ehandler kthread is invalid

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: SVM: remove INIT intercept handler

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: SVM: #SMI interception must not skip the instruction

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nSVM: Check the value written to MSR_VM_HSAVE_PA

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: selftests: do not require 64GB in set_memory_region_test

Kefeng Wang <wangkefeng.wang@huawei.com>
    KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: Do not use the original cruid when following DFS links for multiuser mounts

Paulo Alcantara <pc@cjr.nz>
    cifs: handle reconnect of tcon when there is no cached dfs referral

Shyam Prasad N <sprasad@microsoft.com>
    cifs: use the expiry output of dns_query to schedule next resolution


-------------

Diffstat:

 Documentation/devicetree/bindings/i2c/i2c-at91.txt |   2 +-
 .../bindings/power/supply/maxim,max17040.yaml      |   2 +-
 Documentation/filesystems/f2fs.rst                 |  16 +-
 Makefile                                           |   9 +-
 arch/arm/boot/dts/am335x-cm-t335.dts               |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   4 +-
 arch/arm/boot/dts/am5718.dtsi                      |   6 +-
 arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi         |   2 +-
 arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi  |   2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |  18 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |  22 -
 arch/arm/boot/dts/dra71x.dtsi                      |   4 -
 arch/arm/boot/dts/dra72x.dtsi                      |   4 -
 arch/arm/boot/dts/dra74x.dtsi                      |  92 +--
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         |   2 +-
 arch/arm/boot/dts/exynos5422-odroidxu4.dts         |   2 +-
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi    |   4 +-
 arch/arm/boot/dts/gemini-rut1xx.dts                |  12 -
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |  41 +-
 arch/arm/boot/dts/qcom-sdx55-t55.dts               |   2 +-
 arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts   |   4 +-
 arch/arm/boot/dts/r8a7779-marzen.dts               |   2 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |   1 +
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |   8 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts       |   2 +-
 arch/arm/mach-exynos/exynos.c                      |   2 +
 arch/arm/probes/kprobes/test-thumb.c               |  10 +-
 .../dts/allwinner/sun50i-a64-sopine-baseboard.dts  |   2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |   2 +
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   4 +-
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |  12 +
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   2 +
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          |   1 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi          |   7 +-
 arch/arm64/boot/dts/renesas/r8a77961.dtsi          |   7 +-
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts     |   2 +-
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi          |   1 -
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   2 -
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi    |   3 +
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi           |   5 +-
 arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi            |   2 +-
 arch/arm64/boot/dts/ti/k3-am642-evm.dts            |   2 +-
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi |   2 +-
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |   5 +-
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |   2 -
 .../boot/dts/ti/k3-j721e-common-proc-board.dts     |  52 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |  58 +-
 arch/arm64/configs/defconfig                       |   1 -
 arch/arm64/lib/copy_from_user.S                    |  13 +-
 arch/arm64/lib/copy_in_user.S                      |  21 +-
 arch/arm64/lib/copy_to_user.S                      |  14 +-
 arch/hexagon/kernel/vmlinux.lds.S                  |   9 +-
 arch/m68k/68000/dragen2.c                          |   1 +
 arch/m68k/68000/screen.h                           | 804 +++++++++++++++++++++
 arch/mips/boot/compressed/Makefile                 |   4 +-
 arch/mips/boot/compressed/decompress.c             |   2 +
 arch/mips/include/asm/vdso/vdso.h                  |   2 +-
 arch/powerpc/boot/devtree.c                        |  59 +-
 arch/powerpc/boot/ns16550.c                        |   9 +-
 arch/powerpc/include/asm/inst.h                    |   7 +-
 arch/powerpc/include/asm/ps3.h                     |   2 +
 arch/powerpc/mm/book3s64/radix_tlb.c               |  26 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   4 +-
 arch/powerpc/platforms/ps3/mm.c                    |  12 +
 arch/s390/Kconfig                                  |   1 -
 arch/s390/Makefile                                 |   1 +
 arch/s390/boot/ipl_parm.c                          |  19 +-
 arch/s390/boot/mem_detect.c                        |  47 +-
 arch/s390/include/asm/processor.h                  |   4 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/s390/purgatory/Makefile                       |   1 +
 arch/um/drivers/chan_user.c                        |   3 +-
 arch/um/drivers/slip_user.c                        |   3 +-
 arch/um/drivers/ubd_kern.c                         |   3 +-
 arch/um/kernel/skas/clone.c                        |   2 +-
 arch/um/os-Linux/helper.c                          |   4 +-
 arch/um/os-Linux/signal.c                          |   2 +-
 arch/um/os-Linux/skas/process.c                    |   2 +-
 arch/x86/include/asm/fpu/internal.h                |  19 +-
 arch/x86/kernel/fpu/regset.c                       |   2 +-
 arch/x86/kernel/fpu/xstate.c                       | 105 +--
 arch/x86/kernel/signal.c                           |  24 +-
 arch/x86/kvm/cpuid.c                               |  27 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +
 arch/x86/kvm/mmu/paging.h                          |  14 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   4 +-
 arch/x86/kvm/mmu/spte.h                            |   6 -
 arch/x86/kvm/svm/svm.c                             |  21 +-
 arch/x86/kvm/x86.c                                 |   2 +
 block/blk-core.c                                   |   2 +-
 block/genhd.c                                      |   4 +-
 block/partitions/ldm.c                             |   2 +-
 block/partitions/ldm.h                             |   3 -
 block/partitions/msdos.c                           |  24 +-
 drivers/acpi/acpi_amba.c                           |   1 +
 drivers/acpi/acpi_video.c                          |   9 +
 drivers/base/arch_topology.c                       |  27 +-
 drivers/block/virtio_blk.c                         |   2 +
 drivers/char/virtio_console.c                      |   4 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  27 +-
 drivers/cpufreq/scmi-cpufreq.c                     |   2 +-
 drivers/dma/fsl-qdma.c                             |   6 +-
 drivers/edac/Kconfig                               |   2 +-
 drivers/firmware/arm_scmi/driver.c                 |  12 +-
 drivers/firmware/tegra/bpmp-tegra210.c             |   2 +-
 drivers/firmware/turris-mox-rwtm.c                 |  55 +-
 drivers/fsi/fsi-master-aspeed.c                    |   1 +
 drivers/fsi/fsi-master-ast-cf.c                    |   1 +
 drivers/fsi/fsi-master-gpio.c                      |   1 +
 drivers/fsi/fsi-occ.c                              |   1 +
 drivers/gpio/gpio-pca953x.c                        |   1 +
 drivers/gpio/gpio-zynq.c                           |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  95 +++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  14 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   1 +
 drivers/gpu/drm/drm_dp_mst_topology.c              |  68 +-
 drivers/gpu/drm/gma500/framebuffer.c               |   7 +-
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c               |   5 +-
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c       |   2 +-
 drivers/hwtracing/intel_th/core.c                  |  17 +
 drivers/hwtracing/intel_th/gth.c                   |  16 +
 drivers/hwtracing/intel_th/intel_th.h              |   3 +
 drivers/i2c/i2c-core-base.c                        |   3 +
 drivers/iio/gyro/fxas21002c_core.c                 |  11 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   6 +-
 drivers/iio/magnetometer/bmc150_magn.c             |  10 +-
 drivers/input/touchscreen/hideep.c                 |  13 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  13 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |  10 +-
 drivers/iommu/intel/iommu.c                        |  34 +-
 drivers/leds/leds-tlc591xx.c                       |   8 +-
 drivers/leds/leds-turris-omnia.c                   |   1 +
 drivers/memory/atmel-ebi.c                         |   4 +-
 drivers/memory/fsl_ifc.c                           |   8 +-
 drivers/memory/pl353-smc.c                         |   1 +
 drivers/memory/stm32-fmc2-ebi.c                    |   4 +
 drivers/mfd/da9052-i2c.c                           |   1 +
 drivers/mfd/motorola-cpcap.c                       |   4 +
 drivers/mfd/stmpe-i2c.c                            |   2 +-
 drivers/misc/cardreader/alcor_pci.c                |   8 +-
 drivers/misc/habanalabs/common/device.c            |   5 +-
 drivers/misc/habanalabs/common/firmware_if.c       |   5 +-
 drivers/misc/habanalabs/common/habanalabs_drv.c    |   2 +-
 drivers/misc/habanalabs/common/mmu/mmu.c           |  14 +-
 drivers/misc/habanalabs/gaudi/gaudi.c              |   7 +-
 drivers/misc/habanalabs/goya/goya.c                |   1 +
 drivers/misc/ibmasm/module.c                       |   5 +-
 drivers/net/virtio_net.c                           |  27 +-
 drivers/nvme/target/tcp.c                          |   1 -
 drivers/pci/controller/dwc/pcie-intel-gw.c         |  10 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   2 +-
 drivers/pci/controller/pci-ftpci100.c              |  30 +-
 drivers/pci/controller/pci-hyperv.c                |  30 +-
 drivers/pci/controller/pci-tegra.c                 |   1 +
 drivers/pci/controller/pcie-iproc-msi.c            |  29 +-
 drivers/pci/controller/pcie-mediatek-gen3.c        |   1 +
 drivers/pci/controller/pcie-rockchip-host.c        |  12 +-
 drivers/pci/ecam.c                                 |  54 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  36 +
 drivers/pci/p2pdma.c                               |  34 +-
 drivers/pci/pci-label.c                            |   2 +-
 drivers/pci/pci.h                                  |   4 +
 drivers/pci/pcie/dpc.c                             |  74 +-
 drivers/phy/intel/phy-intel-keembay-emmc.c         |   3 +-
 drivers/power/reset/gpio-poweroff.c                |   1 +
 drivers/power/reset/regulator-poweroff.c           |   1 +
 drivers/power/supply/Kconfig                       |   3 +-
 drivers/power/supply/ab8500-bm.h                   |   6 +-
 drivers/power/supply/ab8500_btemp.c                | 119 ++-
 drivers/power/supply/ab8500_charger.c              | 378 ++++++----
 drivers/power/supply/ab8500_fg.c                   | 137 ++--
 drivers/power/supply/abx500_chargalg.c             | 116 +--
 drivers/power/supply/axp288_fuel_gauge.c           |  18 +-
 drivers/power/supply/charger-manager.c             |   1 +
 drivers/power/supply/max17040_battery.c            |   4 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/power/supply/rt5033_battery.c              |   7 +
 drivers/power/supply/sc2731_charger.c              |   1 +
 drivers/power/supply/sc27xx_fuel_gauge.c           |   1 +
 drivers/power/supply/surface_battery.c             |  14 +-
 drivers/power/supply/surface_charger.c             |   2 +-
 drivers/pwm/pwm-img.c                              |   2 +-
 drivers/pwm/pwm-imx1.c                             |   2 -
 drivers/pwm/pwm-pca9685.c                          |  74 +-
 drivers/pwm/pwm-spear.c                            |   4 -
 drivers/pwm/pwm-tegra.c                            |  13 -
 drivers/pwm/pwm-visconti.c                         |  17 +-
 drivers/remoteproc/remoteproc_cdev.c               |   2 +-
 drivers/remoteproc/remoteproc_core.c               |   2 +-
 drivers/remoteproc/stm32_rproc.c                   |  16 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   2 +-
 drivers/reset/Kconfig                              |   4 +-
 drivers/reset/core.c                               |   5 +-
 drivers/reset/reset-a10sr.c                        |   1 +
 drivers/reset/reset-brcmstb.c                      |   1 +
 drivers/rtc/Kconfig                                |   3 +-
 drivers/rtc/proc.c                                 |   4 +-
 drivers/s390/char/sclp_vt220.c                     |   4 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   1 +
 drivers/scsi/arcmsr/arcmsr_hba.c                   |  19 +-
 drivers/scsi/be2iscsi/be_main.c                    |   5 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |  11 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  12 +-
 drivers/scsi/hosts.c                               |   4 +
 drivers/scsi/libiscsi.c                            | 122 ++--
 drivers/scsi/lpfc/lpfc_els.c                       |   9 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   5 +-
 drivers/scsi/megaraid/megaraid_sas.h               |  12 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |  96 ++-
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  22 +
 drivers/scsi/qedi/qedi.h                           |   1 +
 drivers/scsi/qedi/qedi_fw.c                        |  24 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |  37 +-
 drivers/scsi/qedi/qedi_main.c                      |   2 +-
 drivers/scsi/scsi_lib.c                            |  10 +-
 drivers/scsi/scsi_transport_iscsi.c                |  12 +
 drivers/scsi/scsi_transport_sas.c                  |   9 +-
 drivers/scsi/sd.c                                  |  12 +-
 drivers/scsi/sr.c                                  |   2 +-
 drivers/scsi/storvsc_drv.c                         |  61 +-
 drivers/soc/mediatek/mtk-pm-domains.c              |  42 +-
 drivers/soundwire/bus.c                            | 151 ++--
 drivers/staging/rtl8723bs/hal/odm.h                |   5 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |   7 +-
 drivers/thermal/rcar_gen3_thermal.c                |   2 +-
 drivers/thermal/sprd_thermal.c                     |   1 +
 drivers/thunderbolt/eeprom.c                       |  19 +-
 drivers/tty/serial/8250/8250_of.c                  |   4 +
 drivers/tty/serial/8250/serial_cs.c                |  11 +-
 drivers/tty/serial/fsl_lpuart.c                    |   9 +
 drivers/tty/serial/uartlite.c                      |  27 +-
 drivers/usb/common/usb-conn-gpio.c                 |  44 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   2 +-
 drivers/usb/gadget/legacy/hid.c                    |   4 +-
 drivers/usb/host/xhci.c                            |   9 +-
 drivers/vdpa/mlx5/core/mr.c                        |   9 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  30 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   1 +
 drivers/video/backlight/lm3630a_bl.c               |  12 +-
 drivers/video/fbdev/core/fbmem.c                   |  12 +-
 drivers/virtio/virtio_mem.c                        |  15 +-
 drivers/w1/slaves/w1_ds2438.c                      |   4 +-
 drivers/watchdog/aspeed_wdt.c                      |   2 +-
 drivers/watchdog/iTCO_wdt.c                        |  12 +-
 drivers/watchdog/imx_sc_wdt.c                      |  11 +-
 drivers/watchdog/jz4740_wdt.c                      |   4 +-
 drivers/watchdog/keembay_wdt.c                     |  15 +-
 drivers/watchdog/lpc18xx_wdt.c                     |   2 +-
 drivers/watchdog/sbc60xxwdt.c                      |   2 +-
 drivers/watchdog/sc520_wdt.c                       |   2 +-
 drivers/watchdog/w83877f_wdt.c                     |   2 +-
 fs/btrfs/block-group.c                             | 355 ++++++---
 fs/btrfs/block-group.h                             |   6 +-
 fs/btrfs/ctree.c                                   |  67 +-
 fs/btrfs/inode.c                                   | 147 +++-
 fs/btrfs/transaction.c                             |  15 +-
 fs/btrfs/transaction.h                             |   9 +-
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/volumes.c                                 | 355 ++++++---
 fs/btrfs/volumes.h                                 |   5 +-
 fs/ceph/addr.c                                     |  10 +-
 fs/cifs/cifs_dfs_ref.c                             |   6 +-
 fs/cifs/cifsglob.h                                 |   4 +
 fs/cifs/connect.c                                  |  61 +-
 fs/cifs/dns_resolve.c                              |  10 +-
 fs/cifs/dns_resolve.h                              |   2 +-
 fs/cifs/misc.c                                     |   2 +-
 fs/ext4/ext4_jbd2.c                                |   2 +-
 fs/ext4/super.c                                    |  12 +-
 fs/f2fs/gc.c                                       |   5 +-
 fs/f2fs/namei.c                                    |  16 +-
 fs/f2fs/super.c                                    |   1 +
 fs/fuse/dir.c                                      |   2 +-
 fs/fuse/fuse_i.h                                   |  10 +
 fs/fuse/inode.c                                    |  44 +-
 fs/fuse/readdir.c                                  |   7 +-
 fs/fuse/virtio_fs.c                                |   1 +
 fs/io-wq.h                                         |   1 -
 fs/io_uring.c                                      | 221 +++---
 fs/jfs/jfs_logmgr.c                                |   1 +
 fs/nfs/delegation.c                                |  71 +-
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/direct.c                                    |  17 +-
 fs/nfs/fscache.c                                   |  18 +-
 fs/nfs/getroot.c                                   |  12 +-
 fs/nfs/inode.c                                     |  54 +-
 fs/nfs/nfs3proc.c                                  |   4 +-
 fs/nfs/nfs4_fs.h                                   |   1 +
 fs/nfs/nfs4client.c                                |  82 ++-
 fs/nfs/nfs4proc.c                                  |  33 +-
 fs/nfs/pnfs.c                                      |  40 +-
 fs/nfs/pnfs_nfs.c                                  |  52 +-
 fs/nfs/read.c                                      |   5 +-
 fs/nfsd/nfs3acl.c                                  |   3 +-
 fs/nfsd/nfs4state.c                                |  14 +-
 fs/nfsd/trace.h                                    |  31 +-
 fs/nfsd/vfs.c                                      |  18 +-
 fs/orangefs/super.c                                |   2 +-
 fs/ubifs/dir.c                                     |   7 +
 fs/ubifs/journal.c                                 |   1 +
 include/linux/compiler-clang.h                     |  17 +
 include/linux/compiler-gcc.h                       |   6 +
 include/linux/compiler_types.h                     |   2 +-
 include/linux/nfs_fs.h                             |   1 +
 include/linux/pci-ecam.h                           |   1 +
 include/linux/rcupdate.h                           |   2 +-
 include/linux/sched/signal.h                       |  19 +-
 include/linux/soundwire/sdw.h                      |   2 -
 include/scsi/libiscsi.h                            |  11 +-
 include/scsi/scsi_transport_iscsi.h                |   2 +
 include/uapi/linux/fuse.h                          |  10 +-
 kernel/cgroup/cgroup-v1.c                          |   2 +
 kernel/jump_label.c                                |  13 +-
 kernel/kprobes.c                                   |   2 +
 kernel/module.c                                    |   3 +-
 kernel/rcu/rcu.h                                   |   2 +
 kernel/rcu/srcutree.c                              |   3 +
 kernel/rcu/tree.c                                  |  16 +-
 kernel/rcu/update.c                                |   2 +-
 kernel/sched/sched.h                               |  21 +-
 kernel/static_call.c                               |  13 +-
 kernel/trace/trace_events_hist.c                   |   6 +-
 lib/decompress_unlz4.c                             |   8 +
 lib/iov_iter.c                                     |   5 +-
 mm/hugetlb.c                                       |   5 +-
 net/bridge/br_multicast.c                          |   6 +
 net/sunrpc/xdr.c                                   |   7 +-
 net/sunrpc/xprtsock.c                              |   3 +-
 sound/ac97/bus.c                                   |   2 +-
 sound/core/control_led.c                           |   2 +-
 sound/firewire/Kconfig                             |   5 +-
 sound/firewire/bebob/bebob.c                       |   5 +-
 sound/firewire/motu/motu-protocol-v2.c             |  13 +-
 sound/firewire/oxfw/oxfw.c                         |   2 +-
 sound/isa/cmi8330.c                                |   2 +-
 sound/isa/sb/sb16_csp.c                            |   8 +-
 sound/mips/snd-n64.c                               |   4 +
 sound/pci/hda/hda_tegra.c                          |   3 +
 sound/ppc/powermac.c                               |   6 +-
 sound/soc/codecs/cs42l42.c                         |  47 +-
 sound/soc/codecs/cs42l42.h                         |   2 +
 sound/soc/fsl/fsl_xcvr.c                           |   4 +
 sound/soc/img/img-i2s-in.c                         |   2 +-
 sound/soc/intel/boards/kbl_da7219_max98357a.c      |   4 +-
 sound/soc/intel/boards/sof_da7219_max98373.c       |   1 +
 sound/soc/intel/boards/sof_rt5682.c                |   1 +
 sound/soc/intel/boards/sof_sdw.c                   |  19 +-
 sound/soc/intel/boards/sof_sdw_common.h            |   1 +
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c  |   2 +-
 sound/soc/soc-core.c                               |   2 +-
 sound/soc/soc-pcm.c                                |   2 +-
 sound/soc/sof/topology.c                           |   2 +-
 sound/usb/mixer_scarlett_gen2.c                    |  39 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |  56 +-
 sound/usb/usx2y/usX2Yhwdep.h                       |   2 +-
 sound/usb/usx2y/usb_stream.c                       |   7 +-
 sound/usb/usx2y/usbus428ctldefs.h                  | 102 +--
 sound/usb/usx2y/usbusx2y.c                         | 218 +++---
 sound/usb/usx2y/usbusx2y.h                         |  58 +-
 sound/usb/usx2y/usbusx2yaudio.c                    | 448 ++++++------
 sound/usb/usx2y/usx2yhwdeppcm.c                    | 410 +++++------
 sound/usb/usx2y/usx2yhwdeppcm.h                    |   4 +-
 tools/perf/builtin-report.c                        |   6 +
 tools/perf/util/parse-events.y                     |   2 +-
 tools/perf/util/pmu.c                              |  36 +-
 tools/perf/util/pmu.h                              |   1 +
 .../util/scripting-engines/trace-event-python.c    |  17 +-
 .../testing/selftests/kvm/set_memory_region_test.c |   3 +-
 .../selftests/powerpc/pmu/ebb/no_handler_test.c    |   2 -
 tools/testing/selftests/timers/rtcpie.c            |  10 +-
 virt/kvm/coalesced_mmio.c                          |   2 +-
 379 files changed, 5441 insertions(+), 2842 deletions(-)


