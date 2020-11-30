Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBFB2C8C36
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387986AbgK3SJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 13:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387982AbgK3SJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 13:09:26 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1A9C0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 10:08:45 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o1so3475125wrx.7
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 10:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T56gbeYCftYGePbSoTOrUz5w0EF1B8H+vLb2k1iCGrA=;
        b=HMbQwgSihXLormglawvupODIwKNWPnKF4i48iJLNpxdMr3AhKeA0eHMKNnQ1X2WOWf
         nbrMH0W0L8pIpNH4tpkbAzVSdHrhOQoYVs1uuxQi0Gm9W3iVyb4HYlLqhza4WH2cSs1r
         IsBGIKVwgAUzM9kYycW44GPx2Gc1Hudgejzitd6BlP2VvspEP1VKsIfFAqyYEMAT4yhY
         MPqlwG4RMmWa8MzRmqT3z8kVWW3HEOZdEg7aBXsqt09F9kSI54mRwaX2UbNHaFYcro7q
         cAzW7Lpbtv9/OvYyqJnnD1KQeqyAGrpHkzDDOWoX2fYUk1ecpAxac3u2f/P9TUPUPGWa
         XyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T56gbeYCftYGePbSoTOrUz5w0EF1B8H+vLb2k1iCGrA=;
        b=TJy9RYcYExog3OV1gMX169x5lGN5F+7Ql56dBgqjTFTArN74bvmPMqT6ZygxS+3jOW
         oB/S6P6SNcG+27xO72Bm5ghBdhq3XJFHUnVbhQu8GE01G4qsh+m0NxIO2jfK9sB+uLDU
         /h75IFZldGIUKoDjbZ7yJaiq4A853kdR0QtvfH0mP1Whn2VkPeTO7NvRo1bOQlDjrZnh
         ep0ADUYLle6yr1keEPiKEx3KBNfW4K7sJiBjMuW7bHkZKSJ3zRqvg4ZLhGeN7VcXwqM4
         P+kyVosOUDFhj8LbMpaM8NdJanaOZE0vwAHJdkYyXKwNkJjUp7Hw1keUua5NgTPKVT9R
         T5FQ==
X-Gm-Message-State: AOAM532DH6t9Ak5kNXVxzTSdBteANTIU/g7Iv8fHBDb3qlQW6e1dLFo9
        WPMZhtPJBeP+dAbITtJvEIzgDPPiXS4WXQ==
X-Google-Smtp-Source: ABdhPJwb9sg/gqBAnZvTMjGM4aRMHcxqaXpDKWo+EhWYS8in88zDHde7TPR45ZzZ9YookC2JRaAqWg==
X-Received: by 2002:a5d:4c8d:: with SMTP id z13mr25026824wrs.248.1606759724215;
        Mon, 30 Nov 2020 10:08:44 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id f199sm128436wme.15.2020.11.30.10.08.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Nov 2020 10:08:43 -0800 (PST)
Date:   Mon, 30 Nov 2020 18:08:41 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stern@rowland.harvard.edu, bugzilla.kernel.org@mrtoasted.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: core: Fix regression in Hercules
 audio card" failed to apply to 5.4-stable tree
Message-ID: <20201130180841.4umfwcvw5smnqbwk@debian>
References: <1606725163049@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sykpgbw7zdgkrddt"
Content-Disposition: inline
In-Reply-To: <1606725163049@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sykpgbw7zdgkrddt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 30, 2020 at 09:32:43AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply to 4.19-stable.

--
Regards
Sudip

--sykpgbw7zdgkrddt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-USB-core-Fix-regression-in-Hercules-audio-card.patch"

From c70b96d62c5d9fd23b7bb0ba174efe45c0afd0e1 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 19 Nov 2020 12:00:40 -0500
Subject: [PATCH] USB: core: Fix regression in Hercules audio card

commit 184eead057cc7e803558269babc1f2cfb9113ad1 upstream

Commit 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
aimed to make the USB stack more reliable by detecting and skipping
over endpoints that are duplicated between interfaces.  This caused a
regression for a Hercules audio card (reported as Bugzilla #208357),
which contains such non-compliant duplications.  Although the
duplications are harmless, skipping the valid endpoints prevented the
device from working.

This patch fixes the regression by adding ENDPOINT_IGNORE quirks for
the Hercules card, telling the kernel to ignore the invalid duplicate
endpoints and thereby allowing the valid endpoints to be used as
intended.

Fixes: 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
CC: <stable@vger.kernel.org>
Reported-by: Alexander Chalikiopoulos <bugzilla.kernel.org@mrtoasted.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201119170040.GA576844@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: use usb_endpoint_blacklist and USB_QUIRK_ENDPOINT_BLACKLIST]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/core/quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 0f80195d0109..b55c3a699fc6 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -348,6 +348,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Guillemot Hercules DJ Console audio card (BZ 208357) */
+	{ USB_DEVICE(0x06f8, 0xb000), .driver_info =
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Midiman M-Audio Keystation 88es */
 	{ USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
 
@@ -525,6 +529,8 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
  * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
  */
 static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x01 },
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x81 },
 	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info = 0x85 },
 	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0208, 1), .driver_info = 0x85 },
 	{ }
-- 
2.11.0


--sykpgbw7zdgkrddt--
