Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245F42C9B21
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbgLAJEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388735AbgLAJDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56BF2222A;
        Tue,  1 Dec 2020 09:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813413;
        bh=Nqkz6S7p5uKLg/Q/qgZs0iq5JhWplBKLKbgtdwMD5xg=;
        h=From:To:Cc:Subject:Date:From;
        b=WO5i1XfUA8lU0xCtEB9dhyC83QauST/6dvCvU8YThCl22nGTqu4/o4xX09qeJMBcA
         JLRd+LggWs3ZMckiSIxePqTHnrth8fThM4DwrOexQkqpv+IjufjzA/678W5oqzag/c
         OKYgjqswr/Qe5BlSv1WTZprsg2sTFIUUdU/ZpVz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/98] 5.4.81-rc1 review
Date:   Tue,  1 Dec 2020 09:52:37 +0100
Message-Id: <20201201084652.827177826@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.81-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.81-rc1
X-KernelTest-Deadline: 2020-12-03T08:46+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.81 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.81-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.81-rc1

Mateusz Gorski <mateusz.gorski@linux.intel.com>
    ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT

Mateusz Gorski <mateusz.gorski@linux.intel.com>
    ASoC: Intel: Multiple I/O PCM format support for pipe

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Await purge request ack on CNL

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Allow for ROM init retry on CNL platforms

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Shield against no-NHLT configurations

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Enable codec wakeup during chip init

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Select hda configuration permissively

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Remove superfluous chip initialization

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix regression in Hercules audio card

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

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags

Yixian Liu <liuyixian@huawei.com>
    RDMA/hns: Bugfix for memory window mtpt configuration

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix retry_cnt and rnr_cnt when querying QP

Kaixu Xia <kaixuxia@tencent.com>
    platform/x86: toshiba_acpi: Fix the wrong variable assignment

Benjamin Berg <bberg@redhat.com>
    platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix endianess problem with candleLight firmware

Geert Uytterhoeven <geert@linux-m68k.org>
    efi: EFI_EARLYCON should depend on EFI

Ard Biesheuvel <ardb@kernel.org>
    efivarfs: revert "fix memory leak in efivarfs_create()"

Dipen Patel <dipenp@nvidia.com>
    arm64: tegra: Wrong AON HSP reg property size

Rui Miguel Silva <rui.silva@linaro.org>
    optee: add writeback to valid memory type

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues

Shay Agroskin <shayagr@amazon.com>
    net: ena: set initial DMA width to avoid intel iommu issue

Krzysztof Kozlowski <krzk@kernel.org>
    nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix removing driver while bare-metal VFs pass traffic

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    IB/mthca: fix return value of error branch in mthca_init_cq()

Stephen Rothwell <sfr@canb.auug.org.au>
    powerpc/64s: Fix allnoconfig build since uaccess flush

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: notify peers when failover and migration happen

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix call_netdevice_notifiers in do_reset

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix tear down of async TX buffers

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix af_iucv notification race

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: make af_iucv TX notification call more robust

Raju Rangoju <rajur@chelsio.com>
    cxgb4: fix the panic caused by non smac rewrite

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

Arnd Bergmann <arnd@arndb.de>
    arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Taehee Yoo <ap420073@gmail.com>
    batman-adv: set .owner to THIS_MODULE

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: write queue_sync_state only for sync

Marc Zyngier <maz@kernel.org>
    phy: tegra: xusb: Fix dangling pointer on probe failure

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Manage MPU state properly for omap_enter_idle_coupled()

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix bogus resetdone warning on enable for cpsw

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    xtensa: uaccess: Add missing __user to strncpy_from_user() prototype

Sami Tolvanen <samitolvanen@google.com>
    perf/x86: fix sysfs type mismatches

Mike Christie <michael.christie@oracle.com>
    scsi: target: iscsi: Fix cmd abort fabric stop race

Lee Duncan <lduncan@suse.com>
    scsi: libiscsi: Fix NOP race condition

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Mike Christie <michael.christie@oracle.com>
    vhost scsi: fix cmd completion race

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme: free sq/cq dbbuf pointers when dbbuf set fails

Jens Axboe <axboe@kernel.dk>
    proc: don't allow async path resolution of /proc/self components

Hans de Goede <hdegoede@redhat.com>
    HID: Add Logitech Dinovo Edge battery quirk

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge

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

Will Deacon <will@kernel.org>
    arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()

Will Deacon <will@kernel.org>
    arm64: pgtable: Fix pte_accessible()

Hui Su <sh_def@163.com>
    trace: fix potenial dangerous pointer

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Fix split-irqchip vs interrupt injection window request

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page

Namjae Jeon <namjae.jeon@samsung.com>
    cifs: fix a memleak with modefromsid

Rohith Surabattula <rohiths@microsoft.com>
    smb3: Handle error case during offload read path

Rohith Surabattula <rohiths@microsoft.com>
    smb3: Avoid Mid pending list corruption

Rohith Surabattula <rohiths@microsoft.com>
    smb3: Call cifs reconnect from demultiplex thread

Hauke Mehrtens <hauke@hauke-m.de>
    wireless: Use linux/stddef.h instead of stddef.h

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat when reading qgroup config on mount

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't access possibly stale fs_info data for printing duplicate device

David Sterba <dsterba@suse.com>
    btrfs: tree-checker: add missing returns after data_ref alignment checks

Daniel Xu <dxu@dxuuu.xyz>
    btrfs: tree-checker: add missing return after error in root_item

Cong Wang <cong.wang@bytedance.com>
    netfilter: clear skb->next in NF_HOOK_LIST()

Florian Klink <flokli@flokli.de>
    ipv4: use IS_ENABLED instead of ifdef

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix use-after-free on unbind

Lukas Wunner <lukas@wunner.de>
    spi: bcm-qspi: Fix use-after-free on unbind


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/pgtable.h                     |   2 +
 arch/arm/boot/dts/dra76x.dtsi                      |   4 +-
 arch/arm/include/asm/pgtable-2level.h              |   2 +
 arch/arm/include/asm/pgtable-3level.h              |   2 +
 arch/arm/mach-omap2/cpuidle44xx.c                  |   8 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   2 +-
 arch/arm64/include/asm/pgtable.h                   |  34 ++---
 arch/mips/include/asm/pgtable-32.h                 |   3 +
 arch/powerpc/include/asm/book3s/32/pgtable.h       |   2 +
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |   2 +
 arch/powerpc/include/asm/nohash/32/pgtable.h       |   2 +
 arch/powerpc/kvm/book3s_xive_native.c              |   7 +
 arch/riscv/include/asm/pgtable-32.h                |   2 +
 arch/x86/events/intel/cstate.c                     |   6 +-
 arch/x86/events/intel/uncore.c                     |   4 +-
 arch/x86/events/intel/uncore.h                     |  12 +-
 arch/x86/events/rapl.c                             |  14 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/cpu/bugs.c                         |   4 +-
 arch/x86/kernel/cpu/mce/core.c                     |   6 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  65 ++++-----
 arch/x86/kvm/irq.c                                 |  85 +++++------
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/x86.c                                 |  18 +--
 arch/x86/xen/spinlock.c                            |  12 +-
 arch/xtensa/include/asm/uaccess.h                  |   2 +-
 drivers/bus/ti-sysc.c                              |   3 +
 drivers/dma/pl330.c                                |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   4 +-
 drivers/firmware/efi/Kconfig                       |   2 +-
 drivers/hid/hid-cypress.c                          |  44 +++++-
 drivers/hid/hid-ids.h                              |   9 ++
 drivers/hid/hid-input.c                            |   3 +
 drivers/hid/hid-ite.c                              |  61 +++++++-
 drivers/hid/hid-logitech-hidpp.c                   |   6 +
 drivers/hid/hid-quirks.c                           |   5 +
 drivers/hid/hid-sensor-hub.c                       |   3 +-
 drivers/hid/hid-uclogic-core.c                     |   2 +
 drivers/hid/hid-uclogic-params.c                   |   2 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   9 +-
 drivers/infiniband/hw/mthca/mthca_cq.c             |  10 +-
 drivers/input/serio/i8042.c                        |  12 +-
 drivers/irqchip/irq-sni-exiu.c                     |   2 +-
 drivers/net/can/m_can/m_can.c                      |   4 +-
 drivers/net/can/usb/gs_usb.c                       | 131 +++++++++--------
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/dsa/mv88e6xxx/global1.c                |  31 ++++
 drivers/net/dsa/mv88e6xxx/global1.h                |   1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  17 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  14 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  22 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  26 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   3 +
 drivers/nfc/s3fwrn5/i2c.c                          |   4 +-
 drivers/nvme/host/pci.c                            |  15 ++
 drivers/phy/tegra/xusb.c                           |   1 +
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/platform/x86/toshiba_acpi.c                |   3 +-
 drivers/s390/net/qeth_core.h                       |   9 +-
 drivers/s390/net/qeth_core_main.c                  |  82 +++++++----
 drivers/scsi/libiscsi.c                            |  23 +--
 drivers/scsi/ufs/ufshcd.c                          |   6 +-
 drivers/spi/spi-bcm-qspi.c                         |  34 ++---
 drivers/spi/spi-bcm2835.c                          |  18 +--
 drivers/spi/spi-bcm2835aux.c                       |   3 +-
 drivers/staging/ralink-gdma/Kconfig                |   1 +
 drivers/target/iscsi/iscsi_target.c                |  17 ++-
 drivers/tee/optee/call.c                           |   3 +-
 drivers/usb/core/devio.c                           |  14 +-
 drivers/usb/core/quirks.c                          |  10 ++
 drivers/usb/gadget/function/f_midi.c               |  10 +-
 drivers/usb/gadget/legacy/inode.c                  |   3 +
 drivers/vhost/scsi.c                               |  42 ++----
 drivers/video/fbdev/hyperv_fb.c                    |   7 +-
 fs/btrfs/qgroup.c                                  |   2 +-
 fs/btrfs/tree-checker.c                            |   3 +
 fs/btrfs/volumes.c                                 |   8 +-
 fs/cifs/cifsacl.c                                  |   1 +
 fs/cifs/smb2ops.c                                  |  88 ++++++++++--
 fs/efivarfs/inode.c                                |   2 +
 fs/efivarfs/super.c                                |   1 -
 fs/proc/self.c                                     |   7 +
 include/asm-generic/pgtable.h                      |  13 ++
 include/linux/netfilter.h                          |   2 +-
 include/scsi/libiscsi.h                            |   3 +
 include/trace/events/writeback.h                   |   8 +-
 include/uapi/linux/wireless.h                      |   6 +-
 include/uapi/sound/skl-tplg-interface.h            |   2 +
 net/batman-adv/log.c                               |   1 +
 net/ipv4/fib_frontend.c                            |   2 +-
 sound/soc/intel/skylake/bxt-sst.c                  |   3 -
 sound/soc/intel/skylake/cnl-sst.c                  |  35 ++++-
 sound/soc/intel/skylake/skl-nhlt.c                 |   3 +-
 sound/soc/intel/skylake/skl-sst-dsp.h              |   2 +
 sound/soc/intel/skylake/skl-topology.c             | 159 ++++++++++++++++++++-
 sound/soc/intel/skylake/skl-topology.h             |   1 +
 sound/soc/intel/skylake/skl.c                      |  29 ++--
 tools/perf/util/dwarf-aux.c                        |   8 ++
 tools/perf/util/stat-display.c                     |   5 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |  22 ++-
 104 files changed, 1013 insertions(+), 454 deletions(-)


