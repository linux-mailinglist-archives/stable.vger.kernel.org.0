Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835B2232E79
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgG3IUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbgG3IHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:07:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A0521744;
        Thu, 30 Jul 2020 08:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096420;
        bh=sohbCCYuDX3uDhpZAatiWG9WdBhEJF+UgBnwV/nnHNY=;
        h=From:To:Cc:Subject:Date:From;
        b=yVqdY5QLrQHbW1862RZUqgBYLiqEtYVoW5PlIVfCud8oPeBEsJhIoIIJyHNqPQzzq
         YbnNjeWD4TAXpf3qaqlaWx1t73gqQCqSS7H/iSdoU7GTbVVRcxAqTbRPtfYHS37mlf
         y2lLFP+tUHXPFYT4Qq74l/xM5OOYzIqdZlbzV9go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/17] 4.19.136-rc1 review
Date:   Thu, 30 Jul 2020 10:04:26 +0200
Message-Id: <20200730074420.449233408@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.136-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.136-rc1
X-KernelTest-Deadline: 2020-08-01T07:44+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.136 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.136-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.136-rc1

Peng Fan <peng.fan@nxp.com>
    regmap: debugfs: check count when read regmap file

Weilong Chen <chenweilong@huawei.com>
    rtnetlink: Fix memory(net_device) leak when ->newlink fails

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    udp: Improve load balancing for SO_REUSEPORT.

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    udp: Copy has_conns in reuseport_grow().

Xin Long <lucien.xin@gmail.com>
    sctp: shrink stream outq when fails to do addstream reconf

Xin Long <lucien.xin@gmail.com>
    sctp: shrink stream outq only when new outcnt < old outcnt

Dan Carpenter <dan.carpenter@oracle.com>
    AX.25: Prevent integer overflows in connect and sendmsg

Yuchung Cheng <ycheng@google.com>
    tcp: allow at most one TLP probe per flight

David Howells <dhowells@redhat.com>
    rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA

Cong Wang <xiyou.wangcong@gmail.com>
    qrtr: orphan socket in qrtr_release()

Miaohe Lin <linmiaohe@huawei.com>
    net: udp: Fix wrong clean up for IS_UDPLITE macro

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    net-sysfs: add a newline when printing 'tx_timeout' by sysfs

Wei Yongjun <weiyongjun1@huawei.com>
    ip6_gre: fix null-ptr-deref in ip6gre_init_net()

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/x25_asy: Fix to make it work

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    dev: Defer free of skbs in flush_backlog

Peilin Ye <yepeilin.cs@gmail.com>
    AX.25: Prevent out-of-bounds read in ax25_sendmsg()

Peilin Ye <yepeilin.cs@gmail.com>
    AX.25: Fix out-of-bounds read in ax25_connect()


-------------

Diffstat:

 Makefile                             |  4 ++--
 drivers/base/regmap/regmap-debugfs.c |  6 ++++++
 drivers/net/wan/x25_asy.c            | 21 ++++++++++++++-------
 include/linux/tcp.h                  |  4 +++-
 net/ax25/af_ax25.c                   | 10 ++++++++--
 net/core/dev.c                       |  2 +-
 net/core/net-sysfs.c                 |  2 +-
 net/core/rtnetlink.c                 |  3 ++-
 net/core/sock_reuseport.c            |  1 +
 net/ipv4/tcp_input.c                 | 11 ++++++-----
 net/ipv4/tcp_output.c                | 13 ++++++++-----
 net/ipv4/udp.c                       | 17 ++++++++++-------
 net/ipv6/ip6_gre.c                   | 11 ++++++-----
 net/ipv6/udp.c                       | 17 ++++++++++-------
 net/qrtr/qrtr.c                      |  1 +
 net/rxrpc/recvmsg.c                  |  2 +-
 net/rxrpc/sendmsg.c                  |  2 +-
 net/sctp/stream.c                    | 27 ++++++++++++++++++---------
 18 files changed, 99 insertions(+), 55 deletions(-)


