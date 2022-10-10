Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1C5FA6E8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 23:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJJVXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 17:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJJVXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 17:23:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC656B173
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:23:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r18so11187793pgr.12
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaikai-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05se/QLxbcZC/U9SJgyBO6TtEpzcC1Jq7/S8OolD1VM=;
        b=vYbM3FK0M1aBaoDw/yrM2w99gA9UTV4/QsqC2J09tWJdCRkxIx/nTYOuTls2kVOzhu
         2uN45IID81baR/CrTPTBS4veUGoTeNWUTRg0EROk+A0zEOy2KZXydCXaWMAL9g9SsuRh
         Hvnv1zPcSYyUgG6EE37POeo1Qn9Tf5inrciM+tOHmw6zskygEegZ5q7m0Bd4G7YglwNE
         XLDAh1r/Y9D37iC2OEbziocGFEPJADhl7r6GytrfOURW+qtwRvU3GW4pLkp9IdwHUL5N
         aNa0fxNcmybxU1jQS8nXX52BG+tXI0MoDcyF2G+5nR+3HhxfQaCnnd6b9Dz9Es5ODOuF
         QQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=05se/QLxbcZC/U9SJgyBO6TtEpzcC1Jq7/S8OolD1VM=;
        b=JPz2889o0E8tm4z+f5dZ6Z30tua3FDeUVD5YKNYnAy8RJf/LjlgC4Kp+mboaqZ6fit
         to6I12Wq0qL/a1aLVnX8I8o0Yu7m3eowPspmX5s4PfWmmaler4rhfPlb4Y6q1WRgZBZg
         WfoZutF3gMhY4wGhe5fevxuf7TvjNk+36KlhscGtWGTAWuf9DauN0JBVHbplpOAcehCE
         OQXoF2EpU82XpvRb+12Lwwi+LWeflsKjHicQlasu3qYpzap9Da6gjl0MqJjeXek1XOER
         cIvNAxesUqPep9XAI3zrqK7AFRnmTU5xP4CjIjKvPW2sTVm9tJTtYjKDOXvKRF8tmZPu
         xwJw==
X-Gm-Message-State: ACrzQf2DpCCL2rekrVM/S8HQIMEneIgjmjPXdRmzHwslHrzMC2Ioae7G
        5wGcbwtHfVSY6dEMBk5b7t3F0g==
X-Google-Smtp-Source: AMsMyM4eOT4VO2Riqb39WbsITGdk0C8AcDEeaV++aLAq+dNy9cyapR4gaVHM6JfrkBj5Lq+ijEy5BQ==
X-Received: by 2002:a63:d709:0:b0:461:be56:507e with SMTP id d9-20020a63d709000000b00461be56507emr8151215pgg.597.1665437001518;
        Mon, 10 Oct 2022 14:23:21 -0700 (PDT)
Received: from localhost.localdomain (23-122-157-100.lightspeed.irvnca.sbcglobal.net. [23.122.157.100])
        by smtp.gmail.com with ESMTPSA id d17-20020a621d11000000b0054097cb2da6sm7383876pfd.38.2022.10.10.14.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 14:23:20 -0700 (PDT)
From:   Roderick Colenbrander <roderick@gaikai.com>
X-Google-Original-From: Roderick Colenbrander <roderick.colenbrander@sony.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/3] HID: playstation: add initial DualSense Edge controller support
Date:   Mon, 10 Oct 2022 14:23:12 -0700
Message-Id: <20221010212313.78275-3-roderick.colenbrander@sony.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221010212313.78275-1-roderick.colenbrander@sony.com>
References: <20221010212313.78275-1-roderick.colenbrander@sony.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Provide initial support for the DualSense Edge controller. The brings
support up to the level of the original DualSense, but won't yet provide
support for new features (e.g. reprogrammable buttons).

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
---
 drivers/hid/hid-ids.h         | 1 +
 drivers/hid/hid-playstation.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f80d6193fca6..cd8087ed412c 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1142,6 +1142,7 @@
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_2	0x09cc
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_DONGLE	0x0ba0
 #define USB_DEVICE_ID_SONY_PS5_CONTROLLER	0x0ce6
+#define USB_DEVICE_ID_SONY_PS5_CONTROLLER_2	0x0df2
 #define USB_DEVICE_ID_SONY_MOTION_CONTROLLER	0x03d5
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
 #define USB_DEVICE_ID_SONY_BUZZ_CONTROLLER		0x0002
diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index d727cd2bf44e..396356b6760a 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -1464,7 +1464,8 @@ static int ps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_stop;
 	}
 
-	if (hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER) {
+	if (hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER ||
+		hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) {
 		dev = dualsense_create(hdev);
 		if (IS_ERR(dev)) {
 			hid_err(hdev, "Failed to create dualsense.\n");
@@ -1499,6 +1500,8 @@ static void ps_remove(struct hid_device *hdev)
 static const struct hid_device_id ps_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ps_devices);
-- 
2.37.3

