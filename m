Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED466429DED
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 08:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhJLGsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 02:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232076AbhJLGsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 02:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D80B60F21;
        Tue, 12 Oct 2021 06:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634021167;
        bh=FglZxS6/2XghYHNYO0qhBtCKFa8TyjJzVboc6yU25oE=;
        h=From:To:Cc:Subject:Date:From;
        b=nZISZ93+5byuEVUJxmDJ1Pbh2p1NxORlWsVKOCn9OF9xN5fa++Kq88mtBi7u78urh
         GDwMUgQ4OeLPaA2V83EdyhyZJ7clvky4IjMtvr5FdGiIo3udJK6i3noYT1tPKIZQ0a
         IzmMgP5rmkLi/BY4bVyk8g+Dmj1le/kdqsHvFJ7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/28] 4.19.211-rc2 review
Date:   Tue, 12 Oct 2021 08:46:04 +0200
Message-Id: <20211012064417.149035532@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.211-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.211-rc2
X-KernelTest-Deadline: 2021-10-14T06:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.211 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Oct 2021 06:44:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.211-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.211-rc2

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    x86/Kconfig: Correct reference to MWINCHIP3D

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_MOD when imm == 1

Jamie Iles <quic_jiles@quicinc.com>
    i2c: acpi: fix resource leak in reconfiguration device addition

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix freeing of uninitialized misc IRQ vector

Jiri Benc <jbenc@redhat.com>
    i40e: fix endless loop under rtnl

Eric Dumazet <edumazet@google.com>
    rtnetlink: fix if_nlmsg_stats_size() under estimation

Yang Yingliang <yangyingliang@huawei.com>
    drm/nouveau/debugfs: fix file release memory leak

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->bound

Sean Anderson <sean.anderson@seco.com>
    net: sfp: Fix typo in state machine debug string

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

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf, arm: Fix register clobbering in div/mod implementation

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Piotr Krysiuk <piotras@gmail.com>
    bpf, mips: Validate conditional branch offsets

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

Jan Beulich <jbeulich@suse.com>
    xen/privcmd: fix error handling in mmap-resource processing

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
 arch/arm/net/bpf_jit_32.c                   | 19 ++++++++++
 arch/mips/net/bpf_jit.c                     | 57 ++++++++++++++++++++++-------
 arch/powerpc/boot/dts/fsl/t1023rdb.dts      |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c           | 10 ++++-
 arch/x86/Kconfig                            |  2 +-
 arch/xtensa/kernel/irq.c                    |  2 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c   |  1 +
 drivers/i2c/i2c-core-acpi.c                 |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c |  5 ++-
 drivers/net/phy/mdio_bus.c                  |  7 ++++
 drivers/net/phy/sfp.c                       |  2 +-
 drivers/ptp/ptp_pch.c                       |  1 +
 drivers/usb/Kconfig                         |  3 +-
 drivers/usb/class/cdc-acm.c                 |  8 ++++
 drivers/xen/balloon.c                       | 21 ++++++++---
 drivers/xen/privcmd.c                       |  7 ++--
 fs/nfsd/nfs4xdr.c                           | 19 ++++++----
 fs/overlayfs/dir.c                          | 10 +++--
 kernel/bpf/stackmap.c                       |  3 +-
 net/bridge/br_netlink.c                     |  2 +-
 net/core/rtnetlink.c                        |  2 +-
 net/netlink/af_netlink.c                    | 14 +++++--
 net/sched/sch_fifo.c                        |  3 ++
 27 files changed, 156 insertions(+), 56 deletions(-)


