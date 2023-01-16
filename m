Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE60F66C1FA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjAPORD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjAPOOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:14:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24372FCE9;
        Mon, 16 Jan 2023 06:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3642A60FC9;
        Mon, 16 Jan 2023 14:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C26C433F2;
        Mon, 16 Jan 2023 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877942;
        bh=ENBJXackha8omqNqOhEs9TxO3aOO2kDId+z48P+U3UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peZ4dV2rhfz5thHk+0oKxTqhr9VskkNXihVR34mOVLA6nGBZQoLjFWFpFzVNA0AFq
         hgFgf85eF+GWkwQFBI9dtVsZs4wGvBxjVaDjIbYYMUuAwvnJ4eZ5vNvaQeblFu3XCP
         FGxzKIS18XoiX3cnnCgRL9NLomGJMRWGD5qIy/X/7hrWmlR2PaYpgmcXu4UqzxkM8H
         qpzjQHUJqjMXHJDSI+SARsYislUCB7SJBE+ej/Qr/YmmEgH6tVEEaSMsppE3lymz7+
         dxf5hc1YBsALMu1tWJKxF1qOWLZ6I7Hu5xYno5gVAhdW6CzzeoWPNODNrNYn9p/0HM
         Rjt/Zmvtzfdhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Klein <m.klein@mvz-labor-lb.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/16] platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD
Date:   Mon, 16 Jan 2023 09:05:16 -0500
Message-Id: <20230116140520.116257-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140520.116257-1-sashal@kernel.org>
References: <20230116140520.116257-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Klein <m.klein@mvz-labor-lb.de>

[ Upstream commit 36c2b9d6710427f802494ba070621cb415198293 ]

Add touchscreen info for the CSL Panther Tab HD.

Signed-off-by: Michael Klein <m.klein@mvz-labor-lb.de>
Link: https://lore.kernel.org/r/20221220121103.uiwn5l7fii2iggct@LLGMVZLB-0037
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 515c66ca1aec..61cb1a4a8257 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -169,6 +169,23 @@ static const struct ts_dmi_data connect_tablet9_data = {
 	.properties     = connect_tablet9_props,
 };
 
+static const struct property_entry csl_panther_tab_hd_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 20),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1980),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1526),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-csl-panther-tab-hd.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data csl_panther_tab_hd_data = {
+	.acpi_name      = "MSSL1680:00",
+	.properties     = csl_panther_tab_hd_props,
+};
+
 static const struct property_entry cube_iwork8_air_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 3),
@@ -721,6 +738,14 @@ static const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Tablet 9"),
 		},
 	},
+	{
+		/* CSL Panther Tab HD */
+		.driver_data = (void *)&csl_panther_tab_hd_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CSL Computer GmbH & Co. KG"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CSL Panther Tab HD"),
+		},
+	},
 	{
 		/* CUBE iwork8 Air */
 		.driver_data = (void *)&cube_iwork8_air_data,
-- 
2.35.1

