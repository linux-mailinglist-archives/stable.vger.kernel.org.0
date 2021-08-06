Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF923E24E6
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbhHFIPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243555AbhHFIPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B183611C9;
        Fri,  6 Aug 2021 08:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237684;
        bh=MpRxmMgUgIX7xCimBxkSPd7fD3wKcDQl6SZgrCvCsS8=;
        h=From:To:Cc:Subject:Date:From;
        b=k4gZJQXuk/I0MN3gQxMhOBuC5L9CZgCy9+X+Rht10t1EJ1ENnbv5Xu+oxBNd4Uwac
         /qN0HtRbD6jeirV0cxPxiJIiP3it6q/OwjZRajANRJ7mdqZyRGLuMIkRuuGvy1qCBl
         fI80ZawRCr4PcRBZGbs53aaGcbsO5RTTrkOP8zKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 0/6] 4.4.279-rc1 review
Date:   Fri,  6 Aug 2021 10:14:32 +0200
Message-Id: <20210806081108.939164003@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.279-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.279-rc1
X-KernelTest-Deadline: 2021-08-08T08:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.279 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.279-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.279-rc1

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"

Pravin B Shelar <pshelar@ovn.org>
    net: Fix zero-copy head len calculation.

Takashi Iwai <tiwai@suse.de>
    r8152: Fix potential PM refcount imbalance

Axel Lin <axel.lin@ingics.com>
    regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Goldwyn Rodrigues <rgoldwyn@suse.com>
    btrfs: mark compressed range uptodate only if all bio succeed


-------------

Diffstat:

 Makefile                           |  4 ++--
 drivers/net/usb/r8152.c            |  3 ++-
 fs/btrfs/compression.c             |  2 +-
 include/linux/mfd/rt5033-private.h |  4 ++--
 net/bluetooth/hci_core.c           | 16 ++++++++--------
 net/can/raw.c                      | 20 ++++++++++++++++++--
 net/core/skbuff.c                  |  5 ++++-
 7 files changed, 37 insertions(+), 17 deletions(-)


