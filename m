Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8802F2FA41C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405542AbhARPG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389067AbhARLml (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD32D2222A;
        Mon, 18 Jan 2021 11:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970108;
        bh=OWbgpe7Qk8Y42KjbUYYbcen3N7e3Q6RTy+Tu+Wy+m9c=;
        h=From:To:Cc:Subject:Date:From;
        b=n77VKwfaiQTgFEkDNIlyw1osQ1W52eFGfbz38U3HRqL/no8jXwgoB8mGLfulfF8jE
         KcCzmyzYwZd2VdQZxy52r+/W5Actsty3qf46sSA7WVqaPiEfWh7vccgeDJ8nhfXZf2
         39DjwxYfKBc/DMlsMUN+i0/J1S1avwjmaEFEbfX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 000/152] 5.10.9-rc1 review
Date:   Mon, 18 Jan 2021 12:32:55 +0100
Message-Id: <20210118113352.764293297@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.9-rc1
X-KernelTest-Deadline: 2021-01-20T11:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.9 release.
There are 152 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.9-rc1

Dinghao Liu <dinghao.liu@zju.edu.cn>
    netfilter: nf_nat: Fix memleak in nf_nat_init

Jesper Dangaard Brouer <brouer@redhat.com>
    netfilter: conntrack: fix reading nf_conntrack_buckets

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: firewire-tascam: Fix integer overflow in midi_port_work()

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: fireface: Fix integer overflow in transmit_midi_msg()

Mike Snitzer <snitzer@redhat.com>
    dm: eliminate potential source of excessive kernel log noise

Chen Yi <yiche@redhat.com>
    selftests: netfilter: Pass family parameter "-f" to conntrack tool

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: sunrpc: interpret the return value of kstrtou32 correctly

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix unaligned addresses for intel_flush_svm_range_dev()

Atish Patra <atish.patra@wdc.com>
    riscv: Trace irq on only interrupt is enabled

Jann Horn <jannh@google.com>
    mm, slub: consider rest of partial list if acquire_slab() fails

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail

Imre Deak <imre.deak@intel.com>
    drm/i915/icl: Fix initing the DSI DSC power refcount during HW readout

Hans de Goede <hdegoede@redhat.com>
    drm/i915/dsi: Use unconditional msleep for the panel_on_delay when there is no reset-deassert MIPI-sequence

Arnd Bergmann <arnd@arndb.de>
    dm zoned: select CONFIG_CRC32

Al Viro <viro@zeniv.linux.org.uk>
    umount(2): move the flag validity checks first

Parav Pandit <parav@nvidia.com>
    IB/mlx5: Fix error unwinding when set_has_smi_cap fails

Mark Bloch <mbloch@nvidia.com>
    RDMA/mlx5: Fix wrong free of blue flame register on error

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve stats context resource accounting with RDMA driver loaded.

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp

Leon Romanovsky <leon@kernel.org>
    RDMA/restrack: Don't treat as an error allocation ID wrapping

Jan Kara <jack@suse.cz>
    ext4: fix superblock checksum failure when setting password salt

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix possible power drain during system suspend

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_igrab_and_active must first reference the superblock

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_delegation_find_inode_server must first reference the superblock

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pNFS: Fix a leak of the layout 'plh_outstanding' counter

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pNFS: Don't leak DS commits in pnfs_generic_retry_commit()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pNFS: Don't call pnfs_free_bucket_lseg() before removing the request

Scott Mayhew <smayhew@redhat.com>
    NFS: Adjust fs_context error logging

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Stricter ordering of layoutget and layoutreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Mark layout for return if return-on-close was not sent

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: We want return-on-close to complete when evicting the inode

Dave Wysochanski <dwysocha@redhat.com>
    NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: Fix warning with CONFIG_DEBUG_PREEMPT

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible data corruption with bio merges

Sagi Grimberg <sagi@grimberg.me>
    nvme: don't intialize hwmon for discovery controllers

Israel Rukshin <israelr@nvidia.com>
    nvmet-rdma: Fix NULL deref when setting pi_enable and traddr INADDR_ANY

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: Intel: fix error code cnl_set_dsp_D0()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdmin: fix axg skew offset

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: fix loopback

Al Viro <viro@zeniv.linux.org.uk>
    dump_common_audit_data(): fix racy accesses to ->d_name

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix 'CPU too large' error

Linus Torvalds <torvalds@linux-foundation.org>
    mm: don't put pinned pages into the swap cache

Linus Torvalds <torvalds@linux-foundation.org>
    mm: don't play games with pinned pages in clear_page_refs

Linus Torvalds <torvalds@linux-foundation.org>
    mm: fix clear_refs_write locking

John Garry <john.garry@huawei.com>
    blk-mq-debugfs: Add decode for BLK_MQ_F_TAG_HCTX_SHARED

Alaa Hleihel <alaa@nvidia.com>
    net/mlx5: E-Switch, fix changing vf VLANID

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: Fix passing zero to 'PTR_ERR'

Oz Shlomo <ozsh@nvidia.com>
    net/mlx5e: CT: Use per flow counter when CT flow accounting is enabled

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Update domain geometry in iommu_ops.at(de)tach_dev

James Smart <james.smart@broadcom.com>
    nvme-fc: avoid calling _nvme_fc_abort_outstanding_ios from interrupt context

Arnd Bergmann <arnd@arndb.de>
    cfg80211: select CONFIG_CRC32

Peter Gonda <pgonda@google.com>
    x86/sev-es: Fix SEV-ES OUT/IN immediate opcode vc handling

Jonathan Lemon <bsd@fb.com>
    bpf: Save correct stopping point in file seq iteration

Song Liu <songliubraving@fb.com>
    bpf: Simplify task_file_seq_get_next()

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu-tasks: Move RCU-tasks initialization to before early_initcall()

Linus Torvalds <torvalds@linux-foundation.org>
    poll: fix performance regression due to out-of-line __put_user()

Arnd Bergmann <arnd@arndb.de>
    ARM: picoxcell: fix missing interrupt-parent properties

Craig Tatlor <ctatlor97@gmail.com>
    drm/msm: Call msm_init_vram before binding the gpu

Shawn Guo <shawn.guo@linaro.org>
    ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix lockdep splat in sva bind()/unbind()

Peter Robinson <pbrobinson@gmail.com>
    usb: typec: Fix copy paste error for NVIDIA alt-mode description

Jiawei Gu <Jiawei.Gu@amd.com>
    drm/amdgpu: fix potential memory leak during navi12 deinitialization

Xiaojian Du <Xiaojian.Du@amd.com>
    drm/amd/pm: fix the failure when change power profile for renoir

Dennis Li <Dennis.Li@amd.com>
    drm/amdgpu: fix a GPU hang issue when remove device

Kevin Wang <kevin1.wang@amd.com>
    drm/amd/display: fix sysfs amdgpu_current_backlight_pwm NULL pointer issue

Israel Rukshin <israelr@nvidia.com>
    nvmet-rdma: Fix list_del corruption on queue establishment failure

Lalithambika Krishnakumar <lalithambika.krishnakumar@intel.com>
    nvme: avoid possible double fetch in handling CQE

Gopal Tiwari <gtiwari@redhat.com>
    nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: fix the return value for UDP GRO test

Michael Ellerman <mpe@ellerman.id.au>
    net: ethernet: fs_enet: Add missing MODULE_LICENSE

Arnd Bergmann <arnd@arndb.de>
    misdn: dsp: select CONFIG_BITREVERSE

Randy Dunlap <rdunlap@infradead.org>
    arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Jan Kara <jack@suse.cz>
    bfq: Fix computation of shallow depth

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: drop file refs after task cancel

Xu Yilun <yilun.xu@intel.com>
    spi: fix the divide by 0 error when calculating xfer waiting time

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: remove 'kvmconfig' and 'xenconfig' shorthands

John Millikin <john@john-millikin.com>
    lib/raid6: Let $(UNROLL) rules work with macOS userland

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    hwmon: (pwm-fan) Ensure that calculation doesn't discard big period values

Dinghao Liu <dinghao.liu@zju.edu.cn>
    habanalabs: Fix memleak in hl_device_reset

Xu Yilun <yilun.xu@intel.com>
    spi: altera: fix return value for altera_spi_txrx()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: spmi: hisi-spmi-controller: Fix some error handling paths

Oded Gabbay <ogabbay@kernel.org>
    habanalabs: register to pci shutdown callback

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: retry loading TPC f/w on -EINTR

Oded Gabbay <ogabbay@kernel.org>
    habanalabs: adjust pci controller init to new firmware

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500/golden: Set display max brightness

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Guido Günther <agx@sigxcpu.org>
    regulator: bd718x7: Add enable times

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan

Pavel Begunkov <asml.silence@gmail.com>
    btrfs: merge critical sections of discard lock in workfn

Pavel Begunkov <asml.silence@gmail.com>
    btrfs: fix async discard stall

Carl Huang <cjhuang@codeaurora.org>
    ath11k: qmi: try to allocate a big block of DMA memory first

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ipset: fixes possible oops in mtype_resize

Carl Huang <cjhuang@codeaurora.org>
    ath11k: fix crash caused by NULL rx_channel

Carl Philipp Klemm <philipp@uvos.xyz>
    ARM: omap2: pmic-cpcap: fix maximum voltage to be consistent with defaults on xt875

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: move symlink creation to arch/arc/Makefile to avoid race

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add boot_targets to PHONY

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add uImage.lzma to the top-level target

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: remove non-existing bootpImage from KBUILD_IMAGE

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: drop mm and files after task_work_run

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't take files/mm for a dead task

Theodore Ts'o <tytso@mit.edu>
    ext4: don't leak old mountpoint samples

Su Yue <l@damenly.su>
    btrfs: tree-checker: check if chunk item end overflows

Leon Schuermann <leon@is.currently.online>
    r8152: Add Lenovo Powered USB-C Travel Hub

Voon Weifeng <weifeng.voon@intel.com>
    stmmac: intel: change all EHL/TGL to auto detect phy addr

Ignat Korchagin <ignat@cloudflare.com>
    dm crypt: defer decryption to a tasklet if interrupts disabled

Ignat Korchagin <ignat@cloudflare.com>
    dm crypt: do not call bio_endio() from the dm-crypt tasklet

Ignat Korchagin <ignat@cloudflare.com>
    dm crypt: do not wait for backlogged crypto request completion in softirq

Ignat Korchagin <ignat@cloudflare.com>
    dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix the maximum number of arguments

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix flush with external metadata device

Akilesh Kailash <akailash@google.com>
    dm snapshot: flush merged data before committing metadata

Mike Snitzer <snitzer@redhat.com>
    dm raid: fix discard limits for raid1

Andrew Morton <akpm@linux-foundation.org>
    mm/process_vm_access.c: include compat.h

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential missing huge page size info

Miaohe Lin <linmiaohe@huawei.com>
    mm/vmalloc.c: fix potential memory leak

Will Deacon <will@kernel.org>
    compiler.h: Raise minimum version of GCC to 5.1 for arm64

Roger Pau Monne <roger.pau@citrix.com>
    xen/privcmd: allow fetching resource sizes

Dexuan Cui <decui@microsoft.com>
    ACPI: scan: Harden acpi_device_add() against device ID overflows

Tom Rix <trix@redhat.com>
    RDMA/ocrdma: Fix use after free in ocrdma_dealloc_ucontext_pd()

Alexander Lobakin <alobakin@pm.me>
    MIPS: relocatable: fix possible boot hangup with KASLR enabled

Al Viro <viro@zeniv.linux.org.uk>
    MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Paul Cercueil <paul@crapouillou.net>
    MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Anders Roxell <anders.roxell@linaro.org>
    mips: lib: uncached: fix non-standard usage of variable 'sp'

Anders Roxell <anders.roxell@linaro.org>
    mips: fix Section mismatch in reference

Nick Hu <nickhu@andestech.com>
    riscv: Fix KASAN memory mapping.

Guo Ren <guoren@linux.alibaba.com>
    riscv: Fixup CONFIG_GENERIC_TIME_VSYSCALL

Andreas Schwab <schwab@suse.de>
    riscv: return -ENOSYS for syscall -1

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Drop a duplicated PAGE_KERNEL_EXEC

Paulo Alcantara <pc@cjr.nz>
    cifs: fix interrupted close commands

Tom Rix <trix@redhat.com>
    cifs: check pointer before freeing

yangerkun <yangerkun@huawei.com>
    ext4: fix bug for rename with RENAME_WHITEOUT

Daejun Park <daejun7.park@samsung.com>
    ext4: fix wrong list_splice in ext4_fc_cleanup

Yi Li <yili@winhong.com>
    ext4: use IS_ERR instead of IS_ERR_OR_NULL and set inode null when IS_ERR

Masami Hiramatsu <mhiramat@kernel.org>
    tools/bootconfig: Add tracing_on support to helper scripts

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobes: Do the notrace functions check without kprobes on ftrace

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    drm/bridge: sii902x: Enable I/O and core VCC supplies if present

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    dt-bindings: display: sii902x: Add supply bindings

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    drm/bridge: sii902x: Refactor init code into separate function

Jani Nikula <jani.nikula@intel.com>
    drm/i915/backlight: fix CPU mode backlight takeover on LPT

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Limit VFE threads based on GT

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Allow the sysadmin to override security mitigations

mengwang <mengbing.wang@amd.com>
    drm/amdgpu: add new device id for Renior

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    Revert "drm/amd/display: Fixed Intermittent blue screen on OLED panel"

Alexandre Demers <alexandre.f.demers@gmail.com>
    drm/amdgpu: fix DRM_INFO flood if display core is not supported (bug 210921)

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: add green_sardine device id (v2)

Wei Liu <wei.liu@kernel.org>
    x86/hyperv: check cpu mask after interrupt has been disabled

Thomas Hebb <tommyhebb@gmail.com>
    ASoC: dapm: remove widget from dirty list on free

Jaroslav Kysela <perex@perex.cz>
    ASoC: AMD Renoir - add DMI entry for Lenovo ThinkPad X395

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    ALSA: doc: Fix reference to mixart.rst

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machines

Su Yue <l@damenly.su>
    btrfs: prevent NULL pointer dereference in extent_io_tree_panic

Qu Wenruo <wqu@suse.com>
    btrfs: reloc: fix wrong file extent type check to avoid false ENOENT


-------------

Diffstat:

 .../devicetree/bindings/display/bridge/sii902x.txt |   4 +
 Documentation/sound/alsa-configuration.rst         |   2 +-
 Makefile                                           |   4 +-
 arch/arc/Makefile                                  |  20 ++-
 arch/arc/boot/Makefile                             |  11 +-
 arch/arc/include/asm/page.h                        |   1 +
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |   4 +
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts     |   1 +
 arch/arm/mach-omap2/pmic-cpcap.c                   |   2 +-
 arch/mips/boot/compressed/decompress.c             |   3 +-
 arch/mips/kernel/binfmt_elfn32.c                   |   7 +
 arch/mips/kernel/binfmt_elfo32.c                   |   7 +
 arch/mips/kernel/relocate.c                        |  10 +-
 arch/mips/lib/uncached.c                           |   4 +-
 arch/mips/mm/c-r4k.c                               |   2 +-
 arch/mips/mm/sc-mips.c                             |   4 +-
 arch/riscv/include/asm/pgtable.h                   |   1 -
 arch/riscv/include/asm/vdso.h                      |   2 +-
 arch/riscv/kernel/entry.S                          |  15 +-
 arch/riscv/kernel/vdso.c                           |   2 +-
 arch/riscv/mm/kasan_init.c                         |   4 +-
 arch/x86/hyperv/mmu.c                              |  12 +-
 arch/x86/kernel/sev-es-shared.c                    |   4 +-
 block/bfq-iosched.c                                |   8 +-
 block/blk-mq-debugfs.c                             |   1 +
 drivers/acpi/internal.h                            |   2 +-
 drivers/acpi/scan.c                                |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |  18 ++-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   7 +-
 .../display/dc/dml/dcn20/display_mode_vba_20v2.c   |  11 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |   1 +
 drivers/gpu/drm/bridge/sii902x.c                   | 100 +++++++-----
 drivers/gpu/drm/i915/Makefile                      |   1 +
 drivers/gpu/drm/i915/display/icl_dsi.c             |   4 -
 drivers/gpu/drm/i915/display/intel_panel.c         |   9 +-
 drivers/gpu/drm/i915/display/vlv_dsi.c             |  16 +-
 drivers/gpu/drm/i915/gt/gen7_renderclear.c         | 157 +++++++++++--------
 drivers/gpu/drm/i915/gt/intel_ring_submission.c    |   6 +-
 drivers/gpu/drm/i915/i915_mitigations.c            | 146 ++++++++++++++++++
 drivers/gpu/drm/i915/i915_mitigations.h            |  13 ++
 drivers/gpu/drm/msm/msm_drv.c                      |   8 +-
 drivers/hwmon/pwm-fan.c                            |  12 +-
 drivers/infiniband/core/restrack.c                 |   1 +
 drivers/infiniband/hw/mlx5/main.c                  |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   3 +
 drivers/iommu/intel/iommu.c                        |  16 +-
 drivers/iommu/intel/svm.c                          |  36 ++++-
 drivers/isdn/mISDN/Kconfig                         |   1 +
 drivers/md/Kconfig                                 |   1 +
 drivers/md/dm-bufio.c                              |   6 +
 drivers/md/dm-crypt.c                              | 170 ++++++++++++++++++---
 drivers/md/dm-integrity.c                          |  62 ++++++--
 drivers/md/dm-raid.c                               |   6 +-
 drivers/md/dm-snap.c                               |  24 +++
 drivers/md/dm.c                                    |   2 +-
 drivers/misc/habanalabs/common/device.c            |   2 +
 drivers/misc/habanalabs/common/habanalabs_drv.c    |   1 +
 drivers/misc/habanalabs/common/pci.c               |  28 ++--
 drivers/misc/habanalabs/gaudi/gaudi.c              |  14 +-
 drivers/misc/habanalabs/gaudi/gaudi_coresight.c    |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   8 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |   1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |   1 +
 drivers/net/ethernet/freescale/ucc_geth.h          |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  77 ++++++----
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  27 ++--
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   6 +-
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  10 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |  24 ++-
 drivers/net/wireless/ath/ath11k/qmi.h              |   1 +
 drivers/nvme/host/core.c                           |  11 +-
 drivers/nvme/host/fc.c                             |  15 +-
 drivers/nvme/host/pci.c                            |  10 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/rdma.c                         |  26 +++-
 drivers/regulator/bd718x7-regulator.c              |  57 +++++++
 drivers/scsi/ufs/ufshcd.c                          |   3 +-
 drivers/spi/spi-altera.c                           |  26 ++--
 drivers/spi/spi.c                                  |   6 +-
 drivers/staging/hikey9xx/hisi-spmi-controller.c    |  21 ++-
 drivers/usb/typec/altmodes/Kconfig                 |   2 +-
 drivers/xen/privcmd.c                              |  25 ++-
 fs/btrfs/discard.c                                 |  60 ++++----
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/qgroup.c                                  |  13 +-
 fs/btrfs/relocation.c                              |   7 +-
 fs/btrfs/super.c                                   |   8 +
 fs/btrfs/tree-checker.c                            |   7 +
 fs/cifs/dfs_cache.c                                |   3 +-
 fs/cifs/smb2pdu.c                                  |   2 +-
 fs/ext4/fast_commit.c                              |  25 +--
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/ioctl.c                                    |   3 +
 fs/ext4/namei.c                                    |  17 ++-
 fs/io_uring.c                                      |  29 ++--
 fs/namespace.c                                     |   7 +-
 fs/nfs/delegation.c                                |  12 +-
 fs/nfs/internal.h                                  |  38 ++++-
 fs/nfs/nfs4proc.c                                  |  28 ++--
 fs/nfs/nfs4super.c                                 |   4 +-
 fs/nfs/pnfs.c                                      |  58 +++----
 fs/nfs/pnfs.h                                      |   8 +-
 fs/nfs/pnfs_nfs.c                                  |  22 ++-
 fs/proc/task_mmu.c                                 |  53 ++++---
 fs/select.c                                        |  14 +-
 include/linux/acpi.h                               |   7 +
 include/linux/compiler-gcc.h                       |   6 +
 include/linux/dm-bufio.h                           |   1 +
 include/linux/rcupdate.h                           |   6 +
 init/main.c                                        |   1 +
 kernel/bpf/task_iter.c                             |  57 +++----
 kernel/rcu/tasks.h                                 |  25 ++-
 kernel/trace/Kconfig                               |   2 +-
 kernel/trace/trace_kprobe.c                        |   2 +-
 lib/raid6/Makefile                                 |   2 +-
 mm/hugetlb.c                                       |   2 +-
 mm/process_vm_access.c                             |   1 +
 mm/slub.c                                          |   2 +-
 mm/vmalloc.c                                       |   4 +-
 mm/vmscan.c                                        |   2 +
 net/netfilter/ipset/ip_set_hash_gen.h              |  22 +--
 net/netfilter/nf_conntrack_standalone.c            |   3 +
 net/netfilter/nf_nat_core.c                        |   1 +
 net/sunrpc/addr.c                                  |   2 +-
 net/wireless/Kconfig                               |   1 +
 scripts/kconfig/Makefile                           |  10 --
 security/lsm_audit.c                               |   7 +-
 sound/firewire/fireface/ff-transaction.c           |   2 +-
 sound/firewire/tascam/tascam-transaction.c         |   2 +-
 sound/pci/hda/patch_realtek.c                      |   4 +
 sound/soc/amd/renoir/rn-pci-acp3x.c                |   7 +
 sound/soc/intel/skylake/cnl-sst.c                  |   1 +
 sound/soc/meson/axg-tdm-interface.c                |  14 +-
 sound/soc/meson/axg-tdmin.c                        |  13 +-
 sound/soc/soc-dapm.c                               |   1 +
 tools/bootconfig/scripts/bconf2ftrace.sh           |   1 +
 tools/bootconfig/scripts/ftrace2bconf.sh           |   4 +
 tools/perf/util/machine.c                          |   4 +-
 tools/perf/util/session.c                          |   2 +-
 tools/testing/selftests/net/udpgro.sh              |  34 +++++
 .../selftests/netfilter/nft_conntrack_helper.sh    |  12 +-
 151 files changed, 1520 insertions(+), 610 deletions(-)


