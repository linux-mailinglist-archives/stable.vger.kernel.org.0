Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C311D4A95DD
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbiBDJU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiBDJU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:20:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06032C061714;
        Fri,  4 Feb 2022 01:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65A6D615E3;
        Fri,  4 Feb 2022 09:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6CEC340ED;
        Fri,  4 Feb 2022 09:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966426;
        bh=+1UElhq8MKv0E+BiGmsX4y0dpd8NMS/SdbFCsgUd62c=;
        h=From:To:Cc:Subject:Date:From;
        b=FEAVIx2jfJXUaoRVhLYHE7OpxF7EVjPuAX1aon4pKnZygoMLtwoAt6lBDpyCfgs/O
         HPyn6FsFoqpH5WdqCn0b/96YHB1FqdFxcFJ/8tQ3J9Xb+Ap+kZYgnNAz8O6Z7dHnhv
         LSSt0iXDR8WtG3oMzZAMG8x7e9AF/dVqg5gflrok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/10] 5.4.177-rc1 review
Date:   Fri,  4 Feb 2022 10:20:13 +0100
Message-Id: <20220204091912.329106021@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.177-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.177-rc1
X-KernelTest-Deadline: 2022-02-06T09:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.177 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.177-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.177-rc1

Eric Dumazet <edumazet@google.com>
    af_packet: fix data-race in packet_setsockopt / packet_setsockopt

Tianchen Ding <dtcccc@linux.alibaba.com>
    cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

Eric Dumazet <edumazet@google.com>
    rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()

Eric Dumazet <edumazet@google.com>
    net: sched: fix use-after-free in tc_new_tfilter()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix skb data length underflow

Raju Rangoju <Raju.Rangoju@amd.com>
    net: amd-xgbe: ensure to reset the tx_timer_active flag

Georgi Valkov <gvalkov@abv.bg>
    ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Eric W. Biederman <ebiederm@xmission.com>
    cgroup-v1: Require capabilities to set release_agent

Suren Baghdasaryan <surenb@google.com>
    psi: Fix uaf issue when psi trigger is destroyed while being polled

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix infinite loop in IRQ handler upon power fault


-------------

Diffstat:

 Documentation/accounting/psi.rst         |  3 +-
 Makefile                                 |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 14 ++++++-
 drivers/net/usb/ipheth.c                 |  6 +--
 drivers/pci/hotplug/pciehp_hpc.c         |  7 ++--
 include/linux/psi.h                      |  2 +-
 include/linux/psi_types.h                |  3 --
 kernel/cgroup/cgroup-v1.c                | 14 +++++++
 kernel/cgroup/cgroup.c                   | 11 ++++--
 kernel/cgroup/cpuset.c                   |  3 +-
 kernel/sched/psi.c                       | 66 ++++++++++++++------------------
 net/core/rtnetlink.c                     |  6 ++-
 net/packet/af_packet.c                   |  8 +++-
 net/sched/cls_api.c                      | 11 ++++--
 14 files changed, 94 insertions(+), 64 deletions(-)


