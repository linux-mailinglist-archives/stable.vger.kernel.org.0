Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78257202298
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgFTIXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgFTIXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 04:23:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC01223A5B;
        Sat, 20 Jun 2020 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592641390;
        bh=my+61IsbAQFLPjXQpQTe1UHrgTDoLuU3MegmcMJ6xPI=;
        h=From:To:Cc:Subject:Date:From;
        b=C6rwqamu543a6pCnoUt3Pai6CgN6Pu6DnQWtSYwp0F+GwOY683GOyKy3eyyGExzhn
         C0+3vYZT/b1zqktuTFyR+2Oc5PIAj5BjARYzq7So9ZMAQQObo4m/qlXL33SOduipKY
         s7/GmUpUVH4YbZ7Vuf7ke8e4jlxMIsE1GVQWVSeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/259] 5.4.48-rc2 review
Date:   Sat, 20 Jun 2020 10:23:05 +0200
Message-Id: <20200620082215.905874302@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.48-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.48-rc2
X-KernelTest-Deadline: 2020-06-22T08:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.48 release.
There are 259 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 22 Jun 2020 08:21:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.48-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.48-rc2

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

NeilBrown <neilb@suse.de>
    sunrpc: clean up properly in gss_mech_unregister()

NeilBrown <neilb@suse.de>
    sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.

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

Mikulas Patocka <mpatocka@redhat.com>
    alpha: fix memory barriers so that they conform to the specification

Eric Biggers <ebiggers@google.com>
    dm crypt: avoid truncating the logical block size

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

Alexander Monakov <amonakov@ispras.ru>
    EDAC/amd64: Add AMD family 17h model 60h PCI IDs

Alexander Monakov <amonakov@ispras.ru>
    hwmon: (k10temp) Add AMD family 17h model 60h PCI match

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Report speed and duplex as unknown when device is runtime suspended

Weiyi Lu <weiyi.lu@mediatek.com>
    clk: mediatek: assign the initial value to clk_init_data of mtk_mux

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

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Avoid error message on reprobe

Samuel Holland <samuel@sholland.org>
    media: cedrus: Program output format during each run

Chuhong Yuan <hslester96@gmail.com>
    media: go7007: fix a miss of snd_card_free

Christian Lamparter <chunkeey@gmail.com>
    carl9170: remove P2P_GO support

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

Tiezhu Yang <yangtiezhu@loongson.cn>
    PCI: Add Loongson vendor ID

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Add Family 19h PCI IDs

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Add device id for VMD device 8086:9A0B

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

Omar Sandoval <osandov@fb.com>
    btrfs: fix error handling when submitting direct I/O bio

Josef Bacik <josef@toxicpanda.com>
    btrfs: force chunk allocation if our global rsv is larger than metadata

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: send: emit file capabilities after chown

Anand Jain <anand.jain@oracle.com>
    btrfs: include non-missing as a qualifier for the latest_bdev

Anand Jain <anand.jain@oracle.com>
    btrfs: free alien device after device add

Daniel Axtens <dja@axtens.net>
    string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Daniel Axtens <dja@axtens.net>
    kasan: stop tests being eliminated as dead code with FORTIFY_SOURCE

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()

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

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core

Ulf Hansson <ulf.hansson@linaro.org>
    staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Set SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 quirk

Coly Li <colyli@suse.de>
    bcache: fix refcount underflow in bcache_device_free()

YuanJunQing <yuanjunqing66@163.com>
    MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    PCI: Don't disable decoding when mmio_always_on is set

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    macvlan: Skip loopback packets in RX handler

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: mark qgroup inconsistent if we're inherting snapshot to a new qgroup

Josef Bacik <josef@toxicpanda.com>
    btrfs: improve global reserve stealing logic

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't call via_flush_cache() on Mac IIfx

Kaige Li <likaige@loongson.cn>
    MIPS: tools: Fix resource leak in elf-entry.c

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm: Stop printing BRK addresses

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

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: MAAR: Use more precise address mask

Huaixin Chang <changhuaixin@linux.alibaba.com>
    sched: Defend cfs and rt bandwidth quota against overflow

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Correct relocation destination on old linkers

Douglas Anderson <dianders@chromium.org>
    kgdboc: Use a platform device to handle tty drivers showing up late

Pali Rohár <pali@kernel.org>
    mwifiex: Fix memory corruption in dump_station

Dan Carpenter <dan.carpenter@oracle.com>
    rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Jesper Dangaard Brouer <brouer@redhat.com>
    veth: Adjust hard_start offset on redirect XDP frames

Tejun Heo <tj@kernel.org>
    iocost: don't let vrate run wild while there's no saturation signal

Coly Li <colyli@suse.de>
    raid5: remove gfp flags from scribble_alloc()

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: don't flush workqueue unconditionally in md_open

Ryder Lee <ryder.lee@mediatek.com>
    mt76: avoid rx reorder buffer overflow

Wei Yongjun <weiyongjun1@huawei.com>
    drm/mcde: dsi: Fix return value check in mcde_dsi_bind()

Bhupesh Sharma <bhsharma@redhat.com>
    net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Remove msdu from idr when management pkt send fails

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: use bh_lock in data_ready

Weiping Zhang <zhangweiping@didiglobal.com>
    nvme-pci: align io queue count with allocted nvme_queue in nvme_probe

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

Devulapally Shiva Krishna <shiva@chelsio.com>
    Crypto/chcr: fix for ccm(aes) failed test

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: clean up the error handling in xfs_swap_extents

Colin Ian King <colin.king@canonical.com>
    libertas_tf: avoid a null dereference in pointer priv

Jeremy Kerr <jk@ozlabs.org>
    powerpc/spufs: fix copy_to_user while atomic

Yunjian Wang <wangyunjian@huawei.com>
    net: allwinner: Fix use correct return type for ndo_start_xmit()

Dan Carpenter <dan.carpenter@oracle.com>
    media: cec: silence shift wrapping warning in __cec_s_log_addrs()

Wei Yongjun <weiyongjun1@huawei.com>
    drivers: net: davinci_mdio: fix potential NULL dereference in davinci_mdio_probe()

Wei Yongjun <weiyongjun1@huawei.com>
    selinux: fix error return code in policydb_read()

Wei Yongjun <weiyongjun1@huawei.com>
    net: lpc-enet: fix error return code in lpc_mii_init()

Tejun Heo <tj@kernel.org>
    iocost_monitor: drop string wrap around numbers when outputting json

Shaokun Zhang <zhangshaokun@hisilicon.com>
    drivers/perf: hisi: Fix typo in events attribute array

Peter Zijlstra <peterz@infradead.org>
    sched/core: Fix illegal RCU from offline CPUs

Jann Horn <jannh@google.com>
    exit: Move preemption fixup up, move blocking operations down

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix 64-bit MIPS build with Clang

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: Fix WoL with password after deep sleep

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: set Rx mode before starting netif

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix memory leak in extract_build_id()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Jesper Dangaard Brouer <brouer@redhat.com>
    dpaa2-eth: fix return codes used in ndo_setup_tc

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Always handle the VMBus messages on CPU0

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

Colin Ian King <colin.king@canonical.com>
    media: dvb: return -EREMOTEIO on i2c transfer failure.

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_send_reply()

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: set dpi pin mode to gpio low to avoid leakage current

Jitao Shi <jitao.shi@mediatek.com>
    dt-bindings: display: mediatek: control dpi pins mode to avoid leakage

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

Bingbu Cao <bingbu.cao@intel.com>
    media: staging/intel-ipu3: Implement lock for stream on/off operations

Venkateswara Naralasetty <vnaralas@codeaurora.org>
    ath10k: fix kernel null pointer dereference

Christoph Hellwig <hch@lst.de>
    staging: android: ion: use vmap instead of vm_map_ram

Christoph Hellwig <hch@lst.de>
    x86: fix vmap arguments in map_irq_stack

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jon Doron <arilou@gmail.com>
    x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix Rx-only DMA transfers

Chuhong Yuan <hslester96@gmail.com>
    Bluetooth: btmtkuart: Improve exception handling in btmtuart_probe()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error

Surabhi Boob <surabhi.boob@intel.com>
    ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS

Surabhi Boob <surabhi.boob@intel.com>
    ice: Fix memory leak

Sven Eckelmann <sven@narfation.org>
    batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

Linus Walleij <linus.walleij@linaro.org>
    ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Filipe Manana <fdmanana@suse.com>
    btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums

Josef Bacik <josef@toxicpanda.com>
    btrfs: account for trans_block_rsv in may_commit_transaction

Brad Love <brad@nextdimension.cc>
    media: dvbdev: Fix tuner->demod media controller link

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer_of: Fix missing clockevent timers

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer: Make CPU-affiliation being optional

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Enable interrupts in accordance with DMA xfer mode

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: Fix cpu_has_mips64r1/2 activation for MIPS32 CPUs

Tuan Phan <tuanphan@os.amperecomputing.com>
    ACPI/IORT: Fix PMCG node single ID mapping handling

Jean-Philippe Brucker <jean-philippe@linaro.org>
    pmu/smmuv3: Clear IRQ affinity hint on device removal

Douglas Anderson <dianders@chromium.org>
    kgdb: Prevent infinite recursive entries to the debugger

Douglas Anderson <dianders@chromium.org>
    kgdb: Disable WARN_CONSOLE_UNLOCKED for all kgdb

Hsin-Yu Chao <hychao@chromium.org>
    Bluetooth: Add SCO fallback for invalid LMP parameters error

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Build ATI Radeon GPU driver as module

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

Luke Nelson <lukenels@cs.washington.edu>
    arm64: insn: Fix two bugs in encoding 32-bit logical immediates

Ming Lei <ming.lei@redhat.com>
    block: alloc map and request for new hardware queue

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Dispatcher: add status checks

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw: Zero DMA Tx and Rx configurations on stack

Dejin Zheng <zhengdejin5@gmail.com>
    rtw88: fix an issue about leak system resources

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

Gavin Shan <gshan@redhat.com>
    arm64/kernel: Fix range on invalidating dcache for boot page tables

limingyu <limingyu@uniontech.com>
    drm/amdgpu: Init data to avoid oops while reading pp_num_states.

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spi-mem: Fix Dual/Quad modes on Octal-capable devices

Julien Thierry <jthierry@redhat.com>
    objtool: Ignore empty alternatives

Brad Love <brad@nextdimension.cc>
    media: si2157: Better check for running tuner in init

Dan Carpenter <dan.carpenter@oracle.com>
    media: vicodec: Fix error codes in probe function

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
 Documentation/virt/kvm/api.txt                     |   2 +
 Makefile                                           |  17 +-
 arch/alpha/include/asm/io.h                        |  74 +++++--
 arch/alpha/kernel/io.c                             |  60 +++++-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi        |   2 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi               |   1 +
 arch/arm/mach-tegra/tegra.c                        |   4 +-
 arch/arm/mm/proc-macros.S                          |   3 +-
 arch/arm64/include/asm/cacheflush.h                |   6 +-
 arch/arm64/include/asm/pgtable.h                   |   1 +
 arch/arm64/kernel/head.S                           |  12 +-
 arch/arm64/kernel/insn.c                           |  14 +-
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
 arch/mips/kernel/time.c                            |  70 +++++++
 arch/mips/kernel/vmlinux.lds.S                     |   2 +-
 arch/mips/tools/elf-entry.c                        |   9 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/include/asm/book3s/32/kup.h           |   3 +-
 arch/powerpc/include/asm/fadump-internal.h         |   4 +-
 arch/powerpc/include/asm/kasan.h                   |   6 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   8 +
 arch/powerpc/kernel/fadump.c                       | 155 ++++++++++----
 arch/powerpc/kernel/prom.c                         |  19 ++
 arch/powerpc/mm/init_32.c                          |   2 -
 arch/powerpc/mm/kasan/kasan_init_32.c              |   4 +-
 arch/powerpc/mm/pgtable_32.c                       |   4 +-
 arch/powerpc/platforms/cell/spufs/file.c           | 113 ++++++----
 arch/powerpc/platforms/powernv/smp.c               |   1 -
 arch/sparc/kernel/ptrace_32.c                      | 228 +++++++++------------
 arch/sparc/kernel/ptrace_64.c                      |  17 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   1 +
 arch/x86/include/asm/smap.h                        |  11 +-
 arch/x86/kernel/amd_nb.c                           |   8 +
 arch/x86/kernel/irq_64.c                           |   2 +-
 arch/x86/mm/init.c                                 |   2 -
 block/blk-iocost.c                                 |  28 ++-
 block/blk-mq.c                                     |  26 +--
 drivers/acpi/acpica/dsfield.c                      |  17 +-
 drivers/acpi/arm64/iort.c                          |   5 +
 drivers/acpi/evged.c                               |   2 +-
 drivers/bluetooth/btbcm.c                          |   2 +
 drivers/bluetooth/btmtkuart.c                      |  14 +-
 drivers/bluetooth/hci_bcm.c                        |   5 +-
 drivers/clk/mediatek/clk-mux.c                     |   2 +-
 drivers/clocksource/dw_apb_timer.c                 |   5 +-
 drivers/clocksource/dw_apb_timer_of.c              |   6 +-
 drivers/cpuidle/sysfs.c                            |   6 +-
 drivers/crypto/ccp/Kconfig                         |   3 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   2 +-
 drivers/crypto/stm32/stm32-crc32.c                 | 144 +++++++------
 drivers/edac/amd64_edac.c                          |  13 ++
 drivers/edac/amd64_edac.h                          |   3 +
 drivers/firmware/efi/libstub/Makefile              |   1 +
 drivers/gnss/sirf.c                                |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  43 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  11 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  12 +-
 drivers/gpu/drm/mcde/mcde_dsi.c                    |   7 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  31 +++
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |  16 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c              |  14 +-
 drivers/hv/connection.c                            |  20 +-
 drivers/hv/hv.c                                    |   7 +
 drivers/hv/hyperv_vmbus.h                          |  11 +-
 drivers/hv/vmbus_drv.c                             |  20 +-
 drivers/hwmon/k10temp.c                            |   1 +
 drivers/macintosh/windfarm_pm112.c                 |  21 +-
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/md.c                                    |   3 +-
 drivers/md/raid5.c                                 |  15 +-
 drivers/media/cec/cec-adap.c                       |   8 +-
 drivers/media/dvb-core/dvbdev.c                    |   5 +-
 drivers/media/i2c/ov5640.c                         |   4 +-
 drivers/media/platform/rcar-fcp.c                  |   5 +
 drivers/media/platform/vicodec/vicodec-core.c      |  15 +-
 drivers/media/tuners/si2157.c                      |  15 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c              |   2 +-
 drivers/media/usb/go7007/snd-go7007.c              |  35 ++--
 drivers/mmc/host/meson-mx-sdio.c                   |   3 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-msm.c                       |   4 +-
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
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   6 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  39 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   4 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  16 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   8 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |  49 +++--
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  15 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   3 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |   2 +
 drivers/net/macvlan.c                              |   4 +
 drivers/net/veth.c                                 |   8 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   2 +
 drivers/net/wireless/ath/ath10k/htt.h              |   7 +
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   8 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   1 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  10 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  15 ++
 drivers/net/wireless/ath/carl9170/fw.c             |   4 +-
 drivers/net/wireless/ath/carl9170/main.c           |  21 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   6 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   1 +
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   1 +
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
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   8 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   1 +
 drivers/nvme/host/core.c                           |  16 +-
 drivers/nvme/host/pci.c                            |  57 +++---
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/pci/controller/vmd.c                       |   2 +
 drivers/pci/probe.c                                |  24 ++-
 drivers/pci/quirks.c                               |  48 ++++-
 drivers/perf/arm_smmuv3_pmu.c                      |   5 +-
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c       |   2 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  82 +++++---
 drivers/platform/x86/asus-wmi.c                    |   2 +
 drivers/platform/x86/dell-laptop.c                 |  11 +-
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/platform/x86/intel-hid.c                   |   7 +
 drivers/platform/x86/intel-vbtn.c                  |  75 +++++--
 drivers/power/reset/vexpress-poweroff.c            |   1 +
 drivers/power/supply/power_supply_hwmon.c          |   4 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   8 +-
 drivers/soc/tegra/Kconfig                          |   1 +
 drivers/spi/spi-dw-mid.c                           |  16 +-
 drivers/spi/spi-dw.c                               |   8 +-
 drivers/spi/spi-mem.c                              |  10 +-
 drivers/spi/spi-pxa2xx.c                           |   1 +
 drivers/spi/spi.c                                  |   1 +
 drivers/staging/android/ion/ion_heap.c             |   4 +-
 drivers/staging/greybus/sdio.c                     |  10 +-
 drivers/staging/media/imx/imx7-mipi-csis.c         |  82 ++++----
 drivers/staging/media/ipu3/ipu3-mmu.c              |  10 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  10 +
 drivers/staging/media/ipu3/ipu3.c                  |   5 +-
 drivers/staging/media/ipu3/ipu3.h                  |   4 +
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |   2 +
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   3 -
 drivers/tty/serial/8250/8250_core.c                |  14 +-
 drivers/tty/serial/8250/8250_pci.c                 |   6 -
 drivers/tty/serial/kgdboc.c                        | 126 +++++++++---
 drivers/w1/masters/omap_hdq.c                      |  10 +-
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/block-rsv.c                               |   3 +
 fs/btrfs/ctree.h                                   |   1 +
 fs/btrfs/file-item.c                               |   6 +-
 fs/btrfs/inode.c                                   |  81 +++++++-
 fs/btrfs/qgroup.c                                  |  14 ++
 fs/btrfs/send.c                                    |  67 ++++++
 fs/btrfs/space-info.c                              |  43 +++-
 fs/btrfs/space-info.h                              |   1 +
 fs/btrfs/transaction.c                             |  60 +++---
 fs/btrfs/transaction.h                             |   3 +-
 fs/btrfs/volumes.c                                 |  14 +-
 fs/ext4/ext4_extents.h                             |   9 +-
 fs/ext4/fsync.c                                    |  28 ++-
 fs/ext4/xattr.c                                    |   7 +-
 fs/f2fs/f2fs.h                                     |   1 +
 fs/f2fs/super.c                                    |  25 ++-
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_buf.c                                   |   8 +-
 fs/xfs/xfs_dquot.c                                 |   9 +-
 include/linux/kgdb.h                               |   2 +-
 include/linux/mmzone.h                             |   2 +
 include/linux/pci_ids.h                            |  11 +
 include/linux/sched/mm.h                           |   2 +
 include/linux/skmsg.h                              |   8 +
 include/linux/string.h                             |  60 ++++--
 include/linux/sunrpc/gss_api.h                     |   1 +
 include/linux/sunrpc/svcauth_gss.h                 |   3 +-
 include/net/tls.h                                  |   9 +
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
 lib/mpi/longlong.h                                 |   2 +-
 lib/test_kasan.c                                   |  29 ++-
 mm/huge_memory.c                                   |  31 ++-
 mm/page_alloc.c                                    |  27 +--
 net/batman-adv/bat_v_elp.c                         |  15 +-
 net/bluetooth/hci_event.c                          |   1 +
 net/core/skmsg.c                                   |  98 ++++++---
 net/netfilter/nft_nat.c                            |   4 +-
 net/sunrpc/auth_gss/gss_mech_switch.c              |  12 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  18 +-
 net/tls/tls_sw.c                                   |  20 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima.h                       |  10 +-
 security/integrity/ima/ima_crypto.c                |  53 ++++-
 security/integrity/ima/ima_init.c                  |  24 ++-
 security/integrity/ima/ima_main.c                  |   3 +
 security/integrity/ima/ima_policy.c                |  12 +-
 security/integrity/ima/ima_template_lib.c          |  18 ++
 security/lockdown/lockdown.c                       |   2 +-
 security/selinux/ss/policydb.c                     |   1 +
 tools/cgroup/iocost_monitor.py                     |  42 ++--
 tools/lib/api/fs/fs.c                              |  17 ++
 tools/lib/api/fs/fs.h                              |  12 ++
 tools/lib/bpf/hashmap.c                            |   7 +
 tools/lib/bpf/libbpf.c                             |   5 +-
 tools/objtool/check.c                              |   6 +
 tools/perf/builtin-probe.c                         |   3 +
 tools/perf/util/dso.c                              |  16 ++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/probe-event.c                      |  46 +++--
 tools/perf/util/probe-finder.c                     |   1 +
 tools/perf/util/symbol.c                           |   4 +
 tools/testing/selftests/bpf/config                 |   1 +
 .../selftests/bpf/prog_tests/flow_dissector.c      |   1 +
 tools/testing/selftests/bpf/test_progs.c           |   1 +
 275 files changed, 2678 insertions(+), 1241 deletions(-)


