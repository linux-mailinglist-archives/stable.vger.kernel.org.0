Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485DA2C8D04
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgK3SkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 13:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgK3SkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 13:40:19 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93937C0613D4
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 10:39:38 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t4so17508832wrr.12
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 10:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GfbEIzkXMgoRAyVKo7th13aA2TlRGnaf9KeZ+rNcoQ0=;
        b=pTKsiWO+6EcmEbeg8wJA9gYlB8DybUCzPZnlGHXLwHvLJQi9E7kfBV6Zlwa80CW/NK
         FVBTNlQS41xjS1iRJ+Jh0Mecn70hA9kOhNEi4vovNOBZWuJTMnz6JQIwQq1rZK0wEQQ/
         GrM0jO/KNH4SDlxrH3YZGtAsMTe7+bAVMiA4Wm0PL6LQmeP279WPCbZSV99Z09aCRDeK
         r1M4ITt+UeqyhA7GXBhHWRGXmUzvBXuZIzdUS+PtSe0FJTiFzM2xxw879dYHc+ZVaUtM
         PvYp+Y0Lsl4z6Oz6VN6mIM0XwxN/hj5jblmvG2NtTLpbSaWQwwYZ/+WNJLWyLcguyyU/
         gtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GfbEIzkXMgoRAyVKo7th13aA2TlRGnaf9KeZ+rNcoQ0=;
        b=MbLLe3Wtg+n8fDh0ipTOsyjhYYIlNeIMPRE/rxVp0N2JoGcwV8YT2AS8mF+qPDvcs8
         saK159V981U2QycW+HL4pnBhRu22K2zp+qWzrWxQrLF/nylBYJ4yeE6yfofNLSz5QbOf
         /X3oeX3N6OiJLu152yk4j7l9eUojiaydX9kMSmLy5gNvX2jzjRiJBNL9nTH2v8Yt/lIT
         OxFGfT3eTc14XYWkZgM569vtNylsqopyxWWUN2sLHGGk84/YKkOzBuo9g+F7Oxk4QAw2
         cMCRhLiBqITO0i3Hm4GJN+qvfUr6ZkDlsDwSvB9FGFByghLxonHq7kz7g3sJPMpL9c34
         v0aA==
X-Gm-Message-State: AOAM532vATP83GpDwqFWuiXSYRtR4uRk0eIBf0tgl9h4ot3PozOekRlu
        TX4b4Tz3rKqfkZ1tjG1Wxnw=
X-Google-Smtp-Source: ABdhPJwgoJ5uFFHERvE1Y8mC3ayW364u7rVXwJ34DDH1vX1tOpMf7xC3X1Lf+A87y72GIkW6Te60BA==
X-Received: by 2002:a5d:6852:: with SMTP id o18mr29764165wrw.336.1606761577344;
        Mon, 30 Nov 2020 10:39:37 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id v20sm194448wml.34.2020.11.30.10.39.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Nov 2020 10:39:36 -0800 (PST)
Date:   Mon, 30 Nov 2020 18:39:35 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stern@rowland.harvard.edu, bugzilla.kernel.org@mrtoasted.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: core: Fix regression in Hercules
 audio card" failed to apply to 4.14-stable tree
Message-ID: <20201130183935.jekxnuugxntadd6n@debian>
References: <160672516553144@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x2hflnts4yosupt4"
Content-Disposition: inline
In-Reply-To: <160672516553144@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x2hflnts4yosupt4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 30, 2020 at 09:32:45AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport which will also need:
73f8bda9b5dc ("USB: core: add endpoint-blacklist quirk") and that backport
also attached.

--
Regards
Sudip

--x2hflnts4yosupt4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-USB-core-add-endpoint-blacklist-quirk.patch"

From 8f9b698f148c1308961d40e2e40c1369943e05ae Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 3 Feb 2020 16:38:28 +0100
Subject: [PATCH 1/2] USB: core: add endpoint-blacklist quirk

commit 73f8bda9b5dc1c69df2bc55c0cbb24461a6391a9 upstream

Add a new device quirk that can be used to blacklist endpoints.

Since commit 3e4f8e21c4f2 ("USB: core: fix check for duplicate
endpoints") USB core ignores any duplicate endpoints found during
descriptor parsing.

In order to handle devices where the first interfaces with duplicate
endpoints are the ones that should have their endpoints ignored, we need
to add a blacklist.

Tested-by: edes <edes@gmx.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200203153830.26394-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/core/config.c  | 11 +++++++++++
 drivers/usb/core/quirks.c  | 32 ++++++++++++++++++++++++++++++++
 drivers/usb/core/usb.h     |  3 +++
 include/linux/usb/quirks.h |  3 +++
 4 files changed, 49 insertions(+)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 7df7faa3eed5..88ca8129d9df 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -256,6 +256,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
 		struct usb_host_interface *ifp, int num_ep,
 		unsigned char *buffer, int size)
 {
+	struct usb_device *udev = to_usb_device(ddev);
 	unsigned char *buffer0 = buffer;
 	struct usb_endpoint_descriptor *d;
 	struct usb_host_endpoint *endpoint;
@@ -297,6 +298,16 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
 		goto skip_to_next_endpoint_or_interface_descriptor;
 	}
 
+	/* Ignore blacklisted endpoints */
+	if (udev->quirks & USB_QUIRK_ENDPOINT_BLACKLIST) {
+		if (usb_endpoint_is_blacklisted(udev, ifp, d)) {
+			dev_warn(ddev, "config %d interface %d altsetting %d has a blacklisted endpoint with address 0x%X, skipping\n",
+					cfgno, inum, asnum,
+					d->bEndpointAddress);
+			goto skip_to_next_endpoint_or_interface_descriptor;
+		}
+	}
+
 	endpoint = &ifp->endpoint[ifp->desc.bNumEndpoints];
 	++ifp->desc.bNumEndpoints;
 
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index ca74b67c4450..26c316bbba99 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -344,6 +344,38 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
 	{ }  /* terminating entry must be last */
 };
 
+/*
+ * Entries for blacklisted endpoints that should be ignored when parsing
+ * configuration descriptors.
+ *
+ * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
+ */
+static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ }
+};
+
+bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd)
+{
+	const struct usb_device_id *id;
+	unsigned int address;
+
+	for (id = usb_endpoint_blacklist; id->match_flags; ++id) {
+		if (!usb_match_device(udev, id))
+			continue;
+
+		if (!usb_match_one_id_intf(udev, intf, id))
+			continue;
+
+		address = id->driver_info;
+		if (address == epd->bEndpointAddress)
+			return true;
+	}
+
+	return false;
+}
+
 static bool usb_match_any_interface(struct usb_device *udev,
 				    const struct usb_device_id *id)
 {
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 1b5f346d93eb..abac87222093 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -36,6 +36,9 @@ extern void usb_deauthorize_interface(struct usb_interface *);
 extern void usb_authorize_interface(struct usb_interface *);
 extern void usb_detect_quirks(struct usb_device *udev);
 extern void usb_detect_interface_quirks(struct usb_device *udev);
+extern bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd);
 extern int usb_remove_device(struct usb_device *udev);
 
 extern int usb_get_device_descriptor(struct usb_device *dev,
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index b6ce4c2eb40b..fe878f253b20 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -60,4 +60,7 @@
 /* Device needs a pause after every control message. */
 #define USB_QUIRK_DELAY_CTRL_MSG		BIT(13)
 
+/* device has blacklisted endpoints */
+#define USB_QUIRK_ENDPOINT_BLACKLIST		BIT(15)
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.11.0


--x2hflnts4yosupt4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-USB-core-Fix-regression-in-Hercules-audio-card.patch"

From d15e3d70e2ea46427a639dff09168bf793631b2c Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 19 Nov 2020 12:00:40 -0500
Subject: [PATCH 2/2] USB: core: Fix regression in Hercules audio card

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
index 26c316bbba99..34d8cece6dd3 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -195,6 +195,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Guillemot Hercules DJ Console audio card (BZ 208357) */
+	{ USB_DEVICE(0x06f8, 0xb000), .driver_info =
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Midiman M-Audio Keystation 88es */
 	{ USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
 
@@ -351,6 +355,8 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
  * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
  */
 static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x01 },
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x81 },
 	{ }
 };
 
-- 
2.11.0


--x2hflnts4yosupt4--
