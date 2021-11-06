Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9B9446E1F
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhKFNm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234300AbhKFNmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 09:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B351060296;
        Sat,  6 Nov 2021 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636206012;
        bh=eZs4/2XFDKEYZQR1I6r+Z1MnfyB4YNtMVJ8z6/NhgjA=;
        h=From:To:Cc:Subject:Date:From;
        b=U+paJomwuwYSIoosjW3fZPskHMUvprW8PREqU6MKJ1ei32YQIPkN58fZOU3kDtHmY
         BcXVv1IM41Lo3A8PqG6DWO/7iC3RPsWmPifTsWZ6ZHx1AsvVPEa+ZKEjgdNenNIivn
         5sObVbXxo3Al9bIhCk+jGqk9tzTKXAwT0wCeerUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.78
Date:   Sat,  6 Nov 2021 14:40:03 +0100
Message-Id: <163620600339221@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.78 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 drivers/amba/bus.c                            |    3 --
 drivers/gpu/drm/ttm/ttm_bo_util.c             |    1 
 drivers/media/firewire/firedtv-avc.c          |   14 +++++++++---
 drivers/media/firewire/firedtv-ci.c           |    2 +
 drivers/net/ethernet/microchip/lan743x_main.c |   10 +++++---
 drivers/net/ethernet/sfc/ethtool_common.c     |   10 +-------
 drivers/net/vrf.c                             |    4 ---
 drivers/net/wireless/ath/wcn36xx/main.c       |   10 --------
 drivers/net/wireless/ath/wcn36xx/pmc.c        |    5 ----
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h    |    1 
 drivers/scsi/scsi.c                           |    4 ++-
 drivers/scsi/scsi_sysfs.c                     |    9 ++++++++
 drivers/usb/core/hcd.c                        |   29 +++++---------------------
 drivers/usb/host/xhci.c                       |    1 
 fs/io_uring.c                                 |    3 +-
 include/linux/usb/hcd.h                       |    2 -
 mm/khugepaged.c                               |   17 ++++++++-------
 sound/usb/mixer_maps.c                        |    8 +++++++
 19 files changed, 61 insertions(+), 74 deletions(-)

Bryan O'Donoghue (1):
      Revert "wcn36xx: Disable bmps when encryption is disabled"

Dan Carpenter (1):
      media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Erik Ekman (1):
      sfc: Fix reading non-legacy supported link modes

Eugene Crosser (1):
      vrf: Revert "Reset skb conntrack connection..."

Greg Kroah-Hartman (4):
      Revert "xhci: Set HCD flag to defer primary roothub registration"
      Revert "usb: core: hcd: Add support for deferring roothub registration"
      Revert "drm/ttm: fix memleak in ttm_transfered_destroy"
      Linux 5.10.78

Lee Jones (1):
      Revert "io_uring: reinforce cancel on flush during exit"

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Takashi Iwai (2):
      ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
      ALSA: usb-audio: Add Audient iD14 to mixer map quirk table

Wang Kefeng (1):
      ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Yang Shi (1):
      mm: khugepaged: skip huge page collapse for special files

Yuiko Oshino (1):
      net: ethernet: microchip: lan743x: Fix skb allocation failure

