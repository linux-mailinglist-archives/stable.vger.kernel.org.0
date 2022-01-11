Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C110A48ADF9
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 13:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiAKM4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 07:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiAKMz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 07:55:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0021FC06173F;
        Tue, 11 Jan 2022 04:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE5DDB81A90;
        Tue, 11 Jan 2022 12:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB45C36AED;
        Tue, 11 Jan 2022 12:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641905756;
        bh=/kQFGb3JB12YMs/w1NS2hbSxAh0R73aXH0KuoXs7tJE=;
        h=From:To:Cc:Subject:Date:From;
        b=gkdw4fC5tIO2mEVV9MOYUt5ANToANE+3F36CKV79NuuIncDEUOvNSauLo/XUt1fX5
         H4ZB8U6Dlfa14KqiTgFCXlko00O5lvh7aH8kPR5xCE8vfKlMMfWyOoh56locOdO0Ao
         5dg3qjNJ4gRUBwGQv6597H1U0F0V5xXZQzhuptvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.299
Date:   Tue, 11 Jan 2022 13:55:52 +0100
Message-Id: <1641905752445@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.299 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 drivers/bluetooth/btusb.c                   |   32 +++++++++++++++++++++-------
 drivers/isdn/mISDN/core.c                   |    6 ++---
 drivers/isdn/mISDN/core.h                   |    4 +--
 drivers/isdn/mISDN/layer1.c                 |    4 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c |   32 +++++++++++++++++++++-------
 drivers/net/ieee802154/atusb.c              |   10 +++++---
 drivers/net/usb/rndis_host.c                |    5 ++++
 drivers/power/reset/ltc2952-poweroff.c      |    4 +--
 drivers/scsi/libiscsi.c                     |    6 +++--
 fs/xfs/xfs_ioctl.c                          |    3 +-
 lib/test_bpf.c                              |    2 -
 net/ipv4/udp.c                              |    2 -
 net/ipv6/ip6_vti.c                          |    2 +
 net/mac80211/mlme.c                         |    2 -
 net/phonet/pep.c                            |    1 
 net/sched/sch_qfq.c                         |    6 +----
 17 files changed, 85 insertions(+), 38 deletions(-)

Daniel Borkmann (1):
      bpf, test: fix ld_abs + vlan push/pop stress test

Darrick J. Wong (1):
      xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

Eric Dumazet (1):
      sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Greg Kroah-Hartman (1):
      Linux 4.4.299

Hangyu Hua (1):
      phonet: refcount leak in pep_sock_accep

Jedrzej Jagielski (1):
      i40e: Fix incorrect netdev's real number of RX/TX queues

Lixiaokeng (1):
      scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Nathan Chancellor (1):
      power: reset: ltc2952: Fix use of floating point literals

Pavel Skripkin (1):
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Takashi Iwai (1):
      Bluetooth: btusb: Apply QCA Rome patches for some ATH3012 models

Thomas Toye (1):
      rndis_host: support Hytera digital radios

Tom Rix (1):
      mac80211: initialize variable have_higher_than_11mbit

William Zhao (1):
      ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

wolfgang huang (1):
      mISDN: change function names to avoid conflicts

yangxingwu (1):
      net: udp: fix alignment problem in udp4_seq_show()

