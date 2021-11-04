Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAAD445512
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhKDOTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbhKDOSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 106B361216;
        Thu,  4 Nov 2021 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035369;
        bh=u0dY0y0KngJsPcSS97DW1dlBjwMhJX75AIQfGiMtwcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=CybF34tTtwjgES/T0cqy/p6B7kzMyUqMQsQ0fjG8VOtYsVZ2MtTpR8nEZV7UVxfxr
         9SOFpF07ZEV8D9tKlk2Z6AQTY6d0R4+J8bFUpsdGedQ0zfjz82yJZFl+qfE1n0jpAk
         5LpI1y4ajyR7fZsag8O/OO2lDMVhieDQxUNUkWxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 0/9] 5.4.158-rc1 review
Date:   Thu,  4 Nov 2021 15:12:53 +0100
Message-Id: <20211104141158.384397574@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.158-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.158-rc1
X-KernelTest-Deadline: 2021-11-06T14:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.158 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.158-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.158-rc1

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/ttm: fix memleak in ttm_transfered_destroy"

Erik Ekman <erik@kryo.se>
    sfc: Fix reading non-legacy supported link modes

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: core: hcd: Add support for deferring roothub registration"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "xhci: Set HCD flag to defer primary roothub registration"

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: ethernet: microchip: lan743x: Fix skb allocation failure

Eugene Crosser <crosser@average.org>
    vrf: Revert "Reset skb conntrack connection..."

Ming Lei <ming.lei@redhat.com>
    scsi: core: Put LLD module refcnt after SCSI device is released


-------------

Diffstat:

 Makefile                                      |  4 ++--
 drivers/amba/bus.c                            |  3 ---
 drivers/gpu/drm/ttm/ttm_bo_util.c             |  1 -
 drivers/media/firewire/firedtv-avc.c          | 14 ++++++++++---
 drivers/media/firewire/firedtv-ci.c           |  2 ++
 drivers/net/ethernet/microchip/lan743x_main.c | 10 +++++----
 drivers/net/ethernet/sfc/ethtool.c            | 10 ++-------
 drivers/net/vrf.c                             |  4 ----
 drivers/scsi/scsi.c                           |  4 +++-
 drivers/scsi/scsi_sysfs.c                     |  9 +++++++++
 drivers/usb/core/hcd.c                        | 29 ++++++---------------------
 drivers/usb/host/xhci.c                       |  1 -
 include/linux/usb/hcd.h                       |  2 --
 13 files changed, 41 insertions(+), 52 deletions(-)


