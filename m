Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C131E2C7FF9
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgK3Icp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:32:45 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47607 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgK3Icp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:32:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 99321769;
        Mon, 30 Nov 2020 03:31:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 30 Nov 2020 03:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=piYyS8
        OOXvT7f3HEz91TsPh4BCZfnMzFV2M40cp7Gf8=; b=Qxk/NbobfoMdzA2ruyHoiR
        Px+A8wNuehPPRgUSIkjhZ9jjM01DxJSaixC/bjyW/YSSA5aSK1NJuli3VuqFW43u
        IOnfZBAaxKgYugUFFBvR9lOKv0f9XtEwDNae9dAlLUynaJEha5GkmlcNbkDeXsOP
        aWYBbe57+Lf+J1OemwhXqDQfYImh+10iZUutf3Gz5F325sQm+l869r+UImIqYV+8
        X2Z+NUdnUvGQ8U/IEYFhtP/wYpPcQAi54V1lpChd5wJSxDUs5+g0nQ/dpv31SwWN
        Y4A/FMq47tzSDMtbpCNZpdGoHBehxFu3OYLnE/0re3AE7yGECgUQnkP21e20rK9w
        ==
X-ME-Sender: <xms:6q3EXx7px-8eaHwiR6G0z-Zkgpo1iOR18_e9xIdriJI_ftwZQ_ayvQ>
    <xme:6q3EX-5RLed6nifp21Y6wqZdxx-SzcFHO1i-hUn7agYS4KvWIanFyrf1l66Hgw0D_
    4bBiXkzpXX7zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehledguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6q3EX4cOsAgsITFLrcJC0CcXSe3WobeNajKjYaIVq8XIgNJ7qcjDjQ>
    <xmx:6q3EX6LlWptVTe6F0YtUYSymbrzOJ_fXBDOndHwEgUfIUH7G01jpHQ>
    <xmx:6q3EX1IWnznixKjcD5sLqDq_DklTxcBg_qHV87eQjwhKKfD4-7nUuA>
    <xmx:663EXzhDGGXNMIfEI1DBqqJ1aQV1SH8BwjAz17KSzmj7sN_sPritA4H1RI4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CABD3280064;
        Mon, 30 Nov 2020 03:31:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: core: Fix regression in Hercules audio card" failed to apply to 5.4-stable tree
To:     stern@rowland.harvard.edu, bugzilla.kernel.org@mrtoasted.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Nov 2020 09:32:43 +0100
Message-ID: <1606725163049@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

