Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE50A4123E9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377708AbhITS2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378759AbhITS0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4A1632D1;
        Mon, 20 Sep 2021 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158732;
        bh=h4RJ1lQVD+WuTghDuN1QCT9ml8gfqYz5S+gAOp9ri18=;
        h=From:To:Cc:Subject:Date:From;
        b=pXpAzMyff3r3ozHp/CaA/utr6uUqATSjTDMj6wKwjOOhiapxJgTwn1GwzigVdlJtG
         t4MLBW1q2HRdc76GaxzyjBfkPkv5QrP4lOSo+AeUsVKBwL3REkm7j/OAxhmcIGaCf6
         EJRVx+qdXY43e7CWVRpckZgHh6BNYPDSAv1/ANTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/122] 5.10.68-rc1 review
Date:   Mon, 20 Sep 2021 18:42:52 +0200
Message-Id: <20210920163915.757887582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.68-rc1
X-KernelTest-Deadline: 2021-09-22T16:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.68 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.68-rc1

Tony Luck <tony.luck@intel.com>
    x86/mce: Avoid infinite loop for copy from user recovery

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: sh_eth: Fix freeing wrong tx descriptor

Randy Dunlap <rdunlap@infradead.org>
    mfd: lpc_sch: Rename GPIOBASE to prevent build error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: lpc_sch: Partially revert "Add support for Intel Quark X1000"

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible unintended driver initiated error recovery

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve logging of error recovery settings information.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Convert to use netif_level() helpers.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Consolidate firmware reset event logging.

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: log firmware debug notifications

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix asic.rev in devlink dev info command

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix stored FW_PSID version masks

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix IMP port setup on BCM5301x

Willem de Bruijn <willemb@google.com>
    ip_gre: validate csum_start only on pull

Dinghao Liu <dinghao.liu@zju.edu.cn>
    qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Eric Dumazet <edumazet@google.com>
    fq_codel: reject silly quantum parameters

Benjamin Hesmans <benjamin.hesmans@tessares.net>
    netfilter: socket: icmp6: fix use-after-scope

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Set correct number of ports in the DSA struct

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix calculating number of switch ports

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: hso: add failure handler for add_net_device

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: clean tmp files in simult_flows

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: tag_rtl4_a: Fix egress tags

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

Randy Dunlap <rdunlap@infradead.org>
    ARC: export clear_user_page() for modules

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

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

Gustavo A. R. Silva <gustavoars@kernel.org>
    netfilter: Fix fall-through warnings for Clang

Rob Herring <robh@kernel.org>
    PCI: iproc: Fix BCMA probe resource handling

Rob Herring <robh@kernel.org>
    PCI: of: Don't fail devm_pci_alloc_host_bridge() on missing 'ranges'

Linus Walleij <linus.walleij@linaro.org>
    backlight: ktd253: Stabilize backlight

Hans de Goede <hdegoede@redhat.com>
    mfd: axp20x: Update AXP288 volatile ranges

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: add suspend/resume support

Yang Li <yang.lee@linux.alibaba.com>
    NTB: perf: Fix an error code in perf_setup_inbuf()

Yang Li <yang.lee@linux.alibaba.com>
    NTB: Fix an error code in ntb_msit_probe()

Yang Li <yang.lee@linux.alibaba.com>
    ethtool: Fix an error code in cxgb2.c

Vishal Aslot <os.vaslot@gmail.com>
    PCI: ibmphp: Fix double unmap of io_mem

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: honor already-setup queue merges

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

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

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

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

Keith Busch <kbusch@kernel.org>
    nvme-tcp: fix io_work priority inversion

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix potential sleeping in atomic context

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: FWTrace, cancel work on alloc pd error flow

Michael Petlan <mpetlan@redhat.com>
    perf machine: Initialize srcline string member in add_location struct

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

Saeed Mahameed <saeedm@nvidia.com>
    ethtool: Fix rxnfc copy to user buffer overflow

Xin Long <lucien.xin@gmail.com>
    tipc: fix an use-after-free issue in tipc_recvmsg

Mike Rapoport <rppt@kernel.org>
    x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Jeff Moyer <jmoyer@redhat.com>
    x86/pat: Pass valid address to sanitize_phys()

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

Ernst Sjöstrand <ernstp@gmail.com>
    drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10

Evan Quan <evan.quan@amd.com>
    PCI: Add AMD GPU multi-function power dependencies

Juergen Gross <jgross@suse.com>
    PM: base: power: don't try to use non-existing RTC for storing data

Mark Brown <broonie@kernel.org>
    arm64/sve: Use correct size when reinitialising SVE state

Adrian Bunk <bunk@kernel.org>
    bnx2x: Fix enabling network interfaces without VFs

Juergen Gross <jgross@suse.com>
    xen: reset legacy rtc flag for PV domU

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure symmetry in handling iter types in loop_rw_iter()

Anand Jain <anand.jain@oracle.com>
    btrfs: fix upper limit for max_inline for page size 64K

Robert Foss <robert.foss@linaro.org>
    drm/bridge: lt9611: Fix handling of 4k panels


-------------

Diffstat:

 Documentation/devicetree/bindings/arm/tegra.yaml   |  2 +-
 .../devicetree/bindings/mtd/gpmc-nand.txt          |  2 +-
 Makefile                                           |  4 +-
 arch/arc/mm/cache.c                                |  2 +-
 arch/arm64/kernel/fpsimd.c                         |  2 +-
 arch/arm64/kvm/arm.c                               |  8 +++
 arch/arm64/kvm/reset.c                             | 24 +++++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            | 36 +++++++++-
 arch/x86/include/asm/uaccess.h                     |  4 +-
 arch/x86/kernel/cpu/mce/core.c                     | 43 +++++++++---
 arch/x86/mm/init_64.c                              |  6 +-
 arch/x86/mm/pat/memtype.c                          |  7 +-
 arch/x86/xen/enlighten_pv.c                        |  7 ++
 block/bfq-iosched.c                                | 16 ++++-
 drivers/base/power/trace.c                         | 10 +++
 drivers/gpio/gpio-mpc8xxx.c                        | 13 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  2 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |  8 ++-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |  3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |  3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              | 43 +++++++-----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c            |  4 ++
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c         |  8 +++
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |  4 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |  2 +-
 drivers/mfd/ab8500-core.c                          |  2 +-
 drivers/mfd/axp20x.c                               |  3 +-
 drivers/mfd/db8500-prcmu.c                         | 14 ++--
 drivers/mfd/lpc_sch.c                              | 36 +++-------
 drivers/mfd/stmpe.c                                |  4 +-
 drivers/mfd/tc3589x.c                              |  2 +-
 drivers/mfd/tqmx86.c                               |  2 +
 drivers/mfd/wm8994-irq.c                           |  2 +-
 drivers/mtd/mtdconcat.c                            | 33 ++++++---
 drivers/mtd/nand/raw/cafe_nand.c                   |  4 +-
 drivers/net/dsa/b53/b53_common.c                   | 33 +++++++--
 drivers/net/dsa/b53/b53_priv.h                     |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 80 ++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |  3 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  8 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 19 ++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  8 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 12 +++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  3 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  5 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  3 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |  6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |  1 -
 drivers/net/ethernet/rdc/r6040.c                   |  9 ++-
 drivers/net/ethernet/renesas/sh_eth.c              |  1 +
 drivers/net/ipa/ipa_table.c                        |  3 +-
 drivers/net/phy/dp83640_reg.h                      |  2 +-
 drivers/net/phy/phylink.c                          | 82 ++++++++++++++++++++++
 drivers/net/usb/cdc_mbim.c                         |  5 ++
 drivers/net/usb/hso.c                              | 11 ++-
 drivers/ntb/test/ntb_msi_test.c                    |  4 +-
 drivers/ntb/test/ntb_perf.c                        |  1 +
 drivers/nvme/host/tcp.c                            | 20 +++---
 drivers/pci/controller/cadence/pci-j721e.c         | 61 ++++++++++++++--
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |  4 ++
 drivers/pci/controller/cadence/pcie-cadence-host.c |  3 +
 drivers/pci/controller/cadence/pcie-cadence.c      | 16 +++++
 drivers/pci/controller/cadence/pcie-cadence.h      | 17 ++++-
 drivers/pci/controller/dwc/pcie-tegra194.c         | 32 ++++-----
 drivers/pci/controller/pci-tegra.c                 | 13 ++--
 drivers/pci/controller/pcie-iproc-bcma.c           | 16 ++---
 drivers/pci/controller/pcie-rcar-ep.c              |  4 +-
 drivers/pci/hotplug/TODO                           |  3 -
 drivers/pci/hotplug/ibmphp_ebda.c                  |  5 +-
 drivers/pci/of.c                                   |  2 +-
 drivers/pci/pci.c                                  |  2 +-
 drivers/pci/quirks.c                               | 58 ++++++++++++++-
 drivers/s390/char/sclp_early.c                     |  3 +-
 drivers/vhost/net.c                                | 11 ++-
 drivers/video/backlight/ktd253-backlight.c         | 75 ++++++++++++++------
 drivers/watchdog/watchdog_dev.c                    |  5 +-
 fs/btrfs/disk-io.c                                 | 45 ++++++------
 fs/fuse/dev.c                                      |  4 +-
 fs/io_uring.c                                      |  9 ++-
 include/linux/memory_hotplug.h                     |  4 +-
 include/linux/pci.h                                |  5 +-
 include/linux/pci_ids.h                            |  3 +-
 include/linux/phylink.h                            |  3 +
 include/linux/sched.h                              |  1 +
 include/linux/skbuff.h                             |  2 +-
 include/uapi/linux/pkt_sched.h                     |  2 +
 kernel/events/core.c                               |  2 +-
 kernel/trace/trace_boot.c                          | 15 ++--
 kernel/trace/trace_kprobe.c                        |  6 +-
 kernel/trace/trace_probe.c                         | 25 +++++++
 kernel/trace/trace_probe.h                         |  1 +
 kernel/trace/trace_uprobe.c                        |  6 +-
 mm/memory_hotplug.c                                |  4 +-
 net/caif/chnl_net.c                                | 19 +----
 net/dccp/minisocks.c                               |  2 +
 net/dsa/slave.c                                    | 12 ++--
 net/dsa/tag_rtl4_a.c                               |  7 +-
 net/ethtool/ioctl.c                                |  2 +-
 net/ipv4/ip_gre.c                                  |  9 ++-
 net/ipv4/nexthop.c                                 |  2 +
 net/ipv4/tcp_input.c                               |  2 +-
 net/ipv4/udp_tunnel_nic.c                          |  2 +-
 net/ipv6/netfilter/nf_socket_ipv6.c                |  4 +-
 net/l2tp/l2tp_core.c                               |  4 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |  1 +
 net/netfilter/nf_tables_api.c                      |  1 +
 net/netfilter/nft_ct.c                             | 10 ++-
 net/sched/sch_fq_codel.c                           | 12 +++-
 net/tipc/socket.c                                  | 10 +--
 net/unix/af_unix.c                                 |  2 +-
 scripts/clang-tools/gen_compile_commands.py        |  1 +
 tools/perf/Makefile.config                         |  8 +--
 tools/perf/bench/inject-buildid.c                  | 52 ++++++++------
 tools/perf/util/machine.c                          |  1 +
 tools/testing/selftests/net/altnames.sh            |  2 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  4 +-
 124 files changed, 950 insertions(+), 394 deletions(-)


