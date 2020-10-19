Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A43292C1A
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgJSRCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730928AbgJSRCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C82C0613CE;
        Mon, 19 Oct 2020 10:02:46 -0700 (PDT)
Date:   Mon, 19 Oct 2020 17:02:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126964;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=9U0Fn1c2lXj076iIZEF+OMwP4AfamS+30GVJUiITv3o=;
        b=TudHgiL7QFYdJUqSd/hz5aRuOl/K8GHcOJbQNX0Vty29WnjP3nHAzUBY0bG8ANYXwZHozD
        TEOB1QcGN3Cm5VKTMw6o45RCN9uTDQv+G6fk9UyHQwE2b6zoPxUuwixXJLp7medxtDUd8z
        7oOLCDT7JsiGjwONvffyGjPN9zjqhJdNLHg4DKs2KSV9pfBbkAnRWTtWNDCA4zLod0uRH7
        VmxR/TVxzGrQLjE1Z5LV8EQ0kE9JTgPEGSPFVF0QC8VqwOCwi3cmf45YgPoOdJpkHC0VDu
        DV2V2vCOu1BBptijVrUf6AgVAIWAxZWHbfYVlKr/MSeTPjEGIt0BNXSCCWequw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126964;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=9U0Fn1c2lXj076iIZEF+OMwP4AfamS+30GVJUiITv3o=;
        b=YwKBsKdnRzuCJKFcHMEDFVrjDUAAjx0KHSBEs4BXETmaVXJ4XHTRRhNnVy2uemc92lYcst
        qAwY+aoO7FZWZcAQ==
From:   "tip-bot2 for Scott Chen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] USB: serial: pl2303: add device-id for HP GC device
Cc:     Scott Chen <scott@labau.com.tw>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160312696384.7002.13344745570625569837.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     9f1e27c040b3956a975f993d4b74006b5a04e969
Gitweb:        https://git.kernel.org/tip/9f1e27c040b3956a975f993d4b74006b5a04e969
Author:        Scott Chen <scott@labau.com.tw>
AuthorDate:    Thu, 24 Sep 2020 14:27:45 +08:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:21 +02:00

USB: serial: pl2303: add device-id for HP GC device

commit 031f9664f8f9356cee662335bc56c93d16e75665 upstream.

This is adds a device id for HP LD381 which is a pl2303GC-base device.

Signed-off-by: Scott Chen <scott@labau.com.tw>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c | 1 +
 drivers/usb/serial/pl2303.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 048452d..be80670 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -100,6 +100,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220TA_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD381_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LD381GC_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960TA_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 7d3090e..0f681dd 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -127,6 +127,7 @@
 
 /* Hewlett-Packard POS Pole Displays */
 #define HP_VENDOR_ID		0x03f0
+#define HP_LD381GC_PRODUCT_ID	0x0183
 #define HP_LM920_PRODUCT_ID	0x026b
 #define HP_TD620_PRODUCT_ID	0x0956
 #define HP_LD960_PRODUCT_ID	0x0b39
