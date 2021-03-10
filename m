Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB94F333EA3
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhCJN0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhCJNZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 067636509B;
        Wed, 10 Mar 2021 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382725;
        bh=b+k0ccjoq4HGAWIgAwKPS4ZBTF3TVK0bEv3RWgy39dI=;
        h=From:To:Cc:Subject:Date:From;
        b=Wg7ibYm2B3I2LcPCVl+yc9h2zLuzN7SzYFcqqEFiiAXOobMw7P/BMBXzYStwc3pzm
         nEdYOeStSTYjlI36JK6vgDH67yAmj55wL1RuiaVmB93lyT9wBADynGkBJ7v3yXidXC
         mairj+GTnAJ4zu4NuoyYknDw40kNtvTb2S2t2LMQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 0/7] 4.4.261-rc1 review
Date:   Wed, 10 Mar 2021 14:25:13 +0100
Message-Id: <20210310132319.155338551@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.261-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.261-rc1
X-KernelTest-Deadline: 2021-03-12T13:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 4.4.261 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.261-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.261-rc1

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add new force_caps module parameter

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix iterate_devices based device capability checks

Dan Carpenter <dan.carpenter@oracle.com>
    rsxx: Return -EFAULT if copy_to_user() fails

Colin Ian King <colin.king@canonical.com>
    ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Thomas Schoebel-Theuer <tst@1und1.de>
    futex: fix spin_lock() / spin_unlock_irq() imbalance

Thomas Schoebel-Theuer <tst@1und1.de>
    futex: fix irq self-deadlock and satisfy assertion


-------------

Diffstat:

 Makefile                        |  4 +-
 drivers/block/rsxx/core.c       |  8 ++--
 drivers/md/dm-table.c           | 83 ++++++++++++++++++++++++++---------------
 drivers/pci/quirks.c            |  3 ++
 drivers/platform/x86/acer-wmi.c |  8 +++-
 kernel/futex.c                  |  4 +-
 sound/pci/ctxfi/cthw20k2.c      |  2 +-
 7 files changed, 74 insertions(+), 38 deletions(-)


