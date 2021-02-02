Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30030C0E0
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhBBOJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233797AbhBBOHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:07:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6CC65028;
        Tue,  2 Feb 2021 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273806;
        bh=jYp5v4FSwGcPX7ygo55IqlglMoCZXVFxQqlIo5DyQd4=;
        h=From:To:Cc:Subject:Date:From;
        b=qsKDOguTue7YE8qcWVMs5bZ64IZjaY2J9ky7urcmkA2L51DR9t1TUqEvu7+HrjPJF
         q8MkfyHYYE4oVYciz/opUizJ3YMA9CH19LumSu7CuKOw+qbUHS/6u8d57HxHZG3trJ
         6g1PC69MIcjnPdwYE6wmjh3jW8UJREYiwUA5z258=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/28] 4.4.255-rc1 review
Date:   Tue,  2 Feb 2021 14:38:20 +0100
Message-Id: <20210202132941.180062901@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.255-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.255-rc1
X-KernelTest-Deadline: 2021-02-04T13:29+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.255 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.255-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.255-rc1

Pan Bian <bianpan2016@163.com>
    NFC: fix possible resource leak

Pan Bian <bianpan2016@163.com>
    NFC: fix resource leak when target index is invalid

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built

David Woodhouse <dwmw@amazon.co.uk>
    iommu/vt-d: Gracefully handle DMAR units with no supported address widths

Dan Carpenter <dan.carpenter@oracle.com>
    can: dev: prevent potential information leak in can_fill_info()

Johannes Berg <johannes.berg@intel.com>
    mac80211: pause TX while changing interface type

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Fix the reported max_recv_sge value

Shmulik Ladkani <shmulik@metanetworks.com>
    xfrm: Fix oops in xfrm_replay_advance_bmp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: add timeout extension to template

Max Krummenacher <max.oss.09@gmail.com>
    ARM: imx: build suspend-imx6.S with arm instruction set

Thomas Gleixner <tglx@linutronix.de>
    futex: Prevent exit livelock

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide distinct return value when owner is exiting

Thomas Gleixner <tglx@linutronix.de>
    futex: Add mutex around futex exit

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide state handling for exec() as well

Thomas Gleixner <tglx@linutronix.de>
    futex: Sanitize exit state handling

Thomas Gleixner <tglx@linutronix.de>
    futex: Mark the begin of futex exit explicitly

Thomas Gleixner <tglx@linutronix.de>
    futex: Set task::futex_state to DEAD right after handling futex exit

Thomas Gleixner <tglx@linutronix.de>
    futex: Split futex_mm_release() for exit/exec

Thomas Gleixner <tglx@linutronix.de>
    exit/exec: Seperate mm_release()

Thomas Gleixner <tglx@linutronix.de>
    futex: Replace PF_EXITPIDONE with a state

Thomas Gleixner <tglx@linutronix.de>
    futex: Move futex exit handling into futex code

Arnd Bergmann <arnd@arndb.de>
    y2038: futex: Move compat implementation into futex.c

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix rx buffer refcounting

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix kernel crash unplugging the device

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]

Giacinto Cifelli <gciofono@gmail.com>
    net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Johannes Berg <johannes.berg@intel.com>
    wext: fix NULL-ptr-dereference with cfg80211's lack of commit()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ACPI: sysfs: Prefer "compatible" modalias


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/arm/mach-imx/suspend-imx6.S            |   1 +
 arch/x86/kvm/pmu_intel.c                    |   2 +-
 drivers/acpi/device_sysfs.c                 |  20 +-
 drivers/infiniband/hw/cxgb4/qp.c            |   2 +-
 drivers/iommu/dmar.c                        |  43 ++-
 drivers/net/can/dev.c                       |   2 +-
 drivers/net/usb/qmi_wwan.c                  |   1 +
 drivers/net/wireless/mediatek/mt7601u/dma.c |   5 +-
 fs/exec.c                                   |   2 +-
 include/linux/compat.h                      |   2 -
 include/linux/futex.h                       |  44 ++-
 include/linux/intel-iommu.h                 |   2 +
 include/linux/sched.h                       |   9 +-
 kernel/Makefile                             |   3 -
 kernel/exit.c                               |  25 +-
 kernel/fork.c                               |  40 +--
 kernel/futex.c                              | 446 ++++++++++++++++++++++++++--
 kernel/futex_compat.c                       | 201 -------------
 net/mac80211/ieee80211_i.h                  |   1 +
 net/mac80211/iface.c                        |   6 +
 net/netfilter/nft_dynset.c                  |   4 +-
 net/nfc/netlink.c                           |   1 +
 net/nfc/rawsock.c                           |   2 +-
 net/wireless/wext-core.c                    |   5 +-
 net/xfrm/xfrm_input.c                       |   2 +-
 26 files changed, 526 insertions(+), 349 deletions(-)


