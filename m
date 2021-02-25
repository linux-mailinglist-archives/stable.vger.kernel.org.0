Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F44324D94
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhBYKGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234563AbhBYKBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FEE064F2F;
        Thu, 25 Feb 2021 09:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246969;
        bh=BViO87cLdkLb4nnIj22hLyjnw+zpQKuNU92oSogE66s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzoYHmYibWF/U0IdZNRFXPGs5gRfVqPGqryaQTqHL7N9WRXLI1Qs4Spg9G/8EaPNb
         trjYYRz2fSRVFPt2LKm5jwtQvM7Z0cEMdjTmribXUOZrQwzlWG7dUo5a7+s1GBULKt
         dgkAKRihcfutqTVD0ZDN0bpBGW3ZWsDo1O88Hfto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 03/17] USB: quirks: sort quirk entries
Date:   Thu, 25 Feb 2021 10:53:48 +0100
Message-Id: <20210225092515.175465337@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
References: <20210225092515.001992375@linuxfoundation.org>
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
 


