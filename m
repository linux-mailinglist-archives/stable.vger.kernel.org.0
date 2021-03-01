Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DF32860B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbhCARC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236503AbhCAQ4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:56:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B76264FD5;
        Mon,  1 Mar 2021 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616568;
        bh=BViO87cLdkLb4nnIj22hLyjnw+zpQKuNU92oSogE66s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNbA9Q1o091XhDpKNMQeT+jBdIg9XKVLLML8xv7UQJ7IpsPvpSfthXixHq8JjQLNk
         lA/gCN0AnWZCqJXqhhUm+VnGLx81+Bzj1sbc28j2rsQ0E5l+zvEUAeBqFz+dtb+Nfb
         O7QqvtQ0v4WLi8ejvKwiJsnVPZ5uYbLmE1FB01ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 002/247] USB: quirks: sort quirk entries
Date:   Mon,  1 Mar 2021 17:10:22 +0100
Message-Id: <20210301161031.806451967@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
 


