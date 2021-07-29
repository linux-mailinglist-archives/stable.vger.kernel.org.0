Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327693DA4F0
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhG2N5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238082AbhG2N5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CCAE60EB2;
        Thu, 29 Jul 2021 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567017;
        bh=wasuJm4+19OVLp3tzzM0IwKg5hlVc1EMRymPqtpDiv4=;
        h=From:To:Cc:Subject:Date:From;
        b=yS1/RRNCCbCvywTId+EXkkXrgYCA8I++lPQVkZpHH7Dz66n5YzsYSyK8MnbgyGYZv
         IuNbDj+rz/FAdpT3copCydEvJ3GQE3a0wj4HBcW6dcLs0x51tzgl0tY+5u9IW68NjS
         4GwmVgeuL7B1gZ4itx9hNe+yRsAaBbLab8KulQLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/17] 4.19.200-rc1 review
Date:   Thu, 29 Jul 2021 15:54:01 +0200
Message-Id: <20210729135137.260993951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.200-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.200-rc1
X-KernelTest-Deadline: 2021-07-31T13:51+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.200 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.200-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.200-rc1

Sudeep Holla <sudeep.holla@arm.com>
    ARM: dts: versatile: Fix up interrupt controller node names

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

Xin Long <lucien.xin@gmail.com>
    sctp: move 198 addresses from unusable to private scope

Eric Dumazet <edumazet@google.com>
    net: annotate data race around sk_ll_usec

Yang Yingliang <yangyingliang@huawei.com>
    net/802/garp: fix memleak in garp_request_join()

Yang Yingliang <yangyingliang@huawei.com>
    net/802/mrp: fix memleak in mrp_request_join()

Yang Yingliang <yangyingliang@huawei.com>
    workqueue: fix UAF in pwq_unbound_release_workfn()

Miklos Szeredi <mszeredi@redhat.com>
    af_unix: fix garbage collect vs MSG_PEEK

Jens Axboe <axboe@kernel.dk>
    net: split out functions related to registering inflight socket files

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: determine if an exception has an error code only when injecting it.

Ruslan Babayev <ruslan@babayev.com>
    iio: dac: ds4422/ds4424 drop of_node check

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/arm/boot/dts/versatile-ab.dts       |   5 +-
 arch/arm/boot/dts/versatile-pb.dts       |   2 +-
 arch/x86/kvm/x86.c                       |  13 ++-
 drivers/firmware/arm_scmi/driver.c       |  12 +--
 drivers/iio/dac/ds4424.c                 |   6 --
 fs/cifs/smb2ops.c                        |   4 +-
 fs/hfs/bfind.c                           |  14 ++-
 fs/hfs/bnode.c                           |  25 ++++--
 fs/hfs/btree.h                           |   7 ++
 fs/hfs/super.c                           |  10 +--
 include/net/af_unix.h                    |   1 +
 include/net/busy_poll.h                  |   2 +-
 include/net/sctp/constants.h             |   4 +-
 kernel/workqueue.c                       |  20 +++--
 net/802/garp.c                           |  14 +++
 net/802/mrp.c                            |  14 +++
 net/Makefile                             |   2 +-
 net/core/sock.c                          |   2 +-
 net/sctp/protocol.c                      |   3 +-
 net/unix/Kconfig                         |   5 ++
 net/unix/Makefile                        |   2 +
 net/unix/af_unix.c                       | 102 ++++++++++-----------
 net/unix/garbage.c                       |  68 +-------------
 net/unix/scm.c                           | 148 +++++++++++++++++++++++++++++++
 net/unix/scm.h                           |  10 +++
 tools/testing/selftests/vm/userfaultfd.c |   2 +-
 27 files changed, 329 insertions(+), 172 deletions(-)


