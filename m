Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CA56C0765
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCTA5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCTA4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DC11ABC1;
        Sun, 19 Mar 2023 17:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4CB61202;
        Mon, 20 Mar 2023 00:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A4AC433A0;
        Mon, 20 Mar 2023 00:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273700;
        bh=AozSHlsXSmei3bB+3S+JzhkTVZ2fKjwGMDsLJuAKtts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2AbipoDt2MrbIJli3W5bDfREJSEEqElLtcqnTj4NGSSKtL5xlhavPVHoa6uUvTSZ
         C5Lre/L5Hhhld7jOzzxaxIIm+SjDLvNHpqwjwo1ZgThpl5lTIr5CirOyPspklKfQWQ
         OEZIL2++BXdRW3K3xCC8bmqrVLlOpNSsY4RCHOCZ91pXhMD9fUookbLKjSHSA0QTot
         BS2rnIwpTxhsC6rm1MLwUe0uJ5Sg2R/mXxTRcAqToWfzK5+Y3w87HsT8fQtHoXNXv5
         dasSk71tsxPnLi60FwBA/VtxuU3//FKZ4U0MTCnDdilGGvLqvGgF4Cddn/6nTFs7Yi
         xFwp4TFBFVWNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, djrscally@gmail.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 23/29] platform/x86: int3472: Add GPIOs to Surface Go 3 Board data
Date:   Sun, 19 Mar 2023 20:54:05 -0400
Message-Id: <20230320005413.1428452-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit e8059d393158e927e36898aca89986a52025b9f3 ]

Add the INT347E GPIO lookup table to the board data for the Surface
Go 3. This is necessary to allow the ov7251 IR camera to probe
properly on that platform.

Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Link: https://lore.kernel.org/r/20230302102611.314341-1-dan.scally@ideasonboard.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/tps68470_board_data.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/tps68470_board_data.c b/drivers/platform/x86/intel/int3472/tps68470_board_data.c
index 309eab9c05588..322237e056f32 100644
--- a/drivers/platform/x86/intel/int3472/tps68470_board_data.c
+++ b/drivers/platform/x86/intel/int3472/tps68470_board_data.c
@@ -159,9 +159,10 @@ static const struct int3472_tps68470_board_data surface_go_tps68470_board_data =
 static const struct int3472_tps68470_board_data surface_go3_tps68470_board_data = {
 	.dev_name = "i2c-INT3472:01",
 	.tps68470_regulator_pdata = &surface_go_tps68470_pdata,
-	.n_gpiod_lookups = 1,
+	.n_gpiod_lookups = 2,
 	.tps68470_gpio_lookup_tables = {
-		&surface_go_int347a_gpios
+		&surface_go_int347a_gpios,
+		&surface_go_int347e_gpios,
 	},
 };
 
-- 
2.39.2

