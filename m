Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317F42C9CFA
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgLAJII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389168AbgLAJIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7942221FF;
        Tue,  1 Dec 2020 09:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813665;
        bh=0SNa4TLA0dOUOAKuZqzS/Ce1ZZNtHv3iWmGydFVT/ZI=;
        h=From:To:Cc:Subject:Date:From;
        b=MaBy4jntXgRf7rDEDm9PBvEToD8GDKJhgtOAhLYmGX9pDKkr7oKo1KeW/BsPznJ8L
         v5H0dl398GScW9HeWApscIVbO07UStEEBYorJRfBOd39lY6igvrD2IDuJJbA20QrvN
         x1vbEwA8XphPWxYkRRrbKLr5sYpcGy/I1qtbwszc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/152] 5.9.12-rc1 review
Date:   Tue,  1 Dec 2020 09:51:55 +0100
Message-Id: <20201201084711.707195422@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.12-rc1
X-KernelTest-Deadline: 2020-12-03T08:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.12 release.
There are 152 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.12-rc1

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: add rlc iram and dram firmware support

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak

Anand K Mistry <amistry@google.com>
    x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

Gabriele Paoloni <gabriele.paoloni@intel.com>
    x86/mce: Do not overwrite no_way_out if mce_end() fails

Chen Baozi <chenbaozi@phytium.com.cn>
    irqchip/exiu: Fix the index of fwspec for IRQ type

Zhang Qilong <zhangqilong3@huawei.com>
    usb: gadget: Fix memleak in gadgetfs_fill_super

penghao <penghao@uniontech.com>
    USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z TIO built-in usb-audio card

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix regression in Hercules audio card

Zhang Qilong <zhangqilong3@huawei.com>
    usb: gadget: f_midi: Fix memleak in f_midi_alloc

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Change %pK for __user pointers to %px

Nathan Chancellor <natechancellor@gmail.com>
    spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to die_entrypc() returns error correctly

Namhyung Kim <namhyung@kernel.org>
    perf stat: Use proper cpu for shadow stats

Namhyung Kim <namhyung@kernel.org>
    perf record: Synthesize cgroup events only if needed

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags

Yixian Liu <liuyixian@huawei.com>
    RDMA/hns: Bugfix for memory window mtpt configuration

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix retry_cnt and rnr_cnt when querying QP

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix wrong field of SRQ number the device supports

Kaixu Xia <kaixuxia@tencent.com>
    platform/x86: toshiba_acpi: Fix the wrong variable assignment

Benjamin Berg <bberg@redhat.com>
    platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix endianess problem with candleLight firmware

Matti Hamalainen <ccr@tnsp.org>
    drm/nouveau: fix relocations applying logic and a double-free

Min Li <min.li.xe@renesas.com>
    ptp: clockmatrix: bug fix for idtcm_strverscmp

Vladimir Oltean <vladimir.oltean@nxp.com>
    enetc: Let the hardware auto-advance the taprio base-time of 0

Antonio Borneo <antonio.borneo@st.com>
    net: stmmac: fix incorrect merge of patch upstream

Randy Dunlap <rdunlap@infradead.org>
    RISC-V: fix barrier() use in <vdso/processor.h>

Anup Patel <anup.patel@wdc.com>
    RISC-V: Add missing jump label initialization

Nathan Chancellor <natechancellor@gmail.com>
    riscv: Explicitly specify the build id style in vDSO Makefile again

Geert Uytterhoeven <geert@linux-m68k.org>
    efi: EFI_EARLYCON should depend on EFI

Ard Biesheuvel <ardb@kernel.org>
    efivarfs: revert "fix memory leak in efivarfs_create()"

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    efi/efivars: Set generic ops before loading SSDT

Dipen Patel <dipenp@nvidia.com>
    arm64: tegra: Wrong AON HSP reg property size

Lu Baolu <baolu.lu@linux.intel.com>
    x86/tboot: Don't disable swiotlb when iommu is forced on

Rui Miguel Silva <rui.silva@linaro.org>
    optee: add writeback to valid memory type

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: enhance resetting status check during module exit

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues

Shay Agroskin <shayagr@amazon.com>
    net: ena: fix packet's addresses for rx_offset feature

Shay Agroskin <shayagr@amazon.com>
    net: ena: set initial DMA width to avoid intel iommu issue

Shay Agroskin <shayagr@amazon.com>
    net: ena: handle bad request id in ena_netdev

Krzysztof Kozlowski <krzk@kernel.org>
    nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Lincoln Ramsay <lincoln.ramsay@opengear.com>
    aquantia: Remove the build_skb path

Joseph Qi <joseph.qi@linux.alibaba.com>
    io_uring: fix shift-out-of-bounds when round up cq size

Clark Wang <xiaoning.wang@nxp.com>
    spi: imx: fix the unbalanced spi runtime pm management

Manish Narani <manish.narani@xilinx.com>
    firmware: xilinx: Fix SD DLL node reset issue

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix removing driver while bare-metal VFs pass traffic

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    IB/mthca: fix return value of error branch in mthca_init_cq()

Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
    iommu: Check return of __iommu_attach_device()

Stephen Rothwell <sfr@canb.auug.org.au>
    powerpc/64s: Fix allnoconfig build since uaccess flush

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: notify peers when failover and migration happen

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix call_netdevice_notifiers in do_reset

Jamie Iles <jamie@nuviainc.com>
    bonding: wait for sysfs kobject destruction before freeing struct slave

CK Hu <ck.hu@mediatek.com>
    drm/mediatek: dsi: Modify horizontal front/back porch byte formula

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix tear down of async TX buffers

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix af_iucv notification race

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: make af_iucv TX notification call more robust

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: select XGMAC_MDIO for MDIO bus support

Raju Rangoju <rajur@chelsio.com>
    cxgb4: fix the panic caused by non smac rewrite

Eric Biggers <ebiggers@google.com>
    block/keyslot-manager: prevent crash when num_slots=1

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Dexuan Cui <decui@microsoft.com>
    video: hyperv_fb: Fix the cache type when mapping the VRAM

Zhang Changzhong <zhangchangzhong@huawei.com>
    bnxt_en: fix error return code in bnxt_init_board()

Zhang Changzhong <zhangchangzhong@huawei.com>
    bnxt_en: fix error return code in bnxt_init_one()

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix race between shutdown and runtime resume flow

Marc Kleine-Budde <mkl@pengutronix.de>
    ARM: dts: dra76x: m_can: fix order of clocks

Grygorii Strashko <grygorii.strashko@ti.com>
    bus: ti-sysc: suppress err msg for timers used as clockevent/source

Arnd Bergmann <arnd@arndb.de>
    arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    phy: qualcomm: Fix 28 nm Hi-Speed USB PHY OF dependency

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    phy: qualcomm: usb: Fix SuperSpeed PHY OF dependency

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: calculate TD_SIZE based on TD

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: fix some endian issues

Taehee Yoo <ap420073@gmail.com>
    batman-adv: set .owner to THIS_MODULE

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: don't commit transaction when we already hold the handle

Collin Walling <walling@linux.ibm.com>
    KVM: s390: remove diag318 reset code

Janosch Frank <frankja@linux.ibm.com>
    KVM: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: write queue_sync_state only for sync

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: properly cancel a session protection for P2P

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: use the HOT_SPOT_CMD to cancel an AUX ROC

Marc Zyngier <maz@kernel.org>
    phy: tegra: xusb: Fix dangling pointer on probe failure

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Manage MPU state properly for omap_enter_idle_coupled()

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix bogus resetdone warning on enable for cpsw

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix reset status check for modules with quirks

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset

Thomas Gleixner <tglx@linutronix.de>
    x86/dumpstack: Do not try to access user space code of other tasks

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    xtensa: uaccess: Add missing __user to strncpy_from_user() prototype

Sami Tolvanen <samitolvanen@google.com>
    perf/x86: fix sysfs type mismatches

Boqun Feng <boqun.feng@gmail.com>
    lockdep: Put graph lock/unlock under lock_recursion protection

Mike Christie <michael.christie@oracle.com>
    scsi: target: iscsi: Fix cmd abort fabric stop race

Lee Duncan <lduncan@suse.com>
    scsi: libiscsi: Fix NOP race condition

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Dmitry Osipenko <digetx@gmail.com>
    cpuidle: tegra: Annotate tegra_pm_set_cpu_in_lp2() with RCU_NONIDLE

Mike Christie <michael.christie@oracle.com>
    vhost scsi: fix cmd completion race

Mike Christie <michael.christie@oracle.com>
    vhost scsi: alloc cmds per vq instead of session

Mike Christie <michael.christie@oracle.com>
    vhost: add helper to check if a vq has been setup

Laurent Vivier <lvivier@redhat.com>
    vdpasim: fix "mac_pton" undefined error

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac_lib: enlarge dma reset timeout

Jens Axboe <axboe@kernel.dk>
    io_uring: handle -EOPNOTSUPP on path resolution

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme: free sq/cq dbbuf pointers when dbbuf set fails

Jens Axboe <axboe@kernel.dk>
    proc: don't allow async path resolution of /proc/self components

Hans de Goede <hdegoede@redhat.com>
    HID: Add Logitech Dinovo Edge battery quirk

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge

Daniel Latypov <dlatypov@google.com>
    kunit: fix display of failed expectations for strings

Brian Masney <bmasney@redhat.com>
    x86/xen: don't unbind uninitialized lock_kicker_irq

Marc Ferland <ferlandm@amotus.ca>
    dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant

Chris Ye <lzye@google.com>
    HID: add HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE for Gamevice devices

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    staging: ralink-gdma: fix kconfig dependency bug for DMA_RALINK

Pablo Ceballos <pceballos@google.com>
    HID: hid-sensor-hub: Fix issue with devices with no report ID

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - allow insmod to succeed on devices without an i8042 controller

Jiri Kosina <jkosina@suse.cz>
    HID: add support for Sega Saturn

Frank Yang <puilp0502@gmail.com>
    HID: cypress: Support Varmilo Keyboards' media hotkeys

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Replace ABS_MISC 120/121 events with touchpad on/off keypresses

Martijn van de Streek <martijn@zeewinde.xyz>
    HID: uclogic: Add ID for Trust Flex Design Tablet

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Avoid HDCP initialization in devices without output

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: fix null pointer in runtime pm

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: update golden setting for sienna_cichlid

Sonny Jiang <sonny.jiang@amd.com>
    drm/amdgpu: fix a page fault

Will Deacon <will@kernel.org>
    arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()

Will Deacon <will@kernel.org>
    arm64: pgtable: Fix pte_accessible()

JC Kuo <jckuo@nvidia.com>
    arm64: tegra: Fix USB_VBUS_EN0 regulator on Jetson TX1

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Correct the UART for Jetson Xavier NX

Hui Su <sh_def@163.com>
    trace: fix potenial dangerous pointer

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix ITER_BVEC check

Sonny Jiang <sonny.jiang@amd.com>
    drm/amdgpu: fix SI UVD firmware validate resume fail

Amit Sunil Dhamne <amit.sunil.dhamne@xilinx.com>
    firmware: xilinx: Use hash-table for api feature check

David Woodhouse <dwmw@amazon.co.uk>
    iommu/vt-d: Don't read VCCAP register unless it exists

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Fix split-irqchip vs interrupt injection window request

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/exception: KVM Fix for host DSI being taken in HPT guest MMU context

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix KVM system reset handling when CONFIG_PPC_PSERIES=y

Namjae Jeon <namjae.jeon@samsung.com>
    cifs: fix a memleak with modefromsid

Rohith Surabattula <rohiths@microsoft.com>
    smb3: Handle error case during offload read path

Rohith Surabattula <rohiths@microsoft.com>
    smb3: Avoid Mid pending list corruption

Rohith Surabattula <rohiths@microsoft.com>
    smb3: Call cifs reconnect from demultiplex thread

Hugh Dickins <hughd@google.com>
    mm: fix VM_BUG_ON(PageTail) and BUG_ON(PageWriteback)

Sven Schnelle <svens@linux.ibm.com>
    s390: fix fpu restore in entry.S

Biwen Li <biwen.li@nxp.com>
    rtc: pcf2127: fix a bug when not specify interrupts property

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat when reading qgroup config on mount

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't access possibly stale fs_info data for printing duplicate device

David Sterba <dsterba@suse.com>
    btrfs: tree-checker: add missing returns after data_ref alignment checks

Daniel Xu <dxu@dxuuu.xyz>
    btrfs: tree-checker: add missing return after error in root_item

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing delalloc new bit for new delalloc ranges

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/i40iw: Address an mmap handler exploit in i40iw

Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
    IB/hfi1: Ensure correct mm is used at all times

Florian Klink <flokli@flokli.de>
    ipv4: use IS_ENABLED instead of ifdef

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix use-after-free on unbind

Lukas Wunner <lukas@wunner.de>
    spi: bcm-qspi: Fix use-after-free on unbind

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: order refnode recycling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: get an active ref_node from files_data


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/pgtable.h                     |   2 +
 arch/arm/boot/dts/dra76x.dtsi                      |   4 +-
 arch/arm/include/asm/pgtable-2level.h              |   2 +
 arch/arm/include/asm/pgtable-3level.h              |   2 +
 arch/arm/mach-omap2/cpuidle44xx.c                  |   8 +-
 .../arm64/boot/dts/nvidia/tegra194-p3668-0000.dtsi |   2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   2 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |  20 +-
 arch/arm64/include/asm/pgtable.h                   |  34 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  22 +-
 arch/mips/include/asm/pgtable-32.h                 |   3 +
 arch/powerpc/include/asm/book3s/32/pgtable.h       |   2 +
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |   2 +
 arch/powerpc/include/asm/nohash/32/pgtable.h       |   2 +
 arch/powerpc/kernel/exceptions-64s.S               |  13 +-
 arch/powerpc/kvm/book3s_xive_native.c              |   7 +
 arch/riscv/include/asm/pgtable-32.h                |   2 +
 arch/riscv/include/asm/vdso/processor.h            |   2 +
 arch/riscv/kernel/setup.c                          |   1 +
 arch/riscv/kernel/vdso/Makefile                    |   2 +-
 arch/s390/kernel/asm-offsets.c                     |  10 +-
 arch/s390/kernel/entry.S                           |   2 +
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/s390/kvm/pv.c                                 |   3 +-
 arch/s390/mm/gmap.c                                |   2 +
 arch/x86/events/intel/cstate.c                     |   6 +-
 arch/x86/events/intel/uncore.c                     |   4 +-
 arch/x86/events/intel/uncore.h                     |  12 +-
 arch/x86/events/rapl.c                             |  14 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/cpu/bugs.c                         |   4 +-
 arch/x86/kernel/cpu/mce/core.c                     |   6 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  65 +++---
 arch/x86/kernel/dumpstack.c                        |  23 +-
 arch/x86/kernel/tboot.c                            |   5 +-
 arch/x86/kvm/irq.c                                 |  85 +++----
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/xen/spinlock.c                            |  12 +-
 arch/xtensa/include/asm/uaccess.h                  |   2 +-
 block/keyslot-manager.c                            |   7 +
 drivers/bus/ti-sysc.c                              |  29 ++-
 drivers/cpuidle/cpuidle-tegra.c                    |   4 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   4 +-
 drivers/firmware/efi/Kconfig                       |   2 +-
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/firmware/xilinx/zynqmp.c                   |  65 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h            |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |  10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h          |  11 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  41 +++-
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h            |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  20 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |  61 ++---
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   8 +-
 drivers/hid/hid-cypress.c                          |  44 +++-
 drivers/hid/hid-ids.h                              |   9 +
 drivers/hid/hid-input.c                            |   3 +
 drivers/hid/hid-ite.c                              |  61 ++++-
 drivers/hid/hid-logitech-hidpp.c                   |   6 +
 drivers/hid/hid-quirks.c                           |   5 +
 drivers/hid/hid-sensor-hub.c                       |   3 +-
 drivers/hid/hid-uclogic-core.c                     |   2 +
 drivers/hid/hid-uclogic-params.c                   |   2 +
 drivers/infiniband/hw/hfi1/file_ops.c              |   4 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   2 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                |  68 +++---
 drivers/infiniband/hw/hfi1/mmu_rb.h                |  16 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |  12 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.h          |   6 +
 drivers/infiniband/hw/hfi1/user_sdma.c             |  13 +-
 drivers/infiniband/hw/hfi1/user_sdma.h             |   7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |   5 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  37 +--
 drivers/infiniband/hw/mthca/mthca_cq.c             |  10 +-
 drivers/input/serio/i8042.c                        |  12 +-
 drivers/iommu/intel/dmar.c                         |   3 +-
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/iommu/iommu.c                              |  10 +-
 drivers/irqchip/irq-sni-exiu.c                     |   2 +-
 drivers/net/bonding/bond_main.c                    |  61 +++--
 drivers/net/bonding/bond_sysfs_slave.c             |  18 +-
 drivers/net/can/m_can/m_can.c                      |   4 +-
 drivers/net/can/usb/gs_usb.c                       | 131 ++++++-----
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/dsa/mv88e6xxx/global1.c                |  31 +++
 drivers/net/dsa/mv88e6xxx/global1.h                |   1 +
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  80 +++----
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   | 126 +++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |   1 +
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  14 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  17 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  22 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  26 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   3 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 103 ++++++---
 drivers/nfc/s3fwrn5/i2c.c                          |   4 +-
 drivers/nvme/host/pci.c                            |  15 ++
 drivers/phy/qualcomm/Kconfig                       |   4 +-
 drivers/phy/tegra/xusb.c                           |   1 +
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/platform/x86/toshiba_acpi.c                |   3 +-
 drivers/ptp/ptp_clockmatrix.c                      |  49 ++--
 drivers/rtc/rtc-pcf2127.c                          |   4 +-
 drivers/s390/net/qeth_core.h                       |   9 +-
 drivers/s390/net/qeth_core_main.c                  |  82 ++++---
 drivers/scsi/libiscsi.c                            |  23 +-
 drivers/scsi/ufs/ufshcd.c                          |   6 +-
 drivers/spi/spi-bcm-qspi.c                         |  34 +--
 drivers/spi/spi-bcm2835.c                          |  27 +--
 drivers/spi/spi-bcm2835aux.c                       |   3 +-
 drivers/spi/spi-imx.c                              |   1 +
 drivers/staging/ralink-gdma/Kconfig                |   1 +
 drivers/target/iscsi/iscsi_target.c                |  17 +-
 drivers/tee/optee/call.c                           |   3 +-
 drivers/usb/cdns3/gadget.c                         |  80 +++----
 drivers/usb/core/devio.c                           |  14 +-
 drivers/usb/core/quirks.c                          |  10 +
 drivers/usb/gadget/function/f_midi.c               |  10 +-
 drivers/usb/gadget/legacy/inode.c                  |   3 +
 drivers/vdpa/Kconfig                               |   1 +
 drivers/vhost/scsi.c                               | 249 ++++++++++++---------
 drivers/vhost/vhost.c                              |   6 +
 drivers/vhost/vhost.h                              |   1 +
 drivers/video/fbdev/hyperv_fb.c                    |   7 +-
 fs/btrfs/file.c                                    |  57 -----
 fs/btrfs/inode.c                                   |  58 +++++
 fs/btrfs/qgroup.c                                  |  22 +-
 fs/btrfs/tests/inode-tests.c                       |  12 +-
 fs/btrfs/tree-checker.c                            |   3 +
 fs/btrfs/volumes.c                                 |   8 +-
 fs/cifs/cifsacl.c                                  |   1 +
 fs/cifs/smb2ops.c                                  |  88 ++++++--
 fs/efivarfs/inode.c                                |   2 +
 fs/efivarfs/super.c                                |   1 -
 fs/io_uring.c                                      |  66 ++++--
 fs/proc/self.c                                     |   7 +
 include/kunit/test.h                               |   2 +-
 include/linux/firmware/xlnx-zynqmp.h               |   4 -
 include/linux/pgtable.h                            |  13 ++
 include/linux/platform_data/ti-sysc.h              |   1 +
 include/net/bonding.h                              |   8 +
 include/scsi/libiscsi.h                            |   3 +
 include/trace/events/writeback.h                   |   8 +-
 kernel/locking/lockdep.c                           |   6 +-
 mm/filemap.c                                       |   8 +
 mm/page-writeback.c                                |   6 -
 net/batman-adv/log.c                               |   1 +
 net/ipv4/fib_frontend.c                            |   2 +-
 tools/perf/util/dwarf-aux.c                        |   8 +
 tools/perf/util/stat-display.c                     |   5 +-
 tools/perf/util/synthetic-events.c                 |   3 +
 168 files changed, 1701 insertions(+), 1098 deletions(-)


