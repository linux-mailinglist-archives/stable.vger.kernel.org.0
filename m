Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7235F15C1CC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgBMP0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387583AbgBMP0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:31 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D24624677;
        Thu, 13 Feb 2020 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607590;
        bh=DJ0Hz4pB36UMgbur4Sz8lMXiHAWjjzaROLPdjiNsDp8=;
        h=From:To:Cc:Subject:Date:From;
        b=KQabMVtXY7G6MZievuusg4jq9RBN8W9Mw0a88nxMqR1pt0+pYtKHP9wZIeYmJAyz2
         O0Kdn0ZK11XsrAQx1rz6x6WHwXtv9Y5aO+u55bDy8NvGkRXA4Rof2GC4IhofRtzcY3
         d782AqN3qSADwFwkgYb1kLcx1DAcEmFda3po0Y8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/52] 4.19.104-stable review
Date:   Thu, 13 Feb 2020 07:20:41 -0800
Message-Id: <20200213151810.331796857@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.104-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.104-rc1
X-KernelTest-Deadline: 2020-02-15T15:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.104 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.104-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.104-rc1

Peter Zijlstra <peterz@infradead.org>
    x86/stackframe, x86/ftrace: Add pt_regs frame annotations

Peter Zijlstra <peterz@infradead.org>
    x86/stackframe: Move ENCODE_FRAME_POINTER to asm/frame.h

Anand Lodnoor <anand.lodnoor@broadcom.com>
    scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state

Nicolai Stange <nstange@suse.de>
    libertas: make lbs_ibss_join_existing() return error code on rates overflow

Nicolai Stange <nstange@suse.de>
    libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held

Qing Xu <m1s5p6688@gmail.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()

Qing Xu <m1s5p6688@gmail.com>
    mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Gustavo A. R. Silva <gustavo@embeddedor.com>
    media: i2c: adv748x: Fix unsafe macros

Eric Biggers <ebiggers@google.com>
    crypto: atmel-sha - fix error handling when setting hmac key

Eric Biggers <ebiggers@google.com>
    crypto: artpec6 - return correct error code for failed setkey()

YueHaibing <yuehaibing@huawei.com>
    mtd: sharpslpart: Fix unsigned comparison to zero

Nathan Chancellor <natechancellor@gmail.com>
    mtd: onenand_base: Adjust indentation in onenand_read_ops_nolock

Eric Auger <eric.auger@redhat.com>
    KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset

James Morse <james.morse@arm.com>
    KVM: arm: Make inject_abt32() inject an external abort instead

James Morse <james.morse@arm.com>
    KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests

Gavin Shan <gshan@redhat.com>
    KVM: arm/arm64: Fix young bit from mmu notifier

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: cpufeature: Fix the type of no FP/SIMD capability

Olof Johansson <olof@lixom.net>
    ARM: 8949/1: mm: mark free_memmap as __init

Eric Auger <eric.auger@redhat.com>
    KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections

Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
    iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-multi-tce for DDW

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    tools/power/acpi: fix compilation error

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: sama5d3: fix maximum peripheral clock rates

Tero Kristo <t-kristo@ti.com>
    ARM: dts: am43xx: add support for clkout1 clock

Ingo van Lil <inguin@gmx.de>
    ARM: dts: at91: Reenable UART TX pull-ups

Mika Westerberg <mika.westerberg@linux.intel.com>
    platform/x86: intel_mid_powerbtn: Take a copy of ddata

Jose Abreu <Jose.Abreu@synopsys.com>
    ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    rtc: cmos: Stop using shared IRQ

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    rtc: hym8563: Return -EINVAL if the time is known to be invalid

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spi-mem: Fix inverted logic in op sanity check

Boris Brezillon <boris.brezillon@bootlin.com>
    spi: spi-mem: Add extra sanity checks on the op param

Brandon Maier <Brandon.Maier@collins.com>
    gpio: zynq: Report gpio direction at boot

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    serial: uartps: Add a timeout to the tx empty wait

Robert Milkowski <rmilkowski@gmail.com>
    NFSv4: try lease recovery on NFS4ERR_EXPIRED

Trond Myklebust <trondmy@gmail.com>
    NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()

Trond Myklebust <trondmy@gmail.com>
    NFS: Revalidate the file size on a fatal write error

Geert Uytterhoeven <geert+renesas@glider.be>
    nfs: NFS_SWAP should depend on SWAP

Logan Gunthorpe <logang@deltatee.com>
    PCI: Don't disable bridge BARs when assigning bus resources

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Fix vep_vector_number ioread width

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe

Navid Emamdoost <navid.emamdoost@gmail.com>
    PCI/IOV: Fix memory leak in pci_iov_add_virtfn()

Bean Huo <beanhuo@micron.com>
    scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails

Michael Guralnik <michaelgur@mellanox.com>
    RDMA/uverbs: Verify MR access flags

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Fix locking in ib_uverbs_event_read

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/netlink: Do not always generate an ACK for some netlink operations

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Fix memory leak in add_gid error flow

Sunil Muthuswamy <sunilmut@microsoft.com>
    hv_sock: Remove the accept port restriction

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: pcm: update FE/BE trigger order based on the command


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/arc/boot/dts/axs10x_mb.dtsi            |  1 +
 arch/arm/boot/dts/am43xx-clocks.dtsi        | 54 ++++++++++++++++
 arch/arm/boot/dts/at91sam9260.dtsi          | 12 ++--
 arch/arm/boot/dts/at91sam9261.dtsi          |  6 +-
 arch/arm/boot/dts/at91sam9263.dtsi          |  6 +-
 arch/arm/boot/dts/at91sam9g45.dtsi          |  8 +--
 arch/arm/boot/dts/at91sam9rl.dtsi           |  8 +--
 arch/arm/boot/dts/sama5d3.dtsi              | 28 ++++-----
 arch/arm/boot/dts/sama5d3_can.dtsi          |  4 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi         |  1 +
 arch/arm/boot/dts/sama5d3_uart.dtsi         |  4 +-
 arch/arm/mm/init.c                          |  2 +-
 arch/arm64/kernel/cpufeature.c              |  2 +-
 arch/arm64/kernel/ptrace.c                  | 21 +++++++
 arch/powerpc/platforms/pseries/iommu.c      | 43 ++++++++-----
 arch/powerpc/platforms/pseries/vio.c        |  2 +
 arch/x86/entry/calling.h                    | 15 -----
 arch/x86/entry/entry_32.S                   | 16 -----
 arch/x86/include/asm/frame.h                | 49 +++++++++++++++
 arch/x86/kernel/ftrace_32.S                 |  3 +
 arch/x86/kernel/ftrace_64.S                 |  3 +
 drivers/crypto/atmel-sha.c                  |  7 +--
 drivers/crypto/axis/artpec6_crypto.c        |  2 +-
 drivers/gpio/gpio-zynq.c                    | 23 +++++++
 drivers/infiniband/core/addr.c              |  2 +-
 drivers/infiniband/core/sa_query.c          |  4 +-
 drivers/infiniband/core/uverbs_main.c       | 32 +++++-----
 drivers/infiniband/hw/mlx4/main.c           | 20 ++++--
 drivers/iommu/arm-smmu-v3.c                 |  1 +
 drivers/media/i2c/adv748x/adv748x.h         |  8 +--
 drivers/mtd/nand/onenand/onenand_base.c     | 82 ++++++++++++-------------
 drivers/mtd/parsers/sharpslpart.c           |  4 +-
 drivers/net/wireless/ath/ath10k/pci.c       | 19 +++++-
 drivers/net/wireless/marvell/libertas/cfg.c |  2 +
 drivers/net/wireless/marvell/mwifiex/scan.c |  7 +++
 drivers/net/wireless/marvell/mwifiex/wmm.c  |  4 ++
 drivers/pci/iov.c                           |  9 ++-
 drivers/pci/setup-bus.c                     | 20 ++++--
 drivers/pci/switch/switchtec.c              |  2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c        |  4 +-
 drivers/platform/x86/intel_mid_powerbtn.c   |  5 +-
 drivers/rtc/rtc-cmos.c                      |  2 +-
 drivers/rtc/rtc-hym8563.c                   |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  1 +
 drivers/scsi/ufs/ufshcd.c                   |  3 +-
 drivers/spi/spi-mem.c                       | 54 ++++++++++++++--
 drivers/tty/serial/xilinx_uartps.c          | 14 +++--
 fs/nfs/Kconfig                              |  2 +-
 fs/nfs/direct.c                             |  4 +-
 fs/nfs/nfs3xdr.c                            |  5 +-
 fs/nfs/nfs4proc.c                           |  5 ++
 fs/nfs/nfs4xdr.c                            |  5 +-
 fs/nfs/pnfs_nfs.c                           |  7 +--
 fs/nfs/write.c                              | 12 +++-
 include/rdma/ib_verbs.h                     |  3 +
 net/vmw_vsock/hyperv_transport.c            | 68 +++------------------
 sound/soc/soc-pcm.c                         | 95 +++++++++++++++++++++--------
 tools/power/acpi/Makefile.config            |  2 +-
 virt/kvm/arm/aarch32.c                      | 14 +++--
 virt/kvm/arm/mmu.c                          |  3 +-
 virt/kvm/arm/pmu.c                          |  3 +
 virt/kvm/arm/vgic/vgic-its.c                |  3 +-
 65 files changed, 562 insertions(+), 300 deletions(-)


