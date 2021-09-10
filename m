Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A39C406C06
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhIJMgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234336AbhIJMfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CF72611EE;
        Fri, 10 Sep 2021 12:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277251;
        bh=TBg3pZI7dj2L8n563xdRtyVkXfFW+x3PkBVbd01i8k0=;
        h=From:To:Cc:Subject:Date:From;
        b=tGQA/j78rTL6eJEyX3dEK5N1xcbxExEDAZxottjQbAgbNT+fPCYsY1J7Xqbv6gcPm
         y+yVtUOd7QzzRPnhPcnrCvZFpWLmvDuqzA3iC4DEscPIyNY/AZNDmVLzHCyOC2mUYj
         Ww2Kt8BrlTIY3c4fwCAcs+k9Jncry8/EJHMoAtqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/26] 5.10.64-rc1 review
Date:   Fri, 10 Sep 2021 14:30:04 +0200
Message-Id: <20210910122916.253646001@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.64-rc1
X-KernelTest-Deadline: 2021-09-12T12:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.64 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.64-rc1

Marek Behún <kabel@kernel.org>
    PCI: Call Max Payload Size-related fixup quirks early

Paul Gortmaker <paul.gortmaker@windriver.com>
    x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix unsafe memory usage in xhci tracing

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix even more unsafe memory usage in xhci tracing

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: fix the wrong HS mult value

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: use @mult for HS isoc or intr

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: restore HS function when set SS/SSP

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: gadget: tegra-xudc: fix the wrong mult value for HS isoc or intr

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: xhci-rcar: Don't reload firmware after the completion

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Ming Lei <ming.lei@redhat.com>
    blk-mq: clearing flush request reference in tags->rqs[]

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: clone set element expression template

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: initialize set before expression setup

Eric Dumazet <edumazet@google.com>
    netfilter: nftables: avoid potential overflows on 32bit arches

Ming Lei <ming.lei@redhat.com>
    blk-mq: fix is_flush_rq

Ming Lei <ming.lei@redhat.com>
    blk-mq: fix kernel panic during iterating over flush request

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    x86/events/amd/iommu: Fix invalid Perf result due to IOMMU PMC power-gating

Hayes Wang <hayeswang@realtek.com>
    Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"

Jiri Slaby <jirislaby@kernel.org>
    tty: drop termiox user definitions

Randy Dunlap <rdunlap@infradead.org>
    net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling

Vignesh Raghavendra <vigneshr@ti.com>
    serial: 8250: 8250_omap: Fix unused variable warning

Randy Dunlap <rdunlap@infradead.org>
    net: kcov: don't select SKB_EXTENSIONS when there is no NET

Muchun Song <songmuchun@bytedance.com>
    mm/page_alloc: speed up the iteration of max_order

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Remove left-over debug message

Tom Rix <trix@redhat.com>
    USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Liu Jian <liujian56@huawei.com>
    igmp: Add ip_mc_list lock in ip_check_mc_rcu


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/x86/events/amd/iommu.c                 | 47 ++++++++-------
 arch/x86/kernel/reboot.c                    |  3 +-
 block/blk-core.c                            |  1 -
 block/blk-flush.c                           | 13 +++++
 block/blk-mq.c                              | 37 +++++++++++-
 block/blk.h                                 |  6 +-
 drivers/net/ethernet/realtek/r8169_main.c   |  1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c |  4 +-
 drivers/pci/quirks.c                        | 12 ++--
 drivers/tty/serial/8250/8250_omap.c         | 26 ++++-----
 drivers/usb/gadget/udc/tegra-xudc.c         |  4 +-
 drivers/usb/host/xhci-debugfs.c             | 14 +++--
 drivers/usb/host/xhci-rcar.c                |  7 +++
 drivers/usb/host/xhci-ring.c                |  3 +-
 drivers/usb/host/xhci-trace.h               | 26 +++++----
 drivers/usb/host/xhci.h                     | 73 ++++++++++++-----------
 drivers/usb/mtu3/mtu3_core.c                |  4 +-
 drivers/usb/mtu3/mtu3_gadget.c              |  6 +-
 drivers/usb/serial/mos7720.c                |  4 +-
 include/linux/skbuff.h                      |  4 +-
 include/uapi/linux/termios.h                | 15 -----
 lib/Kconfig.debug                           |  2 +-
 mm/page_alloc.c                             |  8 +--
 net/ipv4/igmp.c                             |  2 +
 net/netfilter/nf_tables_api.c               | 89 ++++++++++++++++++-----------
 net/netfilter/nft_set_hash.c                | 10 ++--
 sound/usb/quirks.c                          |  1 +
 28 files changed, 252 insertions(+), 174 deletions(-)


