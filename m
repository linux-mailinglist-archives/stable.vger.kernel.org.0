Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51D236AE3D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhDZHnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232655AbhDZHk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 211C5611CD;
        Mon, 26 Apr 2021 07:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422715;
        bh=QkzVlPH0VK5H59N1DADVWwoRJHH59zUmJz1/dtwN1wg=;
        h=From:To:Cc:Subject:Date:From;
        b=UdeSX41NxTbczl5TlitixtcxKN1fhdHV/PlJ8Yj98PxXdv7bQa7EtBjpoD6ObVeAy
         nW6BAztmKseuhcM/SlLOBDtdoOnfYignZ88M6y8vfm1GdvfOkHQDS98VHqNRl9Axfs
         ObKf4mK5EfCLiWh3dUThSn2SSe3nhsRtgFyiXKwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/20] 5.4.115-rc1 review
Date:   Mon, 26 Apr 2021 09:29:51 +0200
Message-Id: <20210426072816.686976183@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.115-rc1
X-KernelTest-Deadline: 2021-04-28T07:28+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.115 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.115-rc1

Mike Galbraith <efault@gmx.de>
    x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    ia64: tools: remove duplicate definition of ia64_mf() on ia64

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix discontig.c section mismatches

Randy Dunlap <rdunlap@infradead.org>
    csky: change a Kconfig symbol name to fix e1000 build error

Wan Jiabing <wanjiabing@vivo.com>
    cavium/liquidio: Fix duplicate argument

Michael Brown <mbrown@fensystems.co.uk>
    xen-netback: Check for hotplug-status existence before watching

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: save the caller of psw_idle

Phillip Potter <phil@philpotter.co.uk>
    net: geneve: check skb is large enough for IPv4/IPv6 header

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix swapped mmc order for omap3

Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
    HID: wacom: Assign boolean values to a bool variable

Jia-Ju Bai <baijiaju1990@gmail.com>
    HID: alps: fix error return code in alps_input_configured()

Shou-Chieh Hsu <shouchieh@chromium.org>
    HID: google: add don USB id

Leo Yan <leo.yan@linaro.org>
    perf auxtrace: Fix potential NULL pointer dereference

Jim Mattson <jmattson@google.com>
    perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Ali Saidi <alisaidi@amazon.com>
    locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS

Yuanyuan Zhong <yzhong@purestorage.com>
    pinctrl: lewisburg: Update number of pins in community

Tony Lindgren <tony@atomide.com>
    gpio: omap: Save and restore sysconfig

Sven Schnelle <svens@linux.ibm.com>
    s390/ptrace: return -ENOSYS when invalid syscall is supplied


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/omap3.dtsi                       |  3 ++
 .../boot/dts/allwinner/sun50i-a64-pine64-lts.dts   |  2 +-
 arch/csky/Kconfig                                  |  2 +-
 arch/csky/include/asm/page.h                       |  2 +-
 arch/ia64/mm/discontig.c                           |  6 +--
 arch/s390/kernel/entry.S                           |  1 +
 arch/s390/kernel/ptrace.c                          | 17 ++++--
 arch/x86/events/intel/core.c                       |  2 +-
 arch/x86/events/intel/uncore_snbep.c               | 61 +++++++++-------------
 arch/x86/kernel/crash.c                            |  2 +-
 drivers/gpio/gpio-omap.c                           |  9 ++++
 drivers/hid/hid-alps.c                             |  1 +
 drivers/hid/hid-google-hammer.c                    |  2 +
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/wacom_wac.c                            |  2 +-
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |  2 +-
 drivers/net/geneve.c                               |  6 +++
 drivers/net/xen-netback/xenbus.c                   | 12 +++--
 drivers/pinctrl/intel/pinctrl-lewisburg.c          |  6 +--
 include/linux/platform_data/gpio-omap.h            |  3 ++
 kernel/locking/qrwlock.c                           |  7 +--
 tools/arch/ia64/include/asm/barrier.h              |  3 --
 tools/perf/util/auxtrace.c                         |  2 +-
 24 files changed, 92 insertions(+), 66 deletions(-)


