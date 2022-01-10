Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F4489142
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbiAJHaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239709AbiAJH2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDCDC028BF4;
        Sun,  9 Jan 2022 23:27:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A7B7611B9;
        Mon, 10 Jan 2022 07:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A055C36AE9;
        Mon, 10 Jan 2022 07:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799627;
        bh=PJOp4dFuN4gNhHSQ96n4gkNxu4wocz8p0mk9c67BfU0=;
        h=From:To:Cc:Subject:Date:From;
        b=U4kPYt3HOq1HrlFZfbDK+s9VKMwvIxav2k5/hYVvucCGFopGlVrXQFzIXl8aA2vWo
         PXtH6eW5m9GHFKlMDmJZMvnbkeP6CJx43kQoW0R04//poWQsHkzPRtHWS5cRkkfJQL
         eGA7rZ3eE1+7wQKbLFYU9sCB0Bi/r5n7lfr0LOgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/21] 4.19.225-rc1 review
Date:   Mon, 10 Jan 2022 08:23:01 +0100
Message-Id: <20220110071813.967414697@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.225-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.225-rc1
X-KernelTest-Deadline: 2022-01-12T07:18+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.225 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.225-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.225-rc1

wolfgang huang <huangjinhui@kylinos.cn>
    mISDN: change function names to avoid conflicts

yangxingwu <xingwu.yang@gmail.com>
    net: udp: fix alignment problem in udp4_seq_show()

William Zhao <wizhao@redhat.com>
    ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

Lixiaokeng <lixiaokeng@huawei.com>
    scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: fix interval value for intr and isoc

David Ahern <dsahern@kernel.org>
    ipv6: Do cleanup if attribute validation fails in multipath route

David Ahern <dsahern@kernel.org>
    ipv6: Continue processing multipath route even if gateway attribute is invalid

Hangyu Hua <hbh25y@gmail.com>
    phonet: refcount leak in pep_sock_accep

Thomas Toye <thomas@toye.io>
    rndis_host: support Hytera digital radios

Nathan Chancellor <nathan@kernel.org>
    power: reset: ltc2952: Fix use of floating point literals

Darrick J. Wong <djwong@kernel.org>
    xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

Eric Dumazet <edumazet@google.com>
    sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

David Ahern <dsahern@kernel.org>
    ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route

David Ahern <dsahern@kernel.org>
    ipv6: Check attribute length for RTA_GATEWAY in multipath route

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix incorrect netdev's real number of RX/TX queues

Di Zhu <zhudi2@huawei.com>
    i40e: fix use-after-free in i40e_sync_filters_subtask()

Tom Rix <trix@redhat.com>
    mac80211: initialize variable have_higher_than_11mbit

Leon Romanovsky <leonro@nvidia.com>
    RDMA/core: Don't infoleak GRH fields

Pavel Skripkin <paskripkin@gmail.com>
    ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Tag trace_percpu_buffer as a percpu pointer

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()


-------------

Diffstat:

 Makefile                                    |  4 +--
 drivers/infiniband/core/uverbs_marshall.c   |  2 +-
 drivers/isdn/mISDN/core.c                   |  6 ++--
 drivers/isdn/mISDN/core.h                   |  4 +--
 drivers/isdn/mISDN/layer1.c                 |  4 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c | 56 +++++++++++++++++++++++++----
 drivers/net/ieee802154/atusb.c              | 10 +++---
 drivers/net/usb/rndis_host.c                |  5 +++
 drivers/power/reset/ltc2952-poweroff.c      |  4 +--
 drivers/scsi/libiscsi.c                     |  6 ++--
 drivers/usb/mtu3/mtu3_gadget.c              |  4 +--
 fs/xfs/xfs_ioctl.c                          |  3 +-
 kernel/trace/trace.c                        |  6 ++--
 net/ipv4/udp.c                              |  2 +-
 net/ipv6/ip6_vti.c                          |  2 ++
 net/ipv6/route.c                            | 28 +++++++++++++--
 net/mac80211/mlme.c                         |  2 +-
 net/phonet/pep.c                            |  1 +
 net/sched/sch_qfq.c                         |  6 ++--
 19 files changed, 116 insertions(+), 39 deletions(-)


