Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1958412511
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353602AbhITSlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348864AbhITSia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0916331E;
        Mon, 20 Sep 2021 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159005;
        bh=az6dYtRYoTwvrcsBSPQDBSURJLGAafpRH/rgG3Bb+Po=;
        h=From:To:Cc:Subject:Date:From;
        b=JKHGQaQy7y5aOoaMpoyymCTaJiKnqfzymJgCr2hYjdK+KqBkBrdLRF9cXbP0n+CR/
         vdjEWVJqC2utLzK9Ay6nsKdnz0KWXWVOU7iBegrF2P4v1jX1oim3TgxT5cnI3Qqovs
         j/cmrYREeKkM6YCCjbZj6pGWsnWOWbdYE/GEHesU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/168] 5.14.7-rc1 review
Date:   Mon, 20 Sep 2021 18:42:18 +0200
Message-Id: <20210920163921.633181900@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.7-rc1
X-KernelTest-Deadline: 2021-09-22T16:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.7 release.
There are 168 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.7-rc1

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: sh_eth: Fix freeing wrong tx descriptor

Heiner Kallweit <hkallweit1@gmail.com>
    cxgb3: fix oops on module removal

Randy Dunlap <rdunlap@infradead.org>
    mfd: lpc_sch: Rename GPIOBASE to prevent build error

Willem de Bruijn <willemb@google.com>
    ip6_gre: Revert "ip6_gre: add validation for csum_start"

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible unintended driver initiated error recovery

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix asic.rev in devlink dev info command

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix stored FW_PSID version masks

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix IMP port setup on BCM5301x

Willem de Bruijn <willemb@google.com>
    ip_gre: validate csum_start only on pull

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iwlwifi: pnvm: Fix a memory leak in 'iwl_pnvm_get_from_fs()'

Dror Moshe <drorx.moshe@intel.com>
    iwlwifi: move get pnvm file name to a separate function

Dinghao Liu <dinghao.liu@zju.edu.cn>
    qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Eric Dumazet <edumazet@google.com>
    fq_codel: reject silly quantum parameters

Benjamin Hesmans <benjamin.hesmans@tessares.net>
    netfilter: socket: icmp6: fix use-after-scope

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: Only send extra TCP acks in eligible socket states

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Set correct number of ports in the DSA struct

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix calculating number of switch ports

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: hso: add failure handler for add_net_device

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: clean tmp files in simult_flows

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix possible divide by zero

James Clark <james.clark@arm.com>
    tools build: Fix feature detect clean for out of source builds

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: tag_rtl4_a: Fix egress tags

Ming Lei <ming.lei@redhat.com>
    io_uring: retry in case of short read on block device

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gpio: mpc8xxx: Use 'devm_gpiochip_add_data()' to simplify the code and avoid a leak

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gpio: mpc8xxx: Fix a potential double iounmap call in 'mpc8xxx_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gpio: mpc8xxx: Fix a resources leak in the error handling path of 'mpc8xxx_probe()'

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bench inject-buildid: Handle writen() errors

Li Huafei <lihuafei1@huawei.com>
    perf unwind: Do not overwrite FEATURE_CHECK_LDFLAGS-libunwind-{x86,aarch64}

Arnaldo Carvalho de Melo <acme@kernel.org>
    perf config: Fix caching and memory leak in perf_home_perfconfig()

Randy Dunlap <rdunlap@infradead.org>
    ARC: export clear_user_page() for modules

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Curtis Klein <curtis.klein@hpe.com>
    watchdog: Fix NULL pointer dereference when releasing cdev

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Jakub Kicinski <kuba@kernel.org>
    PCI/PTM: Remove error message at boot

Oliver Upton <oupton@google.com>
    KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Oliver Upton <oupton@google.com>
    KVM: arm64: Fix read-side race on updates to vcpu reset state

Zhihao Cheng <chengzhihao1@huawei.com>
    mtd: mtdconcat: Check _read, _write callbacks existence before assignment

Zhihao Cheng <chengzhihao1@huawei.com>
    mtd: mtdconcat: Judge callback existence based on the master

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/boot: Fix a hist trigger dependency for boot time tracing

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    mfd: tqmx86: Clear GPIO IRQ resource when no IRQ is set

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Anshuman Khandual <anshuman.khandual@arm.com>
    KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and 16K page size

Pavel Skripkin <paskripkin@gmail.com>
    netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex

Rob Herring <robh@kernel.org>
    PCI: iproc: Fix BCMA probe resource handling

Rob Herring <robh@kernel.org>
    PCI: of: Don't fail devm_pci_alloc_host_bridge() on missing 'ranges'

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: controller: PCI_IXP4XX should depend on ARCH_IXP4XX

Linus Walleij <linus.walleij@linaro.org>
    backlight: ktd253: Stabilize backlight

Hans de Goede <hdegoede@redhat.com>
    mfd: axp20x: Update AXP288 volatile ranges

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: add suspend/resume support

zhaoxiao <long870912@gmail.com>
    stmmac: dwmac-loongson:Fix missing return value

Yang Li <yang.lee@linux.alibaba.com>
    NTB: perf: Fix an error code in perf_setup_inbuf()

Yang Li <yang.lee@linux.alibaba.com>
    NTB: Fix an error code in ntb_msit_probe()

Yang Li <yang.lee@linux.alibaba.com>
    ethtool: Fix an error code in cxgb2.c

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    loop: reduce the loop_ctl_mutex scope

Vishal Aslot <os.vaslot@gmail.com>
    PCI: ibmphp: Fix double unmap of io_mem

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: honor already-setup queue merges

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    flow: fix object-size-mismatch warning in flowi{4,6}_to_flowi_common()

Ryoga Saito <contact@proelbtn.com>
    Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

Smadar Fuks <smadarf@marvell.com>
    octeontx2-af: Add additional register check to rvu_poll_reg()

Jan Kiszka <jan.kiszka@siemens.com>
    watchdog: Start watchdog in watchdog_set_last_hw_keepalive only if appropriate

George Cherian <george.cherian@marvell.com>
    PCI: Add ACS quirks for Cavium multi-function devices

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: j721e: Add PCIe support for AM64

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: j721e: Add PCIe support for J7200

Nadeem Athani <nadeem@cadence.com>
    PCI: cadence: Add quirk flag to set minimum delay in LTSSM Detect.Quiet state

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: cadence: Use bitfield for *quirk_retrain_flag* instead of bool

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/probes: Reject events which have the same name of existing one

Will Deacon <will@kernel.org>
    KVM: arm64: Make hyp_panic() more robust when protected mode is enabled

Kenneth Lee <liguozhu@hisilicon.com>
    riscv: fix the global name pfn_base confliction error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    PCI: rcar: Fix runtime PM imbalance in rcar_pcie_ep_probe()

Marc Zyngier <maz@kernel.org>
    mfd: Don't use irq_create_mapping() to resolve a mapping

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: tegra: Fix OF node reference leak

Om Prakash Singh <omp@nvidia.com>
    PCI: tegra194: Fix MSI-X programming

Om Prakash Singh <omp@nvidia.com>
    PCI: tegra194: Fix handling BME_CHGED event

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix use after free in fuse_read_interrupt()

Wasim Khan <wasim.khan@nxp.com>
    PCI: Add ACS quirks for NXP LX2xx0 and LX2xx2 platforms

Linus Walleij <linus.walleij@linaro.org>
    mfd: db8500-prcmu: Adjust map to reality

Bjorn Andersson <bjorn.andersson@linaro.org>
    remoteproc: qcom: wcnss: Fix race with iris probe

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

David Thompson <davthompson@nvidia.com>
    mlxbf_gige: clear valid_polarity upon open

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports

Yanfei Xu <yanfei.xu@windriver.com>
    blkcg: fix memory leak in blk_iolatency_init

Daniel Wagner <dwagner@suse.de>
    nvme: avoid race in shutdown namespace removal

Jiaran Zhang <zhangjiaran@huawei.com>
    net: hns3: fix the exception when query imp info

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: dsa: lantiq_gswip: Add 200ms assert delay

Ansuel Smith <ansuelsmth@gmail.com>
    net: dsa: qca8k: fix kernel panic with legacy mdio mapping

Dave Ertman <david.m.ertman@intel.com>
    ice: Correctly deal with PFs that do not support RDMA

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix mutual exclusion between CQE compression and HW TS

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: vmbus: Fix kernel crash upon unbinding a device from uio_hv_generic driver

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP

Jiaran Zhang <zhangjiaran@huawei.com>
    net: hns3: fix the timing issue of VF clearing interrupt sources

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: disable mac in flr process

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: change affinity_mask to numa node range

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: pad the short tunnel frame before sending to hardware

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()

David Hildenbrand <david@redhat.com>
    s390/pci_mmio: fully validate the VMA before calling follow_pte()

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc/mce: Fix access error in mce handler

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: system call rfscv workaround for TM bugs

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: check failover_pending in login response

David Heidelberg <david@ixit.cz>
    dt-bindings: arm: Fix Toradex compatible typo

Aya Levin <ayal@nvidia.com>
    udp_tunnel: Fix udp_tunnel_nic work-queue type

Shai Malin <smalin@marvell.com>
    qed: Handle management FW error

Andrea Claudi <aclaudi@redhat.com>
    selftest: net: fix typo in altname test

zhenggy <zhenggy@chinatelecom.cn>
    tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

Will Deacon <will@kernel.org>
    x86/uaccess: Fix 32-bit __get_user_asm_u64() when CC_HAS_ASM_GOTO_OUTPUT=y

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup

Eric Dumazet <edumazet@google.com>
    net/af_unix: fix a data-race in unix_dgram_poll

Paolo Abeni <pabeni@redhat.com>
    vhost_net: fix OoB on sendmsg() failure.

Kortan <kortanzh@gmail.com>
    gen_compile_commands: fix missing 'sys' package

Alex Elder <elder@linaro.org>
    net: ipa: initialize all filter table slots

Baptiste Lepers <baptiste.lepers@gmail.com>
    events: Reuse value read using READ_ONCE instead of re-reading it

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: system call scv tabort fix for corrupt irq soft-mask state

Keith Busch <kbusch@kernel.org>
    nvme-tcp: fix io_work priority inversion

Paolo Abeni <pabeni@redhat.com>
    igc: fix tunnel offloading

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix potential sleeping in atomic context

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: FWTrace, cancel work on alloc pd error flow

Michael Petlan <mpetlan@redhat.com>
    perf machine: Initialize srcline string member in add_location struct

Lee Shawn C <shawn.c.lee@intel.com>
    drm/i915/dp: return proper DPRX link training result

Chris Wilson <chris@chris-wilson.co.uk>
    rtc: cmos: Disable irq around direct invocation of cmos_interrupt()

Arnd Bergmann <arnd@arndb.de>
    drm/rockchip: cdn-dp-core: Make cdn_dp_core_resume __maybe_unused

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: increase timeout in tipc_sk_enqueue()

Florian Fainelli <f.fainelli@gmail.com>
    r6040: Restore MDIO clock frequency after MAC reset

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Lin, Zhenpeng <zplin@psu.edu>
    dccp: don't duplicate ccid when cloning dccp sock

Randy Dunlap <rdunlap@infradead.org>
    ptp: dp83640: don't define PAGE0

Eric Dumazet <edumazet@google.com>
    net-caif: avoid user-triggerable WARN_ON(1)

Eli Cohen <elic@nvidia.com>
    net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert

王贇 <yun.wang@linux.alibaba.com>
    net: remove the unnecessary check in cipso_v4_doi_free

Saeed Mahameed <saeedm@nvidia.com>
    ethtool: Fix rxnfc copy to user buffer overflow

Xin Long <lucien.xin@gmail.com>
    tipc: fix an use-after-free issue in tipc_recvmsg

Tony Luck <tony.luck@intel.com>
    x86/mce: Avoid infinite loop for copy from user recovery

Mike Rapoport <rppt@kernel.org>
    x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Jeff Moyer <jmoyer@redhat.com>
    x86/pat: Pass valid address to sanitize_phys()

Dan Carpenter <dan.carpenter@oracle.com>
    net: qrtr: revert check in qrtr_endpoint_post()

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/sclp: fix Secure-IPL facility detection

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: add missing MMU context put when reaping MMU mapping

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: reference MMU context when setting up hardware state

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix MMU context leak on GPU reset

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: exec and MMU state is lost when resetting the GPU

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: keep MMU context across runtime suspend/resume

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: stop abusing mmu_context as FE running marker

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: put submit prev MMU context when it exists

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: return context from etnaviv_iommu_context_get

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/i915/dp: Use max params for panels < eDP 1.4

Jens Axboe <axboe@kernel.dk>
    io_uring: allow retry for O_NONBLOCK if async is supported

Nirmoy Das <nirmoy.das@amd.com>
    drm/radeon: pass drm dev radeon_agp_head_init directly

James Zhu <James.Zhu@amd.com>
    drm/amdkfd: separate kfd_iommu_resume from kfd_resume

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: fix the issue of uploading powerplay table

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: move iommu_resume before ip init/resume

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: add amdgpu_amdkfd_resume_iommu

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix use after free during BO move

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: use IS_ERR for debugfs APIs

Ernst Sjöstrand <ernstp@gmail.com>
    drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fix runpm hang when amdgpu loaded prior to sound driver

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix white screen page fault for gpuvm

Hersen Wu <hersenwu@amd.com>
    drm/amd/display: dsc mst 2 4K displays go dark with 2 lane HBR3

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Get backlight from PWM if DMCU is not initialized

Evan Quan <evan.quan@amd.com>
    PCI: Add AMD GPU multi-function power dependencies

Juergen Gross <jgross@suse.com>
    PM: base: power: don't try to use non-existing RTC for storing data

Mark Brown <broonie@kernel.org>
    arm64/sve: Use correct size when reinitialising SVE state

Adrian Bunk <bunk@kernel.org>
    bnx2x: Fix enabling network interfaces without VFs

Juergen Gross <jgross@suse.com>
    xen: fix usage of pmd_populate in mremap for pv guests

Juergen Gross <jgross@suse.com>
    xen: reset legacy rtc flag for PV domU

Jan Beulich <jbeulich@suse.com>
    swiotlb-xen: fix late init retry

Jan Beulich <jbeulich@suse.com>
    swiotlb-xen: avoid double free

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure symmetry in handling iter types in loop_rw_iter()


-------------

Diffstat:

 Documentation/devicetree/bindings/arm/tegra.yaml   |   2 +-
 .../devicetree/bindings/mtd/gpmc-nand.txt          |   2 +-
 Makefile                                           |   4 +-
 arch/arc/mm/cache.c                                |   2 +-
 arch/arm64/kernel/fpsimd.c                         |   2 +-
 arch/arm64/kvm/arm.c                               |   8 ++
 arch/arm64/kvm/handle_exit.c                       |  23 ++--
 arch/arm64/kvm/hyp/nvhe/host.S                     |  21 +++-
 arch/arm64/kvm/reset.c                             |  24 +++--
 arch/powerpc/kernel/interrupt.c                    |  43 ++++++++
 arch/powerpc/kernel/interrupt_64.S                 |  41 -------
 arch/powerpc/kernel/mce.c                          |  17 ++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  36 ++++++-
 arch/riscv/include/asm/page.h                      |   4 +-
 arch/riscv/mm/init.c                               |   6 +-
 arch/s390/pci/pci_mmio.c                           |   4 +-
 arch/x86/include/asm/uaccess.h                     |   4 +-
 arch/x86/kernel/cpu/mce/core.c                     |  43 ++++++--
 arch/x86/mm/init_64.c                              |   6 +-
 arch/x86/mm/pat/memtype.c                          |   7 +-
 arch/x86/xen/enlighten_pv.c                        |   7 ++
 arch/x86/xen/mmu_pv.c                              |   7 +-
 block/bfq-iosched.c                                |  16 ++-
 block/blk-cgroup.c                                 |  10 +-
 drivers/base/power/trace.c                         |  10 ++
 drivers/block/loop.c                               |  75 ++++++++-----
 drivers/block/loop.h                               |   1 +
 drivers/gpio/gpio-mpc8xxx.c                        |  13 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  10 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   7 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  12 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  18 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  12 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  24 +++--
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  18 ++--
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.h    |  11 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  16 ++-
 .../gpu/drm/amd/display/dc/dce/dce_panel_cntl.c    |  10 --
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |  24 ++++-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |  21 ++++
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h             |   2 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  43 ++++----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |   1 +
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c            |   4 +
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c         |   8 ++
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |   4 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   5 +-
 .../gpu/drm/i915/display/intel_dp_link_training.c  |   2 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   2 +-
 drivers/hv/ring_buffer.c                           |   1 +
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/axp20x.c                               |   3 +-
 drivers/mfd/db8500-prcmu.c                         |  14 ++-
 drivers/mfd/lpc_sch.c                              |   4 +-
 drivers/mfd/stmpe.c                                |   4 +-
 drivers/mfd/tc3589x.c                              |   2 +-
 drivers/mfd/tqmx86.c                               |   2 +
 drivers/mfd/wm8994-irq.c                           |   2 +-
 drivers/mtd/mtdconcat.c                            |  33 ++++--
 drivers/mtd/nand/raw/cafe_nand.c                   |   4 +-
 drivers/net/dsa/b53/b53_common.c                   |  34 ++++--
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/lantiq_gswip.c                     |   6 ++
 drivers/net/dsa/qca8k.c                            |  30 ++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  38 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   3 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   1 +
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  19 ++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 ++
 drivers/net/ethernet/intel/ice/ice.h               |   2 +
 drivers/net/ethernet/intel/ice/ice_idc.c           |   6 ++
 drivers/net/ethernet/intel/igc/igc_main.c          |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  12 ++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   3 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |   7 ++
 .../net/ethernet/netronome/nfp/flower/offload.c    |   3 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   1 -
 drivers/net/ethernet/rdc/r6040.c                   |   9 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  14 ---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  44 ++++++++
 drivers/net/ipa/ipa_table.c                        |   3 +-
 drivers/net/phy/dp83640_reg.h                      |   2 +-
 drivers/net/phy/phylink.c                          |  82 ++++++++++++++
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/hso.c                              |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  19 ++--
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |  20 ++++
 drivers/ntb/test/ntb_msi_test.c                    |   4 +-
 drivers/ntb/test/ntb_perf.c                        |   1 +
 drivers/nvme/host/core.c                           |  15 ++-
 drivers/nvme/host/tcp.c                            |  20 ++--
 drivers/pci/controller/Kconfig                     |   1 +
 drivers/pci/controller/cadence/pci-j721e.c         |  61 ++++++++++-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   4 +
 drivers/pci/controller/cadence/pcie-cadence-host.c |   3 +
 drivers/pci/controller/cadence/pcie-cadence.c      |  16 +++
 drivers/pci/controller/cadence/pcie-cadence.h      |  17 ++-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  32 +++---
 drivers/pci/controller/pci-tegra.c                 |  13 ++-
 drivers/pci/controller/pcie-iproc-bcma.c           |  16 ++-
 drivers/pci/controller/pcie-rcar-ep.c              |   4 +-
 drivers/pci/hotplug/TODO                           |   3 -
 drivers/pci/hotplug/ibmphp_ebda.c                  |   5 +-
 drivers/pci/of.c                                   |   2 +-
 drivers/pci/pci.c                                  |   2 +-
 drivers/pci/pcie/ptm.c                             |   4 +-
 drivers/pci/quirks.c                               |  58 +++++++++-
 drivers/remoteproc/qcom_wcnss.c                    |  49 +++------
 drivers/remoteproc/qcom_wcnss.h                    |   4 +-
 drivers/remoteproc/qcom_wcnss_iris.c               | 120 +++++++++++++--------
 drivers/rtc/rtc-cmos.c                             |   2 +
 drivers/s390/char/sclp_early.c                     |   3 +-
 drivers/vhost/net.c                                |  11 +-
 drivers/video/backlight/ktd253-backlight.c         |  75 +++++++++----
 drivers/watchdog/watchdog_dev.c                    |   8 +-
 drivers/xen/swiotlb-xen.c                          |   5 +-
 fs/fuse/dev.c                                      |   4 +-
 fs/io_uring.c                                      |  33 ++++--
 include/linux/pci.h                                |   5 +-
 include/linux/pci_ids.h                            |   3 +-
 include/linux/phylink.h                            |   3 +
 include/linux/sched.h                              |   1 +
 include/linux/skbuff.h                             |   2 +-
 include/net/dsa.h                                  |   5 +
 include/net/flow.h                                 |   4 +-
 include/uapi/linux/pkt_sched.h                     |   2 +
 kernel/events/core.c                               |   2 +-
 kernel/trace/trace_boot.c                          |  15 +--
 kernel/trace/trace_kprobe.c                        |   6 +-
 kernel/trace/trace_probe.c                         |  25 +++++
 kernel/trace/trace_probe.h                         |   1 +
 kernel/trace/trace_uprobe.c                        |   6 +-
 net/caif/chnl_net.c                                |  19 +---
 net/dccp/minisocks.c                               |   2 +
 net/dsa/dsa.c                                      |   5 +
 net/dsa/dsa2.c                                     |  46 +++++---
 net/dsa/dsa_priv.h                                 |   1 +
 net/dsa/slave.c                                    |  12 +--
 net/dsa/tag_rtl4_a.c                               |   7 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv4/cipso_ipv4.c                              |  18 ++--
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/nexthop.c                                 |   2 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv6/ip6_gre.c                                 |   2 -
 net/ipv6/netfilter/nf_socket_ipv6.c                |   4 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/mptcp/pm_netlink.c                             |  10 +-
 net/mptcp/protocol.c                               |  97 ++++++++---------
 net/mptcp/protocol.h                               |   1 +
 net/netfilter/nft_ct.c                             |   9 +-
 net/qrtr/qrtr.c                                    |   2 +-
 net/sched/sch_fq_codel.c                           |  12 ++-
 net/tipc/socket.c                                  |  10 +-
 net/unix/af_unix.c                                 |   2 +-
 scripts/clang-tools/gen_compile_commands.py        |   1 +
 tools/build/Makefile                               |   2 +-
 tools/perf/Makefile.config                         |   8 +-
 tools/perf/bench/inject-buildid.c                  |  52 +++++----
 tools/perf/util/config.c                           |   5 +-
 tools/perf/util/machine.c                          |   1 +
 tools/testing/selftests/net/altnames.sh            |   2 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   4 +-
 188 files changed, 1562 insertions(+), 717 deletions(-)


