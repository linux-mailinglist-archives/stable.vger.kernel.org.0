Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF9485223
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 12:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiAEL6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 06:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiAEL6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 06:58:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06358C061761;
        Wed,  5 Jan 2022 03:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8A43B81A62;
        Wed,  5 Jan 2022 11:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3249C36AEB;
        Wed,  5 Jan 2022 11:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641383893;
        bh=B1IYSyvF2scAf84JeSBuTkWSlKvo81R897HWHhyCfTE=;
        h=From:To:Cc:Subject:Date:From;
        b=oitlWgzyXRuY7Pc04nBuMzKqgeglzSpoNEC//hvC3Nz0+BUSS6slH+CkmCXKN36KR
         G/EH/RY8rL2HmuS3c7JiOYbZklkGunL1tBwDrT7A75YP0wqLpZNK3+RLvWdqK44A+Z
         EugEtzu4RYD87bA6aPi0XYnqcrF/hLfWXfOk/yOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.261
Date:   Wed,  5 Jan 2022 12:58:09 +0100
Message-Id: <164138388915177@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.261 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 drivers/android/binder_alloc.c                  |    2 
 drivers/hid/Kconfig                             |    1 
 drivers/input/joystick/spaceball.c              |   11 +
 drivers/input/mouse/appletouch.c                |    4 
 drivers/net/ethernet/freescale/fman/fman_port.c |   12 +
 drivers/net/usb/pegasus.c                       |    4 
 drivers/nfc/st21nfca/i2c.c                      |   29 +++-
 drivers/platform/x86/apple-gmux.c               |    2 
 drivers/scsi/lpfc/lpfc_debugfs.c                |    4 
 drivers/scsi/vmw_pvscsi.c                       |    7 -
 drivers/tee/tee_private.h                       |    4 
 drivers/tee/tee_shm.c                           |  155 +++++++++---------------
 drivers/usb/gadget/function/f_fs.c              |    9 -
 drivers/usb/host/xhci-pci.c                     |    5 
 include/net/sctp/sctp.h                         |    6 
 include/net/sctp/structs.h                      |    3 
 include/uapi/linux/nfc.h                        |    6 
 net/ipv4/af_inet.c                              |   10 -
 net/sctp/endpointola.c                          |   23 ++-
 net/sctp/sctp_diag.c                            |   12 -
 net/sctp/socket.c                               |   23 ++-
 scripts/recordmcount.pl                         |    2 
 security/selinux/hooks.c                        |    2 
 24 files changed, 174 insertions(+), 164 deletions(-)

Alexey Makhalov (1):
      scsi: vmw_pvscsi: Set residual data length conditionally

Dan Carpenter (1):
      scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()

Dmitry V. Levin (1):
      uapi: fix linux/nfc.h userspace compilation errors

Greg Kroah-Hartman (1):
      Linux 4.14.261

Hans de Goede (1):
      HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option

Heiko Carstens (1):
      recordmcount.pl: fix typo in s390 mcount regex

Jens Wiklander (1):
      tee: handle lookup of shm with reference count 0

Krzysztof Kozlowski (1):
      nfc: uapi: use kernel size_t to fix user-space builds

Leo L. Schwab (1):
      Input: spaceball - fix parsing of movement data packets

Mathias Nyman (1):
      xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Matthias-Christian Ott (1):
      net: usb: pegasus: Do not drop long Ethernet frames

Miaoqian Lin (1):
      fsl/fman: Fix missing put_device() call in fman_port_probe

Muchun Song (1):
      net: fix use-after-free in tw_timer_handler

Pavel Skripkin (1):
      Input: appletouch - initialize work before device registration

Todd Kjos (1):
      binder: fix async_free_space accounting for empty parcels

Tom Rix (1):
      selinux: initialize proto variable in selinux_ip_postroute_compat()

Vincent Pelletier (1):
      usb: gadget: f_fs: Clear ffs_eventfd in ffs_data_clear.

Wang Qing (1):
      platform/x86: apple-gmux: use resource_size() with res

Wei Yongjun (1):
      NFC: st21nfca: Fix memory leak in device probe and remove

Xin Long (1):
      sctp: use call_rcu to free endpoint

