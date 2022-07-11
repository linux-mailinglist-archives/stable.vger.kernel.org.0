Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11EE56F9B0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiGKJHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGKJHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6219023168;
        Mon, 11 Jul 2022 02:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69E5A6118B;
        Mon, 11 Jul 2022 09:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DC9C34115;
        Mon, 11 Jul 2022 09:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530431;
        bh=AHkzYgJb5Kdc7JjggcpQUjFZ/Bd+h25yDl+GMxzxB6c=;
        h=From:To:Cc:Subject:Date:From;
        b=UBLhybM5ijWDCpE2ZVNx5Td5Co2JIZgOkAPcOezsAdQs2d4qSzxkrvOmpjE7vYPuN
         5si3IQkHEXni2K0xdOigFokFMDYF1ekZh+7AwLNg84eXaLhvp3xKpiwcZ3kmVcF53n
         +sRk1pOywYwvSv5ISVTak0JOPBRl0vVGLpoJQu8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/14] 4.9.323-rc1 review
Date:   Mon, 11 Jul 2022 11:06:19 +0200
Message-Id: <20220711090535.517697227@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.323-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.323-rc1
X-KernelTest-Deadline: 2022-07-13T09:05+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.323 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.323-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.323-rc1

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate

Michael Walle <michael@walle.cc>
    dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly

Linus Torvalds <torvalds@linux-foundation.org>
    ida: don't use BUG_ON() for debugging

Satish Nagireddy <satish.nagireddy@getcruise.com>
    i2c: cadence: Unregister the clk notifier in error path

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: a83t: Fix NAND function name for some pins

Eric Sandeen <sandeen@redhat.com>
    xfs: remove incorrect ASSERT in xfs_rename

Hsin-Yi Wang <hsinyi@chromium.org>
    video: of_display_timing.h: include errno.h

Yian Chen <yian.chen@intel.com>
    iommu/vt-d: Fix PCI bus rescan device hot add

Duoming Zhou <duoming@zju.edu.cn>
    net: rose: fix UAF bug caused by rose_t0timer_expiry

Oliver Neukum <oneukum@suse.com>
    usbnet: fix memory leak in error case

Rhett Aultman <rhett.aultman@samsara.com>
    can: gs_usb: gs_usb_open/close(): fix memory leak

Liang He <windhl@126.com>
    can: grcan: grcan_probe(): remove extra of_node_get()

Jann Horn <jannh@google.com>
    mm/slub: add missing TID updates on slab deactivation


-------------

Diffstat:

 Makefile                                   |  4 ++--
 drivers/dma/at_xdmac.c                     |  5 +++++
 drivers/dma/ti-dma-crossbar.c              |  5 +++++
 drivers/i2c/busses/i2c-cadence.c           |  1 +
 drivers/iommu/dmar.c                       |  2 +-
 drivers/net/can/grcan.c                    |  1 -
 drivers/net/can/usb/gs_usb.c               | 23 +++++++++++++++++++++--
 drivers/net/usb/usbnet.c                   | 17 ++++++++++++-----
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c | 10 +++++-----
 fs/xfs/xfs_inode.c                         |  1 -
 include/video/of_display_timing.h          |  2 ++
 lib/idr.c                                  |  4 +++-
 mm/slub.c                                  |  5 +++++
 net/rose/rose_route.c                      |  4 ++--
 14 files changed, 64 insertions(+), 20 deletions(-)


