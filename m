Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34D465812A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiL1QZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbiL1QYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927AB19C3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3704CB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC88C433EF;
        Wed, 28 Dec 2022 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244522;
        bh=8tFq7JLBXzqGGvy14KOYaed8BFPAxwaM75ZJKH6+DsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHAAxJnAbUYI15dv/XsnKYF+5iq7l1MCtqlf93Fp0wgFdvEsJ6A9V1/xE+ZGSf06R
         j73rY+SoY/D5Ug5HZ7oJa8Xj2kTOHYpxTgiCo7vo63LnALyks538vcZvc+YY7h8x0N
         Gqv/exDYXciTddIrqaIV6+D7yq0bz8uIJwkjur+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bryan Brattlof <bb@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0726/1073] thermal/drivers/k3_j72xx_bandgap: Fix the debug print message
Date:   Wed, 28 Dec 2022 15:38:34 +0100
Message-Id: <20221228144347.744739073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Keerthy <j-keerthy@ti.com>

[ Upstream commit a7c42af78b19a11e98a5555a664c343e3a672632 ]

The debug print message to check the workaround applicability is inverted.
Fix the same.

Fixes: ffcb2fc86eb7 ("thermal: k3_j72xx_bandgap: Add the bandgap driver support")
Reported-by: Bryan Brattlof <bb@ti.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Link: https://lore.kernel.org/r/20221010034126.3550-1-j-keerthy@ti.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/k3_j72xx_bandgap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/k3_j72xx_bandgap.c b/drivers/thermal/k3_j72xx_bandgap.c
index 115a44eb4fbf..4eb4926bbdc7 100644
--- a/drivers/thermal/k3_j72xx_bandgap.c
+++ b/drivers/thermal/k3_j72xx_bandgap.c
@@ -439,7 +439,7 @@ static int k3_j72xx_bandgap_probe(struct platform_device *pdev)
 		workaround_needed = false;
 
 	dev_dbg(bgp->dev, "Work around %sneeded\n",
-		workaround_needed ? "not " : "");
+		workaround_needed ? "" : "not ");
 
 	if (!workaround_needed)
 		init_table(5, ref_table, golden_factors);
-- 
2.35.1



