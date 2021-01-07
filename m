Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5AE2ED25A
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbhAGOcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbhAGOcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA5223358;
        Thu,  7 Jan 2021 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029902;
        bh=f2BJZqgiOu6i363FPPRFdSFCigX5dqCcn4+1ZmhB3HM=;
        h=From:To:Cc:Subject:Date:From;
        b=QOXZFdIwPktH1qn4I6nICEyxiwj7MbwGQxaZ/D2DnRku4OHy7eSuZDfEsTmSFyjcK
         +eph1Pzb3bcuRzg2L2+2EHwIGPAw6LppNd1tulVWHXGCPM3b9BOtkjq5B8yLwgNhNs
         vRmBj+aYg/mksm7q67J7rbTI25Fw7vi1PxVHZ55w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 0/8] 4.19.166-rc1 review
Date:   Thu,  7 Jan 2021 15:32:00 +0100
Message-Id: <20210107143047.586006010@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.166-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.166-rc1
X-KernelTest-Deadline: 2021-01-09T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.166 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.166-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.166-rc1

Zhang Xiaohui <ruc_zhangxiaohui@163.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:mag3110: Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:bmi160: Fix alignment and data leak issues

Josh Poimboeuf <jpoimboe@redhat.com>
    kdev_t: always inline major/minor helper functions

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Substitute kzalloc with kmalloc

Felix Fietkau <nbd@nbd.name>
    Revert "mtd: spinand: Fix OOB read"


-------------

Diffstat:

 Makefile                                    |  4 ++--
 drivers/dma/at_hdmac.c                      | 11 ++++++++---
 drivers/iio/imu/bmi160/bmi160_core.c        | 13 +++++++++----
 drivers/iio/magnetometer/mag3110.c          | 13 +++++++++----
 drivers/mtd/nand/spi/core.c                 |  4 ----
 drivers/net/wireless/marvell/mwifiex/join.c |  2 ++
 include/linux/kdev_t.h                      | 22 +++++++++++-----------
 7 files changed, 41 insertions(+), 28 deletions(-)


