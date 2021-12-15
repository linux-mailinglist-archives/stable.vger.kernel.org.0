Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02647660C
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 23:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhLOWms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 17:42:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58372 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhLOWms (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 17:42:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 132E8B82214
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 22:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D75DC36AE3;
        Wed, 15 Dec 2021 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639608165;
        bh=EzcrW38sobws5L6NIH06cpgULlNZuW/lpVmO3dTpuqM=;
        h=Subject:To:From:Date:From;
        b=t72Ve2SQE/o8D5nbceAkB7U5xzUBLPqKoB/NShJA5MmxXYMqmfQcYN5cGsQKkWo1d
         yAZLR20JEJK8AqN3wirp2lZcacfViWTuOqNSLX868QkiaFatIWk14jkLV9WpwtoT0Q
         8jNZcwNP3sU5G2IBPcgIdZ5r+7p/hML4iZAVz5rg=
Subject: patch "USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)" added to usb-linus
To:     wangjm221@gmail.com, gregkh@linuxfoundation.org,
        markpearson@lenovo.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 23:42:43 +0100
Message-ID: <1639608163180111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0ad3bd562bb91853b9f42bda145b5db6255aee90 Mon Sep 17 00:00:00 2001
From: Jimmy Wang <wangjm221@gmail.com>
Date: Tue, 14 Dec 2021 09:26:50 +0800
Subject: USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

This device doesn't work well with LPM, losing connectivity intermittently.
Disable LPM to resolve the issue.

Reviewed-by: <markpearson@lenovo.com>
Signed-off-by: Jimmy Wang <wangjm221@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211214012652.4898-1-wangjm221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 019351c0b52c..d3c14b5ed4a1 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -434,6 +434,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
+	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Lenovo Powered USB-C Travel Hub (4X90S92381, RTL8153 GigE) */
 	{ USB_DEVICE(0x17ef, 0x721e), .driver_info = USB_QUIRK_NO_LPM },
 
-- 
2.34.1


