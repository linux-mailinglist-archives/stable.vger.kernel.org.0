Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA92681036
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbjA3OB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbjA3OBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52AC3B64F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6108CB81141
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEF3C433EF;
        Mon, 30 Jan 2023 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087245;
        bh=6uAxm5KEIl3IcxH80/PrBEBFQrOTSh5clf3i1F9u3mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFqhbOcuijJyrzqjEu5UOukGcsQCtLZSUv8CzG346xbxCeVpQNB4cTlJz4KxE9txd
         iJ7GQUy2GmjrtSerxmXl0SBCMz+2LZ4EjbhWqelVCIq9K7Y93vrIl5wd4Q/dbBQBwd
         jhUPXow/TgE5IChOVw0SdR8ww/Nu2aAjBnE8oP3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wim Van Boven <wimvanboven@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/313] ASoC: amd: yc: Add Razer Blade 14 2022 into DMI table
Date:   Mon, 30 Jan 2023 14:49:40 +0100
Message-Id: <20230130134343.410031123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wim Van Boven <wimvanboven@gmail.com>

[ Upstream commit 68506a173dd700c2bd794dcc3489edcdb8ee35c6 ]

Razer Blade 14 (2022) - RZ09-0427 needs the quirk to enable the built in microphone

Signed-off-by: Wim Van Boven <wimvanboven@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221216081828.12382-1-wimvanboven@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f0b5527c594..469c5e79e0ea 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
+		}
+	},
 	{}
 };
 
-- 
2.39.0



