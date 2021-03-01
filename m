Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9E3287D9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhCAR3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238248AbhCARYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B76CA65074;
        Mon,  1 Mar 2021 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617335;
        bh=u/KiAqbukSOreMo+aOB7aJN48p3LMw1oC8VcASKm+AA=;
        h=From:To:Cc:Subject:Date:From;
        b=z1JAbKd1/oofjIl3o/PASjIhbxsSumC+gphw4pVmdI6QL/WSJ09p7zcKjAQCgyx30
         xVpUsNyzMhNdwm9D09iZvP/V1c/iOU3qVjRfmMVKsH6seTNzosRVjLjx6FSR0EUfsx
         l6FJycwrgYUxD2qoSRA7Gru4Su8BU4VUdEvynwrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/340] 5.4.102-rc1 review
Date:   Mon,  1 Mar 2021 17:09:04 +0100
Message-Id: <20210301161048.294656001@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.102-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.102-rc1
X-KernelTest-Deadline: 2021-03-03T16:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.102 release.
There are 340 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.102-rc1

Takeshi Misawa <jeliantsurux@gmail.com>
    net: qrtr: Fix memory leak in qrtr_tun_open

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Update in-core bitset after committing the metadata

Vlad Buslov <vladbu@nvidia.com>
    net: sched: fix police ext initialization

Jason A. Donenfeld <Jason@zx2c4.com>
    net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending

Leon Romanovsky <leonro@nvidia.com>
    ipv6: silence compilation warning for non-IPV6 builds

Eric Dumazet <edumazet@google.com>
    ipv6: icmp6: avoid indirect call for icmpv6_send()

Jason A. Donenfeld <Jason@zx2c4.com>
    xfrm: interface: use icmp_ndo_send helper

Jason A. Donenfeld <Jason@zx2c4.com>
    sunvnet: use icmp_ndo_send helper

Jason A. Donenfeld <Jason@zx2c4.com>
    gtp: use icmp_ndo_send helper

Jason A. Donenfeld <Jason@zx2c4.com>
    icmp: introduce helper for nat'd source address in network device context

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Reject 446-480MHz HDMI clock on GLK

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: only resize metadata in preresume

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Reinitialize bitset cache before digesting a new writeset

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Use correct value size in equality function of writeset tree

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Fix bitset memory leaks

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Verify the data block size hasn't changed

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Recover committed writeset after crash

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix writing beyond end of underlying device when shrinking

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix deadlock when swapping to encrypted device

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't skip dlm unlock if glock has an lvb

Masahisa Kojima <masahisa.kojima@linaro.org>
    spi: spi-synquacer: fix set_cs handling

Al Viro <viro@zeniv.linux.org.uk>
    sparc32: fix a user-triggerable oops in clear_user()

Chao Yu <chao@kernel.org>
    f2fs: fix out-of-repair __setattr_copy()

Johannes Berg <johannes.berg@intel.com>
    um: mm: check more comprehensively for stub changes

Cornelia Huck <cohuck@redhat.com>
    virtio/s390: implement virtio-ccw revision 2 correctly

Heiko Carstens <hca@linux.ibm.com>
    s390/vtime: fix inline assembly clobber list

Chen Yu <yu.c.chen@intel.com>
    cpufreq: intel_pstate: Get per-CPU max freq via MSR_HWP_CAPABILITIES if available

Muchun Song <songmuchun@bytedance.com>
    printk: fix deadlock when kernel panic

Maxim Kiselev <bigunclemax@gmail.com>
    gpio: pcf857x: Fix missing first interrupt

Subbaraman Narayanamurthy <subbaram@codeaurora.org>
    spmi: spmi-pmic-arb: Fix hw_irq overflow

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Add missing call to kuep_lock on syscall entry

Frank Li <Frank.Li@nxp.com>
    mmc: sdhci-esdhc-imx: fix kernel panic when remove module

Fangrui Song <maskray@google.com>
    module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Sean Young <sean@mess.org>
    media: smipcie: fix interrupt handling and IR timeout

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix copy_huge_page_from_user contig page struct assumption

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix update_and_free_page contig page struct assumption

NeilBrown <neilb@suse.de>
    x86: fix seq_file iteration for pat/memtype.c

NeilBrown <neilb@suse.de>
    seq_file: document how per-entry resources are managed.

Pan Bian <bianpan2016@163.com>
    fs/affs: release old buffer head on error path

Pan Bian <bianpan2016@163.com>
    mtd: spi-nor: hisi-sfc: Put child node np on error path

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: core: Add erase size check for erase command initialization

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: core: Fix erase type discovery for overlaid region

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: Fix wrong erase type bitmask for overlaid region

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: Fix last erase region marking

Alexander Usyskin <alexander.usyskin@intel.com>
    watchdog: mei_wdt: request stop on unregister

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    watchdog: qcom: Remove incorrect usage of QCOM_WDT_ENABLE_IRQ

He Zhe <zhe.he@windriver.com>
    arm64: uprobe: Return EOPNOTSUPP for AARCH32 instruction probing

qiuguorui1 <qiuguorui1@huawei.com>
    arm64: kexec_file: fix memory leakage in create_dtb() when fdt_open_into() fails

Jiri Kosina <jkosina@suse.cz>
    floppy: reintroduce O_NDELAY fix

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Trigger self-IPI on late deferred wake up before user resume

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Perform deferred wake up before last idle's need_resched() check

Frederic Weisbecker <frederic@kernel.org>
    rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers

Cédric Le Goater <clg@kaod.org>
    powerpc/prom: Fix "ibm,arch-vec-5-platform-support" scan

Sean Christopherson <seanjc@google.com>
    x86/reboot: Force all cpus to exit VMX root if VMX is supported

Sean Christopherson <seanjc@google.com>
    x86/virt: Eat faults on VMXOFF in reboot flows

Pavel Machek <pavel@denx.de>
    media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()

Martin Kaiser <martin@kaiser.cx>
    staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

Amey Narkhede <ameynarkhede03@gmail.com>
    staging: gdm724x: Fix DMA from stack

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c

Frank Wunderlich <frank-w@public-files.de>
    dts64: mt7622: fix slow sd card access

Jiri Bohac <jbohac@suse.cz>
    pstore: Fix typo in compression option name

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: init of rts522a add OCP power off when no card is present

Paul Cercueil <paul@crapouillou.net>
    seccomp: Add missing return in non-void function

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - initialize need_fallback

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - handle BigEndian for cipher

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - IV register does not work on A10 and A13

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - checking sg length is not sufficient

Ard Biesheuvel <ardb@kernel.org>
    crypto: aesni - prevent misaligned buffers on the stack

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm64/sha - add missing module aliases

Filipe Manana <fdmanana@suse.com>
    btrfs: fix extent buffer leak on failure to copy root

Josef Bacik <josef@toxicpanda.com>
    btrfs: splice remaining dirty_bg's onto the transaction dirty bg list

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix reloc root leak with 0 ref reloc roots on recovery

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort the transaction if we fail to inc ref in btrfs_copy_root

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix migratable=1 failing

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm_tis: Clean up locality release

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm_tis: Fix check_locality for correct locality acquisition

Gao Xiang <hsiangkao@redhat.com>
    erofs: initialized fields can only be observed after bit is set

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/sched: Cancel and flush all outstanding jobs before finish.

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/kms: handle mDP connectors

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Set reference clock to 100Mhz on Renoir (v2)

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add vupdate_no_lock interrupts for DCN2.1

Kai Krakow <kai@kaishome.de>
    bcache: Move journal work to new flush wq

Kai Krakow <kai@kaishome.de>
    bcache: Give btree_io_wq correct semantics again

Kai Krakow <kai@kaishome.de>
    Revert "bcache: Kill btree_io_wq"

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: modify EAPD in the ALC886

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: Add another CometLake-H PCI ID

Dan Carpenter <dan.carpenter@oracle.com>
    USB: serial: mos7720: fix error code in mos7720_write()

Dan Carpenter <dan.carpenter@oracle.com>
    USB: serial: mos7840: fix error code in mos7840_write()

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix FTX sub-integer prescaler

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Fix runtime PM race in musb_queue_resume_work

Lech Perczak <lech.perczak@gmail.com>
    USB: serial: option: update interface mapping for ZTE P685M

James Reynolds <jr@memlen.com>
    media: mceusb: Fix potential out-of-bounds shift

Marcos Paulo de Souza <mpdesouza@suse.com>
    Input: i8042 - add ASUS Zenbook Flip to noselftest list

Dan Carpenter <dan.carpenter@oracle.com>
    Input: joydev - prevent potential read overflow in ioctl

Olivier Crête <olivier.crete@ocrete.ca>
    Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S

jeffrey.lin <jeffrey.lin@rad-ic.com>
    Input: raydium_ts_i2c - do not send zero length

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ignore attempts to overwrite the touch_max value from HID

Filipe Laíns <lains@riseup.net>
    HID: logitech-dj: add support for keyboard events in eQUAD step 4 Gaming

Qinglang Miao <miaoqinglang@huawei.com>
    ACPI: configfs: add missing check after configfs_register_default_group()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Fix fwnode string properties matching

Mikulas Patocka <mpatocka@redhat.com>
    blk-settings: align max_sectors on "logical_block_size" boundary

Randy Dunlap <rdunlap@infradead.org>
    scsi: bnx2fc: Fix Kconfig warning & CNIC build errors

Miaohe Lin <linmiaohe@huawei.com>
    mm/rmap: fix potential pte_unmap on an not mapped pte

Maxime Ripard <maxime@cerno.tech>
    i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition

Marc Zyngier <maz@kernel.org>
    arm64: Add missing ISB after invalidating TLB in __primary_switch

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix jumbo packet handling on RTL8168e

Wonhyuk Yang <vvghjk1234@gmail.com>
    mm/compaction: fix misbehaviors of fast_find_migrateblock()

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential double free in hugetlb_register_node() error path

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory.c: fix potential pte_unmap_unlock pte error

Dan Carpenter <dan.carpenter@oracle.com>
    ocfs2: fix a use after free on error

Taehee Yoo <ap420073@gmail.com>
    vxlan: move debug check after netdev unregister

Chuhong Yuan <hslester96@gmail.com>
    net/mlx4_core: Add missed mlx4_free_cmd_mailbox()

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Use follow_pte()

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix add TC filter for IPv6

Jann Horn <jannh@google.com>
    Take mmap lock in cacheflush syscall

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix VFs not created

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix addition of RX filters after enabling FW LLDP agent

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix overwriting flow control settings during driver loading

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Add zero-initialization of AQ command structures

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix flow for IPv6 next header (extension header)

Bard Liao <yung-chuan.liao@linux.intel.com>
    regmap: sdw: use _no_pm functions in regmap_read/write

Ahmad Fatoum <a.fatoum@pengutronix.de>
    nvmem: core: skip child nodes not matching binding

Dan Carpenter <dan.carpenter@oracle.com>
    nvmem: core: Fix a resource leak on error in nvmem_add_cells_from_of()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential htree index checksum corruption

Keqian Zhu <zhukeqian1@huawei.com>
    vfio/iommu_type1: Fix some sanity checks in detach group

Iskren Chernev <iskren.chernev@gmail.com>
    drm/msm/mdp5: Fix wait-for-commit for cmd panels

Konrad Dybcio <konrad.dybcio@somainline.org>
    drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: hbm: call mei_set_devstate() on hbm stop response

Heiner Kallweit <hkallweit1@gmail.com>
    PCI: Align checking of syscall user config accessors

Jorgen Hansen <jhansen@vmware.com>
    VMCI: Use set_page_dirty_lock() when unregistering guest memory

Simon South <simon@simonsouth.net>
    pwm: rockchip: rockchip_pwm_probe(): Remove superfluous clk_unprepare()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix ACK/NAK handling

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Chris Ruehl <chris.ruehl@gtsys.com.hk>
    phy: rockchip-emmc: emmc_phy_init() always return 0

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Fix module alias to enable module autoprobe

Randy Dunlap <rdunlap@infradead.org>
    sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set

Dan Carpenter <dan.carpenter@oracle.com>
    Input: elo - fix an error code in elo_connect()

Namhyung Kim <namhyung@kernel.org>
    perf test: Fix unaligned access in sample parsing test

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix premature IPC

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix missing CYC processing in PSB

Dan Carpenter <dan.carpenter@oracle.com>
    Input: sur40 - fix an error code in sur40_probe()

Lang Cheng <chenglang@huawei.com>
    RDMA/hns: Fixes missing error code of CMDQ

J. Bruce Fields <bfields@redhat.com>
    nfsd: register pernet ops last, unregister first

Ryan Chen <ryan_chen@aspeedtech.com>
    clk: aspeed: Fix APLL calculate formula from ast2600-A2

Jonathan Marek <jonathan@marek.ca>
    regulator: qcom-rpmh: fix pm8009 ldo7

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: pxa2xx: Fix the controller numbering for Wildcat Point

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Fix type of sq_signal_bits

Kamal Heib <kamalheib1@gmail.com>
    RDMA/siw: Fix calculation of tx_valid_cpus size

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fixed wrong judgments in the goto branch

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    clk: qcom: gcc-msm8998: Fix Alpha PLL type for all GPLLs

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix software emulation interrupt

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/dlpar: handle ibm, configure-connector delay status

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32: properly handle 0 byte transfer

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Correct skb on loopback path

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix coding error in rxe_rcv_mcast_pkt

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix coding error in rxe_recv.c

John Garry <john.garry@huawei.com>
    perf vendor events arm64: Fix Ampere eMag event typo

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Fix DSO filtering when not finding a map for a sampled address

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracepoint: Do not fail unregistering a probe due to memory failure

Parav Pandit <parav@nvidia.com>
    IB/cm: Avoid a loop when device has 255 ports

Parav Pandit <parav@nvidia.com>
    IB/mlx5: Return appropriate error code instead of ENOMEM

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    amba: Fix resource leak for drivers without .remove

Roja Rani Yarubandi <rojay@codeaurora.org>
    i2c: i2c-qcom-geni: Add shutdown callback for i2c

Roja Rani Yarubandi <rojay@codeaurora.org>
    i2c: qcom-geni: Store DMA mapping data in geni_i2c_dev struct

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Takeshi Saito <takeshi.saito.xv@renesas.com>
    mmc: renesas_sdhi_internal_dmac: Fix DMA buffer alignment from 8 to 128-bytes

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: sdhci-sprd: Fix some resource leaks in the remove function

Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
    powerpc/sstep: Fix incorrect return from analyze_instr()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/47x: Disable 256k page size

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Make the VMX instruction emulation routines static

Shay Drory <shayd@nvidia.com>
    IB/umad: Return EPOLLERR in case of when device disassociated

Shay Drory <shayd@nvidia.com>
    IB/umad: Return EIO in case of when device disassociated

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix ".cold" section suffix check for newer versions of GCC

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix error handling for STD/CLD warnings

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Fix refresh rate handling

Pan Bian <bianpan2016@163.com>
    isofs: release buffer head before return

Hans de Goede <hdegoede@redhat.com>
    regulator: core: Avoid debugfs: Directory ... already present! error

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: s5m8767: Drop regulators OF node reference

Pan Bian <bianpan2016@163.com>
    spi: atmel: Put allocated master before return

Pan Bian <bianpan2016@163.com>
    regulator: s5m8767: Fix reference count leak

David Howells <dhowells@redhat.com>
    certs: Fix blacklist flag type confusion

Pan Bian <bianpan2016@163.com>
    regulator: axp20x: Fix reference cout leak

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h6: Fix clock divider range on some clocks

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Use the correct obj_id upon DEVX TIR creation

Tom Rix <trix@redhat.com>
    clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Arnd Bergmann <arnd@arndb.de>
    clocksource/drivers/ixp4xx: Select TIMER_OF when needed

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    rtc: s5m: select REGMAP_I2C

Claudiu Beznea <claudiu.beznea@microchip.com>
    power: reset: at91-sama5d2_shdwc: fix wkupdbc mask

Nicolas Boichat <drinkcat@chromium.org>
    of/fdt: Make sure no-map does not remove already reserved regions

KarimAllah Ahmed <karahmed@amazon.de>
    fdt: Properly handle "no-map" field in the memory region

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    mfd: bd9571mwv: Use devm_mfd_add_devices()

Ferry Toth <ftoth@exalondelft.nl>
    dmaengine: hsu: disable spurious interrupt

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: owl-dma: Fix a resource leak in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: fsldma: Fix a resource leak in the remove function

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix handling of zero-sized Read and Receive Queues.

Randy Dunlap <rdunlap@infradead.org>
    HID: core: detect and skip invalid inputs to snto32()

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h6: Fix CEC clock

Pratyush Yadav <p.yadav@ti.com>
    spi: cadence-quadspi: Abort read if dummy cycles required are too many

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: handle master read request

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: update slave isr mask (ISR_MASK_SLAVE)

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: handle only slave interrupts which are enabled

Jan Kara <jack@suse.cz>
    quota: Fix memory leak when handling corrupted quota file

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/powerpc: Make the test check in eeh-basic.sh posix compliant

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: propagate the error from meson_clk_pll_set_rate()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: make "ret" a signed integer

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL

Zhang Qilong <zhangqilong3@huawei.com>
    HSI: Fix PM usage counter unbalance in ssi_hw_init

Eric W. Biederman <ebiederm@xmission.com>
    capabilities: Don't allow writing ambiguous v3 file capabilities

Wang ShaoBo <bobo.shaobowang@huawei.com>
    ubifs: Fix error return code in alloc_wbufs()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ubifs: Fix memleak in ubifs_init_authentication

Tom Rix <trix@redhat.com>
    jffs2: fix use after free in jffs2_sum_write_data()

Colin Ian King <colin.king@canonical.com>
    fs/jfs: fix potential integer overflow on shift of a int

Sameer Pujar <spujar@nvidia.com>
    ASoC: simple-card-utils: Fix device module clock

Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
    ima: Free IMA measurement buffer after kexec syscall

Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
    ima: Free IMA measurement buffer on error

Daniele Alessandrelli <daniele.alessandrelli@intel.com>
    crypto: ecdh_helper - Ensure 'len >= secret.len' in decode_key()

Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>
    hwrng: timeriomem - Fix cooldown period calculation

Zhihao Cheng <chengzhihao1@huawei.com>
    btrfs: clarify error returns values in __load_free_space_cache

Hui Wang <hui.wang@canonical.com>
    ASoC: SOF: debug: Fix a potential issue on string buffer termination

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Avoid use-after-free in vmbus_onoffer_rescind()

Dehe Gu <gudehe@huawei.com>
    f2fs: fix a wrong condition in __submit_bio

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()

Yi Chen <chenyi77@huawei.com>
    f2fs: fix to avoid inconsistent quota data

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    mtd: parsers: afs: Fix freeing the part name memory in failure

Sebastian Reichel <sre@kernel.org>
    ASoC: cpcap: fix microphone timeslot mask

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Add back regulators management

Frantisek Hrbata <frantisek@hrbata.com>
    drm/nouveau: bail out of nouveau_channel_new if channel init fails

Christophe Leroy <christophe.leroy@csgroup.eu>
    crypto: talitos - Work around SEC6 ERRATA (AES-CTR mode data size error)

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: parser: imagetag: fix error codes in bcm963xx_parse_imagetag_partitions()

Qais Yousef <qais.yousef@arm.com>
    sched/eas: Don't update misfit status if the task is pinned

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Tom Rix <trix@redhat.com>
    media: pxa_camera: declare variable when DEBUG is defined

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cx25821: Fix a bug when reallocating some dma memory

Luo Meng <luomeng12@huawei.com>
    media: qm1d1c0042: fix error return code in qm1d1c0042_init()

Joe Perches <joe@perches.com>
    media: lmedm04: Fix misuse of comma

Daniel Scally <djrscally@gmail.com>
    media: software_node: Fix refcounts in software_node_get_next_child()

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Fix HDMI deep color output for DCE 6-11.

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Fix 10/12 bpc setup in DCE output bit depth reduction.

Pan Bian <bianpan2016@163.com>
    bsg: free the request before return error code

Alexander Lobakin <alobakin@pm.me>
    MIPS: properly stop .eh_frame generation

Giulio Benetti <giulio.benetti@micronovasrl.com>
    drm/sun4i: tcon: fix inverted DCLK polarity

Jiri Olsa <jolsa@kernel.org>
    crypto: bcm - Rename struct device_private to bcm_device_private

Dinghao Liu <dinghao.liu@zju.edu.cn>
    evm: Fix memleak in init_desc

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: cs42l56: fix up error handling in probe

Zhang Changzhong <zhangchangzhong@huawei.com>
    media: aspeed: fix error return code in aspeed_video_setup_video()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: tm6000: Fix memleak in tm6000_start_stream

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: media/pci: Fix memleak in empress_init

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: em28xx: Fix use-after-free in em28xx_alloc_urbs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: vsp1: Fix an error handling path in the probe function

Dan Carpenter <dan.carpenter@oracle.com>
    media: camss: missing error code in msm_video_register()

Ezequiel Garcia <ezequiel@collabora.com>
    media: imx: Fix csc/scaler unregister

Ezequiel Garcia <ezequiel@collabora.com>
    media: imx: Unregister csc/scaler only if registered

Jacopo Mondi <jacopo@jmondi.org>
    media: i2c: ov5670: Fix PIXEL_RATE minimum value

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: c-r4k: Fix section mismatch for loongson2_sc_init

Chenyang Li <lichenyang@loongson.cn>
    drm/amdgpu: Fix macro name _AMDGPU_TRACE_H_ in preprocessor if condition

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - fix kmap usage

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - linearize buffers content must be kept

Chuhong Yuan <hslester96@gmail.com>
    drm/fb-helper: Add missed unlocks in setcmap_legacy()

Dan Carpenter <dan.carpenter@oracle.com>
    gma500: clean up error handling in init

Jialin Zhang <zhangjialin11@huawei.com>
    drm/gma500: Fix error return code in psb_driver_load()

Randy Dunlap <rdunlap@infradead.org>
    fbdev: aty: SPARC64 requires FB_ATY_CT

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvneta: Remove per-cpu queue mapping for Armada 3700

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Reset link when the link never comes back

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: skip send_request_unmap for timeout reset

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: add memory barrier to protect long term buffer

Colin Ian King <colin.king@canonical.com>
    b43: N-PHY: Fix the update of coef for the PHY revision >= 3case

Ayush Sawal <ayush.sawal@chelsio.com>
    cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Handle deferred probe on clock properly

Eric Dumazet <edumazet@google.com>
    tcp: fix SO_RCVLOWAT related hangs under mem pressure

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf: Fix bpf_fib_lookup helper MTU check for SKB ctx

Colin Ian King <colin.king@canonical.com>
    mac80211: fix potential overflow when multiplying to u32 integers

Juergen Gross <jgross@suse.com>
    xen/netback: fix spurious event detection for common event case

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: reverse order of TX disable and carrier off

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Set to CLOSED state even on error

Linus Lüssing <ll@simonwunderlich.de>
    ath9k: fix data bus crash when setting nf_override via debugfs

Marco Elver <elver@google.com>
    bpf_lru_list: Read double-checked variable once without lock

Jae Hyun Yoo <jae.hyun.yoo@intel.com>
    soc: aspeed: snoop: Add clock control logic

Arnd Bergmann <arnd@arndb.de>
    ARM: s3c: fix fiq for clang IAS

Vincent Knecht <vincent.knecht@mailoo.org>
    arm64: dts: msm8916: Fix reserved and rfsa nodes unit address

Jupeng Zhong <zhongjupeng@yulong.com>
    Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv

Marek Behún <kabel@kernel.org>
    arm64: dts: armada-3720-turris-mox: rename u-boot mtd partition to a53-firmware

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada388-helios4: assign pinctrl to each fan

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada388-helios4: assign pinctrl to LEDs

Chen-Yu Tsai <wens@csie.org>
    staging: rtl8723bs: wifi_regd.c: Fix incorrect number of regulatory rules

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Make "trimming xfer length" a debug message

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Abort transaction after errors with unknown reason

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Do not update data length if it is 0 on inbound transfers

Tony Lindgren <tony@atomide.com>
    ARM: dts: Configure missing thermal interrupt for 4430

Pan Bian <bianpan2016@163.com>
    memory: ti-aemif: Drop child node when jumping out loop

Pan Bian <bianpan2016@163.com>
    Bluetooth: Put HCI device if inquiry procedure interrupts

Pan Bian <bianpan2016@163.com>
    Bluetooth: drop HCI device reference before return

Jack Pham <jackp@codeaurora.org>
    usb: gadget: u_audio: Free requests only after callback

Maximilian Luz <luzmaximilian@gmail.com>
    ACPICA: Fix exception code class checks

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cpufreq: brcmstb-avs-cpufreq: Free resources in error path

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: A64: Limit MMC2 bus frequency to 150 MHz

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H6: Allow up to 150 MHz MMC bus frequency

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H6: properly connect USB PHY to port 0

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: A64: properly connect USB PHY to port 0

Andrii Nakryiko <andrii@kernel.org>
    bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args

Andrii Nakryiko <andrii@kernel.org>
    bpf: Add bpf_patch_call_args prototype to include/linux/bpf.h

Zhang Qilong <zhangqilong3@huawei.com>
    memory: mtk-smi: Fix PM usage counter unbalance in mtk_smi ops

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: exynos: correct PMIC interrupt trigger level on TM2

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid XU3 family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Spring

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Rinato

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Monk

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Artik 5

Christopher William Snowhill <chris@kode54.net>
    Bluetooth: Fix initializing response id after clearing struct

Claire Chang <tientzu@chromium.org>
    Bluetooth: hci_uart: Fix a race for write_work scheduling

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Fix error handling in case of CE pipe init failure

Eric Biggers <ebiggers@google.com>
    random: fix the RNDRESEEDCRNG ioctl

Alexander Lobakin <alobakin@pm.me>
    MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix PCM buffer allocation in non-vmalloc mode

Jan Kara <jack@suse.cz>
    bfq: Avoid false bfq queue merging

Hans de Goede <hdegoede@redhat.com>
    virt: vbox: Do not use wait_event_interruptible when called from kernel context

Ard Biesheuvel <ardb@kernel.org>
    PCI: Decline to resize resources if boot config must be preserved

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Use PHY_REFCLK_USE_PAD only for ipq8064

Sumit Garg <sumit.garg@linaro.org>
    kdb: Make memory allocations more robust

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    debugfs: do not attempt to create a new file before the filesystem is initalized

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    debugfs: be more robust at handling improper input in debugfs_lookup()

Maxim Levitsky <mlevitsk@redhat.com>
    kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: add DWARF v5 sections


-------------

Diffstat:

 Documentation/filesystems/seq_file.txt             |   6 +
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |   4 +-
 arch/arm/boot/dts/armada-388-helios4.dts           |  28 ++-
 arch/arm/boot/dts/exynos3250-artik5.dtsi           |   2 +-
 arch/arm/boot/dts/exynos3250-monk.dts              |   2 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos5250-spring.dts            |   2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   2 +-
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi      |   2 +-
 arch/arm/boot/dts/omap443x.dtsi                    |   2 +
 arch/arm/mach-ixp4xx/Kconfig                       |   1 -
 arch/arm64/Kconfig                                 |   2 +-
 .../boot/dts/allwinner/sun50i-a64-pinebook.dts     |   5 +-
 .../boot/dts/allwinner/sun50i-a64-sopine.dtsi      |   1 -
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   6 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |   7 +
 .../boot/dts/exynos/exynos5433-tm2-common.dtsi     |   2 +-
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |   2 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   2 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/crypto/aes-glue.c                       |   4 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   1 +
 arch/arm64/crypto/sha2-ce-glue.c                   |   2 +
 arch/arm64/crypto/sha3-ce-glue.c                   |   4 +
 arch/arm64/crypto/sha512-ce-glue.c                 |   2 +
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/head.S                           |   1 +
 arch/arm64/kernel/machine_kexec_file.c             |   4 +-
 arch/arm64/kernel/probes/uprobes.c                 |   2 +-
 arch/mips/include/asm/asm.h                        |  18 ++
 arch/mips/kernel/vmlinux.lds.S                     |   2 +-
 arch/mips/lantiq/irq.c                             |   2 +-
 arch/mips/mm/c-r4k.c                               |   2 +-
 arch/nios2/kernel/sys_nios2.c                      |  11 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/kernel/entry_32.S                     |   3 +
 arch/powerpc/kernel/head_8xx.S                     |   2 +-
 arch/powerpc/kernel/prom_init.c                    |  12 +-
 arch/powerpc/kvm/powerpc.c                         |   8 +-
 arch/powerpc/lib/sstep.c                           |   7 +-
 arch/powerpc/platforms/pseries/dlpar.c             |   7 +-
 arch/s390/kernel/vtime.c                           |   3 +-
 arch/sparc/Kconfig                                 |   2 +-
 arch/sparc/lib/memset.S                            |   1 +
 arch/um/kernel/tlb.c                               |  12 +-
 arch/x86/crypto/aesni-intel_glue.c                 |  28 ++-
 arch/x86/include/asm/virtext.h                     |  17 +-
 arch/x86/kernel/reboot.c                           |  29 +--
 arch/x86/kvm/svm.c                                 |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/kvm/x86.c                                 |  38 +--
 arch/x86/kvm/x86.h                                 |   2 +-
 arch/x86/mm/pat.c                                  |   3 +-
 block/bfq-iosched.c                                |   1 +
 block/blk-settings.c                               |  12 +
 block/bsg.c                                        |   4 +-
 certs/blacklist.c                                  |   2 +-
 crypto/ecdh_helper.c                               |   3 +
 drivers/acpi/acpi_configfs.c                       |   7 +-
 drivers/acpi/property.c                            |  44 +++-
 drivers/amba/bus.c                                 |  20 +-
 drivers/ata/ahci_brcm.c                            |  14 +-
 drivers/auxdisplay/ht16k33.c                       |   3 +-
 drivers/base/regmap/regmap-sdw.c                   |   4 +-
 drivers/base/swnode.c                              |   8 +-
 drivers/block/floppy.c                             |  27 +-
 drivers/bluetooth/btqcomsmd.c                      |  27 +-
 drivers/bluetooth/btusb.c                          |  20 +-
 drivers/bluetooth/hci_ldisc.c                      |   7 +-
 drivers/bluetooth/hci_serdev.c                     |   4 +-
 drivers/char/hw_random/timeriomem-rng.c            |   2 +-
 drivers/char/random.c                              |   2 +-
 drivers/char/tpm/tpm_tis_core.c                    |  50 +---
 drivers/clk/clk-ast2600.c                          |  37 ++-
 drivers/clk/meson/clk-pll.c                        |  10 +-
 drivers/clk/qcom/gcc-msm8998.c                     | 100 ++++----
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |  10 +-
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/mxs_timer.c                    |   5 +-
 drivers/cpufreq/brcmstb-avs-cpufreq.c              |  24 +-
 drivers/cpufreq/intel_pstate.c                     |   5 +-
 drivers/crypto/bcm/cipher.c                        |   2 +-
 drivers/crypto/bcm/cipher.h                        |   4 +-
 drivers/crypto/bcm/util.c                          |   2 +-
 drivers/crypto/chelsio/chtls/chtls_cm.h            |   3 -
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          | 173 ++++++++-----
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |   2 +
 drivers/crypto/talitos.c                           |  28 ++-
 drivers/crypto/talitos.h                           |   1 +
 drivers/dma/fsldma.c                               |   6 +
 drivers/dma/hsu/pci.c                              |  21 +-
 drivers/dma/owl-dma.c                              |   1 +
 drivers/gpio/gpio-pcf857x.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h          |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 +
 .../gpu/drm/amd/display/dc/bios/command_table.c    |  61 +++++
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |  14 ++
 .../drm/amd/display/dc/dce/dce_stream_encoder.c    |   1 +
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c |   8 +-
 .../amd/display/dc/irq/dcn21/irq_service_dcn21.c   |  22 ++
 drivers/gpu/drm/drm_fb_helper.c                    |  15 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |  22 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |   2 +
 drivers/gpu/drm/i915/display/intel_hdmi.c          |   6 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   2 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c         |   2 +-
 .../drm/nouveau/include/nvkm/subdev/bios/conn.h    |   1 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   1 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 +
 drivers/gpu/drm/scheduler/sched_main.c             |   3 +
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  21 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.h                 |   1 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-logitech-dj.c                      |   1 +
 drivers/hid/wacom_wac.c                            |   7 +-
 drivers/hsi/controllers/omap_ssi_core.c            |   2 +-
 drivers/hv/channel_mgmt.c                          |   3 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 | 231 ++++++++++++++----
 drivers/i2c/busses/i2c-brcmstb.c                   |   2 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  93 +++++--
 drivers/infiniband/core/cm.c                       |   8 +-
 drivers/infiniband/core/user_mad.c                 |  17 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   7 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   3 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   3 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   5 +
 drivers/infiniband/sw/rxe/rxe_recv.c               |  27 +-
 drivers/infiniband/sw/siw/siw.h                    |   2 +-
 drivers/infiniband/sw/siw/siw_main.c               |   2 +-
 drivers/infiniband/sw/siw/siw_qp.c                 | 271 +++++++++++----------
 drivers/infiniband/sw/siw/siw_qp_rx.c              |  26 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   4 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  20 +-
 drivers/input/joydev.c                             |   7 +-
 drivers/input/joystick/xpad.c                      |   1 +
 drivers/input/serio/i8042-x86ia64io.h              |   4 +
 drivers/input/touchscreen/elo.c                    |   4 +-
 drivers/input/touchscreen/raydium_i2c_ts.c         |   3 +-
 drivers/input/touchscreen/sur40.c                  |   1 +
 drivers/md/bcache/bcache.h                         |   3 +
 drivers/md/bcache/btree.c                          |  21 +-
 drivers/md/bcache/journal.c                        |   4 +-
 drivers/md/bcache/super.c                          |  20 ++
 drivers/md/dm-core.h                               |   4 +
 drivers/md/dm-crypt.c                              |   1 +
 drivers/md/dm-era-target.c                         |  93 ++++---
 drivers/md/dm-writecache.c                         |  18 ++
 drivers/md/dm.c                                    |  60 +++++
 drivers/media/i2c/ov5670.c                         |   3 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   4 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   5 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |  46 ++--
 drivers/media/platform/aspeed-video.c              |   6 +-
 drivers/media/platform/pxa_camera.c                |   3 +
 drivers/media/platform/qcom/camss/camss-video.c    |   1 +
 drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/media/tuners/qm1d1c0042.c                  |   4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   2 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   6 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |   4 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |  18 +-
 drivers/memory/mtk-smi.c                           |   4 +-
 drivers/memory/ti-aemif.c                          |   8 +-
 drivers/mfd/bd9571mwv.c                            |   6 +-
 drivers/mfd/wm831x-auxadc.c                        |   3 +-
 drivers/misc/cardreader/rts5227.c                  |   5 +
 drivers/misc/eeprom/eeprom_93xx46.c                |   1 +
 drivers/misc/mei/hbm.c                             |   2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   5 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   3 +-
 drivers/mmc/host/sdhci-sprd.c                      |   6 +-
 drivers/mmc/host/usdhi6rol0.c                      |   4 +-
 drivers/mtd/parsers/afs.c                          |   4 +-
 drivers/mtd/parsers/parser_imagetag.c              |   4 +
 drivers/mtd/spi-nor/cadence-quadspi.c              |   2 +-
 drivers/mtd/spi-nor/hisi-sfc.c                     |   4 +-
 drivers/mtd/spi-nor/spi-nor.c                      |  15 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |  14 ++
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  39 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   3 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  11 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  16 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  16 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  50 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   9 +-
 drivers/net/ethernet/marvell/mvneta.c              |   9 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/ethernet/sun/sunvnet_common.c          |  23 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  26 +-
 drivers/net/gtp.c                                  |   5 +-
 drivers/net/vxlan.c                                |  11 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   5 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   5 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |   2 +-
 drivers/net/xen-netback/interface.c                |   8 +-
 drivers/nvmem/core.c                               |   5 +-
 drivers/of/fdt.c                                   |  12 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   4 +-
 drivers/pci/setup-res.c                            |   6 +
 drivers/pci/syscall.c                              |  10 +-
 drivers/phy/rockchip/phy-rockchip-emmc.c           |   8 +-
 drivers/power/reset/at91-sama5d2_shdwc.c           |   2 +-
 drivers/pwm/pwm-rockchip.c                         |   1 -
 drivers/regulator/axp20x-regulator.c               |   7 +-
 drivers/regulator/core.c                           |   6 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
 drivers/regulator/s5m8767.c                        |  15 +-
 drivers/rtc/Kconfig                                |   1 +
 drivers/s390/virtio/virtio_ccw.c                   |   4 +-
 drivers/scsi/bnx2fc/Kconfig                        |   1 +
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  30 ++-
 drivers/soundwire/cadence_master.c                 |   8 +-
 drivers/spi/spi-atmel.c                            |   2 +-
 drivers/spi/spi-pxa2xx-pci.c                       |  27 +-
 drivers/spi/spi-s3c24xx-fiq.S                      |   9 +-
 drivers/spi/spi-stm32.c                            |   4 +
 drivers/spi/spi-synquacer.c                        |   4 +
 drivers/spmi/spmi-pmic-arb.c                       |   5 +-
 drivers/staging/gdm724x/gdm_usb.c                  |  10 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   4 -
 drivers/staging/media/imx/imx-media-dev.c          |   7 +-
 drivers/staging/mt7621-dma/Makefile                |   2 +-
 .../mt7621-dma/{mtk-hsdma.c => hsdma-mt7621.c}     |   2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c       |   2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |   3 +-
 drivers/usb/dwc2/hcd.c                             |  15 +-
 drivers/usb/dwc2/hcd_intr.c                        |  14 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/gadget/function/u_audio.c              |  17 +-
 drivers/usb/musb/musb_core.c                       |  31 +--
 drivers/usb/serial/ftdi_sio.c                      |   5 +-
 drivers/usb/serial/mos7720.c                       |   4 +-
 drivers/usb/serial/mos7840.c                       |   4 +-
 drivers/usb/serial/option.c                        |   3 +-
 drivers/vfio/vfio_iommu_type1.c                    |  46 ++--
 drivers/video/fbdev/Kconfig                        |   2 +-
 drivers/virt/vboxguest/vboxguest_utils.c           |  18 +-
 drivers/watchdog/mei_wdt.c                         |   1 +
 drivers/watchdog/qcom-wdt.c                        |  13 +-
 fs/affs/namei.c                                    |   4 +-
 fs/btrfs/block-group.c                             |  19 +-
 fs/btrfs/ctree.c                                   |   7 +-
 fs/btrfs/free-space-cache.c                        |   6 +-
 fs/btrfs/relocation.c                              |   4 +-
 fs/debugfs/inode.c                                 |   5 +-
 fs/erofs/xattr.c                                   |  10 +-
 fs/erofs/zmap.c                                    |  10 +-
 fs/ext4/namei.c                                    |   7 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/file.c                                     |   7 +-
 fs/f2fs/inline.c                                   |   4 +
 fs/gfs2/bmap.c                                     |   6 +-
 fs/gfs2/lock_dlm.c                                 |   8 +-
 fs/isofs/dir.c                                     |   1 +
 fs/isofs/namei.c                                   |   1 +
 fs/jffs2/summary.c                                 |   3 +
 fs/jfs/jfs_dmap.c                                  |   2 +-
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/ocfs2/cluster/heartbeat.c                       |   8 +-
 fs/pstore/platform.c                               |   4 +-
 fs/quota/quota_v2.c                                |  11 +-
 fs/ubifs/auth.c                                    |   2 +-
 fs/ubifs/super.c                                   |   4 +-
 include/acpi/acexcep.h                             |  10 +-
 include/asm-generic/vmlinux.lds.h                  |   7 +-
 include/linux/bpf.h                                |   3 +
 include/linux/device-mapper.h                      |   5 +
 include/linux/filter.h                             |   2 +-
 include/linux/icmpv6.h                             |  44 +++-
 include/linux/ipv6.h                               |   1 -
 include/linux/kexec.h                              |   5 +
 include/linux/key.h                                |   1 +
 include/linux/rcupdate.h                           |   2 +
 include/linux/rmap.h                               |   3 +-
 include/net/act_api.h                              |   1 +
 include/net/icmp.h                                 |  10 +
 include/net/tcp.h                                  |   9 +-
 kernel/bpf/bpf_lru_list.c                          |   7 +-
 kernel/debug/kdb/kdb_private.h                     |   2 +-
 kernel/kexec_file.c                                |   5 +
 kernel/module.c                                    |  21 +-
 kernel/printk/printk_safe.c                        |  16 +-
 kernel/rcu/tree.c                                  |  27 +-
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_plugin.h                           |  30 ++-
 kernel/sched/fair.c                                |   2 +-
 kernel/sched/idle.c                                |   1 +
 kernel/seccomp.c                                   |   2 +
 kernel/tracepoint.c                                |  80 ++++--
 mm/compaction.c                                    |  27 +-
 mm/hugetlb.c                                       |  10 +-
 mm/memory.c                                        |  16 +-
 net/bluetooth/a2mp.c                               |   3 +-
 net/bluetooth/hci_core.c                           |   6 +-
 net/core/filter.c                                  |  13 +-
 net/ipv4/icmp.c                                    |  34 +++
 net/ipv6/icmp.c                                    |  19 +-
 net/ipv6/ip6_icmp.c                                |  46 +++-
 net/mac80211/mesh_hwmp.c                           |   2 +-
 net/qrtr/tun.c                                     |  12 +-
 net/sched/act_api.c                                |   2 +-
 net/sched/cls_api.c                                |   1 +
 net/xfrm/xfrm_interface.c                          |   6 +-
 security/commoncap.c                               |  12 +-
 security/integrity/evm/evm_crypto.c                |   7 +-
 security/integrity/ima/ima_kexec.c                 |   3 +
 security/integrity/ima/ima_mok.c                   |   5 +-
 security/keys/key.c                                |   2 +
 security/keys/trusted.c                            |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |  11 +
 sound/soc/codecs/cpcap.c                           |  12 +-
 sound/soc/codecs/cs42l56.c                         |   3 +-
 sound/soc/generic/simple-card-utils.c              |  13 +-
 sound/soc/sof/debug.c                              |   2 +-
 sound/usb/pcm.c                                    |   2 +-
 tools/objtool/check.c                              |  12 +-
 .../pmu-events/arch/arm64/ampere/emag/cache.json   |   2 +-
 tools/perf/tests/sample-parsing.c                  |   2 +-
 tools/perf/util/event.c                            |   2 +
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  14 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.h  |   1 +
 tools/perf/util/intel-pt.c                         |  16 +-
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh   |   2 +-
 337 files changed, 2573 insertions(+), 1253 deletions(-)


