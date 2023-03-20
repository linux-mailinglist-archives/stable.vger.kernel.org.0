Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91B96C0751
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjCTA4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCTA4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:56:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E649A1969E;
        Sun, 19 Mar 2023 17:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B390611FA;
        Mon, 20 Mar 2023 00:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7790C433A0;
        Mon, 20 Mar 2023 00:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273631;
        bh=AozSHlsXSmei3bB+3S+JzhkTVZ2fKjwGMDsLJuAKtts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iiu5fjawi/KlNKVC+QbdGiHm1/KDHOTWi9E9GQ89p6j1n7gLdwdUiXsQm5kqEoi51
         R+IEU2ULWW5Z6S1omGOZBaXSP8nmh5vWYxz5HN07MAvxUGs9sh/6wJeGSrLD+ZLJrR
         j/Ikn8KzCq0y85Ko2fhXEw8iZpVQNWI62flxwlNoFm+LvuWMmWpQWxVay7+TR6ISIJ
         z6Jfvq6fO1ySDRVbDF51MDzYf48Y+PBF/D3NRKZGvd9wQINK9JosL5XgfuWdxPmgWk
         nUcV0Jm1znvw/ylSGAGMw/mYk8wQt/u9iBffPNQlQBV21GHBC58wfPIhAfptwEAkG/
         paaDwWBN4KALg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, djrscally@gmail.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 24/30] platform/x86: int3472: Add GPIOs to Surface Go 3 Board data
Date:   Sun, 19 Mar 2023 20:52:49 -0400
Message-Id: <20230320005258.1428043-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
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

