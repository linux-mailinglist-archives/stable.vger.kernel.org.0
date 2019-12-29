Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7AE12C5F4
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfL2RmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbfL2RmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019F721D7E;
        Sun, 29 Dec 2019 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641338;
        bh=+9CY5Gd3A6l7rxHLNXG9qDnZOVpYEvb82GBBY43EwaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ebpTWism8yyMeqWI9Oi2QNnqKDifDc1efOCBGiDVr9txiAVBJUztlZirUC4NMdfpw
         BDs2kiBeIC+hyIG8nwbLF5+eh/u+2aFW/x4PqtuYc8P9iAqUhEWDtNOcaTfLsGOO/l
         qqq1zpDJ20ryOSI+R99OckbHcnUMXAgzalwPBua0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/434] 5.4.7-stable review
Date:   Sun, 29 Dec 2019 18:20:53 +0100
Message-Id: <20191229172702.393141737@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.7-rc1
X-KernelTest-Deadline: 2019-12-31T17:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.7 release.
There are 434 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.7-rc1

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: move power gating workaround earlier in the flow

Mike Christie <mchristi@redhat.com>
    nbd: fix shutdown and recv work deadlock v2

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Add a quirk for broken command queuing

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Workaround broken command queuing on Intel GLK

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: fix P2020 errata handling

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci: Update the tuning failed messages to pr_debug level

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add erratum A-009204 support"

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Correct the offset and value for DDR_CONFIG register

Frederic Barrat <fbarrat@linux.ibm.com>
    ocxl: Fix concurrent AFU open and device removal

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/irq: fix stack overflow verification

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/vcpu: Assume dedicated processors as non-preempt

Jan H. Schönherr <jschoenh@amazon.de>
    x86/mce: Fix possibly incorrect severity calculation on AMD

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE/AMD: Allow Reserved types to be overwritten in smca_banks[]

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in smca_configure()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/intel: Disable HPET on Intel Coffee Lake H platforms

Will Deacon <will@kernel.org>
    KVM: arm64: Ensure 'params' is initialised when looking up sys register

Marc Zyngier <maz@kernel.org>
    KVM: arm/arm64: Properly handle faulting of device mappings

Jim Mattson <jmattson@google.com>
    kvm: x86: Host feature SSBD doesn't imply guest feature AMD_SSBD

Jim Mattson <jmattson@google.com>
    kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Marcus Comstedt <marcus@mc.pp.se>
    KVM: PPC: Book3S HV: Fix regression on big endian hosts

Tejun Heo <tj@kernel.org>
    iocost: over-budget forced IOs should schedule async delay

Theodore Ts'o <tytso@mit.edu>
    ext4: validate the debug_want_extra_isize mount option at parse time

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: unlock on error in ext4_expand_extra_isize()

Jan Kara <jack@suse.cz>
    ext4: check for directory entries too close to block end

Jan Kara <jack@suse.cz>
    ext4: fix ext4_empty_dir() for directories with holes

Peng Fan <peng.fan@nxp.com>
    clk: imx: pll14xx: fix clk_pll14xx_wait_lock

Peng Fan <peng.fan@nxp.com>
    clk: imx: clk-composite-8m: add lock to gate/mux

Peng Fan <peng.fan@nxp.com>
    clk: imx: clk-imx7ulp: Add missing sentinel of ulp_div_table

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Really serialize all register accesses

Yonghan Ye <yonghan.ye@unisoc.com>
    serial: sprd: Add clearing break interrupt operation

David Engraf <david.engraf@sysgo.com>
    tty/serial: atmel: fix out of range clock divider handling

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix window switching without windows

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix freeing IRQs

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Elkhart Lake SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Comet Lake PCH-V support

Erkka Talvitie <erkka.talvitie@vincit.fi>
    USB: EHCI: Do not return -EPIPE when hub is disconnected

Yang Shi <yang.shi@linux.alibaba.com>
    mm: vmscan: protect shrinker idr replace with CONFIG_MEMCG

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: return ENOMEM if akcipher_request_alloc() fails

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid leaving stale IRQ work items during CPU offline

Ard Biesheuvel <ardb@kernel.org>
    efi/memreserve: Register reservations as 'reserved' in /proc/iomem

Christophe Leroy <christophe.leroy@c-s.fr>
    spi: fsl: use platform_get_irq() instead of of_irq_to_resource()

Christophe Leroy <christophe.leroy@c-s.fr>
    spi: fsl: don't map irq during probe

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Fix error path of vhci_recv_ret_submit()

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Fix receive error in vhci-hcd when using scatter-gather

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: add low power enter/exit acknowledgment helper

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix vcsi regulator to be always-on for droid4 to prevent hangs

Sven Schnelle <svens@linux.ibm.com>
    s390/ftrace: fix endless recursion in function_graph tracer

Yufen Yu <yuyufen@huawei.com>
    md: avoid invalid memory access for array sb->dev_roles

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix post_recv QP state locking

Bjorn Andersson <bjorn.andersson@linaro.org>
    ath10k: Revert "ath10k: add cleanup in ath10k_sta_state()"

Colin Ian King <colin.king@canonical.com>
    drm/amdgpu: fix uninitialized variable pasid_mapping_needed

Guenter Roeck <linux@roeck-us.net>
    usb: xhci: Fix build warning seen with CONFIG_PM=n

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: cadence: Correct handling of native chipselect

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: dw: Correct handling of native chipselect

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    selftests: net: tls: remove recv_rcvbuf test

Xiaolong Huang <butterflyhuangxx@gmail.com>
    can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment

Sean Nyekjaer <sean@geanix.com>
    can: flexcan: fix possible deadlock and out-of-order reception after wakeup

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_sk_bind(): take priv after lock is held

Sean Nyekjaer <sean@geanix.com>
    can: m_can: tcan4x5x: add required delay after reset

Srinivas Neeli <srinivas.neeli@xilinx.com>
    can: xilinx_can: Fix missing Rx can packets on CANFD2.0

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Allocate reserved region for ISA with correct permission

Alex Williamson <alex.williamson@redhat.com>
    iommu/vt-d: Set ISA bridge reserved region as relaxable

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix dmar pte read access not set error

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu: set group default domain before creating direct mappings

Eric Auger <eric.auger@redhat.com>
    iommu: fix KASAN use-after-free in iommu_insert_resv_region

Tadeusz Struk <tadeusz.struk@intel.com>
    tpm: fix invalid locking in NONBLOCKING mode

Jerry Snitselaar <jsnitsel@redhat.com>
    tpm_tis: reserve chip for duration of tpm_tis_core_init

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix CMD_TA to 2 for MT8173 HS200/HS400 mode

Faiz Abbas <faiz_abbas@ti.com>
    Revert "mmc: sdhci: Fix incorrect switch to HS mode"

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in scrub_missing_raid56_worker()

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in reada_start_machine_worker()

Paul Burton <paulburton@kernel.org>
    MIPS: futex: Restore \n after sync instructions

Alexander Lobakin <alobakin@dlink.ru>
    net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Fix completion structure initialization

Luke Starrett <luke.starrett@broadcom.com>
    RDMA/bnxt_re: Fix chip number validation Broadcom's Gen P5 series

Yonghong Song <yhs@fb.com>
    bpf: Provide better register bounds after jmp32 instructions

Devesh Sharma <devesh.sharma@broadcom.com>
    RDMA/bnxt_re: Fix stat push into dma buffer on gen p5 devices

Devesh Sharma <devesh.sharma@broadcom.com>
    RDMA/bnxt_re: Fix missing le16_to_cpu

Quentin Monnet <quentin.monnet@netronome.com>
    tools, bpf: Fix build for 'make -s tools/bpf O=<dir>'

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: initialise phydev speed and duplex sanely

Brett Creeley <brett.creeley@intel.com>
    ice: Fix setting coalesce to handle DCB configuration

Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
    ice: Only disable VF state when freeing each VF resources

Sam Bobroff <sbobroff@linux.ibm.com>
    drm/amdgpu: fix bad DMA from INTERRUPT_CNTL2

Mike Rapoport <rppt@linux.ibm.com>
    mips: fix build when "48 bits virtual memory" is enabled

Hewenliang <hewenliang4@huawei.com>
    libtraceevent: Fix memory leakage in copy_filter_type

Michael Ellerman <mpe@ellerman.id.au>
    crypto: vmx - Avoid weird build failures

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: sun4i-ss - Fix 64-bit size_t warnings

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpumf: Adjust registration of s390 PMU device drivers

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: fix possible out-of-bound access in mt7615_fill_txs/mt7603_fill_txs

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: ale: clean ale tbl on init and intf restart

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: soc-pcm: check symmetry before hw_params

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbtft: Make sure string is NULL terminated

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: check kasprintf() return value

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve RX buffer error handling.

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: support memcpy_real with TRACE_IRQFLAGS

YueHaibing <yuehaibing@huawei.com>
    s390/crypto: Fix unsigned variable compared with zero

Alexey Budankov <alexey.budankov@linux.intel.com>
    perf session: Fix decompression of PERF_RECORD_COMPRESSED records

Rafał Miłecki <rafal@milecki.pl>
    brcmfmac: remove monitor interface when detaching

Luigi Rizzo <lrizzo@google.com>
    net-af_xdp: Use correct number of channels from ethtool

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Add some Intel instructions to the opcode map

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Update quirk for Acer Switch 10 SW5-012 2-in-1

Linus Walleij <linus.walleij@linaro.org>
    firmware_loader: Fix labels with comma for builtin firmware

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: avoid matching all-ones clause 45 PHY IDs

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Return proper error code for non-existent NVM variable

Yonghong Song <yhs@fb.com>
    selftests, bpf: Workaround an alu32 sub-register spilling issue

Jiri Benc <jbenc@redhat.com>
    selftests, bpf: Fix test_tc_tunnel hanging

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/core: Fix the mlock accounting, again

Chuhong Yuan <hslester96@gmail.com>
    ASoC: wm5100: add missed pm_runtime_disable

Chuhong Yuan <hslester96@gmail.com>
    spi: st-ssc4: add missed pm_runtime_disable

Chuhong Yuan <hslester96@gmail.com>
    ASoC: wm2200: add missed operations in remove and probe failure

Valentin Schneider <valentin.schneider@arm.com>
    sched/uclamp: Fix overzealous type replacement

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in run_ordered_work()

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in end_workqueue_fn()

Eugeniu Rosca <erosca@de.adit-jv.com>
    mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests

Ard Biesheuvel <ardb@kernel.org>
    crypto: virtio - deal with unsupported input sizes

Mika Westerberg <mika.westerberg@linux.intel.com>
    xhci-pci: Allow host runtime PM as default also for Intel Ice Lake xHCI

Petar Penkov <ppenkov@google.com>
    tun: fix data-race in gro_normal_list()

Chuhong Yuan <hslester96@gmail.com>
    spi: tegra20-slink: add missed clk_unprepare

Pascal Paillet <p.paillet@st.com>
    regulator: core: Let boot-on regulators be powered off

Michael Walle <michael@walle.cc>
    ASoC: wm8904: fix regcache handling

Wang Xuerui <wangxuerui@qiniu.com>
    iwlwifi: mvm: fix unaligned read of rx_pkt_status

Andrea Righi <andrea.righi@canonical.com>
    bcache: fix deadlock in bcache_allocator

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobe: Check whether the non-suffixed symbol is notrace

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    MIPS: ralink: enable PCI support only if driver for mt7621 SoC is selected

Yuming Han <yuming.han@unisoc.com>
    tracing: use kvcalloc for tgid_map array allocation

Gal Pressman <galpress@amazon.com>
    RDMA/efa: Clear the admin command buffer prior to its submission

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: fix using skb after free

Lianbo Jiang <lijiang@redhat.com>
    x86/crash: Add a forward declaration of struct kimage

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: fix invalid channel information output

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: fix debugfs support for multiple cards

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Register drivers only after CPU devices have been registered

Coly Li <colyli@suse.de>
    bcache: fix static checker warning in bcache_device_free()

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    parport: load lowlevel driver if ports not found

Eduard Hasenleithner <eduard@hasenleithner.at>
    nvme: Discard workaround for non-conformant devices

Mao Wenan <maowenan@huawei.com>
    net: ethernet: ti: Add dependency for TI_DAVINCI_EMAC

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/disassembler: don't hide instruction addresses

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: respect EEE user setting when restarting network

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: sja1105: Disallow management xmit during switch reset

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: Intel: kbl_rt5663_rt5514_max98927: Add dmic format constraint

Yonghong Song <yhs@fb.com>
    bpf, testing: Workaround a verifier failure for test_progs

Stefan Popa <stefan.popa@analog.com>
    iio: dac: ad5446: Add support for new AD5600 DAC

Ben Zhang <benzh@chromium.org>
    ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile

Chuhong Yuan <hslester96@gmail.com>
    spi: pxa2xx: Add missed security checks

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vim2m: media_device_cleanup was called too early

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vicodec: media_device_cleanup was called too early

Robert Richter <rrichter@marvell.com>
    EDAC/ghes: Fix grain calculation

Gwendal Grignou <gwendal@chromium.org>
    iio: cros_ec_baro: set info_mask_shared_by_all_available field

Pi-Hsun Shih <pihsun@chromium.org>
    media: v4l2-ctrl: Lock main_hdl on operations of requests_queued.

Jernej Skrabec <jernej.skrabec@siol.net>
    media: cedrus: Use helpers to access capture queue

Chuhong Yuan <hslester96@gmail.com>
    media: si470x-i2c: add missed operations in remove

Mitch Williams <mitch.a.williams@intel.com>
    ice: delay less

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: atmel - Fix authenc support when it is set to m

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix PDI/stream mapping for Bulk

Mike Isely <isely@pobox.com>
    media: pvrusb2: Fix oops on tear-down when radio support is not present

Masami Hiramatsu <mhiramat@kernel.org>
    selftests: net: Fix printf format warnings on arm

Andrew Jeffery <andrew@aj.id.au>
    fsi: core: Fix small accesses and unaligned offsets via sysfs

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix get invalid tx rate for Mesh metric

Seung-Woo Kim <sw0312.kim@samsung.com>
    media: exynos4-is: fix wrong mdev and v4l2 dev order in error path

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Avoid accidental thread reactivation.

Masami Hiramatsu <mhiramat@kernel.org>
    selftests: proc: Make va_max 1MB

Honglei Wang <honglei.wang@oracle.com>
    cgroup: freezer: don't change task and cgroups status unnecessarily

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Use kvcalloc for addrs array

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix negative FD close() in xsk_setup_xdp_prog()

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Filter out instances except for inlined subroutine and subprogram

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Skip end-of-sequence and non statement lines

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show calling lines of inlined functions

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Return a better scope DIE if there is no best scope

Eric Dumazet <edumazet@google.com>
    net: avoid potential false sharing in neighbor related code

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Skip overlapped location on searching variables

Ian Rogers <irogers@google.com>
    perf parse: If pmu configuration fails free terms

Jason Gunthorpe <jgg@ziepe.ca>
    xen/gntdev: Use select for DMA_SHARED_BUFFER

Michal Swiatkowski <michal.swiatkowski@intel.com>
    ice: Check for null pointer dereference when setting rings

Pan Bian <bianpan2016@163.com>
    drm/amdgpu: fix potential double drop fence reference

Raul E Rangel <rrangel@chromium.org>
    drm/amd/powerplay: fix struct init in renoir_print_clk_levels

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: disallow direct upload save restore list from gfx driver

Ian Rogers <irogers@google.com>
    perf tools: Splice events onto evlist even on error

John Garry <john.garry@huawei.com>
    perf tools: Fix cross compile for ARM64

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to probe a function which has no entry pc

James Clark <James.Clark@arm.com>
    libsubcmd: Use -O0 with DEBUG=1

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show inlined function callsite without entry_pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show ranges of variables in functions without entry_pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to probe an inline function which has no entry pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Walk function lines in lexical blocks

Yunfeng Ye <yeyunfeng@huawei.com>
    perf jevents: Fix resource leak in process_mapfile() and main()

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to list probe event with correct line number

Leo Yan <leo.yan@linaro.org>
    perf cs-etm: Fix definition of macro TO_CS_QUEUE_NR

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to find range-only function instance

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Sharat Masetty <smasetty@codeaurora.org>
    drm: msm: a6xx: fix debug bus register configuration

Kamal Heib <kamalheib1@gmail.com>
    RDMA/core: Fix return code when modify_port isn't supported

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Limit max amount of slave instances

Pan Bian <bianpan2016@163.com>
    spi: img-spfi: fix potential double release

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix PF-VF communication over multi-cos queues.

Thor Thayer <thor.thayer@linux.intel.com>
    spi: dw: Fix Designware SPI loopback

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: media_device_cleanup was called too early

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: topology: set trigger order for FE DAI link

Sebastian Reichel <sebastian.reichel@collabora.com>
    nvmem: core: fix nvmem_cell_write inline function

Lucas Stach <l.stach@pengutronix.de>
    nvmem: imx-ocotp: reset error status on probe

Fabio Estevam <festevam@gmail.com>
    media: staging/imx: Use a shorter name for driver

Max Gurtovoy <maxg@mellanox.com>
    nvme: introduce "Command Aborted By host" status code

Vandana BN <bnvandana@gmail.com>
    media: v4l2-core: fix touch support in v4l_g_fmt

Kangjie Lu <kjlu@umn.edu>
    media: rcar_drif: fix a memory disclosure

Ondrej Jirman <megous@megous.com>
    cpufreq: sun50i: Fix CPU speed bin detection

Manjunath Patil <manjunath.b.patil@oracle.com>
    ixgbe: protect TX timestamping from API misuse

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    pinctrl: amd: fix __iomem annotation in amd_gpio_irq_handler()

Rajendra Nayak <rnayak@codeaurora.org>
    pinctrl: qcom: sc7180: Add missing tile info in SDC_QDSD_PINGROUP/UFS_RESET

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: imx: fix reverse CONFIG_SND_SOC_SOF_OF dependency

Chuhong Yuan <hslester96@gmail.com>
    spi: sifive: disable clk when probe fails and remove

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix missing check of the new non-cached buffer type

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix advertising duplicated flags

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Fix error handling in bpf_map__reuse_fd()

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: dln2-adc: fix iio_triggered_buffer_postenable() position

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: expand sleep just after breaking connections for protocol version 1

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B

Vlad Buslov <vladbu@mellanox.com>
    net/mlx5e: Verify that rule has at least one fwd/drop action

Darrick J. Wong <darrick.wong@oracle.com>
    loop: fix no-unmap write-zeroes request behavior

John Garry <john.garry@huawei.com>
    libata: Ensure ata_port probe has completed before detach

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: add struct netdev_queue debug info for TX timeout

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: add mm_pxd_folded() checks to pxd_free()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390: add error handling to perf_callchain_kernel

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/time: ensure get_clock_monotonic() returns monotonic values

Stephan Gerhold <stephan@gerhold.net>
    phy: qcom-usb-hs: Fix extcon double register after power cycle

Biju Das <biju.das@bp.renesas.com>
    phy: renesas: phy-rcar-gen2: Fix the array off by one warning

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi - implement mst_no_extra_pcms flag

Mao Wenan <maowenan@huawei.com>
    net: dsa: LAN9303: select REGMAP when LAN9303 enable

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Allocate gather copy for host1x

Adham Abozaeid <adham.abozaeid@microchip.com>
    staging: wilc1000: check if device is initialzied before changing vif

Bart Van Assche <bvanassche@acm.org>
    RDMA/core: Set DMA parameters correctly

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix srqs xarray initialization

Colin Ian King <colin.king@canonical.com>
    RDMA/hns: Fix memory leak on 'context' on error return path

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix memory leak in user qp and mr

Hans de Goede <hdegoede@redhat.com>
    ACPI: button: Add DMI quirk for Medion Akoya E2215T

Lingling Xu <ling_ling.xu@unisoc.com>
    spi: sprd: adi: Add missing lock protection when rebooting

Peter Zijlstra <peterz@infradead.org>
    ubsan, x86: Annotate and allow __ubsan_handle_shift_out_of_bounds() in uaccess regions

Dmitry Osipenko <digetx@gmail.com>
    regulator: core: Release coupled_rdevs on regulator_init_coupling() error

Thierry Reding <treding@nvidia.com>
    drm/tegra: sor: Use correct SOR index on Tegra210

Grygorii Strashko <grygorii.strashko@ti.com>
    net: phy: dp83867: enable robust auto-mdix

Jaroslaw Gawin <jaroslawx.gawin@intel.com>
    i40e: Wrong 'Advertised FEC modes' after set FEC to AUTO

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: correctly populate dpp refclk in fpga

Nicholas Nunley <nicholas.d.nunley@intel.com>
    i40e: initialize ITRN registers with correct values

Zhan liu <zhan.liu@amd.com>
    drm/amd/display: setting the DIG_MODE to the correct value.

Yunfeng Ye <yeyunfeng@huawei.com>
    arm64: psci: Reduce the waiting time for cpu_psci_cpu_kill()

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Set grain per DIMM

Steven Price <steven.price@arm.com>
    drm: Don't free jobs in wait_event_interruptible()

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md/bitmap: avoid race window between md_bitmap_resize and bitmap_file_clear_bit

Dan Carpenter <dan.carpenter@oracle.com>
    staging: wilc1000: potential corruption in wilc_parse_join_bss_param()

Yufen Yu <yuyufen@huawei.com>
    md: no longer compare spare disk superblock events in super_load

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: smiapp: Register sensor after enabling runtime PM on the device

Jae Hyun Yoo <jae.hyun.yoo@intel.com>
    media: aspeed: clear garbage interrupts

Chuhong Yuan <hslester96@gmail.com>
    media: imx7-mipi-csis: Add a check for devm_regulator_get

Chuhong Yuan <hslester96@gmail.com>
    media: st-mipid02: add a check for devm_gpiod_get_optional

Benoit Parrot <bparrot@ti.com>
    media: ov5640: Make 2592x1944 mode only available at 15 fps

Ricardo Ribalda Delgado <ribalda@kernel.org>
    media: ad5820: Define entity function

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix stored frame interval not in sync with hardware

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't grab runtime PM refs for HPD IRQs

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    media: aspeed: set hsync and vsync polarities to normal before starting mode detection

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: cedrus: Fix undefined shift with a SHIFT_AND_MASK_BITS macro

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Prevent inconsistent state when moving an interrupt

Corey Minyard <cminyard@mvista.com>
    ipmi: Don't allow device module unload when in use

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix SQ/RQ drain logic

Chris Chiu <chiu@endlessm.com>
    rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-pcm: fixup dpcm_prune_paths() loop continue

Kangjie Lu <kjlu@umn.edu>
    drm/gma500: fix memory disclosures due to uninitialized bytes

Weihang Li <liweihang@hisilicon.com>
    RDMA/hns: Fix wrong parameters when initial mtt of srq->idx_que

Jian Shen <shenjian15@huawei.com>
    net: hns3: log and clear hardware error after reset complete

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Make a copy of subtest name

Leo Yan <leo.yan@linaro.org>
    perf tests: Disable bp_signal testing for arm64

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-battery: Check voltage before orderly_poweroff

Chuhong Yuan <hslester96@gmail.com>
    staging: iio: ad9834: add a check for devm_clk_get

Kevin Wang <kevin1.wang@amd.com>
    drm/amdgpu: fix amdgpu trace event print string format error

joseph gravenor <joseph.gravenor@amd.com>
    drm/amd/display: fix header for RN clk mgr

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: enable hostvm based on roimmu active for dcn2.1

Benjamin Berg <bberg@redhat.com>
    x86/mce: Lower throttling MCE messages' priority to warning

Song Liu <songliubraving@fb.com>
    bpf/stackmap: Fix deadlock with rq_lock in bpf_get_stack()

Mattijs Korpershoek <mkorpershoek@baylibre.com>
    Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Szymon Janc <szymon.janc@codecoup.pl>
    Bluetooth: Workaround directed advertising bug in Broadcom controllers

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    Bluetooth: missed cpu_to_le16 conversion in hci_init4_req

Arnd Bergmann <arnd@arndb.de>
    Bluetooth: btusb: avoid unused function warning

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Reset the device at probe time

Le Ma <le.ma@amd.com>
    drm/amd/powerplay: avoid disabling ECC if RAS is enabled for VEGA20

Ingo Rohloff <ingo.rohloff@lauterbach.com>
    usb: usbfs: Suppress problematic bind and unbind uevents.

John Garry <john.garry@huawei.com>
    perf vendor events arm64: Fix Hisi hip08 DDRC PMU eventname

Leo Yan <leo.yan@linaro.org>
    perf test: Avoid infinite loop for task exit case

Jin Yao <yao.jin@linux.intel.com>
    perf report: Add warning when libunwind not compiled in

Leo Yan <leo.yan@linaro.org>
    perf test: Report failure for mmap events

Daniel Kurtz <djkurtz@chromium.org>
    drm/bridge: dw-hdmi: Restore audio when setting a mode

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: coex: Set 4 slot mode for A2DP

Bjorn Andersson <bjorn.andersson@linaro.org>
    ath10k: Correct error handling of dma_map_single()

Sami Tolvanen <samitolvanen@google.com>
    x86/mm: Use the correct function type for native_set_fixmap()

Julian Parkin <julian.parkin@amd.com>
    drm/amd/display: Program DWB watermarks from correct state

Stephan Gerhold <stephan@gerhold.net>
    extcon: sm5502: Reset registers during initialization

David Galiffi <david.galiffi@amd.com>
    drm/amd/display: Fix dongle_caps containing stale information.

Sami Tolvanen <samitolvanen@google.com>
    syscalls/x86: Use the correct function type in SYSCALL_DEFINE0

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amd/display: add new active dongle to existent w/a

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure about invalid sizeimage

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: wait for set pipe mcp command completion

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Properly round nominal frequency for SPD

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: ensure buffers are cleaned up properly in abort cases

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure causing a kernel panic

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: Make sure YUYV is set as default format

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequence number

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel format

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: Fix Motion Vector vpdma stride

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: enable sync_write in hdac_bus

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    misc: fastrpc: fix memory leak from miscdev->name

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: aegis128/simd - build 32-bit ARM for v8 architecture explicitly

Arnd Bergmann <arnd@arndb.de>
    crypto: inside-secure - Fix a maybe-uninitialized warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cx88: Fix some error handling path in 'cx8800_initdev()'

Hangbin Liu <liuhangbin@gmail.com>
    team: call RCU read lock when walking the port_list

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: increase device refcount for added link group

Ilya Maximets <i.maximets@ovn.org>
    libbpf: Fix passing uninitialized bytes to setsockopt

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix struct end padding in btf_dump

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix btf_dump padding test case

Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
    drm/drm_vblank: Change EINVAL by the correct errno

Navid Emamdoost <navid.emamdoost@gmail.com>
    mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Paul Burton <paulburton@kernel.org>
    MIPS: futex: Emit Loongson3 sync workarounds within asm

Oak Zeng <Oak.Zeng@amd.com>
    drm/amdkfd: Fix MQD size calculation

Paul Burton <paulburton@kernel.org>
    MIPS: syscall: Emit Loongson3 sync workarounds within asm

Bart Van Assche <bvanassche@acm.org>
    block: Fix writeback throttling W=1 compiler warnings

Daniel T. Lee <danieltimlee@gmail.com>
    samples: pktgen: fix proc_cmd command result check logic

Matthias Kaehlcke <mka@chromium.org>
    drm/bridge: dw-hdmi: Refuse DDC/CI transfers on the internal I2C controller

Neil Armstrong <narmstrong@baylibre.com>
    media: meson/ao-cec: move cec_notifier_cec_adap_register after hw setup

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-funcs.h: add status_req checks

Yang Yingliang <yangyingliang@huawei.com>
    media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()

Alan Stern <stern@rowland.harvard.edu>
    tools/memory-model: Fix data race detection for unordered store and load

Yizhuo <yzhai003@ucr.edu>
    regulator: max8907: Fix the usage of uninitialized variable in max8907_regulator_probe()

Tony Lindgren <tony@atomide.com>
    hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not idled

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: aegis128-neon - use Clang compatible cflags for ARM

Veeraiyan Chidambaram <veeraiyan.chidambaram@in.bosch.com>
    usb: renesas_usbhs: add suspend event support in gadget mode

Raul E Rangel <rrangel@chromium.org>
    drm/amd/display: fix struct init in update_bounding_box

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: fix NSS of hw_cap

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: Fix occasionally failures to suspend

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: set minimum abm backlight level

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    selftests/bpf: Correct path to include msg + path

chen gong <curry.gong@amd.com>
    drm/amd/powerplay: A workaround to GPU RESET on APU

Arnd Bergmann <arnd@arndb.de>
    x86/math-emu: Check __copy_from_user() result

Allen Pais <allen.pais@oracle.com>
    drm/amdkfd: fix a potential NULL pointer dereference (v2)

Jagan Teki <jagan@amarulasolutions.com>
    drm/sun4i: dsi: Fix TCON DRQ set bits

Will Deacon <will@kernel.org>
    pinctrl: devicetree: Avoid taking direct reference to device name string

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Set number of pipes to 1 if the second pipe was disabled

Shuah Khan <skhan@linuxfoundation.org>
    media: vimc: Fix gpf in rmmod path when stream is active

Ben Greear <greearb@candelatech.com>
    ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq

Loic Poulain <loic.poulain@linaro.org>
    media: venus: core: Fix msm8996 frequency table

Nathan Chancellor <natechancellor@gmail.com>
    tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix stored crop rectangle not in sync with hardware

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix stored frame format not in sync with hardware

Benoit Parrot <bparrot@ti.com>
    media: i2c: ov2659: Fix missing 720p register config

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix crop rectangle alignment not passed back

Benoit Parrot <bparrot@ti.com>
    media: i2c: ov2659: fix s_stream return value

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix control handler not freed on init error

YueHaibing <yuehaibing@huawei.com>
    media: max2175: Fix build error without CONFIG_REGMAP_I2C

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: vim2m: Fix BUG_ON in vim2m_device_release()

Jernej Skrabec <jernej.skrabec@siol.net>
    media: vim2m: Fix abort issue

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: seco-cec: Add a missing 'release_region()' in an error handling path

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cedrus: fill in bus_info for media device

Benoit Parrot <bparrot@ti.com>
    media: am437x-vpfe: Setting STD to current value is not an error

Navid Emamdoost <navid.emamdoost@gmail.com>
    spi: gpio: prevent memory leak in spi_gpio_probe

Mihail Atanassov <Mihail.Atanassov@arm.com>
    drm/komeda: Workaround for broken FLIP_COMPLETE timestamps

Max Gurtovoy <maxg@mellanox.com>
    IB/iser: bound protection_sg size by data_sg size

Anilkumar Kolli <akolli@codeaurora.org>
    ath10k: fix backtrace on coredump

Geert Uytterhoeven <geert+renesas@glider.be>
    Revert "pinctrl: sh-pfc: r8a77990: Fix MOD_SEL1 bit31 when using SIM0_D"

Geert Uytterhoeven <geert+renesas@glider.be>
    Revert "pinctrl: sh-pfc: r8a77990: Fix MOD_SEL1 bit30 when using SSI_SCK2 and SSI_WS2"

Allen Pais <allen.pais@oracle.com>
    libertas: fix a potential NULL pointer dereference

Navid Emamdoost <navid.emamdoost@gmail.com>
    rtlwifi: prevent memory leak in rtl_usb_probe

Connor Kuehl <connor.kuehl@canonical.com>
    staging: rtl8188eu: fix possible null dereference

Navid Emamdoost <navid.emamdoost@gmail.com>
    staging: rtl8192u: fix multiple memory leaks on error path

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: vclk: use the correct G12A frac max value

Lukasz Majewski <lukma@denx.de>
    spi: Add call to spi_slave_abort() function when spidev driver is released

Hauke Mehrtens <hauke@hauke-m.de>
    ath10k: Check if station exists before forwarding tx airtime report

Martin Tsai <martin.tsai@amd.com>
    drm/amd/display: Handle virtual signal type in disable_link()

Wenwen Wang <wenwen@cs.uga.edu>
    ath10k: add cleanup in ath10k_sta_state()

Mikita Lipski <mikita.lipski@amd.com>
    drm/amd/display: Rebuild mapped resources after pipe split

Christian König <christian.koenig@amd.com>
    drm/ttm: return -EBUSY on pipelining with no_gpu_wait (v2)

Christian König <christian.koenig@amd.com>
    drm/amdgpu: grab the id mgr lock while accessing passid_mapping

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amdgpu/sriov: add ring_stop before ring_create in psp v11 code

Krzysztof Wilczynski <kw@linux.com>
    iio: light: bh1750: Resolve compiler warning and make code more readable

Andrea Merello <andrea.merello@gmail.com>
    iio: max31856: add missing of_node and parent references to iio_dev

Jaehyun Chung <jaehyun.chung@amd.com>
    drm/amd/display: OTC underflow fix

Brian Masney <masneyb@onstation.org>
    drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings

Jing Zhou <Jing.Zhou@amd.com>
    drm/amd/display: verify stream link before link test

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm: Use EOPNOTSUPP, not ENOTSUPP

Dariusz Marcinkiewicz <darekm@google.com>
    drm: exynos: exynos_hdmi: use cec_notifier_conn_(un)register

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/panel: Add missing drm_panel_init() in panel drivers

Dan Carpenter <dan.carpenter@oracle.com>
    drm/mipi-dbi: fix a loop in debugfs code

Sean Paul <seanpaul@chromium.org>
    drm: mst: Fix query_payload ack reply struct

Gerd Hoffmann <kraxel@redhat.com>
    drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper.

Dariusz Marcinkiewicz <darekm@google.com>
    drm/vc4/vc4_hdmi: fill in connector info

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix work handling in delayed HP detection

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Avoid endless loop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Keep power on during processing DSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Avoid possible info leaks from PCM stream buffers

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix removal logic of the tree mod log that leads to use-after-free issues

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle ENOENT in btrfs_uuid_tree_iterate

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not leak reloc root if we fail to read the fs root

Josef Bacik <josef@toxicpanda.com>
    btrfs: skip log replay on orphaned roots

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort transaction after failed inode updates in create_subvol

Anand Jain <anand.jain@oracle.com>
    btrfs: send: remove WARN_ON for readonly mount

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix missing data checksums after replaying a log tree

Dan Carpenter <dan.carpenter@oracle.com>
    btrfs: return error pointer from alloc_test_extent_buffer

Filipe Manana <fdmanana@suse.com>
    Btrfs: make tree checker detect checksum items with overlapping ranges

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not call synchronize_srcu() in inode_tree_del

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't double lock the subvol_sem for rename exchange

Stephan Gerhold <stephan@gerhold.net>
    NFC: nxp-nci: Fix probing without ACPI

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Fix egress flooding settings

Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
    net: stmmac: platform: Fix MDIO init for platforms without PHY

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: davinci_cpdma: fix warning "device driver frees DMA memory with different size"

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Remove unlikely user-triggerable warning

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-ptp: fix double free of the ptp_qoriq IRQ

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix issues in setting interrupt moderation params in ethtool

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix default tx interrupt moderation interval

Eric Dumazet <edumazet@google.com>
    bonding: fix bond_neigh_init()

Eric Dumazet <edumazet@google.com>
    neighbour: remove neigh_cleanup() method

Ido Schimmel <idosch@mellanox.com>
    selftests: forwarding: Delete IPv6 address at the end

Xin Long <lucien.xin@gmail.com>
    sctp: fully initialize v4 addr in some functions

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix memleak on err handling of stream initialization

Manish Chopra <manishc@marvell.com>
    qede: Fix multicast mac configuration

Manish Chopra <manishc@marvell.com>
    qede: Disable hardware gro when xdp prog is installed

John Hurley <john.hurley@netronome.com>
    nfp: flower: fix stats id allocation

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix suspend/resume PHY register access error

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in rx_queue_add_kobject

Ben Hutchings <ben@decadent.org.uk>
    net: qlogic: Fix error paths in ql_alloc_large_buffers()

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: ensure that phy IDs are correctly typed

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart_tty_receive()

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Navid Emamdoost <navid.emamdoost@gmail.com>
    net: gemini: Fix memory leak in gmac_setup_txqs

Geert Uytterhoeven <geert@linux-m68k.org>
    net: dst: Force 4-byte alignment of dst_metrics

Russell King <rmk+kernel@armlinux.org.uk>
    mod_devicetable: fix PHY module format

Chuhong Yuan <hslester96@gmail.com>
    fjes: fix missed check in fjes_acpi_add

Mao Wenan <maowenan@huawei.com>
    af_packet: set defaule value for tmo


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi     |   4 +-
 arch/arm64/kernel/psci.c                           |  15 ++-
 arch/arm64/kvm/sys_regs.c                          |   5 +-
 arch/mips/include/asm/barrier.h                    |  13 +-
 arch/mips/include/asm/futex.h                      |  15 +--
 arch/mips/include/asm/pgtable-64.h                 |   9 +-
 arch/mips/kernel/syscall.c                         |   3 +-
 arch/mips/ralink/Kconfig                           |   1 +
 arch/powerpc/include/asm/spinlock.h                |   4 +-
 arch/powerpc/kernel/irq.c                          |   4 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   4 +-
 arch/powerpc/platforms/pseries/setup.c             |   7 +
 arch/s390/crypto/sha_common.c                      |   7 +-
 arch/s390/include/asm/pgalloc.h                    |  16 ++-
 arch/s390/include/asm/timex.h                      |  16 ++-
 arch/s390/kernel/dis.c                             |  13 +-
 arch/s390/kernel/perf_cpum_cf.c                    |  21 ++-
 arch/s390/kernel/perf_cpum_cf_diag.c               |  10 +-
 arch/s390/kernel/perf_event.c                      |   8 +-
 arch/s390/mm/maccess.c                             |  12 +-
 arch/s390/net/bpf_jit_comp.c                       |   5 +-
 arch/sh/include/cpu-sh4/cpu/sh7734.h               |   2 +-
 arch/x86/include/asm/crash.h                       |   2 +
 arch/x86/include/asm/fixmap.h                      |   2 +-
 arch/x86/include/asm/syscall_wrapper.h             |  23 ++--
 arch/x86/kernel/apic/io_apic.c                     |   9 +-
 arch/x86/kernel/cpu/mce/amd.c                      |   4 +-
 arch/x86/kernel/cpu/mce/core.c                     |   2 +-
 arch/x86/kernel/cpu/mce/therm_throt.c              |   2 +-
 arch/x86/kernel/early-quirks.c                     |   2 +
 arch/x86/kvm/cpuid.c                               |   6 +-
 arch/x86/lib/x86-opcode-map.txt                    |  18 ++-
 arch/x86/math-emu/fpu_system.h                     |   6 +-
 arch/x86/math-emu/reg_ld_str.c                     |   6 +-
 arch/x86/mm/pgtable.c                              |   4 +-
 block/blk-iocost.c                                 |  13 +-
 crypto/Kconfig                                     |   1 +
 crypto/Makefile                                    |   2 +-
 crypto/asymmetric_keys/asym_tpm.c                  |   1 +
 crypto/asymmetric_keys/public_key.c                |   1 +
 drivers/acpi/button.c                              |  11 ++
 drivers/ata/libata-core.c                          |   3 +
 drivers/base/firmware_loader/builtin/Makefile      |   3 +-
 drivers/block/loop.c                               |  26 ++--
 drivers/block/nbd.c                                |   6 +-
 drivers/bluetooth/btusb.c                          |   5 +-
 drivers/char/hw_random/omap3-rom-rng.c             |   3 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  23 +++-
 drivers/char/tpm/tpm-dev-common.c                  |   8 ++
 drivers/char/tpm/tpm_tis_core.c                    |  35 ++---
 drivers/clk/imx/clk-composite-8m.c                 |   2 +
 drivers/clk/imx/clk-imx7ulp.c                      |   1 +
 drivers/clk/imx/clk-pll14xx.c                      |   2 +-
 drivers/cpufreq/cpufreq.c                          |   7 +
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |  25 ++--
 drivers/crypto/atmel-aes.c                         |  18 +--
 drivers/crypto/atmel-authenc.h                     |   2 +-
 drivers/crypto/atmel-sha.c                         |   2 +-
 drivers/crypto/inside-secure/safexcel.c            |   2 +
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |  22 ++--
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  12 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |  12 +-
 drivers/crypto/vmx/Makefile                        |   6 +-
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/edac/ghes_edac.c                           |  10 +-
 drivers/extcon/extcon-sm5502.c                     |   4 +
 drivers/extcon/extcon-sm5502.h                     |   2 +
 drivers/firmware/efi/efi.c                         |  28 +++-
 drivers/fsi/fsi-core.c                             |  31 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  10 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_test.c           |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h          |  18 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |  61 +++++----
 drivers/gpu/drm/amd/amdgpu/si_ih.c                 |   3 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c         |   5 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |  10 +-
 .../dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c        |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  17 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   4 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c       |   3 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   5 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c  |   4 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   7 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c    |  40 +++---
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h  |   6 +-
 .../drm/amd/display/include/ddc_service_types.h    |   2 +
 .../drm/amd/display/modules/freesync/freesync.c    |  13 +-
 .../drm/amd/display/modules/power/power_helpers.c  |  77 ++++++-----
 .../drm/amd/display/modules/power/power_helpers.h  |   1 +
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c         |   5 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c  |  12 +-
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c         |   4 +-
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c   |   2 +
 drivers/gpu/drm/bridge/analogix-anx78xx.c          |   8 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  12 +-
 drivers/gpu/drm/drm_edid.c                         |   6 +-
 drivers/gpu/drm/drm_mipi_dbi.c                     |   5 +-
 drivers/gpu/drm/drm_vblank.c                       |   6 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  31 +++--
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |   2 +
 drivers/gpu/drm/meson/meson_vclk.c                 |   9 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |  24 ++--
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  33 ++---
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  |   1 +
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c     |   1 +
 drivers/gpu/drm/scheduler/sched_main.c             |  43 ++++---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |   4 +-
 drivers/gpu/drm/tegra/sor.c                        |   5 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  44 ++++---
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  13 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  28 ++--
 drivers/gpu/host1x/job.c                           |  11 +-
 drivers/hwtracing/intel_th/core.c                  |   7 +-
 drivers/hwtracing/intel_th/intel_th.h              |   2 +
 drivers/hwtracing/intel_th/msu.c                   |  14 +-
 drivers/hwtracing/intel_th/pci.c                   |  10 ++
 drivers/iio/adc/dln2-adc.c                         |  20 ++-
 drivers/iio/adc/max1027.c                          |   8 ++
 drivers/iio/dac/Kconfig                            |   4 +-
 drivers/iio/dac/ad5446.c                           |   6 +
 drivers/iio/light/bh1750.c                         |   4 +-
 drivers/iio/pressure/cros_ec_baro.c                |   3 +
 drivers/iio/temperature/max31856.c                 |   2 +
 drivers/infiniband/core/device.c                   |  22 +++-
 drivers/infiniband/hw/bnxt_re/main.c               |   9 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |   8 +-
 drivers/infiniband/hw/efa/efa_com.c                |   5 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |  10 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |  24 ++--
 drivers/infiniband/hw/qedr/main.c                  |   1 +
 drivers/infiniband/hw/qedr/verbs.c                 |  12 +-
 drivers/infiniband/sw/siw/siw_main.c               |  20 ---
 drivers/infiniband/sw/siw/siw_verbs.c              | 143 +++++++++++++++++----
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   1 +
 drivers/iommu/intel-iommu.c                        |  12 +-
 drivers/iommu/iommu.c                              |   8 +-
 drivers/md/bcache/alloc.c                          |   5 +-
 drivers/md/bcache/bcache.h                         |   2 +-
 drivers/md/bcache/super.c                          |  51 ++++++--
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/md/md.c                                    |  46 ++++++-
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/ad5820.c                         |   1 +
 drivers/media/i2c/ov2659.c                         |  18 ++-
 drivers/media/i2c/ov5640.c                         |   5 +
 drivers/media/i2c/ov6650.c                         |  75 ++++++-----
 drivers/media/i2c/smiapp/smiapp-core.c             |  12 +-
 drivers/media/i2c/st-mipid02.c                     |   5 +
 drivers/media/pci/cx88/cx88-video.c                |  11 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   4 +
 drivers/media/platform/aspeed-video.c              |  12 ++
 drivers/media/platform/exynos4-is/media-dev.c      |   7 +-
 drivers/media/platform/meson/ao-cec-g12a.c         |  36 +++---
 drivers/media/platform/meson/ao-cec.c              |  30 ++---
 drivers/media/platform/qcom/venus/core.c           |   9 +-
 drivers/media/platform/qcom/venus/hfi_venus.c      |   6 +
 drivers/media/platform/rcar_drif.c                 |   1 +
 drivers/media/platform/seco-cec/seco-cec.c         |   1 +
 drivers/media/platform/ti-vpe/vpdma.h              |   1 +
 drivers/media/platform/ti-vpe/vpe.c                |  52 ++++++--
 drivers/media/platform/vicodec/vicodec-core.c      |   4 +-
 drivers/media/platform/vim2m.c                     |   8 +-
 drivers/media/platform/vimc/vimc-common.c          |   3 +-
 drivers/media/platform/vimc/vimc-debayer.c         |   1 +
 drivers/media/platform/vimc/vimc-scaler.c          |   1 +
 drivers/media/platform/vimc/vimc-sensor.c          |   1 +
 drivers/media/platform/vivid/vivid-core.c          |   4 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +
 drivers/media/usb/b2c2/flexcop-usb.c               |   8 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   9 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   7 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  33 ++---
 drivers/misc/fastrpc.c                             |   4 +-
 drivers/misc/ocxl/file.c                           |  23 ++--
 drivers/mmc/host/mtk-sd.c                          |   2 +
 drivers/mmc/host/sdhci-msm.c                       |  28 ++--
 drivers/mmc/host/sdhci-of-esdhc.c                  |   7 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  10 +-
 drivers/mmc/host/sdhci.c                           |  11 +-
 drivers/mmc/host/sdhci.h                           |   2 +
 drivers/mmc/host/tmio_mmc_core.c                   |   2 +-
 drivers/net/bonding/bond_main.c                    |  39 +++---
 drivers/net/can/flexcan.c                          |  73 ++++++-----
 drivers/net/can/m_can/tcan4x5x.c                   |   2 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   6 +-
 drivers/net/can/xilinx_can.c                       |   7 +
 drivers/net/dsa/Kconfig                            |   1 +
 drivers/net/dsa/b53/b53_common.c                   |  21 ++-
 drivers/net/dsa/sja1105/sja1105_main.c             |   4 +
 drivers/net/ethernet/amazon/ena/ena_com.h          |   2 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  24 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  16 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +
 drivers/net/ethernet/cortina/gemini.c              |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |  14 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  19 +--
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  13 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  32 ++---
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h      |   5 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  13 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  18 ++-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   7 +-
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  12 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   4 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   8 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  18 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +-
 drivers/net/ethernet/ti/Kconfig                    |   1 +
 drivers/net/ethernet/ti/cpsw_ale.c                 |   2 +
 drivers/net/ethernet/ti/davinci_cpdma.c            |   5 +-
 drivers/net/fjes/fjes_main.c                       |   3 +
 drivers/net/phy/dp83867.c                          |  15 ++-
 drivers/net/phy/phy_device.c                       |  21 +--
 drivers/net/team/team.c                            |   5 +-
 drivers/net/tun.c                                  |   4 +-
 drivers/net/usb/lan78xx.c                          |   1 +
 drivers/net/wireless/ath/ath10k/coredump.c         |  11 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  26 ++--
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  13 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  25 ----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  30 +++++
 drivers/net/wireless/marvell/libertas/if_sdio.c    |   5 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   7 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |   6 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   2 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |  24 ++--
 drivers/net/wireless/realtek/rtw88/main.c          |   3 +-
 drivers/nfc/nxp-nci/i2c.c                          |   2 +-
 drivers/nvme/host/core.c                           |  14 +-
 drivers/nvme/host/multipath.c                      |   1 +
 drivers/nvmem/imx-ocotp.c                          |   4 +
 drivers/parport/share.c                            |  21 +++
 drivers/phy/qualcomm/phy-qcom-usb-hs.c             |   7 +-
 drivers/phy/renesas/phy-rcar-gen2.c                |   5 +-
 drivers/pinctrl/devicetree.c                       |  25 +++-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |  81 ++++++------
 drivers/pinctrl/pinctrl-amd.c                      |   3 +-
 drivers/pinctrl/qcom/pinctrl-sc7180.c              |  18 +--
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c              |  25 ++--
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   4 +-
 drivers/platform/x86/hp-wmi.c                      |   2 +-
 drivers/power/supply/cpcap-battery.c               |   8 +-
 drivers/regulator/core.c                           |   5 +-
 drivers/regulator/max8907-regulator.c              |  15 ++-
 drivers/soundwire/intel.c                          |  10 +-
 drivers/spi/spi-cadence.c                          |   6 +-
 drivers/spi/spi-dw.c                               |   8 +-
 drivers/spi/spi-fsl-spi.c                          |   7 +-
 drivers/spi/spi-gpio.c                             |   4 +-
 drivers/spi/spi-img-spfi.c                         |   2 +
 drivers/spi/spi-pxa2xx.c                           |   6 +
 drivers/spi/spi-sifive.c                           |  11 +-
 drivers/spi/spi-sprd-adi.c                         |   3 +
 drivers/spi/spi-st-ssc4.c                          |   3 +
 drivers/spi/spi-tegra20-slink.c                    |   5 +-
 drivers/spi/spidev.c                               |   3 +
 drivers/staging/comedi/drivers/gsc_hpdi.c          |  10 ++
 drivers/staging/fbtft/fbtft-core.c                 |   2 +-
 drivers/staging/iio/frequency/ad9834.c             |   4 +
 drivers/staging/media/imx/imx-media-capture.c      |   6 +-
 drivers/staging/media/imx/imx7-mipi-csis.c         |   7 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   2 +
 drivers/staging/media/sunxi/cedrus/cedrus.h        |   8 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   8 +-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |  31 +++--
 drivers/staging/mt7621-pci/Kconfig                 |   1 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |   4 +-
 drivers/staging/rtl8192u/r8192U_core.c             |  17 ++-
 drivers/staging/wilc1000/wilc_hif.c                |   2 +
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |  18 ++-
 drivers/tty/serial/atmel_serial.c                  |  43 ++++---
 drivers/tty/serial/sprd_serial.c                   |   3 +
 drivers/usb/core/devio.c                           |  15 ++-
 drivers/usb/host/ehci-q.c                          |  13 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/renesas_usbhs/common.h                 |   3 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |  12 +-
 drivers/usb/usbip/usbip_common.c                   |   3 +
 drivers/usb/usbip/vhci_rx.c                        |  13 +-
 drivers/xen/Kconfig                                |   3 +-
 fs/btrfs/async-thread.c                            |  56 ++++++--
 fs/btrfs/ctree.c                                   |   2 +-
 fs/btrfs/ctree.h                                   |   2 +-
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent-tree.c                             |   7 +-
 fs/btrfs/extent_io.c                               |   6 +-
 fs/btrfs/file-item.c                               |   7 +-
 fs/btrfs/inode.c                                   |  12 +-
 fs/btrfs/ioctl.c                                   |  10 +-
 fs/btrfs/reada.c                                   |  10 +-
 fs/btrfs/relocation.c                              |   1 +
 fs/btrfs/scrub.c                                   |   3 +-
 fs/btrfs/send.c                                    |   6 -
 fs/btrfs/tests/free-space-tree-tests.c             |   4 +-
 fs/btrfs/tests/qgroup-tests.c                      |   4 +-
 fs/btrfs/tree-checker.c                            |  18 ++-
 fs/btrfs/tree-log.c                                |  52 +++++++-
 fs/btrfs/uuid-tree.c                               |   2 +
 fs/ext4/dir.c                                      |   5 +
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/namei.c                                    |  32 +++--
 fs/ext4/super.c                                    | 143 ++++++++++-----------
 include/drm/drm_dp_mst_helper.h                    |   2 +-
 include/linux/cpufreq.h                            |  11 --
 include/linux/ipmi_smi.h                           |  12 +-
 include/linux/mod_devicetable.h                    |   4 +-
 include/linux/nvme.h                               |   1 +
 include/linux/nvmem-consumer.h                     |   2 +-
 include/linux/phy.h                                |   2 +-
 include/linux/sched/cpufreq.h                      |   3 +
 include/net/arp.h                                  |   4 +-
 include/net/dst.h                                  |   2 +-
 include/net/ndisc.h                                |   8 +-
 include/net/neighbour.h                            |   1 -
 include/net/sock.h                                 |  12 +-
 include/sound/hda_codec.h                          |   1 +
 include/trace/events/wbt.h                         |  12 +-
 include/uapi/linux/cec-funcs.h                     |   6 +-
 kernel/bpf/stackmap.c                              |   7 +-
 kernel/bpf/verifier.c                              |  19 +++
 kernel/cgroup/freezer.c                            |   9 ++
 kernel/events/core.c                               |   6 +-
 kernel/sched/core.c                                |   6 +-
 kernel/sched/cpufreq.c                             |  18 +++
 kernel/sched/cpufreq_schedutil.c                   |   8 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace_kprobe.c                        |  27 +++-
 lib/ubsan.c                                        |   5 +-
 mm/vmscan.c                                        |   2 +-
 net/bluetooth/hci_conn.c                           |   8 ++
 net/bluetooth/hci_core.c                           |  13 +-
 net/bluetooth/hci_request.c                        |   9 ++
 net/can/j1939/socket.c                             |  10 +-
 net/core/neighbour.c                               |   3 -
 net/core/net-sysfs.c                               |   7 +-
 net/mac80211/status.c                              |   3 +-
 net/nfc/nci/uart.c                                 |   2 +-
 net/packet/af_packet.c                             |   3 +-
 net/sctp/protocol.c                                |   5 +
 net/sctp/stream.c                                  |   8 +-
 net/smc/smc_core.c                                 |   9 +-
 samples/pktgen/functions.sh                        |  17 ++-
 sound/core/pcm_native.c                            |   7 +-
 sound/core/timer.c                                 |  10 ++
 sound/firewire/bebob/bebob_stream.c                |  11 +-
 sound/pci/hda/patch_ca0132.c                       |  23 +++-
 sound/pci/hda/patch_hdmi.c                         |  19 ++-
 sound/soc/codecs/rt5677.c                          |   1 +
 sound/soc/codecs/wm2200.c                          |   5 +
 sound/soc/codecs/wm5100.c                          |   2 +
 sound/soc/codecs/wm8904.c                          |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  10 +-
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   3 +
 sound/soc/soc-pcm.c                                |  14 +-
 sound/soc/sof/imx/Kconfig                          |   8 +-
 sound/soc/sof/intel/hda.c                          |   1 +
 sound/soc/sof/topology.c                           |   4 +
 tools/arch/x86/lib/x86-opcode-map.txt              |  18 ++-
 tools/bpf/Makefile                                 |   6 +
 tools/lib/bpf/btf_dump.c                           |   8 +-
 tools/lib/bpf/libbpf.c                             |  14 +-
 tools/lib/bpf/xsk.c                                |  14 +-
 tools/lib/subcmd/Makefile                          |   4 +-
 tools/lib/traceevent/parse-filter.c                |   9 +-
 tools/memory-model/linux-kernel.cat                |   2 +-
 tools/objtool/check.c                              |   1 +
 tools/perf/arch/arm64/util/sym-handling.c          |   3 +-
 tools/perf/builtin-report.c                        |   7 +
 .../arch/arm64/hisilicon/hip08/uncore-ddrc.json    |   2 +-
 tools/perf/pmu-events/jevents.c                    |  13 +-
 tools/perf/tests/bp_signal.c                       |  15 +--
 tools/perf/tests/task-exit.c                       |   9 ++
 tools/perf/util/cs-etm.c                           |   4 +-
 tools/perf/util/dwarf-aux.c                        |  56 ++++++--
 tools/perf/util/parse-events.c                     |  26 +++-
 tools/perf/util/probe-finder.c                     |  45 ++++++-
 tools/perf/util/session.c                          |  44 ++++---
 .../cpupower/utils/idle_monitor/hsw_ext_idle.c     |   1 -
 tools/testing/selftests/bpf/cgroup_helpers.c       |   2 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |   5 +-
 tools/testing/selftests/bpf/progs/test_seg6_loop.c |   4 +-
 .../selftests/bpf/progs/test_sysctl_loop1.c        |   5 +-
 tools/testing/selftests/bpf/test_progs.c           |  17 ++-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   5 +
 .../selftests/net/forwarding/router_bridge_vlan.sh |   2 +-
 tools/testing/selftests/net/so_txtime.c            |   4 +-
 tools/testing/selftests/net/tls.c                  |  28 ----
 tools/testing/selftests/net/udpgso.c               |   3 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |   3 +-
 .../selftests/proc/proc-self-map-files-002.c       |   6 +-
 virt/kvm/arm/mmu.c                                 |  21 ++-
 425 files changed, 3076 insertions(+), 1511 deletions(-)


