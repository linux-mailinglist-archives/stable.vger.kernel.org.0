Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31436AEE68
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjCGSLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjCGSLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:11:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F6DABACC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F5866152C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8365CC4339B;
        Tue,  7 Mar 2023 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212377;
        bh=vfUAMRT1qE9J1/aqt0rnCESVFB3WSq9+Qg8UAOepUoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdPiElK0NrWtUq/bfiOqlvEFuFAqY0MT3ShKCwjJzZZP2ubVG6W6iVd3SgefZjVgF
         xfgKTH9qGYk+/P8zXvba+SgtgZLlQeC6lAvERRIA3PbbP3+Fn3V7WEKgBRnoe+JXgt
         oOt8zk+ctmmWV9DN2p2DD3sTWyQC7RmH5N5clCBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/885] thermal/drivers/imx_sc_thermal: Drop empty platform remove function
Date:   Tue,  7 Mar 2023 17:51:40 +0100
Message-Id: <20230307170009.145303437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5011a110295d25418f5918a6af7bfcdb00dd4e34 ]

A remove callback just returning 0 is equivalent to no remove callback
at all. So drop the useless function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20221212220217.3777176-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Stable-dep-of: 4b26b7c9cdef ("thermal/drivers/imx_sc_thermal: Fix the loop condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_sc_thermal.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/thermal/imx_sc_thermal.c b/drivers/thermal/imx_sc_thermal.c
index 5d92b70a5d53a..4df925e3a80bd 100644
--- a/drivers/thermal/imx_sc_thermal.c
+++ b/drivers/thermal/imx_sc_thermal.c
@@ -127,11 +127,6 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int imx_sc_thermal_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static int imx_sc_sensors[] = { IMX_SC_R_SYSTEM, IMX_SC_R_PMIC_0, -1 };
 
 static const struct of_device_id imx_sc_thermal_table[] = {
@@ -142,7 +137,6 @@ MODULE_DEVICE_TABLE(of, imx_sc_thermal_table);
 
 static struct platform_driver imx_sc_thermal_driver = {
 		.probe = imx_sc_thermal_probe,
-		.remove	= imx_sc_thermal_remove,
 		.driver = {
 			.name = "imx-sc-thermal",
 			.of_match_table = imx_sc_thermal_table,
-- 
2.39.2



