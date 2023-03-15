Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DEA6BB146
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjCOM0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbjCOMZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:25:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDC39AA24;
        Wed, 15 Mar 2023 05:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1A62CE19C0;
        Wed, 15 Mar 2023 12:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D50C433D2;
        Wed, 15 Mar 2023 12:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883093;
        bh=HxobUR7YsoVwribI8QOOk0cgyEyxSdfD1k5aCnEhznY=;
        h=From:To:Cc:Subject:Date:From;
        b=RZ6F6NM5S+B90/4jRXN9tYq/Ca35W+dWv8R9NqPhea7mw4rEl824orRVtpwqXKWtB
         eFUsZEti5g7t1a9uDr5QyI0rWrz653yiAXB9BZfRZrOGHT/mmlW5b+Qm50lDwjqzkH
         jd1H8e9lBtO2mQO75iqRfVIGC5smWhGiafsmkoUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/145] 5.15.103-rc1 review
Date:   Wed, 15 Mar 2023 13:11:06 +0100
Message-Id: <20230315115738.951067403@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.103-rc1
X-KernelTest-Deadline: 2023-03-17T11:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.103 release.
There are 145 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.103-rc1

Alexandru Matei <alexandru.matei@uipath.com>
    KVM: VMX: Fix crash due to uninitialized current_vmcs

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Don't use Enlightened MSR Bitmap for L3

Christian Brauner <christian.brauner@ubuntu.com>
    fs: hold writers when changing mount's idmapping

Masahiro Yamada <masahiroy@kernel.org>
    UML: define RUNTIME_DISCARD_EXIT

Gaosheng Cui <cuigaosheng1@huawei.com>
    xfs: remove xfs_setattr_time() declaration

Miaohe Lin <linmiaohe@huawei.com>
    KVM: fix memoryleak in kvm_init()

Andres Freund <andres@anarazel.de>
    tools bpftool: Fix compilation error with new binutils

Andres Freund <andres@anarazel.de>
    tools bpf_jit_disasm: Fix compilation error with new binutils

Andres Freund <andres@anarazel.de>
    tools perf: Fix compilation error with new binutils

Andres Freund <andres@anarazel.de>
    tools include: add dis-asm-compat.h to handle version differences

Andres Freund <andres@anarazel.de>
    tools build: Add feature test for init_disassemble_info API changes

Tom Saeger <tom.saeger@oracle.com>
    sh: define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    arch: fix broken BuildID for arm64 and riscv

Lukas Czerner <lczerner@redhat.com>
    ext4: block range must be validated before use in ext4_mb_clear_bb()

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: add strict range checks while freeing blocks

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: add ext4_sb_block_valid() refactored out of ext4_inode_block_valid()

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()

Qais Yousef <qyousef@layalina.io>
    sched/fair: Fixes for capacity inversion detection

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Fix a uninitialized variable warnings

Qais Yousef <qais.yousef@arm.com>
    sched/fair: Consider capacity inversion in util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/fair: Detect capacity inversion

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make cpu_overutilized() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix fits_capacity() check in feec()

Seth Forshee <sforshee@kernel.org>
    filelocks: use mount idmapping for setlease permission check

Li Jun <jun.li@nxp.com>
    media: rc: gpio-ir-recv: add remove function

Paul Elder <paul.elder@ideasonboard.com>
    media: ov5640: Fix analogue gain control

Masahiro Yamada <masahiroy@kernel.org>
    scripts: handle BrokenPipeError for python scripts

Alvaro Karsz <alvaro.karsz@solid-run.com>
    PCI: Avoid FLR for SolidRun SNET DPU rev 1

Alvaro Karsz <alvaro.karsz@solid-run.com>
    PCI: Add SolidRun vendor ID

Nathan Chancellor <nathan@kernel.org>
    macintosh: windfarm: Use unsigned type for 1-bit bitfields

Edward Humes <aurxenon@lunos.org>
    alpha: fix R_ALPHA_LITERAL reloc for large modules

Rohan McLure <rmclure@linux.ibm.com>
    powerpc/kcsan: Exclude udelay to prevent recursive instrumentation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    powerpc/iommu: fix memory leak with using debugfs_lookup()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Check !irq instead of irq == NO_IRQ and remove NO_IRQ

xurui <xurui@kylinos.cn>
    MIPS: Fix a compilation issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: mmcc-apq8084: remove spdm clocks

Christian Brauner <brauner@kernel.org>
    fs: use consistent setgid checks in is_sxid()

Christian Brauner <brauner@kernel.org>
    attr: use consistent sgid stripping checks

Christian Brauner <brauner@kernel.org>
    attr: add setattr_should_drop_sgid()

Christian Brauner <brauner@kernel.org>
    fs: move should_remove_suid()

Christian Brauner <brauner@kernel.org>
    attr: add in_group_or_capable()

Yang Xu <xuyang2018.jy@fujitsu.com>
    fs: move S_ISGID stripping into the vfs_*() helpers

Yang Xu <xuyang2018.jy@fujitsu.com>
    fs: add mode_strip_sgid() helper

Dave Chinner <dchinner@redhat.com>
    xfs: set prealloc flag in xfs_alloc_file_space()

Dave Chinner <dchinner@redhat.com>
    xfs: fallocate() should call file_modified()

Dave Chinner <dchinner@redhat.com>
    xfs: remove XFS_PREALLOC_SYNC

Darrick J. Wong <djwong@kernel.org>
    xfs: use setattr_copy to set vfs inode attributes

Morten Linderud <morten@linderud.pw>
    tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address

David Disseldorp <ddiss@suse.de>
    watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Fix key-store index handling

Hannes Braun <hannesbraun@mail.de>
    staging: rtl8723bs: fix placement of braces

Jagath Jog J <jagathjog1996@gmail.com>
    Staging: rtl8723bs: Placing opening { braces in previous line

Michael Straube <straube.linux@gmail.com>
    staging: rtl8723bs: clean up comparsions to NULL

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands

Christoph Hellwig <hch@lst.de>
    nbd: use the correct block_device in nbd_bdev_reset

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix mapping-creation race

Jan Kara <jack@suse.cz>
    ext4: Fix deadlock during directory rename

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: Don't check text_mutex during stop_machine

Heiko Carstens <hca@linux.ibm.com>
    s390/ftrace: remove dead code

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Eric Dumazet <edumazet@google.com>
    af_unix: fix struct pid leaks in OOB support

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a server shutdown leak

Suman Ghosh <sumang@marvell.com>
    octeontx2-af: Unlock contexts in the queue context cache in case of fault detection

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix fallback failed while sendmsg with fastopen

Randy Dunlap <rdunlap@infradead.org>
    platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it

Eric Dumazet <edumazet@google.com>
    netfilter: conntrack: adopt safer max chain length

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Update max supported LD IDs to 240

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix RX data corruption issue

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: smsc: fix link up detection in forced irq mode

Lukas Wunner <lukas@wunner.de>
    net: phy: smsc: Cache interrupt mask

Lorenz Bauer <lorenz.bauer@isovalent.com>
    btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Florian Westphal <fw@strlen.de>
    netfilter: tproxy: fix deadlock due to missing BH disable

Ivan Delalande <colona@arista.com>
    netfilter: ctnetlink: revert to dumping mark regardless of event type

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Avoid order-5 memory allocation for TPA data

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylib: get rid of unnecessary locking

Rongguang Wei <weirongguang@kylinos.cn>
    net: stmmac: add to set device wake up flag when stmmac init phy

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix len of sc7180 ctl blocks

Liu Jian <liujian56@huawei.com>
    bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()

Petr Oros <poros@redhat.com>
    ice: copy last block omitted in ice_get_module_eeprom()

Shigeru Yoshida <syoshida@redhat.com>
    net: caif: Fix use-after-free in cfusbl_device_notify()

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Changbin Du <changbin.du@huawei.com>
    perf stat: Fix counting when initial delay configured

Hangbin Liu <liuhangbin@gmail.com>
    selftests: nft_nat: ensuring the listening side is up before starting the client

Eric Dumazet <edumazet@google.com>
    ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Vladimir Oltean <vladimir.oltean@nxp.com>
    powerpc: dts: t1040rdb: fix compatible string for Rev A boards

Kang Chen <void0red@gmail.com>
    nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Rafał Miłecki <rafal@milecki.pl>
    bgmac: fix *initial* chip reset to support BCM5358

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a5xx: fix context faults during ring switch

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a5xx: fix the emptyness check in the preempt code

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a5xx: fix highest bank bit for a530

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix potential invalid ptr free

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/nv50-: remove unused functions

Jan Kara <jack@suse.cz>
    ext4: Fix possible corruption when moving a directory

Matthias Kaehlcke <mka@chromium.org>
    regulator: core: Use ktime_get_boottime() to determine how long a regulator was off

Christian Kohlschütter <christian@kohlschutter.com>
    regulator: core: Fix off-on-delay-us for always-on/boot-on regulators

Mark Brown <broonie@kernel.org>
    regulator: Flag uncontrollable regulators as always_on

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Liao Chang <liaochang1@huawei.com>
    riscv: Add header include guards to insn.h

Mattias Nissler <mnissler@rivosinc.com>
    riscv: Avoid enabling interrupts in die()

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Avoid dereferening NULL regs in die()

Pierre Gondois <pierre.gondois@arm.com>
    arm64: efi: Make efi_rt_lock a raw_spinlock

Jens Axboe <axboe@kernel.dk>
    brd: mark as nowait compatible

Luis Chamberlain <mcgrof@kernel.org>
    block/brd: add error handling support for add_disk()

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix PASID directory pointer coherency

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Refactor __irq_domain_alloc_irqs()

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Add a timer between request retries

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Increase the message retry time

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: retry to update the inode page given data corruption

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: do not bother checkpoint by f2fs_get_node_info

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid down_write on nat_tree_lock during checkpoint

Jan Kara <jack@suse.cz>
    udf: Fix off-by-one error when discarding preallocation

Alexander Aring <aahringo@redhat.com>
    fs: dlm: start midcomms before scand

Alexander Aring <aahringo@redhat.com>
    fs: dlm: add midcomms init/start functions

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix log of lowcomms vs midcomms

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure

Sean Christopherson <seanjc@google.com>
    KVM: Register /dev/kvm as the _very_ last thing during initialization

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: Optimize kvm_make_vcpus_request_mask() a bit

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: change order inside nfc_se_io error path

Zhihao Cheng <chengzhihao1@huawei.com>
    ext4: zero i_disksize when initializing the bootloader inode

Ye Bin <yebin10@huawei.com>
    ext4: fix WARNING in ext4_update_inline_data

Ye Bin <yebin10@huawei.com>
    ext4: move where set the MAY_INLINE_DATA flag is set

Darrick J. Wong <djwong@kernel.org>
    ext4: fix another off-by-one fsmap error on 1k block filesystems

Eric Whitney <enwlinux@gmail.com>
    ext4: fix RENAME_WHITEOUT handling for inline directories

Eric Biggers <ebiggers@google.com>
    ext4: fix cgroup writeback accounting with fs-layer encryption

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()

Harry Wentland <harry.wentland@amd.com>
    drm/connector: print max_requested_bpc in state debugfs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Tobias Klauser <tklauser@distanz.ch>
    fork: allow CLONE_NEWTIME in clone3 flags

Namhyung Kim <namhyung@kernel.org>
    perf inject: Fix --buildid-all not to eat up MMAP2

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix percent calculation for bg reclaim message

Theodore Ts'o <tytso@mit.edu>
    fs: prevent out-of-bounds array speculation when closing a file descriptor


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  51 ++-
 Documentation/trace/ftrace.rst                     |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/module.c                         |   4 +-
 arch/arm64/include/asm/efi.h                       |   6 +-
 arch/arm64/kernel/efi.c                            |   2 +-
 arch/mips/include/asm/mach-rc32434/pci.h           |   2 +-
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts       |   1 -
 arch/powerpc/include/asm/irq.h                     |   3 -
 arch/powerpc/kernel/iommu.c                        |   4 +-
 arch/powerpc/kernel/time.c                         |   4 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |   6 +-
 arch/powerpc/platforms/44x/fsp2.c                  |   2 +-
 arch/riscv/include/asm/ftrace.h                    |   2 +-
 arch/riscv/include/asm/parse_asm.h                 |   5 +
 arch/riscv/include/asm/patch.h                     |   2 +
 arch/riscv/kernel/ftrace.c                         |  14 +-
 arch/riscv/kernel/patch.c                          |  28 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/riscv/kernel/traps.c                          |  14 +-
 arch/s390/kernel/ftrace.c                          |  86 +----
 arch/s390/kernel/vmlinux.lds.S                     |   2 +
 arch/sh/kernel/vmlinux.lds.S                       |   1 +
 arch/um/kernel/vmlinux.lds.S                       |   2 +-
 arch/x86/kernel/cpu/amd.c                          |   9 +
 arch/x86/kvm/lapic.c                               |   1 +
 arch/x86/kvm/svm/avic.c                            |  28 +-
 arch/x86/kvm/vmx/evmcs.h                           |  11 -
 arch/x86/kvm/vmx/vmx.c                             |  44 ++-
 drivers/block/brd.c                                |  10 +-
 drivers/block/nbd.c                                |  14 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  34 +-
 drivers/char/tpm/eventlog/acpi.c                   |   6 +-
 drivers/clk/qcom/mmcc-apq8084.c                    | 271 ----------------
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   5 +-
 drivers/gpu/drm/drm_atomic.c                       |   1 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   6 +-
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c          |   4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   6 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   5 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  16 -
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |  12 -
 drivers/gpu/drm/nouveau/dispnv50/wndw.h            |   7 +-
 drivers/iommu/amd/init.c                           | 105 ++++--
 drivers/iommu/intel/pasid.c                        |   7 +
 drivers/macintosh/windfarm_lm75_sensor.c           |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c           |   4 +-
 drivers/media/i2c/ov5640.c                         |   2 +-
 drivers/media/rc/gpio-ir-recv.c                    |  18 ++
 drivers/net/dsa/mt7530.c                           |  35 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
 drivers/net/ethernet/broadcom/bgmac.h              |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  23 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   7 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  58 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   3 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/phy/microchip.c                        |  32 ++
 drivers/net/phy/phy_device.c                       |   8 +-
 drivers/net/phy/smsc.c                             |  20 +-
 drivers/net/usb/lan78xx.c                          |  27 +-
 drivers/nfc/fdp/i2c.c                              |   4 +
 drivers/pci/quirks.c                               |   8 +
 drivers/platform/x86/Kconfig                       |   3 +-
 drivers/regulator/core.c                           |  27 +-
 drivers/scsi/hosts.c                               |   2 +
 drivers/scsi/megaraid/megaraid_sas.h               |   2 +
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   2 +-
 drivers/staging/rtl8723bs/core/rtw_ap.c            |  20 +-
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |  96 +++---
 drivers/staging/rtl8723bs/core/rtw_ioctl_set.c     |   4 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   6 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |  56 ++--
 drivers/staging/rtl8723bs/core/rtw_security.c      |   6 +-
 drivers/staging/rtl8723bs/include/rtw_security.h   |   8 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  | 355 +++++++--------------
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |  51 +--
 drivers/staging/rtl8723bs/os_dep/os_intfs.c        |   4 +-
 fs/attr.c                                          |  72 ++++-
 fs/btrfs/block-group.c                             |   3 +-
 fs/dlm/lockspace.c                                 |  21 +-
 fs/dlm/lowcomms.c                                  |  16 +-
 fs/dlm/lowcomms.h                                  |   1 +
 fs/dlm/main.c                                      |   7 +-
 fs/dlm/midcomms.c                                  |  17 +-
 fs/dlm/midcomms.h                                  |   3 +
 fs/ext4/block_validity.c                           |  26 +-
 fs/ext4/ext4.h                                     |   3 +
 fs/ext4/fsmap.c                                    |   2 +
 fs/ext4/inline.c                                   |   1 -
 fs/ext4/inode.c                                    |   7 +-
 fs/ext4/ioctl.c                                    |   1 +
 fs/ext4/mballoc.c                                  | 205 +++++++-----
 fs/ext4/namei.c                                    |  36 ++-
 fs/ext4/page-io.c                                  |  11 +-
 fs/ext4/xattr.c                                    |   3 +
 fs/f2fs/checkpoint.c                               |   2 +-
 fs/f2fs/compress.c                                 |   2 +-
 fs/f2fs/data.c                                     |   8 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/f2fs/gc.c                                       |   6 +-
 fs/f2fs/inline.c                                   |   4 +-
 fs/f2fs/inode.c                                    |  14 +-
 fs/f2fs/node.c                                     |  23 +-
 fs/f2fs/recovery.c                                 |   2 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/file.c                                          |   1 +
 fs/fuse/file.c                                     |   2 +-
 fs/inode.c                                         |  90 +++---
 fs/internal.h                                      |  10 +-
 fs/locks.c                                         |   3 +-
 fs/namei.c                                         |  82 ++++-
 fs/namespace.c                                     |  29 +-
 fs/ocfs2/file.c                                    |   4 +-
 fs/ocfs2/namei.c                                   |   1 +
 fs/open.c                                          |   8 +-
 fs/udf/inode.c                                     |   2 +-
 fs/xfs/xfs_bmap_util.c                             |   9 +-
 fs/xfs/xfs_file.c                                  |  24 +-
 fs/xfs/xfs_iops.c                                  |  56 +---
 fs/xfs/xfs_iops.h                                  |   1 -
 fs/xfs/xfs_pnfs.c                                  |   9 +-
 include/asm-generic/vmlinux.lds.h                  |   5 +
 include/linux/fs.h                                 |   6 +-
 include/linux/pci_ids.h                            |   2 +
 include/net/netfilter/nf_tproxy.h                  |   7 +
 kernel/bpf/btf.c                                   |   1 +
 kernel/fork.c                                      |   2 +-
 kernel/irq/irqdomain.c                             | 152 +++++----
 kernel/sched/core.c                                |  10 +-
 kernel/sched/fair.c                                | 128 +++++++-
 kernel/sched/sched.h                               |  61 +++-
 kernel/watch_queue.c                               |   1 +
 net/caif/caif_usb.c                                |   3 +
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +-
 net/ipv4/tcp_bpf.c                                 |   6 +
 net/ipv4/udp_bpf.c                                 |   3 +
 net/ipv6/ila/ila_xlat.c                            |   1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |  14 +-
 net/nfc/netlink.c                                  |   2 +-
 net/smc/af_smc.c                                   |  13 +-
 net/sunrpc/svc.c                                   |   6 +-
 net/unix/af_unix.c                                 |  16 +-
 net/unix/unix_bpf.c                                |   3 +
 scripts/checkkconfigsymbols.py                     |  13 +-
 scripts/clang-tools/run-clang-tools.py             |  21 +-
 scripts/diffconfig                                 |  16 +-
 tools/bpf/Makefile                                 |   5 +-
 tools/bpf/bpf_jit_disasm.c                         |   5 +-
 tools/bpf/bpftool/Makefile                         |   5 +-
 tools/bpf/bpftool/jit_disasm.c                     |  42 ++-
 tools/build/Makefile.feature                       |   1 +
 tools/build/feature/Makefile                       |   4 +
 tools/build/feature/test-all.c                     |   4 +
 .../build/feature/test-disassembler-init-styled.c  |  13 +
 tools/include/tools/dis-asm-compat.h               |  55 ++++
 tools/perf/Makefile.config                         |   8 +
 tools/perf/builtin-inject.c                        |   1 +
 tools/perf/builtin-stat.c                          |  15 +-
 tools/perf/util/annotate.c                         |   7 +-
 tools/perf/util/stat.c                             |   6 +-
 tools/perf/util/stat.h                             |   1 -
 tools/perf/util/target.h                           |  12 +
 tools/testing/selftests/netfilter/nft_nat.sh       |   2 +
 virt/kvm/kvm_main.c                                | 145 ++++++---
 173 files changed, 1962 insertions(+), 1490 deletions(-)


