Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D806324D6D
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhBYKAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235497AbhBYJ63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8796F64F1A;
        Thu, 25 Feb 2021 09:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246891;
        bh=BViO87cLdkLb4nnIj22hLyjnw+zpQKuNU92oSogE66s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEZDT3jNSHOg4MB/YujcsuM1UKta6j4niAI1dPY3QmWb5AuegORxPFnjZiBCcrgpM
         cpwdA5tNzkhh5JDDF3IKb5Tpr0ECSCTWIHNQisi9y+x3T9zOuRFE3ZGnkP+QF0SvAI
         WGX57shJH5bj6IjLkDr+LRE9lQPNfKT2l4K/fCsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 05/23] USB: quirks: sort quirk entries
Date:   Thu, 25 Feb 2021 10:53:36 +0100
Message-Id: <20210225092516.793075315@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 43861d29c0810a70792bf69d37482efb7bb6677d upstream.

Move the last entry to its proper place to maintain the VID/PID sort
order.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210210111746.13360-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -415,6 +415,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },
 
+	/* novation SoundControl XL */
+	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
@@ -495,9 +498,6 @@ static const struct usb_device_id usb_qu
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* novation SoundControl XL */
-	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
-
 	{ }  /* terminating entry must be last */
 };
 


