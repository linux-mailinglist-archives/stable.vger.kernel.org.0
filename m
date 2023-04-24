Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C886ECE3B
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjDXNa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjDXNaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22D476B3;
        Mon, 24 Apr 2023 06:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B5FF62333;
        Mon, 24 Apr 2023 13:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E812C4339B;
        Mon, 24 Apr 2023 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342995;
        bh=5kQh/jnrQQsCW2tdbXAw3tgY2VMgTYw7NeJPw87F7eE=;
        h=From:To:Cc:Subject:Date:From;
        b=ozrDJonX0BJh/Z81W7NJMS0RcpnrC3nDtKTSA4qAWxA89TRWmGiXKPkt6o+P4UYJY
         n+Cr2TcEpPP43aPGheQsQ8jfV9GMkfWxKqIrJ2rhFNHazZUkduXwmNDMxVvCYRU2TY
         KHY5F5KUlPmPAJ5NNw4bCEXtqYNx7sfeeLAqulxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 000/110] 6.2.13-rc1 review
Date:   Mon, 24 Apr 2023 15:16:22 +0200
Message-Id: <20230424131136.142490414@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.13-rc1
X-KernelTest-Deadline: 2023-04-26T13:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.13 release.
There are 110 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.13-rc1

Ekaterina Orlova <vorobushek.ok@gmail.com>
    ASN.1: Fix check for strdup() success

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_sai: Fix pins setting for i.MX8QM platform

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    ASoC: fsl_asrc_dma: fix potential null-ptr-deref

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: SOF: pm: Tear down pipelines only if DSP was active

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mm/page_alloc: fix potential deadlock on zonelist_update_seq seqlock

Alexis Lothoré <alexis.lothore@bootlin.com>
    fpga: bridge: properly initialize bridge device before populating children

Dan Carpenter <error27@gmail.com>
    iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()

Soumya Negi <soumya.negi97@gmail.com>
    Input: pegasus-notetaker - check pipe type when probing

hrdl <git@hrdl.eu>
    Input: cyttsp5 - fix sensing configuration data structure

Linus Torvalds <torvalds@linux-foundation.org>
    gcc: disable '-Warray-bounds' for gcc-13 too

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Remove over-zealous hardware size check in pci_msix_validate_entries()

Alyssa Ross <hi@alyssa.is>
    purgatory: fix disabling debug info

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make WriteCombine configurable for ioremap()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make -mstrict-align configurable

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Define RUNTIME_DISCARD_EXIT in LD script

Dan Carpenter <dan.carpenter@linaro.org>
    KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make vcpu flag updates non-preemptible

Paulo Alcantara <pc@manguebit.com>
    cifs: avoid dup prefix path in dfs_get_automount_devname()

Liam R. Howlett <Liam.Howlett@oracle.com>
    mm/mmap: regression fix for unmapped_area{_topdown}

Mel Gorman <mgorman@techsingularity.net>
    mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages

Alexander Potapenko <glider@google.com>
    mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()

Alexander Potapenko <glider@google.com>
    mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm/huge_memory.c: warn with pr_warn_ratelimited instead of VM_WARN_ON_ONCE_FOLIO

Peter Xu <peterx@redhat.com>
    mm/khugepaged: check again on anon uffd-wp during isolation

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: fix uffd-wp handling for THP migration entries

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    mm: fix memory leak on mm_init error handling

Sascha Hauer <s.hauer@pengutronix.de>
    drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume

Sascha Hauer <s.hauer@pengutronix.de>
    drm/rockchip: vop2: fix suspend/resume

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: set dcn315 lb bpp to 48

Alan Liu <HaoPing.Liu@amd.com>
    drm/amdgpu: Fix desktop freezed after gpu-reset

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix fast wake AUX sync len

Bhavya Kapoor <b-kapoor@ti.com>
    mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25

Baokun Li <libaokun1@huawei.com>
    writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs

Ondrej Mosnacek <omosnace@redhat.com>
    kernel/sys.c: fix and improve control flow in __sys_setres[ug]id()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    memstick: fix memory leak if card device is never registered

Steve Chou <steve_chou@pesi.com.tw>
    tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix accept vs worker race

Paolo Abeni <pabeni@redhat.com>
    mptcp: stops worker on unaccepted sockets at listener close

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: initialize unused bytes in segment summary blocks

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module

Peng Zhang <zhangpeng.00@bytedance.com>
    maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix mas_empty_area() search

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: make maple state reusable after mas_empty_area_rev()

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Mark 3 symbol exports as non-GPL

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix probing of the CRC32 feature

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Check unwind_error() in arch_stack_walk()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: module: set section addresses to 0x0

David Gow <davidgow@google.com>
    rust: kernel: Mark rust_fmt_argument as extern "C"

Boris Burkov <boris@bur.io>
    btrfs: reinterpret async discard iops_limit=0 as no delay

Boris Burkov <boris@bur.io>
    btrfs: set default discard iops_limit to 1000

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Brian Masney <bmasney@redhat.com>
    iio: light: tsl2772: fix reading proximity-diodes from device tree

Liang He <windhl@126.com>
    iio: dac: ad5755: Add missing fwnode_handle_put()

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "ACPICA: Events: Support fixed PCIe wake event"

Peter Xu <peterx@redhat.com>
    Revert "userfaultfd: don't fail on unrecognized features"

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: Zero-initialize the pwm_state passed to driver's .get_state()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: spi-nor: fix memory leak when using debugfs_lookup()

weiliang1503 <weiliang1503@gmail.com>
    platform/x86: asus-nb-wmi: Add quirk_asus_tablet_mode to other ROG Flow X13 models

Hans de Goede <hdegoede@redhat.com>
    platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE

Juergen Gross <jgross@suse.com>
    xen/netback: use same error messages for same errors

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix a possible UAF when failing to allocate an io queue

David Gow <davidgow@google.com>
    drm: test: Fix 32-bit issue in drm_buddy_test

David Gow <davidgow@google.com>
    drm: buddy_allocator: Fix buddy allocator init on 32-bit systems

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: gigabyte-wmi: add support for B650 AORUS ELITE AX

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: mmap: add phy ops

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: core: Improve scsi_vpd_inquiry() checks

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix fw_crash_buffer_show()

Nick Desaulniers <ndesaulniers@google.com>
    selftests: sigaltstack: fix -Wuninitialized

Frank Crawford <frank@crawford.emu.id.au>
    platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2

Dongliang Mu <dzm91@hust.edu.cn>
    platform/x86/intel: vsec: Fix a memory leak in intel_vsec_add_aux

Douglas Raillard <douglas.raillard@arm.com>
    f2fs: Fix f2fs_truncate_partial_nodes ftrace event

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: switchdev: don't notify FDB entries with "master dynamic"

Sebastian Basierski <sebastianx.basierski@intel.com>
    e1000e: Disable TSO on i219-LM card to increase speed

Vadim Fedorenko <vadfed@meta.com>
    bnxt_en: fix free-runnig PHC mode

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: dsa: microchip: ksz8795: Correctly handle huge frame configuration

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect verifier pruning due to missing register precision taints

Li Lanzhe <u202212060@hust.edu.cn>
    spi: spi-rockchip: Fix missing unwind goto in rockchip_sfc_probe()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: pci: Fix possible crash during initialization

Alexander Aring <aahringo@redhat.com>
    net: rpl: fix rpl header size calculation

Ido Schimmel <idosch@nvidia.com>
    bonding: Fix memory leak when changing bond type to Ethernet

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix build error if CONFIG_SUSPEND is not set

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Do not initialize PTP on older P3/P4 chips

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements

Duoming Zhou <duoming@zju.edu.cn>
    cxgb4: fix use after free bugs caused by circular dependency problem

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate catch-all set elements

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix i40e_setup_misc_vector() error handling

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix accessing vsi->active_filters without holding lock

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Ding Hui <dinghui@sangfor.com.cn>
    sfc: Fix use-after-free due to selftest_work

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_net: bugfix overflow inside xdp_linearize_page()

Gwangun Jung <exsociety@gmail.com>
    net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regulator: fan53555: Fix wrong TCS_SLEW_MASK

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regulator: fan53555: Explicitly include bits header

Patrick Blass <patrickblass@mailbox.org>
    rust: str: fix requierments->requirements typo

Chen Aotian <chenaotian2@163.com>
    netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: fix recent physdev match breakage

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-verdin: correct off-on-delay

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-verdin: correct off-on-delay

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-evk: correct pmic clock source

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp-pmics: fix pon compatible and registers

Marc Gonzalez <mgonzalez@freebox.fr>
    perf/amlogic: adjust register offsets

Marc Gonzalez <mgonzalez@freebox.fr>
    arm64: dts: meson-g12-common: resolve conflict between canvas & pmu

Marc Gonzalez <mgonzalez@freebox.fr>
    arm64: dts: meson-g12-common: specify full DMC range

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: ipq8074-hk10: enable QMP device, not the PHY node

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: ipq8074-hk01: enable QMP device, not the PHY node

Dan Johansen <strit@manjaro.org>
    arm64: dts: rockchip: Lower sd speed on rk3566-soquartz

Jianqun Xu <jay.xu@rock-chips.com>
    ARM: dts: rockchip: fix a typo error for rk3288 spdif node


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.rst    |  1 +
 Documentation/admin-guide/kernel-parameters.txt    |  6 ++
 Makefile                                           |  4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  2 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  | 15 ++--
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi      |  2 +-
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |  4 +-
 .../boot/dts/freescale/imx8mp-verdin-dev.dtsi      |  2 +-
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi   |  4 +-
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts          |  4 +-
 arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi         |  4 +-
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi       |  5 +-
 arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi  |  2 +-
 arch/arm64/include/asm/kvm_host.h                  | 19 ++++-
 arch/arm64/kvm/hypercalls.c                        |  2 +
 arch/loongarch/Kconfig                             | 35 ++++++++++
 arch/loongarch/Makefile                            |  5 ++
 arch/loongarch/include/asm/acpi.h                  |  3 +
 arch/loongarch/include/asm/cpu-features.h          |  1 +
 arch/loongarch/include/asm/cpu.h                   | 40 ++++++-----
 arch/loongarch/include/asm/io.h                    |  4 +-
 arch/loongarch/include/asm/loongarch.h             |  2 +-
 arch/loongarch/include/asm/module.lds.h            |  8 +--
 arch/loongarch/kernel/Makefile                     |  4 +-
 arch/loongarch/kernel/cpu-probe.c                  |  9 ++-
 arch/loongarch/kernel/proc.c                       |  1 +
 arch/loongarch/kernel/setup.c                      | 21 ++++++
 arch/loongarch/kernel/stacktrace.c                 |  2 +-
 arch/loongarch/kernel/traps.c                      |  9 ++-
 arch/loongarch/kernel/unwind.c                     |  1 +
 arch/loongarch/kernel/unwind_prologue.c            |  4 +-
 arch/loongarch/mm/init.c                           |  4 +-
 arch/mips/kernel/vmlinux.lds.S                     |  2 +
 arch/riscv/purgatory/Makefile                      |  4 +-
 arch/s390/kernel/ptrace.c                          |  8 +--
 arch/x86/purgatory/Makefile                        |  3 +-
 drivers/acpi/acpica/evevent.c                      | 11 ---
 drivers/acpi/acpica/hwsleep.c                      | 14 ----
 drivers/acpi/acpica/utglobal.c                     |  4 --
 drivers/fpga/fpga-bridge.c                         |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |  3 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 17 ++++-
 .../gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c   |  2 +-
 drivers/gpu/drm/drm_buddy.c                        |  4 +-
 drivers/gpu/drm/i915/display/intel_dp_aux.c        |  2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  4 ++
 drivers/gpu/drm/tests/drm_buddy_test.c             |  3 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  2 +-
 drivers/iio/dac/ad5755.c                           |  1 +
 drivers/iio/light/tsl2772.c                        |  1 +
 drivers/input/tablet/pegasus_notetaker.c           |  6 ++
 drivers/input/touchscreen/cyttsp5.c                |  1 +
 drivers/memstick/core/memstick.c                   |  5 +-
 drivers/mmc/host/sdhci_am654.c                     |  2 -
 drivers/mtd/spi-nor/core.c                         | 14 +++-
 drivers/mtd/spi-nor/core.h                         |  2 +
 drivers/mtd/spi-nor/debugfs.c                      | 11 ++-
 drivers/net/bonding/bond_main.c                    |  7 +-
 drivers/net/dsa/b53/b53_mmap.c                     | 14 ++++
 drivers/net/dsa/microchip/ksz8795.c                |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  4 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 51 +++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  9 ++-
 .../ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c |  2 +
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |  2 +-
 drivers/net/ethernet/sfc/efx.c                     |  1 -
 drivers/net/ethernet/sfc/efx_common.c              |  2 +
 drivers/net/virtio_net.c                           |  8 ++-
 drivers/net/wireless/ath/ath9k/mci.c               |  4 +-
 drivers/net/xen-netback/netback.c                  |  6 +-
 drivers/nvme/host/tcp.c                            | 46 +++++++------
 drivers/pci/msi/msi.c                              |  9 +--
 drivers/perf/amlogic/meson_g12_ddr_pmu.c           | 34 ++++-----
 drivers/platform/x86/asus-nb-wmi.c                 |  3 +-
 drivers/platform/x86/gigabyte-wmi.c                |  3 +
 drivers/platform/x86/intel/vsec.c                  |  1 +
 drivers/pwm/core.c                                 | 12 +++-
 drivers/regulator/fan53555.c                       | 13 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c          |  2 +-
 drivers/scsi/scsi.c                                | 11 ++-
 drivers/spi/spi-rockchip-sfc.c                     |  2 +-
 fs/btrfs/discard.c                                 | 21 +++---
 fs/cifs/cifs_dfs_ref.c                             |  2 -
 fs/cifs/dfs.h                                      | 22 ++++--
 fs/fs-writeback.c                                  | 17 +++--
 fs/nilfs2/segment.c                                | 20 ++++++
 fs/userfaultfd.c                                   |  6 +-
 include/acpi/actypes.h                             |  3 +-
 include/linux/kmsan.h                              | 39 ++++++-----
 include/linux/skbuff.h                             |  5 +-
 include/net/netfilter/nf_tables.h                  |  4 ++
 include/trace/events/f2fs.h                        |  2 +-
 init/Kconfig                                       | 10 +--
 kernel/bpf/verifier.c                              | 15 ++++
 kernel/fork.c                                      |  1 +
 kernel/sys.c                                       | 69 +++++++++++--------
 lib/maple_tree.c                                   | 66 +++++++++---------
 mm/backing-dev.c                                   | 12 +++-
 mm/huge_memory.c                                   | 19 +++--
 mm/khugepaged.c                                    |  4 ++
 mm/kmsan/hooks.c                                   | 55 ++++++++++++---
 mm/kmsan/shadow.c                                  | 27 +++++---
 mm/mmap.c                                          | 48 +++++++++++--
 mm/page_alloc.c                                    | 19 +++++
 mm/vmalloc.c                                       | 10 ++-
 net/bridge/br_netfilter_hooks.c                    | 17 +++--
 net/bridge/br_switchdev.c                          | 11 +++
 net/ipv6/rpl.c                                     |  3 +-
 net/mptcp/protocol.c                               | 74 +++++++++++++-------
 net/mptcp/protocol.h                               |  2 +
 net/mptcp/subflow.c                                | 80 +++++++++++++++++++++-
 net/netfilter/nf_tables_api.c                      | 69 ++++++++++++++++---
 net/netfilter/nft_lookup.c                         | 36 ++--------
 net/sched/sch_qfq.c                                | 13 ++--
 rust/kernel/print.rs                               |  6 +-
 rust/kernel/str.rs                                 |  2 +-
 scripts/asn1_compiler.c                            |  2 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/fsl/fsl_asrc_dma.c                       | 11 ++-
 sound/soc/fsl/fsl_sai.c                            |  2 +-
 sound/soc/sof/ipc4-topology.c                      | 10 +--
 sound/soc/sof/pm.c                                 |  8 ++-
 .../selftests/sigaltstack/current_stack_pointer.h  | 23 +++++++
 tools/testing/selftests/sigaltstack/sas.c          |  7 +-
 tools/vm/page_owner_sort.c                         |  2 +-
 126 files changed, 1017 insertions(+), 466 deletions(-)


