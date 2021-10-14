Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C4742DCB1
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhJNPBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231889AbhJNO7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E6A611C5;
        Thu, 14 Oct 2021 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223459;
        bh=Pct5Zrb8glnEnirhNhAZdnF7kD06zQnLUzNT3i4j8rM=;
        h=From:To:Cc:Subject:Date:From;
        b=pmfE4cYX5bXskMWR7NLyl5AQZEig+51A8uJSAd+rxn3JXtuYapLu7taMb0z27Tbz7
         bNOMVVd+X1L/G4xh1D9xVguVvNOy+Jhwj2fB90fQdJzX3N8sOW7r+E96p6TMrsjdoN
         3UZXgY1qZ60x0VErrdEndofikP1S03eaWsMRAWSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/33] 4.14.251-rc1 review
Date:   Thu, 14 Oct 2021 16:53:32 +0200
Message-Id: <20211014145208.775270267@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.251-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.251-rc1
X-KernelTest-Deadline: 2021-10-16T14:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.251 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.251-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.251-rc1

Peter Zijlstra <peterz@infradead.org>
    sched: Always inline is_percpu_thread()

Anand K Mistry <amistry@google.com>
    perf/x86: Reset destroy callback on event init failure

Colin Ian King <colin.king@canonical.com>
    scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    scsi: ses: Fix unsigned comparison with less than zero

Randy Dunlap <rdunlap@infradead.org>
    net: sun: SUNVNET_COMMON should depend on INET

Al Viro <viro@zeniv.linux.org.uk>
    m68k: Handle arrivals of multiple signals correctly

YueHaibing <yuehaibing@huawei.com>
    mac80211: Drop frames from invalid MAC address in ad-hoc mode

Jeremy Sowden <jeremy@azazel.net>
    netfilter: ip6_tables: zero-initialize fragment offset

Mizuho Mori <morimolymoly@gmail.com>
    HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: bcm7xxx: Fixed indirect MMD operations

Jamie Iles <quic_jiles@quicinc.com>
    i2c: acpi: fix resource leak in reconfiguration device addition

Jiri Benc <jbenc@redhat.com>
    i40e: fix endless loop under rtnl

Eric Dumazet <edumazet@google.com>
    rtnetlink: fix if_nlmsg_stats_size() under estimation

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/debugfs: fix file release memory leak

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->bound

Eric Dumazet <edumazet@google.com>
    net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()

Oleksij Rempel <o.rempel@pengutronix.de>
    ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ptp_pch: Load module automatically if ID matches

Pali Rohár <pali@kernel.org>
    powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Eric Dumazet <edumazet@google.com>
    net_sched: fix NULL deref in fifo_set_limit()

Pavel Skripkin <paskripkin@gmail.com>
    phy: mdio: fix memory leak

Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
    bpf: Fix integer overflow in prealloc_elems_and_freelist()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Piotr Krysiuk <piotras@gmail.com>
    bpf, mips: Validate conditional branch offsets

Daniel Borkmann <daniel@iogearbox.net>
    bpf: add also cbpf long jump test cases with heavy expansion

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: apq8064: use compatible which contains chipid

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap3430-sdp: Fix NAND device node

Juergen Gross <jgross@suse.com>
    xen/balloon: fix cancelled balloon action

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Zheng Liang <zhengliang6@huawei.com>
    ovl: fix missing negative dentry check in ovl_rename()

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix break reporting

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy tty buffer accesses

Ben Hutchings <ben@decadent.org.uk>
    Partially revert "usb: Kconfig: using select for USB_COMMON dependency"


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/arm/boot/dts/omap3430-sdp.dts          |  2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi         |  3 +-
 arch/arm/mach-imx/pm-imx6.c                 |  2 +
 arch/m68k/kernel/signal.c                   | 88 +++++++++++++--------------
 arch/mips/net/bpf_jit.c                     | 57 ++++++++++++-----
 arch/powerpc/boot/dts/fsl/t1023rdb.dts      |  2 +-
 arch/x86/events/core.c                      |  1 +
 arch/xtensa/kernel/irq.c                    |  2 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c   |  1 +
 drivers/hid/hid-apple.c                     |  7 +++
 drivers/i2c/i2c-core-acpi.c                 |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c |  2 +-
 drivers/net/ethernet/sun/Kconfig            |  1 +
 drivers/net/phy/bcm7xxx.c                   | 94 +++++++++++++++++++++++++++++
 drivers/net/phy/mdio_bus.c                  |  7 +++
 drivers/ptp/ptp_pch.c                       |  1 +
 drivers/scsi/ses.c                          |  2 +-
 drivers/scsi/virtio_scsi.c                  |  4 +-
 drivers/usb/Kconfig                         |  3 +-
 drivers/usb/class/cdc-acm.c                 |  8 +++
 drivers/xen/balloon.c                       | 21 +++++--
 fs/nfsd/nfs4xdr.c                           | 19 +++---
 fs/overlayfs/dir.c                          | 10 ++-
 include/linux/sched.h                       |  2 +-
 kernel/bpf/stackmap.c                       |  3 +-
 lib/test_bpf.c                              | 63 +++++++++++++++++++
 net/bridge/br_netlink.c                     |  2 +-
 net/core/rtnetlink.c                        |  2 +-
 net/ipv6/netfilter/ip6_tables.c             |  1 +
 net/mac80211/rx.c                           |  3 +-
 net/netlink/af_netlink.c                    | 14 +++--
 net/sched/sch_fifo.c                        |  3 +
 33 files changed, 336 insertions(+), 99 deletions(-)


