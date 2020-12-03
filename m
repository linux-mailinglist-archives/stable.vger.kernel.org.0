Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300812CD7FF
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389150AbgLCNhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436608AbgLCNa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:29 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        russianneuromancer <russianneuromancer@ya.ru>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 37/39] platform/x86: touchscreen_dmi: Add info for the Irbis TW118 tablet
Date:   Thu,  3 Dec 2020 08:28:31 -0500
Message-Id: <20201203132834.930999-37-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c9aa128080cbce92f8715a9328f88d8ca3134279 ]

Add touchscreen info for the Irbis TW118 tablet.

Reported-and-tested-by: russianneuromancer <russianneuromancer@ya.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201124110454.114286-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 26cbf7cc8129c..5783139d0a119 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -295,6 +295,21 @@ static const struct ts_dmi_data irbis_tw90_data = {
 	.properties	= irbis_tw90_props,
 };
 
+static const struct property_entry irbis_tw118_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 20),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 30),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1960),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1510),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-irbis-tw118.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data irbis_tw118_data = {
+	.acpi_name	= "MSSL1680:00",
+	.properties	= irbis_tw118_props,
+};
+
 static const struct property_entry itworks_tw891_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 5),
@@ -953,6 +968,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "TW90"),
 		},
 	},
+	{
+		/* Irbis TW118 */
+		.driver_data = (void *)&irbis_tw118_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IRBIS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TW118"),
+		},
+	},
 	{
 		/* I.T.Works TW891 */
 		.driver_data = (void *)&itworks_tw891_data,
-- 
2.27.0

