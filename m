Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5A1AC661
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgDPOim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730620AbgDPOCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D96F217D8;
        Thu, 16 Apr 2020 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045755;
        bh=eVpf3emQcJsfXdpiAQF8X/wna/+epGORT9/dzxHCv+4=;
        h=Subject:To:From:Date:From;
        b=upFiZw/63/Sn5CNGr0FaOQfex4mbJwSxRYlpgFwLWt+e6raIjHM7P+TlQWGSGT5kN
         UkkHoU74pu2lzgRa5Cz4uVwIDTAM9750TPx8q18KKnawYikRsBHNFbj0kLhHCqKcqs
         8nc6GO9VcuM+iFjhlPmNO46t+jJ2wSrqhhJ1tOUc=
Subject: patch "USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for" added to usb-linus
To:     jonathan@jdcox.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 15:28:42 +0200
Message-ID: <1587043722105255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From be34a5854b4606bd7a160ad3cb43415d623596c7 Mon Sep 17 00:00:00 2001
From: Jonathan Cox <jonathan@jdcox.net>
Date: Fri, 10 Apr 2020 14:24:27 -0700
Subject: USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for
 Corsair K70 RGB RAPIDFIRE

The Corsair K70 RGB RAPIDFIRE needs the USB_QUIRK_DELAY_INIT and
USB_QUIRK_DELAY_CTRL_MSG to function or it will randomly not
respond on boot, just like other Corsair keyboards

Signed-off-by: Jonathan Cox <jonathan@jdcox.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200410212427.2886-1-jonathan@jdcox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index da30b5664ff3..3e8efe759c3e 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -430,6 +430,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Corsair K70 LUX */
 	{ USB_DEVICE(0x1b1c, 0x1b36), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Corsair K70 RGB RAPDIFIRE */
+	{ USB_DEVICE(0x1b1c, 0x1b38), .driver_info = USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_DELAY_CTRL_MSG },
+
 	/* MIDI keyboard WORLDE MINI */
 	{ USB_DEVICE(0x1c75, 0x0204), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
-- 
2.26.1


