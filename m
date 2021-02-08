Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1789313641
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBHPIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:08:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhBHPGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B349B64EDE;
        Mon,  8 Feb 2021 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796689;
        bh=D2iaUTmR4dn+fvOOvuid64TM/WBbuMRpbXA1U+GGuyg=;
        h=From:To:Cc:Subject:Date:From;
        b=S0YYgWF7gJ5P0DEy+6ODaz6JDG9VV634h3XAkFVv2Jl3V8HpVPOrOIoTgT4gDEDcT
         zpdr/yzDAIaOYdAlRKmxHkAGZLcPPDwr2erwiOTILbViWJdIpHT3sdPvkECPirgIFk
         xl8sLSsoj0YmNsZ2t/WvZG7PxUG0/pAuykrI/sJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/43] 4.9.257-rc1 review
Date:   Mon,  8 Feb 2021 16:00:26 +0100
Message-Id: <20210208145806.281758651@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.257-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.257-rc1
X-KernelTest-Deadline: 2021-02-10T14:58+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.257 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.257-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.257-rc1

Shih-Yuan Lee (FourDollars) <sylee@canonical.com>
    ALSA: hda/realtek - Fix typo of pincfg for Dell quirk

Nadav Amit <namit@vmware.com>
    iommu/vt-d: Do not use flush-queue when caching-mode is on

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: thermal: Do not call acpi_thermal_check() directly

Benjamin Valentin <benpicco@googlemail.com>
    Input: xpad - sync supported devices with fork on GitHub

Dave Hansen <dave.hansen@linux.intel.com>
    x86/apic: Add extra serialization for non-serializing MSRs

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/build: Disable CET instrumentation in the kernel

Hugh Dickins <hughd@google.com>
    mm: thp: fix MADV_REMOVE deadlock on shmem THP

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix a race between isolating and freeing page

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix dc21285 PCI configuration accessors

Fengnan Chang <fengnanchang@gmail.com>
    mmc: core: Limit retries when analyse of SDIO tuples fails

Aurelien Aptel <aaptel@suse.com>
    cifs: report error instead of invalid when revalidating a dentry fails

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix bounce buffer usage for non-sg list case

Wang ShaoBo <bobo.shaobowang@huawei.com>
    kretprobe: Avoid re-registration of the same kretprobe earlier

Felix Fietkau <nbd@nbd.name>
    mac80211: fix station rate table updates on assoc

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    usb: dwc2: Fix endpoint direction check in ep_from_windex

Jeremy Figgins <kernel@jeremyfiggins.com>
    USB: usblp: don't call usb_set_interface if there's a single alt

Dan Carpenter <dan.carpenter@oracle.com>
    USB: gadget: legacy: fix an error code in eth_bind()

Arnd Bergmann <arnd@arndb.de>
    elfcore: fix building with clang

Xie He <xie.he.0141@gmail.com>
    net: lapb: Copy the skb before sending a packet

Alexey Dobriyan <adobriyan@gmail.com>
    Input: i8042 - unbreak Pegatron C15B

Christoph Schemmel <christoph.schemmel@gmail.com>
    USB: serial: option: Adding support for Cinterion MV31

Chenxin Jin <bg4akv@hotmail.com>
    USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Pho Tran <Pho.Tran@silabs.com>
    USB: serial: cp210x: add pid/vid for WSDA-200-USB

Sasha Levin <sashal@kernel.org>
    stable: clamp SUBLEVEL in 4.4 and 4.9

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't fail on missing symbol table

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Set default timeout to avoid crash during migration

Felix Fietkau <nbd@nbd.name>
    mac80211: fix fast-rx encryption check

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Avoid invoking response handler twice if ep is already completed

Thomas Gleixner <tglx@linutronix.de>
    futex: Handle faults correctly for PI futexes

Thomas Gleixner <tglx@linutronix.de>
    futex: Simplify fixup_pi_state_owner()

Thomas Gleixner <tglx@linutronix.de>
    futex: Use pi_state_update_owner() in put_pi_state()

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Remove unused argument from rt_mutex_proxy_unlock()

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide and use pi_state_update_owner()

Thomas Gleixner <tglx@linutronix.de>
    futex: Replace pointless printk in fixup_owner()

Peter Zijlstra <peterz@infradead.org>
    futex: Avoid violating the 10th rule of futex

Peter Zijlstra <peterz@infradead.org>
    futex: Rework inconsistent rt_mutex/futex_q state

Peter Zijlstra <peterz@infradead.org>
    futex: Remove rt_mutex_deadlock_account_*()

Peter Zijlstra <peterz@infradead.org>
    futex,rt_mutex: Provide futex specific rt_mutex API

Eric Dumazet <edumazet@google.com>
    net_sched: reject silly cell_log in qdisc_get_rtab()

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: Ensure that CRQ entry read are correctly ordered

Pan Bian <bianpan2016@163.com>
    net: dsa: bcm_sf2: put device node before return


-------------

Diffstat:

 Makefile                              |  12 +-
 arch/arm/mach-footbridge/dc21285.c    |  12 +-
 arch/x86/Makefile                     |   3 +
 arch/x86/include/asm/apic.h           |  10 --
 arch/x86/include/asm/barrier.h        |  18 +++
 arch/x86/kernel/apic/apic.c           |   4 +
 arch/x86/kernel/apic/x2apic_cluster.c |   6 +-
 arch/x86/kernel/apic/x2apic_phys.c    |   6 +-
 drivers/acpi/thermal.c                |  55 ++++---
 drivers/input/joystick/xpad.c         |  17 ++-
 drivers/input/serio/i8042-x86ia64io.h |   2 +
 drivers/iommu/intel-iommu.c           |   6 +
 drivers/mmc/core/sdio_cis.c           |   6 +
 drivers/net/dsa/bcm_sf2.c             |   8 +-
 drivers/net/ethernet/ibm/ibmvnic.c    |   6 +
 drivers/scsi/ibmvscsi/ibmvfc.c        |   4 +-
 drivers/scsi/libfc/fc_exch.c          |  16 +-
 drivers/usb/class/usblp.c             |  19 ++-
 drivers/usb/dwc2/gadget.c             |   8 +-
 drivers/usb/gadget/legacy/ether.c     |   4 +-
 drivers/usb/host/xhci-ring.c          |  31 ++--
 drivers/usb/serial/cp210x.c           |   2 +
 drivers/usb/serial/option.c           |   6 +
 fs/cifs/dir.c                         |  22 ++-
 fs/hugetlbfs/inode.c                  |   3 +-
 include/linux/elfcore.h               |  22 +++
 include/linux/hugetlb.h               |   3 +
 kernel/Makefile                       |   1 -
 kernel/elfcore.c                      |  25 ---
 kernel/futex.c                        | 276 +++++++++++++++++++---------------
 kernel/kprobes.c                      |   4 +
 kernel/locking/rtmutex-debug.c        |   9 --
 kernel/locking/rtmutex-debug.h        |   3 -
 kernel/locking/rtmutex.c              | 127 ++++++++++------
 kernel/locking/rtmutex.h              |   2 -
 kernel/locking/rtmutex_common.h       |  12 +-
 mm/huge_memory.c                      |  37 +++--
 mm/hugetlb.c                          |   9 +-
 net/lapb/lapb_out.c                   |   3 +-
 net/mac80211/driver-ops.c             |   5 +-
 net/mac80211/rate.c                   |   3 +-
 net/mac80211/rx.c                     |   2 +
 net/sched/sch_api.c                   |   3 +-
 sound/pci/hda/patch_realtek.c         |   2 +-
 tools/objtool/elf.c                   |   7 +-
 45 files changed, 521 insertions(+), 320 deletions(-)


