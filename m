Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383864AFB03
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbiBISlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbiBISlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:41:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77155C050CF4;
        Wed,  9 Feb 2022 10:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15BF260918;
        Wed,  9 Feb 2022 18:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0E5C340E7;
        Wed,  9 Feb 2022 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432066;
        bh=JFakvK8607UA2o62LWq8p0ThgIQUef2OWViBTDQfYQc=;
        h=From:To:Cc:Subject:Date:From;
        b=N8rC/s3a69nzrUbHE9Yid8xidHF61qImRjg7UdHjQl3+7akxYhOOn5rSs83xwYhXt
         663f8nk7MbG945p8tgjOXxvfZ7NZ+smBZ8X97dwKSQTYnU2FzBHIbpwHIctAw1DZxH
         7wcjzMYFMbHpTDZm0nwkEp6CysZ8fM1sZ4SNYhRJLZL7/Hsc/P1maEoudnOHial/YJ
         GyKf+1A1l0e0VmIX9Z8Xm50P75h3L5z931Pbra0m2dllA8hQip3hN5G386pb98GhS0
         toQh7qXiee1e5udH2gMIBCpGXa6gESRltwV8l3GVt/q6EaNR/2uaCGf/56Fy19P5rf
         EAUB34U854oDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuka Kawajiri <yukx00@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/27] platform/x86: touchscreen_dmi: Add info for the RWC NANOTE P8 AY07J 2-in-1
Date:   Wed,  9 Feb 2022 13:40:37 -0500
Message-Id: <20220209184103.47635-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuka Kawajiri <yukx00@gmail.com>

[ Upstream commit 512eb73cfd1208898cf10cb06094e0ee0bb53b58 ]

Add touchscreen info for RWC NANOTE P8 (AY07J) 2-in-1.

Signed-off-by: Yuka Kawajiri <yukx00@gmail.com>
Link: https://lore.kernel.org/r/20220111154019.4599-1-yukx00@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 59b7e90cd5875..ab6a9369649db 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -756,6 +756,21 @@ static const struct ts_dmi_data predia_basic_data = {
 	.properties	= predia_basic_props,
 };
 
+static const struct property_entry rwc_nanote_p8_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 46),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1728),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-rwc-nanote-p8.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data rwc_nanote_p8_data = {
+	.acpi_name = "MSSL1680:00",
+	.properties = rwc_nanote_p8_props,
+};
+
 static const struct property_entry schneider_sct101ctm_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1715),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
@@ -1326,6 +1341,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
 		},
 	},
+	{
+		/* RWC NANOTE P8 */
+		.driver_data = (void *)&rwc_nanote_p8_data,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Default string"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AY07J"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "0001")
+		},
+	},
 	{
 		/* Schneider SCT101CTM */
 		.driver_data = (void *)&schneider_sct101ctm_data,
-- 
2.34.1

