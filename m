Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C39833B611
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCON5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhCON43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2026664EFE;
        Mon, 15 Mar 2021 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816589;
        bh=Z8CJ23SfORqF+8L3FUDEA1SgGIfKdlVSvzOTt0/56dI=;
        h=From:To:Cc:Subject:Date:From;
        b=kkMSENGPdlXim6aAkWi5Jon2cEHiil6G4SY9kWwNV5eEW93W13i9wXU1uJxEXjrSv
         xw1Ef3EnDL7AUzaS9YN1nIT2TcZVAw+iNAA/XV6Q0iQzZprH9t7kyvkWIjUQTe/k2U
         LKkd2mBa1fCtA25NZEeThrvU0p4HDIMA0LFQrLQY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/290] 5.10.24-rc1 review
Date:   Mon, 15 Mar 2021 14:51:33 +0100
Message-Id: <20210315135541.921894249@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.24-rc1
X-KernelTest-Deadline: 2021-03-17T13:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 5.10.24 release.
There are 290 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.24-rc1

Christoph Hellwig <hch@lst.de>
    RDMA/umem: Use ib_dma_max_seg_size instead of dma_get_max_seg_size

Andrew Scull <ascull@google.com>
    KVM: arm64: Fix nVHE hyp panic host context restore

Juergen Gross <jgross@suse.com>
    xen/events: avoid handling the same event on two cpus at the same time

Juergen Gross <jgross@suse.com>
    xen/events: don't unmask an event channel when an eoi is pending

Mike Rapoport <rppt@kernel.org>
    mm/page_alloc.c: refactor initialization of struct page for holes in memory layout

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Ensure I-cache isolation between vcpus of a same VM

Suren Baghdasaryan <surenb@google.com>
    mm/madvise: replace ptrace attach requirement for process_madvise

Nadav Amit <namit@vmware.com>
    mm/userfaultfd: fix memory corruption due to writeprotect

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix exclusive limit for IPA size

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Reject VM creation when the default IPA size is unsupported

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: nvhe: Save the SPE context early

Will Deacon <will@kernel.org>
    KVM: arm64: Avoid corrupting vCPU context register in guest exit

Jia He <justin.he@arm.com>
    KVM: arm64: Fix range alignment when walking page tables

Wanpeng Li <wanpengli@tencent.com>
    KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ensure deadline timer has truly expired before posting its IRQ

Andy Lutomirski <luto@kernel.org>
    x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Use __copy_from_user_inatomic()

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Correctly track IRQ states in runtime #VC handler

Thomas Gleixner <tglx@linutronix.de>
    x86/entry: Move nmi entry/exit into common code

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Check regs->sp is trusted before adjusting #VC IST stack

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Introduce ip_within_syscall_gap() helper

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2

Lior Ribak <liorribak@gmail.com>
    binfmt_misc: fix possible deadlock in bm_register_write

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Fix missing declaration of [en/dis]able_kernel_vsx()

Nicholas Piggin <npiggin@gmail.com>
    powerpc: Fix inverted SET_FULL_REGS bitop

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Ard Biesheuvel <ardb@kernel.org>
    efi: stub: omit SetVirtualAddressMap() if marked unsupported in RT_PROP table

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    sched/membarrier: fix missing local execution of ipi_sync_rq_state()

Arnd Bergmann <arnd@arndb.de>
    linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Minchan Kim <minchan@kernel.org>
    zram: fix return value on writeback_store

Alexey Dobriyan <adobriyan@gmail.com>
    prctl: fix PR_SET_MM_AUXV kernel stack leak

Matthew Wilcox (Oracle) <willy@infradead.org>
    include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Arnd Bergmann <arnd@arndb.de>
    stop_machine: mark helpers __always_inline

Peter Zijlstra <peterz@infradead.org>
    seqlock,lockdep: Fix seqcount_latch_init()

Daniel Axtens <dja@axtens.net>
    powerpc/64s/exception: Clean up a missed SRR specifier

Anna-Maria Behnsen <anna-maria@linutronix.de>
    hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Set PERF_ATTACH_SCHED_CB for large PEBS and LBR

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Flush PMU internal buffers for per-CPU events

Ard Biesheuvel <ardb@kernel.org>
    arm64: mm: use a 48-bit ID map when possible on 52-bit VA builds

Daiyue Zhang <zhangdaiyue1@huawei.com>
    configfs: fix a use-after-free in __configfs_open_file

James Smart <jsmart2021@gmail.com>
    nvme-fc: fix racing controller reset and create association

Jia-Ju Bai <baijiaju1990@gmail.com>
    block: rsxx: fix error return code of rsxx_pci_probe()

Ondrej Mosnacek <omosnace@redhat.com>
    NFSv4.2: fix return value of _nfs4_get_security_label()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't gratuitously clear the inode cache when lookup failed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't revalidate the directory permissions on a lookup failure

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Set memalloc_nofs_save() for sync tasks

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory

Wei Yongjun <weiyongjun1@huawei.com>
    cpufreq: qcom-hw: Fix return value check in qcom_cpufreq_hw_cpu_init()

Shawn Guo <shawn.guo@linaro.org>
    cpufreq: qcom-hw: fix dereferencing freed memory 'data'

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for R7S72100

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcl818: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcl711: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: me4000: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dmm32at: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das800: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das6402: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: adv_pci1710: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1500: Fix endian problem for command sample

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1032: Fix endian problem for COS sample

Lee Gibson <leegib@gmail.com>
    staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Lee Gibson <leegib@gmail.com>
    staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd

Dan Carpenter <dan.carpenter@oracle.com>
    staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: unterminated string leads to read overflow

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    misc: fastrpc: restrict user apps from sending kernel RPC messages

Shile Zhang <shile.zhang@linux.alibaba.com>
    misc/pvpanic: Export module FDT device table

Alexander Shiyan <shc_work@mail.ru>
    Revert "serial: max310x: rework RX interrupt handling"

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vudc usbip_sockfd_store races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vhci_hcd attach_store() races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix stub_dev usbip_sockfd_store() races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vudc to check for stream socket

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vhci_hcd to check for stream socket

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix stub_dev to check for stream socket

Sebastian Reichel <sebastian.reichel@collabora.com>
    USB: serial: cp210x: add some more GE USB IDs

Karan Singhal <karan.singhal@acuitybrands.com>
    USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Niv Sardi <xaiki@evilgiggle.com>
    USB: serial: ch341: add new Product ID

Pavel Skripkin <paskripkin@gmail.com>
    USB: serial: io_edgeport: fix memory leak in edge_startup

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix repeated xhci wake after suspend due to uncleared internal wake state

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Improve detection of device initiated wake signal.

Stanislaw Gruszka <stf_xl@wp.pl>
    usb: xhci: do not perform Soft Retry for some xHCI hosts

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM

Pete Zaitcev <zaitcev@redhat.com>
    USB: usblp: fix a hang in poll() if disconnected

Matthias Kaehlcke <mka@chromium.org>
    usb: dwc3: qcom: Honor wakeup enabled/disabled state

Shawn Guo <shawn.guo@linaro.org>
    usb: dwc3: qcom: add ACPI device id for sc8180x

Shawn Guo <shawn.guo@linaro.org>
    usb: dwc3: qcom: add URS Host support for sdm845 ACPI boot

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac1: stop playback on function disable

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot

Dan Carpenter <dan.carpenter@oracle.com>
    USB: gadget: u_ether: Fix a configfs return code

Wei Yongjun <weiyongjun1@huawei.com>
    USB: gadget: udc: s3c2410_udc: fix return value check in s3c2410_udc_probe()

Yorick de Wid <ydewid@gmail.com>
    Goodix Fingerprint device is not a modem

Paulo Alcantara <pc@cjr.nz>
    cifs: do not send close in compound create+close requests

Frank Li <lznuaa@gmail.com>
    mmc: cqhci: Fix random crash when remove mmc module/card

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix partition switch time for eMMC

Yann Gautier <yann.gautier@foss.st.com>
    mmc: mmci: Add MMC_CAP_NEED_RSP_BUSY for the stm32 variants

Juergen Gross <jgross@suse.com>
    xen/events: reset affinity of 2-level event when tearing it down

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    software node: Fix node registration

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging IO request during DASD driver unbind

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging DASD driver unbind

Rob Herring <robh@kernel.org>
    arm64: perf: Fix 64-bit event counter read truncation

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Map hotplugged memory as Normal Tagged

Andrey Konovalov <andreyknvl@google.com>
    arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL

Jan Kara <jack@suse.cz>
    block: Try to handle busy underlying device on discard

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: Discard page cache of zone reset target range

Eric W. Biederman <ebiederm@xmission.com>
    Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Pavel Skripkin <paskripkin@gmail.com>
    ALSA: usb-audio: fix use after free in usb_audio_disconnect

Pavel Skripkin <paskripkin@gmail.com>
    ALSA: usb-audio: fix NULL ptr dereference in usb_audio_probe

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: usb-audio: Disable USB autosuspend properly in setup_disable_autosuspend()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply the control quirk to Plantronics headsets

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Avoid spurious unsol event handling during S3/S4

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Flush pending unsolicited events before suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Drop the BATCH workaround for AMD controllers

Simeon Simeonoff <sim.simeonoff@gmail.com>
    ALSA: hda/ca0132: Add Sound BlasterX AE-5 Plus support

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Add quirk for mute LED control on HP ZBook G5

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Cancel pending works before suspend

John Ernberg <john.ernberg@actia.se>
    ALSA: usb: Add Plantronics C320-M USB ctrl msg delay quirk

Ard Biesheuvel <ardb@kernel.org>
    ARM: efistub: replace adrl pseudo-op with adr_l macro invocation

Ard Biesheuvel <ardb@kernel.org>
    ARM: assembler: introduce adr_l, ldr_l and str_l macros

Jian Cai <jiancai@google.com>
    ARM: 9029/1: Make iwmmxt.S support Clang's integrated assembler

Jeremy Linton <jeremy.linton@arm.com>
    mmc: sdhci: Update firmware interface API

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    clk: qcom: gpucc-msm8998: Add resets, cxc, fix flags on gpu_gx_gdsc

Aleksandr Miloserdov <a.miloserdov@yadro.com>
    scsi: target: core: Prevent underflow for service actions

Aleksandr Miloserdov <a.miloserdov@yadro.com>
    scsi: target: core: Add cmd length set before cmd complete

Mike Christie <michael.christie@oracle.com>
    scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Lin Feng <linf@wangsu.com>
    sysctl.c: fix underflow value setting risk in vm_table

David Hildenbrand <david@redhat.com>
    drivers/base/memory: don't store phys_device in memory blocks

Heiko Carstens <hca@linux.ibm.com>
    s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Andrey Konovalov <andreyknvl@google.com>
    kasan: fix memory corruption in kasan_bitops_tags test

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    i40e: Fix memory leak in i40e_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: Fix pci_register_io_range() memory leak

Sasha Levin <sashal@kernel.org>
    kbuild: clamp SUBLEVEL to 255

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to processed freed blocks until mballoc is initialized

Bjorn Helgaas <bhelgaas@google.com>
    PCI/LINK: Remove bandwidth notification

Arnd Bergmann <arnd@arndb.de>
    drivers/base: build kunit tests without structleak plugin

Krzysztof Wilczyński <kw@linux.com>
    PCI: mediatek: Add missing of_node_put() to fix reference leak

Martin Kaiser <martin@kaiser.cx>
    PCI: xgene-msi: Fix race in installing chained irq handler

Ronald Tschalär <ronald@innovation.ch>
    Input: applespi - don't wait for responses to commands indefinitely.

Khalid Aziz <khalid.aziz@oracle.com>
    sparc64: Use arch_validate_flags() to validate ADI flag

Andreas Larsson <andreas@gaisler.com>
    sparc32: Limit memblock allocation to low memory

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    clk: qcom: gdsc: Implement NO_RET_PERIPH flag

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Fix performance counter initialization

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Fix stack trace not displaying final frame

Filipe Laíns <lains@riseup.net>
    HID: logitech-dj: add support for the new lightspeed connection iteration

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Nicholas Piggin <npiggin@gmail.com>
    powerpc: improve handling of unrecoverable system reset

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32: make spurious and overrun interrupts visible

Oliver O'Halloran <oohall@gmail.com>
    powerpc/pci: Add ppc_md.discover_phbs()

Lubomir Rintel <lkundrak@v3.sk>
    Platform: OLPC: Fix probe error handling

Jeremy Linton <jeremy.linton@arm.com>
    mmc: sdhci-iproc: Add ACPI bindings for the RPi

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear PRQ overflow only when PRQ is empty

Steven J. Magnani <magnani@ieee.org>
    udf: fix silent AED tagLocation corruption

Jaegeuk Kim <jaegeuk@kernel.org>
    scsi: ufs: WB is only available on LUN #0 to #7

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: optimize cacheline to minimize HW race condition

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: faster irq code to minimize HW race condition

Kalle Valo <kvalo@codeaurora.org>
    ath11k: fix AP mode for QCA6390

Carl Huang <cjhuang@codeaurora.org>
    ath11k: start vdev if a bss peer is already created

Ritesh Singh <ritesi@codeaurora.org>
    ath11k: peer delete synchronization with firmware

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: initialize RFS/RSS memories for unused ports too

Arnd Bergmann <arnd@arndb.de>
    enetc: Fix unused var build warning for CONFIG_OF

DENG Qingfang <dqfext@gmail.com>
    net: dsa: tag_mtk: fix 802.1ad VLAN egress

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_ar9331: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_gswip: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_dsa: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_brcm: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_edsa: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_lan9303: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_mtk: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_ocelot: let DSA core deal with TX reallocation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_qca: let DSA core deal with TX reallocation

Christian Eggers <ceggers@arri.de>
    net: dsa: trailer: don't allocate additional memory for padding/tagging

Christian Eggers <ceggers@arri.de>
    net: dsa: tag_ksz: don't allocate additional memory for padding/tagging

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: implement a central TX reallocation procedure

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix notification for pending buffers during teardown

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: improve completion of pending TX buffers

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: remove QETH_QDIO_BUF_HANDLED_DELAYED state

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't replace a fully completed async TX buffer

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix error mask definition of flow director

Aurelien Aptel <aaptel@suse.com>
    cifs: fix credit accounting for extra channel

Hans Verkuil <hverkuil@xs4all.nl>
    media: rc: compile rc-cec.c into rc-core

Biju Das <biju.das.jz@bp.renesas.com>
    media: v4l: vsp1: Fix bru null pointer access

Biju Das <biju.das.jz@bp.renesas.com>
    media: v4l: vsp1: Fix uif null pointer access

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: rkisp1: params: fix wrong bits settings

Maxim Mikityanskiy <maxtram95@gmail.com>
    media: usbtv: Fix deadlock on suspend

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for R7S9210

Colin Ian King <colin.king@canonical.com>
    qxl: Fix uninitialised struct field head.surface_id

Wang Qing <wangqing@vivo.com>
    s390/crypto: return -EFAULT if copy_to_user() fails

Eric Farman <farman@linux.ibm.com>
    s390/cio: return -EFAULT if copy_to_user() fails

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Wedge the GPU if command parser setup fails

Noralf Trønnes <noralf@tronnes.org>
    drm/shmem-helpers: vunmap: Don't put pages for dma-buf

Artem Lapkin <art@khadas.com>
    drm: meson_drv add shutdown function

Thomas Zimmermann <tzimmermann@suse.de>
    drm: Use USB controller's DMA mask when importing dmabufs

Neil Roberts <nroberts@igalia.com>
    drm/shmem-helper: Don't remove the offset in vm_area_struct pgoff

Neil Roberts <nroberts@igalia.com>
    drm/shmem-helper: Check for purged buffers in fault handler

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: handle aux backlight in backlight_get_brightness

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: don't assert in set backlight function

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: simplify backlight setting

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: bug fix for pcie dpm

Holger Hoffstätte <holger@applied-asynchrony.com>
    drm/amd/display: Fix nested FPU context in dcn21_validate_bandwidth()

Holger Hoffstätte <holger@applied-asynchrony.com>
    drm/amdgpu/display: use GFP_ATOMIC in dcn21_validate_bandwidth_fp()

Takashi Iwai <tiwai@suse.de>
    drm/amd/display: Add a backlight module option

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/compat: Clear bounce structures

Johan Hovold <johan@kernel.org>
    gpio: fix gpio-device list corruption

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Read "gpio-line-names" from a firmware node

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Allow to find GpioInt() resource by name and index

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: reliably allocate IRQ table on reset to avoid crash

Wang Qing <wangqing@vivo.com>
    s390/cio: return -EFAULT if copy_to_user() fails again

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix bug when calculating the TCAM table info

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix query vlan mask value error for flow director

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf report: Fix -F for branch & mem modes

Ian Rogers <irogers@google.com>
    perf traceevent: Ensure read cmdlines are null terminated.

Danielle Ratson <danieller@nvidia.com>
    mlxsw: spectrum_ethtool: Add an external speed to PTYS register

Danielle Ratson <danieller@nvidia.com>
    selftests: forwarding: Fix race condition in mirror installation

Arnd Bergmann <arnd@arndb.de>
    net: phy: make mdio_bus_phy_suspend/resume as __maybe_unused

Yinjun Zhang <yinjun.zhang@corigine.com>
    ethtool: fix the check logic of at least one channel for RX/TX

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix wrongly set buffer2 valid when sph unsupport

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix watchdog timeout during suspend/resume stress test

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: stop each tx channel independently

Antonio Terceiro <antonio.terceiro@linaro.org>
    perf build: Fix ccache usage in $(CC) when generating arch errno table

Kun-Chuan Hsieh <jetswayss@gmail.com>
    tools/resolve_btfids: Fix build error with older host toolchains

Antony Antony <antony@phenome.org>
    ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Hayes Wang <hayeswang@realtek.com>
    r8169: fix r8168fp_adjust_ocp_cmd function

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix memory leak after failed TX Buffer allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qrtr: fix error return code of qrtr_sendmsg()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: allow hardware timestamping on TX queues with tc-etf enabled

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Fix regulator not turned off on driver removal

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Fix regulator not turned off on failed probe

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Remove netif_start_queue / netif_stop_queue

Wong Vee Khee <vee.khee.wong@intel.com>
    stmmac: intel: Fixes clock registration error seen for multiple interfaces

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: Fix VLAN filter delete timeout issue in Intel mGBE SGMII

Paul Moore <paul@paul-moore.com>
    cipso,calipso: resolve a number of problems with the DOI refcounts

Hillf Danton <hdanton@sina.com>
    netdevsim: init u64 stats for 32bit hardware

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: allow qmimux add/del with master up

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix SGMII PCS being forced to SPEED_UNKNOWN instead of SPEED_10

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: properly reject destination IP keys in VCAP IS1

Maximilian Heyne <mheyne@amazon.de>
    net: sched: avoid duplicates in classes dump

Ido Schimmel <idosch@nvidia.com>
    nexthop: Do not flush blackhole nexthops when loopback goes down

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10

Kevin(Yudong) Yang <yyd@google.com>
    net/mlx4_en: update moderation when config reset

Biao Huang <biao.huang@mediatek.com>
    net: ethernet: mtk-star-emac: fix wrong unmap in RX handling

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: keep RX ring consumer index in sync with hardware

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: force the RGMII speed and duplex instead of operating in inband mode

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: don't disable VLAN filtering in IFF_PROMISC mode

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: take the MDIO lock only once per NAPI poll cycle

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: don't overwrite the RSS indirection table when initializing

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for SH771x

DENG Qingfang <dqfext@gmail.com>
    net: dsa: tag_rtl4_a: fix egress tags

Jakub Kicinski <kuba@kernel.org>
    docs: networking: drop special stable handling

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Paulo Alcantara <pc@cjr.nz>
    cifs: return proper error code in statfs(2)

Christian Brauner <christian.brauner@ubuntu.com>
    mount: fix mounting of detached mounts onto targets that reside on shared mounts

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/603: Fix protection of user pages mapped with PROT_NONE

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: do not report truncated frames to mac80211

Jiri Wiesner <jwiesner@suse.com>
    ibmvnic: always store valid MAC address

Michal Suchanek <msuchanek@suse.de>
    ibmvnic: Fix possibly uninitialized old_num_tx_queues variable warning.

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    libbpf: Clear map_info before each bpf_obj_get_info_by_fd

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    samples, bpf: Add missing munmap in xdpsock

Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
    selftests/bpf: Mask bpf_csum_diff() return value to 16 bits in test_verifier

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: No need to drop the packet when there is no geneve opt

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Use the last page in test_snprintf_btf on s390

Guangbin Huang <huangguangbin2@huawei.com>
    net: phy: fix save wrong speed and duplex problem if autoneg is on

Jason A. Donenfeld <Jason@zx2c4.com>
    net: always use icmp{,v6}_ndo_send from ndo_start_xmit

Vasily Averin <vvs@virtuozzo.com>
    netfilter: x_tables: gpf inside xt_find_revision()

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: undo erroneous tcp edemux lookup

Eric Dumazet <edumazet@google.com>
    tcp: add sanity tests to TCP_QUEUE_SEQ

Arjun Roy <arjunroy@google.com>
    tcp: Fix sign comparison bug in getsockopt(TCP_ZEROCOPY_RECEIVE)

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: tcan4x5x: tcan4x5x_init(): fix initialization - clear MRAM before entering Normal Mode

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: invoke flexcan_chip_freeze() to enter freeze mode

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: enable RX FIFO after FRZ/HALT valid

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: assert FRZ bit in flexcan_chip_freeze()

Oleksij Rempel <linux@rempel-privat.de>
    can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Matthias Schiffer <mschiffer@universe-factory.net>
    net: l2tp: reduce log level of messages in receive path, add counter instead

Balazs Nemeth <bnemeth@redhat.com>
    net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

Balazs Nemeth <bnemeth@redhat.com>
    net: check if protocol extracted by virtio_net_hdr_set_proto is correct

Daniel Borkmann <daniel@iogearbox.net>
    net: Fix gro aggregation for udp encaps with zero csum

Felix Fietkau <nbd@nbd.name>
    ath9k: fix transmitting to stations in dynamic SMPS mode

Maciej W. Rozycki <macro@orcam.me.uk>
    crypto: mips/poly1305 - enable for all MIPS processors

Jakub Kicinski <kuba@kernel.org>
    ethernet: alx: fix order of calls on resume

Greg Kurz <groug@kaod.org>
    powerpc/pseries: Don't enforce MSI affinity with kdump

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix handling of privilege level checks in perf interrupt context

Dmitry V. Levin <ldv@altlinux.org>
    uapi: nfnetlink_cthelper.h: fix userspace compilation error


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-memory     |   5 +-
 Documentation/admin-guide/mm/memory-hotplug.rst    |   4 +-
 Documentation/gpu/todo.rst                         |  21 +++
 Documentation/networking/netdev-FAQ.rst            |  78 +-------
 Documentation/process/stable-kernel-rules.rst      |   6 -
 Documentation/process/submitting-patches.rst       |   5 -
 Documentation/virt/kvm/api.rst                     |   3 +
 Makefile                                           |  16 +-
 arch/arm/boot/compressed/head.S                    |   3 +-
 arch/arm/include/asm/assembler.h                   |  84 +++++++++
 arch/arm/kernel/iwmmxt.S                           |  89 ++++-----
 arch/arm/kernel/iwmmxt.h                           |  47 +++++
 arch/arm64/include/asm/kvm_asm.h                   |   4 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   8 +-
 arch/arm64/include/asm/memory.h                    |   5 +
 arch/arm64/include/asm/mmu_context.h               |   5 +-
 arch/arm64/include/asm/pgtable-prot.h              |   1 -
 arch/arm64/include/asm/pgtable.h                   |   3 +
 arch/arm64/kernel/head.S                           |   2 +-
 arch/arm64/kernel/perf_event.c                     |   2 +-
 arch/arm64/kvm/arm.c                               |   7 +-
 arch/arm64/kvm/hyp/entry.S                         |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |  20 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  14 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |   3 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   1 +
 arch/arm64/kvm/hyp/vhe/tlb.c                       |   3 +-
 arch/arm64/kvm/mmu.c                               |   3 +-
 arch/arm64/kvm/reset.c                             |  12 +-
 arch/arm64/mm/init.c                               |  12 ++
 arch/arm64/mm/mmu.c                                |   5 +-
 arch/mips/crypto/Makefile                          |   4 +-
 arch/powerpc/include/asm/code-patching.h           |   2 +-
 arch/powerpc/include/asm/machdep.h                 |   3 +
 arch/powerpc/include/asm/ptrace.h                  |   7 +-
 arch/powerpc/include/asm/switch_to.h               |  10 ++
 arch/powerpc/kernel/asm-offsets.c                  |   2 +-
 arch/powerpc/kernel/exceptions-64s.S               |   2 +-
 arch/powerpc/kernel/head_book3s_32.S               |   9 +-
 arch/powerpc/kernel/pci-common.c                   |  10 ++
 arch/powerpc/kernel/process.c                      |   2 +-
 arch/powerpc/kernel/traps.c                        |   5 +-
 arch/powerpc/perf/core-book3s.c                    |  23 ++-
 arch/powerpc/platforms/pseries/msi.c               |  25 ++-
 arch/s390/kernel/smp.c                             |   2 +-
 arch/sparc/include/asm/mman.h                      |  54 +++---
 arch/sparc/mm/init_32.c                            |   3 +
 arch/x86/entry/common.c                            |  37 +---
 arch/x86/entry/entry_64_compat.S                   |   2 +
 arch/x86/events/intel/core.c                       |   5 +-
 arch/x86/include/asm/idtentry.h                    |   3 -
 arch/x86/include/asm/insn-eval.h                   |   2 +
 arch/x86/include/asm/proto.h                       |   1 +
 arch/x86/include/asm/ptrace.h                      |  15 ++
 arch/x86/kernel/cpu/mce/core.c                     |   6 +-
 arch/x86/kernel/kvmclock.c                         |  19 +-
 arch/x86/kernel/nmi.c                              |   6 +-
 arch/x86/kernel/sev-es.c                           |  22 ++-
 arch/x86/kernel/traps.c                            |  16 +-
 arch/x86/kernel/unwind_orc.c                       |  12 +-
 arch/x86/kvm/lapic.c                               |  11 +-
 arch/x86/lib/insn-eval.c                           |  66 +++++--
 block/blk-zoned.c                                  |  38 +++-
 crypto/Kconfig                                     |   2 +-
 drivers/base/memory.c                              |  25 +--
 drivers/base/swnode.c                              |   3 +
 drivers/base/test/Makefile                         |   1 +
 drivers/block/rsxx/core.c                          |   1 +
 drivers/block/zram/zram_drv.c                      |  11 +-
 drivers/clk/qcom/gdsc.c                            |  10 +-
 drivers/clk/qcom/gdsc.h                            |   3 +-
 drivers/clk/qcom/gpucc-msm8998.c                   |   8 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |   6 +-
 drivers/firmware/efi/libstub/efi-stub.c            |  16 ++
 drivers/gpio/gpio-pca953x.c                        |  78 +++-----
 drivers/gpio/gpiolib-acpi.c                        |  19 +-
 drivers/gpio/gpiolib.c                             |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   4 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  49 ++---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   1 -
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   6 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  48 +++++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |  66 +++++++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |  48 ++---
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  32 ++--
 drivers/gpu/drm/drm_ioc32.c                        |  11 ++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   7 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  19 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   2 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  11 ++
 drivers/gpu/drm/qxl/qxl_display.c                  |   1 +
 drivers/gpu/drm/tiny/gm12u320.c                    |  44 ++++-
 drivers/gpu/drm/udl/udl_drv.c                      |  17 ++
 drivers/gpu/drm/udl/udl_drv.h                      |   1 +
 drivers/gpu/drm/udl/udl_main.c                     |  10 ++
 drivers/hid/hid-logitech-dj.c                      |   7 +-
 drivers/i2c/busses/i2c-rcar.c                      |  13 +-
 drivers/infiniband/core/umem.c                     |   8 +-
 drivers/input/keyboard/applespi.c                  |  21 ++-
 drivers/iommu/amd/init.c                           |  45 +++--
 drivers/iommu/intel/svm.c                          |  13 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   6 +-
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/keymaps/Makefile                  |   1 -
 drivers/media/rc/keymaps/rc-cec.c                  |  28 ++-
 drivers/media/rc/rc-main.c                         |   6 +
 drivers/media/usb/usbtv/usbtv-audio.c              |   2 +-
 drivers/misc/fastrpc.c                             |   5 +
 drivers/misc/pvpanic.c                             |   1 +
 drivers/mmc/core/bus.c                             |  11 +-
 drivers/mmc/core/mmc.c                             |  15 +-
 drivers/mmc/host/mmci.c                            |  10 +-
 drivers/mmc/host/mtk-sd.c                          |  18 +-
 drivers/mmc/host/mxs-mmc.c                         |   2 +-
 drivers/mmc/host/sdhci-iproc.c                     |  18 ++
 drivers/mmc/host/sdhci.c                           |   8 +-
 drivers/net/Kconfig                                |   2 +-
 drivers/net/can/flexcan.c                          |  24 ++-
 drivers/net/can/m_can/tcan4x5x.c                   |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   2 +-
 drivers/net/ethernet/atheros/alx/main.c            |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  14 +-
 drivers/net/ethernet/davicom/dm9000.c              |  21 ++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  93 +++++-----
 drivers/net/ethernet/freescale/enetc/enetc.h       |   5 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |  18 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    | 117 +++++++++---
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |   7 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   7 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  13 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   5 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |   5 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   5 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   1 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   5 +
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |   3 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |   9 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  19 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   4 -
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  19 +-
 drivers/net/netdevsim/netdev.c                     |   1 +
 drivers/net/phy/phy.c                              |   6 +-
 drivers/net/phy/phy_device.c                       |   6 +-
 drivers/net/usb/qmi_wwan.c                         |  14 --
 drivers/net/wan/lapbether.c                        |   3 -
 drivers/net/wireless/ath/ath11k/core.c             |   1 +
 drivers/net/wireless/ath/ath11k/core.h             |   1 +
 drivers/net/wireless/ath/ath11k/mac.c              |  25 ++-
 drivers/net/wireless/ath/ath11k/peer.c             |  61 ++++++-
 drivers/net/wireless/ath/ath11k/peer.h             |   4 +
 drivers/net/wireless/ath/ath11k/wmi.c              |  17 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   6 +
 drivers/net/wireless/mediatek/mt76/dma.c           |  11 +-
 drivers/nvme/host/fc.c                             |   2 +-
 drivers/pci/controller/pci-xgene-msi.c             |  10 +-
 drivers/pci/controller/pcie-mediatek.c             |   7 +-
 drivers/pci/pci.c                                  |   4 +
 drivers/pci/pcie/Kconfig                           |   8 -
 drivers/pci/pcie/Makefile                          |   1 -
 drivers/pci/pcie/bw_notification.c                 | 138 --------------
 drivers/pci/pcie/portdrv.h                         |   6 -
 drivers/pci/pcie/portdrv_pci.c                     |   1 -
 drivers/platform/olpc/olpc-ec.c                    |  15 +-
 drivers/s390/block/dasd.c                          |   6 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   2 +-
 drivers/s390/net/qeth_core.h                       |   5 +-
 drivers/s390/net/qeth_core_main.c                  | 200 ++++++++++-----------
 drivers/scsi/libiscsi.c                            |  11 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |   3 +-
 drivers/scsi/ufs/ufs.h                             |   6 +-
 drivers/scsi/ufs/ufshcd.c                          |   2 +-
 drivers/spi/spi-stm32.c                            |  15 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   4 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |  18 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  10 +-
 drivers/staging/comedi/drivers/das6402.c           |   2 +-
 drivers/staging/comedi/drivers/das800.c            |   2 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   2 +-
 drivers/staging/comedi/drivers/me4000.c            |   2 +-
 drivers/staging/comedi/drivers/pcl711.c            |   2 +-
 drivers/staging/comedi/drivers/pcl818.c            |   2 +-
 drivers/staging/ks7010/ks_wlan_net.c               |   6 +-
 drivers/staging/media/rkisp1/rkisp1-params.c       |   1 -
 drivers/staging/rtl8188eu/core/rtw_ap.c            |   5 +
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   6 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |   7 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |   6 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |   6 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   2 +-
 drivers/target/target_core_pr.c                    |  15 +-
 drivers/target/target_core_transport.c             |  15 +-
 drivers/tty/serial/max310x.c                       |  29 +--
 drivers/usb/class/cdc-acm.c                        |   5 +
 drivers/usb/class/usblp.c                          |  16 +-
 drivers/usb/core/usb.c                             |  32 ++++
 drivers/usb/dwc3/dwc3-qcom.c                       |  77 +++++++-
 drivers/usb/gadget/function/f_uac1.c               |   1 +
 drivers/usb/gadget/function/f_uac2.c               |   2 +-
 drivers/usb/gadget/function/u_ether_configfs.h     |   5 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |   4 +-
 drivers/usb/host/xhci-pci.c                        |  13 +-
 drivers/usb/host/xhci-ring.c                       |   3 +-
 drivers/usb/host/xhci.c                            |  78 ++++----
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/serial/ch341.c                         |   1 +
 drivers/usb/serial/cp210x.c                        |   3 +
 drivers/usb/serial/io_edgeport.c                   |  26 +--
 drivers/usb/usbip/stub_dev.c                       |  42 ++++-
 drivers/usb/usbip/vhci_sysfs.c                     |  39 +++-
 drivers/usb/usbip/vudc_sysfs.c                     |  49 ++++-
 drivers/xen/events/events_2l.c                     |  22 ++-
 drivers/xen/events/events_base.c                   | 140 +++++++++++----
 drivers/xen/events/events_fifo.c                   |   7 -
 drivers/xen/events/events_internal.h               |  14 +-
 fs/binfmt_misc.c                                   |  29 ++-
 fs/block_dev.c                                     |  11 +-
 fs/cifs/cifsfs.c                                   |   2 +-
 fs/cifs/cifsglob.h                                 |  11 +-
 fs/cifs/connect.c                                  |  10 +-
 fs/cifs/sess.c                                     |   1 +
 fs/cifs/smb2inode.c                                |   1 +
 fs/cifs/smb2misc.c                                 |   8 +-
 fs/cifs/smb2ops.c                                  |  10 +-
 fs/cifs/smb2proto.h                                |   3 +-
 fs/cifs/transport.c                                |   2 +-
 fs/configfs/file.c                                 |   6 +-
 fs/ext4/super.c                                    |   9 +-
 fs/nfs/dir.c                                       |  40 +++--
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/pnode.h                                         |   2 +-
 fs/udf/inode.c                                     |   9 +-
 include/linux/acpi.h                               |  10 +-
 include/linux/can/skb.h                            |   8 +-
 include/linux/compiler-clang.h                     |   6 +
 include/linux/entry-common.h                       |  39 +++-
 include/linux/gpio/consumer.h                      |   2 +
 include/linux/memory.h                             |   3 +-
 include/linux/perf_event.h                         |   2 +
 include/linux/pgtable.h                            |   4 +
 include/linux/sched/mm.h                           |   3 +-
 include/linux/seqlock.h                            |   5 +-
 include/linux/stop_machine.h                       |  11 +-
 include/linux/usb.h                                |   2 +
 include/linux/virtio_net.h                         |   7 +-
 include/media/rc-map.h                             |   7 +
 include/target/target_core_backend.h               |   1 +
 include/uapi/linux/l2tp.h                          |   1 +
 include/uapi/linux/netfilter/nfnetlink_cthelper.h  |   2 +-
 kernel/entry/common.c                              |  36 ++++
 kernel/events/core.c                               |  42 ++++-
 kernel/sched/membarrier.c                          |   4 +-
 kernel/sys.c                                       |   2 +-
 kernel/sysctl.c                                    |   8 +-
 kernel/time/hrtimer.c                              |  60 ++++---
 lib/logic_pio.c                                    |   3 +
 lib/test_kasan.c                                   |  10 +-
 mm/madvise.c                                       |  13 +-
 mm/memory.c                                        |   8 +
 mm/memory_hotplug.c                                |   2 +-
 mm/page_alloc.c                                    | 158 ++++++++--------
 mm/slub.c                                          |   2 +-
 net/dsa/slave.c                                    |  45 +++++
 net/dsa/tag_ar9331.c                               |   3 -
 net/dsa/tag_brcm.c                                 |   3 -
 net/dsa/tag_dsa.c                                  |   5 -
 net/dsa/tag_edsa.c                                 |   4 -
 net/dsa/tag_gswip.c                                |   5 -
 net/dsa/tag_ksz.c                                  |  73 +-------
 net/dsa/tag_lan9303.c                              |   9 -
 net/dsa/tag_mtk.c                                  |  22 ++-
 net/dsa/tag_ocelot.c                               |   7 -
 net/dsa/tag_qca.c                                  |   3 -
 net/dsa/tag_rtl4_a.c                               |  12 +-
 net/dsa/tag_trailer.c                              |  31 +---
 net/ethtool/channels.c                             |  26 +--
 net/ipv4/cipso_ipv4.c                              |  11 +-
 net/ipv4/ip_tunnel.c                               |   5 +-
 net/ipv4/ip_vti.c                                  |   6 +-
 net/ipv4/nexthop.c                                 |  10 +-
 net/ipv4/tcp.c                                     |  26 ++-
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/calipso.c                                 |  14 +-
 net/ipv6/ip6_gre.c                                 |  16 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/ipv6/ip6_vti.c                                 |   6 +-
 net/ipv6/sit.c                                     |   2 +-
 net/l2tp/l2tp_core.c                               |  41 +++--
 net/l2tp/l2tp_core.h                               |   1 +
 net/l2tp/l2tp_netlink.c                            |   6 +
 net/mpls/mpls_gso.c                                |   3 +
 net/netfilter/nf_nat_proto.c                       |  25 ++-
 net/netfilter/x_tables.c                           |   6 +-
 net/netlabel/netlabel_cipso_v4.c                   |   3 +
 net/qrtr/qrtr.c                                    |   4 +-
 net/sched/sch_api.c                                |   8 +-
 net/sunrpc/sched.c                                 |   5 +-
 samples/bpf/xdpsock_user.c                         |   2 +
 security/commoncap.c                               |  12 +-
 sound/pci/hda/hda_bind.c                           |   4 +
 sound/pci/hda/hda_controller.c                     |   7 -
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_ca0132.c                       |   1 +
 sound/pci/hda/patch_conexant.c                     |  62 +++++--
 sound/pci/hda/patch_hdmi.c                         |  13 ++
 sound/usb/card.c                                   |   6 +
 sound/usb/quirks.c                                 |  11 +-
 sound/usb/usbaudio.h                               |   1 +
 tools/bpf/resolve_btfids/main.c                    |   5 +
 tools/lib/bpf/xsk.c                                |   5 +-
 tools/perf/Makefile.perf                           |   2 +-
 tools/perf/util/sort.c                             |   4 +-
 tools/perf/util/trace-event-read.c                 |   1 +
 .../selftests/bpf/progs/netif_receive_skb.c        |  13 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   6 +-
 .../testing/selftests/bpf/verifier/array_access.c  |   3 +-
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh    |   9 +
 333 files changed, 3007 insertions(+), 1742 deletions(-)


