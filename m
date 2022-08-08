Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FC458BF44
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241882AbiHHBhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242374AbiHHBf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3938CE38;
        Sun,  7 Aug 2022 18:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96C1DB80E0A;
        Mon,  8 Aug 2022 01:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674E6C433C1;
        Mon,  8 Aug 2022 01:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922402;
        bh=rWb1f1Z+DT94vEc9LqkW7nYkUu054H+aCua9enkzrAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loj2cF8xn8JPQ5FRghwx1pAj7IXjp3bT6u0SLy2L9aRlPTxoQPfV4NbmbVb1cZ18P
         Rh2ah+bvZpZPhVAIKPuH3Orx4s05WQabdSNNQrli3sF5HmClvsMb1CALIkwb/HAfv/
         y3lKJoy4kmfeHR63l2MFg0UhZ1uM+7uRbHpc6060eV0lMkPuKfq9tWbcIJ1d6k5sAn
         s3/8bSXtReRD+MXN7j1R8Pa8KsmCPRgC0Ncps49vbXjxJBRgehwKrkBICPItKD9zKf
         smlObyH7K561z3y3QjtxGUBgHttFw223X4PRmh3nL1p/G1e/sFwUyLqs1JXJloWsQW
         xkjBw3Lf/V8Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 48/58] hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist
Date:   Sun,  7 Aug 2022 21:31:06 -0400
Message-Id: <20220808013118.313965-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 385e5f57053ff293282fea84c1c27186d53f66e1 ]

A user reported that the program dell-bios-fan-control
worked on his Dell XPS 13 7390 to switch off automatic
fan control.
Since it uses the same mechanism as the dell_smm_hwmon
module, add this model to the fan control whitelist.

Compile-tested only.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220612041806.11367-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 071aa6f4e109..16c10ac84a91 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1365,6 +1365,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_34A3_35A3],
 	},
+	{
+		.ident = "Dell XPS 13 7390",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 13 7390"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_34A3_35A3],
+	},
 	{ }
 };
 
-- 
2.35.1

