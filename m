Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10C0252DBE
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgHZMGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgHZMD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B6F20786;
        Wed, 26 Aug 2020 12:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443438;
        bh=U1KRin26GDja2a+pX85+Yr8lXPbXGzALSWAlfN+Uoe8=;
        h=From:To:Cc:Subject:Date:From;
        b=BLSCZxsood8BSUcrS40nXUXL/hRa2H/hk2UQP5doLOPIEyrHAA/I2GsmfudSXqgp1
         D2RLiBR71rJ2WtKYntFZVYFldQVCw0WUuT3ao+IkOsJha/cY0gqpR2XX/sg1RkQ3qA
         H4vsoBbMvYnweX5WuUrx3nNgMyJMoYMdp0lHrle8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 00/16] 5.8.5-rc1 review
Date:   Wed, 26 Aug 2020 14:02:37 +0200
Message-Id: <20200826114911.216745274@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.5-rc1
X-KernelTest-Deadline: 2020-08-28T11:49+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.5 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 28 Aug 2020 11:49:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.5-rc1

Max Filippov <jcmvbkbc@gmail.com>
    binfmt_flat: revert "binfmt_flat: don't offset the data start"

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix missing ->mm on exit

Johannes Berg <johannes.berg@intel.com>
    netlink: fix state reallocation in policy export

Maxim Mikityanskiy <maximmi@mellanox.com>
    ethtool: Don't omit the netlink reply if no features were changed

Maxim Mikityanskiy <maximmi@mellanox.com>
    ethtool: Account for hw_features in netlink interface

Maxim Mikityanskiy <maximmi@mellanox.com>
    ethtool: Fix preserving of wanted feature bits in netlink interface

Shay Agroskin <shayagr@amazon.com>
    net: ena: Make missed_tx stat incremental

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

Xin Long <lucien.xin@gmail.com>
    tipc: call rcu_read_lock() in tipc_aead_encrypt_done()

Peilin Ye <yepeilin.cs@gmail.com>
    net/smc: Prevent kernel-infoleak in __smc_diag_dump()

David Laight <David.Laight@ACULAB.COM>
    net: sctp: Fix negotiation of the number of data streams.

Alaa Hleihel <alaa@mellanox.com>
    net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow

Necip Fazil Yildiran <necip@google.com>
    net: qrtr: fix usage of idr in port assignment to socket

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: nexthop: don't allow empty NHA_GROUP

Miaohe Lin <linmiaohe@huawei.com>
    net: Fix potential wrong skb->protocol in skb_vlan_untag()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY


-------------

Diffstat:

 Makefile                                     |  4 ++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  5 ++++-
 fs/binfmt_flat.c                             | 20 ++++++++++++--------
 fs/io_uring.c                                |  3 ++-
 net/core/skbuff.c                            |  4 ++--
 net/ethtool/features.c                       | 19 ++++++++++---------
 net/ipv4/nexthop.c                           |  5 ++++-
 net/ipv6/ip6_tunnel.c                        | 10 +++++++++-
 net/netlink/policy.c                         |  3 +++
 net/qrtr/qrtr.c                              | 20 +++++++++++---------
 net/sched/act_ct.c                           |  2 +-
 net/sctp/stream.c                            |  6 ++++--
 net/smc/smc_diag.c                           | 16 +++++++++-------
 net/tipc/crypto.c                            |  2 ++
 net/tipc/netlink_compat.c                    | 12 +++++++++++-
 15 files changed, 86 insertions(+), 45 deletions(-)


