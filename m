Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D91D48914B
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbiAJHav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36500 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240119AbiAJH2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C48A611D3;
        Mon, 10 Jan 2022 07:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F8AC36AE9;
        Mon, 10 Jan 2022 07:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799709;
        bh=D8LBidOLjBzdTIhwKiHL1SfhnvOMGjFNjh2z2ukCbBo=;
        h=From:To:Cc:Subject:Date:From;
        b=ZsoPszEOWsKZQR76SDvDFgcf8kC8H2YiuJd2eP5ssSA84B0osYQNFvItT0gn2ukay
         4uqovqd7/R2rxXtFc7ZiwqDu5C0ueqRvUk2qHu0lbeVElHZoKK06JbK6ScG/sTNMmS
         VZECPOwKoY/vI4fGQRXOlbf1Hm1PUCtrrUNF7KMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/34] 5.4.171-rc1 review
Date:   Mon, 10 Jan 2022 08:22:55 +0100
Message-Id: <20220110071815.647309738@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.171-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.171-rc1
X-KernelTest-Deadline: 2022-01-12T07:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.171 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.171-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.171-rc1

wolfgang huang <huangjinhui@kylinos.cn>
    mISDN: change function names to avoid conflicts

Zekun Shen <bruceshenzk@gmail.com>
    atlantic: Fix buff_ring OOB in aq_ring_rx_clean

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

Linus Walleij <linus.walleij@linaro.org>
    power: supply: core: Break capacity loop

Darrick J. Wong <djwong@kernel.org>
    xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

Christian Melki <christian.melki@t2data.com>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081

Eric Dumazet <edumazet@google.com>
    sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: don't send link-local multicast to mcast routers

David Ahern <dsahern@kernel.org>
    lwtunnel: Validate RTA_ENCAP_TYPE attribute length

David Ahern <dsahern@kernel.org>
    ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route

David Ahern <dsahern@kernel.org>
    ipv6: Check attribute length for RTA_GATEWAY in multipath route

David Ahern <dsahern@kernel.org>
    ipv4: Check attribute length for RTA_FLOW in multipath route

David Ahern <dsahern@kernel.org>
    ipv4: Check attribute length for RTA_GATEWAY in multipath route

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix incorrect netdev's real number of RX/TX queues

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix for displaying message regarding NVM version

Di Zhu <zhudi2@huawei.com>
    i40e: fix use-after-free in i40e_sync_filters_subtask()

Tom Rix <trix@redhat.com>
    mac80211: initialize variable have_higher_than_11mbit

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    RDMA/uverbs: Check for null return of kmalloc_array

Leon Romanovsky <leonro@nvidia.com>
    RDMA/core: Don't infoleak GRH fields

Karen Sornek <karen.sornek@intel.com>
    iavf: Fix limit of total number of queues to active queues of VF

Pavel Skripkin <paskripkin@gmail.com>
    ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Tag trace_percpu_buffer as a percpu pointer

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()

Shuah Khan <skhan@linuxfoundation.org>
    selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()

Nathan Chancellor <nathan@kernel.org>
    Input: touchscreen - Fix backport of a02dcde595f7cbd240ccd64de96034ad91cffc40

Chao Yu <chao@kernel.org>
    f2fs: quota: fix potential deadlock


-------------

Diffstat:

 Makefile                                         |  4 +-
 drivers/infiniband/core/uverbs_marshall.c        |  2 +-
 drivers/infiniband/core/uverbs_uapi.c            |  3 ++
 drivers/input/touchscreen/of_touchscreen.c       |  8 ++--
 drivers/isdn/mISDN/core.c                        |  6 +--
 drivers/isdn/mISDN/core.h                        |  4 +-
 drivers/isdn/mISDN/layer1.c                      |  4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c |  8 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c      | 60 ++++++++++++++++++++----
 drivers/net/ethernet/intel/iavf/iavf_main.c      |  5 +-
 drivers/net/ieee802154/atusb.c                   | 10 ++--
 drivers/net/phy/micrel.c                         |  1 +
 drivers/net/usb/rndis_host.c                     |  5 ++
 drivers/power/reset/ltc2952-poweroff.c           |  4 +-
 drivers/power/supply/power_supply_core.c         |  4 ++
 drivers/scsi/libiscsi.c                          |  6 ++-
 drivers/usb/mtu3/mtu3_gadget.c                   |  4 +-
 fs/f2fs/checkpoint.c                             |  3 +-
 fs/xfs/xfs_ioctl.c                               |  3 +-
 kernel/trace/trace.c                             |  6 +--
 net/batman-adv/multicast.c                       | 15 ++++--
 net/batman-adv/multicast.h                       | 10 ++--
 net/batman-adv/soft-interface.c                  |  7 ++-
 net/core/lwtunnel.c                              |  4 ++
 net/ipv4/fib_semantics.c                         | 49 ++++++++++++++++---
 net/ipv4/udp.c                                   |  2 +-
 net/ipv6/ip6_vti.c                               |  2 +
 net/ipv6/route.c                                 | 32 ++++++++++++-
 net/mac80211/mlme.c                              |  2 +-
 net/phonet/pep.c                                 |  1 +
 net/sched/sch_qfq.c                              |  6 +--
 tools/testing/selftests/x86/test_vsyscall.c      |  2 +-
 32 files changed, 217 insertions(+), 65 deletions(-)


