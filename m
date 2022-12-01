Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24EA63FBBC
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 00:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiLAXMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 18:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiLAXMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 18:12:22 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0F6CE407;
        Thu,  1 Dec 2022 15:11:49 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c15so2998513qtw.8;
        Thu, 01 Dec 2022 15:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eB2SiEkoahwJAweFszDO7tR3Np0KafunJjb2zk1tlog=;
        b=S8P4aWhLotqldvBO0a1xty1ZMCTm6QV5GhxODDqIATGbw5i1KAAns9u8XLVcen1U/x
         GzHjWOP0HIdqyjAKsYnPz4zeNx7o9f1GqpMxitX9JokxSpU649hMNneAPWy2R4/CCjcR
         WT23gwurVelSOLWXWtUpDR66QbXOvexdzp11lYISmscNfG+wsPVy+m78z7IptGxOcglu
         8fz13kcO0cG7W6EZ5aYNuO7vpzAlocgbyeaKr7CeTxCyTtfDQhhZcObx0QdDJnF4OT1j
         hPXmGLQ8VQb36GjkTNcpa1uXgfGizJT7QanAHM3csCF1NK7pmNfDNZHvedbphEZxJ+s4
         YRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eB2SiEkoahwJAweFszDO7tR3Np0KafunJjb2zk1tlog=;
        b=EjUCAGEabPHNe0GiCB0iFgX7dKLTnDt5N6DABcHwBo3AX/Gboh4MvwZy1GT6XRYtnJ
         FGYZAiKYLjKsc8cGUVtiy0K+/wttDSTNB43t4Kh+Q1LgCAX+s0WEocnY9GaTabWNfBwF
         zsw68tfZWtw30F8KPYqlJ19DtUdgvzXKwJ7Xh5KTgjdV/bHLBltMYd175kCAqgQqhdVa
         HU9bIOB+fLes3HG1T/zDdCMrtcp4xtxvOhy/ruHckmgO+lvNRQ2t6my2tynRCQW9WxMu
         vXQnY+zc9tVjqgjXDJYLYi/5ScSQowEKXePW1+6avcjFMCNC4di7ztJbpOtDWO9tRbe3
         +Pug==
X-Gm-Message-State: ANoB5pmB2dWkC2RFpiPJ5QDJrtZEE+wIXx7jAddUJmEiMDnASh+Wauss
        EwzMl6LiH3pZmuBoCdcjqRC5KvbupJJNGg==
X-Google-Smtp-Source: AA0mqf6A/k2nTDCcmt9r3O+EmT4tQ1Kgd/ymVBfCgPvWSW0cLvUBJL/A+evgotkrG0swRuWWadnoIw==
X-Received: by 2002:ac8:4615:0:b0:3a5:4057:4202 with SMTP id p21-20020ac84615000000b003a540574202mr64536341qtn.454.1669936308739;
        Thu, 01 Dec 2022 15:11:48 -0800 (PST)
Received: from horus.lan (75-164-171-180.ptld.qwest.net. [75.164.171.180])
        by smtp.gmail.com with ESMTPSA id f25-20020ac86ed9000000b003a4f2510e5dsm3254365qtv.24.2022.12.01.15.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:11:48 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        "Tobita, Tatsunosuke" <tatsunosuke.tobita@wacom.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <killertofu@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: [PATCH] HID: wacom: Ensure bootloader PID is usable in hidraw mode
Date:   Thu,  1 Dec 2022 15:11:41 -0800
Message-Id: <20221201231141.112916-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

Some Wacom devices have a special "bootloader" mode that is used for
firmware flashing. When operating in this mode, the device cannot be
used for input, and the HID descriptor is not able to be processed by
the driver. The driver generates an "Unknown device_type" warning and
then returns an error code from wacom_probe(). This is a problem because
userspace still needs to be able to interact with the device via hidraw
to perform the firmware flash.

This commit adds a non-generic device definition for 056a:0094 which
is used when devices are in "bootloader" mode. It marks the devices
with a special BOOTLOADER type that is recognized by wacom_probe() and
wacom_raw_event(). When we see this type we ensure a hidraw device is
created and otherwise keep our hands off so that userspace is in full
control.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hid/wacom_sys.c | 8 ++++++++
 drivers/hid/wacom_wac.c | 4 ++++
 drivers/hid/wacom_wac.h | 1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 634263e4556b..fb538a6c4add 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -155,6 +155,9 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 
+	if (wacom->wacom_wac.features.type == BOOTLOADER)
+		return 0;
+
 	if (size > WACOM_PKGLEN_MAX)
 		return 1;
 
@@ -2785,6 +2788,11 @@ static int wacom_probe(struct hid_device *hdev,
 		return error;
 	}
 
+	if (features->type == BOOTLOADER) {
+		hid_warn(hdev, "Using device in hidraw-only mode");
+		return hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	}
+
 	error = wacom_parse_and_register(wacom, false);
 	if (error)
 		return error;
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 0f3d57b42684..9312d611db8e 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4882,6 +4882,9 @@ static const struct wacom_features wacom_features_0x3dd =
 static const struct wacom_features wacom_features_HID_ANY_ID =
 	{ "Wacom HID", .type = HID_GENERIC, .oVid = HID_ANY_ID, .oPid = HID_ANY_ID };
 
+static const struct wacom_features wacom_features_0x94 =
+	{ "Wacom Bootloader", .type = BOOTLOADER };
+
 #define USB_DEVICE_WACOM(prod)						\
 	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -4955,6 +4958,7 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x84) },
 	{ USB_DEVICE_WACOM(0x90) },
 	{ USB_DEVICE_WACOM(0x93) },
+	{ USB_DEVICE_WACOM(0x94) },
 	{ USB_DEVICE_WACOM(0x97) },
 	{ USB_DEVICE_WACOM(0x9A) },
 	{ USB_DEVICE_WACOM(0x9F) },
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 5ca6c06d143b..16f221388563 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -243,6 +243,7 @@ enum {
 	MTTPC,
 	MTTPC_B,
 	HID_GENERIC,
+	BOOTLOADER,
 	MAX_TYPE
 };
 
-- 
2.38.1

