Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCE74AFA9C
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiBISil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239926AbiBISiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:38:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E46BC0613C9;
        Wed,  9 Feb 2022 10:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04583B82380;
        Wed,  9 Feb 2022 18:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8678C340E7;
        Wed,  9 Feb 2022 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431882;
        bh=rJqkONifNZkKsNztAUsXBO+i58TXXXnD/CHomPNqq44=;
        h=From:To:Cc:Subject:Date:From;
        b=Y5xOyygbuQTUcRVpEABbmN3Z0zm54CnJlUCE3pBgHf1yOf8Cn/8mP+kabHct+1Rsx
         GLutJbeUDoSFeJHBXXpY/rD05WIQLRhYFbeiHItwOELuT1hzviM0n6PJROabOBgNp1
         +7p62cr97kGNs9r4pQuDKwYNV1nY0bcqyK6u35/zl85HKNnsCrD6cqbiG/4/Sm5xf6
         5O1LBpS/BLaD4XN3Oy6h86BgMrdx7nY2nAF/2AnRtykLu/bsNrDmJnHvzSh5za9/pY
         y74hnukOLq2rfysDtF0A3NSOUahPsrJjYzCTK67Puv9lBkYTsfCQ6rum99f8ckwXfH
         QFRpkx6I9WIiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuka Kawajiri <yukx00@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/36] platform/x86: touchscreen_dmi: Add info for the RWC NANOTE P8 AY07J 2-in-1
Date:   Wed,  9 Feb 2022 13:37:24 -0500
Message-Id: <20220209183759.47134-1-sashal@kernel.org>
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
index 033f797861d8a..c608078538a79 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -773,6 +773,21 @@ static const struct ts_dmi_data predia_basic_data = {
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
@@ -1379,6 +1394,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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

