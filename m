Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4447AB83
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhLTOhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:37:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbhLTOhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:37:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 887B2B80EE0;
        Mon, 20 Dec 2021 14:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973A8C36AE7;
        Mon, 20 Dec 2021 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011022;
        bh=yInhjDVQOOAvP9gY99LTKwjRxKM4l3abNFq5X3Zf/T4=;
        h=From:To:Cc:Subject:Date:From;
        b=XNKEfJ1ChOs+ohL6UsT+f4ugHRAoUOAm1F0/7kV72jhMpth5JPLJuJRmG8ap3ue+W
         sSQoEnLmgsJjRUCla8zD2eXesGMKRw2mY+9zFd6tG59KHDhhk/LH34svIKU4SltKDT
         0ciXe+QHkHXUQdhE5+diR5Met5nnjQoAA2UuR+oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/23] 4.4.296-rc1 review
Date:   Mon, 20 Dec 2021 15:34:01 +0100
Message-Id: <20211220143017.842390782@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.296-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.296-rc1
X-KernelTest-Deadline: 2021-12-22T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.296 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.296-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.296-rc1

Juergen Gross <jgross@suse.com>
    xen/netback: don't queue unlimited number of packages

Juergen Gross <jgross@suse.com>
    xen/console: harden hvc_xen against event channel storms

Juergen Gross <jgross@suse.com>
    xen/netfront: harden netfront against event channel storms

Juergen Gross <jgross@suse.com>
    xen/blkfront: harden blkfront against event channel storms

Nathan Chancellor <nathan@kernel.org>
    Input: touchscreen - avoid bitwise vs logical OR warning

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 8805/2: remove unneeded naked function usage

Nathan Chancellor <natechancellor@gmail.com>
    net: lan78xx: Avoid unnecessary self assignment

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Add global locking for descriptor lifecycle

Yu Liao <liaoyu15@huawei.com>
    timekeeping: Really make sure wall_to_monotonic isn't positive

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN990 compositions

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: bRequestType is a bitfield, not a enum

Letu Ren <fantasquex@gmail.com>
    igbvf: fix double free in `igbvf_probe`

Nathan Chancellor <nathan@kernel.org>
    soc/tegra: fuse: Fix bitwise vs. logical OR warning

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix use-after-free due to delegation race

Joe Thornber <ejt@redhat.com>
    dm btree remove: fix use after free in rebalance_children()

Jerome Marchand <jmarchan@redhat.com>
    recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Felix Fietkau <nbd@nbd.name>
    mac80211: send ADDBA requests using the tid/queue of the aggregation session

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Ondrej Jirman <megous@megous.com>
    i2c: rk3x: Handle a spurious start completion interrupt flag

Helge Deller <deller@gmx.de>
    parisc/agp: Annotate parisc agp init functions with __init

Tadeusz Struk <tadeusz.struk@linaro.org>
    nfc: fix segfault in nfc_genl_dump_devices_done


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm/mm/copypage-fa.c                    |  35 ++++----
 arch/arm/mm/copypage-feroceon.c              |  98 ++++++++++-----------
 arch/arm/mm/copypage-v4mc.c                  |  19 ++--
 arch/arm/mm/copypage-v4wb.c                  |  41 +++++----
 arch/arm/mm/copypage-v4wt.c                  |  37 ++++----
 arch/arm/mm/copypage-xsc3.c                  |  71 +++++++--------
 arch/arm/mm/copypage-xscale.c                |  71 ++++++++-------
 drivers/block/xen-blkfront.c                 |  12 ++-
 drivers/char/agp/parisc-agp.c                |   6 +-
 drivers/hwmon/dell-smm-hwmon.c               |   7 +-
 drivers/i2c/busses/i2c-rk3x.c                |   4 +-
 drivers/input/touchscreen/of_touchscreen.c   |  18 ++--
 drivers/md/persistent-data/dm-btree-remove.c |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c   |   5 ++
 drivers/net/ethernet/broadcom/bcmsysport.h   |   1 +
 drivers/net/ethernet/intel/igbvf/netdev.c    |   1 +
 drivers/net/usb/lan78xx.c                    |   6 +-
 drivers/net/xen-netback/netback.c            |  13 ++-
 drivers/net/xen-netfront.c                   | 125 ++++++++++++++++++++-------
 drivers/pci/msi.c                            |   2 +-
 drivers/soc/tegra/fuse/fuse-tegra.c          |   2 +-
 drivers/soc/tegra/fuse/fuse.h                |   2 +-
 drivers/tty/hvc/hvc_xen.c                    |  30 ++++++-
 drivers/usb/gadget/composite.c               |   6 +-
 drivers/usb/gadget/legacy/dbgp.c             |   6 +-
 drivers/usb/gadget/legacy/inode.c            |   6 +-
 drivers/usb/serial/option.c                  |   8 ++
 fs/nfsd/nfs4state.c                          |   9 +-
 kernel/time/timekeeping.c                    |   3 +-
 net/mac80211/agg-tx.c                        |   2 +-
 net/netlink/af_netlink.c                     |   5 ++
 net/nfc/netlink.c                            |   6 +-
 scripts/recordmcount.pl                      |   2 +-
 34 files changed, 388 insertions(+), 277 deletions(-)


