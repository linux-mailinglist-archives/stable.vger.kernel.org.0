Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2380B202296
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFTIXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgFTIXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 04:23:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F1223A31;
        Sat, 20 Jun 2020 08:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592641376;
        bh=vSVgvetnyOgF9LAUyGq8DFDFJjozrqgecbaugDk9W8M=;
        h=From:To:Cc:Subject:Date:From;
        b=tpoy/UAWflpo9fMa0jorFwPnVRpqboAcMfqK+jBIlR3JLHmef0Pslzs97nxu0Uqcv
         mr9efwWOLrbYHQ05I89Q6CcQTna9VHfHnmRWbwx36qsXPNyXK9+EiaSNSDaPo6qDTs
         YeDocU9RncB9aWjjfRILYTSFTXyD60AOKr1kqpaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/265] 4.19.129-rc2 review
Date:   Sat, 20 Jun 2020 10:22:51 +0200
Message-Id: <20200620082214.928028424@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.129-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.129-rc2
X-KernelTest-Deadline: 2020-06-22T08:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.129 release.
There are 265 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 22 Jun 2020 08:21:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.129-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.129-rc2

Adrian Hunter <adrian.hunter@intel.com>
    perf symbols: Fix debuginfo search for Ubuntu

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Check address correctness by map instead of _etext

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to check blacklist address correctly

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not show the skipped events

H. Nikolaus Schaller <hns@goldelico.com>
    w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: pasemi: Fix the probe error path

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix hamming oob layout

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

Michael Ellerman <mpe@ellerman.id.au>
    drivers/macintosh: Fix memleak in windfarm_pm112 driver

Jonathan Bakker <xc-racer2@live.ca>
    ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3 CM36651 sensor's bus

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Douglas Anderson <dianders@chromium.org>
    kernel/cpu_pm: Fix uninitted local in cpu_pm

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

Anders Roxell <anders.roxell@linaro.org>
    power: vexpress: add suppress_bind_attrs to true

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Report speed and duplex as unknown when device is runtime suspended

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

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong file range cleanup after an error filling dealloc range

Omar Sandoval <osandov@fb.com>
    btrfs: fix error handling when submitting direct I/O bio

Abhishek Sahu <abhsahu@nvidia.com>
    PCI: Generalize multi-function power dependency device links

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Unify ACS quirk desired vs provided checking

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Make ACS quirk implementations more uniform

Kai-Heng Feng <kai.heng.feng@canonical.com>
    serial: 8250_pci: Move Pericom IDs to pci_ids.h

Tiezhu Yang <yangtiezhu@loongson.cn>
    PCI: Add Loongson vendor ID

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Add Family 19h PCI IDs

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Add device id for VMD device 8086:9A0B

Jonathan Chocron <jonnyc@amazon.com>
    PCI: Add Amazon's Annapurna Labs vendor ID

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    PCI: Add Genesys Logic, Inc. Vendor ID

Tim Blechmann <tim@klingt.org>
    ALSA: lx6464es - add support for LX6464ESe pci express variant

Marcel Bocu <marcel.p.bocu@gmail.com>
    x86/amd_nb: Add PCI device IDs for family 17h, model 70h

Jianjun Wang <jianjun.wang@mediatek.com>
    PCI: mediatek: Add controller support for MT7629

Lukas Wunner <lukas@wunner.de>
    PCI: Enable NVIDIA HDA controllers

Abhishek Sahu <abhsahu@nvidia.com>
    PCI: Add NVIDIA GPU multi-function power dependencies

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    PCI: Add Synopsys endpoint EDDA Device ID

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Add support to test PCI EP in AM654x

Xiaowei Bao <xiaowei.bao@nxp.com>
    misc: pci_endpoint_test: Add the layerscape EP device support

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    PCI: Move Rohm Vendor ID to generic list

Thinh Nguyen <thinh.nguyen@synopsys.com>
    PCI: Move Synopsys HAPS platform device IDs

Heiner Kallweit <hkallweit1@gmail.com>
    PCI: add USR vendor id and use it in r8169 and w6692 driver

Woods, Brian <Brian.Woods@amd.com>
    x86/amd_nb: Add PCI device IDs for family 17h, model 30h

Woods, Brian <Brian.Woods@amd.com>
    hwmon/k10temp, x86/amd_nb: Consolidate shared device IDs

Corey Minyard <cminyard@mvista.com>
    pci:ipmi: Move IPMI PCI class id defines to pci_ids.h

Jakub Kicinski <jakub.kicinski@netronome.com>
    PCI: Remove unused NFP32xx IDs

Ashok Raj <ashok.raj@intel.com>
    PCI: Add ACS quirk for Intel Root Complex Integrated Endpoints

Abhinav Ratna <abhinav.ratna@broadcom.com>
    PCI: Add ACS quirk for iProc PAXB

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
    ima: Directly assign the ima_default_policy pointer to ima_rules

Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
    ima: Fix ima digest hash table key calculation

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm: initialize deferred pages with interrupts enabled

Andrea Arcangeli <aarcange@redhat.com>
    mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: send: emit file capabilities after chown

Anand Jain <anand.jain@oracle.com>
    btrfs: include non-missing as a qualifier for the latest_bdev

Daniel Axtens <dja@axtens.net>
    string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

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

Xie XiuQi <xiexiuqi@huawei.com>
    ixgbe: fix signed-integer-overflow warning

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

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't call via_flush_cache() on Mac IIfx

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm: Stop printing BRK addresses

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

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Correct relocation destination on old linkers

Pali Rohár <pali@kernel.org>
    mwifiex: Fix memory corruption in dump_station

Dan Carpenter <dan.carpenter@oracle.com>
    rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Jesper Dangaard Brouer <brouer@redhat.com>
    veth: Adjust hard_start offset on redirect XDP frames

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: don't flush workqueue unconditionally in md_open

Ryder Lee <ryder.lee@mediatek.com>
    mt76: avoid rx reorder buffer overflow

Bhupesh Sharma <bhsharma@redhat.com>
    net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Remove msdu from idr when management pkt send fails

Christoph Hellwig <hch@lst.de>
    nvme: refine the Qemu Identify CNS quirk

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

Jeremy Kerr <jk@ozlabs.org>
    powerpc/spufs: fix copy_to_user while atomic

Yunjian Wang <wangyunjian@huawei.com>
    net: allwinner: Fix use correct return type for ndo_start_xmit()

Dan Carpenter <dan.carpenter@oracle.com>
    media: cec: silence shift wrapping warning in __cec_s_log_addrs()

Wei Yongjun <weiyongjun1@huawei.com>
    net: lpc-enet: fix error return code in lpc_mii_init()

Shaokun Zhang <zhangshaokun@hisilicon.com>
    drivers/perf: hisi: Fix typo in events attribute array

Peter Zijlstra <peterz@infradead.org>
    sched/core: Fix illegal RCU from offline CPUs

Jann Horn <jannh@google.com>
    exit: Move preemption fixup up, move blocking operations down

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix 64-bit MIPS build with Clang

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: set Rx mode before starting netif

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix memory leak in extract_build_id()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_list_rules_send()

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: btbcm: Add 2 missing models to subver tables

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Make sparse_init() using top-down allocation

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    media: platform: fcp: Set appropriate DMA parameters

Colin Ian King <colin.king@canonical.com>
    media: dvb: return -EREMOTEIO on i2c transfer failure.

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_send_reply()

Jitao Shi <jitao.shi@mediatek.com>
    dt-bindings: display: mediatek: control dpi pins mode to avoid leakage

Kees Cook <keescook@chromium.org>
    e1000: Distribute switch variables for initialization

Stephane Eranian <eranian@google.com>
    tools api fs: Make xxx__mountpoint() more scalable

Jaehoon Chung <jh80.chung@samsung.com>
    brcmfmac: fix wrong location to get firmware feature

Christoph Hellwig <hch@lst.de>
    staging: android: ion: use vmap instead of vm_map_ram

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jon Doron <arilou@gmail.com>
    x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix Rx-only DMA transfers

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error

Sven Eckelmann <sven@narfation.org>
    batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

Linus Walleij <linus.walleij@linaro.org>
    ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Filipe Manana <fdmanana@suse.com>
    btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer_of: Fix missing clockevent timers

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer: Make CPU-affiliation being optional

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Enable interrupts in accordance with DMA xfer mode

Douglas Anderson <dianders@chromium.org>
    kgdb: Prevent infinite recursive entries to the debugger

Douglas Anderson <dianders@chromium.org>
    kgdb: Disable WARN_CONSOLE_UNLOCKED for all kgdb

Hsin-Yu Chao <hychao@chromium.org>
    Bluetooth: Add SCO fallback for invalid LMP parameters error

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Build ATI Radeon GPU driver as module

Jesper Dangaard Brouer <brouer@redhat.com>
    ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K

Luke Nelson <lukenels@cs.washington.edu>
    arm64: insn: Fix two bugs in encoding 32-bit logical immediates

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw: Zero DMA Tx and Rx configurations on stack

Daniel Thompson <daniel.thompson@linaro.org>
    arm64: cacheflush: Fix KGDB trap detection

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub/x86: Work around LLVM ELF quirk build regression

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix error returning in ena_com_get_hash_function()

Mark Starovoytov <mstarovoitov@marvell.com>
    net: atlantic: make hw_get_regs optional

Evan Green <evgreen@chromium.org>
    spi: pxa2xx: Apply CS clk quirk to BXT

Julien Thierry <jthierry@redhat.com>
    objtool: Ignore empty alternatives

Brad Love <brad@nextdimension.cc>
    media: si2157: Better check for running tuner in init

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp -- don't "select" CONFIG_DMADEVICES

Bogdan Togorean <bogdan.togorean@analog.com>
    drm: bridge: adv7511: Extend list of audio sample rates

Ard Biesheuvel <ardb@kernel.org>
    ACPI: GED: use correct trigger type field in _Exx / _Lxx handling

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception

Juergen Gross <jgross@suse.com>
    xen/pvcalls-back: test for errors when calling backend_connect()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdio: Fix potential NULL pointer error in mmc_sdio_init_card()

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node description

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Clear tuning done flag while hs400 tuning

Chris Wilson <chris@chris-wilson.co.uk>
    agp/intel: Reinforce the barrier after GTT updates

Barret Rhoden <brho@google.com>
    perf: Add cond_resched() to task_function_call()

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: don't allow to mount if the FAT length == 0

Wang Hai <wanghai38@huawei.com>
    mm/slub: fix a memory leak in sysfs_slab_add()

Ezequiel Garcia <ezequiel@collabora.com>
    drm/vkms: Hold gem object while still in-use

Casey Schaufler <casey@schaufler-ca.com>
    Smack: slab-out-of-bounds in vsscanf

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Qiujun Huang <hqjagain@gmail.com>
    ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix use-after-free Write in ath9k_htc_rx_msg

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx

Sumit Saxena <sumit.saxena@broadcom.com>
    scsi: megaraid_sas: TM command refire leads to controller firmware crash

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts

Xing Li <lixing@loongson.cn>
    KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits

Xing Li <lixing@loongson.cn>
    KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nSVM: leave ASID aside in copy_vmcb_control_area

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nSVM: fix condition for filtering async PF

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: fbdev: w100fb: Fix a potential double free.

Eric W. Biederman <ebiederm@xmission.com>
    proc: Use new_inode not new_inode_pseudo

Yuxuan Shui <yshuiv7@gmail.com>
    ovl: initialize error in ovl_copy_xattr

tannerlove <tannerlove@google.com>
    selftests/net: in rxtimestamp getopt_long needs terminating null entry

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix runtime PM ref imbalance on probe error

Lubomir Rintel <lkundrak@v3.sk>
    spi: pxa2xx: Balance runtime PM enable/disable on error

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: Fix controller unregister order

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: No need to assign dummy value in spi_unregister_controller()

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.

Thomas Lendacky <Thomas.Lendacky@amd.com>
    x86/speculation: Add support for STIBP always-on preferred mode

Waiman Long <longman@redhat.com>
    x86/speculation: Change misspelled STIPB to STIBP

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: only do L1TF workaround on affected processors

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Consolidate "is MMIO SPTE" code

Kai Huang <kai.huang@linux.intel.com>
    kvm: x86: Fix L1TF mitigation for shadow MMU

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    KVM: x86: Fix APIC page invalidation race

Tony Luck <tony.luck@intel.com>
    x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ALSA: pcm: disallow linking stream to itself

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: clk: Fix clk_pm_runtime_get() error path

Justin Chen <justinpopo6@gmail.com>
    spi: bcm-qspi: when tx/rx buffer is NULL set to 0

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835aux: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: dw: Fix controller unregister order

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Tejun Heo <tj@kernel.org>
    cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid using power resources if there are none for D0

Ard Biesheuvel <ardb@kernel.org>
    ACPI: GED: add support for _Exx / _Lxx handler methods

Qiushi Wu <wu000273@umn.edu>
    ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()

Qiushi Wu <wu000273@umn.edu>
    ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix inconsistent card PM state after resume

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - add a pintbl quirk for several Lenovo machines

Chuhong Yuan <hslester96@gmail.com>
    ALSA: es1688: Add the missed snd_card_free()

Ard Biesheuvel <ardb@kernel.org>
    efi/efivars: Add missing kobject_put() in sysfs entry creation error path

Hill Ma <maahiuzeon@gmail.com>
    x86/reboot/quirks: Add MacBook6,1 reboot quirk

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: Prevent rogue cross-process SSBD shutdown

Xiaochun Lee <lixc17@lenovo.com>
    x86/PCI: Mark Intel C620 MROMs as having non-compliant BARs

Bob Haarman <inglorion@google.com>
    x86_64: Fix jiffies ODR violation

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Check level for leaves and nodes

Miklos Szeredi <mszeredi@redhat.com>
    aio: fix async fsync creds

Waiman Long <longman@redhat.com>
    mm: add kvfree_sensitive() for freeing sensitive data objects

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Accept the instance number of kretprobe event

Kim Phillips <kim.phillips@amd.com>
    x86/cpu/amd: Make erratum #1054 a legacy erratum

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/uverbs: Make the event_queue fds return POLLERR when disassociated

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Silence undersized packet warnings

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Clear the page tables for the ESB IO mapping

Thomas Falcon <tlfalcon@linux.ibm.com>
    drivers/net/ibmvnic: Update VNIC protocol version reporting

Dennis Kadioglu <denk@eclipso.email>
    Input: synaptics - add a second working PNP_ID for Lenovo T470s

Jens Axboe <axboe@kernel.dk>
    sched/fair: Don't NUMA balance for kthreads

Fredrik Strupe <fredrik@strupe.net>
    ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook

Stephan Gerhold <stephan@gerhold.net>
    Input: mms114 - fix handling of mms345l

Su Kang Yin <cantona@cantona.net>
    crypto: talitos - fix ECB and CBC algs ivsize

Qu Wenruo <wqu@suse.com>
    btrfs: Detect unbalanced tree with empty leaf before crashing btree operations

Anand Jain <anand.jain@oracle.com>
    btrfs: merge btrfs_find_device and find_device

Christophe Leroy <christophe.leroy@c-s.fr>
    lib: Reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()

Will Deacon <will.deacon@arm.com>
    x86: uaccess: Inhibit speculation past access_ok() in user_access_begin()

Stafford Horne <shorne@gmail.com>
    arch/openrisc: Fix issues with access_ok()

Linus Torvalds <torvalds@linux-foundation.org>
    Fix 'acccess_ok()' on alpha and SH

Linus Torvalds <torvalds@linux-foundation.org>
    make 'user_access_begin()' do 'access_ok()'

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: fix use of undeclared RET_IF macro

Willem de Bruijn <willemb@google.com>
    tun: correct header offsets in napi frags mode

Ido Schimmel <idosch@mellanox.com>
    vxlan: Avoid infinite loop when suppressing NS messages with invalid options

Ido Schimmel <idosch@mellanox.com>
    bridge: Avoid infinite loop when suppressing NS messages with invalid options

Vasily Averin <vvs@virtuozzo.com>
    net_failover: fixed rollback in net_failover_open()

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: fix IPV6_ADDRFORM operation logic


-------------

Diffstat:

 .../bindings/display/mediatek/mediatek,dpi.txt     |   6 +
 Documentation/virtual/kvm/api.txt                  |   2 +
 Makefile                                           |  17 +-
 arch/alpha/include/asm/io.h                        |  74 ++++--
 arch/alpha/include/asm/uaccess.h                   |   8 +-
 arch/alpha/kernel/io.c                             |  60 ++++-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |   4 +-
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi        |   2 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi               |   1 +
 arch/arm/include/asm/kvm_host.h                    |   2 +
 arch/arm/kernel/ptrace.c                           |   4 +-
 arch/arm/mach-tegra/tegra.c                        |   4 +-
 arch/arm/mm/proc-macros.S                          |   3 +-
 arch/arm64/include/asm/cacheflush.h                |   6 +-
 arch/arm64/include/asm/kvm_host.h                  |   8 +-
 arch/arm64/kernel/insn.c                           |  14 +-
 arch/m68k/include/asm/mac_via.h                    |   1 +
 arch/m68k/mac/config.c                             |  21 +-
 arch/m68k/mac/via.c                                |   6 +-
 arch/mips/Makefile                                 |  13 +-
 arch/mips/boot/compressed/Makefile                 |   2 +-
 arch/mips/configs/loongson3_defconfig              |   2 +-
 arch/mips/include/asm/kvm_host.h                   |   6 +-
 arch/mips/include/asm/mipsregs.h                   |   2 +-
 arch/mips/kernel/genex.S                           |   6 +-
 arch/mips/kernel/mips-cm.c                         |   6 +-
 arch/mips/kernel/setup.c                           |  10 +
 arch/mips/kernel/time.c                            |  70 ++++++
 arch/mips/kernel/vmlinux.lds.S                     |   2 +-
 arch/openrisc/include/asm/uaccess.h                |   8 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   8 +
 arch/powerpc/kernel/prom.c                         |  19 ++
 arch/powerpc/platforms/cell/spufs/file.c           | 113 ++++++---
 arch/powerpc/platforms/powernv/smp.c               |   1 -
 arch/powerpc/sysdev/xive/common.c                  |   5 +
 arch/sh/include/asm/uaccess.h                      |   7 +-
 arch/sparc/kernel/ptrace_32.c                      | 228 ++++++++----------
 arch/sparc/kernel/ptrace_64.c                      |  17 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   1 +
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/nospec-branch.h               |   1 +
 arch/x86/include/asm/set_memory.h                  |  19 +-
 arch/x86/include/asm/uaccess.h                     |  12 +-
 arch/x86/kernel/amd_nb.c                           |  15 +-
 arch/x86/kernel/cpu/amd.c                          |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  94 +++++---
 arch/x86/kernel/cpu/mcheck/mce.c                   |  11 +-
 arch/x86/kernel/process.c                          |  28 +--
 arch/x86/kernel/process.h                          |   2 +-
 arch/x86/kernel/reboot.c                           |   8 +
 arch/x86/kernel/time.c                             |   4 -
 arch/x86/kernel/vmlinux.lds.S                      |   4 +-
 arch/x86/kvm/mmu.c                                 |  37 +--
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/kvm/vmx.c                                 |   2 +-
 arch/x86/kvm/x86.c                                 |   7 +-
 arch/x86/mm/init.c                                 |   2 -
 arch/x86/pci/fixup.c                               |   4 +
 drivers/acpi/cppc_acpi.c                           |   1 +
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/acpi/evged.c                               |  22 +-
 drivers/acpi/scan.c                                |  28 ++-
 drivers/acpi/sysfs.c                               |   4 +-
 drivers/bluetooth/btbcm.c                          |   2 +
 drivers/bluetooth/hci_bcm.c                        |   5 +-
 drivers/char/agp/intel-gtt.c                       |   4 +-
 drivers/char/ipmi/ipmi_si_pci.c                    |   5 -
 drivers/clk/clk.c                                  |   6 +-
 drivers/clocksource/dw_apb_timer.c                 |   5 +-
 drivers/clocksource/dw_apb_timer_of.c              |   6 +-
 drivers/cpuidle/sysfs.c                            |   6 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |   4 +-
 drivers/crypto/ccp/Kconfig                         |   3 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   2 +-
 drivers/crypto/stm32/stm32_crc32.c                 | 144 +++++++-----
 drivers/crypto/talitos.c                           |   2 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |  21 +-
 drivers/dma/pch_dma.c                              |   1 -
 drivers/firmware/efi/efivars.c                     |   4 +-
 drivers/firmware/efi/libstub/Makefile              |   1 +
 drivers/gnss/sirf.c                                |   8 +-
 drivers/gpio/gpio-ml-ioh.c                         |   2 -
 drivers/gpio/gpio-pch.c                            |   1 -
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  12 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  16 +-
 drivers/gpu/drm/vkms/vkms_drv.h                    |   5 -
 drivers/gpu/drm/vkms/vkms_gem.c                    |  11 +-
 drivers/hwmon/k10temp.c                            |   9 +-
 drivers/i2c/busses/i2c-eg20t.c                     |   1 -
 drivers/infiniband/core/uverbs_main.c              |   2 +
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/mms114.c                 |  12 +-
 drivers/isdn/hardware/mISDN/w6692.c                |   3 -
 drivers/macintosh/windfarm_pm112.c                 |  21 +-
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/md.c                                    |   3 +-
 drivers/media/cec/cec-adap.c                       |   8 +-
 drivers/media/i2c/ov5640.c                         |   4 +-
 drivers/media/platform/rcar-fcp.c                  |   5 +
 drivers/media/tuners/si2157.c                      |  15 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c              |   2 +-
 drivers/media/usb/go7007/snd-go7007.c              |  35 ++-
 drivers/misc/pch_phub.c                            |   1 -
 drivers/misc/pci_endpoint_test.c                   |  20 +-
 drivers/mmc/core/sdio.c                            |   3 +-
 drivers/mmc/host/meson-mx-sdio.c                   |   3 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-msm.c                       |  10 +-
 drivers/mmc/host/via-sdmmc.c                       |   7 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |  11 +-
 drivers/mtd/nand/raw/pasemi_nand.c                 |   4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   6 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   4 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  16 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  15 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   3 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   7 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/ethernet/realtek/r8169.c               |   2 +-
 drivers/net/macvlan.c                              |   4 +
 drivers/net/net_failover.c                         |   3 +-
 drivers/net/tun.c                                  |  12 +-
 drivers/net/veth.c                                 |   8 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   2 +
 drivers/net/vxlan.c                                |   4 +
 drivers/net/wireless/ath/ath10k/mac.c              |   3 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  10 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  15 ++
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  58 +++--
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   6 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 drivers/net/wireless/ath/ath9k/wmi.c               |   5 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |   3 +-
 drivers/net/wireless/ath/carl9170/fw.c             |   4 +-
 drivers/net/wireless/ath/carl9170/main.c           |  21 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   6 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   1 +
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   3 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  14 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   6 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   8 +-
 drivers/nvme/host/core.c                           |  16 +-
 drivers/pci/controller/pcie-mediatek.c             |  18 ++
 drivers/pci/controller/vmd.c                       |   2 +
 drivers/pci/probe.c                                |  24 +-
 drivers/pci/quirks.c                               | 260 ++++++++++++++++-----
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c       |   2 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  82 +++++--
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/platform/x86/intel-hid.c                   |   7 +
 drivers/platform/x86/intel-vbtn.c                  |  75 ++++--
 drivers/power/reset/vexpress-poweroff.c            |   1 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   7 +-
 drivers/spi/spi-bcm-qspi.c                         |   8 +-
 drivers/spi/spi-bcm2835.c                          |   4 +-
 drivers/spi/spi-bcm2835aux.c                       |   4 +-
 drivers/spi/spi-dw-mid.c                           |  16 +-
 drivers/spi/spi-dw.c                               |  12 +-
 drivers/spi/spi-pxa2xx.c                           |  12 +-
 drivers/spi/spi-topcliff-pch.c                     |   1 -
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/android/ion/ion_heap.c             |   4 +-
 drivers/staging/greybus/sdio.c                     |  10 +-
 drivers/tty/serial/8250/8250_pci.c                 |   6 -
 drivers/tty/serial/pch_uart.c                      |   2 -
 drivers/usb/dwc3/dwc3-haps.c                       |   4 -
 drivers/usb/gadget/udc/pch_udc.c                   |   1 -
 drivers/video/fbdev/w100fb.c                       |   2 +
 drivers/w1/masters/omap_hdq.c                      |  10 +-
 drivers/xen/pvcalls-back.c                         |   3 +-
 fs/aio.c                                           |   8 +
 fs/btrfs/dev-replace.c                             |   8 +-
 fs/btrfs/disk-io.c                                 |  10 +
 fs/btrfs/file-item.c                               |   6 +-
 fs/btrfs/inode.c                                   |  10 +-
 fs/btrfs/ioctl.c                                   |   5 +-
 fs/btrfs/qgroup.c                                  |  14 ++
 fs/btrfs/scrub.c                                   |   4 +-
 fs/btrfs/send.c                                    |  67 ++++++
 fs/btrfs/tree-checker.c                            |  20 ++
 fs/btrfs/volumes.c                                 |  86 +++----
 fs/btrfs/volumes.h                                 |   4 +-
 fs/ext4/ext4_extents.h                             |   9 +-
 fs/ext4/fsync.c                                    |  28 ++-
 fs/ext4/xattr.c                                    |   7 +-
 fs/fat/inode.c                                     |   6 +
 fs/fs-writeback.c                                  |   1 +
 fs/nilfs2/segment.c                                |   2 +
 fs/overlayfs/copy_up.c                             |   2 +-
 fs/proc/inode.c                                    |   2 +-
 fs/proc/self.c                                     |   2 +-
 fs/proc/thread_self.c                              |   2 +-
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_buf.c                                   |   8 +-
 fs/xfs/xfs_dquot.c                                 |   9 +-
 include/linux/kgdb.h                               |   2 +-
 include/linux/kvm_host.h                           |   4 +-
 include/linux/mm.h                                 |   1 +
 include/linux/mmzone.h                             |   2 +
 include/linux/pci_ids.h                            |  36 ++-
 include/linux/sched/mm.h                           |   2 +
 include/linux/set_memory.h                         |   2 +-
 include/linux/string.h                             |  60 ++++-
 include/linux/sunrpc/gss_api.h                     |   1 +
 include/linux/sunrpc/svcauth_gss.h                 |   3 +-
 include/linux/uaccess.h                            |   2 +-
 include/uapi/linux/kvm.h                           |   2 +
 kernel/audit.c                                     |  52 +++--
 kernel/audit.h                                     |   2 +-
 kernel/auditfilter.c                               |  16 +-
 kernel/compat.c                                    |   6 +-
 kernel/cpu.c                                       |  18 +-
 kernel/cpu_pm.c                                    |   4 +-
 kernel/debug/debug_core.c                          |   5 +
 kernel/events/core.c                               |  23 +-
 kernel/exit.c                                      |  31 +--
 kernel/sched/core.c                                |   5 +-
 kernel/sched/fair.c                                |   2 +-
 lib/mpi/longlong.h                                 |   2 +-
 lib/strncpy_from_user.c                            |  23 +-
 lib/strnlen_user.c                                 |  23 +-
 mm/huge_memory.c                                   |  31 ++-
 mm/page_alloc.c                                    |  19 +-
 mm/slub.c                                          |   4 +-
 mm/util.c                                          |  18 ++
 net/batman-adv/bat_v_elp.c                         |  15 +-
 net/bluetooth/hci_event.c                          |   1 +
 net/bridge/br_arp_nd_proxy.c                       |   4 +
 net/ipv6/ipv6_sockglue.c                           |  13 +-
 net/netfilter/nft_nat.c                            |   4 +-
 net/sunrpc/auth_gss/gss_mech_switch.c              |  12 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  18 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima.h                       |  10 +-
 security/integrity/ima/ima_crypto.c                |   6 +-
 security/integrity/ima/ima_init.c                  |   2 +-
 security/integrity/ima/ima_policy.c                |   3 +-
 security/integrity/ima/ima_template_lib.c          |  18 ++
 security/keys/internal.h                           |  11 -
 security/keys/keyctl.c                             |  16 +-
 security/smack/smackfs.c                           |  10 +
 sound/core/pcm_native.c                            |   5 +
 sound/isa/es1688/es1688.c                          |   4 +-
 sound/pci/hda/patch_realtek.c                      |   6 +
 sound/pci/lx6464es/lx6464es.c                      |   8 +
 sound/usb/card.c                                   |  19 +-
 sound/usb/quirks-table.h                           |  20 ++
 sound/usb/usbaudio.h                               |   2 +-
 tools/lib/api/fs/fs.c                              |  17 ++
 tools/lib/api/fs/fs.h                              |  12 +
 tools/objtool/check.c                              |   6 +
 tools/perf/builtin-probe.c                         |   3 +
 tools/perf/util/dso.c                              |  16 ++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/probe-event.c                      |  49 ++--
 tools/perf/util/probe-finder.c                     |   1 +
 tools/perf/util/symbol.c                           |   2 +
 tools/testing/selftests/bpf/test_progs.c           |   1 +
 .../testing/selftests/bpf/test_select_reuseport.c  |   8 +-
 .../networking/timestamping/rxtimestamp.c          |   1 +
 virt/kvm/arm/aarch32.c                             |  28 +++
 virt/kvm/kvm_main.c                                |  24 +-
 278 files changed, 2429 insertions(+), 1160 deletions(-)


