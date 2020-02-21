Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5E016706D
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgBUHpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:45:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgBUHpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:45:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB82207FD;
        Fri, 21 Feb 2020 07:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271097;
        bh=79fULYoRHbFop/cgqBaLVn1p36W0xUEmTbTEAghrz2I=;
        h=From:To:Cc:Subject:Date:From;
        b=JmPPFUc1kISTvA/wYnMz7dHZGkSFtSCWHEeUXnUnlWPktvrFf9kgtb4hMQkOjZPD1
         XnYyC0rvNvAcJH5365QDatmTc1gKYQ4vKlS7jWjGCJAnABVRhfo8grvQiZ3yGMDlPP
         4Y5H9QKQMZTZbobQgdcqQYhEgkTe0n8hsg2JjAGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 000/399] 5.5.6-stable review
Date:   Fri, 21 Feb 2020 08:35:25 +0100
Message-Id: <20200221072402.315346745@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.6-rc1
X-KernelTest-Deadline: 2020-02-23T07:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.6 release.
There are 399 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.6-rc1

Coly Li <colyli@suse.de>
    bcache: properly initialize 'path' and 'err' in register_bcache()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (v2)

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Recover handle in clp_set_pci_fn()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_dpipe: Add missing error path

Vadim Pasternak <vadimp@mellanox.com>
    mlxsw: core: Add validation of hardware device types for MGPIR register

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't overflow LLONG_MAX with end offset

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: prevent pfn array overflow

Steve French <stfrench@microsoft.com>
    cifs: log warning message (once) if out of disk space

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: make multiple directory targets work

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: Relax i40e_xsk_wakeup's return value when PF is busy

Vasily Averin <vvs@virtuozzo.com>
    help_next should increase position index

Wenwen Wang <wenwen@cs.uga.edu>
    NFS: Fix memory leaks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    brd: check and limit max_part par

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    microblaze: Prevent the overflow of the start

Davide Caratti <dcaratti@redhat.com>
    tc-testing: add missing 'nsPlugin' to basic.json

Peter Zijlstra <peterz@infradead.org>
    asm-generic/tlb: add missing CONFIG symbol

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Check the sta is not NULL in iwl_mvm_cfg_he_sta()

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Fix thermal zone registration

Christoph Hellwig <hch@lst.de>
    nvme-pci: remove nvmeq->tags

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix dsm failure when payload does not match sgl descriptor

Amol Grover <frextrite@gmail.com>
    nvmet: Pass lockdep expression to RCU lists

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when building INVALL

Coly Li <colyli@suse.de>
    bcache: fix incorrect data type usage in btree_flush_write()

Coly Li <colyli@suse.de>
    bcache: explicity type cast in bset_bkey_last()

Coly Li <colyli@suse.de>
    bcache: fix memory corruption in bch_cache_accounting_clear()

Yunfeng Ye <yeyunfeng@huawei.com>
    reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Nathan Chancellor <natechancellor@gmail.com>
    lib/scatterlist.c: adjust indentation in __sg_alloc_table

wangyan <wangyan122@huawei.com>
    ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fsync_trans()

Masahiro Yamada <masahiroy@kernel.org>
    ocfs2: make local header paths relative to C files

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix now invalid var_ref_vals assumption in trace action

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not do delalloc reservation under page lock

Alexandre Ghiti <alex@ghiti.fr>
    powerpc: Do not consider weak unresolved symbol relocations as bad

Daniel Vetter <daniel.vetter@ffwll.ch>
    radeon: insert 10ms sleep in dce5_crtc_load_lut

Vasily Averin <vvs@virtuozzo.com>
    trigger_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    ftrace: fpid_next() should increase position index

Gustavo A. R. Silva <gustavo@embeddedor.com>
    char: hpet: Fix out-of-bounds read bug

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/disp/nv50-: prevent oops when no channel method map provided

Bharata B Rao <bharata@linux.ibm.com>
    KVM: PPC: Book3S HV: Release lock on page-out failure path

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Only provision redistributors that are enabled in ACPI

Dor Askayo <dor.askayo@gmail.com>
    drm/amd/display: do not allocate display_mode_lib unnecessarily

Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
    ASoC: Intel: consistent HDMI codec probing code

Arnd Bergmann <arnd@arndb.de>
    rbd: work around -Wuninitialized warning

Xiubo Li <xiubli@redhat.com>
    ceph: check availability of mds cluster on mount after wait timeout

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Don't log user reads to 0xffffffff

Vasily Averin <vvs@virtuozzo.com>
    bpf: map_seq_next should always increase position index

Wei Hu <weh@microsoft.com>
    video: hyperv: hyperv_fb: Use physical memory for fb on HyperV Gen 1 VMs.

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix NULL dereference in match_prepath

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix mount options set in automount

Steve French <stfrench@microsoft.com>
    cifs: fix unitialized variable poential problem with network I/O cache lock patch

Colin Ian King <colin.king@canonical.com>
    iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop

Yan-Hsuan Chuang <yhchuang@realtek.com>
    rtw88: fix potential NULL skb access in TX ISR

Nathan Chancellor <natechancellor@gmail.com>
    hostap: Adjust indentation in prism2_hostapd_add_sta

Nicola Lunghi <nick83ola@gmail.com>
    ALSA: usb-audio: add quirks for Line6 Helix devices fw>=2.82

Vincenzo Frascino <vincenzo.frascino@arm.com>
    ARM: 8951/1: Fix Kexec compilation issue.

Ard Biesheuvel <ardb@kernel.org>
    ARM: 8941/1: decompressor: enable CP15 barrier instructions in v7 cache setup code

Oliver O'Halloran <oohall@gmail.com>
    selftests/eeh: Bump EEH wait time to 60s

Michael Bringmann <mwb@linux.ibm.com>
    powerpc/pseries/lparcfg: Fix display of Maximum Memory

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: make sure ESHUTDOWN to be recorded in the journal superblock

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: Reset global state between reuseport test runs

Stephen Boyd <swboyd@chromium.org>
    alarmtimer: Make alarmtimer platform device child of RTC device

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove unnecessary WARN_ON_ONCE()

Barret Rhoden <brho@google.com>
    iommu/vt-d: Mark firmware tainted if RMRR fails sanity check

Coly Li <colyli@suse.de>
    bcache: fix use-after-free in register_bcache()

Christoph Hellwig <hch@lst.de>
    bcache: rework error unwinding in register_bcache

Liang Chen <liangchen.linux@gmail.com>
    bcache: cached_dev_free needs to put the sb page

Nikolay Borisov <nborisov@suse.com>
    btrfs: Fix split-brain handling when changing FSID to metadata uuid

David Sterba <dsterba@suse.com>
    btrfs: separate definition of assertion failure handlers

Sergey Zakharchenko <szakharchenko@digital-loggers.com>
    media: uvcvideo: Add a quirk to force GEO GC6500 Camera bits-per-pixel value

Oliver O'Halloran <oohall@gmail.com>
    powerpc/sriov: Remove VF eeh_dev state when disabling SR-IOV

Olof Johansson <olof@lixom.net>
    net/mlx5e: Fix printk format warning

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/mmu: fix comptag memory leak

Trond Myklebust <trondmy@gmail.com>
    sunrpc: Fix potential leaks in sunrpc_cache_unhash()

Peter Große <pegro@friiks.de>
    ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Chris Down <chris@chrisdown.name>
    bpf, btf: Always output invariant hit in pahole DWARF to BTF transform

Colin Ian King <colin.king@canonical.com>
    driver core: platform: fix u32 greater or equal to zero comparison

Sven Schnelle <svens@linux.ibm.com>
    s390: fix __EMIT_BUG() macro

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: generate traced function stack frame

Vasily Gorbik <gor@linux.ibm.com>
    s390: adjust -mpacked-stack support check for clang 10

Masami Hiramatsu <mhiramat@kernel.org>
    x86/decoder: Add TEST opcode to Group3-2

Shile Zhang <shile.zhang@linux.alibaba.com>
    objtool: Fix ARCH=x86_64 build error

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: use -S instead of -E for precise cc-option test in Kconfig

Michael Walle <michael@walle.cc>
    spi: spi-fsl-qspi: Ensure width is respected in spi-mem operations

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()

John Garry <john.garry@huawei.com>
    irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove problems

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    regulator: core: Fix exported symbols to the exported GPL version

Brandon Maier <brandon.maier@rockwellcollins.com>
    remoteproc: Initialize rproc_class before use

Jessica Yu <jeyu@kernel.org>
    module: avoid setting info->name early in case we can fall back to info->mod->name

Anand Jain <anand.jain@oracle.com>
    btrfs: device stats, log when stats are zeroed

David Sterba <dsterba@suse.com>
    btrfs: safely advance counter when looking up bio csums

Johannes Thumshirn <jth@kernel.org>
    btrfs: fix possible NULL-pointer dereference in integrity checks

yu kuai <yukuai3@huawei.com>
    pwm: Remove set but not set variable 'pwm'

Dan Carpenter <dan.carpenter@oracle.com>
    ide: serverworks: potential overflow in svwks_set_pio_mode()

Dan Carpenter <dan.carpenter@oracle.com>
    cmd64x: potential buffer overflow in cmd64x_program_timings()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunctional

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Ard Biesheuvel <ardb@kernel.org>
    efi/arm: Defer probe of PCIe backed efifb on DT systems

Ard Biesheuvel <ardb@kernel.org>
    x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd

Chao Yu <chao@kernel.org>
    f2fs: fix memleak of kobject

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    regulator: vctrl-regulator: Avoid deadlock getting and setting the voltage

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: SOF: Intel: hda: Fix SKL dai count

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Correct cache handling of new kernel control API

Marco Elver <elver@google.com>
    debugobjects: Fix various data races

Arnd Bergmann <arnd@arndb.de>
    x86/apic/uv: Avoid unused variable warning

Hanjun Guo <guohanjun@huawei.com>
    ACPI/IORT: Fix 'Number of IDs' handling in iort_id_map()

Vladimir Oltean <vladimir.oltean@nxp.com>
    enetc: Don't print from enetc_sched_speed_set when link goes down

Thomas Gleixner <tglx@linutronix.de>
    watchdog/softlockup: Enforce that timestamp is valid on boot

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Constrain Large Increment per Cycle events

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Assert non-NUMA topology masks don't (partially) overlap

Li Guanglei <guanglei.li@unisoc.com>
    sched/core: Fix size of rq::uclamp initialization

Lokesh Vutla <lokeshvutla@ti.com>
    arm64: dts: ti: k3-j721e-main: Add missing power-domains for smmu

zhengbin <zhengbin13@huawei.com>
    KVM: PPC: Remove set but not used variable 'ra', 'rs', 'rt'

Wei Yongjun <weiyongjun1@huawei.com>
    EDAC/sifive: Fix return value check in ecc_register()

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix possible overflow on jiffies comparaison

Jun Lei <Jun.Lei@amd.com>
    drm/amd/display: fixup DML dependencies

Sami Tolvanen <samitolvanen@google.com>
    arm64: fix alternatives with LLVM's integrated assembler

Sami Tolvanen <samitolvanen@google.com>
    arm64: lse: fix LSE atomics with LLVM's integrated assembler

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Don't fake udata for kernel path

Mika Westerberg <mika.westerberg@linux.intel.com>
    pinctrl: tigerlake: Tiger Lake uses _HID enumeration

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Add debugfs support with devfreq_summary file

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: add implicit fb quirk for MOTU M Series

Geert Uytterhoeven <geert@linux-m68k.org>
    crypto: essiv - fix AEAD capitalization and preposition use in help text

Zaibo Xu <xuzaibo@huawei.com>
    crypto: hisilicon - Bugfixed tfm leak

Zaibo Xu <xuzaibo@huawei.com>
    crypto: hisilicon - Update debugfs usage of SEC V2

Nick Black <nlb@google.com>
    scsi: iscsi: Don't destroy session if there are outstanding connections

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs-mediatek: add apply_dev_quirks variant operation

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: pass device information to apply_dev_quirks

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: free sysfs kobject

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: set I_LINKABLE early to avoid wrong access by vfs

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: usb-audio: unlock on error in probe

Will Deacon <will@kernel.org>
    iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: remove *.tmp file when filechk fails

Tony Lindgren <tony@atomide.com>
    usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Leonard Crestez <leonard.crestez@nxp.com>
    perf/imx_ddr: Fix cpu hotplug state cleanup

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Stephen Boyd <swboyd@chromium.org>
    gpiolib: Set lockdep class for hierarchical irq domains

Mikulas Patocka <mpatocka@redhat.com>
    dm thin: don't allow changing data device during thin-pool reload

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fault/gv100-: fix memory leak on module unload

YueHaibing <yuehaibing@huawei.com>
    drm/nouveau/drm/ttm: Remove set but not used variable 'mem'

YueHaibing <yuehaibing@huawei.com>
    drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read from fw

Dan Carpenter <dan.carpenter@oracle.com>
    drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()

Reto Schneider <reto.schneider@husqvarnagroup.com>
    MIPS: ralink: dts: gardena_smart_gateway_mt7688: Limit UART1

Arnd Bergmann <arnd@arndb.de>
    vme: bridges: reduce stack usage

Li RongQing <lirongqing@baidu.com>
    bpf: Return -EBADRQC for invalid map type in __bpf_tx_xdp_map

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix compilation warning in pcm_prepare

Geert Uytterhoeven <geert+renesas@glider.be>
    driver core: Print device when resources present in really_probe()

Simon Schwartz <kern.simon@theschwartz.xyz>
    driver core: platform: Prevent resouce overflow from causing infinite loops

Arnd Bergmann <arnd@arndb.de>
    visorbus: fix uninitialized variable access

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    misc: xilinx_sdfec: fix xsdfec_poll()'s return type

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: properly empty-initialize structure

Nathan Chancellor <natechancellor@gmail.com>
    tty: synclink_gt: Adjust indentation in several functions

Nathan Chancellor <natechancellor@gmail.com>
    tty: synclinkmp: Adjust indentation in several functions

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/uverbs: Remove needs_kfree_rcu from uverbs_obj_type_class

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    raid6/test: fix a compilation warning

Chen Zhou <chenzhou10@huawei.com>
    ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=m

Paul Burton <paulburton@kernel.org>
    ASoC: txx9: Remove unused rtd variable

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add boot quirk for MOTU M Series

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: add reg property to brcmf sub node for rk3188-bqedison2qc

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: add reg property to brcmf sub-nodes

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix dwmmc clock name for rk3308

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix dwmmc clock name for px30

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    clocksource: davinci: only enable clockevents once tim34 is initialized

Arnd Bergmann <arnd@arndb.de>
    wan: ixp4xx_hss: fix compile-testing on 64-bit

Changbin Du <changbin.du@intel.com>
    x86/nmi: Remove irq_work from the long duration NMI handler

Jonathan Lemon <jonathan.lemon@gmail.com>
    bnxt: Detach page from page pool before sending up the stack

Philipp Zabel <p.zabel@pengutronix.de>
    Input: edt-ft5x06 - work around first register access error

Paul E. McKenney <paulmck@kernel.org>
    rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Don't panic or BUG() on non-critical error conditions

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: fuse: Correct straps' address for older Tegra124 device trees

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Add RcvShortLengthErrCnt to hfi1stats

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Add software counter for ctxt0 seq drop

Arnd Bergmann <arnd@arndb.de>
    staging: rtl8188: avoid excessive stack usage

Yongqiang Niu <yongqiang.niu@mediatek.com>
    drm/mediatek: Add gamma property according to hardware capability

Alan Maguire <alan.maguire@oracle.com>
    kunit: remove timeout dependence on sysctl_hung_task_timeout_seconds

Dan Carpenter <dan.carpenter@oracle.com>
    selftests: Uninitialized variable in test_cgcore_proc_migration()

Jan Kara <jack@suse.cz>
    udf: Fix free space reporting for metadata and virtual partitions

Shuah Khan <skhan@linuxfoundation.org>
    usbip: Fix unsafe unaligned pointer usage

Benjamin Gaignard <benjamin.gaignard@st.com>
    ARM: dts: stm32: Add power-supply for DSI panel on stm32f469-disco

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    usb: dwc3: use proper initializers for property entries

Dingchen Zhang <dingchen.zhang@amd.com>
    drm: remove the newline for CRC source name.

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Avoid printing address of mtt page

Arnd Bergmann <arnd@arndb.de>
    mlx5: work around high stack usage with gcc

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Fix permissions of hang_hws

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Avoid sending invalid page response

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Match CPU and IOMMU paging mode

Jason Ekstrand <jason@jlekstrand.net>
    ACPI: button: Add DMI quirk for Razer Blade Stealth 13 late 2019 lid switch

Shile Zhang <shile.zhang@linux.alibaba.com>
    x86/unwind/orc: Fix !CONFIG_MODULES build warning

Sam McNally <sammc@chromium.org>
    ASoC: Intel: sof_rt5682: Ignore the speaker amp when there isn't one.

Alexey Kardashevskiy <aik@ozlabs.ru>
    vfio/spapr/nvlink2: Skip unpinning pages on error exit

Andrey Zhizhikin <andrey.z@gmail.com>
    tools lib api fs: Fix gcc9 stringop-truncation compilation error

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    net: phy: fixed_phy: fix use-after-free when checking link GPIO

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix compile warning wrt const

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply mic mute LED quirk for Dell E7xx laptops, too

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    clk: uniphier: Add SCSSI clock gate for each channel

Stephen Boyd <sboyd@kernel.org>
    clk: Use parent node pointer during registration if necessary

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix unused variable warnings

Icenowy Zheng <icenowy@aosc.io>
    clk: sunxi-ng: add mux and pll notifiers for A64 CPU clock

Mitch Williams <mitch.a.williams@intel.com>
    ice: add extra check for null Rx descriptor

Jiewei Ke <kejiewei.cn@gmail.com>
    RDMA/rxe: Fix error type of mmap_offset

Peter Rosin <peda@axentia.se>
    fbdev: fix numbering of fbcon options

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: soc-topology: fix endianness issues

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    reset: uniphier: Add SCSSI reset control for each channel

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs

Manasi Navare <manasi.d.navare@intel.com>
    drm/fbdev: Fallback to non tiled mode if all tiles not present

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC dependency

Kamil Konieczny <k.konieczny@samsung.com>
    PM / devfreq: Change time stats to 64-bit

Arnd Bergmann <arnd@arndb.de>
    PM / devfreq: exynos-ppmu: Fix excessive stack usage

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    x86/vdso: Provide missing include file

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    crypto: chtls - Fixed memory leak

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: phy: realtek: add logging for the RGMII TX delay configuration

Hechao Li <hechaol@fb.com>
    bpf: Print error message for bpftool cgroup show

Sascha Hauer <s.hauer@pengutronix.de>
    dmaengine: imx-sdma: Fix memory leak

YueHaibing <yuehaibing@huawei.com>
    clk: bm1800: Remove set but not used variable 'fref'

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: Store module owner in dma_device struct

Jerome Brunet <jbrunet@baylibre.com>
    clk: actually call the clock init before any other callback of the clock

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    clk: qcom: Add missing msm8998 gcc_bimc_gfx_clk

Qian Cai <cai@lca.pw>
    iommu/iova: Silence warnings under memory pressure

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Only support x2APIC with IVHD type 11h/40h

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Check feature support bit before accessing MSI capability registers

Greg Kroah-Hartman <gregkh@google.com>
    PCI/ATS: Restore EXPORT_SYMBOL_GPL() for pci_{enable,disable}_ats()

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: db845c: Enable ath10k 8bit host-cap quirk

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix: Rework setting of fdmi symbolic node name registration

Jaihind Yadav <jaihindyadav@codeaurora.org>
    selinux: ensure we cleanup the internal AVC counters on error in avc_update()

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: q6v5-mss: Remove mem clk from the active pool

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7779: Add device node for ARM global timer

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    clk: renesas: rcar-gen3: Allow changing the RPC[D2] clocks

Bibby Hsieh <bibby.hsieh@mediatek.com>
    drm/mediatek: handle events when enabling/disabling crtc

Brendan Higgins <brendanhiggins@google.com>
    crypto: amlogic - add unspecified HAS_IOMEM dependency

Brendan Higgins <brendanhiggins@google.com>
    crypto: inside-secure - add unspecified HAS_IOMEM dependency

Nathan Chancellor <natechancellor@gmail.com>
    scsi: aic7xxx: Adjust indentation in ahc_find_syncrate

Can Guo <cang@codeaurora.org>
    scsi: ufs: Complete pending requests in host reset and restore path

Trond Myklebust <trondmy@gmail.com>
    nfsd: Clone should commit src file metadata too

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    clk: qcom: smd: Add missing bimc clock

Monk Liu <Monk.Liu@amd.com>
    drm/amdgpu: fix KIQ ring test fail in TDR of SRIOV

Monk Liu <Monk.Liu@amd.com>
    drm/amdgpu: fix double gpu_recovery for NV of SRIOV

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Lower DPP DTO only when safe

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Fix update_bw_bounding_box Calcs

Aditya Pakki <pakki001@umn.edu>
    orinoco: avoid assertion in case of NULL pointer

Phong Tran <tranmanphong@gmail.com>
    rtlwifi: rtl_pci: Fix -Wcast-function-type

Phong Tran <tranmanphong@gmail.com>
    iwlegacy: Fix -Wcast-function-type

Phong Tran <tranmanphong@gmail.com>
    ipw2x00: Fix -Wcast-function-type

Phong Tran <tranmanphong@gmail.com>
    b43legacy: Fix -Wcast-function-type

James Sewart <jamessewart@arista.com>
    PCI: Add DMA alias quirk for PLX PEX NTB

James Sewart <jamessewart@arista.com>
    PCI: Add nr_devfns parameter to pci_add_dma_alias()

Arnd Bergmann <arnd@arndb.de>
    nfs: fix timstamp debug prints

Nathan Chancellor <natechancellor@gmail.com>
    ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status

Xin Long <lucien.xin@gmail.com>
    netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy

Tero Kristo <t-kristo@ti.com>
    ARM: OMAP2+: pdata-quirks: add PRM data for reset support

Arnd Bergmann <arnd@arndb.de>
    x86/mce/therm_throt: Mark throttle_active_work() as __maybe_unused

Arnd Bergmann <arnd@arndb.de>
    isdn: don't mark kcapi_proc_exit as __exit

Aditya Pakki <pakki001@umn.edu>
    fore200e: Fix incorrect checks of NULL pointer dereference

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: check that Realtek PHY driver module is loaded

Toke Høiland-Jørgensen <toke@redhat.com>
    samples/bpf: Set -fno-stack-protector when building BPF programs

Jan Kara <jack@suse.cz>
    reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling

Nathan Chancellor <natechancellor@gmail.com>
    media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2_device macros

Willem de Bruijn <willemb@google.com>
    selftests/net: make so_txtime more robust to timer variance

Paul Cercueil <paul@crapouillou.net>
    gpu/drm: ingenic: Avoid null pointer deference in plane atomic update

Jakub Kicinski <kuba@kernel.org>
    Revert "nfp: abm: fix memory leak in nfp_abm_u32_knode_replace"

Daniel Drake <drake@endlessm.com>
    PCI: Increase D3 delay for AMD Ryzen5/7 XHCI controllers

Daniel Drake <drake@endlessm.com>
    PCI: Add generic quirk for increasing D3hot delay

Forest Crossman <cyrozap@gmail.com>
    media: cx23885: Add support for AVerMedia CE310B

Wei Liu <wei.liu@kernel.org>
    PCI: iproc: Apply quirk_paxc_bridge() for module as well as built-in

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Implement quirk handling for CLKDM_NOAUTO

Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
    IMA: Check IMA policy flag

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6: rdu2: Limit USBH1 to Full Speed

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6: rdu2: Disable WP for USDHC2 and USDHC3

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: exynos_defconfig: Bring back explicitly wanted options

Abel Vesa <abel.vesa@nxp.com>
    clk: imx: Add correct failure handling for clk based helpers

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: validate cpumask without removed CPU during offline

Manu Gautam <mgautam@codeaurora.org>
    arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core

Chen Wandun <chenwandun@huawei.com>
    enetc: remove variable 'tc_max_sized_frame' set but not used

Paul Moore <paul@paul-moore.com>
    selinux: ensure we cleanup the internal AVC counters on error in avc_insert()

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Free static OPPs on errors while adding them

Andre Przywara <andre.przywara@arm.com>
    arm: dts: allwinner: H3: Add PMU node

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H5: Add PMU node

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H6: Add PMU mode

Mao Wenan <maowenan@huawei.com>
    NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Thong Thai <thong.thai@amd.com>
    Revert "drm/amdgpu: enable VCN DPG on Raven and Raven2"

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net/wan/fsl_ucc_hdlc: reject muram offsets above 64K

Miquel Raynal <miquel.raynal@bootlin.com>
    regulator: rk808: Lower log level on optional GPIOs being not available

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: hda: solve MSI issues by merging ipc and stream irq handlers

Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
    ASoC: intel: sof_rt5682: Add support for tgl-max98357a-rt5682

Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
    ASoC: intel: sof_rt5682: Add quirk for number of HDMI DAI's

Masami Hiramatsu <mhiramat@kernel.org>
    modules: lockdep: Suppress suspicious RCU usage warning

Robin Murphy <robin.murphy@arm.com>
    arm64: dts: rockchip: Fix NanoPC-T4 cooling maps

Adam Ford <aford173@gmail.com>
    drm/panel: simple: Add Logic PD Type 28 display support

Nathan Chancellor <natechancellor@gmail.com>
    drm/amdgpu: Ensure ret is always initialized when using SOC15_WAIT_ON_RREG

Wen Gong <wgong@codeaurora.org>
    ath10k: correct the tlv len of ath10k_wmi_tlv_op_gen_config_pno_start

Chris Wilson <chris@chris-wilson.co.uk>
    drm/amdgpu/dm: Do not throw an error for a display with no audio

yu kuai <yukuai3@huawei.com>
    drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table

Eric Yang <Eric.Yang2@amd.com>
    drm/amd/display: Renoir chroma viewport WA

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockhash: Synchronize_rcu before free'ing map

Yong Zhao <Yong.Zhao@amd.com>
    drm/amdkfd: Fix a bug in SDMA RLC queue counting under HWS mode

Douglas Anderson <dianders@chromium.org>
    clk: qcom: rcg2: Don't crash if our parent can't be found; return an error

Stephen Boyd <sboyd@kernel.org>
    clk: qcom: Don't overwrite 'cfg' in clk_rcg2_dfs_populate_freq()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix broken dependency in randconfig-generated .config

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: do not plug I/O for bfq_queues with no proc refs

Colin Ian King <colin.king@canonical.com>
    drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store

Chris Mason <clm@fb.com>
    Btrfs: keep pages dirty when using btrfs_writepage_fixup_worker

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups

Sun Ke <sunke32@huawei.com>
    nbd: add a flush_workqueue in nbd_start_device

Tom Zanussi <zanussi@kernel.org>
    tracing: Simplify assignment parsing for hist triggers

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Retrain dongles when SINK_COUNT becomes non-zero

Geert Uytterhoeven <geert@linux-m68k.org>
    rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: settings: tests can be in subsubdirs

Jean-Philippe Brucker <jean-philippe@linaro.org>
    brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: fix rate mask for 1SS chip

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Correct the DMA direction for management tx buffers

zhangyi (F) <yi.zhang@huawei.com>
    ext4, jbd2: ensure panic when aborting with zero errno

Vincenzo Frascino <vincenzo.frascino@arm.com>
    ARM: 8952/1: Disable kmemleak on XIP kernels

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix very unlikely race of registering two stat tracers

Luis Henriques <luis.henriques@canonical.com>
    tracing: Fix tracing_stat return values in error handling paths

Oliver O'Halloran <oohall@gmail.com>
    powerpc/iov: Move VF pdev fixup into pcibios_fixup_iov()

Chen Zhou <chenzhou10@huawei.com>
    backlight: qcom-wled: Fix unsigned comparison to zero

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix possible deadlock in recover_store()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Fix get_vlpi_map() breakage with doorbells

Martin Schiller <ms@dev.tdt.de>
    wan/hdlc_x25: fix skb handling

Chen Zhou <chenzhou10@huawei.com>
    dmaengine: fsl-qdma: fix duplicated argument to &&

Jan Kara <jack@suse.cz>
    udf: Allow writing to 'Rewritable' partitions

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: omap-dmtimer: Simplify error handling

Arvind Sankar <nivedita@alum.mit.edu>
    x86/sysfb: Fix check for bad VRAM size

Grygorii Strashko <grygorii.strashko@ti.com>
    clk: ti: dra7: fix parent for gmac_clkctrl

Eric Biggers <ebiggers@google.com>
    ext4: fix deadlock allocating bio_post_read_ctx from mempool

Kai Li <li.kai4@h3c.com>
    jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal

Siddhesh Poyarekar <siddhesh@gotplt.org>
    kselftest: Minimise dependency of get_size on C library interfaces

Amanda Liu <amanda.liu@amd.com>
    drm/amd/display: Clear state after exiting fixed active VRR state

Colin Ian King <colin.king@canonical.com>
    clocksource/drivers/bcm2835_timer: Fix memory leak of timer

John Keeping <john@metanate.com>
    usb: dwc2: Fix IN FIFO allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_probe()

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/nouveau: fix incorrect sizeof on args.src an args.dst

Philippe Schenker <philippe.schenker@toradex.com>
    spi: fsl-lpspi: fix only one cs-gpio working

Tiecheng Zhou <Tiecheng.Zhou@amd.com>
    drm/amdgpu/sriov: workaround on rev_id for Navi12 under sriov

Jia-Ju Bai <baijiaju1990@gmail.com>
    uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: check return value from st_lsm6dsx_sensor_set_enable

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    raid6/test: fix a compilation error

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: ixp4xx: Standard module init

David S. Miller <davem@davemloft.net>
    sparc: Add .exit.data section.

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Map the entire EFI vendor string before copying it

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins

Parav Pandit <parav@mellanox.com>
    IB/core: Let IB core distribute cache update events

YueHaibing <yuehaibing@huawei.com>
    kernel/module: Fix memleak in module_add_modinfo_attrs()

Jia-Ju Bai <baijiaju1990@gmail.com>
    media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdisp_device_run()

Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
    char/random: silence a lockdep splat with printk()

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: table line rebuild status fixes

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/fpu: Deactivate FPU state after failure during state load

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix off-by-one in PASID allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpio_irq_map/unmap()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: meson8b: make the CCF use the glitch-free mali mux

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid PE number

Eugen Hristev <eugen.hristev@microchip.com>
    clk: at91: sam9x60: fix programmable clock prescaler

Chen-Yu Tsai <wens@csie.org>
    media: sun4i-csi: Fix [HV]sync polarity handling

Chen-Yu Tsai <wens@csie.org>
    media: sun4i-csi: Fix data sampling polarity handling

Chen-Yu Tsai <wens@csie.org>
    media: sun4i-csi: Deal with DRAM offset

Eugen Hristev <eugen.hristev@microchip.com>
    media: i2c: mt9v032: fix enum mbus codes and frame sizes

Adam Ford <aford173@gmail.com>
    media: ov5640: Fix check for PLL1 exceeding max allowed rate

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pxa168fb: Fix the function used to release some memory in an error handling path

Rob Clark <robdclark@chromium.org>
    drm/msm/adreno: fix zap vs no-zap handling

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/mipi_dbi: Fix off-by-one bugs in mipi_dbi_blank()

John Ogness <john.ogness@linutronix.de>
    printk: fix exclusive_console replaying

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs

Vladimir Oltean <olteanv@gmail.com>
    gianfar: Fix TX timestamping with a stacked DSA driver

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: ctl: allow TLV read operation for callback type of element in locked case

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix ext4_dax_read/write inode locking sequence for IOCB_NOWAIT

Zahari Petkov <zahari@balena.io>
    leds: pca963x: Fix open-drain initialization

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Map ODM memory correctly when doing ODM combine

James Sewart <jamessewart@arista.com>
    PCI: Fix pci_add_dma_alias() bitmask size

Dan Carpenter <dan.carpenter@oracle.com>
    brcmfmac: Fix use after free in brcmf_sdio_readframes()

Navid Emamdoost <navid.emamdoost@gmail.com>
    brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()

Wei Yongjun <weiyongjun1@huawei.com>
    dmaengine: ti: edma: Fix error return code in edma_probe()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: rcar-du: Recognize "renesas,vsps" in addition to "vsps"

Peter Zijlstra <peterz@infradead.org>
    cpu/hotplug, stop_machine: Fix stop_machine vs hotplug order

Remi Pommarel <repk@triplefau.lt>
    clk: meson: pll: Fix by 0 division in __pll_params_to_rate()

Colin Ian King <colin.king@canonical.com>
    media: meson: add missing allocation failure check on new_buf

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: call f2fs_balance_fs outside of locked page

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: preallocate DIO blocks when forcing buffered_io

Chuhong Yuan <hslester96@gmail.com>
    dmaengine: ti: edma: add missed operations

Marco Elver <elver@google.com>
    rcu: Fix data-race due to atomic_t copy-by-value

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    soc: fsl: qe: change return type of cpm_muram_alloc() to s32

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu: Fix missed wakeup of exp_wq waiters

Stefan Reiter <stefan@pimaker.at>
    rcu/nocb: Fix dump_tree hierarchy print always active

J. Bruce Fields <bfields@redhat.com>
    nfsd4: avoid NULL deference on strange COPY compounds

Markus Elfring <elfring@users.sourceforge.net>
    drm/qxl: Complete exception handling in qxl_device_init()

Gerd Hoffmann <kraxel@redhat.com>
    drm/virtio: fix byteorder handling in virtio_gpu_cmd_transfer_{from, to}_host_3d functions

Colin Ian King <colin.king@canonical.com>
    wil6210: fix break that is never reached because of zero'ing of a retry counter

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    ath10k: Fix qmi init error handling

Colin Ian King <colin.king@canonical.com>
    drm/dp_mst: fix multiple frees of tx->bytes

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/gma500: Fixup fbdev stolen size usage evaluation

Davide Caratti <dcaratti@redhat.com>
    net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Davide Caratti <dcaratti@redhat.com>
    net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS

Per Forlin <per.forlin@axis.com>
    net: dsa: tag_qca: Make sure there is headroom for tag

Eric Dumazet <edumazet@google.com>
    net/smc: fix leak of kernel memory to user space

Firo Yang <firo.yang@suse.com>
    enic: prevent waking up stopped tx queues over watchdog reset

Toke Høiland-Jørgensen <toke@redhat.com>
    core: Don't skip generic XDP program execution for cloned SKBs


-------------

Diffstat:

 .../admin-guide/device-mapper/dm-raid.rst          |   2 +
 Documentation/fb/fbcon.rst                         |   8 +-
 Makefile                                           |   6 +-
 arch/Kconfig                                       |   3 +
 arch/arm/Kconfig                                   |   4 +-
 arch/arm/boot/compressed/head.S                    |  13 +
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi            |   7 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |   8 +
 arch/arm/boot/dts/rk3188-bqedison2qc.dts           |   3 +
 arch/arm/boot/dts/stm32f469-disco.dts              |   8 +
 arch/arm/boot/dts/sun8i-h3.dtsi                    |  15 +-
 arch/arm/configs/exynos_defconfig                  |   6 +
 arch/arm/mach-omap2/pdata-quirks.c                 |   8 +
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi       |  16 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |  10 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   4 +
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   2 +
 arch/arm64/boot/dts/rockchip/px30.dtsi             |   6 +-
 arch/arm64/boot/dts/rockchip/rk3308.dtsi           |   6 +-
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts    |   3 +
 .../boot/dts/rockchip/rk3399-khadas-edge.dtsi      |   3 +
 arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts  |  27 -
 arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts   |   3 +
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |   1 +
 arch/arm64/include/asm/alternative.h               |  32 +-
 arch/arm64/include/asm/atomic_lse.h                |  19 +
 arch/arm64/include/asm/lse.h                       |   6 +-
 arch/microblaze/kernel/cpu/cache.c                 |   3 +-
 .../dts/ralink/gardena_smart_gateway_mt7688.dts    |   3 +
 arch/powerpc/Makefile.postlink                     |   4 +-
 arch/powerpc/kernel/eeh_driver.c                   |   6 -
 arch/powerpc/kernel/pci_dn.c                       |  15 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   2 +-
 arch/powerpc/kvm/emulate_loadstore.c               |   5 -
 arch/powerpc/mm/fault.c                            |   3 +
 arch/powerpc/platforms/powernv/pci-ioda.c          |  48 +-
 arch/powerpc/platforms/powernv/pci.c               |  18 -
 arch/powerpc/platforms/pseries/lparcfg.c           |   4 +-
 arch/powerpc/tools/relocs_check.sh                 |  20 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/boot/head.S                              |   2 +-
 arch/s390/include/asm/bug.h                        |  16 +-
 arch/s390/include/asm/pci.h                        |   2 +-
 arch/s390/kernel/entry.h                           |   1 +
 arch/s390/kernel/mcount.S                          |  15 +-
 arch/s390/kernel/pgm_check.S                       |   2 +-
 arch/s390/kernel/traps.c                           |  41 +-
 arch/s390/kvm/interrupt.c                          |   6 +-
 arch/s390/pci/pci.c                                |   2 +-
 arch/s390/pci/pci_clp.c                            |  48 +-
 arch/s390/pci/pci_sysfs.c                          |  63 ++-
 arch/sh/include/cpu-sh2a/cpu/sh7269.h              |  11 +-
 arch/sparc/kernel/vmlinux.lds.S                    |   6 +-
 arch/x86/boot/Makefile                             |   2 +-
 arch/x86/entry/vdso/vdso32-setup.c                 |   1 +
 arch/x86/events/amd/core.c                         |  91 ++--
 arch/x86/events/perf_event.h                       |   2 +
 arch/x86/include/asm/nmi.h                         |   1 -
 arch/x86/kernel/apic/x2apic_uv_x.c                 |  43 +-
 arch/x86/kernel/cpu/mce/therm_throt.c              |   2 +-
 arch/x86/kernel/fpu/signal.c                       |   3 +
 arch/x86/kernel/nmi.c                              |  20 +-
 arch/x86/kernel/sysfb_simplefb.c                   |   2 +-
 arch/x86/kernel/unwind_orc.c                       |   3 +-
 arch/x86/lib/x86-opcode-map.txt                    |   2 +-
 arch/x86/mm/pageattr.c                             |   8 +-
 arch/x86/platform/efi/efi.c                        |  41 +-
 arch/x86/platform/efi/efi_64.c                     |   9 +-
 block/bfq-iosched.c                                |  12 +
 crypto/Kconfig                                     |   4 +-
 drivers/acpi/acpica/dsfield.c                      |   2 +-
 drivers/acpi/acpica/dswload.c                      |  21 +
 drivers/acpi/arm64/iort.c                          |  57 ++-
 drivers/acpi/button.c                              |  11 +
 drivers/atm/fore200e.c                             |  25 +-
 drivers/base/dd.c                                  |   5 +-
 drivers/base/platform.c                            |  12 +-
 drivers/block/brd.c                                |  22 +-
 drivers/block/nbd.c                                |  10 +
 drivers/block/rbd.c                                |   2 +-
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/bus/ti-sysc.c                              |  10 +-
 drivers/char/hpet.c                                |   2 +-
 drivers/char/random.c                              |   5 +-
 drivers/clk/at91/sam9x60.c                         |   1 +
 drivers/clk/clk-bm1880.c                           |   3 +-
 drivers/clk/clk.c                                  |  53 +-
 drivers/clk/imx/clk.h                              |  37 +-
 drivers/clk/meson/clk-pll.c                        |   9 +
 drivers/clk/meson/meson8b.c                        |  11 +-
 drivers/clk/qcom/clk-rcg2.c                        |  11 +-
 drivers/clk/qcom/clk-smd-rpm.c                     |   3 +
 drivers/clk/qcom/gcc-msm8998.c                     |  14 +
 drivers/clk/renesas/rcar-gen3-cpg.c                |   6 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |  28 +-
 drivers/clk/ti/clk-7xx.c                           |   2 +-
 drivers/clk/uniphier/clk-uniphier-peri.c           |  13 +-
 drivers/clocksource/bcm2835_timer.c                |   5 +-
 drivers/clocksource/timer-davinci.c                |   8 +-
 drivers/crypto/Kconfig                             |   2 +-
 drivers/crypto/amlogic/Kconfig                     |   1 +
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  27 +-
 drivers/crypto/chelsio/chtls/chtls_cm.h            |  21 +
 drivers/crypto/chelsio/chtls/chtls_hw.c            |   3 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   7 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  24 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   8 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |  18 +-
 drivers/devfreq/Kconfig                            |   3 +-
 drivers/devfreq/devfreq.c                          |  96 +++-
 drivers/devfreq/event/Kconfig                      |   2 +-
 drivers/devfreq/event/exynos-ppmu.c                |  13 +-
 drivers/dma/dmaengine.c                            |   4 +-
 drivers/dma/fsl-qdma.c                             |   2 +-
 drivers/dma/imx-sdma.c                             |  19 +-
 drivers/dma/ti/edma.c                              |  39 +-
 drivers/edac/sifive_edac.c                         |   4 +-
 drivers/firmware/efi/arm-init.c                    | 107 +++-
 drivers/gpio/gpio-grgpio.c                         |  10 +-
 drivers/gpio/gpiolib.c                             |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 -
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   6 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   8 +-
 drivers/gpu/drm/amd/amdgpu/soc15_common.h          |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c           |   2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  10 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   2 -
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c   |  34 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |  16 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h   |   2 +-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  17 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   3 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c  |  16 +-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c  |  65 ++-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  12 +-
 .../gpu/drm/amd/display/dc/dml/dml_common_defs.c   |   2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |   2 +-
 .../amd/display/dc/{calcs => inc}/dcn_calc_math.h  |   0
 .../drm/amd/display/modules/freesync/freesync.c    |   2 +
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c  |  23 +-
 drivers/gpu/drm/drm_client_modeset.c               |  72 +++
 drivers/gpu/drm/drm_debugfs_crc.c                  |   4 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   4 +-
 drivers/gpu/drm/drm_mipi_dbi.c                     |   4 +-
 drivers/gpu/drm/gma500/framebuffer.c               |   8 +-
 drivers/gpu/drm/ingenic/ingenic-drm.c              |  16 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |  18 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  11 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  11 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   4 -
 drivers/gpu/drm/nouveau/nvkm/core/memory.c         |   2 +-
 .../gpu/drm/nouveau/nvkm/engine/disp/channv50.c    |   2 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c     |  21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c   |   1 +
 .../gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c    |   5 +-
 drivers/gpu/drm/panel/panel-simple.c               |  37 ++
 drivers/gpu/drm/qxl/qxl_kms.c                      |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   2 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |  17 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   5 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  22 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  19 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c         |   4 +-
 drivers/ide/cmd64x.c                               |   3 +
 drivers/ide/serverworks.c                          |   6 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   7 +-
 drivers/infiniband/core/cache.c                    | 121 +++--
 drivers/infiniband/core/core_priv.h                |   1 +
 drivers/infiniband/core/device.c                   |  33 +-
 drivers/infiniband/core/rdma_core.c                |  23 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  11 +
 drivers/infiniband/hw/hfi1/chip.h                  |   2 +
 drivers/infiniband/hw/hfi1/chip_registers.h        |   1 +
 drivers/infiniband/hw/hfi1/driver.c                |   1 +
 drivers/infiniband/hw/hfi1/hfi.h                   |   2 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |  34 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   2 +-
 drivers/input/touchscreen/edt-ft5x06.c             |   7 +
 drivers/iommu/amd_iommu.c                          |   7 +-
 drivers/iommu/amd_iommu_init.c                     |  19 +-
 drivers/iommu/amd_iommu_types.h                    |   2 +-
 drivers/iommu/arm-smmu-v3.c                        |   3 +-
 drivers/iommu/dmar.c                               |   1 -
 drivers/iommu/intel-iommu.c                        |  15 +-
 drivers/iommu/intel-pasid.c                        |  12 +-
 drivers/iommu/intel-svm.c                          |   9 +-
 drivers/iommu/iova.c                               |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  13 +-
 drivers/irqchip/irq-gic-v3.c                       |   9 +-
 drivers/irqchip/irq-mbigen.c                       |   1 +
 drivers/isdn/capi/kcapi_proc.c                     |   2 +-
 drivers/leds/leds-pca963x.c                        |   8 +-
 drivers/md/bcache/bset.h                           |   3 +-
 drivers/md/bcache/journal.c                        |   3 +-
 drivers/md/bcache/stats.c                          |  10 +-
 drivers/md/bcache/super.c                          |  79 +--
 drivers/md/dm-raid.c                               |  43 +-
 drivers/md/dm-thin.c                               |  18 +-
 drivers/media/i2c/mt9v032.c                        |  10 +-
 drivers/media/i2c/ov5640.c                         |   2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |  24 +
 drivers/media/pci/cx23885/cx23885-video.c          |   3 +-
 drivers/media/pci/cx23885/cx23885.h                |   1 +
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |   6 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c |  22 +
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h |   4 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c |  20 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  25 +
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/misc/xilinx_sdfec.c                        |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   1 +
 drivers/net/ethernet/cisco/enic/enic_main.c        |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   4 +-
 drivers/net/ethernet/freescale/gianfar.c           |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   8 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |   3 +-
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  14 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   9 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |  96 ++--
 drivers/net/phy/fixed_phy.c                        |   7 +-
 drivers/net/phy/realtek.c                          |  19 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   5 +
 drivers/net/wan/hdlc_x25.c                         |  13 +-
 drivers/net/wan/ixp4xx_hss.c                       |   4 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   5 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   5 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   3 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   5 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  13 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   7 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   5 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   4 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |   2 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   3 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  10 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  12 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   5 +
 drivers/nfc/port100.c                              |   2 +-
 drivers/nvme/host/pci.c                            |  23 +-
 drivers/nvme/target/core.c                         |  17 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   2 +-
 drivers/nvme/target/io-cmd-file.c                  |   2 +-
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/opp/of.c                                   |  17 +-
 drivers/pci/ats.c                                  |   2 +
 drivers/pci/controller/pcie-iproc.c                |  24 +
 drivers/pci/pci.c                                  |  24 +-
 drivers/pci/pci.h                                  |   3 +
 drivers/pci/quirks.c                               |  99 ++--
 drivers/pci/search.c                               |   4 +-
 drivers/perf/fsl_imx8_ddr_perf.c                   |  16 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |   8 +-
 drivers/pinctrl/intel/pinctrl-tigerlake.c          | 547 ++++++++++-----------
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |   9 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |  39 +-
 drivers/pwm/pwm-omap-dmtimer.c                     |  35 +-
 drivers/pwm/pwm-pca9685.c                          |   4 -
 drivers/regulator/core.c                           |   2 +
 drivers/regulator/rk808-regulator.c                |   2 +-
 drivers/regulator/vctrl-regulator.c                |  38 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |   1 -
 drivers/remoteproc/remoteproc_core.c               |   2 +-
 drivers/reset/reset-uniphier.c                     |  13 +-
 drivers/rtc/Kconfig                                |   8 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/scsi/iscsi_tcp.c                           |   4 +
 drivers/scsi/lpfc/lpfc_ct.c                        |  42 +-
 drivers/scsi/scsi_transport_iscsi.c                |  26 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |  11 +
 drivers/scsi/ufs/ufs-qcom.c                        |   3 +-
 drivers/scsi/ufs/ufshcd.c                          |  32 +-
 drivers/scsi/ufs/ufshcd.h                          |   9 +-
 drivers/soc/fsl/qe/qe_common.c                     |  29 +-
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |   2 +-
 drivers/spi/spi-fsl-lpspi.c                        |  32 +-
 drivers/spi/spi-fsl-qspi.c                         |   2 +-
 drivers/staging/media/meson/vdec/vdec.c            |   2 +
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   9 +-
 drivers/staging/wfx/data_tx.c                      |  14 +-
 drivers/tty/synclink_gt.c                          |  18 +-
 drivers/tty/synclinkmp.c                           |  24 +-
 drivers/uio/uio_dmem_genirq.c                      |   6 +-
 drivers/usb/dwc2/gadget.c                          |   3 +-
 drivers/usb/dwc3/host.c                            |   6 +-
 drivers/usb/gadget/udc/gr_udc.c                    |  16 +-
 drivers/usb/musb/omap2430.c                        |   2 -
 drivers/vfio/pci/vfio_pci_nvlink2.c                |   6 +-
 drivers/video/backlight/qcom-wled.c                |   4 +-
 drivers/video/fbdev/Kconfig                        |   1 +
 drivers/video/fbdev/hyperv_fb.c                    | 182 +++++--
 drivers/video/fbdev/pxa168fb.c                     |   6 +-
 drivers/virtio/virtio_balloon.c                    |   2 +
 drivers/visorbus/visorchipset.c                    |  11 +-
 drivers/vme/bridges/vme_fake.c                     |  30 +-
 fs/btrfs/check-integrity.c                         |   3 +-
 fs/btrfs/ctree.h                                   |  20 +-
 fs/btrfs/file-item.c                               |   3 +-
 fs/btrfs/inode.c                                   | 121 ++++-
 fs/btrfs/volumes.c                                 |  44 +-
 fs/ceph/mds_client.c                               |   3 +-
 fs/ceph/super.c                                    |   5 +
 fs/cifs/cifs_dfs_ref.c                             |  97 ++--
 fs/cifs/connect.c                                  |   6 +-
 fs/cifs/dfs_cache.c                                |   2 +-
 fs/cifs/smb2pdu.c                                  |   3 +
 fs/ext4/file.c                                     |  10 +-
 fs/ext4/readpage.c                                 |  17 +-
 fs/f2fs/data.c                                     |  13 -
 fs/f2fs/file.c                                     |  50 +-
 fs/f2fs/namei.c                                    |  27 +-
 fs/f2fs/sysfs.c                                    |  12 +-
 fs/fuse/file.c                                     |  12 +
 fs/jbd2/checkpoint.c                               |   2 +-
 fs/jbd2/commit.c                                   |   4 +-
 fs/jbd2/journal.c                                  |  24 +-
 fs/nfs/nfs42proc.c                                 |   4 +-
 fs/nfs/nfs4xdr.c                                   |  10 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/vfs.c                                      |  19 +-
 fs/ocfs2/dlm/Makefile                              |   2 -
 fs/ocfs2/dlm/dlmast.c                              |   8 +-
 fs/ocfs2/dlm/dlmconvert.c                          |   8 +-
 fs/ocfs2/dlm/dlmdebug.c                            |   8 +-
 fs/ocfs2/dlm/dlmdomain.c                           |   8 +-
 fs/ocfs2/dlm/dlmlock.c                             |   8 +-
 fs/ocfs2/dlm/dlmmaster.c                           |   8 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |   8 +-
 fs/ocfs2/dlm/dlmthread.c                           |   8 +-
 fs/ocfs2/dlm/dlmunlock.c                           |   8 +-
 fs/ocfs2/dlmfs/Makefile                            |   2 -
 fs/ocfs2/dlmfs/dlmfs.c                             |   4 +-
 fs/ocfs2/dlmfs/userdlm.c                           |   6 +-
 fs/ocfs2/journal.h                                 |   8 +-
 fs/orangefs/orangefs-debugfs.c                     |   1 +
 fs/reiserfs/stree.c                                |   3 +-
 fs/reiserfs/super.c                                |   2 +-
 fs/udf/super.c                                     |  23 +-
 include/dt-bindings/clock/qcom,gcc-msm8998.h       |   1 +
 include/linux/cpuhotplug.h                         |   1 +
 include/linux/devfreq.h                            |   4 +-
 include/linux/dmaengine.h                          |   2 +
 include/linux/list_nulls.h                         |   8 +-
 include/linux/pci.h                                |   2 +-
 include/linux/platform_data/ti-sysc.h              |   1 +
 include/linux/raid/pq.h                            |   3 +-
 include/linux/rculist_nulls.h                      |   8 +-
 include/media/v4l2-device.h                        |  12 +-
 include/rdma/ib_verbs.h                            |   9 +-
 include/rdma/uverbs_types.h                        |   1 -
 include/soc/fsl/qe/qe.h                            |  16 +-
 include/trace/events/rcu.h                         |   4 +-
 kernel/bpf/inode.c                                 |   3 +-
 kernel/cpu.c                                       |  13 +-
 kernel/kprobes.c                                   |  67 ++-
 kernel/module.c                                    |  20 +-
 kernel/padata.c                                    |  34 +-
 kernel/printk/printk.c                             |   4 +-
 kernel/rcu/tree.c                                  |  11 +-
 kernel/rcu/tree_exp.h                              |   2 +-
 kernel/rcu/tree_plugin.h                           |  22 +-
 kernel/sched/core.c                                |   3 +-
 kernel/sched/topology.c                            |  39 ++
 kernel/time/alarmtimer.c                           |  20 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace_events_hist.c                   | 123 ++---
 kernel/trace/trace_events_trigger.c                |   5 +-
 kernel/trace/trace_stat.c                          |  31 +-
 kernel/watchdog.c                                  |  10 +-
 lib/debugobjects.c                                 |  46 +-
 lib/kunit/try-catch.c                              |  22 +-
 lib/raid6/mktables.c                               |   2 +-
 lib/scatterlist.c                                  |   2 +-
 net/core/dev.c                                     |   4 +-
 net/core/filter.c                                  |   2 +-
 net/core/sock_map.c                                |   3 +
 net/dsa/tag_qca.c                                  |   2 +-
 net/netfilter/nft_tunnel.c                         |   3 +-
 net/sched/cls_flower.c                             |   1 +
 net/sched/cls_matchall.c                           |   1 +
 net/smc/smc_diag.c                                 |   5 +-
 net/sunrpc/cache.c                                 |   2 +
 samples/bpf/Makefile                               |   1 +
 scripts/Kbuild.include                             |  15 +-
 scripts/Kconfig.include                            |   2 +-
 scripts/kconfig/confdata.c                         |   2 +-
 scripts/link-vmlinux.sh                            |   4 +-
 security/integrity/ima/ima_main.c                  |   3 +
 security/selinux/avc.c                             |  53 +-
 sound/core/control.c                               |   5 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_hdmi.c                         |   7 +-
 sound/pci/hda/patch_realtek.c                      |  10 +-
 sound/sh/aica.c                                    |   4 +-
 sound/sh/sh_dac_audio.c                            |   3 -
 sound/soc/atmel/Kconfig                            |   2 +
 sound/soc/codecs/wm_adsp.c                         |  98 ++--
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |  14 +-
 sound/soc/intel/boards/bxt_rt298.c                 |  14 +-
 sound/soc/intel/boards/cml_rt1011_rt5682.c         |  13 +-
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |  16 +-
 sound/soc/intel/boards/sof_rt5682.c                |  58 ++-
 sound/soc/soc-topology.c                           |  42 +-
 sound/soc/sof/intel/apl.c                          |   1 -
 sound/soc/sof/intel/cnl.c                          |   5 -
 sound/soc/sof/intel/hda-dai.c                      |   3 -
 sound/soc/sof/intel/hda-ipc.c                      |  23 +-
 sound/soc/sof/intel/hda-stream.c                   |  20 +-
 sound/soc/sof/intel/hda.c                          |  69 ++-
 sound/soc/sof/intel/hda.h                          |  13 +-
 sound/soc/txx9/txx9aclc.c                          |   1 -
 sound/usb/card.c                                   |   4 +
 sound/usb/format.c                                 |   3 +
 sound/usb/pcm.c                                    |   4 +
 sound/usb/quirks.c                                 |  38 ++
 sound/usb/quirks.h                                 |   5 +
 sound/usb/usx2y/usX2Yhwdep.c                       |   2 +-
 tools/arch/x86/lib/x86-opcode-map.txt              |   2 +-
 tools/bpf/bpftool/cgroup.c                         |  56 ++-
 tools/lib/api/fs/fs.c                              |   4 +-
 tools/objtool/Makefile                             |   6 +-
 .../testing/selftests/bpf/test_select_reuseport.c  |  16 +-
 tools/testing/selftests/cgroup/test_core.c         |   2 +-
 tools/testing/selftests/kselftest/runner.sh        |   2 +-
 tools/testing/selftests/net/so_txtime.c            |  84 +++-
 tools/testing/selftests/net/so_txtime.sh           |   9 +-
 .../testing/selftests/powerpc/eeh/eeh-functions.sh |  10 +-
 tools/testing/selftests/size/get_size.c            |  24 +-
 .../tc-testing/tc-tests/filters/basic.json         |  51 ++
 tools/usb/usbip/src/usbip_network.c                |  40 +-
 tools/usb/usbip/src/usbip_network.h                |  12 +-
 450 files changed, 4343 insertions(+), 2389 deletions(-)


