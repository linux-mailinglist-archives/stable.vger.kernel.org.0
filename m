Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65500359ED
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfFEJxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 05:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbfFEJxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 05:53:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B85A206B8;
        Wed,  5 Jun 2019 09:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559728420;
        bh=BPT+fsCIustpkh0/ujYhsvBc80RxtJmJZP+ZtCKYDdk=;
        h=Subject:To:From:Date:From;
        b=lIMcLLusC6a/Yt1t+9Vx+bFqkWwpC1q55INcZ2zgPIVaXnP0YnUF5Z0VRPXUWmXDY
         8xO35lqeHVFyMFtK0eeOrcKyISRlByjX1Puj+OBDFFi1mfrTVw8uHm16hkVbjsiiCu
         Un+6Dma7pU/WsWcH6Dl2Ua+60O+XELPGVNtSt/MA=
Subject: patch "USB: usb-storage: Add new ID to ums-realtek" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 05 Jun 2019 11:53:38 +0200
Message-ID: <1559728418199135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usb-storage: Add new ID to ums-realtek

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1a6dd3fea131276a4fc44ae77b0f471b0b473577 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Tue, 4 Jun 2019 00:20:49 +0800
Subject: USB: usb-storage: Add new ID to ums-realtek

There is one more Realtek card reader requires ums-realtek to work
correctly.

Add the device ID to support it.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_realtek.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/storage/unusual_realtek.h b/drivers/usb/storage/unusual_realtek.h
index 6b2140f966ef..7e14c2d7cf73 100644
--- a/drivers/usb/storage/unusual_realtek.h
+++ b/drivers/usb/storage/unusual_realtek.h
@@ -17,6 +17,11 @@ UNUSUAL_DEV(0x0bda, 0x0138, 0x0000, 0x9999,
 		"USB Card Reader",
 		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
+UNUSUAL_DEV(0x0bda, 0x0153, 0x0000, 0x9999,
+		"Realtek",
+		"USB Card Reader",
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
+
 UNUSUAL_DEV(0x0bda, 0x0158, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-- 
2.21.0


