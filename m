Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E166BB0C8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjCOMVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjCOMUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EAD80924;
        Wed, 15 Mar 2023 05:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23234B81DFD;
        Wed, 15 Mar 2023 12:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66833C433D2;
        Wed, 15 Mar 2023 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882816;
        bh=2mvbocSkeKwQQ2g6vYWUD781Dm0TEkI/c80Hwon8j1c=;
        h=From:To:Cc:Subject:Date:From;
        b=pOkE4XuJ6AOwjgAGUSowOCBY44kNLnBbIrcqqXBwl74fs5sLJlbE+8ph4OjUtQ4ej
         SnoyuYHs/BkxWZCBsCiAcgTxZRxrP2AH2lm7uci4tUgy5TUgXktyOJvU5wTq5hLpya
         g+Dbt3v+7+disdBQMVcg6j0oqqA3At7zdvaAVRSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/104] 5.10.175-rc1 review
Date:   Wed, 15 Mar 2023 13:11:31 +0100
Message-Id: <20230315115731.942692602@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.175-rc1
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

This is the start of the stable review cycle for the 5.10.175 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.175-rc1

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: add missing discipline function

Alexandru Matei <alexandru.matei@uipath.com>
    KVM: VMX: Fix crash due to uninitialized current_vmcs

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Don't use Enlightened MSR Bitmap for L3

Masahiro Yamada <masahiroy@kernel.org>
    UML: define RUNTIME_DISCARD_EXIT

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
    sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make select_idle_capacity() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix fits_capacity() check in feec()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make task_fits_capacity() use util_fits_cpu()

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use BAR mappings for ring buffers with LLC

Tao Liu <taoliu828@163.com>
    skbuff: Fix nfct leak on napi stolen

Corey Minyard <cminyard@mvista.com>
    ipmi:watchdog: Set panic count to proper value on a panic

Yejune Deng <yejune.deng@gmail.com>
    ipmi/watchdog: replace atomic_add() and atomic_sub()

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

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Check !irq instead of irq == NO_IRQ and remove NO_IRQ

xurui <xurui@kylinos.cn>
    MIPS: Fix a compilation issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: mmcc-apq8084: remove spdm clocks

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for bfqq in bic_set_bfqq()

Yu Kuai <yukuai3@huawei.com>
    block, bfq: replace 0/1 with false/true in bic apis

NeilBrown <neilb@suse.de>
    block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix possible uaf for 'bfqq->bic'

Morten Linderud <morten@linderud.pw>
    tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address

David Disseldorp <ddiss@suse.de>
    watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    PCI/PM: Define pci_restore_standard_config() only for CONFIG_PM_SLEEP

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Jan Kara <jack@suse.cz>
    ext4: Fix deadlock during directory rename

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: Don't check text_mutex during stop_machine

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a server shutdown leak

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix fallback failed while sendmsg with fastopen

Randy Dunlap <rdunlap@infradead.org>
    platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Update max supported LD IDs to 240

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix RX data corruption issue

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

Shigeru Yoshida <syoshida@redhat.com>
    net: caif: Fix use-after-free in cfusbl_device_notify()

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Lee Jones <lee.jones@linaro.org>
    net: usb: lan78xx: Remove lots of set but unused 'ret' variables

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

Rob Clark <robdclark@chromium.org>
    drm/msm: Document and rename preempt_lock

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

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix PASID directory pointer coherency

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix lockdep splat in intel_pasid_get_entry()

Marc Zyngier <maz@kernel.org>
    irqdomain: Fix domain registration race

Bixuan Cui <cuibixuan@huawei.com>
    irqdomain: Change the type of 'size' in __irq_domain_add() to be consistent

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix mapping-creation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Refactor __irq_domain_alloc_irqs()

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Look for existing mapping only once

Ingo Molnar <mingo@kernel.org>
    irq: Fix typos in comments

Jan Kara <jack@suse.cz>
    udf: Fix off-by-one error when discarding preallocation

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

Harry Wentland <harry.wentland@amd.com>
    drm/connector: print max_requested_bpc in state debugfs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Tobias Klauser <tklauser@distanz.ch>
    fork: allow CLONE_NEWTIME in clone3 flags

Theodore Ts'o <tytso@mit.edu>
    fs: prevent out-of-bounds array speculation when closing a file descriptor


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/alpha/kernel/module.c                        |   4 +-
 arch/arm64/include/asm/efi.h                      |   6 +-
 arch/arm64/kernel/efi.c                           |   2 +-
 arch/mips/include/asm/mach-rc32434/pci.h          |   2 +-
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts      |   1 -
 arch/powerpc/include/asm/irq.h                    |   3 -
 arch/powerpc/kernel/time.c                        |   4 +-
 arch/powerpc/kernel/vmlinux.lds.S                 |   6 +-
 arch/powerpc/platforms/44x/fsp2.c                 |   2 +-
 arch/riscv/include/asm/ftrace.h                   |   2 +-
 arch/riscv/include/asm/parse_asm.h                |   5 +
 arch/riscv/include/asm/patch.h                    |   2 +
 arch/riscv/kernel/ftrace.c                        |  14 +-
 arch/riscv/kernel/patch.c                         |  28 ++-
 arch/riscv/kernel/stacktrace.c                    |   2 +-
 arch/riscv/kernel/traps.c                         |  14 +-
 arch/s390/kernel/vmlinux.lds.S                    |   2 +
 arch/sh/kernel/vmlinux.lds.S                      |   1 +
 arch/um/kernel/vmlinux.lds.S                      |   2 +-
 arch/x86/kernel/cpu/amd.c                         |   9 +
 arch/x86/kvm/vmx/evmcs.h                          |  11 -
 arch/x86/kvm/vmx/vmx.c                            |  44 ++--
 block/bfq-cgroup.c                                |   8 +-
 block/bfq-iosched.c                               |  19 +-
 drivers/char/ipmi/ipmi_watchdog.c                 |   8 +-
 drivers/char/tpm/eventlog/acpi.c                  |   6 +-
 drivers/clk/qcom/mmcc-apq8084.c                   | 271 ----------------------
 drivers/gpu/drm/amd/amdgpu/soc15.c                |   5 +-
 drivers/gpu/drm/drm_atomic.c                      |   1 +
 drivers/gpu/drm/i915/gt/intel_ring.c              |   4 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c             |   8 +-
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c         |  16 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c             |   4 +-
 drivers/gpu/drm/msm/msm_gem_submit.c              |   5 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c              |   2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h              |   7 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c           |  16 --
 drivers/gpu/drm/nouveau/dispnv50/wndw.c           |  12 -
 drivers/gpu/drm/nouveau/dispnv50/wndw.h           |   7 +-
 drivers/iommu/amd/init.c                          |  16 +-
 drivers/iommu/intel/pasid.c                       |  28 ++-
 drivers/irqchip/irq-aspeed-vic.c                  |   4 +-
 drivers/irqchip/irq-bcm7120-l2.c                  |   2 +-
 drivers/irqchip/irq-csky-apb-intc.c               |   2 +-
 drivers/irqchip/irq-gic-v2m.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                  |  10 +-
 drivers/irqchip/irq-gic-v3.c                      |   2 +-
 drivers/irqchip/irq-loongson-pch-pic.c            |   2 +-
 drivers/irqchip/irq-meson-gpio.c                  |   2 +-
 drivers/irqchip/irq-mtk-cirq.c                    |   2 +-
 drivers/irqchip/irq-mxs.c                         |   4 +-
 drivers/irqchip/irq-sun4i.c                       |   2 +-
 drivers/irqchip/irq-ti-sci-inta.c                 |   2 +-
 drivers/irqchip/irq-vic.c                         |   4 +-
 drivers/irqchip/irq-xilinx-intc.c                 |   2 +-
 drivers/macintosh/windfarm_lm75_sensor.c          |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c          |   4 +-
 drivers/media/i2c/ov5640.c                        |   2 +-
 drivers/media/rc/gpio-ir-recv.c                   |  18 ++
 drivers/net/ethernet/broadcom/bgmac.c             |   8 +-
 drivers/net/ethernet/broadcom/bgmac.h             |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  23 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       |   3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   1 +
 drivers/net/phy/microchip.c                       |  32 +++
 drivers/net/phy/phy_device.c                      |   8 +-
 drivers/net/usb/lan78xx.c                         | 189 ++++++---------
 drivers/nfc/fdp/i2c.c                             |   4 +
 drivers/pci/pci-driver.c                          |  17 +-
 drivers/pci/quirks.c                              |   8 +
 drivers/platform/x86/Kconfig                      |   3 +-
 drivers/s390/block/dasd_diag.c                    |   7 +-
 drivers/s390/block/dasd_fba.c                     |   7 +-
 drivers/s390/block/dasd_int.h                     |   1 -
 drivers/scsi/hosts.c                              |   2 +
 drivers/scsi/megaraid/megaraid_sas.h              |   2 +
 drivers/scsi/megaraid/megaraid_sas_fp.c           |   2 +-
 fs/ext4/block_validity.c                          |  26 ++-
 fs/ext4/ext4.h                                    |   3 +
 fs/ext4/fsmap.c                                   |   2 +
 fs/ext4/inline.c                                  |   1 -
 fs/ext4/inode.c                                   |   7 +-
 fs/ext4/ioctl.c                                   |   1 +
 fs/ext4/mballoc.c                                 | 205 +++++++++-------
 fs/ext4/namei.c                                   |  36 ++-
 fs/ext4/page-io.c                                 |  11 +-
 fs/ext4/xattr.c                                   |   3 +
 fs/file.c                                         |   1 +
 fs/udf/inode.c                                    |   2 +-
 include/asm-generic/vmlinux.lds.h                 |   5 +
 include/linux/irq.h                               |   4 +-
 include/linux/irqdesc.h                           |   2 +-
 include/linux/irqdomain.h                         |   2 +-
 include/linux/pci_ids.h                           |   2 +
 include/net/netfilter/nf_tproxy.h                 |   7 +
 kernel/bpf/btf.c                                  |   1 +
 kernel/fork.c                                     |   2 +-
 kernel/irq/chip.c                                 |   2 +-
 kernel/irq/dummychip.c                            |   2 +-
 kernel/irq/irqdesc.c                              |   2 +-
 kernel/irq/irqdomain.c                            | 262 +++++++++++++--------
 kernel/irq/manage.c                               |   6 +-
 kernel/irq/msi.c                                  |   2 +-
 kernel/irq/timings.c                              |   2 +-
 kernel/sched/core.c                               |  10 +-
 kernel/sched/fair.c                               | 183 ++++++++++++---
 kernel/sched/sched.h                              |  70 +++++-
 kernel/watch_queue.c                              |   1 +
 net/caif/caif_usb.c                               |   3 +
 net/core/dev.c                                    |   1 +
 net/core/skbuff.c                                 |   1 -
 net/ipv4/netfilter/nf_tproxy_ipv4.c               |   2 +-
 net/ipv6/ila/ila_xlat.c                           |   1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c               |   2 +-
 net/netfilter/nf_conntrack_netlink.c              |  14 +-
 net/nfc/netlink.c                                 |   2 +-
 net/smc/af_smc.c                                  |  13 +-
 net/sunrpc/svc.c                                  |   6 +-
 scripts/checkkconfigsymbols.py                    |  13 +-
 scripts/clang-tools/run-clang-tools.py            |  21 +-
 scripts/diffconfig                                |  16 +-
 tools/testing/selftests/netfilter/nft_nat.sh      |   2 +
 124 files changed, 1093 insertions(+), 872 deletions(-)


