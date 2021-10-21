Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857F243626B
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 15:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhJUNLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 09:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhJUNLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 09:11:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D792AC061749;
        Thu, 21 Oct 2021 06:09:18 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ec8so1080706edb.6;
        Thu, 21 Oct 2021 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C6dmmLtRpJPnrkTBdi9iZgSt/uT2huszD9+DESNwaO8=;
        b=pJKvEgmVw9icBYy090eTcWUSzupiLzc6KVXrZTlN3EzrQofHfLRvyNRbsfHbRekb1Q
         U/Qay6N05AeyDpzTA9qpVEgSKQ4g9C4wO7wcnwRaZxqpPgxuovz2CSWnR1HIT1e+1GuZ
         rjuxumnvk7+aUvBk1LuBVFVOJEjdDRfyLsu/dNBgfsFbSeXec4QoL0RfenDQEvcnTZY+
         EnS39Z0yJUocN/mUfrkrD2az/+xtWyK8xSBoevZQv2X6xcNifTFvyO3AlNcnhhG7rkcD
         qbKBHoIzDgdS2U3oGM4araLQR/Nkoy39pUlsHnDqqQ5q4V3k+nN/vmGfNJ94vcioOb7y
         CsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C6dmmLtRpJPnrkTBdi9iZgSt/uT2huszD9+DESNwaO8=;
        b=20KSxTE6unJTAgdaO5JzYd23wa8qAZRIN6l26RpIVJgiAIqT4P4Y4CRCpjfzxaRTjF
         ouNzgqgPIY9YY1hQTpcrvbcBH92W3gTP9jpHjglYZw5GrmjjdzKTGN7Y3HsEon4gXDd+
         xhWSOxJBnkMjgKUVdMi6R0RATiSy1L+G87ywOFhA3n2UeIlwYijQa7WUb5tlqRs9aJSM
         Q44qMyMOvhCbjICnD7LA+0F/NKVibbhwitrdG6ok8kKxTbl/fZGhhdLuNddr4qnbckmO
         TJR2xQgMr02gHmMt8+kF/sTCygA+6dMaZ+u4v5CuP5y1DKycJtNIz3AXu8BG7qrN5ziL
         csPg==
X-Gm-Message-State: AOAM5328Wdk2aFdHn6TWi+5m31BEOdZ4c4q4uukomSOy3UzDDzVbLkTN
        N5fGSJ1I7cs4GltCvDHHdL8=
X-Google-Smtp-Source: ABdhPJxsYjntN+sM0nMpcfIr+MAXYon0wtUZXuW79zDrH/tQ3nlVL9khl3duSt8p/tnsP4/iDMLA8Q==
X-Received: by 2002:a17:906:34c3:: with SMTP id h3mr7561100ejb.10.1634821755192;
        Thu, 21 Oct 2021 06:09:15 -0700 (PDT)
Received: from xws.localdomain ([194.126.177.11])
        by smtp.gmail.com with ESMTPSA id q6sm126987eds.96.2021.10.21.06.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 06:09:14 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] platform/surface: aggregator_registry: Add support for Surface Laptop Studio
Date:   Thu, 21 Oct 2021 15:09:02 +0200
Message-Id: <20211021130904.862610-2-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211021130904.862610-1-luzmaximilian@gmail.com>
References: <20211021130904.862610-1-luzmaximilian@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add support for the Surface Laptop Studio.

In contrast to previous Surface Laptop models, this one has its HID
devices attached to target ID 1 (instead of 2). It also has a couple
more of them, including a new notifier for when the pen is stashed /
taken out of its place, a "Sys Control" device, and two other
unidentified HID devices with unknown usages.

Battery and performance profile interfaces remain the same.

Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 .../surface/surface_aggregator_registry.c     | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 4428c4330229..1679811eff50 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -77,6 +77,42 @@ static const struct software_node ssam_node_bas_dtx = {
 	.parent = &ssam_node_root,
 };
 
+/* HID keyboard (TID1). */
+static const struct software_node ssam_node_hid_tid1_keyboard = {
+	.name = "ssam:01:15:01:01:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID pen stash (TID1; pen taken / stashed away evens). */
+static const struct software_node ssam_node_hid_tid1_penstash = {
+	.name = "ssam:01:15:01:02:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID touchpad (TID1). */
+static const struct software_node ssam_node_hid_tid1_touchpad = {
+	.name = "ssam:01:15:01:03:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID device instance 6 (TID1, unknown HID device). */
+static const struct software_node ssam_node_hid_tid1_iid6 = {
+	.name = "ssam:01:15:01:06:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID device instance 7 (TID1, unknown HID device). */
+static const struct software_node ssam_node_hid_tid1_iid7 = {
+	.name = "ssam:01:15:01:07:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID system controls (TID1). */
+static const struct software_node ssam_node_hid_tid1_sysctrl = {
+	.name = "ssam:01:15:01:08:00",
+	.parent = &ssam_node_root,
+};
+
 /* HID keyboard. */
 static const struct software_node ssam_node_hid_main_keyboard = {
 	.name = "ssam:01:15:02:01:00",
@@ -159,6 +195,21 @@ static const struct software_node *ssam_node_group_sl3[] = {
 	NULL,
 };
 
+/* Devices for Surface Laptop Studio. */
+static const struct software_node *ssam_node_group_sls[] = {
+	&ssam_node_root,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_pprof,
+	&ssam_node_hid_tid1_keyboard,
+	&ssam_node_hid_tid1_penstash,
+	&ssam_node_hid_tid1_touchpad,
+	&ssam_node_hid_tid1_iid6,
+	&ssam_node_hid_tid1_iid7,
+	&ssam_node_hid_tid1_sysctrl,
+	NULL,
+};
+
 /* Devices for Surface Laptop Go. */
 static const struct software_node *ssam_node_group_slg1[] = {
 	&ssam_node_root,
@@ -507,6 +558,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Studio */
+	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
+
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, ssam_platform_hub_match);
-- 
2.33.1

