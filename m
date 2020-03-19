Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405B818B70C
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgCSNVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgCSNVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20A4206D7;
        Thu, 19 Mar 2020 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624067;
        bh=sYWF8AvnWk2btIK4f5F35II3uns03QA+pOLfSwTEN+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sctWjZ3bDsQ1njOSxfMzECrhwWoG7Yj2jAwLCBsclH2K/jZGrNXZILxorflSLEdpc
         jpC2fInvha35eOLq/jAX57fC2dzvjkZ3OUILNmDMDVHJzgA9WLcvui21+L+sjOip0d
         xcGJBfF9pTvNHDMslVRfOCW+zzTbiReeToFUpfvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Tsung Hsieh <chentsung@chromium.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 46/48] HID: google: add moonball USB id
Date:   Thu, 19 Mar 2020 14:04:28 +0100
Message-Id: <20200319123917.214841680@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Tsung Hsieh <chentsung@chromium.org>

commit 58322a1590fc189a8e1e349d309637d4a4942840 upstream.

Add 1 additional hammer-like device.

Signed-off-by: Chen-Tsung Hsieh <chentsung@chromium.org>
Reviewed-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-google-hammer.c |    2 ++
 drivers/hid/hid-ids.h           |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -125,6 +125,8 @@ static const struct hid_device_id hammer
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MASTERBALL) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MOONBALL) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_STAFF) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_WAND) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -468,6 +468,7 @@
 #define USB_DEVICE_ID_GOOGLE_WHISKERS	0x5030
 #define USB_DEVICE_ID_GOOGLE_MASTERBALL	0x503c
 #define USB_DEVICE_ID_GOOGLE_MAGNEMITE	0x503d
+#define USB_DEVICE_ID_GOOGLE_MOONBALL	0x5044
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f


