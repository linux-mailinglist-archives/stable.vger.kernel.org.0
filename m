Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A4C630A47
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbiKSCYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiKSCW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:22:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A735C6223;
        Fri, 18 Nov 2022 18:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1EC162832;
        Sat, 19 Nov 2022 02:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76919C43470;
        Sat, 19 Nov 2022 02:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824123;
        bh=SqsKySvKD3lBPFNaijXqMwh/KmrYMvYdDYfzg8IAPfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqOt/IhEJR6waemzmz5nGt7NJwj+VaLlkQP00pJTYcGh6jxS4Fg94ikQvpcqjnpQ9
         mpFChYoav8IB7T90gF+4QSK++D69NxUpKmQX5LPzHpfEibr1OeVWZdcu6uL41xSqAW
         MX903McyQVaqFgLn914LNxB4KPzc7oV04DHrpSwX53oP/kp+RMSSCV3GON5GpKoFGw
         axEoO5xQRmlmqqsCxZMEC7bUxlyhvuJn0iu7VXk0+xMVs2bixdDhjIvl6vPeUeCGI/
         LPR2DiwUHjhudojr3ALknaQ4U0V/q+6Cw7uqYCkWqm9wu8iC4jfTEWXehDuEaYqBy5
         g/S7rQ1uUZmoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/18] platform/x86: touchscreen_dmi: Add info for the RCA Cambio W101 v2 2-in-1
Date:   Fri, 18 Nov 2022 21:14:52 -0500
Message-Id: <20221119021459.1775052-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021459.1775052-1-sashal@kernel.org>
References: <20221119021459.1775052-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0df044b34bf33e7e35c32b3bf6747fde6279c162 ]

Add touchscreen info for the RCA Cambio W101 v2 2-in-1.

Link: https://github.com/onitake/gsl-firmware/discussions/193
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221025141131.509211-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index ab6a9369649d..110ff1e6ef81 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -756,6 +756,22 @@ static const struct ts_dmi_data predia_basic_data = {
 	.properties	= predia_basic_props,
 };
 
+static const struct property_entry rca_cambio_w101_v2_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 4),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 20),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1644),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 874),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-rca-cambio-w101-v2.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data rca_cambio_w101_v2_data = {
+	.acpi_name = "MSSL1680:00",
+	.properties = rca_cambio_w101_v2_props,
+};
+
 static const struct property_entry rwc_nanote_p8_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 46),
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1728),
@@ -1341,6 +1357,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
 		},
 	},
+	{
+		/* RCA Cambio W101 v2 */
+		/* https://github.com/onitake/gsl-firmware/discussions/193 */
+		.driver_data = (void *)&rca_cambio_w101_v2_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "RCA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "W101SA23T1"),
+		},
+	},
 	{
 		/* RWC NANOTE P8 */
 		.driver_data = (void *)&rwc_nanote_p8_data,
-- 
2.35.1

