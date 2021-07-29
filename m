Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DD03DA579
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238262AbhG2OCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238297AbhG2OBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 10:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA2861057;
        Thu, 29 Jul 2021 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567187;
        bh=czP2HfxTPzbIAbqVozgVgFooXFpYbTpZOjboE4UdvhY=;
        h=From:To:Cc:Subject:Date:From;
        b=RyZoWm/qzw46MD2orclqzi0a5hk/0idHOhxHgd+d/Z9NLo6KcTIWYVU1KyaTULVEO
         XFTlkAxQ+xuoz5HvVaVUdm/EkYq05mXZkrn9h9FaBAP1p5MhwgCTjcdeR+792vAJF6
         kfZcneteHc4AJUKo+eLbFlYswcx1Dv7zBTdG0SXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 00/22] 5.13.7-rc1 review
Date:   Thu, 29 Jul 2021 15:54:31 +0200
Message-Id: <20210729135137.336097792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.7-rc1
X-KernelTest-Deadline: 2021-07-31T13:51+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.7 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.7-rc1

Vasily Averin <vvs@virtuozzo.com>
    ipv6: ip6_finish_output2: set sk into newly allocated nskb

Sudeep Holla <sudeep.holla@arm.com>
    ARM: dts: versatile: Fix up interrupt controller node names

Christoph Hellwig <hch@lst.de>
    iomap: remove the length variable in iomap_seek_hole

Christoph Hellwig <hch@lst.de>
    iomap: remove the length variable in iomap_seek_data

Hyunchul Lee <hyc.lee@gmail.com>
    cifs: fix the out of range assignment to bit fields in parse_server_interfaces

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix range check for the maximum number of pending messages

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    hfs: add lock nesting notation to hfs_find_init

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    hfs: fix high memory mapping in hfs_bnode_read

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    hfs: add missing clean-up in hfs_fill_super

Zheyu Ma <zheyuma97@gmail.com>
    drm/ttm: add a check against null pointer dereference

Casey Chen <cachen@purestorage.com>
    nvme-pci: fix multiple races in nvme_setup_io_queues

Vasily Averin <vvs@virtuozzo.com>
    ipv6: allocate enough headroom in ip6_finish_output2()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Don't delete holdouts within trc_inspect_reader()

Xin Long <lucien.xin@gmail.com>
    sctp: move 198 addresses from unusable to private scope

Eric Dumazet <edumazet@google.com>
    net: annotate data race around sk_ll_usec

Yang Yingliang <yangyingliang@huawei.com>
    net/802/garp: fix memleak in garp_request_join()

Yang Yingliang <yangyingliang@huawei.com>
    net/802/mrp: fix memleak in mrp_request_join()

Paul Gortmaker <paul.gortmaker@windriver.com>
    cgroup1: fix leaked context root causing sporadic NULL deref in LTP

Yang Yingliang <yangyingliang@huawei.com>
    workqueue: fix UAF in pwq_unbound_release_workfn()

Miklos Szeredi <mszeredi@redhat.com>
    af_unix: fix garbage collect vs MSG_PEEK


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/arm/boot/dts/versatile-ab.dts      |  5 +--
 arch/arm/boot/dts/versatile-pb.dts      |  2 +-
 drivers/firmware/arm_scmi/driver.c      | 12 +++---
 drivers/gpu/drm/ttm/ttm_range_manager.c |  3 ++
 drivers/nvme/host/pci.c                 | 66 +++++++++++++++++++++++++++++----
 fs/cifs/smb2ops.c                       |  4 +-
 fs/hfs/bfind.c                          | 14 ++++++-
 fs/hfs/bnode.c                          | 25 ++++++++++---
 fs/hfs/btree.h                          |  7 ++++
 fs/hfs/super.c                          | 10 ++---
 fs/internal.h                           |  1 -
 fs/iomap/seek.c                         | 25 +++++--------
 include/linux/fs_context.h              |  1 +
 include/net/busy_poll.h                 |  2 +-
 include/net/sctp/constants.h            |  4 +-
 kernel/cgroup/cgroup-v1.c               |  4 +-
 kernel/rcu/tasks.h                      |  6 +--
 kernel/workqueue.c                      | 20 ++++++----
 net/802/garp.c                          | 14 +++++++
 net/802/mrp.c                           | 14 +++++++
 net/core/sock.c                         |  2 +-
 net/ipv6/ip6_output.c                   | 28 ++++++++++++++
 net/sctp/protocol.c                     |  3 +-
 net/unix/af_unix.c                      | 51 ++++++++++++++++++++++++-
 25 files changed, 256 insertions(+), 71 deletions(-)


