Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE574485228
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 12:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiAEL60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 06:58:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33634 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbiAEL6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 06:58:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB9B2B81A63;
        Wed,  5 Jan 2022 11:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EEC36AE9;
        Wed,  5 Jan 2022 11:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641383901;
        bh=lNWIkedqAasnqh9OjM0u5E+HuLTuziqkIITaWu8OraA=;
        h=From:To:Cc:Subject:Date:From;
        b=pB19lLbVrGjkO1EvMOZNt4wGldjXDkUr1gBOZ4VWR4VDLliENi46o9j2189nzoC3a
         d6bAtFkgFm16JMSp4rLvXXaAs5szp7ucVPWRtqvACYN5HpScemUIYinkcRydwyXMiZ
         wB9c+l448Hrl7Q5NinJEYqSYbXCYfqsCY2b+P0FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.224
Date:   Wed,  5 Jan 2022 12:58:14 +0100
Message-Id: <1641383894210192@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.224 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt   |    2 
 Makefile                                          |    2 
 drivers/android/binder_alloc.c                    |    2 
 drivers/hid/Kconfig                               |    1 
 drivers/i2c/i2c-dev.c                             |    3 
 drivers/input/joystick/spaceball.c                |   11 +
 drivers/input/mouse/appletouch.c                  |    4 
 drivers/input/serio/i8042-x86ia64io.h             |   21 ++
 drivers/input/serio/i8042.c                       |   54 ++++--
 drivers/net/ethernet/freescale/fman/fman_port.c   |   12 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   11 -
 drivers/net/usb/pegasus.c                         |    4 
 drivers/nfc/st21nfca/i2c.c                        |   29 ++-
 drivers/platform/x86/apple-gmux.c                 |    2 
 drivers/scsi/lpfc/lpfc_debugfs.c                  |    4 
 drivers/scsi/vmw_pvscsi.c                         |    7 
 drivers/tee/tee_shm.c                             |  177 ++++++++--------------
 drivers/usb/gadget/function/f_fs.c                |    9 -
 drivers/usb/host/xhci-pci.c                       |    5 
 drivers/usb/mtu3/mtu3_gadget.c                    |    7 
 include/linux/tee_drv.h                           |    4 
 include/net/sctp/sctp.h                           |    6 
 include/net/sctp/structs.h                        |    3 
 include/uapi/linux/nfc.h                          |    6 
 net/ipv4/af_inet.c                                |   10 -
 net/ipv6/udp.c                                    |    2 
 net/sctp/diag.c                                   |   12 -
 net/sctp/endpointola.c                            |   23 +-
 net/sctp/socket.c                                 |   23 +-
 scripts/recordmcount.pl                           |    2 
 security/selinux/hooks.c                          |    2 
 tools/testing/selftests/net/udpgso.c              |   12 -
 tools/testing/selftests/net/udpgso_bench_tx.c     |    8 
 33 files changed, 267 insertions(+), 213 deletions(-)

Alexey Makhalov (1):
      scsi: vmw_pvscsi: Set residual data length conditionally

Chunfeng Yun (1):
      usb: mtu3: set interval of FS intr and isoc endpoint

Coco Li (2):
      udp: using datalen to cap ipv6 udp max gso segments
      selftests: Calculate udpgso segment count without header adjustment

Dan Carpenter (1):
      scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()

Dmitry V. Levin (1):
      uapi: fix linux/nfc.h userspace compilation errors

Gal Pressman (1):
      net/mlx5e: Fix wrong features assignment in case of error

Greg Kroah-Hartman (1):
      Linux 4.19.224

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

Pavel Skripkin (2):
      i2c: validate user data in compat ioctl
      Input: appletouch - initialize work before device registration

Samuel Čavoj (1):
      Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Takashi Iwai (1):
      Input: i8042 - add deferred probe support

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

wujianguo (1):
      selftests/net: udpgso_bench_tx: fix dst ip argument

