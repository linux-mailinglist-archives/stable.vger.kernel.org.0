Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7121C252DF5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgHZMH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgHZMCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:02:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C3720838;
        Wed, 26 Aug 2020 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443352;
        bh=XU7kw8EKx+dxjCQFJN0yOvyQfd9J0drOfXvIptB9kvM=;
        h=From:To:Cc:Subject:Date:From;
        b=ejtr0flzNgvuIogYGcEof0T8nvpcmzgFBmo0FvkhZCSHWWwBwFAPLbYfqnGs+DX2i
         rsOhagXS9L8icHPy3Y4zFPThPL20osBRhKCmEv3y84cIqoutI1odl/AE2Rwg1/JJHg
         3TnaY3jnbXDmCoiKAwzjuNNbxF/6rZOrACVX9emw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 00/15] 5.7.19-rc1 review
Date:   Wed, 26 Aug 2020 14:02:28 +0200
Message-Id: <20200826114849.295321031@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.19-rc1
X-KernelTest-Deadline: 2020-08-28T11:48+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-------------------
Note, ok, this is really going to be the final 5.7.y kernel release.  I
mean it this time....
-------------------

This is the start of the stable review cycle for the 5.7.19 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 28 Aug 2020 11:48:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.19-rc1

Max Filippov <jcmvbkbc@gmail.com>
    binfmt_flat: revert "binfmt_flat: don't offset the data start"

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()

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
 arch/powerpc/kernel/cpu_setup_power.S        |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  5 ++++-
 fs/binfmt_flat.c                             | 20 ++++++++++++--------
 net/core/skbuff.c                            |  4 ++--
 net/ethtool/features.c                       | 19 ++++++++++---------
 net/ipv4/nexthop.c                           |  5 ++++-
 net/ipv6/ip6_tunnel.c                        | 10 +++++++++-
 net/qrtr/qrtr.c                              | 20 +++++++++++---------
 net/sched/act_ct.c                           |  2 +-
 net/sctp/stream.c                            |  6 ++++--
 net/smc/smc_diag.c                           | 16 +++++++++-------
 net/tipc/crypto.c                            |  2 ++
 net/tipc/netlink_compat.c                    | 12 +++++++++++-
 14 files changed, 82 insertions(+), 45 deletions(-)


