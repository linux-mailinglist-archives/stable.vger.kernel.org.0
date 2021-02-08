Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAD13135F7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhBHPD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhBHPDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B9464EB4;
        Mon,  8 Feb 2021 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796550;
        bh=MdHahxvlgKemvMKAa5VOcRlIArdALTK5gj+f3Myj23k=;
        h=From:To:Cc:Subject:Date:From;
        b=QQqIe0CCvuL/RC44nXwa9D9/h1E40s8gdyuUUDDz/FxGXnv0F3hUeKuu4ejevC1cP
         6tXlTgLppcxoM/YWMv4Rc0Bu01jvUvmSrgqj6czjBrjqKT0JdHfsSc1qasry5altbT
         ePMuG7D7mkbV0pMNQ+Qf1nuA3+k9YzxTkhPj+yns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/38] 4.4.257-rc1 review
Date:   Mon,  8 Feb 2021 16:00:22 +0100
Message-Id: <20210208145805.279815326@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.257-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.257-rc1
X-KernelTest-Deadline: 2021-02-10T14:58+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.257 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.257-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.257-rc1

Shih-Yuan Lee (FourDollars) <sylee@canonical.com>
    ALSA: hda/realtek - Fix typo of pincfg for Dell quirk

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: thermal: Do not call acpi_thermal_check() directly

Benjamin Valentin <benpicco@googlemail.com>
    Input: xpad - sync supported devices with fork on GitHub

Dave Hansen <dave.hansen@linux.intel.com>
    x86/apic: Add extra serialization for non-serializing MSRs

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/build: Disable CET instrumentation in the kernel

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

Ralf Baechle <ralf@linux-mips.org>
    ELF/MIPS build fix

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

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Set default timeout to avoid crash during migration

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Avoid invoking response handler twice if ep is already completed

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: udc: core: Use lock when write to soft_connect

Lee Jones <lee.jones@linaro.org>
    futex: Handle faults correctly for PI futexes

Lee Jones <lee.jones@linaro.org>
    futex: Simplify fixup_pi_state_owner()

Lee Jones <lee.jones@linaro.org>
    futex: Use pi_state_update_owner() in put_pi_state()

Lee Jones <lee.jones@linaro.org>
    rtmutex: Remove unused argument from rt_mutex_proxy_unlock()

Lee Jones <lee.jones@linaro.org>
    futex: Provide and use pi_state_update_owner()

Lee Jones <lee.jones@linaro.org>
    futex: Replace pointless printk in fixup_owner()

Lee Jones <lee.jones@linaro.org>
    futex: Avoid violating the 10th rule of futex

Lee Jones <lee.jones@linaro.org>
    futex: Rework inconsistent rt_mutex/futex_q state

Lee Jones <lee.jones@linaro.org>
    futex: Remove rt_mutex_deadlock_account_*()

Lee Jones <lee.jones@linaro.org>
    futex,rt_mutex: Provide futex specific rt_mutex API

Eric Dumazet <edumazet@google.com>
    net_sched: reject silly cell_log in qdisc_get_rtab()


-------------

Diffstat:

 Makefile                              |  12 +-
 arch/arm/mach-footbridge/dc21285.c    |  12 +-
 arch/mips/Kconfig                     |   1 +
 arch/x86/Makefile                     |   3 +
 arch/x86/include/asm/apic.h           |  10 --
 arch/x86/include/asm/barrier.h        |  18 +++
 arch/x86/kernel/apic/apic.c           |   4 +
 arch/x86/kernel/apic/x2apic_cluster.c |   3 +-
 arch/x86/kernel/apic/x2apic_phys.c    |   3 +-
 drivers/acpi/thermal.c                |  54 +++++--
 drivers/input/joystick/xpad.c         |  17 ++-
 drivers/input/serio/i8042-x86ia64io.h |   2 +
 drivers/mmc/core/sdio_cis.c           |   6 +
 drivers/scsi/ibmvscsi/ibmvfc.c        |   4 +-
 drivers/scsi/libfc/fc_exch.c          |  16 +-
 drivers/usb/class/usblp.c             |  19 ++-
 drivers/usb/dwc2/gadget.c             |   8 +-
 drivers/usb/gadget/legacy/ether.c     |   4 +-
 drivers/usb/gadget/udc/udc-core.c     |  13 +-
 drivers/usb/serial/cp210x.c           |   2 +
 drivers/usb/serial/option.c           |   6 +
 fs/Kconfig.binfmt                     |   8 +
 fs/cifs/dir.c                         |  22 ++-
 fs/hugetlbfs/inode.c                  |   3 +-
 include/linux/elfcore.h               |  22 +++
 include/linux/hugetlb.h               |   3 +
 kernel/Makefile                       |   3 -
 kernel/elfcore.c                      |  25 ---
 kernel/futex.c                        | 278 +++++++++++++++++++---------------
 kernel/kprobes.c                      |   4 +
 kernel/locking/rtmutex-debug.c        |   9 --
 kernel/locking/rtmutex-debug.h        |   3 -
 kernel/locking/rtmutex.c              | 127 ++++++++++------
 kernel/locking/rtmutex.h              |   2 -
 kernel/locking/rtmutex_common.h       |  12 +-
 mm/hugetlb.c                          |   9 +-
 net/lapb/lapb_out.c                   |   3 +-
 net/mac80211/driver-ops.c             |   5 +-
 net/mac80211/rate.c                   |   3 +-
 net/sched/sch_api.c                   |   3 +-
 sound/pci/hda/patch_realtek.c         |   2 +-
 41 files changed, 469 insertions(+), 294 deletions(-)


