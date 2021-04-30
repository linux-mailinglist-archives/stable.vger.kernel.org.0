Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A8836FC3D
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhD3OWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhD3OWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45F5D6147D;
        Fri, 30 Apr 2021 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792482;
        bh=y76eaaT+6/Fol56EKBPspOvz98BSt6XcjwmgPSjiXbM=;
        h=From:To:Cc:Subject:Date:From;
        b=xJTuI+UOnQH5gyHkeqNawXrZQKuhurmA5Qwlb75ULOxr4rB8nXLhbj7cltGRPy2TH
         2E2DD3fL1zrJ5aNUC3b5KlWGQ/jty6AY9R1qVoX3hmBgKKsAAqgmo8JzSArRD3bPOC
         7lL7lTKZhG+wycTQ/6T/UOy4RcSRyUPrKKHyLA+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 0/5] 5.12.1-rc1 review
Date:   Fri, 30 Apr 2021 16:20:55 +0200
Message-Id: <20210430141910.899518186@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.1-rc1
X-KernelTest-Deadline: 2021-05-02T14:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.1 release.
There are 5 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.1-rc1

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add Alder Lake P device id.

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix locking in netlink owner interface destruction

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Oliver Neukum <oneukum@suse.com>
    USB: CDC-ACM: fix poison/unpoison imbalance

Johan Hovold <johan@kernel.org>
    net: hso: fix NULL-deref on disconnect regression


-------------

Diffstat:

 Makefile                                          |  4 ++--
 drivers/misc/mei/hw-me-regs.h                     |  1 +
 drivers/misc/mei/pci-me.c                         |  1 +
 drivers/net/usb/hso.c                             |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  7 ++++---
 drivers/usb/class/cdc-acm.c                       |  3 ++-
 net/wireless/core.c                               | 21 ++++++++++++++++----
 net/wireless/nl80211.c                            | 24 ++++++++++++++++++-----
 8 files changed, 47 insertions(+), 16 deletions(-)


