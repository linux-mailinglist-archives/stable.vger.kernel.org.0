Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FA548520B
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 12:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbiAELw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 06:52:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52668 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiAELwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 06:52:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F507616FC;
        Wed,  5 Jan 2022 11:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D63C36AE9;
        Wed,  5 Jan 2022 11:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641383535;
        bh=FfXOvgk2bUAggKH2l0QklGKxC4yrS+s9jrmW/bZ9GVs=;
        h=From:To:Cc:Subject:Date:From;
        b=bwtM6s7loanpUTFFBnM6eJFdVjUesgqYzPXyetUUnnka+6Jho/TtqH+Y2Di5LwTLg
         sI1pL8TzogltsQ47p0Foz2tdNyFgAsZsgmKV/MA1NOFJshLZdZ7pGAlfbkYdK8emac
         xpS1YHuH70uk7ZVJzXfg73GrEfidpuotAztDTxPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.296
Date:   Wed,  5 Jan 2022 12:52:08 +0100
Message-Id: <164138352914056@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.296 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 +-
 drivers/hid/Kconfig                             |    1 +
 drivers/input/joystick/spaceball.c              |   11 +++++++++--
 drivers/input/mouse/appletouch.c                |    4 ++--
 drivers/net/ethernet/freescale/fman/fman_port.c |   12 +++++++-----
 drivers/platform/x86/apple-gmux.c               |    2 +-
 drivers/scsi/vmw_pvscsi.c                       |    7 +++++--
 drivers/usb/gadget/function/f_fs.c              |    9 ++++++---
 drivers/usb/host/xhci-pci.c                     |    5 ++++-
 include/uapi/linux/nfc.h                        |    6 +++---
 net/ipv4/af_inet.c                              |   10 ++++------
 scripts/recordmcount.pl                         |    2 +-
 security/selinux/hooks.c                        |    2 +-
 13 files changed, 45 insertions(+), 28 deletions(-)

Alexey Makhalov (1):
      scsi: vmw_pvscsi: Set residual data length conditionally

Dmitry V. Levin (1):
      uapi: fix linux/nfc.h userspace compilation errors

Greg Kroah-Hartman (1):
      Linux 4.9.296

Hans de Goede (1):
      HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option

Heiko Carstens (1):
      recordmcount.pl: fix typo in s390 mcount regex

Krzysztof Kozlowski (1):
      nfc: uapi: use kernel size_t to fix user-space builds

Leo L. Schwab (1):
      Input: spaceball - fix parsing of movement data packets

Mathias Nyman (1):
      xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Miaoqian Lin (1):
      fsl/fman: Fix missing put_device() call in fman_port_probe

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

