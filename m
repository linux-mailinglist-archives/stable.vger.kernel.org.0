Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792901ACCA7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636679AbgDPQD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895219AbgDPN0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:26:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AFF5217D8;
        Thu, 16 Apr 2020 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043566;
        bh=dKa+r2KWcHa6BDT+slfBcXSEGnIFz880ggYbFzSaTKM=;
        h=From:To:Cc:Subject:Date:From;
        b=eBOdmsvpASOfvT/ayvtEDjIFheVJosuApMO7GNA+NW0UzbISYcRzIEZe4Xv0+T7Ok
         jz54XSp0kKJkPoMJxydL7itpvsCWruiXDDotFYzan7apiO4rWdneudjerdMKUMabrI
         BAoY403SdOcnuLrSLjtcQIMKdoceMmN1rwca7fNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/146] 4.19.116-rc1 review
Date:   Thu, 16 Apr 2020 15:22:21 +0200
Message-Id: <20200416131242.353444678@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.116-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.116-rc1
X-KernelTest-Deadline: 2020-04-18T13:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.116 release.
There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.116-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.116-rc1

Christian Gmeiner <christian.gmeiner@gmail.com>
    etnaviv: perfmon: fix total and idle HI cyleces readout

Nathan Chancellor <natechancellor@gmail.com>
    misc: echo: Remove unnecessary parentheses and simplify check for zero

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Masami Hiramatsu <mhiramat@kernel.org>
    ftrace/kprobe: Show the maxactive number on kprobe_events

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Remove PageReserved manipulation from drm_pci_alloc

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Fix clearing payload state on topology disable

Sasha Levin <sashal@kernel.org>
    Revert "drm/dp_mst: Remove VCPI while disabling topology mgr"

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - only try to map auth tag if needed

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - dec auth tag size from cryptlen map

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - don't mangle the request assoclen

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - zero out internal struct before use

Hadar Gat <hadar.gat@arm.com>
    crypto: ccree - improve error handling

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam - update xts sector size for large input length

Bob Liu <bob.liu@oracle.com>
    dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Josef Bacik <josef@toxicpanda.com>
    btrfs: use nofs allocations for running delayed items

Clement Courbet <courbet@google.com>
    powerpc: Make setjmp/longjmp signature standard

Segher Boessenkool <segher@kernel.crashing.org>
    powerpc: Add attributes for setjmp/longjmp

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kprobes: Ignore traps that happened in real mode

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configured IPIs

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devmap PTE entries

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv/idle: Restore AMR/UAMOR/AMOR after idle

Juergen Gross <jgross@suse.com>
    xen/blkfront: fix memory allocation flags in blkfront_setup_indirect()

Wen Yang <wenyang@linux.alibaba.com>
    ipmi: fix hung processes in __get_guid()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DFLAG_DETACH is set

Simon Gander <simon@tuxera.com>
    hfsplus: fix crash and filesystem corruption when deleting files

Oliver O'Halloran <oohall@gmail.com>
    cpufreq: powernv: Fix use-after-free

Eric Biggers <ebiggers@google.com>
    kmod: make request_module() return an error when autoloading is disabled

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic/jz4770: Exit with error if CGU init failed

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add Acer Aspire 5738z to nomux list

Michael Mueller <mimu@linux.ibm.com>
    s390/diag: fix display of diagnose call statistics

Sam Lunt <samueljlunt@gmail.com>
    perf tools: Support Python 3.8+ in Makefile

Changwei Ge <chge@linux.alibaba.com>
    ocfs2: no need try to truncate file beyond i_size

Eric Biggers <ebiggers@google.com>
    fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()

Qian Cai <cai@lca.pw>
    ext4: fix a data race at inode->i_blocks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()

Libor Pechacek <lpechacek@suse.cz>
    powerpc/pseries: Avoid NULL pointer dereference when drmem is unavailable

Christian Gmeiner <christian.gmeiner@gmail.com>
    drm/etnaviv: rework perfmon query infrastructure

Nathan Chancellor <natechancellor@gmail.com>
    rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH

Michal Hocko <mhocko@suse.com>
    selftests: vm: drop dependencies on page flags from mlock2 tests

Fredrik Strupe <fredrik@strupe.net>
    arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point

Shetty, Harshini X (EXT-Sony Mobile) <Harshini.X.Shetty@sony.com>
    dm verity fec: fix memory leak in verity_fec_dtr

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: add cond_resched to avoid CPU hangs

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: h6: Fix PMU compatible

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: qualcomm: rmnet: Allow configuration updates to existing devices

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    mm: Use fixed constant in page_frag_alloc instead of size + 1

Anssi Hannula <anssi.hannula@bitwise.fi>
    tools: gpio: Fix out-of-tree build regression

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86/speculation: Remove redundant arch_smt_update() invocation

YueHaibing <yuehaibing@huawei.com>
    powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()

Gao Xiang <gaoxiang25@huawei.com>
    erofs: correct the remaining shrink objects

Rosioru Dragos <dragos.rosioru@nxp.com>
    crypto: mxs-dcp - fix scatterlist linearization for hash

Robbie Ko <robbieko@synology.com>
    btrfs: fix missing semaphore unlock in btrfs_sync_file

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing file extent item for hole after ranged fsync

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop block from cache on error in relocation

Josef Bacik <josef@toxicpanda.com>
    btrfs: set update the uuid generation as soon as possible

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix crash during unmount due to race with delayed inode workers

Frieder Schrempf <frieder.schrempf@kontron.de>
    mtd: spinand: Do not erase the block before writing a bad block marker

Frieder Schrempf <frieder.schrempf@kontron.de>
    mtd: spinand: Stop using spinand->oobbuf for buffering bad block markers

Yilu Lin <linyilu@huawei.com>
    CIFS: Fix bug which the return value by asynchronous read is error

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: VMX: fix crash cleanup when KVM wasn't used

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Gracefully handle __vmalloc() failure during VM allocation

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Allocate new rmap and large page tracking when moving memslot

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix delivery of addressing exceptions

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Properly handle userspace interrupt window request

Thomas Gleixner <tglx@linutronix.de>
    x86/entry/32: Add missing ASM_CLAC to general_protection entry

Eric W. Biederman <ebiederm@xmission.com>
    signal: Extend exec_id to 64bits

Remi Pommarel <repk@triplefau.lt>
    ath9k: Handle txpower changes even when TPC is disabled

Gustavo A. R. Silva <gustavo@embeddedor.com>
    MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Huacai Chen <chenhc@lemote.com>
    MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3

Vasily Averin <vvs@virtuozzo.com>
    pstore: pstore_ftrace_seq_next should increase position index

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Apply clear-mask earlier

Yang Xu <xuyang2018.jy@cn.fujitsu.com>
    KEYS: reaching the keys quotas correctly

Vasily Averin <vvs@virtuozzo.com>
    tpm: tpm2_bios_measurements_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    tpm: tpm1_bios_measurements_next should increase position index

Matthew Garrett <matthewgarrett@google.com>
    tpm: Don't make log failures fatal

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: endpoint: Fix for concurrent memory allocation in OB address region

Sean V Kelley <sean.v.kelley@linux.intel.com>
    PCI: Add boot interrupt quirk mechanism for Xeon chipsets

Yicong Yang <yangyicong@hisilicon.com>
    PCI/ASPM: Clear the correct bits when enabling L1 substates

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix indefinite wait on sysfs requests

James Smart <jsmart2021@gmail.com>
    nvme: Treat discovery subsystems as unique subsystems

James Smart <jsmart2021@gmail.com>
    nvme-fc: Revert "add module to ops template to allow module references"

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=n

Jan Engelhardt <jengelh@inai.de>
    acpi/x86: ignore unspecified bit positions in the ACPI global lock field

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: cal: fix disable_irqs to only the intended target

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Add quirk for MSI GL63

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: hda/realtek - Remove now-unnecessary XPS 13 headphone noise fixups

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: hda/realtek - Set principled PC Beep configuration for ALC256

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix regression by buffer overflow fix

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix invalid access for enumerated ctl items

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential access overflow in beep helper

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add driver blacklist

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add mixer workaround for TRX40 and co

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: composite: Inform controller driver of self-powered

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: gadget: f_fs: Fix use after free issue as part of queue failure

이경택 <gt82.lee@samsung.com>
    ASoC: topology: use name_prefix for new kcontrol

이경택 <gt82.lee@samsung.com>
    ASoC: dpcm: allow start or stop during pause for backend

이경택 <gt82.lee@samsung.com>
    ASoC: dapm: connect virtual mux with default value

이경택 <gt82.lee@samsung.com>
    ASoC: fix regwmask

Kees Cook <keescook@chromium.org>
    slub: improve bit diffusion for freelist ptr obfuscation

Yury Norov <yury.norov@gmail.com>
    uapi: rename ext2_swab() to swab() and share globally in swab.h

Alex Vesker <valex@mellanox.com>
    IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads

Josef Bacik <josef@toxicpanda.com>
    btrfs: track reloc roots based on their commit root bytenr

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove a BUG_ON() from merge_reloc_roots()

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: ensure qgroup_rescan_running is only set when the worker is at least queued

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    block, bfq: fix use-after-free in bfq_idle_slice_timer_body

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()

Junyong Sun <sunjy516@gmail.com>
    firmware: fix a double abort case with fw_load_sysfs_fallback

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: check arrays is suspended in mddev_detach before call quiesce operations

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Provide irq_retrigger to avoid circular locking dependency

Neil Armstrong <narmstrong@baylibre.com>
    usb: dwc3: core: add support for disabling SS instances in park mode

Dongchun Zhu <dongchun.zhu@mediatek.com>
    media: i2c: ov5695: Fix power on and off sequences

Sahitya Tummala <stummala@codeaurora.org>
    block: Fix use-after-free issue accessing struct io_cq

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Ignore the memory attributes table on i386

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Use unsigned comparison for addresses

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't demote a glock until its revokes are written

chenqiwu <chenqiwu@xiaomi.com>
    pstore/platform: fix potential mem leak if pstore_init_fs failed

John Garry <john.garry@huawei.com>
    libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Matt Ranostay <matt.ranostay@konsulko.com>
    media: i2c: video-i2c: fix build errors due to 'imply hwmon'

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Fix init_completion race condition with poll_wait()

Andy Lutomirski <luto@kernel.org>
    selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Michael Wang <yun.wang@linux.alibaba.com>
    sched: Avoid scale real weight down to zero

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Handle chained IRQs properly

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    block: keep bdi->io_pages in sync with max_sectors_kb for stacked devices

Thomas Hellstrom <thellstrom@vmware.com>
    x86: Don't let pgprot_modify() change the page encryption bit

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: bail out early if driver can't accress host in resume

Alexey Dobriyan <adobriyan@gmail.com>
    null_blk: fix spurious IO errors after failed past-wp access

Bart Van Assche <bvanassche@acm.org>
    null_blk: Handle null_add_dev() failures properly

Bart Van Assche <bvanassche@acm.org>
    null_blk: Fix the null_add_dev() error path

James Morse <james.morse@arm.com>
    firmware: arm_sdei: fix double-lock on hibernate with shared events

Stephan Gerhold <stephan@gerhold.net>
    media: venus: hfi_parser: Ignore HEVC encoding for V1

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL

Alain Volmat <avolmat@me.com>
    i2c: st: fix missing struct parameter description

Xu Wang <vulab@iscas.ac.cn>
    qlcnic: Fix bad kzalloc null test

Raju Rangoju <rajur@chelsio.com>
    cxgb4/ptp: pass the sign of offset delta in FW CMD

Luo bin <luobin9@huawei.com>
    hinic: fix wrong para of wait_for_completion_timeout

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of waitting for IO stopped

Zheng Wei <wei.zheng@vivo.com>
    net: vxge: fix wrong __VA_ARGS__ usage

David Howells <dhowells@redhat.com>
    rxrpc: Abstract out the calculation of whether there's Tx space

Ondrej Jirman <megous@megous.com>
    bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads

Ondrej Jirman <megous@megous.com>
    ARM: dts: sun8i-a83t-tbs-a711: HM5065 doesn't like such a high voltage


-------------

Diffstat:

 Documentation/sound/hd-audio/index.rst             |   1 +
 Documentation/sound/hd-audio/models.rst            |   2 -
 Documentation/sound/hd-audio/realtek-pc-beep.rst   | 129 ++++++++++++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts          |   4 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |   3 +-
 arch/arm64/kernel/armv8_deprecated.c               |   2 +-
 arch/mips/cavium-octeon/octeon-irq.c               |   3 +
 arch/mips/mm/tlbex.c                               |   5 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |   6 +
 arch/powerpc/include/asm/book3s/64/hash-64k.h      |   8 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   4 +-
 arch/powerpc/include/asm/book3s/64/radix.h         |   5 +
 arch/powerpc/include/asm/drmem.h                   |   4 +-
 arch/powerpc/include/asm/setjmp.h                  |   6 +-
 arch/powerpc/kernel/Makefile                       |   3 -
 arch/powerpc/kernel/idle_book3s.S                  |  27 ++-
 arch/powerpc/kernel/kprobes.c                      |   3 +
 arch/powerpc/kernel/signal_64.c                    |   4 +-
 arch/powerpc/mm/tlb_nohash_low.S                   |  12 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   8 +-
 arch/powerpc/platforms/pseries/lpar.c              |   2 +-
 arch/powerpc/sysdev/xive/common.c                  |  12 +-
 arch/powerpc/sysdev/xive/native.c                  |   4 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   4 +-
 arch/powerpc/sysdev/xive/xive-internal.h           |   7 +
 arch/powerpc/xmon/Makefile                         |   3 -
 arch/s390/kernel/diag.c                            |   2 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/s390/mm/gmap.c                                |   6 +-
 arch/x86/boot/compressed/head_32.S                 |   2 +-
 arch/x86/boot/compressed/head_64.S                 |   4 +-
 arch/x86/entry/entry_32.S                          |   1 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/pgtable.h                     |   7 +-
 arch/x86/include/asm/pgtable_types.h               |   2 +-
 arch/x86/kernel/acpi/boot.c                        |   2 +-
 arch/x86/kvm/svm.c                                 |   4 +
 arch/x86/kvm/vmx.c                                 | 110 ++++------
 arch/x86/kvm/x86.c                                 |  21 +-
 block/bfq-iosched.c                                |  16 +-
 block/blk-ioc.c                                    |   7 +
 block/blk-settings.c                               |   3 +
 drivers/ata/libata-pmp.c                           |   1 +
 drivers/ata/libata-scsi.c                          |   9 +-
 drivers/base/firmware_loader/fallback.c            |   2 +-
 drivers/block/null_blk_main.c                      |  10 +-
 drivers/block/xen-blkfront.c                       |  17 +-
 drivers/bus/sunxi-rsb.c                            |   2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/tpm/eventlog/common.c                 |  12 +-
 drivers/char/tpm/eventlog/tpm1.c                   |   2 +-
 drivers/char/tpm/eventlog/tpm2.c                   |   2 +-
 drivers/char/tpm/tpm-chip.c                        |   4 +-
 drivers/char/tpm/tpm.h                             |   2 +-
 drivers/clk/ingenic/jz4770-cgu.c                   |   4 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   3 +
 drivers/cpufreq/powernv-cpufreq.c                  |   6 +
 drivers/crypto/caam/caamalg_desc.c                 |  16 +-
 drivers/crypto/ccree/cc_aead.c                     |  56 +++--
 drivers/crypto/ccree/cc_aead.h                     |   1 +
 drivers/crypto/ccree/cc_buffer_mgr.c               | 108 +++++-----
 drivers/crypto/mxs-dcp.c                           |  58 +++--
 drivers/firmware/arm_sdei.c                        |  32 ++-
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  19 +-
 drivers/gpu/drm/drm_pci.c                          |  25 +--
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c          | 103 +++++++--
 drivers/i2c/busses/i2c-st.c                        |   1 +
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/input/serio/i8042-x86ia64io.h              |  11 +
 drivers/irqchip/irq-gic-v3-its.c                   |   6 +
 drivers/irqchip/irq-versatile-fpga.c               |  18 +-
 drivers/md/dm-verity-fec.c                         |   1 +
 drivers/md/dm-writecache.c                         |   6 +-
 drivers/md/dm-zoned-metadata.c                     |   1 -
 drivers/md/md.c                                    |   2 +-
 drivers/media/i2c/ov5695.c                         |  49 +++--
 drivers/media/i2c/video-i2c.c                      |   2 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   1 +
 drivers/media/platform/ti-vpe/cal.c                |  16 +-
 drivers/misc/echo/echo.c                           |   2 +-
 drivers/mtd/nand/spi/core.c                        |  17 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |   3 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |   3 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |  51 +----
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |   5 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h   |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h     |  14 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |  31 +--
 drivers/net/wireless/ath/ath9k/main.c              |   3 +
 drivers/nvme/host/core.c                           |  11 +
 drivers/nvme/host/fc.c                             |  14 +-
 drivers/nvme/target/fcloop.c                       |   1 -
 drivers/pci/endpoint/pci-epc-mem.c                 |  10 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  14 +-
 drivers/pci/pcie/aspm.c                            |   4 +-
 drivers/pci/quirks.c                               |  80 ++++++-
 drivers/pci/switch/switchtec.c                     |   2 +-
 drivers/rtc/rtc-omap.c                             |   4 +-
 drivers/s390/scsi/zfcp_erp.c                       |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   8 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   1 -
 drivers/staging/erofs/utils.c                      |   2 +-
 drivers/usb/dwc3/core.c                            |   5 +
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/gadget/composite.c                     |   9 +
 drivers/usb/gadget/function/f_fs.c                 |   1 +
 drivers/usb/host/xhci.c                            |   4 +-
 fs/btrfs/async-thread.c                            |   8 +
 fs/btrfs/async-thread.h                            |   1 +
 fs/btrfs/delayed-inode.c                           |  13 ++
 fs/btrfs/disk-io.c                                 |  27 ++-
 fs/btrfs/file.c                                    |  11 +
 fs/btrfs/qgroup.c                                  |  11 +-
 fs/btrfs/relocation.c                              |  35 ++--
 fs/cifs/file.c                                     |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/filesystems.c                                   |   4 +-
 fs/gfs2/glock.c                                    |   3 +
 fs/hfsplus/attributes.c                            |   4 +
 fs/nfs/write.c                                     |   1 +
 fs/ocfs2/alloc.c                                   |   4 +
 fs/pstore/inode.c                                  |   5 +-
 fs/pstore/platform.c                               |   4 +-
 include/linux/devfreq_cooling.h                    |   2 +-
 include/linux/iocontext.h                          |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   9 +-
 include/linux/nvme-fc-driver.h                     |   4 -
 include/linux/pci-epc.h                            |   3 +
 include/linux/sched.h                              |   4 +-
 include/linux/swab.h                               |   1 +
 include/uapi/linux/swab.h                          |  10 +
 kernel/cpu.c                                       |   5 +-
 kernel/irq/irqdomain.c                             |  10 +-
 kernel/kmod.c                                      |   4 +-
 kernel/locking/lockdep.c                           |   4 +
 kernel/sched/sched.h                               |   8 +-
 kernel/signal.c                                    |   2 +-
 kernel/trace/trace_kprobe.c                        |   2 +
 lib/find_bit.c                                     |  16 +-
 mm/page_alloc.c                                    |   8 +-
 mm/slub.c                                          |   2 +-
 net/rxrpc/sendmsg.c                                |  27 ++-
 security/keys/key.c                                |   2 +-
 security/keys/keyctl.c                             |   4 +-
 sound/core/oss/pcm_plugin.c                        |  32 ++-
 sound/pci/hda/hda_beep.c                           |   6 +-
 sound/pci/hda/hda_intel.c                          |  16 ++
 sound/pci/hda/patch_realtek.c                      |  50 +----
 sound/pci/ice1712/prodigy_hifi.c                   |   4 +-
 sound/soc/soc-dapm.c                               |   8 +-
 sound/soc/soc-ops.c                                |   4 +-
 sound/soc/soc-pcm.c                                |   6 +-
 sound/soc/soc-topology.c                           |   2 +-
 sound/usb/mixer_maps.c                             |  28 +++
 tools/gpio/Makefile                                |   2 +-
 tools/perf/Makefile.config                         |  11 +-
 tools/testing/selftests/vm/mlock2-tests.c          | 233 ++++-----------------
 tools/testing/selftests/x86/ptrace_syscall.c       |   8 +-
 163 files changed, 1231 insertions(+), 840 deletions(-)


