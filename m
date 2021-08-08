Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9153E393D
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 08:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhHHGwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 02:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhHHGwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 02:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D070260F42;
        Sun,  8 Aug 2021 06:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628405535;
        bh=mfTlJliaJoSsnTFmq6NKOjiBmoFJ4cSUJbe9aXahcIA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZgNHJjvZxkwx0l4Y9LsqnbUGqOb5KXmQ5oDUUDHmwMaisxZ2pPSHSycl5cnopp8ZJ
         FJyH+5xAlN3PUMzmxRKbJnFaflSlfAjs3Yh55ply5CIr0DR5BYgAENlGhDvhkv/oHV
         skwjez33n5/bh4a+k2CxMRULpMOF5OZnWxgEMzN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.279
Date:   Sun,  8 Aug 2021 08:52:09 +0200
Message-Id: <1628405529193137@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.279 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 drivers/net/usb/r8152.c            |    3 ++-
 drivers/spi/spi-mt65xx.c           |   19 +++++--------------
 fs/btrfs/compression.c             |    2 +-
 include/linux/mfd/rt5033-private.h |    4 ++--
 net/bluetooth/hci_core.c           |   16 ++++++++--------
 net/can/raw.c                      |   20 ++++++++++++++++++--
 net/core/skbuff.c                  |    5 ++++-
 8 files changed, 41 insertions(+), 30 deletions(-)

Axel Lin (1):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Goldwyn Rodrigues (1):
      btrfs: mark compressed range uptodate only if all bio succeed

Greg Kroah-Hartman (2):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Linux 4.9.279

Guenter Roeck (1):
      spi: mediatek: Fix fifo transfer

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Takashi Iwai (1):
      r8152: Fix potential PM refcount imbalance

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

