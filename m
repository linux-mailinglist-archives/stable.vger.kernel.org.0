Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AA6BC9EA
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCPIvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjCPIvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B44B7186;
        Thu, 16 Mar 2023 01:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77EF3B820BE;
        Thu, 16 Mar 2023 08:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBA0C433EF;
        Thu, 16 Mar 2023 08:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678956634;
        bh=ugTKdznJw2E2YFzsArC7CpPVtqt4huJWGSwejxYSTuo=;
        h=From:To:Cc:Subject:Date:From;
        b=lUEVjdvOlULdExZE7ffdXN3PWjUVeN6po/kqceCxfbRKfkRitlgtE+7HbwArYlrdI
         ygMp0OseuTKLUIIq8CiXN6e9ZDo0oY7ep7tx16hU3DryZhfr6A3SLmCFJ8CRfWZ7CO
         MdwR48JdiSZHcrrQObwLJDTB8eToSTZF4s0UXEJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 000/137] 6.2.7-rc2 review
Date:   Thu, 16 Mar 2023 09:50:31 +0100
Message-Id: <20230316083443.733397152@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.7-rc2
X-KernelTest-Deadline: 2023-03-18T08:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.7 release.
There are 137 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.7-rc2

Masahiro Yamada <masahiroy@kernel.org>
    UML: define RUNTIME_DISCARD_EXIT

Conor Dooley <conor@kernel.org>
    RISC-V: fix taking the text_mutex twice during sifive errata patching

Martin KaFai Lau <martin.lau@kernel.org>
    Revert "bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES"

Seth Forshee <sforshee@kernel.org>
    filelocks: use mount idmapping for setlease permission check

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: adjust MALL size available for DCN32 and DCN321

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Allow subvp on vactive pipes that are 2560x1440@60

Li Jun <jun.li@nxp.com>
    media: rc: gpio-ir-recv: add remove function

Paul Elder <paul.elder@ideasonboard.com>
    media: ov5640: Fix analogue gain control

Masahiro Yamada <masahiroy@kernel.org>
    scripts: handle BrokenPipeError for python scripts

Alvaro Karsz <alvaro.karsz@solid-run.com>
    PCI: Add SolidRun vendor ID

Nathan Chancellor <nathan@kernel.org>
    macintosh: windfarm: Use unsigned type for 1-bit bitfields

Edward Humes <aurxenon@lunos.org>
    alpha: fix R_ALPHA_LITERAL reloc for large modules

Rohan McLure <rmclure@linux.ibm.com>
    powerpc/kcsan: Exclude udelay to prevent recursive instrumentation

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Move paca allocation to early_setup()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Fix task_cpu in early boot when booting non-zero cpuid

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bpf/32: Only set a stack frame when necessary

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Remove __kernel_text_address() in show_instructions()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clk: renesas: rcar-gen3: Disable R-Car H3 ES1.*

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    powerpc/iommu: fix memory leak with using debugfs_lookup()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Don't recurse irq replay

xurui <xurui@kylinos.cn>
    MIPS: Fix a compilation issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: mmcc-apq8084: remove spdm clocks

Morten Linderud <morten@linderud.pw>
    tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address

David Disseldorp <ddiss@suse.de>
    watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths

Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
    drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc21: don't expose AV1 if VCN0 is harvested

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: take text_mutex during alternative patching

Jan Kara <jack@suse.cz>
    ext4: Fix deadlock during directory rename

Shashank Sharma <shashank.sharma@amd.com>
    drm/amdgpu: fix return value check in kfd

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: Don't check text_mutex during stop_machine

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Gao Xiang <xiang@kernel.org>
    erofs: Revert "erofs: fix kvcalloc() misuse with __GFP_NOFAIL"

Eric Dumazet <edumazet@google.com>
    af_unix: fix struct pid leaks in OOB support

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a server shutdown leak

Suman Ghosh <sumang@marvell.com>
    octeontx2-af: Unlock contexts in the queue context cache in case of fault detection

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix fallback failed while sendmsg with fastopen

Arnd Bergmann <arnd@arndb.de>
    ethernet: ice: avoid gcc-9 integer overflow warning

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix DSCP PFC TLV creation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against filesystem freezing

Yu Kuai <yukuai3@huawei.com>
    block: fix wrong mode for blkdev_put() from disk_scan_partitions()

Randy Dunlap <rdunlap@infradead.org>
    platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it

Randy Dunlap <rdunlap@infradead.org>
    platform: mellanox: select REGMAP instead of depending on it

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-ddv: Fix temperature scaling

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-ddv: Return error if buffer is empty

Eric Dumazet <edumazet@google.com>
    netfilter: conntrack: adopt safer max chain length

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: sd: Fix wrong zone_write_granularity value during revalidate

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Update max supported LD IDs to 240

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix device-offloaded sendpage straddling records

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix RX data corruption issue

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: smsc: fix link up detection in forced irq mode

Lorenz Bauer <lorenz.bauer@isovalent.com>
    btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Alexander Lobakin <aleksander.lobakin@intel.com>
    bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES

Filipe Manana <fdmanana@suse.com>
    btrfs: fix extent map logging bit not cleared for split maps after dropping range

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: mm: Move initrd phys_to_virt handling after paging_init()

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

Kalyan Thota <quic_kalyant@quicinc.com>
    drm/msm/dpu: clear DSPP reservations in rm release

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/disp/dpu: fix sc7280_pp base offset

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix clocks settings for msm8998 SSPP blocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: drop DPU_DIM_LAYER from MIXER_MSM8998_MASK

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: correct sm6115 scaler

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: correct sm8250 and sm8350 scaler

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix sm6115 and qcm2290 mixer width limits

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix len of sc7180 ctl blocks

Liu Jian <liujian56@huawei.com>
    bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()

Huanhuan Wang <huanhuan.wang@corigine.com>
    nfp: fix esp-tx-csum-offload doesn't take effect

Huanhuan Wang <huanhuan.wang@corigine.com>
    nfp: fix incorrectly set csum flag for nfd3 path

Petr Oros <poros@redhat.com>
    ice: copy last block omitted in ice_get_module_eeprom()

Shigeru Yoshida <syoshida@redhat.com>
    net: caif: Fix use-after-free in cfusbl_device_notify()

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Changbin Du <changbin.du@huawei.com>
    perf stat: Fix counting when initial delay configured

Brian Vazquez <brianvv@google.com>
    net: use indirect calls helpers for sk_exit_memory_pressure()

Hangyu Hua <hbh25y@gmail.com>
    net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_quota: copy content when cloning expression

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_last: copy content when cloning expression

Hangbin Liu <liuhangbin@gmail.com>
    selftests: nft_nat: ensuring the listening side is up before starting the client

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix port police support using tc-matchall

Eric Dumazet <edumazet@google.com>
    ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: disable features unsupported by QCM2290

Jakub Kicinski <kuba@kernel.org>
    tls: rx: fix return value for async crypto

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

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fb/gp102-: cache scrubber binary on first load

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype

Jan Kara <jack@suse.cz>
    ext4: Fix possible corruption when moving a directory

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Liao Chang <liaochang1@huawei.com>
    riscv: Add header include guards to insn.h

Yu Kuai <yukuai3@huawei.com>
    block: fix scan partition for exclusively open device again

Yu Kuai <yukuai3@huawei.com>
    block: Revert "block: Do not reread partition table on exclusively open device"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Populate encoder->devdata for DSI on icl+

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Do panel VBT init early if the VBT declares an explicit panel type

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Introduce intel_panel_init_alloc()

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Change state_lock to mutex

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Power up/down MHI stack during MHI RESET

Jan Kara <jack@suse.cz>
    udf: Fix off-by-one error when discarding preallocation

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move guts of kvm_arch_init() to standalone helper

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Don't bother disabling eVMCS static key on module exit

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Reset eVMCS controls in VP assist page during hardware disabling

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: change order inside nfc_se_io error path

Lee Jones <lee@kernel.org>
    HID: uhid: Over-ride the default maximum data buffer value with our own

Lee Jones <lee@kernel.org>
    HID: core: Provide new max_buffer_size attribute to over-ride the default

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

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Fix key-store index handling

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/adreno: fix runtime PM imbalance at unbind

Harry Wentland <harry.wentland@amd.com>
    drm/connector: print max_requested_bpc in state debugfs

Harry Wentland <harry.wentland@amd.com>
    drm/display: Don't block HDR_OUTPUT_METADATA on unknown EOTF

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix error checking in amdgpu_read_mm_registers for nv

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc21

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Srinivas Pandruvada <srinivas.pandruvada@intel.com>
    thermal: intel: int340x: processor_thermal: Fix deadlock

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Stop emitting attributes

Tobias Klauser <tklauser@distanz.ch>
    fork: allow CLONE_NEWTIME in clone3 flags

Namhyung Kim <namhyung@kernel.org>
    perf inject: Fix --buildid-all not to eat up MMAP2

Gao Xiang <xiang@kernel.org>
    erofs: fix wrong kunmap when using LZMA on HIGHMEM platforms

Jens Axboe <axboe@kernel.dk>
    io_uring/uring_cmd: ensure that device supports IOPOLL

Filipe Manana <fdmanana@suse.com>
    btrfs: fix block group item corruption after inserting new block group

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix percent calculation for bg reclaim message

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix unnecessary increment of read error stat on write error

Theodore Ts'o <tytso@mit.edu>
    fs: prevent out-of-bounds array speculation when closing a file descriptor


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/module.c                         |   4 +-
 arch/m68k/kernel/setup_mm.c                        |  10 +-
 arch/mips/include/asm/mach-rc32434/pci.h           |   2 +-
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts       |   1 -
 arch/powerpc/include/asm/hw_irq.h                  |   6 +-
 arch/powerpc/include/asm/paca.h                    |   1 -
 arch/powerpc/include/asm/smp.h                     |   1 +
 arch/powerpc/kernel/iommu.c                        |   4 +-
 arch/powerpc/kernel/irq_64.c                       | 101 +++++---
 arch/powerpc/kernel/process.c                      |   3 +-
 arch/powerpc/kernel/prom.c                         |  12 +-
 arch/powerpc/kernel/setup-common.c                 |   4 +
 arch/powerpc/kernel/setup_64.c                     |  16 +-
 arch/powerpc/kernel/time.c                         |   4 +-
 arch/powerpc/net/bpf_jit_comp32.c                  |  20 +-
 arch/riscv/Makefile                                |   7 +
 arch/riscv/errata/sifive/errata.c                  |   3 +
 arch/riscv/errata/thead/errata.c                   |   8 +-
 arch/riscv/include/asm/ftrace.h                    |   2 +-
 arch/riscv/include/asm/parse_asm.h                 |   5 +
 arch/riscv/include/asm/patch.h                     |   2 +
 arch/riscv/kernel/compat_vdso/Makefile             |   4 +
 arch/riscv/kernel/cpufeature.c                     |   6 +-
 arch/riscv/kernel/ftrace.c                         |  13 +-
 arch/riscv/kernel/patch.c                          |  28 ++-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/um/kernel/vmlinux.lds.S                       |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   3 +
 arch/x86/kernel/cpu/amd.c                          |   9 +
 arch/x86/kvm/svm/svm.c                             |  23 +-
 arch/x86/kvm/vmx/vmx.c                             |  91 ++++---
 arch/x86/kvm/x86.c                                 |  15 +-
 block/blk.h                                        |   2 +-
 block/genhd.c                                      |  37 ++-
 block/ioctl.c                                      |  13 +-
 drivers/bus/mhi/ep/main.c                          |  41 +---
 drivers/bus/mhi/ep/sm.c                            |  42 ++--
 drivers/char/tpm/eventlog/acpi.c                   |   6 +-
 drivers/clk/qcom/mmcc-apq8084.c                    | 271 ---------------------
 drivers/clk/renesas/Kconfig                        |   2 +-
 drivers/clk/renesas/r8a7795-cpg-mssr.c             | 126 +---------
 drivers/clk/renesas/rcar-gen3-cpg.c                |  17 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |  27 --
 drivers/clk/renesas/renesas-cpg-mssr.h             |  14 --
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   7 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   5 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  69 ++++--
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |   2 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |  62 ++++-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.h  |   4 +
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |   9 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |  36 ++-
 .../gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |   5 +-
 drivers/gpu/drm/display/drm_hdmi_helper.c          |   6 +-
 drivers/gpu/drm/drm_atomic.c                       |   1 +
 drivers/gpu/drm/i915/display/icl_dsi.c             |   3 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |  71 ++++--
 drivers/gpu/drm/i915/display/intel_bios.h          |  11 +-
 drivers/gpu/drm/i915/display/intel_connector.c     |   2 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   7 +-
 drivers/gpu/drm/i915/display/intel_lvds.c          |   4 +-
 drivers/gpu/drm/i915/display/intel_panel.c         |   8 +
 drivers/gpu/drm/i915/display/intel_panel.h         |   1 +
 drivers/gpu/drm/i915/display/intel_sdvo.c          |   2 +-
 drivers/gpu/drm/i915/display/vlv_dsi.c             |   2 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   6 +-
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c          |   4 +-
 drivers/gpu/drm/msm/adreno/adreno_device.c         |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |  60 +++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c             |   2 +
 drivers/gpu/drm/msm/msm_gem_submit.c               |   5 +-
 drivers/gpu/drm/nouveau/dispnv50/wndw.h            |   5 +-
 drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h   |   3 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c      |   8 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c     |  21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c     |  41 ++--
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c     |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h      |   3 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c     |   4 +-
 drivers/hid/hid-core.c                             |  32 ++-
 drivers/hid/uhid.c                                 |   1 +
 drivers/macintosh/windfarm_lm75_sensor.c           |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c           |   4 +-
 drivers/media/i2c/ov5640.c                         |   2 +-
 drivers/media/rc/gpio-ir-recv.c                    |  18 ++
 drivers/net/dsa/mt7530.c                           |  35 +--
 drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
 drivers/net/ethernet/broadcom/bgmac.h              |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  23 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   6 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   7 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  58 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   3 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 +
 .../ethernet/microchip/lan966x/lan966x_police.c    |   2 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c       |   7 +-
 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c    |  25 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/phy/microchip.c                        |  32 +++
 drivers/net/phy/phy_device.c                       |   8 +-
 drivers/net/phy/smsc.c                             |  14 +-
 drivers/net/usb/lan78xx.c                          |  27 +-
 drivers/nfc/fdp/i2c.c                              |   4 +
 drivers/platform/mellanox/Kconfig                  |   9 +-
 drivers/platform/x86/Kconfig                       |   3 +-
 drivers/platform/x86/dell/dell-wmi-ddv.c           |  21 +-
 drivers/scsi/hosts.c                               |   2 +
 drivers/scsi/megaraid/megaraid_sas.h               |   2 +
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   2 +-
 drivers/scsi/sd.c                                  |   7 +-
 drivers/scsi/sd_zbc.c                              |   8 -
 drivers/staging/rtl8723bs/include/rtw_security.h   |   8 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |  32 +--
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |  33 +--
 .../int340x_thermal/processor_thermal_device_pci.c |   5 +-
 fs/btrfs/bio.c                                     |   2 +-
 fs/btrfs/block-group.c                             |  16 +-
 fs/btrfs/extent_map.c                              |   7 +-
 fs/erofs/decompressor_lzma.c                       |   2 +-
 fs/erofs/zdata.c                                   |  12 +-
 fs/ext4/fsmap.c                                    |   2 +
 fs/ext4/inline.c                                   |   1 -
 fs/ext4/inode.c                                    |   7 +-
 fs/ext4/ioctl.c                                    |   1 +
 fs/ext4/namei.c                                    |  36 ++-
 fs/ext4/page-io.c                                  |  11 +-
 fs/ext4/xattr.c                                    |   3 +
 fs/file.c                                          |   1 +
 fs/locks.c                                         |   3 +-
 fs/nfsd/vfs.c                                      |   2 +
 fs/udf/inode.c                                     |   2 +-
 include/linux/hid.h                                |   3 +
 include/linux/mhi_ep.h                             |   4 +-
 include/linux/pci_ids.h                            |   2 +
 include/net/netfilter/nf_tproxy.h                  |   7 +
 io_uring/uring_cmd.c                               |   4 +-
 kernel/bpf/btf.c                                   |   1 +
 kernel/fork.c                                      |   2 +-
 kernel/watch_queue.c                               |   1 +
 net/caif/caif_usb.c                                |   3 +
 net/core/sock.c                                    |   3 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +-
 net/ipv4/tcp_bpf.c                                 |   6 +
 net/ipv4/udp_bpf.c                                 |   3 +
 net/ipv6/ila/ila_xlat.c                            |   1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |  14 +-
 net/netfilter/nft_last.c                           |   4 +
 net/netfilter/nft_quota.c                          |   6 +-
 net/nfc/netlink.c                                  |   2 +-
 net/smc/af_smc.c                                   |  13 +-
 net/sunrpc/svc.c                                   |   6 +-
 net/tls/tls_device.c                               |   2 +
 net/tls/tls_main.c                                 |  23 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/unix/af_unix.c                                 |  10 +-
 net/unix/unix_bpf.c                                |   3 +
 scripts/checkkconfigsymbols.py                     |  13 +-
 scripts/clang-tools/run-clang-tools.py             |  21 +-
 scripts/diffconfig                                 |  16 +-
 tools/perf/builtin-inject.c                        |   1 +
 tools/perf/builtin-stat.c                          |  15 +-
 tools/perf/util/stat.c                             |   6 +-
 tools/perf/util/stat.h                             |   1 -
 tools/perf/util/target.h                           |  12 +
 tools/testing/selftests/netfilter/nft_nat.sh       |   2 +
 176 files changed, 1276 insertions(+), 1050 deletions(-)


