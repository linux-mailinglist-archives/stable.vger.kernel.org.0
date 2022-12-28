Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A379658207
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiL1Qcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiL1Qc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F6D1929A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D028B81886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03666C433D2;
        Wed, 28 Dec 2022 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244954;
        bh=FvOVMjnj+QMZKs3u4sBYEJyYInIsw3DB5uRBc499JI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIwCN1rEbAxe9qAJCmA4S0aGcsungH/3vtlkLu9Z9JxI0x1rXuUcPpcxmM0+O1gI9
         RsPWvnd0/fOtXwo4lI+4nx4M3a7kQTZJw7eFAjqqZxFq9KC3R9KU6gBB88SFJznrme
         odOY7bXbyLh+r97oe8310JOz0RyuV62s2eou1CsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bryan Brattlof <bb@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0750/1146] thermal/drivers/k3_j72xx_bandgap: Fix the debug print message
Date:   Wed, 28 Dec 2022 15:38:09 +0100
Message-Id: <20221228144350.516226420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 16b6bcf1bf4f..c073b1023bbe 100644
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



