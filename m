Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF533E2539
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244037AbhHFISY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244061AbhHFIRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:17:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77C326120A;
        Fri,  6 Aug 2021 08:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237800;
        bh=xjwII51qNefhiPOoLREh7N0Spr5NsPgdmJtZUk0/Rqg=;
        h=From:To:Cc:Subject:Date:From;
        b=lvZST/0bEd3OpZND4D5oFayH9HOxty52LWmd0Gp6+iFhkt9Jxw7Tha8Ti9avGxFJr
         LRJCKxAKGUi/nxMddlhxhRhHK6sveSk5K3E6cRA2L8D9OVIaljbGzHPqLluhg0WQQd
         zH4ibcrnv9R7HROFLhZ+duzQtTr/KDoOu10QVeoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/16] 4.19.202-rc1 review
Date:   Fri,  6 Aug 2021 10:14:51 +0200
Message-Id: <20210806081111.144943357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.202-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.202-rc1
X-KernelTest-Deadline: 2021-08-08T08:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.202 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.202-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.202-rc1

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: add separate cpuhp node for CPUHP_PADATA_DEAD

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: validate cpumask without removed CPU during offline

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Ensure drivers provide a probe function

Jani Nikula <jani.nikula@intel.com>
    drm/i915: Ensure intel_engine_init_execlist() builds with Clang

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "spi: mediatek: fix fifo rx mode"

Christoph Hellwig <hch@lst.de>
    bdi: add a ->dev_name field to struct backing_dev_info

Yufen Yu <yuyufen@huawei.com>
    bdi: use bdi_dev_name() to get device name

Christoph Hellwig <hch@lst.de>
    bdi: move bdi_dev_name out of line

Pravin B Shelar <pshelar@ovn.org>
    net: Fix zero-copy head len calculation.

Jia He <justin.he@arm.com>
    qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Takashi Iwai <tiwai@suse.de>
    r8152: Fix potential PM refcount imbalance

Kyle Russell <bkylerussell@gmail.com>
    ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Axel Lin <axel.lin@ingics.com>
    regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: mark compressed range uptodate only if all bio succeed


-------------

Diffstat:

 Makefile                                  |  4 ++--
 block/bfq-iosched.c                       |  6 ++++--
 block/blk-cgroup.c                        |  2 +-
 drivers/firmware/arm_scmi/bus.c           |  3 +++
 drivers/gpu/drm/i915/intel_engine_cs.c    |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 23 +++++++++++++++++------
 drivers/net/usb/r8152.c                   |  3 ++-
 drivers/spi/spi-mt65xx.c                  | 16 +++-------------
 drivers/watchdog/iTCO_wdt.c               | 12 +++---------
 fs/btrfs/compression.c                    |  3 +--
 fs/ceph/debugfs.c                         |  2 +-
 include/linux/backing-dev-defs.h          |  1 +
 include/linux/backing-dev.h               |  9 +--------
 include/linux/cpuhotplug.h                |  1 +
 include/linux/mfd/rt5033-private.h        |  4 ++--
 include/linux/padata.h                    |  6 ++++--
 include/trace/events/wbt.h                |  8 ++++----
 kernel/padata.c                           | 28 ++++++++++++++++++++--------
 mm/backing-dev.c                          | 13 +++++++++++--
 net/bluetooth/hci_core.c                  | 16 ++++++++--------
 net/core/skbuff.c                         |  5 ++++-
 sound/soc/codecs/tlv320aic31xx.h          |  4 ++--
 22 files changed, 96 insertions(+), 75 deletions(-)


