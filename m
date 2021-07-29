Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558323DA511
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhG2N57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238198AbhG2N5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C549760F4A;
        Thu, 29 Jul 2021 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567058;
        bh=iCL5HkI/sRDxKnME9GJMSwdMLwVWk5r0QJcSkAKB3Fg=;
        h=From:To:Cc:Subject:Date:From;
        b=RofrtwCLQpY3LAjT5cb35IGlyYSyZg+VZWaIF7EvClbp00TLgJrygoZX+6AY+LbT7
         HXxNC6z0M57ywDjHwC5ErQGn6PKcA8rIpV3jxU1OvqYgCAbhuKZn3PzgnnP72S+8G7
         f8UDFOYMo0DfKv3e5cyUn2TG7OhYfHGTGtYenXfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/21] 5.4.137-rc1 review
Date:   Thu, 29 Jul 2021 15:54:07 +0200
Message-Id: <20210729135142.920143237@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.137-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.137-rc1
X-KernelTest-Deadline: 2021-07-31T13:51+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.137 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.137-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.137-rc1

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

Vasily Averin <vvs@virtuozzo.com>
    ipv6: allocate enough headroom in ip6_finish_output2()

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

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: determine if an exception has an error code only when injecting it.

Yonghong Song <yhs@fb.com>
    tools: Allow proper CC/CXX/... override with LLVM=1 in Makefile.include

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c


-------------

Diffstat:

 Makefile                                 |  4 +--
 arch/arm/boot/dts/versatile-ab.dts       |  5 ++--
 arch/arm/boot/dts/versatile-pb.dts       |  2 +-
 arch/x86/kvm/x86.c                       | 13 +++++---
 drivers/firmware/arm_scmi/driver.c       | 12 ++++----
 fs/cifs/smb2ops.c                        |  4 +--
 fs/hfs/bfind.c                           | 14 ++++++++-
 fs/hfs/bnode.c                           | 25 ++++++++++++----
 fs/hfs/btree.h                           |  7 +++++
 fs/hfs/super.c                           | 10 +++----
 fs/internal.h                            |  1 -
 fs/iomap/seek.c                          | 25 ++++++----------
 include/linux/fs_context.h               |  1 +
 include/net/busy_poll.h                  |  2 +-
 include/net/sctp/constants.h             |  4 +--
 kernel/cgroup/cgroup-v1.c                |  4 +--
 kernel/workqueue.c                       | 20 ++++++++-----
 net/802/garp.c                           | 14 +++++++++
 net/802/mrp.c                            | 14 +++++++++
 net/core/sock.c                          |  2 +-
 net/ipv6/ip6_output.c                    | 28 ++++++++++++++++++
 net/sctp/protocol.c                      |  3 +-
 net/unix/af_unix.c                       | 51 ++++++++++++++++++++++++++++++--
 tools/scripts/Makefile.include           | 12 ++++++--
 tools/testing/selftests/vm/userfaultfd.c |  2 +-
 25 files changed, 213 insertions(+), 66 deletions(-)


