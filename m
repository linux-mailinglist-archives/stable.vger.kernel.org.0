Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC564AA89C
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379825AbiBEMPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379795AbiBEMPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:15:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD26C043186;
        Sat,  5 Feb 2022 04:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48CAD60DF0;
        Sat,  5 Feb 2022 12:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210DFC340E8;
        Sat,  5 Feb 2022 12:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644063317;
        bh=oE9lhREupdpa6wqtKD24ugZu89b7j2Pq47N43r3HcZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=Jp2LJ/+PHa5p0qJXC9AZtQSCA3U21ZqkHQvm6vS0D34tmLg4GpL0LkkwY1oaNs7bb
         xqCi8YI5nie/sHmwTQhRzHvo7T5kQPKTCfgE3QBJduXiNBOde+UQLFEGzIebG3Uv8k
         Z8etJqA3D+J/xC/6Lbth4Jc1aa/2GgR2shcgy6tI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.20
Date:   Sat,  5 Feb 2022 13:15:03 +0100
Message-Id: <164406330442229@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.20 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                             |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                       |   25 +++----
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                             |   14 +++-
 drivers/net/ethernet/intel/e1000e/netdev.c                           |    6 +
 drivers/net/ethernet/intel/i40e/i40e.h                               |    1 
 drivers/net/ethernet/intel/i40e/i40e_main.c                          |   31 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c                     |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c                |   32 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c              |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c        |   13 +++
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c                 |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h |    2 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c              |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c                       |    9 +-
 drivers/net/ipa/ipa_endpoint.c                                       |   21 ++++--
 drivers/net/ipa/ipa_endpoint.h                                       |   17 ++++
 drivers/net/usb/ipheth.c                                             |    6 -
 drivers/pci/hotplug/pciehp_hpc.c                                     |    7 +-
 fs/lockd/svcsubs.c                                                   |   18 ++---
 fs/notify/fanotify/fanotify_user.c                                   |    6 -
 fs/overlayfs/copy_up.c                                               |   16 +++-
 kernel/cgroup/cgroup-v1.c                                            |   14 ++++
 kernel/cgroup/cpuset.c                                               |    3 
 mm/gup.c                                                             |   35 ++++++++--
 net/core/rtnetlink.c                                                 |    6 +
 net/ipv4/tcp_input.c                                                 |    2 
 net/packet/af_packet.c                                               |    8 +-
 net/sched/cls_api.c                                                  |   11 ++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh                      |    5 -
 30 files changed, 240 insertions(+), 94 deletions(-)

Alex Elder (2):
      net: ipa: use a bitmap for endpoint replenish_enabled
      net: ipa: prevent concurrent replenish

Christoph Fritz (1):
      ovl: fix NULL pointer dereference in copy up warning

Dan Carpenter (1):
      fanotify: Fix stale file descriptor in copy_event_to_user()

Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Eric Dumazet (4):
      net: sched: fix use-after-free in tc_new_tfilter()
      rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
      af_packet: fix data-race in packet_setsockopt / packet_setsockopt
      tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Gal Pressman (1):
      net/mlx5e: Fix module EEPROM query

Georgi Valkov (1):
      ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Greg Kroah-Hartman (1):
      Linux 5.15.20

J. Bruce Fields (2):
      lockd: fix server crash on reboot of client holding lock
      lockd: fix failure to cleanup client locks

Jedrzej Jagielski (1):
      i40e: Fix reset bw limit when DCB enabled with 1 TC

John Hubbard (1):
      Revert "mm/gup: small refactoring: simplify try_grab_page()"

Karen Sornek (1):
      i40e: Fix reset path while removing the driver

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

Raed Salem (1):
      net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic

Raju Rangoju (1):
      net: amd-xgbe: ensure to reset the tx_timer_active flag

Roi Dayan (1):
      net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion

Sasha Neftin (1):
      e1000e: Handshake with CSME starts from ADL platforms

Shyam Sundar S K (1):
      net: amd-xgbe: Fix skb data length underflow

Tianchen Ding (1):
      cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

Vlad Buslov (2):
      net/mlx5: Bridge, take rtnl lock in init error handler
      net/mlx5: Bridge, ensure dev_name is null-terminated

