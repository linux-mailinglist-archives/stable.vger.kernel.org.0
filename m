Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74B64BDF66
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbiBUJXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349115AbiBUJVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC35C35272;
        Mon, 21 Feb 2022 01:07:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 620BC6092A;
        Mon, 21 Feb 2022 09:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4435CC340F1;
        Mon, 21 Feb 2022 09:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434474;
        bh=rJqkONifNZkKsNztAUsXBO+i58TXXXnD/CHomPNqq44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aELT26m/wbDegCD2Jd5WUuj9Ts+9fcdKDv5L1HFfUnNNdjLBhAIyzIUqjs99Cj2TL
         qr3nb0cmIPFz4cmstSKcrdEaG0F70L8+brq6z+mWhP70Lat4PczbFSvdL2SRxILumu
         CHhL4riJC8MkjjD92TETtD/kacSAr1GDZPMACIDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuka Kawajiri <yukx00@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/196] platform/x86: touchscreen_dmi: Add info for the RWC NANOTE P8 AY07J 2-in-1
Date:   Mon, 21 Feb 2022 09:47:33 +0100
Message-Id: <20220221084931.607356103@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



