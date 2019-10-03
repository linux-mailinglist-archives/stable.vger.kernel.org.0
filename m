Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A745CA85E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbfJCQ0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390992AbfJCQZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 691AA215EA;
        Thu,  3 Oct 2019 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119953;
        bh=+QVIHzagQ1B4dWAqbz2UGjqwDfMio9GQfUAu5Q3nCxM=;
        h=From:To:Cc:Subject:Date:From;
        b=a1sn+4u1FTpiwXdJnIV49pHVOGRA0XFjHhg3FhwxO5xEu7raGV9mnCMys8ch66vtU
         GDJH1QiVRO+lWKhYShXSc1X82hpmtTMu584G94lo/KtkUGrJ2VWtxPwy8iSu20Fhm2
         z441PG9VMgoJYJN8x6mO8sPEBxH0zJM15ePHZYiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 000/313] 5.2.19-stable review
Date:   Thu,  3 Oct 2019 17:49:38 +0200
Message-Id: <20191003154533.590915454@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.19-rc1
X-KernelTest-Deadline: 2019-10-05T15:46+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.19 release.
There are 313 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.19-rc1

Pi-Hsun Shih <pihsun@chromium.org>
    platform/chrome: cros_ec_rpmsg: Fix race with host command when probe failed

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix mt7615 firmware path definitions

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: always release sem in mt7615_load_patch

NeilBrown <neilb@suse.de>
    md/raid0: avoid RAID0 data corruption due to layout confusion.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amd/display: Restore backlight brightness after system resume

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix oplock handling for SMB 2.1+ protocols

Murphy Zhou <jencce.kernel@gmail.com>
    CIFS: fix max ea value size

Chris Brandt <chris.brandt@renesas.com>
    i2c: riic: Clear NACK in tend isr

Laurent Vivier <lvivier@redhat.com>
    hwrng: core - don't wait on add_early_randomness()

Chao Yu <yuchao0@huawei.com>
    quota: fix wrong condition in is_quota_modification()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix punch hole for inline_data file systems

Rakesh Pandit <rakesh@tuxera.com>
    ext4: fix warning inside ext4_convert_unwritten_extents_endio

Christophe Kerello <christophe.kerello@st.com>
    mtd: rawnand: stm32_fmc2: avoid warnings when building with W=1 option

Tony Camuso <tcamuso@redhat.com>
    ipmi: move message error checking to avoid deadlock

Jan Kara <jack@suse.cz>
    xfs: Fix stale data exposure when readahead races with hole punch

Jan Kara <jack@suse.cz>
    mm: Handle MADV_WILLNEED through vfs_fadvise()

Jan Kara <jack@suse.cz>
    fs: Export generic_fadvise()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    /dev/mem: Bail out upon SIGKILL.

Denis Kenzior <denkenz@gmail.com>
    cfg80211: Purge frame registrations on iftype change

NeilBrown <neilb@suse.com>
    md: only call set_in_sync() when it is expected to succeed.

NeilBrown <neilb@suse.com>
    md: don't report active array_state until after revalidate_disk() completes.

Xiao Ni <xni@redhat.com>
    md/raid6: Set R5_ReadError when there is read failure on parity disk

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ACPI / LPSS: Save/restore LPSS private registers also on Lynxpoint

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix buffer handling of GSS MIC without slack

Trond Myklebust <trondmy@gmail.com>
    SUNRPC: Dequeue the request from the receive queue while we're re-encoding

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race setting up and completing qgroup rescan workers

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Fix reserved data space leak if we have multiple reserve calls

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Fix the wrong target io_tree when freeing reserved data space

Dennis Zhou <dennis@kernel.org>
    btrfs: adjust dirty_metadata_bytes after writeback failure of extent buffer

Nikolay Borisov <nborisov@suse.com>
    btrfs: Relinquish CPUs in btrfs_compare_trees

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix use-after-free when using the tree modification log

Christophe Leroy <christophe.leroy@c-s.fr>
    btrfs: fix allocation of free space cache v1 bitmap pages

Mark Salyzyn <salyzyn@android.com>
    ovl: filter of trusted xattr results in audit

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ovl: Fix dereferencing possible ERR_PTR()

Steve French <stfrench@microsoft.com>
    smb3: fix leak in "open on server" perf counter

Steve French <stfrench@microsoft.com>
    smb3: allow disabling requesting leases

Yufen Yu <yuyufen@huawei.com>
    block: fix null pointer dereference in blk_mq_rq_timed_out()

Damien Le Moal <damien.lemoal@wdc.com>
    block: mq-deadline: Fix queue restart handling

Stefan Assmann <sassmann@kpanic.de>
    i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: fix channel info parsing for non tlv target

Jian-Hong Pan <jian-hong@endlessm.com>
    rtw88: pci: Use DMA sync instead of remapping in RX ISR

Jian-Hong Pan <jian-hong@endlessm.com>
    rtw88: pci: Rearrange the memory usage for skb in RX ISR

Roberto Sassu <roberto.sassu@huawei.com>
    KEYS: trusted: correctly initialize digests and fix locking issue

Felix Fietkau <nbd@nbd.name>
    mt76: round up length on mt76_wr_copy

Dave Rodgman <dave.rodgman@arm.com>
    lib/lzo/lzo1x_compress.c: fix alignment bug in lzo-rle

Michal Hocko <mhocko@suse.com>
    memcg, kmem: do not fail __GFP_NOFAIL charges

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    memcg, oom: don't require __GFP_FS when invoking memcg OOM killer

Yafang Shao <laoar.shao@gmail.com>
    mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone

Vitaly Wool <vitalywool@gmail.com>
    z3fold: fix memory leak in kmem cache

Vitaly Wool <vitalywool@gmail.com>
    z3fold: fix retry mechanism in page reclaim

Bob Peterson <rpeterso@redhat.com>
    gfs2: clear buf_in_tr when ending a transaction in sweep_bh_for_rgrps

Hans de Goede <hdegoede@redhat.com>
    efifb: BGRT: Improve efifb_bgrt_sanity_check

Mark Brown <broonie@kernel.org>
    regulator: Defer init completion for a while after late_initcall

Nadav Amit <namit@vmware.com>
    iommu/vt-d: Fix wrong analysis whether devices share the same bus

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Will Deacon <will@kernel.org>
    iommu/arm-smmu-v3: Disable detection of ATS and PRI

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328

Will Deacon <will@kernel.org>
    arm64: tlb: Ensure we execute an ISB following walk cache invalidation

Luis Araneda <luaraneda@gmail.com>
    ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Lihua Yao <ylhuajnu@outlook.com>
    ARM: samsung: Fix system restart on S3C6410

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: Fix use of potentially uninitialized variable

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: Skylake: Use correct function to access iomem space

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: NHLT: Fix debug print format

Kees Cook <keescook@chromium.org>
    binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Vladimir Oltean <olteanv@gmail.com>
    spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    spi: ep93xx: Repair SPI CS lookup tables

Arnd Bergmann <arnd@arndb.de>
    media: don't drop front-end reference count for ->detach

Hans de Goede <hdegoede@redhat.com>
    media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videobuf-core.c: poll_wait needs a non-NULL buf pointer

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes

Alexander Graf <graf@amazon.com>
    KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Manually calculate reserved bits when loading PDPTRS

Jan Dakinevich <jan.dakinevich@virtuozzo.com>
    KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jan Dakinevich <jan.dakinevich@virtuozzo.com>
    KVM: x86: always stop emulation on page fault

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel_int0002_vgpio: Fix wakeups not working on Cherry Trail

Helge Deller <deller@gmx.de>
    parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Tejun Heo <tj@kernel.org>
    fuse: fix beyond-end-of-page access in fuse_parse_cache()

Vasily Averin <vvs@virtuozzo.com>
    fuse: fix missing unlock_page in fuse_writepage()

Eric Biggers <ebiggers@google.com>
    fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: Wrap the buffer from the caller to tpm_buf in tpm_send()

Stefan Berger <stefanb@linux.ibm.com>
    tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts

Stefan Berger <stefanb@linux.ibm.com>
    tpm_tis_core: Turn on the TPM before probing IRQ's

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/imc: Dont create debugfs files for cpu-less nodes

Ming Lei <ming.lei@redhat.com>
    scsi: implement .cleanup_rq callback

Ming Lei <ming.lei@redhat.com>
    blk-mq: add callback of .cleanup_rq

Jan-Marek Glogowski <glogow@fbihome.de>
    ALSA: hda/realtek - PCI quirk for Medion E4254

Peter Zijlstra <peterz@infradead.org>
    rcu/tree: Fix SCHED_FIFO params

Adam Ford <aford173@gmail.com>
    ARM: dts: am3517-evm: Fix missing video

Joonwon Kang <kjw1627@gmail.com>
    randstruct: Check member structs in is_pure_ops_struct()

Jack Morgenstein <jackm@dev.mellanox.co.il>
    RDMA: Fix double-free in srq creation error flow

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Do not update hcrc for a KDETH packet during fault injection

Ira Weiny <ira.weiny@intel.com>
    IB/hfi1: Define variables as unsigned long to fix KASAN warning

Danit Goldberg <danitg@mellanox.com>
    IB/mlx5: Free mpi in mp_slave mode

Vincent Whitchurch <vincent.whitchurch@axis.com>
    printk: Do not lose last line in kmsg buffer dump

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag

Martin Wilck <Martin.Wilck@suse.com>
    scsi: scsi_dh_rdac: zero cdb in send_mode_select()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: check intermediate state of clock status and retry

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: handle error code when getting current source of clock

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 36

Adam Ford <aford173@gmail.com>
    ARM: omap2plus_defconfig: Fix missing video

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-baseboard: Fix missing video

MyungJoo Ham <myungjoo.ham@samsung.com>
    PM / devfreq: passive: fix compiler warning

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: omap3isp: Set device on omap3isp subdevs

Jiří Paleček <jpalecek@web.de>
    kvm: Nested KVM MMUs need PAE root too

Qu Wenruo <wqu@suse.com>
    btrfs: Detect unbalanced tree with empty leaf before crashing btree operations

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Add ROOT_ITEM check

Qu Wenruo <wqu@suse.com>
    btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type

Qu Wenruo <wqu@suse.com>
    btrfs: delayed-inode: Kill the BUG_ON() in btrfs_delete_delayed_dir_index()

Oliver Neukum <oneukum@suse.com>
    zd1211rw: remove false assertion from zd_mac_clear()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    iommu/amd: Override wrong IVRS IOAPIC on Raven Ridge systems

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Jani Nikula <jani.nikula@intel.com>
    drm: fix module name in edid_firmware log message

Tomas Bortoli <tomasbortoli@gmail.com>
    media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Ahzo <Ahzo@tutanota.com>
    drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Drop unsol event handler for Intel HDMI codecs

Tomas Espeleta <tomas.espeleta@gmail.com>
    ALSA: hda - Add a quirk model for fixing Huawei Matebook X right speaker

Kai-Heng Feng <kai.heng.feng@canonical.com>
    e1000e: add workaround for possible stalled packet

Kevin Easton <kevin@guarana.org>
    libertas: Add missing sentinel at end of if_usb.c fw_table

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: mtk-sd: Re-store SDIO IRQs mask at system resume

Nigel Croxon <ncroxon@redhat.com>
    raid5: don't increment read_errors on EILSEQ return

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: dw_mmc: Re-store SDIO IRQs mask at system resume

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Add helper function to indicate if SDIO IRQs is enabled

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci: Fix incorrect switch to HS mode

Miles Chen <miles.chen@mediatek.com>
    sched/psi: Correct overly pessimistic size calculation

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHREAD

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    raid5: don't set STRIPE_HANDLE to stripe which is in batch list

Hou Tao <houtao1@huawei.com>
    block: make rq sector size accessible for block stats

Jackie Liu <liuyun01@kylinos.cn>
    io_uring: fix wrong sequence setting logic

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    SoC: simple-card-utils: set 0Hz to sysclk when shutdown

M. Vefa Bicakci <m.v.b@runbox.com>
    platform/x86: intel_pmc_core: Do not ioremap RAM

Gayatri Kammela <gayatri.kammela@intel.com>
    x86/cpu: Add Tiger Lake to Intel family

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding

Christoph Hellwig <hch@lst.de>
    irqchip/sifive-plic: set max threshold for ignored handlers

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix cpumask_of_node() error condition

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Prohibit probing on BUG() and WARN() address

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: ti: edma: Do not reset reserved paRAM slots

Yufen Yu <yuyufen@huawei.com>
    md/raid1: fail run raid1 array when active disk less than one

Wang Shenran <shenran268@gmail.com>
    hwmon: (acpi_power_meter) Change log level for 'unsafe software power cap'

Marcel Bocu <marcel.p.bocu@gmail.com>
    hwmon: (k10temp) Add support for AMD family 17h, model 70h CPUs

Kent Overstreet <kent.overstreet@gmail.com>
    closures: fix a race on wakeup from closure_sync

Wenwen Wang <wenwen@cs.uga.edu>
    ACPI / PCI: fix acpi_pci_irq_enable() memory leak

Wenwen Wang <wenwen@cs.uga.edu>
    ACPI: custom_method: fix memory leaks

Marcel Bocu <marcel.p.bocu@gmail.com>
    x86/amd_nb: Add PCI device IDs for family 17h, model 70h

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks

Tzvetomir Stoyanov <tstoyanov@vmware.com>
    libtraceevent: Change users plugin directory

Eric Dumazet <edumazet@google.com>
    iommu/iova: Avoid false sharing on fq_timer_on

Dan Williams <dan.j.williams@intel.com>
    libata/ahci: Drop PCS quirk for Denverton and beyond

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Haswell: Adjust machine device private context

Qian Cai <cai@lca.pw>
    iommu/amd: Silence warnings under memory pressure

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: add support for MOTU 4pre

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix ana log nsid lookup when nsid is not found

Tom Wu <tomwu@mellanox.com>
    nvmet: fix data units read and written counters in SMART log

Song Liu <songliubraving@fb.com>
    x86/mm/pti: Handle unaligned address gracefully in pti_clone_pagetable()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_ssi: Fix clock control issue in master mode

Thomas Gleixner <tglx@linutronix.de>
    x86/mm/pti: Do not invoke PTI functions when PTI is disabled

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evlist: Use unshare(CLONE_FS) in sb threads to let setns(CLONE_NEWNS) work

Mark Rutland <mark.rutland@arm.com>
    arm64: kpti: ensure patched kernel text is fetched from PoU

Neil Horman <nhorman@tuxdriver.com>
    x86/apic/vector: Warn when vector space exhaustion breaks affinity

Douglas RAILLARD <douglas.raillard@arm.com>
    sched/cpufreq: Align trace event behavior of fast switching

Al Stone <ahs3@redhat.com>
    ACPI / CPPC: do not require the _PSD method

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    ASoC: es8316: fix headphone mixer volume table

Dan Murphy <dmurphy@ti.com>
    leds: lm3532: Fixes for the driver for stability

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: ov9650: add a sanity check

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: aspeed-video: address a protential usage of an unitialized var

Gustavo A. R. Silva <gustavo@embeddedor.com>
    perf script: Fix memory leaks in list_scripts()

Andi Kleen <ak@linux.intel.com>
    perf report: Fix --ns time sort key output

Benjamin Peterson <benjamin@python.org>
    perf trace beauty ioctl: Fix off-by-one error in cmd->string table

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()

Wenwen Wang <wenwen@cs.uga.edu>
    media: cpia2_usb: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    media: saa7146: add cleanup in hexium_attach()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-notifier: clear cec_adap in cec_notifier_unregister

Kamil Konieczny <k.konieczny@partner.samsung.com>
    PM / devfreq: exynos-bus: Correct clock enable sequence

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: passive: Use non-devm notifiers

Masahiro Yamada <yamada.masahiro@socionext.com>
    ARM: OMAP2+: move platform-specific asm-offset.h to arch/arm/mach-omap2

Ezequiel Garcia <ezequiel@collabora.com>
    PM / devfreq: Fix kernel oops on governor module load

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: Enable ARM_ERRATA_754322 for affected Cortex-A9

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: rmobile-sysc: Set GENPD_FLAG_ALWAYS_ON for always-on domain

Masahiro Yamada <yamada.masahiro@socionext.com>
    ARM: at91: move platform-specific asm-offset.h to arch/arm/mach-at91

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Decode syndrome before translating address

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Recognize DRAM device type ECC capability

Gerald BAEZA <gerald.baeza@st.com>
    libperf: Fix alignment trap with xyarray contents in 'perf stat'

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Support more than two controllers for chip selects handling

Wenwen Wang <wenwen@cs.uga.edu>
    media: dvb-core: fix a memory leak bug

Thomas Gleixner <tglx@linutronix.de>
    posix-cpu-timers: Sanitize bogus WARNONS

Sean Young <sean@mess.org>
    media: dvb-frontends: use ida for pll number

A Sun <as1033x@comcast.net>
    media: mceusb: fix (eliminate) TX IR signal length limit

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: provide uninstrumented __strlen

James Morse <james.morse@arm.com>
    arm64: entry: Move ct_user_exit before any other exception

Liguang Zhang <zhangliguang@linux.alibaba.com>
    ACPI / APEI: Release resources if gen_pool_add() fails

Mike Christie <mchristi@redhat.com>
    nbd: add missing config put

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: mchp-i2s-mcc: Fix unprepare of GCLK

Wenwen Wang <wenwen@cs.uga.edu>
    led: triggers: Fix a memory leak bug

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: mchp-i2s-mcc: Wait for RX/TX RDY only if controller is running

Maxime Ripard <maxime.ripard@bootlin.com>
    ASoC: sun4i-i2s: Don't use the oversample to calculate BCLK

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers: Fixup bitsperlong per arch includes

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/Makefile: Always pass --synthetic to nm if supported

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    ASoC: uniphier: Fix double reset assersion when transitioning to suspend state

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: hdpvr: add terminating 0 at end of string

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio/si470x: kill urb on error

Hans de Goede <hdegoede@redhat.com>
    x86/platform/intel/iosf_mbi Rewrite locking

Stefan Agner <stefan.agner@toradex.com>
    ARM: dts: imx7-colibri: disable HS400

André Draszik <git@andred.net>
    ARM: dts: imx7d: cl-som-imx7: make ethernet work again

Finn Thain <fthain@telegraphics.com.au>
    m68k: Prevent some compiler warnings in Coldfire builds

Arnd Bergmann <arnd@arndb.de>
    net: lpc-enet: fix printk format strings

Mark Rutland <mark.rutland@arm.com>
    kasan/arm64: fix CONFIG_KASAN_SW_TAGS && KASAN_INLINE

Ezequiel Garcia <ezequiel@collabora.com>
    media: imx: mipi csi-2: Don't fail if initial state times-out

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: omap3isp: Don't set streaming state on random subdevs

Ezequiel Garcia <ezequiel@collabora.com>
    media: i2c: ov5645: Fix power sequence

Colin Ian King <colin.king@canonical.com>
    media: vsp1: fix memory leak of dl on error return path

Tan Xiaojun <tanxiaojun@huawei.com>
    perf record: Support aarch64 random socket_id assignment

Arnd Bergmann <arnd@arndb.de>
    ARM: xscale: fix multi-cpu compilation

Arnd Bergmann <arnd@arndb.de>
    dmaengine: iop-adma: use correct printk format strings

Darius Rad <alpha@area49.net>
    media: rc: imon: Allow iMON RC protocol for ffdc 7e device

John Keeping <john@metanate.com>
    perf unwind: Fix libunwind when tid != pid

Kees Cook <keescook@chromium.org>
    arm64/efi: Move variable assignments after SECTIONS

Sean Young <sean@mess.org>
    media: em28xx: modules workqueue not inited for 2nd device

Geert Uytterhoeven <geert+renesas@glider.be>
    media: fdp1: Reduce FCP not found message level to debug

Wolfram Sang <wsa+renesas@sang-engineering.com>
    media: i2c: tda1997x: prevent potential NULL pointer access

Matthias Brugger <matthias.bgg@gmail.com>
    media: mtk-mdp: fix reference count on old device tree

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test vfs_getname: Disable ~/.perfconfig to get default output

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf config: Honour $PERF_CONFIG env var to specify alternate .perfconfig

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: zero usb_buf on error

zhengbin <zhengbin13@huawei.com>
    blk-mq: Fix memory leak in blk_mq_init_allocated_queue error handling

Peter Zijlstra <peterz@infradead.org>
    idle: Prevent late-arriving interrupts from disrupting offline

Phil Auld <pauld@redhat.com>
    sched/fair: Use rq_lock/unlock in online_fair_sched_group

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Check if platform has released shmem before using

Xiaofei Tan <tanxiaofei@huawei.com>
    efi: cper: print AER info of PCIe fatal error

Stephen Douthit <stephend@silicom-usa.com>
    EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()

Luke Mujica <lukemujica@google.com>
    perf tools: Fix paths in include statements

Alessio Balsini <balsini@android.com>
    loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Jiri Slaby <jslaby@suse.cz>
    ACPI / processor: don't print errors for processorIDs == 0xff

Keyon Jie <yang.jie@linux.intel.com>
    ASoC: hdac_hda: fix page fault issue by removing race

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    RAS: Build debugfs.o only when enabled in Kconfig

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    RAS: Fix prototype warnings

Randy Dunlap <rdunlap@infradead.org>
    media: media/platform: fsl-viu.c: fix build for MICROBLAZE

Guoqing Jiang <jgq516@gmail.com>
    md: don't set In_sync if array is frozen

Guoqing Jiang <jgq516@gmail.com>
    md: don't call spare_active in md_reap_sync_thread if all member devices can't work

Yufen Yu <yuyufen@huawei.com>
    md/raid1: end bio when the device faulty

Qian Cai <cai@lca.pw>
    arm64/prefetch: fix a -Wtype-limits warning

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't call clk_get_rate() under atomic context

Dan Carpenter <dan.carpenter@oracle.com>
    EDAC/altera: Use the proper type for the IRQ status bits

chenzefeng <chenzefeng2@huawei.com>
    ia64:unwind: fix double free for mod->arch.init_unw_table

Ard van Breemen <ard@kwaak.net>
    ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Vinod Koul <vkoul@kernel.org>
    base: soc: Export soc_device_register/unregister APIs

Neil Armstrong <narmstrong@baylibre.com>
    soc: amlogic: meson-clk-measure: protect measure with a mutex

Junhua Huang <huang.junhua@zte.com.cn>
    arm64: mm: free the initrd reserved memblock in a aligned manner

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: teo: Allow tick to be stopped if PM QoS is used

Oliver Neukum <oneukum@suse.com>
    media: iguanair: add sanity checks

Robert Richter <rrichter@marvell.com>
    EDAC/mc: Fix grain_bits calculation

Jia-Ju Bai <baijiaju1990@gmail.com>
    ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Show the fatal CORB/RIRB error more clearly

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Soft disable APIC before initializing it

Juri Lelli <juri.lelli@redhat.com>
    rcu/tree: Call setschedule() gp ktread to SCHED_FIFO outside of atomic region

Grzegorz Halat <ghalat@redhat.com>
    x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix bandwidth accounting at all levels after offline migration

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Make apic_pending_intr_clear() more robust

Juri Lelli <juri.lelli@redhat.com>
    sched/core: Fix CPU controller for !RT_GROUP_SCHED

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix imbalance due to CPU affinity

Paul E. McKenney <paulmck@linux.ibm.com>
    time/tick-broadcast: Fix tick_broadcast_offline() lockdep complaint

Fabio Estevam <festevam@gmail.com>
    media: i2c: ov5640: Check for devm_gpiod_get_optional() error

Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
    media: hdpvr: Add device num check and handling

Arnd Bergmann <arnd@arndb.de>
    media: vivid: work around high stack usage with clang

Michael Tretter <m.tretter@pengutronix.de>
    media: vb2: reorder checks in vb2_poll()

Vandana BN <bnvandana@gmail.com>
    media: vivid:add sanity check to avoid divide error and set value to 1 if 0.

Wen Yang <wen.yang99@zte.com.cn>
    media: exynos4-is: fix leaked of_node references

Pan Xiuli <xiuli.pan@linux.intel.com>
    ASoC: SOF: pci: mark last_busy value at runtime PM init

Sean Young <sean@mess.org>
    media: mtk-cir: lower de-glitch counter for rc-mm protocol

Arnd Bergmann <arnd@arndb.de>
    media: dib0700: fix link error for dibx000_i2c_set_speed

Nick Stoughton <nstoughton@logitech.com>
    leds: leds-lp5562 allow firmware files up to the maximum length

Stefan Wahren <wahrenst@gmx.net>
    dmaengine: bcm2835: Print error in case setting DMA mask fails

Stephen Boyd <swboyd@chromium.org>
    firmware: qcom_scm: Use proper types for dma mappings

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Fix charge pump source assignment

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Fix of unmute outputs on probe

Lucas Stach <l.stach@pengutronix.de>
    ASoC: tlv320aic31xx: suppress error message for EPROBE_DEFER

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mmio: Clock should be shut when error occurs

Axel Lin <axel.lin@ingics.com>
    regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_vneg

Hariprasad Kelam <hariprasad.kelam@gmail.com>
    cpufreq: ap806: Add NULL check after kcalloc

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: Make hdac_device device-managed

Chris Wilson <chris@chris-wilson.co.uk>
    ALSA: hda: Flush interrupts on disabling

Ori Nimron <orinimron123@gmail.com>
    nfc: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    ieee802154: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    ax25: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    appletalk: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    mISDN: enforce CAP_NET_RAW for raw sockets

Bodong Wang <bodong@mellanox.com>
    net/mlx5: Add device ID of upcoming BlueField-2

Eric Dumazet <edumazet@google.com>
    tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state

Eric Dumazet <edumazet@google.com>
    net: sched: fix possible crash in tcf_action_destroy()

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5e: Fix traffic duplication in ethtool steering

David Ahern <dsahern@gmail.com>
    vrf: Do not attempt to create IPv6 mcast rule if IPv6 is disabled

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: add policy validation for action attributes

David Ahern <dsahern@gmail.com>
    ipv4: Revert removal of rt_uses_gateway

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    net/sched: cbs: Fix not adding cbs instance to list

Hans Andersson <hans.andersson@cellavision.se>
    net: phy: micrel: add Asym Pause workaround for KSZ9021

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity checking of packet sizes and device mtu

Bjørn Mork <bjorn@mork.no>
    usbnet: ignore endpoints with invalid wMaxPacketSize

Kevin(Yudong) Yang <yyd@google.com>
    tcp_bbr: fix quantization code to not raise cwnd if not probing bandwidth

Stephen Hemminger <stephen@networkplumber.org>
    skge: fix checksum byte order

David Ahern <dsahern@gmail.com>
    selftests: Update fib_tests to handle missing ping6

Eric Dumazet <edumazet@google.com>
    sch_netem: fix a divide by zero in tabledist()

Takeshi Misawa <jeliantsurux@gmail.com>
    ppp: Fix memory leak in ppp_write

Li RongQing <lirongqing@baidu.com>
    openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfp: flower: prevent memory leak in nfp_flower_spawn_phy_reprs

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: add max len check for TCA_KIND

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_sample: don't push mac header on ip6gre ingress

Bjorn Andersson <bjorn.andersson@linaro.org>
    net: qrtr: Stop rx_worker before freeing node

Peter Mamonov <pmamonov@gmail.com>
    net/phy: fix DP83865 10 Mbps HDX loopback disable function

Xin Long <lucien.xin@gmail.com>
    macsec: drop skb sk before calling gro_cells_receive

Jason A. Donenfeld <Jason@zx2c4.com>
    ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule

Bjørn Mork <bjorn@mork.no>
    cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    arcnet: provide a buffer big enough to actually receive packets


-------------

Diffstat:

 Documentation/sound/hd-audio/models.rst            |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am3517-evm.dts                   |  23 +-
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   1 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   1 +
 arch/arm/boot/dts/imx7-colibri.dtsi                |   1 +
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts            |   4 +-
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi   |  37 +--
 arch/arm/configs/omap2plus_defconfig               |   1 +
 arch/arm/mach-at91/.gitignore                      |   1 +
 arch/arm/mach-at91/Makefile                        |   5 +-
 arch/arm/mach-at91/pm_suspend.S                    |   2 +-
 arch/arm/mach-ep93xx/edb93xx.c                     |   2 +-
 arch/arm/mach-ep93xx/simone.c                      |   2 +-
 arch/arm/mach-ep93xx/ts72xx.c                      |   4 +-
 arch/arm/mach-ep93xx/vision_ep9307.c               |   2 +-
 arch/arm/mach-omap2/.gitignore                     |   1 +
 arch/arm/mach-omap2/Makefile                       |   5 +-
 arch/arm/mach-omap2/sleep33xx.S                    |   2 +-
 arch/arm/mach-omap2/sleep43xx.S                    |   2 +-
 arch/arm/mach-zynq/platsmp.c                       |   2 +-
 arch/arm/mm/copypage-xscale.c                      |   6 +-
 arch/arm/plat-samsung/watchdog-reset.c             |   1 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   3 +
 arch/arm64/include/asm/cputype.h                   |  21 +-
 arch/arm64/include/asm/exception.h                 |   2 +
 arch/arm64/include/asm/tlbflush.h                  |   1 +
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/entry.S                          |  36 +--
 arch/arm64/kernel/image-vars.h                     |  51 ++++
 arch/arm64/kernel/image.h                          |  42 ---
 arch/arm64/kernel/traps.c                          |   9 +
 arch/arm64/kernel/vmlinux.lds.S                    |   2 +
 arch/arm64/mm/init.c                               |   6 +-
 arch/arm64/mm/proc.S                               |   9 +
 arch/ia64/kernel/module.c                          |   8 +-
 arch/m68k/include/asm/atarihw.h                    |   9 -
 arch/m68k/include/asm/io_mm.h                      |   6 +-
 arch/m68k/include/asm/macintosh.h                  |   1 +
 arch/powerpc/Makefile                              |   2 -
 arch/powerpc/platforms/powernv/opal-imc.c          |  12 +-
 arch/s390/crypto/aes_s390.c                        |   6 +
 arch/s390/include/asm/string.h                     |   9 +-
 arch/x86/include/asm/intel-family.h                |   3 +
 arch/x86/include/asm/kvm_host.h                    |   7 +
 arch/x86/kernel/amd_nb.c                           |   3 +
 arch/x86/kernel/apic/apic.c                        | 115 ++++---
 arch/x86/kernel/apic/vector.c                      |  11 +
 arch/x86/kernel/smp.c                              |  46 +--
 arch/x86/kvm/emulate.c                             |   2 +
 arch/x86/kvm/mmu.c                                 |  47 +--
 arch/x86/kvm/svm.c                                 |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/kvm/x86.c                                 |  21 +-
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/mm/pti.c                                  |   8 +-
 arch/x86/platform/intel/iosf_mbi.c                 | 100 +++---
 block/blk-flush.c                                  |  10 +
 block/blk-mq.c                                     |  25 +-
 block/blk-throttle.c                               |   3 +-
 block/blk.h                                        |   7 +
 block/mq-deadline.c                                |  19 +-
 drivers/acpi/acpi_lpss.c                           |   8 +-
 drivers/acpi/acpi_processor.c                      |  10 +-
 drivers/acpi/apei/ghes.c                           |  17 +-
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/custom_method.c                       |   5 +-
 drivers/acpi/pci_irq.c                             |   4 +-
 drivers/ata/ahci.c                                 | 116 ++++---
 drivers/ata/ahci.h                                 |   2 +
 drivers/base/soc.c                                 |   2 +
 drivers/block/loop.c                               |   1 +
 drivers/block/nbd.c                                |   4 +-
 drivers/char/hw_random/core.c                      |   2 +-
 drivers/char/ipmi/ipmi_msghandler.c                | 114 +++----
 drivers/char/mem.c                                 |  21 ++
 drivers/char/tpm/tpm-interface.c                   |  23 +-
 drivers/char/tpm/tpm_tis_core.c                    |   3 +
 drivers/cpufreq/armada-8k-cpufreq.c                |   2 +
 drivers/cpuidle/governors/teo.c                    |  32 +-
 drivers/devfreq/devfreq.c                          |   2 +-
 drivers/devfreq/exynos-bus.c                       |  31 +-
 drivers/devfreq/governor_passive.c                 |   7 +-
 drivers/dma/bcm2835-dma.c                          |   4 +-
 drivers/dma/iop-adma.c                             |  18 +-
 drivers/dma/ti/edma.c                              |   9 +-
 drivers/edac/altera_edac.c                         |   4 +-
 drivers/edac/amd64_edac.c                          | 151 ++++++----
 drivers/edac/amd64_edac.h                          |   5 +-
 drivers/edac/edac_mc.c                             |   8 +-
 drivers/edac/pnd2_edac.c                           |   7 +-
 drivers/firmware/arm_scmi/driver.c                 |   8 +
 drivers/firmware/efi/cper.c                        |  15 +
 drivers/firmware/qcom_scm.c                        |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   5 +
 drivers/gpu/drm/drm_kms_helper_common.c            |   2 +-
 drivers/hwmon/acpi_power_meter.c                   |   4 +-
 drivers/hwmon/k10temp.c                            |   1 +
 drivers/i2c/busses/i2c-riic.c                      |   1 +
 drivers/infiniband/core/addr.c                     |   2 +-
 drivers/infiniband/core/uverbs_cmd.c               |   3 +-
 drivers/infiniband/hw/hfi1/mad.c                   |  45 ++-
 drivers/infiniband/hw/hfi1/verbs.c                 |  17 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/iommu/Makefile                             |   2 +-
 drivers/iommu/amd_iommu.c                          |   4 +-
 drivers/iommu/amd_iommu.h                          |  14 +
 drivers/iommu/amd_iommu_init.c                     |   5 +-
 drivers/iommu/amd_iommu_quirks.c                   |  92 ++++++
 drivers/iommu/arm-smmu-v3.c                        |   2 +
 drivers/iommu/intel_irq_remapping.c                |   6 +-
 drivers/iommu/iova.c                               |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   9 +-
 drivers/irqchip/irq-sifive-plic.c                  |  12 +-
 drivers/isdn/mISDN/socket.c                        |   2 +
 drivers/leds/led-triggers.c                        |   1 +
 drivers/leds/leds-lm3532.c                         |  17 +-
 drivers/leds/leds-lp5562.c                         |   6 +-
 drivers/md/bcache/closure.c                        |  10 +-
 drivers/md/dm-rq.c                                 |   1 +
 drivers/md/md.c                                    |  28 +-
 drivers/md/md.h                                    |   3 +
 drivers/md/raid0.c                                 |  33 +-
 drivers/md/raid0.h                                 |  14 +
 drivers/md/raid1.c                                 |  39 ++-
 drivers/md/raid5.c                                 |  10 +-
 drivers/media/cec/cec-notifier.c                   |   2 +
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   8 +-
 drivers/media/dvb-core/dvb_frontend.c              |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |   4 +-
 drivers/media/dvb-frontends/dvb-pll.c              |  40 ++-
 drivers/media/i2c/ov5640.c                         |   5 +
 drivers/media/i2c/ov5645.c                         |  26 +-
 drivers/media/i2c/ov9650.c                         |   5 +
 drivers/media/i2c/tda1997x.c                       |   9 +-
 drivers/media/pci/saa7134/saa7134-i2c.c            |  12 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |   3 +
 drivers/media/platform/aspeed-video.c              |   5 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   1 +
 drivers/media/platform/exynos4-is/media-dev.c      |   2 +
 drivers/media/platform/fsl-viu.c                   |   2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |   4 +-
 drivers/media/platform/omap3isp/isp.c              |   8 +
 drivers/media/platform/omap3isp/ispccdc.c          |   1 +
 drivers/media/platform/omap3isp/ispccp2.c          |   1 +
 drivers/media/platform/omap3isp/ispcsi2.c          |   1 +
 drivers/media/platform/omap3isp/isppreview.c       |   1 +
 drivers/media/platform/omap3isp/ispresizer.c       |   1 +
 drivers/media/platform/omap3isp/ispstat.c          |   2 +
 drivers/media/platform/rcar_fdp1.c                 |   2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   9 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |   4 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   5 +-
 drivers/media/rc/iguanair.c                        |  15 +-
 drivers/media/rc/imon.c                            |   7 +-
 drivers/media/rc/mceusb.c                          | 334 ++++++++++++---------
 drivers/media/rc/mtk-cir.c                         |   8 +
 drivers/media/usb/cpia2/cpia2_usb.c                |   4 +
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   8 +
 drivers/media/usb/dvb-usb/pctv452e.c               |   8 -
 drivers/media/usb/em28xx/em28xx-cards.c            |   1 -
 drivers/media/usb/gspca/konica.c                   |   5 +
 drivers/media/usb/gspca/nw80x.c                    |   5 +
 drivers/media/usb/gspca/ov519.c                    |  10 +
 drivers/media/usb/gspca/ov534.c                    |   5 +
 drivers/media/usb/gspca/ov534_9.c                  |   1 +
 drivers/media/usb/gspca/se401.c                    |   5 +
 drivers/media/usb/gspca/sn9c20x.c                  |  12 +
 drivers/media/usb/gspca/sonixb.c                   |   5 +
 drivers/media/usb/gspca/sonixj.c                   |   5 +
 drivers/media/usb/gspca/spca1528.c                 |   5 +
 drivers/media/usb/gspca/sq930x.c                   |   5 +
 drivers/media/usb/gspca/sunplus.c                  |   5 +
 drivers/media/usb/gspca/vc032x.c                   |   5 +
 drivers/media/usb/gspca/w996Xcf.c                  |   5 +
 drivers/media/usb/hdpvr/hdpvr-core.c               |  13 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |   2 +-
 drivers/media/v4l2-core/videobuf-core.c            |   5 +-
 drivers/mmc/core/sdio_irq.c                        |   9 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +
 drivers/mmc/host/mtk-sd.c                          |   3 +
 drivers/mmc/host/sdhci.c                           |   4 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  90 ++----
 drivers/net/arcnet/arcnet.c                        |  31 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  10 +
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +
 drivers/net/ethernet/marvell/skge.c                |   2 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/netronome/nfp/flower/main.c   |   7 +
 drivers/net/ethernet/nxp/lpc_eth.c                 |  13 +-
 drivers/net/macsec.c                               |   1 +
 drivers/net/phy/micrel.c                           |   3 +
 drivers/net/phy/national.c                         |   9 +-
 drivers/net/ppp/ppp_generic.c                      |   2 +
 drivers/net/usb/cdc_ncm.c                          |   6 +-
 drivers/net/usb/usbnet.c                           |   8 +
 drivers/net/vrf.c                                  |   3 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  16 +
 drivers/net/wireless/ath/ath10k/wmi.h              |   8 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   8 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   3 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   6 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   2 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  71 +++--
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   1 -
 drivers/nvme/host/multipath.c                      |   8 +-
 drivers/nvme/target/admin-cmd.c                    |  14 +-
 drivers/parisc/dino.c                              |  24 ++
 drivers/platform/chrome/cros_ec_rpmsg.c            |  32 +-
 drivers/platform/x86/intel_int0002_vgpio.c         |   1 +
 drivers/platform/x86/intel_pmc_core.c              |   8 +-
 drivers/ras/Makefile                               |   3 +-
 drivers/ras/cec.c                                  |   1 +
 drivers/ras/debugfs.c                              |   2 +
 drivers/regulator/core.c                           |  42 ++-
 drivers/regulator/lm363x-regulator.c               |   2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   2 +
 drivers/scsi/qla2xxx/qla_init.c                    |  25 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   1 +
 drivers/scsi/qla2xxx/qla_target.c                  |   1 -
 drivers/scsi/scsi_lib.c                            |  13 +
 drivers/soc/amlogic/meson-clk-measure.c            |  12 +-
 drivers/soc/renesas/Kconfig                        |   5 +
 drivers/soc/renesas/rmobile-sysc.c                 |  31 +-
 drivers/spi/spi-dw-mmio.c                          |   6 +-
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  12 +-
 drivers/video/fbdev/efifb.c                        |  27 +-
 fs/binfmt_elf.c                                    |   3 +-
 fs/btrfs/ctree.c                                   |   5 +-
 fs/btrfs/ctree.h                                   |   1 +
 fs/btrfs/delayed-inode.c                           |  13 +-
 fs/btrfs/disk-io.c                                 |  10 +
 fs/btrfs/extent-tree.c                             |   8 +
 fs/btrfs/extent_io.c                               |   9 +
 fs/btrfs/free-space-cache.c                        |  20 +-
 fs/btrfs/inode.c                                   |   8 +
 fs/btrfs/qgroup.c                                  |  38 ++-
 fs/btrfs/tree-checker.c                            |  98 ++++++
 fs/cifs/cifsfs.c                                   |   2 +
 fs/cifs/cifsglob.h                                 |   2 +
 fs/cifs/connect.c                                  |   9 +-
 fs/cifs/smb2ops.c                                  |  10 +
 fs/cifs/smb2pdu.c                                  |   3 +-
 fs/cifs/xattr.c                                    |   2 +-
 fs/ext4/extents.c                                  |   4 +-
 fs/ext4/inode.c                                    |   9 +
 fs/fuse/dev.c                                      |  93 +++---
 fs/fuse/file.c                                     |   1 +
 fs/fuse/fuse_i.h                                   |   3 +
 fs/fuse/inode.c                                    |   1 +
 fs/fuse/readdir.c                                  |   4 +-
 fs/gfs2/bmap.c                                     |   1 +
 fs/io_uring.c                                      |   4 +-
 fs/overlayfs/export.c                              |   3 +-
 fs/overlayfs/inode.c                               |   3 +-
 fs/xfs/xfs_file.c                                  |  26 ++
 include/linux/blk-mq.h                             |  13 +
 include/linux/blkdev.h                             |  15 +-
 include/linux/bug.h                                |   5 +
 include/linux/fs.h                                 |   2 +
 include/linux/mmc/host.h                           |   9 +
 include/linux/pci_ids.h                            |   1 +
 include/linux/quotaops.h                           |   2 +-
 include/linux/sunrpc/xprt.h                        |   1 +
 include/net/route.h                                |   3 +-
 kernel/kprobes.c                                   |   3 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/rcu/tree.c                                  |   6 +-
 kernel/sched/core.c                                |  61 +++-
 kernel/sched/cpufreq_schedutil.c                   |   7 +-
 kernel/sched/deadline.c                            |  33 ++
 kernel/sched/fair.c                                |  11 +-
 kernel/sched/idle.c                                |   5 +-
 kernel/sched/psi.c                                 |   2 +-
 kernel/time/alarmtimer.c                           |   4 +-
 kernel/time/posix-cpu-timers.c                     |  20 +-
 lib/lzo/lzo1x_compress.c                           |  14 +-
 mm/compaction.c                                    |  35 +--
 mm/fadvise.c                                       |   4 +-
 mm/madvise.c                                       |  22 +-
 mm/memcontrol.c                                    |  10 +
 mm/oom_kill.c                                      |   5 +-
 mm/z3fold.c                                        |  64 ++--
 net/appletalk/ddp.c                                |   5 +
 net/ax25/af_ax25.c                                 |   2 +
 net/ieee802154/socket.c                            |   3 +
 net/ipv4/inet_connection_sock.c                    |   4 +-
 net/ipv4/ip_forward.c                              |   2 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/route.c                                   |  34 ++-
 net/ipv4/tcp_bbr.c                                 |   8 +-
 net/ipv4/tcp_timer.c                               |   5 +-
 net/ipv4/xfrm4_policy.c                            |   1 +
 net/ipv6/fib6_rules.c                              |   3 +-
 net/nfc/llcp_sock.c                                |   7 +-
 net/openvswitch/datapath.c                         |   2 +-
 net/qrtr/qrtr.c                                    |   1 +
 net/sched/act_api.c                                |  34 ++-
 net/sched/act_sample.c                             |   1 +
 net/sched/cls_api.c                                |   6 +-
 net/sched/sch_api.c                                |   3 +-
 net/sched/sch_cbs.c                                |  30 +-
 net/sched/sch_netem.c                              |   2 +-
 net/sunrpc/clnt.c                                  |   6 +-
 net/sunrpc/xdr.c                                   |  27 +-
 net/sunrpc/xprt.c                                  |  54 ++--
 net/wireless/util.c                                |   1 +
 scripts/Makefile.kasan                             |  11 +-
 scripts/gcc-plugins/randomize_layout_plugin.c      |  10 +-
 security/keys/trusted.c                            |   5 +
 sound/firewire/motu/motu.c                         |  12 +
 sound/firewire/tascam/tascam-pcm.c                 |   3 +
 sound/firewire/tascam/tascam-stream.c              |  42 ++-
 sound/hda/hdac_controller.c                        |   2 +
 sound/i2c/other/ak4xxx-adda.c                      |   7 +-
 sound/pci/hda/hda_codec.c                          |   8 +-
 sound/pci/hda/hda_controller.c                     |   5 +-
 sound/pci/hda/hda_intel.c                          |   2 +-
 sound/pci/hda/patch_hdmi.c                         |   9 +-
 sound/pci/hda/patch_realtek.c                      |  90 ++++++
 sound/soc/atmel/mchp-i2s-mcc.c                     |  41 ++-
 sound/soc/codecs/es8316.c                          |   7 +-
 sound/soc/codecs/hdac_hda.c                        |   4 +
 sound/soc/codecs/sgtl5000.c                        |  21 +-
 sound/soc/codecs/tlv320aic31xx.c                   |   7 +-
 sound/soc/fsl/fsl_ssi.c                            |  18 +-
 sound/soc/generic/simple-card-utils.c              |   7 +
 sound/soc/intel/common/sst-acpi.c                  |   3 +-
 sound/soc/intel/common/sst-ipc.c                   |   2 +
 sound/soc/intel/skylake/skl-debug.c                |   2 +-
 sound/soc/intel/skylake/skl-nhlt.c                 |   2 +-
 sound/soc/sh/rcar/adg.c                            |  21 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |   6 +
 sound/soc/sof/intel/hda-codec.c                    |   6 +-
 sound/soc/sof/sof-pci-dev.c                        |   3 +
 sound/soc/sunxi/sun4i-i2s.c                        |   9 +-
 sound/soc/uniphier/aio-cpu.c                       |  31 +-
 sound/soc/uniphier/aio.h                           |   1 +
 sound/usb/pcm.c                                    |   1 +
 tools/include/uapi/asm/bitsperlong.h               |  18 +-
 tools/lib/traceevent/Makefile                      |   6 +-
 tools/lib/traceevent/event-plugin.c                |   2 +-
 tools/perf/arch/x86/util/kvm-stat.c                |   4 +-
 tools/perf/arch/x86/util/tsc.c                     |   6 +-
 tools/perf/perf.c                                  |   3 +
 tools/perf/tests/shell/trace+probe_vfs_getname.sh  |   4 +
 tools/perf/trace/beauty/ioctl.c                    |   2 +-
 tools/perf/ui/browsers/scripts.c                   |   6 +-
 tools/perf/ui/helpline.c                           |   4 +-
 tools/perf/ui/util.c                               |   2 +-
 tools/perf/util/evlist.c                           |   9 +
 tools/perf/util/header.c                           |   4 +-
 tools/perf/util/hist.c                             |   5 +-
 tools/perf/util/map.c                              |   3 +-
 tools/perf/util/map_groups.h                       |   4 +
 tools/perf/util/thread.c                           |   7 +-
 tools/perf/util/thread.h                           |   4 -
 tools/perf/util/unwind-libunwind-local.c           |  18 +-
 tools/perf/util/unwind-libunwind.c                 |  34 +--
 tools/perf/util/unwind.h                           |  25 +-
 tools/perf/util/xyarray.h                          |   3 +-
 tools/testing/selftests/net/fib_tests.sh           |  21 +-
 369 files changed, 3159 insertions(+), 1539 deletions(-)


