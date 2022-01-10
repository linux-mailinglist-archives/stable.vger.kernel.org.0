Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29880489173
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbiAJHcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:32:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59134 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239932AbiAJHaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5860CB81218;
        Mon, 10 Jan 2022 07:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0645C36AE9;
        Mon, 10 Jan 2022 07:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799811;
        bh=lGyFUTiZ+IxSMkSwz8MW14hqi8EA9VgPIkYlf1hLz54=;
        h=From:To:Cc:Subject:Date:From;
        b=xra0rVHghVWY/5ghhBOVupEuEe/qevEHZMhELhuu0VpeJnHGWXEDaUV0D1SOLQ4wr
         cgRT62dD2ci3HqRSolQbJtim8EsfDoletVnYNPzqGPvnk1ta4RmGWQKm6oAyWRFWYm
         EJrqbHmC5IeyspBRb2YNYQEE0C/ye9VFaO93ebbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/43] 5.10.91-rc1 review
Date:   Mon, 10 Jan 2022 08:22:57 +0100
Message-Id: <20220110071817.337619922@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.91-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.91-rc1
X-KernelTest-Deadline: 2022-01-12T07:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.91 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.91-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.91-rc1

Nikita Travkin <nikita@trvn.ru>
    Input: zinitix - make sure the IRQ is allocated before it gets enabled

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: gpio-ranges property is now required

Tamir Duberstein <tamird@gmail.com>
    ipv6: raw: check passed optlen before reading

Lai, Derek <Derek.Lai@amd.com>
    drm/amd/display: Added power down for DCN10

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

Yauhen Kharuzhy <jekhor@gmail.com>
    power: bq25890: Enable continuous conversion for ADC at charging

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

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: Fix error handling when calculating max IO queues number

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: Fix undefined state when tx request id is out of bounds

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

Jiri Olsa <jolsa@redhat.com>
    ftrace/samples: Add missing prototypes direct functions

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix incorrect netdev's real number of RX/TX queues

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix for displaying message regarding NVM version

Di Zhu <zhudi2@huawei.com>
    i40e: fix use-after-free in i40e_sync_filters_subtask()

Martin Habets <habetsm.xilinx@gmail.com>
    sfc: The RX page_ring is optional

Tom Rix <trix@redhat.com>
    mac80211: initialize variable have_higher_than_11mbit

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    RDMA/uverbs: Check for null return of kmalloc_array

Christoph Hellwig <hch@lst.de>
    netrom: fix copying in user data in nr_setsockopt

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Don't infoleak GRH fields

Karen Sornek <karen.sornek@intel.com>
    iavf: Fix limit of total number of queues to active queues of VF

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix to not show opcode msg on unsuccessful VF MAC change

Pavel Skripkin <paskripkin@gmail.com>
    ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Tag trace_percpu_buffer as a percpu pointer

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()

Shuah Khan <skhan@linuxfoundation.org>
    selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()

Chao Yu <chao@kernel.org>
    f2fs: quota: fix potential deadlock


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |  2 +
 arch/arm/boot/dts/bcm283x.dtsi                     |  2 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c  |  1 +
 drivers/infiniband/core/uverbs_marshall.c          |  2 +-
 drivers/infiniband/core/uverbs_uapi.c              |  3 ++
 drivers/input/touchscreen/zinitix.c                | 16 +++---
 drivers/isdn/mISDN/core.c                          |  6 +--
 drivers/isdn/mISDN/core.h                          |  4 +-
 drivers/isdn/mISDN/layer1.c                        |  4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 38 +++++++-------
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  8 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 60 ++++++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 40 ++++++++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  5 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |  5 ++
 drivers/net/ethernet/sfc/rx_common.c               |  5 ++
 drivers/net/ieee802154/atusb.c                     | 10 ++--
 drivers/net/usb/rndis_host.c                       |  5 ++
 drivers/power/reset/ltc2952-poweroff.c             |  4 +-
 drivers/power/supply/bq25890_charger.c             |  4 +-
 drivers/power/supply/power_supply_core.c           |  4 ++
 drivers/scsi/libiscsi.c                            |  6 ++-
 drivers/usb/mtu3/mtu3_gadget.c                     |  4 +-
 fs/f2fs/checkpoint.c                               |  3 +-
 fs/xfs/xfs_ioctl.c                                 |  3 +-
 kernel/trace/trace.c                               |  6 +--
 net/batman-adv/multicast.c                         | 15 ++++--
 net/batman-adv/multicast.h                         | 10 ++--
 net/batman-adv/soft-interface.c                    |  7 ++-
 net/core/lwtunnel.c                                |  4 ++
 net/ipv4/fib_semantics.c                           | 49 +++++++++++++++---
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/ip6_vti.c                                 |  2 +
 net/ipv6/raw.c                                     |  3 ++
 net/ipv6/route.c                                   | 32 +++++++++++-
 net/mac80211/mlme.c                                |  2 +-
 net/netrom/af_netrom.c                             |  2 +-
 net/phonet/pep.c                                   |  1 +
 net/sched/sch_qfq.c                                |  6 +--
 samples/ftrace/ftrace-direct-modify.c              |  3 ++
 samples/ftrace/ftrace-direct-too.c                 |  3 ++
 samples/ftrace/ftrace-direct.c                     |  2 +
 tools/testing/selftests/x86/test_vsyscall.c        |  2 +-
 44 files changed, 302 insertions(+), 97 deletions(-)


