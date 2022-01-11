Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA17848AFC0
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242373AbiAKOll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiAKOlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:41:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E5EC06173F;
        Tue, 11 Jan 2022 06:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8B786165D;
        Tue, 11 Jan 2022 14:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE9EC36AE3;
        Tue, 11 Jan 2022 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641912099;
        bh=38eFh7aZkNBFpQm9mw2LOI79ungaftiy6Jzx7fV5qUw=;
        h=From:To:Cc:Subject:Date:From;
        b=Fe6r6FO3/0wKZyZiRwm1Fp5SQCzbTU6wxBvQCvWP4lN3kE8sMAlkpkfoFq/ooaHLg
         XgtEag7i5OUh87mP/IAZ8SVn46H8G1y8mHqA4uUd5/Ua5rylbUZS79HZEgO/P3Fm/z
         chc0HcJqoVpAEy/QqFM7abQ7zerRTUMJFDi8Vx2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.91
Date:   Tue, 11 Jan 2022 15:41:31 +0100
Message-Id: <1641912091110251@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.91 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/bcm2711.dtsi                     |    2 
 arch/arm/boot/dts/bcm283x.dtsi                     |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c  |    1 
 drivers/infiniband/core/uverbs_marshall.c          |    2 
 drivers/infiniband/core/uverbs_uapi.c              |    3 +
 drivers/input/touchscreen/zinitix.c                |   16 +++--
 drivers/isdn/mISDN/core.c                          |    6 +-
 drivers/isdn/mISDN/core.h                          |    4 -
 drivers/isdn/mISDN/layer1.c                        |    4 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   38 +++++++------
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |    8 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   60 +++++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   40 +++++++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c        |    5 +
 drivers/net/ethernet/sfc/falcon/rx.c               |    5 +
 drivers/net/ethernet/sfc/rx_common.c               |    5 +
 drivers/net/ieee802154/atusb.c                     |   10 ++-
 drivers/net/usb/rndis_host.c                       |    5 +
 drivers/power/reset/ltc2952-poweroff.c             |    4 -
 drivers/power/supply/bq25890_charger.c             |    4 -
 drivers/power/supply/power_supply_core.c           |    4 +
 drivers/scsi/libiscsi.c                            |    6 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |    4 -
 fs/f2fs/checkpoint.c                               |    3 -
 fs/xfs/xfs_ioctl.c                                 |    3 -
 kernel/trace/trace.c                               |    6 +-
 net/batman-adv/multicast.c                         |   15 +++--
 net/batman-adv/multicast.h                         |   10 ++-
 net/batman-adv/soft-interface.c                    |    7 +-
 net/core/lwtunnel.c                                |    4 +
 net/ipv4/fib_semantics.c                           |   49 +++++++++++++++--
 net/ipv4/udp.c                                     |    2 
 net/ipv6/ip6_vti.c                                 |    2 
 net/ipv6/raw.c                                     |    3 +
 net/ipv6/route.c                                   |   32 ++++++++++-
 net/mac80211/mlme.c                                |    2 
 net/netrom/af_netrom.c                             |    2 
 net/phonet/pep.c                                   |    1 
 net/sched/sch_qfq.c                                |    6 --
 samples/ftrace/ftrace-direct-modify.c              |    3 +
 samples/ftrace/ftrace-direct-too.c                 |    3 +
 samples/ftrace/ftrace-direct.c                     |    2 
 tools/testing/selftests/x86/test_vsyscall.c        |    2 
 44 files changed, 301 insertions(+), 96 deletions(-)

Arthur Kiyanovski (2):
      net: ena: Fix undefined state when tx request id is out of bounds
      net: ena: Fix error handling when calculating max IO queues number

Chao Yu (1):
      f2fs: quota: fix potential deadlock

Christoph Hellwig (1):
      netrom: fix copying in user data in nr_setsockopt

Chunfeng Yun (1):
      usb: mtu3: fix interval value for intr and isoc

Darrick J. Wong (1):
      xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

David Ahern (7):
      ipv4: Check attribute length for RTA_GATEWAY in multipath route
      ipv4: Check attribute length for RTA_FLOW in multipath route
      ipv6: Check attribute length for RTA_GATEWAY in multipath route
      ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
      lwtunnel: Validate RTA_ENCAP_TYPE attribute length
      ipv6: Continue processing multipath route even if gateway attribute is invalid
      ipv6: Do cleanup if attribute validation fails in multipath route

Di Zhu (1):
      i40e: fix use-after-free in i40e_sync_filters_subtask()

Eric Dumazet (1):
      sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Greg Kroah-Hartman (1):
      Linux 5.10.91

Hangyu Hua (1):
      phonet: refcount leak in pep_sock_accep

Jedrzej Jagielski (1):
      i40e: Fix incorrect netdev's real number of RX/TX queues

Jiasheng Jiang (1):
      RDMA/uverbs: Check for null return of kmalloc_array

Jiri Olsa (1):
      ftrace/samples: Add missing prototypes direct functions

Karen Sornek (1):
      iavf: Fix limit of total number of queues to active queues of VF

Lai, Derek (1):
      drm/amd/display: Added power down for DCN10

Leon Romanovsky (1):
      RDMA/core: Don't infoleak GRH fields

Linus Lüssing (1):
      batman-adv: mcast: don't send link-local multicast to mcast routers

Linus Walleij (1):
      power: supply: core: Break capacity loop

Lixiaokeng (1):
      scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Martin Habets (1):
      sfc: The RX page_ring is optional

Mateusz Palczewski (2):
      i40e: Fix to not show opcode msg on unsuccessful VF MAC change
      i40e: Fix for displaying message regarding NVM version

Nathan Chancellor (1):
      power: reset: ltc2952: Fix use of floating point literals

Naveen N. Rao (2):
      tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()
      tracing: Tag trace_percpu_buffer as a percpu pointer

Nikita Travkin (1):
      Input: zinitix - make sure the IRQ is allocated before it gets enabled

Pavel Skripkin (1):
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Phil Elwell (1):
      ARM: dts: gpio-ranges property is now required

Shuah Khan (1):
      selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()

Tamir Duberstein (1):
      ipv6: raw: check passed optlen before reading

Thomas Toye (1):
      rndis_host: support Hytera digital radios

Tom Rix (1):
      mac80211: initialize variable have_higher_than_11mbit

William Zhao (1):
      ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

Yauhen Kharuzhy (1):
      power: bq25890: Enable continuous conversion for ADC at charging

Zekun Shen (1):
      atlantic: Fix buff_ring OOB in aq_ring_rx_clean

wolfgang huang (1):
      mISDN: change function names to avoid conflicts

yangxingwu (1):
      net: udp: fix alignment problem in udp4_seq_show()

