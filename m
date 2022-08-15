Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E708594252
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349622AbiHOVsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349810AbiHOVqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:46:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE948F1;
        Mon, 15 Aug 2022 12:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F21360FB9;
        Mon, 15 Aug 2022 19:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F010C433C1;
        Mon, 15 Aug 2022 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591813;
        bh=Dods9/N9gaUudH92kC+aHYMD4cxqqiaIWH0rZtPAawc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+MbkmzNtKCtw0gork6g7yWhZTtx2qVH96+xmpdYhrYeEGdr7vgcuKIyNo7gg/2rp
         nmEDOYTLXXUWM5NHG3okac68yIARodKr7fFCJWbZ6g1eL6TV3Lufb7Wax+Q3bqr0Tf
         6Vk+glFDuHhaSVrhT/InnoLA1iyWHiAuE3d9wy8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syed sabakareem <Syed.SabaKareem@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        David Korth <gerbilsoft@gerbilsoft.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 0012/1157] ASoC: amd: yc: Update DMI table entries
Date:   Mon, 15 Aug 2022 19:49:28 +0200
Message-Id: <20220815180439.955407174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: syed sabakareem <Syed.SabaKareem@amd.com>

commit be0aa8d4b0fcb4532bf7973141e911998ab39508 upstream.

Removed intel DMI product id's 21AW/21AX/21D8/21D9/21BN/21BQ
in DMI table and updated DMI entry for AMD platform X13 Gen 3
platform 21CM/21CN.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216267

Signed-off-by: syed sabakareem <Syed.SabaKareem@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reported-by: David Korth <gerbilsoft@gerbilsoft.com>
Fixes: fa991481b8b2 ("ASoC: amd: add YC machine driver using dmic")
Link: https://lore.kernel.org/r/20220722134603.316668-1-Syed.SabaKareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |   32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -105,28 +105,14 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21AW"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21CM"),
 		}
 	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21AX"),
-		}
-	},
-	{
-		.driver_data = &acp6x_card,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21BN"),
-		}
-	},
-	{
-		.driver_data = &acp6x_card,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21BQ"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21CN"),
 		}
 	},
 	{
@@ -157,20 +143,6 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CL"),
 		}
 	},
-	{
-		.driver_data = &acp6x_card,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21D8"),
-		}
-	},
-	{
-		.driver_data = &acp6x_card,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21D9"),
-		}
-	},
 	{}
 };
 


