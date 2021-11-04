Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010264457DB
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhKDREa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhKDREQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 13:04:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345ED610D0;
        Thu,  4 Nov 2021 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636045297;
        bh=8eE03GEeebqAFUd4jPPf0bNTziy0oIk4mLieFwyCwIk=;
        h=From:To:Cc:Subject:Date:From;
        b=MHjtssZeFZC8tpzDPRXpCpkAOUtvdVBbvtELXOvzj8rjMupGLs7c+c7GJQJy0hPa0
         rfn16A56dixNxeA6poIfulBz1mxRaXvdVTyBRnH22LMN+elSJaZqd5lrHiz52qk07s
         z+cgOSuxXGB0EQCFCKX2d2WO/2/Xo9WGCAK35SNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/14] 5.10.78-rc2 review
Date:   Thu,  4 Nov 2021 18:01:35 +0100
Message-Id: <20211104170112.899181800@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.78-rc2
X-KernelTest-Deadline: 2021-11-06T17:01+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.78 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.78-rc2

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add Audient iD14 to mixer map quirk table

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    Revert "wcn36xx: Disable bmps when encryption is disabled"

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/ttm: fix memleak in ttm_transfered_destroy"

Yang Shi <shy828301@gmail.com>
    mm: khugepaged: skip huge page collapse for special files

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

Erik Ekman <erik@kryo.se>
    sfc: Fix reading non-legacy supported link modes

Lee Jones <lee.jones@linaro.org>
    Revert "io_uring: reinforce cancel on flush during exit"

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
 drivers/net/ethernet/sfc/ethtool_common.c     | 10 ++-------
 drivers/net/vrf.c                             |  4 ----
 drivers/net/wireless/ath/wcn36xx/main.c       | 10 ---------
 drivers/net/wireless/ath/wcn36xx/pmc.c        |  5 +----
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h    |  1 -
 drivers/scsi/scsi.c                           |  4 +++-
 drivers/scsi/scsi_sysfs.c                     |  9 +++++++++
 drivers/usb/core/hcd.c                        | 29 ++++++---------------------
 drivers/usb/host/xhci.c                       |  1 -
 fs/io_uring.c                                 |  3 ++-
 include/linux/usb/hcd.h                       |  2 --
 mm/khugepaged.c                               | 17 +++++++++-------
 sound/usb/mixer_maps.c                        |  8 ++++++++
 19 files changed, 62 insertions(+), 75 deletions(-)


