Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5173FFC81
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348549AbhICJCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234865AbhICJCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4781C6069E;
        Fri,  3 Sep 2021 09:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659671;
        bh=hdIBc+hyNTHkGTRZ1vB/NxT9+LU9E+D/Dq3hwcpVfq0=;
        h=From:To:Cc:Subject:Date:From;
        b=RNto9gtyKZVH79M0w6kGKc3uIrfjCT8GTWC0mZf/v34ItQrEitA+HkKRj+WcEELtl
         RqNW9FZCInI3ScRtm45Mf6nG7dEIyVS//qLMSZBxk8L6LBehdV1ZzVOZRWEW2HqamK
         R/vbpOmYCPhE3cqFMTTB9OwzIpRgVK15hRuAy1Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.283
Date:   Fri,  3 Sep 2021 11:01:08 +0200
Message-Id: <163065966817856@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.283 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 +-
 drivers/block/floppy.c                      |   27 +++++++++++++--------------
 drivers/net/can/usb/esd_usb2.c              |    4 ++--
 drivers/net/ethernet/intel/e1000e/ich8lan.c |   14 +++++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |    3 +++
 drivers/net/ethernet/marvell/mvneta.c       |    2 +-
 drivers/tty/vt/vt_ioctl.c                   |   11 +++++++----
 drivers/usb/serial/ch341.c                  |    1 -
 drivers/usb/serial/option.c                 |    2 ++
 drivers/vhost/vringh.c                      |    2 +-
 drivers/video/fbdev/core/fbmem.c            |    4 ++++
 drivers/virtio/virtio_ring.c                |    6 ++++--
 12 files changed, 51 insertions(+), 27 deletions(-)

Denis Efremov (1):
      Revert "floppy: reintroduce O_NDELAY fix"

George Kennedy (1):
      fbmem: add margin check to fb_check_caps()

Greg Kroah-Hartman (1):
      Linux 4.4.283

Johan Hovold (1):
      Revert "USB: serial: ch341: fix character loss at high transfer rates"

Linus Torvalds (1):
      vt_kdsetmode: extend console locking

Maxim Kiselev (1):
      net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Neeraj Upadhyay (1):
      vringh: Use wiov->used to check for read/write desc order

Parav Pandit (1):
      virtio: Improve vq->broken access to avoid any compiler optimization

Sasha Neftin (1):
      e1000e: Fix the max snoop/no-snoop latency for 10M

Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Zhengjun Zhang (1):
      USB: serial: option: add new VID/PID to support Fibocom FG150

