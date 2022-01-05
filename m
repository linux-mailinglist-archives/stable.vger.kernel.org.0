Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96309485207
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 12:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbiAELwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 06:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239802AbiAELwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 06:52:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4DFC061761;
        Wed,  5 Jan 2022 03:52:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3943616FC;
        Wed,  5 Jan 2022 11:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A828C36AE9;
        Wed,  5 Jan 2022 11:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641383528;
        bh=hFLrBTXj3p7wL2USvxsahbOevxgKqsL6wAfMq2NoC+8=;
        h=From:To:Cc:Subject:Date:From;
        b=vA5DpR4EODKwr6wFtwvOdwYB0lbhKr96uJbNdXOF+4g0R8x4LY82vzyoJPYUdcveB
         3adyDDmO8TreuzF8f8myZVKbSc3AQGYsEDtw6e1qgCUFhcmqJRb7bdTgYnl/DOHjHa
         xduQR7Ajv9SJ2plOMGs5npectLAdpxwgUs5cScVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.298
Date:   Wed,  5 Jan 2022 12:52:03 +0100
Message-Id: <1641383524120143@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.298 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 drivers/input/joystick/spaceball.c |   11 +++++++++--
 drivers/input/mouse/appletouch.c   |    4 ++--
 drivers/platform/x86/apple-gmux.c  |    2 +-
 drivers/scsi/vmw_pvscsi.c          |    7 +++++--
 drivers/usb/gadget/function/f_fs.c |    9 ++++++---
 drivers/usb/host/xhci-pci.c        |    5 ++++-
 include/uapi/linux/nfc.h           |    6 +++---
 net/ipv4/af_inet.c                 |   10 ++++------
 scripts/recordmcount.pl            |    2 +-
 security/selinux/hooks.c           |    2 +-
 11 files changed, 37 insertions(+), 23 deletions(-)

Alexey Makhalov (1):
      scsi: vmw_pvscsi: Set residual data length conditionally

Dmitry V. Levin (1):
      uapi: fix linux/nfc.h userspace compilation errors

Greg Kroah-Hartman (1):
      Linux 4.4.298

Heiko Carstens (1):
      recordmcount.pl: fix typo in s390 mcount regex

Krzysztof Kozlowski (1):
      nfc: uapi: use kernel size_t to fix user-space builds

Leo L. Schwab (1):
      Input: spaceball - fix parsing of movement data packets

Mathias Nyman (1):
      xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Muchun Song (1):
      net: fix use-after-free in tw_timer_handler

Pavel Skripkin (1):
      Input: appletouch - initialize work before device registration

Tom Rix (1):
      selinux: initialize proto variable in selinux_ip_postroute_compat()

Vincent Pelletier (1):
      usb: gadget: f_fs: Clear ffs_eventfd in ffs_data_clear.

Wang Qing (1):
      platform/x86: apple-gmux: use resource_size() with res

