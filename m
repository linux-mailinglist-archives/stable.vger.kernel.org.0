Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094E34AA8A1
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379817AbiBEMPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:15:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50118 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379800AbiBEMPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:15:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B12C60DF0;
        Sat,  5 Feb 2022 12:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0098AC340E8;
        Sat,  5 Feb 2022 12:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644063324;
        bh=0ioLUtrKdBwkxRXSk+AnJy4wIx5hjKnuaD3I6nEPO5k=;
        h=From:To:Cc:Subject:Date:From;
        b=L1nrMQVIgI8MNwG25EwIckpTY9E9iN4dfMGD+mhUGluPhsewbIsY8iL/KItjxYtng
         xpfsLY6I0iYfnnQAklY7dQURw5NdKr0VuYIM34esas/m1WrUxpInRppS6NtVzflVOJ
         j3Z/Xqhi2T8DCU182LcQPq9oUghubyehCwZos3kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.6
Date:   Sat,  5 Feb 2022 13:15:09 +0100
Message-Id: <164406330924779@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.6 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                             |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                       |   25 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                             |   14 ++
 drivers/net/ethernet/intel/e1000e/netdev.c                           |    6 -
 drivers/net/ethernet/intel/i40e/i40e.h                               |    1 
 drivers/net/ethernet/intel/i40e/i40e_main.c                          |   31 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en.h                         |    6 -
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c                     |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c                |   32 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c              |    6 -
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                    |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c                     |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c        |   13 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h        |    9 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                      |   30 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                      |   15 ++
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c                 |    4 
 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h |    2 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c              |    9 -
 drivers/net/ethernet/mellanox/mlx5/core/port.c                       |    9 -
 drivers/net/ipa/ipa_endpoint.c                                       |   21 +++-
 drivers/net/ipa/ipa_endpoint.h                                       |   17 ++-
 drivers/net/ipa/ipa_power.c                                          |   52 ++++++++++
 drivers/net/ipa/ipa_power.h                                          |    7 +
 drivers/net/ipa/ipa_uc.c                                             |    5 
 drivers/net/phy/at803x.c                                             |   26 ++---
 drivers/net/usb/ipheth.c                                             |    6 -
 drivers/pci/hotplug/pciehp_hpc.c                                     |    7 -
 fs/lockd/svcsubs.c                                                   |   18 +--
 fs/notify/fanotify/fanotify_user.c                                   |    6 -
 fs/overlayfs/copy_up.c                                               |   16 ++-
 kernel/bpf/trampoline.c                                              |    5 
 kernel/cgroup/cgroup-v1.c                                            |   14 ++
 kernel/cgroup/cpuset.c                                               |    3 
 mm/gup.c                                                             |   35 +++++-
 net/core/rtnetlink.c                                                 |    6 -
 net/ipv4/tcp.c                                                       |    7 -
 net/ipv4/tcp_input.c                                                 |    2 
 net/packet/af_packet.c                                               |    8 +
 net/sched/cls_api.c                                                  |   11 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh                      |    5 
 42 files changed, 375 insertions(+), 130 deletions(-)

Alex Elder (3):
      net: ipa: use a bitmap for endpoint replenish_enabled
      net: ipa: prevent concurrent replenish
      net: ipa: request IPA register values be retained

Christoph Fritz (1):
      ovl: fix NULL pointer dereference in copy up warning

Dan Carpenter (1):
      fanotify: Fix stale file descriptor in copy_event_to_user()

Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Eric Dumazet (5):
      net: sched: fix use-after-free in tc_new_tfilter()
      rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
      af_packet: fix data-race in packet_setsockopt / packet_setsockopt
      tcp: fix mem under-charging with zerocopy sendmsg()
      tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Gal Pressman (1):
      net/mlx5e: Fix module EEPROM query

Georgi Valkov (1):
      ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Greg Kroah-Hartman (1):
      Linux 5.16.6

He Fengqing (1):
      bpf: Fix possible race in inc_misses_counter

J. Bruce Fields (2):
      lockd: fix server crash on reboot of client holding lock
      lockd: fix failure to cleanup client locks

Jedrzej Jagielski (1):
      i40e: Fix reset bw limit when DCB enabled with 1 TC

John Hubbard (1):
      Revert "mm/gup: small refactoring: simplify try_grab_page()"

Jonathan McDowell (1):
      net: phy: Fix qca8081 with speeds lower than 2.5Gb/s

Karen Sornek (1):
      i40e: Fix reset path while removing the driver

Kees Cook (1):
      net/mlx5e: Avoid field-overflowing memcpy()

Khalid Manaa (2):
      net/mlx5e: Fix wrong calculation of header index in HW_GRO
      net/mlx5e: Fix broken SKB allocation in HW-GRO

Lukas Wunner (1):
      PCI: pciehp: Fix infinite loop in IRQ handler upon power fault

Maher Sanalla (1):
      net/mlx5: Use del_timer_sync in fw reset flow of halting poll

Maor Dickman (2):
      net/mlx5e: Fix handling of wrong devices during bond netevent
      net/mlx5: E-Switch, Fix uninitialized variable modact

Maxim Mikityanskiy (1):
      net/mlx5e: Don't treat small ceil values as unlimited in HTB offload

Maxime Ripard (1):
      drm/vc4: hdmi: Make sure the device is powered with CEC

Miklos Szeredi (1):
      ovl: don't fail copy up if no fileattr support on upper

Paolo Abeni (1):
      selftests: mptcp: fix ipv6 routing setup

Raed Salem (2):
      net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
      net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic

Raju Rangoju (1):
      net: amd-xgbe: ensure to reset the tx_timer_active flag

Roi Dayan (4):
      net/mlx5e: TC, Reject rules with drop and modify hdr action
      net/mlx5e: TC, Reject rules with forward and drop actions
      net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion
      net/mlx5e: Avoid implicit modify hdr for decap drop rule

Sasha Neftin (1):
      e1000e: Handshake with CSME starts from ADL platforms

Shyam Sundar S K (1):
      net: amd-xgbe: Fix skb data length underflow

Tianchen Ding (1):
      cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

Vlad Buslov (2):
      net/mlx5: Bridge, take rtnl lock in init error handler
      net/mlx5: Bridge, ensure dev_name is null-terminated

