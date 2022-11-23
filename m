Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9B6635DE8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbiKWMrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbiKWMq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB6459168;
        Wed, 23 Nov 2022 04:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07E79B81F40;
        Wed, 23 Nov 2022 12:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16FFC433B5;
        Wed, 23 Nov 2022 12:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207384;
        bh=RUpOMe3BO0dzbxwVHpa6aIEvvuaeeCposlJJy+mWPjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LE5k4tUTbjzKxSGd8lcskvSKGQF/DOePDIgsDXm4Kg9RrquFNFEYGldLYKZlKlMW0
         d0Pzas5AMlX/htfSnt/yY9L8fk/O2x/254XmEtUcqN0FXuUxkvfImHNuCvHwc684uv
         nit2ZUEji6yi1Db+U9qfUSmbInFCqCBeDgCIrMMe86lOJP/Mv+3Hb37UTSUnQ8SZgq
         yPvFR7DUBPZLYN8f3g6OE2KF/DwkOiWJIIk3DCBpkRRCgVrPGDtVzJODDGgY2Tfq1S
         HMEyJHk9RZEa+5k2RXZNzJRJ1UUtdvaxHbqNcWM/NNJkpWb7rZjBKVHIgPzeP+E7Ws
         s6AebWyGqTu+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hdegoede@redhat.com,
        wse@tuxedocomputers.com, samuel@cavoj.net,
        wsa+renesas@sang-engineering.com, chenhuacai@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/31] Input: i8042 - apply probe defer to more ASUS ZenBook models
Date:   Wed, 23 Nov 2022 07:42:12 -0500
Message-Id: <20221123124234.265396-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 26c263bf1847d4dadba016a0457c4c5f446407bf ]

There are yet a few more ASUS ZenBook models that require the deferred
probe.  At least, there are different ZenBook UX325x and UX425x
models.  Let's extend the DMI matching table entries for adapting
those missing models.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20221108142027.28480-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 4b0201cf71f5..3a41ac9af2e7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -114,18 +114,18 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UX425UA */
+		/* ASUS ZenBook UX425UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UM325UA */
+		/* ASUS ZenBook UM325UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
-- 
2.35.1

