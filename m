Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D582C7FF5
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgK3Ic2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:32:28 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50093 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbgK3Ic2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:32:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9F87A8D5;
        Mon, 30 Nov 2020 03:31:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 30 Nov 2020 03:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bQhUVe
        HnwHrVB1pMP+LeOoqu8c8fOW2cyO60qmDsjRU=; b=daTArjXQF/OnKle/0Oh2wX
        i5kxh8owWO5X4EqFEpb+kZa4+ZUX7snQVmR7SgLlERnTCJMOzv4Zf/gA4YkOlE+k
        2D903zrS+RKLHA788YbxfIG8MFK1kslC+v0/FWhUgM6JklXKa1s6acD2Ia/KDlou
        4mMd8APC2Sz/DPfT0XiiKTBLH6/V/x90xxDpHu4SmxZQGgxWNr0wYVbCoCsa5Knr
        yypzbAcElc9h9UJw0wRsiW0QiUUqYi5TdrKF0AWLWH86lRV4ypUIABJ6r7DERc0L
        idK1GUzGeqzmVksj5FpOClMtaxiFW7wZJsKA5BIqCEW2CheEpWIvUyuav2/ebDsA
        ==
X-ME-Sender: <xms:7q3EX9dyFtfFWxvh7rezXB28hulSn-yKd7wOQL-mLFl1xycKxXMF3g>
    <xme:7q3EX7Mr5ldbH7Dg-sKvFfOYfxyzhT2xsKvr8I6OvmyehGSsnFw_U0ZHm9qvM3mB1
    BD8miLoCeUEjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehledguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7q3EX2jFp7JAKmwVlcLbv25togejQvpFn55sXfD2cvpjE-5VqKALQA>
    <xmx:7q3EX2_pjT0Yptx_BhHzDi963_ycuvqyTKCp-yUIV225GYWOfYhhXA>
    <xmx:7q3EX5vivWW4lEGp9Tb8ZAJNiKcTPno6ZGnAg5YelkqyBEzElBp8Eg>
    <xmx:7q3EX6UTqdzXDusYDhlHT5Fq0RqHHsKKCgJLbUKU3cdWMj6hgiPn6M5tJ5U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E03EA328005A;
        Mon, 30 Nov 2020 03:31:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: core: Fix regression in Hercules audio card" failed to apply to 4.14-stable tree
To:     stern@rowland.harvard.edu, bugzilla.kernel.org@mrtoasted.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Nov 2020 09:32:45 +0100
Message-ID: <160672516553144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 184eead057cc7e803558269babc1f2cfb9113ad1 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 19 Nov 2020 12:00:40 -0500
Subject: [PATCH] USB: core: Fix regression in Hercules audio card

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

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f536ea9fe945..fad31ccd1fa8 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -348,6 +348,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Guillemot Hercules DJ Console audio card (BZ 208357) */
+	{ USB_DEVICE(0x06f8, 0xb000), .driver_info =
+			USB_QUIRK_ENDPOINT_IGNORE },
+
 	/* Midiman M-Audio Keystation 88es */
 	{ USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
 
@@ -525,6 +529,8 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
  * Matched for devices with USB_QUIRK_ENDPOINT_IGNORE.
  */
 static const struct usb_device_id usb_endpoint_ignore[] = {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x01 },
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x81 },
 	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info = 0x85 },
 	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0208, 1), .driver_info = 0x85 },
 	{ }

