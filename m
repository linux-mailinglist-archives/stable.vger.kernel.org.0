Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA7A4AA891
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiBEMPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379040AbiBEMPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:15:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B35C061346;
        Sat,  5 Feb 2022 04:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A417B80ACB;
        Sat,  5 Feb 2022 12:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E231C340E8;
        Sat,  5 Feb 2022 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644063296;
        bh=1IKoIMeNa5YUBp2eOHtz5AE2Ja+TqsIHdACHpiYxOl0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZC9o5qwlv4y+PyacjCYZtUzD8VdO13aK3L2Z5UaCCagfaElqKU7T+BCPxKfgVGSaM
         xGLaXfRSkD316KbVQMZ2wgh7GI4FjHnYzp8WkQL3VLccSbN4Z0jprzusBWWwF1FSmm
         in639QLpdrqyq9Ba6D9z0EFrsxXVSPgk0+Zpbtyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.177
Date:   Sat,  5 Feb 2022 13:14:52 +0100
Message-Id: <164406329313858@kroah.com>
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

I'm announcing the release of the 5.4.177 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/accounting/psi.rst         |    3 -
 Makefile                                 |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c |   14 ++++++
 drivers/net/usb/ipheth.c                 |    6 +-
 drivers/pci/hotplug/pciehp_hpc.c         |    7 +--
 include/linux/psi.h                      |    2 
 include/linux/psi_types.h                |    3 -
 kernel/cgroup/cgroup-v1.c                |   14 ++++++
 kernel/cgroup/cgroup.c                   |   11 +++--
 kernel/cgroup/cpuset.c                   |    3 -
 kernel/sched/psi.c                       |   66 +++++++++++++------------------
 net/core/rtnetlink.c                     |    6 +-
 net/packet/af_packet.c                   |    8 ++-
 net/sched/cls_api.c                      |   11 +++--
 14 files changed, 93 insertions(+), 63 deletions(-)

Eric Dumazet (3):
      net: sched: fix use-after-free in tc_new_tfilter()
      rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
      af_packet: fix data-race in packet_setsockopt / packet_setsockopt

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Georgi Valkov (1):
      ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Greg Kroah-Hartman (1):
      Linux 5.4.177

Lukas Wunner (1):
      PCI: pciehp: Fix infinite loop in IRQ handler upon power fault

Raju Rangoju (1):
      net: amd-xgbe: ensure to reset the tx_timer_active flag

Shyam Sundar S K (1):
      net: amd-xgbe: Fix skb data length underflow

Suren Baghdasaryan (1):
      psi: Fix uaf issue when psi trigger is destroyed while being polled

Tianchen Ding (1):
      cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

