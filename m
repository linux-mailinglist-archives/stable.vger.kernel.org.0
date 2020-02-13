Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFF815C396
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgBMPmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgBMP2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:07 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A2F24688;
        Thu, 13 Feb 2020 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607685;
        bh=9fvPfYQnOmJLm2CPIwafAG3hPxkKOwlyMw7ylt3WbB4=;
        h=From:To:Cc:Subject:Date:From;
        b=wNsoiciZwsbZ/AmgHgDH7qg3CxqeiU+Nj2sffqPzirAzqMsYehGkRmlD7gko6d4WW
         wBudDDVeMhc2Oa2KM73rzSI3s0PKbltzeFIMt0Utryh0XuYhEKH4R9CyyCwBEMZ8oR
         wgZHrp8aTdg5x50/wWfjCd4VFuwgNRNV0ewt1CZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 000/120] 5.5.4-stable review
Date:   Thu, 13 Feb 2020 07:19:56 -0800
Message-Id: <20200213151901.039700531@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.4-rc1
X-KernelTest-Deadline: 2020-02-15T15:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.4 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.4-rc1

Nicolai Stange <nstange@suse.de>
    libertas: make lbs_ibss_join_existing() return error code on rates overflow

Nicolai Stange <nstange@suse.de>
    libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held

Qing Xu <m1s5p6688@gmail.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()

Qing Xu <m1s5p6688@gmail.com>
    mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()

Chuhong Yuan <hslester96@gmail.com>
    dmaengine: axi-dmac: add a check for devm_regmap_init_mmio

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: g12a: fix missing uart2 in regmap table

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    mfd: max77650: Select REGMAP_IRQ in Kconfig

Ben Whitten <ben.whitten@gmail.com>
    regmap: fix writes to non incrementing registers

Stephen Boyd <swboyd@chromium.org>
    pinctrl: qcom: Don't lock around irq_set_irq_wake()

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a77965: Fix DU_DOTCLKIN3 drive/bias control

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: baytrail: Allocate IRQ chip dynamic

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: fix regression introduced by move_mount(2) syscall

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: revert "stop passing MAY_NOT_BLOCK to the AVC upon follow_link"

Dave Hansen <dave.hansen@linux.intel.com>
    x86/alternatives: add missing insn.h include

Coly Li <colyli@suse.de>
    bcache: avoid unnecessary btree nodes flushing in btree_flush_write()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: soc-generic-dmaengine-pcm: Fix error handling

Beniamin Bia <beniamin.bia@analog.com>
    dt-bindings: iio: adc: ad7606: Fix wrong maxItems value

Raul E Rangel <rrangel@chromium.org>
    i2c: cros-ec-tunnel: Fix ACPI identifier

Akshu Agrawal <akshu.agrawal@amd.com>
    i2c: cros-ec-tunnel: Fix slave device enumeration

Gustavo A. R. Silva <gustavo@embeddedor.com>
    media: i2c: adv748x: Fix unsafe macros

Christophe Roullier <christophe.roullier@st.com>
    drivers: watchdog: stm32_iwdg: set WDOG_HW_RUNNING at probe

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam/qi2 - fix typo in algorithm's driver name

Eric Biggers <ebiggers@google.com>
    crypto: atmel-sha - fix error handling when setting hmac key

Eric Biggers <ebiggers@google.com>
    crypto: artpec6 - return correct error code for failed setkey()

Eric Biggers <ebiggers@google.com>
    crypto: testmgr - don't try to decrypt uninitialized buffers

YueHaibing <yuehaibing@huawei.com>
    mtd: sharpslpart: Fix unsigned comparison to zero

Nathan Chancellor <natechancellor@gmail.com>
    mtd: onenand_base: Adjust indentation in onenand_read_ops_nolock

Russell King <rmk+kernel@armlinux.org.uk>
    arm64: kvm: Fix IDMAP overlap with HYP VA

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer

Eric Auger <eric.auger@redhat.com>
    KVM: arm64: pmu: Fix chained SW_INCR counters

Eric Auger <eric.auger@redhat.com>
    KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset

James Morse <james.morse@arm.com>
    KVM: arm: Make inject_abt32() inject an external abort instead

James Morse <james.morse@arm.com>
    KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests

Gavin Shan <gshan@redhat.com>
    KVM: arm/arm64: Fix young bit from mmu notifier

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm/chacha - fix build failured when kernel mode NEON is disabled

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: cpufeature: Fix the type of no FP/SIMD capability

Mark Brown <broonie@kernel.org>
    arm64: kernel: Correct annotation of end of el0_sync

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix a bug in propagating uclamp value in new cgroups

Olof Johansson <olof@lixom.net>
    ARM: 8949/1: mm: mark free_memmap as __init

Eric Auger <eric.auger@redhat.com>
    KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use of_device_id array to find the proper shdwc node

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use SAM9X60 PMC's compatible

Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
    iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-multi-tce for DDW

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/papr_scm: Fix leaking 'bus_desc.provider_name' in some paths

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/ptdump: Only enable PPC_CHECK_WX with STRICT_KERNEL_RWX

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/ptdump: Fix W+X verification call in mark_rodata_ro()

Ram Pai <linuxram@us.ibm.com>
    Revert "powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests"

Douglas Anderson <dianders@chromium.org>
    soc: qcom: rpmhpd: Set 'active_only' for active only power domains

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    tools/power/acpi: fix compilation error

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: sama5d3: fix maximum peripheral clock rates

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8b: use the actual frequency for the GPU's 364MHz OPP

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: use the actual frequency for the GPU's 182.1MHz OPP

Baruch Siach <baruch@tkos.co.il>
    arm64: dts: marvell: clearfog-gt-8k: fix switch cpu port node

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    arm64: dts: renesas: r8a77990: ebisu: Remove clkout-lr-synchronous from sound

Tero Kristo <t-kristo@ti.com>
    ARM: dts: am43xx: add support for clkout1 clock

Ingo van Lil <inguin@gmx.de>
    ARM: dts: at91: Reenable UART TX pull-ups

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: msm8998-mtp: Add alias for blsp1_uart3

Russell King <rmk+kernel@armlinux.org.uk>
    arm64: dts: uDPU: fix broken ethernet

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    arm64: dts: qcom: msm8998: Fix tcsr syscon size

Mika Westerberg <mika.westerberg@linux.intel.com>
    platform/x86: intel_mid_powerbtn: Take a copy of ddata

Jose Abreu <Jose.Abreu@synopsys.com>
    ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_init()

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    watchdog: qcom: Use platform_get_irq_optional() for bark irq

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    rtc: cmos: Stop using shared IRQ

Geert Uytterhoeven <geert@linux-m68k.org>
    rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    rtc: hym8563: Return -EINVAL if the time is known to be invalid

Wei Yongjun <weiyongjun1@huawei.com>
    rtc: mt6397: drop free_irq of devm_ allocated irq

Taehee Yoo <ap420073@gmail.com>
    netdevsim: use __GFP_NOWARN to avoid memalloc warning

Taehee Yoo <ap420073@gmail.com>
    netdevsim: fix panic in nsim_dev_take_snapshot_write()

Taehee Yoo <ap420073@gmail.com>
    netdevsim: disable devlink reload when resources are being used

Taehee Yoo <ap420073@gmail.com>
    netdevsim: fix using uninitialized resources

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap

Lorenz Bauer <lmb@cloudflare.com>
    bpf, sockmap: Check update requirements after locking

Martin KaFai Lau <kafai@fb.com>
    bpf: Improve bucket_log calculation logic

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf: Test freeing sockmap/sockhash with a socket in it

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockhash: Synchronize_rcu before free'ing map

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockmap: Don't sleep while holding RCU lock on tear-down

Toke Høiland-Jørgensen <toke@redhat.com>
    bpftool: Don't crash on missing xlated program instructions

Steven Clarkson <sc@lambdal.com>
    x86/boot: Handle malformed SRAT tables during early ACPI parsing

Robert Milkowski <rmilkowski@gmail.com>
    NFSv4.0: nfs4_do_fsinfo() should not do implicit lease renewals

Robert Milkowski <rmilkowski@gmail.com>
    NFSv4: try lease recovery on NFS4ERR_EXPIRED

Trond Myklebust <trondmy@gmail.com>
    NFSv4: pnfs_roc() must use cred_fscmp() to compare creds

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix fix of show_nfs_errors

Trond Myklebust <trondmy@gmail.com>
    NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()

Trond Myklebust <trondmy@gmail.com>
    NFS: Revalidate the file size on a fatal write error

Geert Uytterhoeven <geert+renesas@glider.be>
    nfs: NFS_SWAP should depend on SWAP

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.x recover from pre-mature loss of openstateid

Paul Blakey <paulb@mellanox.com>
    netfilter: flowtable: Fix missing flush hardware on table free

Paul Blakey <paulb@mellanox.com>
    netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: restrict flow dissector match on meta ingress device

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: fetch stats only if flow is still alive

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix TDLS discovery with the new firmware API

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: avoid use after free for pmsr request

Dongdong Liu <liudongdong3@huawei.com>
    PCI/AER: Initialize aer_fifo

Logan Gunthorpe <logang@deltatee.com>
    PCI: Don't disable bridge BARs when assigning bus resources

Marcel Ziswiler <marcel@ziswiler.com>
    PCI: tegra: Fix afi_pex2_ctrl reg offset for Tegra30

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Fix vep_vector_number ioread width

Wesley Sheng <wesley.sheng@microchip.com>
    PCI/switchtec: Use dma_set_mask_and_coherent()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe

Navid Emamdoost <navid.emamdoost@gmail.com>
    PCI/IOV: Fix memory leak in pci_iov_add_virtfn()

Bean Huo <beanhuo@micron.com>
    scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails

Artemy Kovalyov <artemyko@mellanox.com>
    RDMA/umem: Fix ib_umem_find_best_pgsz()

Parav Pandit <parav@mellanox.com>
    RDMA/cma: Fix unbalanced cm_id reference count during address resolve

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Ensure that rdma_user_mmap_entry_remove() is a fence

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Fix handling of IOVA != user_va in ODP paths

Michael Guralnik <michaelgur@mellanox.com>
    RDMA/uverbs: Verify MR access flags

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Fix locking in ib_uverbs_event_read

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    RDMA/i40iw: fix a potential NULL pointer dereference

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/netlink: Do not always generate an ACK for some netlink operations

Håkon Bugge <haakon.bugge@oracle.com>
    IB/mlx4: Fix leak in id_map_find_del

Danit Goldberg <danitg@mellanox.com>
    IB/mlx5: Return the administrative GUID if exists

Sergey Gorenko <sergeygo@mellanox.com>
    IB/srp: Never use immediate data if it is disabled by a user

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Fix memory leak in add_gid error flow


-------------

Diffstat:

 .../devicetree/bindings/iio/adc/adi,ad7606.yaml    |  8 +--
 Makefile                                           |  4 +-
 arch/arc/boot/dts/axs10x_mb.dtsi                   |  1 +
 arch/arm/boot/dts/am43xx-clocks.dtsi               | 54 ++++++++++++++
 arch/arm/boot/dts/at91sam9260.dtsi                 | 12 ++--
 arch/arm/boot/dts/at91sam9261.dtsi                 |  6 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 |  6 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  8 +--
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  8 +--
 arch/arm/boot/dts/meson8.dtsi                      |  4 +-
 arch/arm/boot/dts/meson8b.dtsi                     |  4 +-
 arch/arm/boot/dts/sama5d3.dtsi                     | 28 ++++----
 arch/arm/boot/dts/sama5d3_can.dtsi                 |  4 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |  1 +
 arch/arm/boot/dts/sama5d3_uart.dtsi                |  4 +-
 arch/arm/crypto/chacha-glue.c                      |  4 +-
 arch/arm/mach-at91/pm.c                            |  9 ++-
 arch/arm/mm/init.c                                 |  2 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts   |  4 ++
 .../dts/marvell/armada-8040-clearfog-gt-8k.dts     |  2 +
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi          |  1 +
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  2 +-
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts     |  1 -
 arch/arm64/kernel/cpufeature.c                     | 39 ++++++++--
 arch/arm64/kernel/entry.S                          |  5 +-
 arch/arm64/kernel/fpsimd.c                         | 30 +++++++-
 arch/arm64/kernel/ptrace.c                         | 21 ++++++
 arch/arm64/kvm/hyp/switch.c                        | 10 ++-
 arch/arm64/kvm/va_layout.c                         | 56 +++++++--------
 arch/mips/loongson64/platform.c                    |  3 +
 arch/powerpc/Kconfig.debug                         |  2 +-
 arch/powerpc/mm/pgtable_32.c                       |  1 +
 arch/powerpc/platforms/pseries/iommu.c             | 54 +++++++-------
 arch/powerpc/platforms/pseries/papr_scm.c          |  2 +
 arch/powerpc/platforms/pseries/vio.c               |  2 +
 arch/x86/boot/compressed/acpi.c                    |  6 ++
 arch/x86/kernel/alternative.c                      |  1 +
 crypto/testmgr.c                                   | 20 ++++--
 drivers/base/regmap/regmap.c                       | 17 +++--
 drivers/clk/meson/g12a.c                           |  1 +
 drivers/crypto/atmel-sha.c                         |  7 +-
 drivers/crypto/axis/artpec6_crypto.c               |  2 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  2 +-
 drivers/dma/dma-axi-dmac.c                         | 10 ++-
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |  3 +-
 drivers/infiniband/core/addr.c                     |  2 +-
 drivers/infiniband/core/cma.c                      |  2 +
 drivers/infiniband/core/ib_core_uverbs.c           |  2 +
 drivers/infiniband/core/sa_query.c                 |  4 +-
 drivers/infiniband/core/umem.c                     |  9 ++-
 drivers/infiniband/core/uverbs_main.c              | 32 ++++-----
 drivers/infiniband/hw/i40iw/i40iw_main.c           |  2 +
 drivers/infiniband/hw/mlx4/cm.c                    | 29 +-------
 drivers/infiniband/hw/mlx4/main.c                  | 20 ++++--
 drivers/infiniband/hw/mlx5/ib_virt.c               | 28 ++++----
 drivers/infiniband/hw/mlx5/mr.c                    |  2 +
 drivers/infiniband/hw/mlx5/odp.c                   | 19 +++--
 drivers/infiniband/ulp/srp/ib_srp.c                |  3 +-
 drivers/iommu/arm-smmu-v3.c                        |  1 +
 drivers/md/bcache/journal.c                        | 80 +++++++++++++++++++--
 drivers/media/i2c/adv748x/adv748x.h                |  8 +--
 drivers/mfd/Kconfig                                |  1 +
 drivers/mtd/nand/onenand/onenand_base.c            | 82 +++++++++++-----------
 drivers/mtd/parsers/sharpslpart.c                  |  4 +-
 drivers/net/netdevsim/bus.c                        | 64 +++++++++++++++--
 drivers/net/netdevsim/dev.c                        | 13 +++-
 drivers/net/netdevsim/health.c                     |  2 +-
 drivers/net/netdevsim/netdevsim.h                  |  4 ++
 drivers/net/wireless/ath/ath10k/pci.c              | 19 ++++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      | 10 ++-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 71 ++++++++++++++++---
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |  4 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |  2 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |  7 ++
 drivers/net/wireless/marvell/mwifiex/wmm.c         |  4 ++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |  3 +-
 drivers/pci/controller/pci-tegra.c                 |  2 +-
 drivers/pci/iov.c                                  |  9 ++-
 drivers/pci/pcie/aer.c                             |  1 +
 drivers/pci/setup-bus.c                            | 20 ++++--
 drivers/pci/switch/switchtec.c                     |  4 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           | 19 +++--
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  5 --
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |  4 +-
 drivers/pinctrl/sh-pfc/pfc-r8a77965.c              |  6 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |  5 +-
 drivers/rtc/Kconfig                                |  8 ++-
 drivers/rtc/rtc-cmos.c                             |  2 +-
 drivers/rtc/rtc-hym8563.c                          |  2 +-
 drivers/rtc/rtc-mt6397.c                           | 10 +--
 drivers/scsi/ufs/ufshcd.c                          |  3 +-
 drivers/soc/qcom/rpmhpd.c                          |  2 +
 drivers/watchdog/qcom-wdt.c                        |  2 +-
 drivers/watchdog/stm32_iwdg.c                      | 18 +++++
 fs/nfs/Kconfig                                     |  2 +-
 fs/nfs/direct.c                                    |  4 +-
 fs/nfs/nfs3xdr.c                                   |  5 +-
 fs/nfs/nfs42proc.c                                 | 36 +++++++---
 fs/nfs/nfs4_fs.h                                   |  4 +-
 fs/nfs/nfs4proc.c                                  | 19 +++--
 fs/nfs/nfs4renewd.c                                |  5 +-
 fs/nfs/nfs4state.c                                 |  4 +-
 fs/nfs/nfs4trace.h                                 | 33 ++++-----
 fs/nfs/nfs4xdr.c                                   |  5 +-
 fs/nfs/pnfs.c                                      |  4 +-
 fs/nfs/pnfs_nfs.c                                  |  7 +-
 fs/nfs/write.c                                     | 12 +++-
 include/linux/mlx5/driver.h                        |  5 ++
 include/rdma/ib_verbs.h                            |  3 +
 kernel/sched/core.c                                |  6 ++
 net/core/bpf_sk_storage.c                          |  5 +-
 net/core/sock_map.c                                | 28 +++++---
 net/netfilter/nf_flow_table_core.c                 |  8 +--
 net/netfilter/nf_flow_table_offload.c              | 11 ++-
 security/selinux/avc.c                             | 24 ++++++-
 security/selinux/hooks.c                           | 15 +++-
 security/selinux/include/avc.h                     |  5 ++
 sound/soc/soc-generic-dmaengine-pcm.c              | 16 +++--
 tools/bpf/bpftool/prog.c                           |  2 +-
 tools/power/acpi/Makefile.config                   |  2 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       | 74 +++++++++++++++++++
 virt/kvm/arm/aarch32.c                             | 14 ++--
 virt/kvm/arm/arch_timer.c                          |  3 +-
 virt/kvm/arm/mmu.c                                 |  3 +-
 virt/kvm/arm/pmu.c                                 | 42 ++++++++---
 virt/kvm/arm/vgic/vgic-its.c                       |  3 +-
 128 files changed, 1099 insertions(+), 443 deletions(-)


