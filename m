Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE95406BCB
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhIJMej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhIJMeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10BC9611C0;
        Fri, 10 Sep 2021 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277177;
        bh=QbN1uEB15hYxh6urVIj1Um89Cpk6m6rwfkRkBMl9hlE=;
        h=From:To:Cc:Subject:Date:From;
        b=fwdflo3HgaI5BKj+hI0o5lFxbY9os5sSR/RHyLdl5FFGgXv+pnKJta8J1VqEjpLM6
         2wCh2H0LQOzqMu940J5GFlIM+lTk/Xjwz6Mgw1aVxy5ki27kgCwv7xHll8zGgsFEyv
         L8OdfHcqn1N+OLyTZehU2qEV2ejz3Yt2TS/oJ12Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 00/22] 5.13.16-rc1 review
Date:   Fri, 10 Sep 2021 14:29:59 +0200
Message-Id: <20210910122915.942645251@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.16-rc1
X-KernelTest-Deadline: 2021-09-12T12:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.16 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.16-rc1

Marek Behún <kabel@kernel.org>
    PCI: Call Max Payload Size-related fixup quirks early

Paul Gortmaker <paul.gortmaker@windriver.com>
    x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix failure to give back some cached cancelled URBs.

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

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: cdnsp: fix the wrong mult value for HS isoc or intr

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix issue of out-of-bounds array access

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: xhci-rcar: Don't reload firmware after the completion

Ismael Ferreras Morezuelas <swyterzone@gmail.com>
    Bluetooth: btusb: Make the CSR clone chip force-suspend workaround more generic

Larry Finger <Larry.Finger@lwfinger.net>
    Bluetooth: Add additional Bluetooth part for Realtek 8852AE

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Ming Lei <ming.lei@redhat.com>
    blk-mq: clearing flush request reference in tags->rqs[]

Ming Lei <ming.lei@redhat.com>
    blk-mq: fix is_flush_rq

Ming Lei <ming.lei@redhat.com>
    blk-mq: fix kernel panic during iterating over flush request

Hayes Wang <hayeswang@realtek.com>
    Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Remove left-over debug message

Liu Jian <liujian56@huawei.com>
    igmp: Add ip_mc_list lock in ip_check_mc_rcu

Hans de Goede <hdegoede@redhat.com>
    firmware: dmi: Move product_sku info to the end of the modalias


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/x86/kernel/reboot.c                    |  3 +-
 block/blk-core.c                            |  1 -
 block/blk-flush.c                           | 13 +++++
 block/blk-mq.c                              | 37 ++++++++++++++-
 block/blk.h                                 |  6 +--
 drivers/bluetooth/btusb.c                   | 59 +++++++++++++----------
 drivers/firmware/dmi-id.c                   |  6 ++-
 drivers/net/ethernet/realtek/r8169_main.c   |  1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c |  4 +-
 drivers/pci/quirks.c                        | 12 ++---
 drivers/usb/cdns3/cdnsp-mem.c               |  2 +-
 drivers/usb/gadget/udc/tegra-xudc.c         |  4 +-
 drivers/usb/host/xhci-debugfs.c             | 14 ++++--
 drivers/usb/host/xhci-mtk-sch.c             | 10 ++--
 drivers/usb/host/xhci-rcar.c                |  7 +++
 drivers/usb/host/xhci-ring.c                | 43 ++++++++++-------
 drivers/usb/host/xhci-trace.h               | 26 +++++-----
 drivers/usb/host/xhci.h                     | 73 ++++++++++++++---------------
 drivers/usb/mtu3/mtu3_core.c                |  4 +-
 drivers/usb/mtu3/mtu3_gadget.c              |  6 +--
 net/ipv4/igmp.c                             |  2 +
 sound/usb/quirks.c                          |  1 +
 23 files changed, 212 insertions(+), 126 deletions(-)


