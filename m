Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B974542DC24
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhJNO46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhJNO45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:56:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61D6360F4A;
        Thu, 14 Oct 2021 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223293;
        bh=u1VQ0wG68d19JixXuPaX7/P0rSYN1HioUgXLAJBSSbY=;
        h=From:To:Cc:Subject:Date:From;
        b=1FADacpLU2gdOL+boURN3aQDSwUwLb+NR/GzPvFAqV8xyi/JjBK4udnK5OHBB4W+p
         e3P15xx1f107fVeTqoQlGrPNQfNroIlcLFvtxp5SfiUFvLt9Skvg+MbGZxMTtUgsot
         ZRldykuw2bFD7Lk2UNLRbgFfWhLW2AdcGr+KoxLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/18] 4.4.289-rc1 review
Date:   Thu, 14 Oct 2021 16:53:32 +0200
Message-Id: <20211014145206.330102860@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.289-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.289-rc1
X-KernelTest-Deadline: 2021-10-16T14:52+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.289 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.289-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.289-rc1

Anand K Mistry <amistry@google.com>
    perf/x86: Reset destroy callback on event init failure

Colin Ian King <colin.king@canonical.com>
    scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    scsi: ses: Fix unsigned comparison with less than zero

YueHaibing <yuehaibing@huawei.com>
    mac80211: Drop frames from invalid MAC address in ad-hoc mode

Jeremy Sowden <jeremy@azazel.net>
    netfilter: ip6_tables: zero-initialize fragment offset

Mizuho Mori <morimolymoly@gmail.com>
    HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: check VMA flags to avoid invalid PROT_NONE NUMA balancing

Linus Torvalds <torvalds@linux-foundation.org>
    gup: document and work around "COW can break either way" issue

Jiri Benc <jbenc@redhat.com>
    i40e: fix endless loop under rtnl

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->bound

Oleksij Rempel <o.rempel@pengutronix.de>
    ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ptp_pch: Load module automatically if ID matches

Eric Dumazet <edumazet@google.com>
    net_sched: fix NULL deref in fifo_set_limit()

Pavel Skripkin <paskripkin@gmail.com>
    phy: mdio: fix memory leak

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix break reporting

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy tty buffer accesses


-------------

Diffstat:

 Makefile                                    |  4 +--
 arch/arm/mach-imx/pm-imx6.c                 |  2 ++
 arch/x86/kernel/cpu/perf_event.c            |  1 +
 arch/xtensa/kernel/irq.c                    |  2 +-
 drivers/hid/hid-apple.c                     |  7 +++++
 drivers/net/ethernet/intel/i40e/i40e_main.c |  2 +-
 drivers/net/phy/mdio_bus.c                  |  7 +++++
 drivers/ptp/ptp_pch.c                       |  1 +
 drivers/scsi/ses.c                          |  2 +-
 drivers/scsi/virtio_scsi.c                  |  4 +--
 drivers/usb/class/cdc-acm.c                 |  8 +++++
 fs/nfsd/nfs4xdr.c                           | 19 +++++++-----
 mm/gup.c                                    | 48 ++++++++++++++++++++++++-----
 mm/huge_memory.c                            | 10 ++----
 mm/memory.c                                 | 12 +++++---
 net/ipv6/netfilter/ip6_tables.c             |  1 +
 net/mac80211/rx.c                           |  3 +-
 net/netlink/af_netlink.c                    | 14 ++++++---
 net/sched/sch_fifo.c                        |  3 ++
 19 files changed, 110 insertions(+), 40 deletions(-)


