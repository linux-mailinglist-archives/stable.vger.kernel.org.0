Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0504831D7
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiACOWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:22:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53362 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiACOWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:22:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DB361122;
        Mon,  3 Jan 2022 14:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37955C36AED;
        Mon,  3 Jan 2022 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219730;
        bh=bI3LBGFTMF3Jbo3Sz0cSIm+rg3xx+O4hPnnBl5Fog6Q=;
        h=From:To:Cc:Subject:Date:From;
        b=ZdJ8sXmDD8Ey4U7xOm4xwOhb46uGHHTvx+rHD7Q0XUFA28HIyCP1E2xPYoa8rSsZG
         XgNwaxPntZDQnVL/jQsTl9tDUUSCvopj3/jrML1erhsytwUxR2p8QIosP/KXz5vwhJ
         3CjPMhkoaCIBA2g4BRrAcoip00qIYyQjLVcpyWeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/13] 4.9.296-rc1 review
Date:   Mon,  3 Jan 2022 15:21:16 +0100
Message-Id: <20220103142051.979780231@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.296-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.296-rc1
X-KernelTest-Deadline: 2022-01-05T14:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.296 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.296-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.296-rc1

Muchun Song <songmuchun@bytedance.com>
    net: fix use-after-free in tw_timer_handler

Leo L. Schwab <ewhac@ewhac.org>
    Input: spaceball - fix parsing of movement data packets

Pavel Skripkin <paskripkin@gmail.com>
    Input: appletouch - initialize work before device registration

Alexey Makhalov <amakhalov@vmware.com>
    scsi: vmw_pvscsi: Set residual data length conditionally

Vincent Pelletier <plr.vincent@gmail.com>
    usb: gadget: f_fs: Clear ffs_eventfd in ffs_data_clear.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Dmitry V. Levin <ldv@altlinux.org>
    uapi: fix linux/nfc.h userspace compilation errors

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: uapi: use kernel size_t to fix user-space builds

Miaoqian Lin <linmq006@gmail.com>
    fsl/fman: Fix missing put_device() call in fman_port_probe

Tom Rix <trix@redhat.com>
    selinux: initialize proto variable in selinux_ip_postroute_compat()

Heiko Carstens <hca@linux.ibm.com>
    recordmcount.pl: fix typo in s390 mcount regex

Wang Qing <wangqing@vivo.com>
    platform/x86: apple-gmux: use resource_size() with res

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option


-------------

Diffstat:

 Makefile                                        |  4 ++--
 drivers/hid/Kconfig                             |  1 +
 drivers/input/joystick/spaceball.c              | 11 +++++++++--
 drivers/input/mouse/appletouch.c                |  4 ++--
 drivers/net/ethernet/freescale/fman/fman_port.c | 12 +++++++-----
 drivers/platform/x86/apple-gmux.c               |  2 +-
 drivers/scsi/vmw_pvscsi.c                       |  7 +++++--
 drivers/usb/gadget/function/f_fs.c              |  9 ++++++---
 drivers/usb/host/xhci-pci.c                     |  5 ++++-
 include/uapi/linux/nfc.h                        |  6 +++---
 net/ipv4/af_inet.c                              | 10 ++++------
 scripts/recordmcount.pl                         |  2 +-
 security/selinux/hooks.c                        |  2 +-
 13 files changed, 46 insertions(+), 29 deletions(-)


