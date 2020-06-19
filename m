Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42743200F65
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404161AbgFSPRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404150AbgFSPRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5293F21582;
        Fri, 19 Jun 2020 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579831;
        bh=42P6nSWzhy7LAvkUTGWNJ1onWypRcSW/WsdhjIzozhM=;
        h=From:To:Cc:Subject:Date:From;
        b=wazskX+HIoHXsFPmDXjXnGdYg0PUUC4ZRtvjzqsrn2HTdxcRCUEUOTZ7rLv//kxHK
         F/l1vw/r2rLzl7/koICLbIfplyTXllKXDmfMXIaQ5AETogy2CuWeyI5GS6mA6Qbfyl
         wQVe9dBVJCTkrfhqL7PCk0fwx2F8W77E6cT/koBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 000/376] 5.7.5-rc1 review
Date:   Fri, 19 Jun 2020 16:28:38 +0200
Message-Id: <20200619141710.350494719@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.5-rc1
X-KernelTest-Deadline: 2020-06-21T14:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.5 release.
There are 376 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.5-rc1

Adrian Hunter <adrian.hunter@intel.com>
    perf symbols: Fix kernel maps for kcore and eBPF

Adrian Hunter <adrian.hunter@intel.com>
    perf symbols: Fix debuginfo search for Ubuntu

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Check address correctness by map instead of _etext

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to check blacklist address correctly

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not show the skipped events

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix checkpoint=disable:%u%%

Eric Biggers <ebiggers@google.com>
    f2fs: don't leak filename in f2fs_try_convert_inline_dir()

H. Nikolaus Schaller <hns@goldelico.com>
    w1: omap-hdq: fix interrupt handling which did show spurious timeouts

H. Nikolaus Schaller <hns@goldelico.com>
    w1: omap-hdq: fix return value to be -1 if there is a timeout

H. Nikolaus Schaller <hns@goldelico.com>
    w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: tmio: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: mtk: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: pasemi: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: plat_nand: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: sunxi: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: oxnas: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: socrates: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: orion: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: xway: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: ingenic: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: sharpsl: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: diskonchip: Fix the probe error path

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix hamming oob layout

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: onfi: Fix redundancy detection check

Boris Brezillon <boris.brezillon@collabora.com>
    mtd: rawnand: Fix nand_gpio_waitrdy()

Paul Cercueil <paul@crapouillou.net>
    pwm: jz4740: Enhance precision in calculation of duty cycle

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Fix get_state runtime-pm reference handling

Anup Patel <anup.patel@wdc.com>
    RISC-V: Don't mark init section as non-executable

Ahmed S. Darwish <a.darwish@linutronix.de>
    block: nr_sects_write(): Disable preemption on seqcount write

NeilBrown <neilb@suse.de>
    sunrpc: clean up properly in gss_mech_unregister()

NeilBrown <neilb@suse.de>
    sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    virtio-balloon: Disable free page reporting if page poison reporting is not enabled

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: force to build vmlinux if CONFIG_MODVERSION=y

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Save FSCR to init_task.thread.fscr after feature init

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Don't let DT CPU features set FSCR_DSCR

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Disable KASAN with pages bigger than 16k

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/kasan: Fix shadow pages allocation failure

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/kasan: Fix issues by lowering KASAN_SHADOW_END

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix another build failure with CONFIG_PPC_KUAP_DEBUG

Michael Ellerman <mpe@ellerman.id.au>
    drivers/macintosh: Fix memleak in windfarm_pm112 driver

Jonathan Bakker <xc-racer2@live.ca>
    ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3 CM36651 sensor's bus

Jan Kara <jack@suse.cz>
    jbd2: avoid leaking transaction credits when unreserving handle

Corentin Labbe <clabbe@baylibre.com>
    soc/tegra: pmc: Select GENERIC_PINCONF

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Douglas Anderson <dianders@chromium.org>
    kernel/cpu_pm: Fix uninitted local in cpu_pm

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: Account for memory_limit while reserving memory

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: consider reserved ranges while reserving memory

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: use static allocation for reserved memory ranges

Bernard Zhao <bernard@vivo.com>
    memory: samsung: exynos5422-dmc: Fix tFAW timings alignment

Mikulas Patocka <mpatocka@redhat.com>
    alpha: fix memory barriers so that they conform to the specification

Eric Biggers <ebiggers@google.com>
    dm crypt: avoid truncating the logical block size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    software node: implement software_node_unregister()

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()

Al Viro <viro@zeniv.linux.org.uk>
    sparc32: fix register window handling in genregs32_[gs]et()

Wei Yongjun <weiyongjun1@huawei.com>
    gnss: sirf: fix error return code in sirf_probe()

Jonathan Bakker <xc-racer2@live.ca>
    pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs

Jonathan Bakker <xc-racer2@live.ca>
    pinctrl: samsung: Correct setting of eint wakeup mask on s5pv210

Qiushi Wu <wu000273@umn.edu>
    power: supply: core: fix memory leak in HWMON error path

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    power: supply: core: fix HWMON temperature labels

Anders Roxell <anders.roxell@linaro.org>
    power: vexpress: add suppress_bind_attrs to true

Jon Derrick <jonathan.derrick@intel.com>
    iommu/vt-d: Allocate domain info for real DMA sub-devices

Jon Derrick <jonathan.derrick@intel.com>
    iommu/vt-d: Only clear real DMA device's context entries

Alexander Monakov <amonakov@ispras.ru>
    EDAC/amd64: Add AMD family 17h model 60h PCI IDs

Alexander Monakov <amonakov@ispras.ru>
    hwmon: (k10temp) Add AMD family 17h model 60h PCI match

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Report speed and duplex as unknown when device is runtime suspended

Weiyi Lu <weiyi.lu@mediatek.com>
    clk: mediatek: assign the initial value to clk_init_data of mtk_mux

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: musb: mediatek: add reset FADDR to zero in reset interrupt handle

Tomi Valkeinen <tomi.valkeinen@ti.com>
    media: ov5640: fix use of destroyed mutex

Larry Finger <Larry.Finger@lwfinger.net>
    b43_legacy: Fix connection problem with WPA3

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix connection problem with WPA3

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix case where channel status is corrupted

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    Bluetooth: hci_bcm: fix freeing not-requested IRQ

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    Bluetooth: hci_bcm: respect IRQ polarity from DT

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Avoid error message on reprobe

Samuel Holland <samuel@sholland.org>
    media: cedrus: Program output format during each run

Michael Ellerman <mpe@ellerman.id.au>
    clocksource/drivers/timer-microchip-pit64b: Select CONFIG_TIMER_OF

Thomas Gleixner <tglx@linutronix.de>
    clocksource: Remove obsolete ifdef

Christian Lamparter <chunkeey@gmail.com>
    carl9170: remove P2P_GO support

Anup Patel <anup.patel@wdc.com>
    irqchip/sifive-plic: Setup cpuhp once after boot CPU handler is present

Anup Patel <anup.patel@wdc.com>
    irqchip/sifive-plic: Set default irq affinity in plic_irqdomain_map()

Punit Agrawal <punit1.agrawal@toshiba.co.jp>
    e1000e: Relax condition to trigger reset for ME workaround

Kai-Heng Feng <kai.heng.feng@canonical.com>
    e1000e: Disable TSO for buffer overrun workaround

Ashok Raj <ashok.raj@intel.com>
    PCI: Program MPS for RCiEP devices

Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
    ima: Set again build_ima_appraise variable

Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
    ima: Remove redundant policy rule set in add_rules()

Alexander Monakov <amonakov@ispras.ru>
    x86/amd_nb: Add AMD family 17h model 60h PCI IDs

Kai-Heng Feng <kai.heng.feng@canonical.com>
    serial: 8250_pci: Move Pericom IDs to pci_ids.h

Ashok Raj <ashok.raj@intel.com>
    PCI: Add ACS quirk for Intel Root Complex Integrated Endpoints

Kevin Buettner <kevinb@redhat.com>
    PCI: Avoid FLR for AMD Starship USB 3.0

Marcos Scriven <marcos@scriven.org>
    PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Avoid Pericom USB controller OHCI/EHCI PME# defect

Eric Biggers <ebiggers@google.com>
    ext4: fix race between ext4_sync_parent() and rename()

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix error pointer dereference

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ext4: fix buffer_head refcnt leak when ext4_iget() fails

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Fix possible memory leak in evm_calc_hmac_or_hash()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Remove __init annotation from ima_pcrread()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Directly assign the ima_default_policy pointer to ima_rules

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Evaluate error in init_ima()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Switch to ima_hash_algo for boot aggregate

Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
    ima: Fix ima digest hash table key calculation

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm: call cond_resched() from deferred_init_memmap()

Daniel Jordan <daniel.m.jordan@oracle.com>
    mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init

Lichao Liu <liulichao@loongson.cn>
    MIPS: CPU_LOONGSON2EF need software to maintain cache consistency

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm: initialize deferred pages with interrupts enabled

Andrea Arcangeli <aarcange@redhat.com>
    mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/mm: Fix conditions to perform MMU specific management by blocks on PPC32.

Filipe Manana <fdmanana@suse.com>
    btrfs: fix space_info bytes_may_use underflow during space cache writeout

Filipe Manana <fdmanana@suse.com>
    btrfs: fix space_info bytes_may_use underflow after nocow buffered write

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong file range cleanup after an error filling dealloc range

Filipe Manana <fdmanana@suse.com>
    btrfs: fix corrupt log due to concurrent fsync of inodes with shared extents

Omar Sandoval <osandov@fb.com>
    btrfs: fix error handling when submitting direct I/O bio

Qu Wenruo <wqu@suse.com>
    btrfs: reloc: fix reloc root leak and NULL pointer dereference

Josef Bacik <josef@toxicpanda.com>
    btrfs: force chunk allocation if our global rsv is larger than metadata

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: send: emit file capabilities after chown

Filipe Manana <fdmanana@suse.com>
    btrfs: fix a race between scrub and block group removal/allocation

Anand Jain <anand.jain@oracle.com>
    btrfs: include non-missing as a qualifier for the latest_bdev

Anand Jain <anand.jain@oracle.com>
    btrfs: free alien device after device add

Daniel Axtens <dja@axtens.net>
    string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Daniel Axtens <dja@axtens.net>
    kasan: stop tests being eliminated as dead code with FORTIFY_SOURCE

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Maintain 8-byte stack alignment

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix up bpf_skb_adjust_room helper's skb csum setting

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf, flow_dissector: Close TAP device FD after the test

John Fastabend <john.fastabend@gmail.com>
    bpf: Fix running sk_skb program types with ktls

John Fastabend <john.fastabend@gmail.com>
    bpf: Refactor sockmap redirect code so its easy to reuse

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Fix map permissions check

Eelco Chaudron <echaudro@redhat.com>
    libbpf: Fix perf_buffer__free() API for sparse allocs

Chris Chiu <chiu@endlessm.com>
    platform/x86: asus_wmi: Reserve more space for struct bias_args

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type

Nickolai Kozachenko <daemongloom@gmail.com>
    platform/x86: intel-hid: Add a quirk to support HP Spectre X2 (2015)

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: Fix inability to set channels when down

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix overflowed reqs cancellation

Angelo Dureghello <angelo.dureghello@timesys.com>
    spi: spi-fsl-dspi: fix native data copy

Qiushi Wu <wu000273@umn.edu>
    cpuidle: Fix three reference count leaks

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Return any value retrieved from the dma_transfer callback

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: fix the mask for tuning start point

Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: fix aux station leak

Xie XiuQi <xiexiuqi@huawei.com>
    ixgbe: fix signed-integer-overflow warning

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix potential double free in probe unrolling

Angelo Dureghello <angelo.dureghello@timesys.com>
    mmc: sdhci: add quirks for be to le byte swapping

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: owl-mmc: Respect the cmd->busy_timeout from the mmc core

Ulf Hansson <ulf.hansson@linaro.org>
    staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Set SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 quirk

Marek Vasut <marex@denx.de>
    mmc: mmci: Switch to mmc_regulator_set_vqmmc()

Coly Li <colyli@suse.de>
    bcache: fix refcount underflow in bcache_device_free()

YuanJunQing <yuanjunqing66@163.com>
    MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    PCI: Don't disable decoding when mmio_always_on is set

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    macvlan: Skip loopback packets in RX handler

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix memory leak when removing namespaces and controllers concurrently

Weiping Zhang <zhangweiping@didiglobal.com>
    nvme-pci: make sure write/poll_queues less or equal then cpu count

Fugang Duan <fugang.duan@nxp.com>
    net: ethernet: fec: move GPR register offset and bit into DT

Paul Menzel <pmenzel@molgen.mpg.de>
    ACPI: video: Use native backlight on Acer TravelMate 5735Z

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: mark qgroup inconsistent if we're inherting snapshot to a new qgroup

Josef Bacik <josef@toxicpanda.com>
    btrfs: improve global reserve stealing logic

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't call via_flush_cache() on Mac IIfx

Kaige Li <likaige@loongson.cn>
    MIPS: tools: Fix resource leak in elf-entry.c

Ben Hutchings <ben@decadent.org.uk>
    MIPS: Fix exception handler memcpy()

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm: Stop printing BRK addresses

Brett Creeley <brett.creeley@intel.com>
    ice: Fix Tx timeout when link is toggled on a VF's interface

Alan Maguire <alan.maguire@oracle.com>
    selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh

Alan Maguire <alan.maguire@oracle.com>
    selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdgpu: Sync with VM root BO when switching VM to CPU update mode

chen gong <curry.gong@amd.com>
    drm/amd/powerpay: Disable gfxoff when setting manual mode on picasso and raven

Nicolas Toromanoff <nicolas.toromanoff@st.com>
    crypto: stm32/crc32 - fix multi-instance

Nicolas Toromanoff <nicolas.toromanoff@st.com>
    crypto: stm32/crc32 - fix run-time self test issue.

Nicolas Toromanoff <nicolas.toromanoff@st.com>
    crypto: stm32/crc32 - fix ext4 chksum BUG_ON()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: Add udelay lpj numbers adjustment

Eric Joyner <eric.joyner@intel.com>
    ice: Fix resource leak on early exit from function

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: cleanup vf_id signedness

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: MAAR: Use more precise address mask

Huaixin Chang <changhuaixin@linux.alibaba.com>
    sched: Defend cfs and rt bandwidth quota against overflow

Brian Foster <bfoster@redhat.com>
    xfs: don't fail verifier on empty attr3 leaf block

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Correct relocation destination on old linkers

Douglas Anderson <dianders@chromium.org>
    kgdboc: Use a platform device to handle tty drivers showing up late

Pali Rohár <pali@kernel.org>
    mwifiex: Fix memory corruption in dump_station

Dan Carpenter <dan.carpenter@oracle.com>
    rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Alex Elder <elder@linaro.org>
    net: ipa: do not clear interrupt in gsi_channel_start()

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Fix test_align verifier log patterns

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Jens Axboe <axboe@kernel.dk>
    io_uring: allow POLL_ADD with double poll_wait() users

Arnd Bergmann <arnd@arndb.de>
    crypto: blake2b - Fix clang optimization for ARMv7-M

Jesper Dangaard Brouer <brouer@redhat.com>
    veth: Adjust hard_start offset on redirect XDP frames

Tejun Heo <tj@kernel.org>
    iocost: don't let vrate run wild while there's no saturation signal

Coly Li <colyli@suse.de>
    raid5: remove gfp flags from scribble_alloc()

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: don't flush workqueue unconditionally in md_open

Chung-Hsien Hsu <stanley.hsu@cypress.com>
    brcmfmac: fix WPA/WPA2-PSK 4-way handshake offload and SAE offload failures

Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
    selftests/bpf: Install generated test progs

Ryder Lee <ryder.lee@mediatek.com>
    mt76: avoid rx reorder buffer overflow

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix mt7615_driver_own routine

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix mt7615_firmware_own for mt7663e

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7663: fix DMA unmap length

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7622: fix DMA unmap length

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: do not always reset the dfs state setting the channel

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7663: fix mt7615_mac_cca_stats_reset routine

Wei Yongjun <weiyongjun1@huawei.com>
    drm/mcde: dsi: Fix return value check in mcde_dsi_bind()

Bhupesh Sharma <bhsharma@redhat.com>
    net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Remove msdu from idr when management pkt send fails

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Skip handling del_server during driver exit

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: use bh_lock in data_ready

Weiping Zhang <zhangweiping@didiglobal.com>
    nvme-pci: align io queue count with allocted nvme_queue in nvme_probe

Arnd Bergmann <arnd@arndb.de>
    nvme-fc: avoid gcc-10 zero-length-bounds warning

Christoph Hellwig <hch@lst.de>
    nvme: refine the Qemu Identify CNS quirk

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: avoid debug max amsdu config overwriting itself

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Also handle tablet-mode switch on "Detachable" and "Portable" chassis-types

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Do not advertise switches to userspace if they are not there

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Split keymap into buttons and switches parts

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Use acpi_evaluate_integer()

Brian Foster <bfoster@redhat.com>
    xfs: fix duplicate verification from xfs_qm_dqflush()

Brian Foster <bfoster@redhat.com>
    xfs: reset buffer write failure state on successful completion

Daniel Thompson <daniel.thompson@linaro.org>
    kgdb: Fix spurious true from in_dbg_master()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: cm: Fix an invalid error code of INTVN_*_ERR

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Truncate link address into 32bit for 32bit kernel

Arnd Bergmann <arnd@arndb.de>
    dsa: sja1105: dynamically allocate stats structure

Devulapally Shiva Krishna <shiva@chelsio.com>
    Crypto/chcr: fix for ccm(aes) failed test

Devulapally Shiva Krishna <shiva@chelsio.com>
    Crypto/chcr: fix ctr, cbc, xts and rfc3686-ctr failed tests

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: clean up the error handling in xfs_swap_extents

Colin Ian King <colin.king@canonical.com>
    libertas_tf: avoid a null dereference in pointer priv

Tamizh Chelvam <tamizhr@codeaurora.org>
    ath11k: fix kernel panic by freeing the msdu received with invalid length

Jeremy Kerr <jk@ozlabs.org>
    powerpc/spufs: fix copy_to_user while atomic

Yunjian Wang <wangyunjian@huawei.com>
    net: allwinner: Fix use correct return type for ndo_start_xmit()

Dan Carpenter <dan.carpenter@oracle.com>
    media: cec: silence shift wrapping warning in __cec_s_log_addrs()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: sun8i: Fix an error handling path in 'deinterlace_runtime_resume()'

Wei Yongjun <weiyongjun1@huawei.com>
    ath11k: fix error return code in ath11k_dp_alloc()

Wei Yongjun <weiyongjun1@huawei.com>
    ath10k: fix possible memory leak in ath10k_bmi_lz_data_large()

Ansuel Smith <ansuelsmth@gmail.com>
    cpufreq: qcom: fix wrong compatible binding

Wei Yongjun <weiyongjun1@huawei.com>
    drivers: net: davinci_mdio: fix potential NULL dereference in davinci_mdio_probe()

Wei Yongjun <weiyongjun1@huawei.com>
    selinux: fix error return code in policydb_read()

Wei Yongjun <weiyongjun1@huawei.com>
    net: lpc-enet: fix error return code in lpc_mii_init()

Wei Yongjun <weiyongjun1@huawei.com>
    ice: Fix error return code in ice_add_prof()

Wei Yongjun <weiyongjun1@huawei.com>
    octeontx2-pf: Fix error return code in otx2_probe()

Tejun Heo <tj@kernel.org>
    iocost_monitor: drop string wrap around numbers when outputting json

Shaokun Zhang <zhangshaokun@hisilicon.com>
    drivers/perf: hisi: Fix typo in events attribute array

Łukasz Stelmach <l.stelmach@samsung.com>
    arm64: kexec_file: print appropriate variable

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    stmmac: intel: Fix clock handling on error and remove paths

Peter Zijlstra <peterz@infradead.org>
    sched/core: Fix illegal RCU from offline CPUs

Jann Horn <jannh@google.com>
    exit: Move preemption fixup up, move blocking operations down

Roi Dayan <roid@mellanox.com>
    net/mlx5e: CT: Avoid false warning about rule may be used uninitialized

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix 64-bit MIPS build with Clang

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: Fix WoL with password after deep sleep

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: set Rx mode before starting netif

Arnd Bergmann <arnd@arndb.de>
    drm/bridge: fix stack usage warning on old gcc

Masahiro Yamada <masahiroy@kernel.org>
    ARM: 8969/1: decompressor: simplify libfdt builds

Sean Young <sean@mess.org>
    media: m88ds3103: error in set_frontend is swallowed and not reported

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Add runqslower binary to .gitignore

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix bpf_link leak in ns_current_pid_tgid selftest

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix huge memory leak in libbpf_find_vmlinux_btf_id()

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix invalid memory reads in core_relo selftest

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix memory leak in extract_build_id()

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix memory leak in test selector

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Ensure test flavors use correct skeletons

Andrii Nakryiko <andriin@fb.com>
    libbpf: Refactor map creation logic and fix cleanup leak

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Do not disable pipe split if mode is not supported

Alain Michaud <alainm@chromium.org>
    Bluetooth: Adding driver and quirk defs for multi-role LE

Wei Yongjun <weiyongjun1@huawei.com>
    ath11k: use GFP_ATOMIC under spin lock

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Luke Nelson <lukenels@cs.washington.edu>
    bpf, riscv: Fix tail call count off by one in RV32 BPF JIT

Zou Wei <zou_wei@huawei.com>
    net/mlx4_core: Add missing iounmap() in error path

Christoph Hellwig <hch@lst.de>
    bcache: remove a duplicate ->make_request_fn assignment

Jesper Dangaard Brouer <brouer@redhat.com>
    dpaa2-eth: fix return codes used in ndo_setup_tc

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub/random: Align allocate size to EFI_ALLOC_ALIGN

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Always handle the VMBus messages on CPU0

Paul Hsieh <paul.hsieh@amd.com>
    drm/amd/display: dmcu wait loop calculation is incorrect in RV

Dale Zhao <dale.zhao@amd.com>
    drm/amd/display: Correct updating logic of dcn21's pipe VM flags

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_list_rules_send()

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: btbcm: Add 2 missing models to subver tables

Wen Gong <wgong@codeaurora.org>
    ath10k: add flush tx packets for SDIO chip

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Make sparse_init() using top-down allocation

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    media: platform: fcp: Set appropriate DMA parameters

Philipp Zabel <p.zabel@pengutronix.de>
    media: imx: utils: fix media bus format enumeration

Philipp Zabel <p.zabel@pengutronix.de>
    media: imx: utils: fix and simplify pixel format enumeration

Colin Ian King <colin.king@canonical.com>
    media: dvb: return -EREMOTEIO on i2c transfer failure.

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_send_reply()

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: set dpi pin mode to gpio low to avoid leakage current

Jitao Shi <jitao.shi@mediatek.com>
    dt-bindings: display: mediatek: control dpi pins mode to avoid leakage

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Allocate initial CRTC state of the correct size

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: deal with problematic MAC_ETYPE VCAP IS2 rules

Kees Cook <keescook@chromium.org>
    e1000: Distribute switch variables for initialization

Stephane Eranian <eranian@google.com>
    tools api fs: Make xxx__mountpoint() more scalable

Bjorn Andersson <bjorn.andersson@linaro.org>
    regulator: qcom-rpmh: Fix typos in pm8150 and pm8150l

Jaehoon Chung <jh80.chung@samsung.com>
    brcmfmac: fix wrong location to get firmware feature

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Respect DataBitLength field of SpiSerialBusV2() ACPI resource

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: core: remove CNOC voting while device suspend

Bingbu Cao <bingbu.cao@intel.com>
    media: staging/intel-ipu3: Implement lock for stream on/off operations

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: Revert to old formula in set_vtg_params

Venkateswara Naralasetty <vnaralas@codeaurora.org>
    ath10k: fix kernel null pointer dereference

Sriram R <srirrama@codeaurora.org>
    ath11k: Avoid mgmt tx count underflow

Tian Tao <tiantao6@hisilicon.com>
    drm/hisilicon: Enforce 128-byte stride alignment to fix the hardware limitation

Colin Ian King <colin.king@canonical.com>
    ath11k: fix error message to correctly report the command that failed

Kees Cook <keescook@chromium.org>
    ubsan: entirely disable alignment checks under UBSAN_TRAP

Christoph Hellwig <hch@lst.de>
    staging: android: ion: use vmap instead of vm_map_ram

Christoph Hellwig <hch@lst.de>
    x86: fix vmap arguments in map_irq_stack

Ayush Sawal <ayush.sawal@chelsio.com>
    Crypto/chcr: Fixes a coccinile check error

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jon Doron <arilou@gmail.com>
    x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
    ice: fix PCI device serial number to be lowercase values

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix Rx-only DMA transfers

Zijun Hu <zijuhu@codeaurora.org>
    Bluetooth: hci_qca: Fix suspend/resume functionality failure

Chuhong Yuan <hslester96@gmail.com>
    Bluetooth: btmtkuart: Improve exception handling in btmtuart_probe()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error

Ludovic Barre <ludovic.barre@st.com>
    mmc: mmci_sdmmc: fix power on issue due to pwr_reg initialization

Marta Plantykow <marta.a.plantykow@intel.com>
    ice: Change number of XDP TxQ to 0 when destroying rings

Surabhi Boob <surabhi.boob@intel.com>
    ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS

Surabhi Boob <surabhi.boob@intel.com>
    ice: Fix memory leak

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: more lockdep whackamole with kmem_alloc*

Sven Eckelmann <sven@narfation.org>
    batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

Linus Walleij <linus.walleij@linaro.org>
    ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Peter Rosin <peda@axentia.se>
    spi: mux: repair mux usage

Filipe Manana <fdmanana@suse.com>
    btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums

Josef Bacik <josef@toxicpanda.com>
    btrfs: account for trans_block_rsv in may_commit_transaction

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer_of: Fix missing clockevent timers

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer: Make CPU-affiliation being optional

Saravana Kannan <saravanak@google.com>
    clocksource/drivers/timer-versatile: Clear OF_POPULATED flag

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Enable interrupts in accordance with DMA xfer mode

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: Fix cpu_has_mips64r1/2 activation for MIPS32 CPUs

Mark Pearson <mpearson.lenovo@gmail.com>
    drm/dp: Lenovo X13 Yoga OLED panel brightness fix

Tuan Phan <tuanphan@os.amperecomputing.com>
    ACPI/IORT: Fix PMCG node single ID mapping handling

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ath11k: Fix some resource leaks in error path in 'ath11k_thermal_register()'

Jean-Philippe Brucker <jean-philippe@linaro.org>
    pmu/smmuv3: Clear IRQ affinity hint on device removal

Douglas Anderson <dianders@chromium.org>
    kgdb: Prevent infinite recursive entries to the debugger

Douglas Anderson <dianders@chromium.org>
    kgdb: Disable WARN_CONSOLE_UNLOCKED for all kgdb

Hsin-Yu Chao <hychao@chromium.org>
    Bluetooth: Add SCO fallback for invalid LMP parameters error

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: i2c: imx219: Fix a bug in imx219_enum_frame_size

Jens Axboe <axboe@kernel.dk>
    io_uring: cleanup io_poll_remove_one() logic

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Build ATI Radeon GPU driver as module

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: psci: Fixup execution order when entering a domain idle state

Koba Ko <koba.ko@canonical.com>
    platform/x86: dell-laptop: don't register micmute LED if there is no token

Jesper Dangaard Brouer <brouer@redhat.com>
    ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K

Jeremy Cline <jcline@redhat.com>
    lockdown: Allow unprivileged users to see lockdown status

Tomohito Esaki <etom@igel.co.jp>
    drm: rcar-du: Set primary plane zpos immutably at initializing

Weiping Zhang <zhangweiping@didiglobal.com>
    block: reset mapping if failed to update hardware queue count

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix aid configuration in mt7615_mcu_wtbl_generic_tlv

Prarit Bhargava <prarit@redhat.com>
    tools/power/x86/intel-speed-select: Fix CLX-N package information output

Luke Nelson <lukenels@cs.washington.edu>
    arm64: insn: Fix two bugs in encoding 32-bit logical immediates

Ming Lei <ming.lei@redhat.com>
    block: alloc map and request for new hardware queue

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Dispatcher: add status checks

Ioana Ciornei <ioana.ciornei@nxp.com>
    soc: fsl: dpio: properly compute the consumer index

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw: Zero DMA Tx and Rx configurations on stack

Dejin Zheng <zhengdejin5@gmail.com>
    rtw88: fix an issue about leak system resources

Ian Rogers <irogers@google.com>
    libperf evlist: Fix a refcount leak

Tomasz Figa <tfiga@chromium.org>
    media: staging: ipu3: Fix stale list entries on parameter queue failure

Daniel Thompson <daniel.thompson@linaro.org>
    arm64: cacheflush: Fix KGDB trap detection

Wen Gong <wgong@codeaurora.org>
    ath10k: remove the max_sched_scan_reqs value

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub/x86: Work around LLVM ELF quirk build regression

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix error returning in ena_com_get_hash_function()

Mark Starovoytov <mstarovoitov@marvell.com>
    net: atlantic: make hw_get_regs optional

Huaixin Chang <changhuaixin@linux.alibaba.com>
    sched/fair: Refill bandwidth before scaling

Peter Zijlstra <peterz@infradead.org>
    x86,smap: Fix smap_{save,restore}() alternatives

Evan Green <evgreen@chromium.org>
    spi: pxa2xx: Apply CS clk quirk to BXT

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix memory leak and possible double-free in hashmap__clear

Veronika Kabatova <vkabatov@redhat.com>
    selftests/bpf: Copy runqslower to OUTPUT directory

Gavin Shan <gshan@redhat.com>
    arm64/kernel: Fix range on invalidating dcache for boot page tables

Wei Yongjun <weiyongjun1@huawei.com>
    net: ethernet: ti: fix return value check in k3_cppi_desc_pool_create_name()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    drm/bridge: panel: Return always an error pointer in drm_panel_bridge_add()

limingyu <limingyu@uniontech.com>
    drm/amdgpu: Init data to avoid oops while reading pp_num_states.

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spi-mem: Fix Dual/Quad modes on Octal-capable devices

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix virtual signal dsc setup

Joshua Aberback <joshua.aberback@amd.com>
    drm/amd/display: Force watermark value propagation

Julien Thierry <jthierry@redhat.com>
    objtool: Ignore empty alternatives

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls: v4l2_ctrl_g/s_ctrl*(): don't continue when WARN_ON

Brad Love <brad@nextdimension.cc>
    media: si2157: Better check for running tuner in init

Dan Carpenter <dan.carpenter@oracle.com>
    media: vicodec: Fix error codes in probe function

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    scripts: sphinx-pre-install: address some issues with Gentoo

Andre Guedes <andre.guedes@intel.com>
    igc: Fix default MAC address filter override

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp -- don't "select" CONFIG_DMADEVICES

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: imx7-mipi-csis: Cleanup and fix subdev pad format handling

Bingbu Cao <bingbu.cao@intel.com>
    media: staging: imgu: do not hold spinlock during freeing mmu page table

Bogdan Togorean <bogdan.togorean@analog.com>
    drm: bridge: adv7511: Extend list of audio sample rates

Maharaja Kennadyrajan <mkenna@codeaurora.org>
    ath10k: Fix the race condition in firmware dump work queue

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix and cleanup amdgpu_gem_object_close v4

Ard Biesheuvel <ardb@kernel.org>
    ACPI: GED: use correct trigger type field in _Exx / _Lxx handling


-------------

Diffstat:

 .../bindings/display/mediatek/mediatek,dpi.txt     |   6 +
 Documentation/virt/kvm/api.rst                     |   2 +
 Makefile                                           |  17 +-
 arch/alpha/include/asm/io.h                        |  74 ++++--
 arch/alpha/kernel/io.c                             |  60 ++++-
 arch/arm/boot/compressed/.gitignore                |   9 -
 arch/arm/boot/compressed/Makefile                  |  38 ++--
 arch/arm/boot/compressed/atags_to_fdt.c            |   1 +
 arch/arm/boot/compressed/fdt.c                     |   2 +
 arch/arm/boot/compressed/fdt_ro.c                  |   2 +
 arch/arm/boot/compressed/fdt_rw.c                  |   2 +
 arch/arm/boot/compressed/fdt_wip.c                 |   2 +
 arch/arm/boot/compressed/libfdt_env.h              |  24 --
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi        |   2 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi               |   1 +
 arch/arm/mach-tegra/tegra.c                        |   4 +-
 arch/arm/mm/proc-macros.S                          |   3 +-
 arch/arm64/include/asm/cacheflush.h                |   6 +-
 arch/arm64/include/asm/pgtable.h                   |   1 +
 arch/arm64/kernel/head.S                           |  12 +-
 arch/arm64/kernel/insn.c                           |  14 +-
 arch/arm64/kernel/machine_kexec_file.c             |   6 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   1 +
 arch/m68k/include/asm/mac_via.h                    |   1 +
 arch/m68k/mac/config.c                             |  21 +-
 arch/m68k/mac/via.c                                |   6 +-
 arch/mips/Makefile                                 |  13 +-
 arch/mips/boot/compressed/Makefile                 |   2 +-
 arch/mips/configs/loongson3_defconfig              |   2 +-
 arch/mips/include/asm/cpu-features.h               |   6 +-
 arch/mips/include/asm/mipsregs.h                   |   2 +-
 arch/mips/kernel/genex.S                           |   6 +-
 arch/mips/kernel/mips-cm.c                         |   6 +-
 arch/mips/kernel/setup.c                           |  10 +
 arch/mips/kernel/time.c                            |  70 ++++++
 arch/mips/kernel/vmlinux.lds.S                     |   2 +-
 arch/mips/loongson2ef/common/init.c                |   4 +-
 arch/mips/loongson64/init.c                        |   4 +-
 arch/mips/mm/dma-noncoherent.c                     |   1 +
 arch/mips/mti-malta/malta-init.c                   |   8 +-
 arch/mips/pistachio/init.c                         |   8 +-
 arch/mips/tools/elf-entry.c                        |   9 +-
 arch/powerpc/Kconfig                               |   4 +-
 arch/powerpc/include/asm/book3s/32/kup.h           |   3 +-
 arch/powerpc/include/asm/fadump-internal.h         |   4 +-
 arch/powerpc/include/asm/kasan.h                   |   6 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   8 +
 arch/powerpc/kernel/fadump.c                       | 155 +++++++++----
 arch/powerpc/kernel/prom.c                         |  19 ++
 arch/powerpc/mm/init_32.c                          |   2 -
 arch/powerpc/mm/kasan/kasan_init_32.c              |   4 +-
 arch/powerpc/mm/pgtable_32.c                       |   4 +-
 arch/powerpc/platforms/cell/spufs/file.c           | 113 ++++++----
 arch/powerpc/platforms/powernv/smp.c               |   1 -
 arch/riscv/mm/init.c                               |  11 -
 arch/riscv/net/bpf_jit_comp32.c                    |   5 +-
 arch/s390/net/bpf_jit_comp.c                       |  19 +-
 arch/sparc/kernel/ptrace_32.c                      | 228 ++++++++-----------
 arch/sparc/kernel/ptrace_64.c                      |  17 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   1 +
 arch/x86/include/asm/smap.h                        |  11 +-
 arch/x86/kernel/amd_nb.c                           |   5 +
 arch/x86/kernel/irq_64.c                           |   2 +-
 arch/x86/mm/init.c                                 |   2 -
 block/blk-iocost.c                                 |  28 ++-
 block/blk-mq.c                                     |  26 +--
 block/blk.h                                        |   2 +
 crypto/blake2b_generic.c                           |   4 +-
 drivers/acpi/acpica/dsfield.c                      |  17 +-
 drivers/acpi/arm64/iort.c                          |   5 +
 drivers/acpi/evged.c                               |   2 +-
 drivers/acpi/video_detect.c                        |  10 +
 drivers/base/swnode.c                              |  27 ++-
 drivers/bluetooth/btbcm.c                          |   2 +
 drivers/bluetooth/btmtkuart.c                      |  14 +-
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bluetooth/hci_bcm.c                        |   8 +-
 drivers/bluetooth/hci_qca.c                        |  10 +-
 drivers/clk/mediatek/clk-mux.c                     |   2 +-
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/dw_apb_timer.c                 |   5 +-
 drivers/clocksource/dw_apb_timer_of.c              |   6 +-
 drivers/clocksource/timer-versatile.c              |   3 +
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |   2 +-
 drivers/cpuidle/cpuidle-psci.c                     |   8 +-
 drivers/cpuidle/sysfs.c                            |   6 +-
 drivers/crypto/ccp/Kconfig                         |   3 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  45 ++--
 drivers/crypto/chelsio/chcr_crypto.h               |   1 +
 drivers/crypto/stm32/stm32-crc32.c                 | 144 +++++++-----
 drivers/edac/amd64_edac.c                          |  14 ++
 drivers/edac/amd64_edac.h                          |   3 +
 drivers/firmware/efi/libstub/Makefile              |   1 +
 drivers/firmware/efi/libstub/randomalloc.c         |   4 +-
 drivers/gnss/sirf.c                                |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  43 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  11 +-
 .../dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c       |   3 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   5 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   9 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h   |   2 +
 drivers/gpu/drm/ast/ast_mode.c                     |  13 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  12 +-
 drivers/gpu/drm/bridge/panel.c                     |   6 +-
 drivers/gpu/drm/bridge/tc358768.c                  |   4 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   1 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |   9 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |   4 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c        |   2 +-
 drivers/gpu/drm/mcde/mcde_dsi.c                    |   7 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  31 +++
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |  16 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c              |  14 +-
 drivers/hv/connection.c                            |  20 +-
 drivers/hv/hv.c                                    |   7 +
 drivers/hv/hyperv_vmbus.h                          |  11 +-
 drivers/hv/vmbus_drv.c                             |  20 +-
 drivers/hwmon/k10temp.c                            |   1 +
 drivers/iommu/intel-iommu.c                        |  28 ++-
 drivers/irqchip/irq-sifive-plic.c                  |  17 +-
 drivers/macintosh/windfarm_pm112.c                 |  21 +-
 drivers/md/bcache/request.c                        |   1 -
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/md.c                                    |   3 +-
 drivers/md/raid5.c                                 |  15 +-
 drivers/media/cec/cec-adap.c                       |   8 +-
 drivers/media/dvb-frontends/m88ds3103.c            |   2 +
 drivers/media/i2c/imx219.c                         |   2 +-
 drivers/media/i2c/ov5640.c                         |   4 +-
 drivers/media/platform/qcom/venus/core.c           |  12 +-
 drivers/media/platform/rcar-fcp.c                  |   5 +
 drivers/media/platform/sunxi/sun8i-di/sun8i-di.c   |   6 +-
 drivers/media/platform/vicodec/vicodec-core.c      |  15 +-
 drivers/media/tuners/si2157.c                      |  15 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c              |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  18 +-
 drivers/memory/samsung/exynos5422-dmc.c            |   2 +-
 drivers/mmc/host/meson-mx-sdio.c                   |   3 +
 drivers/mmc/host/mmci.c                            |  30 +--
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   1 +
 drivers/mmc/host/owl-mmc.c                         |   8 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-msm.c                       |   4 +-
 drivers/mmc/host/sdhci.c                           |  10 +-
 drivers/mmc/host/sdhci.h                           |   3 +
 drivers/mmc/host/via-sdmmc.c                       |   7 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |  11 +-
 drivers/mtd/nand/raw/diskonchip.c                  |   7 +-
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c    |   2 +-
 drivers/mtd/nand/raw/mtk_nand.c                    |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  10 +-
 drivers/mtd/nand/raw/nand_onfi.c                   |   2 +-
 drivers/mtd/nand/raw/orion_nand.c                  |   2 +-
 drivers/mtd/nand/raw/oxnas_nand.c                  |   8 +-
 drivers/mtd/nand/raw/pasemi_nand.c                 |   4 +-
 drivers/mtd/nand/raw/plat_nand.c                   |   2 +-
 drivers/mtd/nand/raw/sharpsl.c                     |   2 +-
 drivers/mtd/nand/raw/socrates_nand.c               |   2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +-
 drivers/mtd/nand/raw/tmio_nand.c                   |   2 +-
 drivers/mtd/nand/raw/xway_nand.c                   |   2 +-
 drivers/net/dsa/sja1105/sja1105_ethtool.c          | 144 ++++++------
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   6 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  39 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |  24 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   4 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  16 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   8 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |  49 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   4 -
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  65 +++++-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx4/crdump.c        |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  15 +-
 drivers/net/ethernet/mscc/ocelot_ace.c             | 103 ++++++++-
 drivers/net/ethernet/mscc/ocelot_ace.h             |   5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |   2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   3 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  20 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   5 -
 drivers/net/ethernet/ti/davinci_mdio.c             |   2 +
 drivers/net/ethernet/ti/k3-cppi-desc-pool.c        |   4 +-
 drivers/net/ipa/gsi.c                              |  11 +-
 drivers/net/macvlan.c                              |   4 +
 drivers/net/veth.c                                 |   8 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   2 +
 drivers/net/wireless/ath/ath10k/bmi.c              |   1 +
 drivers/net/wireless/ath/ath10k/htt.h              |   7 +
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   8 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   1 +
 drivers/net/wireless/ath/ath10k/qmi.c              |  13 +-
 drivers/net/wireless/ath/ath10k/qmi.h              |   6 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  10 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  15 ++
 drivers/net/wireless/ath/ath11k/dp.c               |   4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  20 +-
 drivers/net/wireless/ath/ath11k/thermal.c          |   6 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   7 +-
 drivers/net/wireless/ath/carl9170/fw.c             |   4 +-
 drivers/net/wireless/ath/carl9170/main.c           |  21 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   6 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   1 +
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   6 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   6 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  14 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  34 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   2 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   8 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   1 +
 drivers/nvme/host/core.c                           |  16 +-
 drivers/nvme/host/fc.c                             |   2 +-
 drivers/nvme/host/pci.c                            |  79 ++++---
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/core.c                         |  15 +-
 drivers/pci/probe.c                                |  24 +-
 drivers/pci/quirks.c                               |  48 +++-
 drivers/perf/arm_smmuv3_pmu.c                      |   5 +-
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c       |   2 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  82 +++++--
 drivers/platform/x86/asus-wmi.c                    |   2 +
 drivers/platform/x86/dell-laptop.c                 |  11 +-
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/platform/x86/intel-hid.c                   |   7 +
 drivers/platform/x86/intel-vbtn.c                  |  75 +++++--
 drivers/power/reset/vexpress-poweroff.c            |   1 +
 drivers/power/supply/power_supply_hwmon.c          |   4 +-
 drivers/pwm/pwm-jz4740.c                           |   6 +-
 drivers/pwm/pwm-lpss.c                             |  15 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   8 +-
 drivers/soc/fsl/dpio/qbman-portal.c                |   1 +
 drivers/soc/tegra/Kconfig                          |   1 +
 drivers/spi/spi-dw-mid.c                           |  16 +-
 drivers/spi/spi-dw.c                               |   8 +-
 drivers/spi/spi-fsl-dspi.c                         |  24 +-
 drivers/spi/spi-mem.c                              |  10 +-
 drivers/spi/spi-mux.c                              |   8 +-
 drivers/spi/spi-pxa2xx.c                           |   1 +
 drivers/spi/spi.c                                  |   1 +
 drivers/staging/android/ion/ion_heap.c             |   4 +-
 drivers/staging/greybus/sdio.c                     |  10 +-
 drivers/staging/media/imx/imx-media-utils.c        | 201 ++++++-----------
 drivers/staging/media/imx/imx7-mipi-csis.c         |  82 +++----
 drivers/staging/media/ipu3/ipu3-mmu.c              |  10 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  10 +
 drivers/staging/media/ipu3/ipu3.c                  |   5 +-
 drivers/staging/media/ipu3/ipu3.h                  |   4 +
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |   2 +
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   3 -
 drivers/tty/serial/8250/8250_core.c                |  14 +-
 drivers/tty/serial/8250/8250_pci.c                 |   6 -
 drivers/tty/serial/kgdboc.c                        | 126 ++++++++---
 drivers/usb/musb/mediatek.c                        |   6 +
 drivers/virtio/virtio_balloon.c                    |   9 +-
 drivers/w1/masters/omap_hdq.c                      |  74 +++---
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/block-rsv.c                               |   3 +
 fs/btrfs/ctree.h                                   |   4 +
 fs/btrfs/disk-io.c                                 |   5 +-
 fs/btrfs/extent-io-tree.h                          |   1 +
 fs/btrfs/file-item.c                               |   6 +-
 fs/btrfs/inode.c                                   |  81 ++++++-
 fs/btrfs/qgroup.c                                  |  14 ++
 fs/btrfs/relocation.c                              |  12 +-
 fs/btrfs/scrub.c                                   |  38 +++-
 fs/btrfs/send.c                                    |  67 ++++++
 fs/btrfs/space-info.c                              |  43 +++-
 fs/btrfs/space-info.h                              |   1 +
 fs/btrfs/transaction.c                             |  60 ++---
 fs/btrfs/transaction.h                             |   3 +-
 fs/btrfs/tree-log.c                                |  22 +-
 fs/btrfs/volumes.c                                 |  14 +-
 fs/ext4/ext4_extents.h                             |   9 +-
 fs/ext4/fsync.c                                    |  28 ++-
 fs/ext4/ialloc.c                                   |   1 +
 fs/ext4/xattr.c                                    |   7 +-
 fs/f2fs/f2fs.h                                     |   1 +
 fs/f2fs/inline.c                                   |   6 +-
 fs/f2fs/super.c                                    |  25 ++-
 fs/io_uring.c                                      | 250 +++++++++++++--------
 fs/jbd2/transaction.c                              |  14 +-
 fs/xfs/kmem.h                                      |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  17 +-
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_buf.c                                   |   8 +-
 fs/xfs/xfs_dquot.c                                 |   9 +-
 include/linux/intel-iommu.h                        |   1 +
 include/linux/kgdb.h                               |   2 +-
 include/linux/mmzone.h                             |   2 +
 include/linux/pci_ids.h                            |   7 +
 include/linux/property.h                           |   1 +
 include/linux/sched/mm.h                           |   2 +
 include/linux/skbuff.h                             |   8 +
 include/linux/skmsg.h                              |   8 +
 include/linux/string.h                             |  60 ++++-
 include/linux/sunrpc/gss_api.h                     |   1 +
 include/linux/sunrpc/svcauth_gss.h                 |   3 +-
 include/net/bluetooth/hci.h                        |   9 +
 include/net/tls.h                                  |   9 +
 include/trace/events/btrfs.h                       |   1 +
 include/uapi/linux/bpf.h                           |   8 +
 include/uapi/linux/kvm.h                           |   2 +
 kernel/audit.c                                     |  52 +++--
 kernel/audit.h                                     |   2 +-
 kernel/auditfilter.c                               |  16 +-
 kernel/bpf/syscall.c                               |   3 +-
 kernel/cpu.c                                       |  18 +-
 kernel/cpu_pm.c                                    |   4 +-
 kernel/debug/debug_core.c                          |   5 +
 kernel/exit.c                                      |  25 ++-
 kernel/sched/core.c                                |  13 +-
 kernel/sched/fair.c                                |   4 +-
 kernel/sched/rt.c                                  |  12 +-
 kernel/sched/sched.h                               |   2 +
 kernel/time/clocksource.c                          |   2 -
 lib/Kconfig.ubsan                                  |   2 +-
 lib/mpi/longlong.h                                 |   2 +-
 lib/test_kasan.c                                   |  29 ++-
 lib/test_printf.c                                  |   4 +-
 mm/huge_memory.c                                   |  31 ++-
 mm/page_alloc.c                                    |  27 +--
 net/batman-adv/bat_v_elp.c                         |  15 +-
 net/bluetooth/hci_event.c                          |   1 +
 net/core/filter.c                                  |   8 +-
 net/core/skmsg.c                                   |  98 ++++++--
 net/netfilter/nft_nat.c                            |   4 +-
 net/sunrpc/auth_gss/gss_mech_switch.c              |  12 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  18 +-
 net/tls/tls_sw.c                                   |  20 +-
 scripts/sphinx-pre-install                         |   7 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima.h                       |  10 +-
 security/integrity/ima/ima_crypto.c                |  53 ++++-
 security/integrity/ima/ima_init.c                  |  24 +-
 security/integrity/ima/ima_main.c                  |   3 +
 security/integrity/ima/ima_policy.c                |  12 +-
 security/integrity/ima/ima_template_lib.c          |  18 ++
 security/lockdown/lockdown.c                       |   2 +-
 security/selinux/ss/policydb.c                     |   1 +
 tools/cgroup/iocost_monitor.py                     |  42 ++--
 tools/include/uapi/linux/bpf.h                     |   8 +
 tools/lib/api/fs/fs.c                              |  17 ++
 tools/lib/api/fs/fs.h                              |  12 +
 tools/lib/bpf/hashmap.c                            |   7 +
 tools/lib/bpf/libbpf.c                             | 236 ++++++++++---------
 tools/lib/perf/evlist.c                            |   1 +
 tools/objtool/check.c                              |   6 +
 tools/perf/builtin-probe.c                         |   3 +
 tools/perf/util/dso.c                              |  16 ++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/probe-event.c                      |  46 ++--
 tools/perf/util/probe-finder.c                     |   1 +
 tools/perf/util/symbol.c                           |   4 +
 tools/power/x86/intel-speed-select/isst-config.c   |   1 +
 tools/testing/selftests/bpf/.gitignore             |   2 +-
 tools/testing/selftests/bpf/Makefile               |   6 +-
 tools/testing/selftests/bpf/config                 |   2 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   2 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   1 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |   5 +-
 tools/testing/selftests/bpf/test_align.c           |  41 ++--
 tools/testing/selftests/bpf/test_progs.c           |  21 +-
 400 files changed, 4012 insertions(+), 2017 deletions(-)


