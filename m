Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3A31ECE4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfEOLCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfEOLCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77EA821743;
        Wed, 15 May 2019 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918166;
        bh=2xi8VDSYhHBsloL50TYfJeQge+i7egz5yCHUTrwhykQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jSdOMu6JcZJqKYu6oHUSNbvnlGQxzMRr/O4Kwreh8gOVe1aLNdP8hUWacPippZ0ro
         O6LnNbQLHI+n+kD1ceTcgfUCK+xYT0c+Pvbv1odlbPJ2Prz2Rux4GV25iLD7tL5E1y
         MNW9Il25MFL5ZgUiWPl+guJk2YtwWw7t2aATdDkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 000/266] 4.4.180-stable review
Date:   Wed, 15 May 2019 12:51:47 +0200
Message-Id: <20190515090722.696531131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.180-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.180-rc1
X-KernelTest-Deadline: 2019-05-17T09:07+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.180 release.
There are 266 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:49 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.180-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.180-rc1

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/booke64: set RI in default MSR

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

Jarod Wilson <jarod@redhat.com>
    bonding: fix arp_validate toggling in active-backup mode

David Ahern <dsahern@gmail.com>
    ipv4: Fix raw socket lookup for local traffic

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: sit mtu should not be updated when vrf netdev is the link

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

YueHaibing <yuehaibing@huawei.com>
    packet: Fix error path in packet_init

Christophe Leroy <christophe.leroy@c-s.fr>
    net: ucc_geth - fix Oops when changing number of buffers in the ring

Tobin C. Harding <tobin@kernel.org>
    bridge: Fix error path for kobject_init_and_add()

Breno Leitao <leitao@debian.org>
    powerpc/64s: Include cpu header

Johan Hovold <johan@kernel.org>
    USB: serial: fix unthrottle races

Oliver Neukum <oneukum@suse.com>
    USB: serial: use variable for status

Ben Hutchings <ben@decadent.org.uk>
    x86/bugs: Change L1TF mitigation string to match upstream

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation/mds: Fix documentation typo

Tyler Hicks <tyhicks@canonical.com>
    Documentation: Correct the possible MDS sysfs values

speck for Pawan Gupta <speck@linutronix.de>
    x86/mds: Add MDSUM variant to the MDS documentation

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation/mds: Add 'mitigations=' support for MDS

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Support 'mitigations=' cmdline option

Josh Poimboeuf <jpoimboe@redhat.com>
    cpu/speculation: Add 'mitigations=' cmdline option

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations off

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/speculation/mds: Fix comment

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation/mds: Add SMT warning message

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Move arch_smt_update() call to after mitigation decisions

Andi Kleen <ak@linux.intel.com>
    x86/cpu/bugs: Use __initconst for 'const' init data

Thomas Gleixner <tglx@linutronix.de>
    Documentation: Add MDS vulnerability documentation

Thomas Gleixner <tglx@linutronix.de>
    Documentation: Move L1TF to separate directory

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Add mitigation mode VMWERV

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Add sysfs reporting for MDS

Ben Hutchings <ben@decadent.org.uk>
    x86/speculation/l1tf: Document l1tf in sysfs

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Add mitigation control for MDS

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Conditionally clear CPU buffers on idle entry

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Clear CPU buffers on exit to user

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Add mds_clear_cpu_buffers()

Andi Kleen <ak@linux.intel.com>
    x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Add BUG_MSBDS_ONLY

Andi Kleen <ak@linux.intel.com>
    x86/speculation/mds: Add basic bug infrastructure for MDS

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Consolidate CPU whitelists

Thomas Gleixner <tglx@linutronix.de>
    x86/msr-index: Cleanup bit defines

Eduardo Habkost <ehabkost@redhat.com>
    kvm: x86: Report STIBP on GET_SUPPORTED_CPUID

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Provide IBPB always command line options

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Add seccomp Spectre v2 user space protection mode

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Enable prctl mode for spectre_v2_user

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Add prctl() control for indirect branch speculation

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Prevent stale SPEC_CTRL msr content

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Prepare arch_smt_update() for PRCTL mode

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Split out TIF update

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Prepare for conditional IBPB in switch_mm()

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Avoid __switch_to_xtra() calls

Thomas Gleixner <tglx@linutronix.de>
    x86/process: Consolidate and simplify switch_to_xtra() code

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Prepare for per task indirect branch speculation control

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Add command line control for indirect branch speculation

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Unify conditional spectre v2 print functions

Thomas Gleixner <tglx@linutronix.de>
    x86/speculataion: Mark command line parser data __initdata

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Mark string arrays const correctly

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Reorder the spec_v2 code

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Rework SMT state change

Ben Hutchings <ben@decadent.org.uk>
    sched: Add sched_smt_active()

Thomas Gleixner <tglx@linutronix.de>
    x86/Kconfig: Select SCHED_SMT if SMP enabled

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Reorganize speculation control MSRs update

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation: Rename SSBD update functions

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Disable STIBP when enhanced IBRS is in use

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Move STIPB/IBPB string conditionals out of cpu_show_common()

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Remove unnecessary ret variable in cpu_show_common()

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Clean up spectre_v2_parse_cmdline()

Tim Chen <tim.c.chen@linux.intel.com>
    x86/speculation: Update the TIF_SSBD comment

Jiri Kosina <jkosina@suse.cz>
    x86/speculation: Propagate information about RSB filling mitigation to sysfs

Jiri Kosina <jkosina@suse.cz>
    x86/speculation: Enable cross-hyperthread spectre v2 STIBP mitigation

Jiri Kosina <jkosina@suse.cz>
    x86/speculation: Apply IBPB more strictly to avoid cross-process data leak

Nadav Amit <namit@vmware.com>
    x86/mm: Use WRITE_ONCE() when setting PTEs

Thomas Gleixner <tglx@xxxxxxxxxxxxx>
    KVM: x86: SVM: Call x86_spec_ctrl_set_guest/host() with interrupts disabled

Peter Zijlstra <peterz@infradead.org>
    x86/cpu: Sanitize FAM6_ATOM naming

Filippo Sironi <sironi@amazon.de>
    x86/microcode: Update the new microcode revision unconditionally

Prarit Bhargava <prarit@redhat.com>
    x86/microcode: Make sure boot_cpu_data.microcode is up-to-date

Jiang Biao <jiang.biao2@zte.com.cn>
    x86/speculation: Remove SPECTRE_V2_IBRS in enum spectre_v2_mitigation

Tom Lendacky <thomas.lendacky@amd.com>
    x86/bugs: Fix the AMD SSBD usage of the SPEC_CTRL MSR

Will Deacon <will.deacon@arm.com>
    locking/atomics, asm-generic: Move some macros from <linux/bitops.h> to a new <linux/bits.h> file

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/bugs: Switch the selection of mitigation from CPU vendor to CPU features

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/bugs: Add AMD's SPEC_CTRL MSR usage

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/bugs: Add AMD's variant of SSB_NO

Dominik Brodowski <linux@dominikbrodowski.net>
    x86/speculation: Simplify the CPU bug detection logic

Sai Praneeth <sai.praneeth.prakhya@intel.com>
    x86/speculation: Support Enhanced IBRS on future CPUs

Ben Hutchings <ben@decadent.org.uk>
    x86/cpufeatures: Hide AMD-specific speculation flags

Tony Luck <tony.luck@intel.com>
    x86/MCE: Save microcode revision in machine check records

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Check microcode revision before updating sibling threads

Matthias Kaehlcke <mka@chromium.org>
    bitops: avoid integer overflow in GENMASK(_ULL)

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    x86: stop exporting msr-index.h to userland

Borislav Petkov <bp@suse.de>
    x86/microcode/intel: Add a helper which gives the microcode revision

Tony Luck <tony.luck@intel.com>
    locking/static_keys: Provide DECLARE and well as DEFINE macros

Nigel Croxon <ncroxon@redhat.com>
    Don't jump to compute_result state from check_result state

Alistair Strachan <astrachan@google.com>
    x86/vdso: Pass --eh-frame-hdr to the linker

Wei Yongjun <weiyongjun1@huawei.com>
    cw1200: fix missing unlock on error in cw1200_hw_scan()

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: dp: fix CSC handling

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_netsocktests

Arnd Bergmann <arnd@arndb.de>
    s390: ctcm: fix ctcm_new_device error return code

Julian Anastasov <ja@ssi.bg>
    ipvs: do not schedule icmp errors from tunnels

Dan Williams <dan.j.williams@intel.com>
    init: initialize jump labels before command line option parsing

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    tools lib traceevent: Fix missing equality check for strcmp

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix lockdep false positive on view->lock

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/dasd: Fix capacity calculation for large volumes

Aditya Pakki <pakki001@umn.edu>
    libnvdimm/btt: Fix a kmemdup failure check

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for Expose/Overview key

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: fix potential use-after-free on remove

Gustavo A. R. Silva <gustavo@embeddedor.com>
    platform/x86: sony-laptop: Fix unintentional fall-through

Michal Hocko <mhocko@suse.com>
    mm, vmstat: make quiet_vmstat lighter

Francesco Ruggeri <fruggeri@arista.com>
    netfilter: compat: initialize all fields in xt_init

Ben Hutchings <ben@decadent.org.uk>
    timer/debug: Change /proc/timer_stats from 0644 to 0600

Ross Zwisler <zwisler@chromium.org>
    ASoC: Intel: avoid Oops if DMA setup fails

WANG Cong <xiyou.wangcong@gmail.com>
    ipv6: fix a potential deadlock in do_ipv6_setsockopt()

Oliver Neukum <oneukum@suse.com>
    UAS: fix alignment of scatter/gather segments

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Young Xiao <YangX92@hotmail.com>
    Bluetooth: hidp: fix buffer overflow

Andrew Vasquez <andrewv@marvell.com>
    scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Fix default lpm_nyet_threshold value

Prasad Sodagudi <psodagud@codeaurora.org>
    genirq: Prevent use-after-free and work list corruption

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Set exclusion range correctly

Varun Prakash <varun@chelsio.com>
    scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Stephane Eranian <eranian@google.com>
    perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Annaliese McDermond <nh6z@nh6z.net>
    ASoC: tlv320aic32x4: Fix Common Pins

Daniel Mack <daniel@zonque.org>
    ASoC: cs4270: Set auto-increment bit for register writes

Rander Wang <rander.wang@linux.intel.com>
    ASoC:soc-pcm:fix a codec fixup issue in TDM case

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: fix a race condition when smp task timeout

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: v4l2: i2c: ov7670: Fix PLL bypass register values

Tony Luck <tony.luck@intel.com>
    x86/mce: Improve error message when kernel cannot recover, p2

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: never allow relabeling on context mounts

Anson Huang <anson.huang@nxp.com>
    Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac write calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac read calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: allow adt751x to use internal vref for all dacs

Malte Leip <malte@leip.net>
    usb: usbip: fix isoc packet num validation in get_pipe

Arnd Bergmann <arnd@arndb.de>
    ARM: iop: don't use using 64-bit DMA masks

Arnd Bergmann <arnd@arndb.de>
    ARM: orion: don't use using 64-bit DMA masks

Guenter Roeck <linux@roeck-us.net>
    xsysace: Fix error handling in ace_setup

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix memory leak for resv_map

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Use NAPI_POLL_WEIGHT for hns driver

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix calculation of sub-channel count

Louis Taylor <louis@kragniz.eu>
    vfio/pci: use correct format characters

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: da9063: set uie_unsupported when relevant

Al Viro <viro@zeniv.linux.org.uk>
    debugfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    jffs2: fix use-after-free on symlink traversal

Konstantin Khorenko <khorenko@virtuozzo.com>
    bonding: show full hw address in sysfs for slave entries

Arvind Sankar <niveditas98@gmail.com>
    igb: Fix WARN_ONCE on runtime suspend

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: sh: Fix invalid alarm warning for non-enabled alarm

He, Bo <bo.he@intel.com>
    HID: debug: fix race condition with between rdesc_show() and device removal

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug caused by duplicate interface PM usage counter

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix unterminated string returned by usb_string()

Alan Stern <stern@rowland.harvard.edu>
    USB: w1 ds2490: Fix bug caused by improper use of altsetting array

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix protection fault after device removal

Willem de Bruijn <willemb@google.com>
    packet: validate msg_namelen in send directly

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve multicast address setup logic.

Willem de Bruijn <willemb@google.com>
    ipv6: invert flowlabel sharing check in process and user mode

Eric Dumazet <edumazet@google.com>
    ipv6/flowlabel: wait rcu grace period before put_pid()

Shmulik Ladkani <shmulik@metanetworks.com>
    ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: line6: use dynamic buffers

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Limit DMA mappings per container

Changbin Du <changbin.du@gmail.com>
    kconfig/[mn]conf: handle backspace (^H) key

raymond pang <raymondpangxd@gmail.com>
    libata: fix using DMA buffers on stack

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN

Al Viro <viro@zeniv.linux.org.uk>
    ceph: fix use-after-free on symlink traversal

Mukesh Ojha <mojha@codeaurora.org>
    usb: u132-hcd: fix resource leak

Kangjie Lu <kjlu@umn.edu>
    scsi: qla4xxx: fix a potential NULL pointer dereference

Wen Yang <wen.yang99@zte.com.cn>
    net: ethernet: ti: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    net: ibm: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    net: xilinx: fix possible object reference leak

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Set initial carrier state to down

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Delay requesting IRQ until opened

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Reassert reset pin if chip ID check fails

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Dequeue RX packets explicitly

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: pfla02: increase phy reset duration

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2272: Fix net2272_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix net2280_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix overrun of OUT messages

Mao Wenan <maowenan@huawei.com>
    sc16is7xx: missing unregister/delete driver on error in sc16is7xx_init()

Xin Long <lucien.xin@gmail.com>
    netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING

Aditya Pakki <pakki001@umn.edu>
    qlcnic: Avoid potential NULL pointer dereference

Gustavo A. R. Silva <garsilva@embeddedor.com>
    usbnet: ipheth: fix potential null pointer dereference in ipheth_carrier_set

Alexander Kappner <agk@godking.net>
    usbnet: ipheth: prevent TX queue timeouts when device not ready

Diana Craciun <diana.craciun@nxp.com>
    Documentation: Add nospectre_v1 parameter

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2 boot arg

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Fixed warning: orphan section `__btb_flush_fixup'

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Sanitize the syscall table for NXP PowerPC 32 bit platforms

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Flush the branch predictor at each kernel entry (32 bit)

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Emulate SPRN_BUCSR register

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Flush branch predictor when entering KVM

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Enable runtime patching if nospectre_v2 boot arg is used

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Vinod Koul <vkoul@kernel.org>
    net: stmmac: move stmmac_check_ether_addr() to driver probe

Hangbin Liu <liuhangbin@gmail.com>
    team: fix possible recursive locking when add slaves

Eric Dumazet <edumazet@google.com>
    ipv4: add sanity checks in ipv4_link_failure()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "block/loop: Use global lock for ioctl() operation."

Daniel Borkmann <daniel@iogearbox.net>
    bpf: reject wrong sized filters earlier

Xin Long <lucien.xin@gmail.com>
    tipc: check link name with right length in tipc_nl_compat_link_set

Xin Long <lucien.xin@gmail.com>
    tipc: check bearer name with right length in tipc_nl_compat_bearer_enable

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

YueHaibing <yuehaibing@huawei.com>
    fs/proc/proc_sysctl.c: Fix a NULL pointer dereference

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: gth: Fix an off-by-one in output unassigning

Linus Torvalds <torvalds@linux-foundation.org>
    slip: make slhc_free() silently accept an error pointer

Xin Long <lucien.xin@gmail.com>
    tipc: handle the err returned from cmd header function

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/fsl: Fix the flush of branch predictor.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/security: Fix spectre_v2 reporting

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Update Spectre v2 reporting

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Flush the branch predictor at each kernel entry (64bit)

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Add nospectre_v2 command line argument

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Fix spectre_v2 mitigations reporting

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Add macro to flush the branch predictor

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Add infrastructure to fixup branch predictor flush

Michael Neuling <mikey@neuling.org>
    powerpc: Avoid code patching freed init sections

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Query firmware for count cache flush settings

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Query hypervisor for count cache flush settings

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Add support for software count cache flush

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Add new security feature flags for count cache flush

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/asm: Add a patch_site macro & helpers for patching instructions

Diana Craciun <diana.craciun@nxp.com>
    powerpc/fsl: Add barrier_nospec implementation for NXP PowerPC Book3E

Diana Craciun <diana.craciun@nxp.com>
    powerpc/64: Make meltdown reporting Book3S 64 specific

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Call setup_barrier_nospec() from setup_arch()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Add CONFIG_PPC_BARRIER_NOSPEC

Diana Craciun <diana.craciun@nxp.com>
    powerpc/64: Make stf barrier PPC_BOOK3S_64 specific.

Diana Craciun <diana.craciun@nxp.com>
    powerpc/64: Disable the speculation barrier from the command line

Michael Ellerman <mpe@ellerman.id.au>
    powerpc64s: Show ori31 availability in spectre_v1 sysfs file not v2

Michal Suchanek <msuchanek@suse.de>
    powerpc/64s: Enhance the information in cpu_show_spectre_v1()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Use barrier_nospec in copy_from_user()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Use barrier_nospec in syscall entry

Michal Suchanek <msuchanek@suse.de>
    powerpc/64s: Enable barrier_nospec based on firmware settings

Michal Suchanek <msuchanek@suse.de>
    powerpc/64s: Patch barrier_nospec in modules

Michal Suchanek <msuchanek@suse.de>
    powerpc/64s: Add support for ori barrier_nospec patching

Michal Suchanek <msuchanek@suse.de>
    powerpc/64s: Add barrier_nospec

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Add support for a store forwarding barrier at kernel entry/exit

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Fix section mismatch warnings from setup_rfi_flush()

Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
    powerpc/pseries: Restore default security feature flags on setup

Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
    powerpc: Move default security feature flags

Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
    powerpc/pseries: Fix clearing of security feature flags

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Wire up cpu_show_spectre_v2()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Wire up cpu_show_spectre_v1()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Use the security flags in pseries_setup_rfi_flush()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Use the security flags in pnv_setup_rfi_flush()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Enhance the information in cpu_show_meltdown()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Move cpu_show_meltdown()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Set or clear security feature flags

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Set or clear security feature flags

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Add security feature flags for Spectre/Meltdown

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/rfi-flush: Call setup_rfi_flush() after LPM migration

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Add new H_GET_CPU_CHARACTERISTICS flags

Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
    powerpc/rfi-flush: Differentiate enabled and patched flush types

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/rfi-flush: Always enable fallback flush on pseries

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/rfi-flush: Make it possible to call setup_rfi_flush() again

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/rfi-flush: Move the logic to avoid a redo into the debugfs code

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Support firmware disable of RFI flush

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Support firmware disable of RFI flush

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Improve RFI L1-D cache flush fallback

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Add RFI flush related fields to paca dump

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Consolidate LPM checks to avoid enabling LPM twice

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Add new USB LPM helpers

NeilBrown <neilb@suse.com>
    sunrpc: don't mark uninitialised items as VALID.

Trond Myklebust <trondmy@gmail.com>
    nfsd: Don't release the callback slot unless it was actually held

Yan, Zheng <zyan@redhat.com>
    ceph: fix ci->i_head_snapc leak

Jeff Layton <jlayton@kernel.org>
    ceph: ensure d_name stability in ceph_dentry_hash()

Xie XiuQi <xiexiuqi@huawei.com>
    sched/numa: Fix a possible divide-by-zero

Peter Zijlstra <peterz@infradead.org>
    trace: Fix preempt_enable_no_resched() abuse

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: scall64-o32: Fix indirect syscall number load

Frank Sorenson <sorenson@redhat.com>
    cifs: do not attempt cifs operation on smb2+ rename error

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fail KVM_SET_VCPU_EVENTS with invalid exception number

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: simplify ld-option implementation


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/mds.rst                      | 305 ++++++++++
 Documentation/kernel-parameters.txt                | 110 +++-
 Documentation/networking/ip-sysctl.txt             |   1 +
 Documentation/spec_ctrl.txt                        |   9 +
 Documentation/usb/power-management.txt             |  14 +-
 Documentation/x86/mds.rst                          | 225 +++++++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |   1 +
 arch/arm/mach-iop13xx/setup.c                      |   8 +-
 arch/arm/mach-iop13xx/tpmi.c                       |  10 +-
 arch/arm/plat-iop/adma.c                           |   6 +-
 arch/arm/plat-orion/common.c                       |   4 +-
 arch/mips/kernel/scall64-o32.S                     |   2 +-
 arch/powerpc/Kconfig                               |   7 +-
 arch/powerpc/include/asm/asm-prototypes.h          |  21 +
 arch/powerpc/include/asm/barrier.h                 |  21 +
 arch/powerpc/include/asm/code-patching-asm.h       |  18 +
 arch/powerpc/include/asm/code-patching.h           |   2 +
 arch/powerpc/include/asm/exception-64s.h           |  35 ++
 arch/powerpc/include/asm/feature-fixups.h          |  40 ++
 arch/powerpc/include/asm/hvcall.h                  |   5 +
 arch/powerpc/include/asm/paca.h                    |   3 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   1 +
 arch/powerpc/include/asm/ppc_asm.h                 |  11 +
 arch/powerpc/include/asm/reg_booke.h               |   2 +-
 arch/powerpc/include/asm/security_features.h       |  92 +++
 arch/powerpc/include/asm/setup.h                   |  23 +-
 arch/powerpc/include/asm/uaccess.h                 |  18 +-
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/powerpc/kernel/asm-offsets.c                  |   3 +-
 arch/powerpc/kernel/entry_32.S                     |  10 +
 arch/powerpc/kernel/entry_64.S                     |  69 +++
 arch/powerpc/kernel/exceptions-64e.S               |  27 +-
 arch/powerpc/kernel/exceptions-64s.S               |  98 ++--
 arch/powerpc/kernel/head_booke.h                   |  12 +
 arch/powerpc/kernel/head_fsl_booke.S               |  15 +
 arch/powerpc/kernel/module.c                       |  10 +-
 arch/powerpc/kernel/security.c                     | 434 ++++++++++++++
 arch/powerpc/kernel/setup_32.c                     |   3 +
 arch/powerpc/kernel/setup_64.c                     |  51 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |  33 +-
 arch/powerpc/kvm/bookehv_interrupts.S              |   4 +
 arch/powerpc/kvm/e500_emulate.c                    |   7 +
 arch/powerpc/lib/code-patching.c                   |  29 +
 arch/powerpc/lib/feature-fixups.c                  | 218 ++++++-
 arch/powerpc/mm/mem.c                              |   2 +
 arch/powerpc/mm/tlb_low_64e.S                      |   7 +
 arch/powerpc/platforms/powernv/setup.c             |  99 +++-
 arch/powerpc/platforms/pseries/mobility.c          |   3 +
 arch/powerpc/platforms/pseries/pseries.h           |   2 +
 arch/powerpc/platforms/pseries/setup.c             |  88 ++-
 arch/powerpc/xmon/xmon.c                           |   2 +
 arch/x86/Kconfig                                   |   8 +-
 arch/x86/entry/common.c                            |   3 +
 arch/x86/entry/vdso/Makefile                       |   3 +-
 arch/x86/include/asm/cpufeatures.h                 |  12 +-
 arch/x86/include/asm/intel-family.h                |  30 +-
 arch/x86/include/asm/irqflags.h                    |   5 +
 arch/x86/include/asm/microcode_intel.h             |  15 +
 arch/x86/include/asm/msr-index.h                   |  30 +-
 arch/x86/include/asm/mwait.h                       |   7 +
 arch/x86/include/asm/nospec-branch.h               |  66 ++-
 arch/x86/include/asm/pgtable_64.h                  |  16 +-
 arch/x86/include/asm/processor.h                   |   7 +
 arch/x86/include/asm/spec-ctrl.h                   |  20 +-
 arch/x86/include/asm/switch_to.h                   |   3 -
 arch/x86/include/asm/thread_info.h                 |  20 +-
 arch/x86/include/asm/tlbflush.h                    |   8 +-
 arch/x86/include/uapi/asm/Kbuild                   |   1 -
 arch/x86/include/uapi/asm/mce.h                    |   4 +
 arch/x86/kernel/cpu/bugs.c                         | 643 +++++++++++++++++----
 arch/x86/kernel/cpu/common.c                       | 140 +++--
 arch/x86/kernel/cpu/intel.c                        |  11 +-
 arch/x86/kernel/cpu/mcheck/mce-severity.c          |   5 +
 arch/x86/kernel/cpu/mcheck/mce.c                   |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  22 +-
 arch/x86/kernel/cpu/microcode/intel.c              |  64 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   2 +-
 arch/x86/kernel/nmi.c                              |   4 +
 arch/x86/kernel/process.c                          | 101 +++-
 arch/x86/kernel/process.h                          |  39 ++
 arch/x86/kernel/process_32.c                       |   9 +-
 arch/x86/kernel/process_64.c                       |   9 +-
 arch/x86/kernel/traps.c                            |   8 +
 arch/x86/kvm/cpuid.c                               |  13 +-
 arch/x86/kvm/cpuid.h                               |   2 +-
 arch/x86/kvm/svm.c                                 |  10 +-
 arch/x86/kvm/trace.h                               |   4 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/mm/kaiser.c                               |   4 +-
 arch/x86/mm/pgtable.c                              |   6 +-
 arch/x86/mm/tlb.c                                  | 114 +++-
 drivers/ata/libata-zpodd.c                         |  34 +-
 drivers/base/cpu.c                                 |   8 +
 drivers/block/loop.c                               |  42 +-
 drivers/block/loop.h                               |   1 +
 drivers/block/xsysace.c                            |   2 +
 drivers/gpu/ipu-v3/ipu-dp.c                        |  12 +-
 drivers/hid/hid-debug.c                            |   5 +
 drivers/hid/hid-input.c                            |   6 +
 drivers/hwtracing/intel_th/gth.c                   |   2 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |   2 +-
 drivers/input/keyboard/snvs_pwrkey.c               |   6 +-
 drivers/iommu/amd_iommu_init.c                     |   2 +-
 drivers/md/raid5.c                                 |  19 +-
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/net/bonding/bond_options.c                 |   7 -
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   9 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |   8 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   7 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  57 +-
 drivers/net/ethernet/micrel/ks8851.c               |  36 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/ethernet/ti/netcp_ethss.c              |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +
 drivers/net/slip/slhc.c                            |   2 +-
 drivers/net/team/team.c                            |   6 +
 drivers/net/usb/ipheth.c                           |  33 +-
 drivers/net/wireless/cw1200/scan.c                 |   5 +-
 drivers/nvdimm/btt_devs.c                          |  18 +-
 drivers/platform/x86/sony-laptop.c                 |   8 +-
 drivers/rtc/rtc-da9063.c                           |   7 +
 drivers/rtc/rtc-sh.c                               |   2 +-
 drivers/s390/block/dasd_eckd.c                     |   6 +-
 drivers/s390/char/con3270.c                        |   2 +-
 drivers/s390/char/fs3270.c                         |   3 +-
 drivers/s390/char/raw3270.c                        |   3 +-
 drivers/s390/char/raw3270.h                        |   4 +-
 drivers/s390/char/tty3270.c                        |   3 +-
 drivers/s390/net/ctcm_main.c                       |   1 +
 drivers/s390/scsi/zfcp_fc.c                        |  21 +-
 drivers/scsi/csiostor/csio_scsi.c                  |   5 +-
 drivers/scsi/libsas/sas_expander.c                 |   9 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/storvsc_drv.c                         |  13 +-
 drivers/staging/iio/addac/adt7316.c                |  22 +-
 drivers/tty/serial/sc16is7xx.c                     |  12 +-
 drivers/usb/core/driver.c                          |  36 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/message.c                         |   7 +-
 drivers/usb/core/sysfs.c                           |   5 +-
 drivers/usb/core/usb.h                             |  10 +-
 drivers/usb/dwc3/core.c                            |   2 +-
 drivers/usb/gadget/udc/net2272.c                   |   1 +
 drivers/usb/gadget/udc/net2280.c                   |   8 +-
 drivers/usb/host/u132-hcd.c                        |   3 +
 drivers/usb/misc/yurex.c                           |   1 +
 drivers/usb/serial/generic.c                       |  57 +-
 drivers/usb/storage/realtek_cr.c                   |  13 +-
 drivers/usb/storage/uas.c                          |  38 +-
 drivers/usb/usbip/stub_rx.c                        |  18 +-
 drivers/usb/usbip/usbip_common.h                   |   7 +
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 drivers/vfio/vfio_iommu_type1.c                    |  14 +
 drivers/virt/fsl_hypervisor.c                      |  29 +-
 drivers/w1/masters/ds2490.c                        |   6 +-
 fs/ceph/dir.c                                      |   6 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/ceph/mds_client.c                               |   9 +
 fs/ceph/snap.c                                     |   7 +-
 fs/cifs/inode.c                                    |   4 +
 fs/debugfs/inode.c                                 |  13 +-
 fs/hugetlbfs/inode.c                               |  20 +-
 fs/jffs2/readinode.c                               |   5 -
 fs/jffs2/super.c                                   |   5 +-
 fs/nfs/super.c                                     |   3 +-
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/state.h                                    |   1 +
 fs/proc/proc_sysctl.c                              |   6 +-
 include/linux/bitops.h                             |  21 +-
 include/linux/bits.h                               |  26 +
 include/linux/cpu.h                                |  19 +
 include/linux/jump_label.h                         |   6 +
 include/linux/ptrace.h                             |  21 +-
 include/linux/sched.h                              |   9 +
 include/linux/sched/smt.h                          |  20 +
 include/linux/usb.h                                |   2 -
 include/net/addrconf.h                             |   1 +
 include/net/bluetooth/hci_core.h                   |   3 +
 include/uapi/linux/prctl.h                         |   1 +
 init/main.c                                        |   4 +-
 kernel/cpu.c                                       |  23 +-
 kernel/irq/manage.c                                |   4 +-
 kernel/ptrace.c                                    |  10 +
 kernel/sched/core.c                                |  24 +
 kernel/sched/fair.c                                |   4 +
 kernel/sched/sched.h                               |   1 +
 kernel/time/timer_stats.c                          |   2 +-
 kernel/trace/ring_buffer.c                         |   2 +-
 mm/vmstat.c                                        |  68 ++-
 net/8021q/vlan_dev.c                               |   4 +-
 net/bluetooth/hci_conn.c                           |   8 +
 net/bluetooth/hidp/sock.c                          |   1 +
 net/bridge/br_if.c                                 |  13 +-
 net/bridge/br_netfilter_hooks.c                    |   1 +
 net/bridge/br_netfilter_ipv6.c                     |   2 +
 net/bridge/netfilter/ebtables.c                    |   3 +-
 net/core/filter.c                                  |  23 +-
 net/ipv4/ip_output.c                               |   1 +
 net/ipv4/raw.c                                     |   4 +-
 net/ipv4/route.c                                   |  32 +-
 net/ipv4/sysctl_net_ipv4.c                         |   5 +-
 net/ipv6/ip6_flowlabel.c                           |  22 +-
 net/ipv6/ipv6_sockglue.c                           |   3 +-
 net/ipv6/mcast.c                                   |  17 +-
 net/ipv6/sit.c                                     |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/x_tables.c                           |   2 +-
 net/packet/af_packet.c                             |  48 +-
 net/sunrpc/cache.c                                 |   3 +
 net/tipc/netlink_compat.c                          |  24 +-
 scripts/Kbuild.include                             |   4 +-
 scripts/kconfig/lxdialog/inputbox.c                |   3 +-
 scripts/kconfig/nconf.c                            |   2 +-
 scripts/kconfig/nconf.gui.c                        |   3 +-
 security/selinux/hooks.c                           |  40 +-
 sound/soc/codecs/cs4270.c                          |   1 +
 sound/soc/codecs/tlv320aic32x4.c                   |   2 +
 sound/soc/intel/common/sst-dsp.c                   |   8 +-
 sound/soc/soc-pcm.c                                |   7 +-
 sound/usb/line6/driver.c                           |  60 +-
 sound/usb/line6/toneport.c                         |  24 +-
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/power/x86/turbostat/Makefile                 |   2 +-
 tools/testing/selftests/net/run_netsocktests       |   2 +-
 232 files changed, 4217 insertions(+), 1000 deletions(-)


