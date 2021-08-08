Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47713E3939
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 08:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhHHGw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 02:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHGw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 02:52:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C1060F4B;
        Sun,  8 Aug 2021 06:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628405528;
        bh=6+HEvmBzHRUb/v9QtV9ZrVOrUTb81snBVUkOT23+m28=;
        h=From:To:Cc:Subject:Date:From;
        b=Mf1279Aqd9awFLWUTKrWR5+oP5tRC4mK1n/3+gAMGLvAPJ9McdUhZCxK+o+Vjd0pq
         NFZ+EzGM7gYkzMwxIDHY/gRPTn1vncmhCu65YD3FiN4riSAJr9iQQE/IP3n2B+8Yrg
         bVdnJhlw3sWJp4iIrleVbKwGVuX07T2perVJYI48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.279
Date:   Sun,  8 Aug 2021 08:52:04 +0200
Message-Id: <1628405524248245@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.279 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 drivers/net/usb/r8152.c            |    3 ++-
 fs/btrfs/compression.c             |    2 +-
 include/linux/mfd/rt5033-private.h |    4 ++--
 net/bluetooth/hci_core.c           |   16 ++++++++--------
 net/can/raw.c                      |   20 ++++++++++++++++++--
 net/core/skbuff.c                  |    5 ++++-
 7 files changed, 36 insertions(+), 16 deletions(-)

Axel Lin (1):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Goldwyn Rodrigues (1):
      btrfs: mark compressed range uptodate only if all bio succeed

Greg Kroah-Hartman (2):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Linux 4.4.279

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Takashi Iwai (1):
      r8152: Fix potential PM refcount imbalance

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

