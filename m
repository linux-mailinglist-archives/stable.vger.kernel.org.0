Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49809521F43
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346136AbiEJPrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346115AbiEJPrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:47:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6A127E3D2;
        Tue, 10 May 2022 08:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 152DFCE1F39;
        Tue, 10 May 2022 15:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C338C385A6;
        Tue, 10 May 2022 15:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197423;
        bh=LtglKuDIcoTD0hbZVEoanwLub+zngdfuc7BctvOC8uc=;
        h=From:To:Cc:Subject:Date:From;
        b=dlbt5G4mubpZ/cKsg57ouR63FWF4S0cqs1IekadNuTTDsFfJG0bXz+ekGEhQ9DZRH
         TSkQaDa34n38MJoQm8IM9AR0ae9knc1llwCKauNw56aQWdbM3HI2Gi8GAM/0mWbDAI
         EkTzUIDz8sguGZGB2dpKuOnRBln93cg5K3SRGr69UwA1hf6bFO36uPnfS4epPct2ha
         zQHdFUuGrZ/CND/FKb4bF9ZbffCmuFsna4H+vMUBogH6AF5SXpDzGr3WgaFAlAg1eV
         HFR2KxgiH9loqVbsFMI23tVCQEPh7Ul76GKnJQySqaTwaNtBY6W3F3hU75eUe1z4zS
         uo8L0Ilo69V8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Pauk <pauk.denis@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, kernel@maidavale.org,
        jdelvare@suse.com, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 01/21] hwmon: (asus_wmi_sensors) Fix CROSSHAIR VI HERO name
Date:   Tue, 10 May 2022 11:43:20 -0400
Message-Id: <20220510154340.153400-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 4fd45cc8568e6086272d3036f2c29d61e9b776a1 ]

CROSSHAIR VI HERO motherboard is incorrectly named as
ROG CROSSHAIR VI HERO.

Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Link: https://lore.kernel.org/r/20220403193455.1363-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus_wmi_sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus_wmi_sensors.c b/drivers/hwmon/asus_wmi_sensors.c
index c80eee874b6c..49784a6ea23a 100644
--- a/drivers/hwmon/asus_wmi_sensors.c
+++ b/drivers/hwmon/asus_wmi_sensors.c
@@ -71,7 +71,7 @@ static const struct dmi_system_id asus_wmi_dmi_table[] = {
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("PRIME X399-A"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("PRIME X470-PRO"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VI EXTREME"),
-	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VI HERO"),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("CROSSHAIR VI HERO"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VI HERO (WI-FI AC)"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VII HERO"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VII HERO (WI-FI)"),
-- 
2.35.1

