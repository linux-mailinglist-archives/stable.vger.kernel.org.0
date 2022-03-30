Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257BF4EC23B
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbiC3L64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiC3Lxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D422706E1;
        Wed, 30 Mar 2022 04:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B3E36162C;
        Wed, 30 Mar 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5936BC36AE3;
        Wed, 30 Mar 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641015;
        bh=HHjBaMZZNUVS7HlclTpFmCYSIBZArxrZX0QEnHO+Zzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcNdWqDA3jnU/XkLa+jRYu0DE6HSnIs+jdIkpK09j24l7WmC43Knn/I/77TR9ZzVW
         TrYh7RNMaAS6djwNepWzdzTMnK61k7+Y/T+qFmIIcsWvUwPwHvbnSO5xX5ETdRzZUa
         oVZxox0qNCpXYOlX9w8xdH6RUhYQA+cB0+7qZ5rqFk8XtaUSjA4VWmXSB7z2HcxzE6
         yHcoUuH8dtuSrV6f0fbtqsWt7XHhP+Vu36eNC7/2sw1zcjceZEsLm1sIvPY6blqT02
         Cz3zkox6wU1QX/Qko6uCwFTgp6ljpI9F9pNNWxmg/uwl6jhPTP+UyU+0Qwv/5yLLPl
         DxS436d5TW7fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 06/50] ASoC: sh: rz-ssi: Make the data structures available before registering the handlers
Date:   Wed, 30 Mar 2022 07:49:20 -0400
Message-Id: <20220330115005.1671090-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 0788785c78342d422f93b1c9831c2b2b7f137937 ]

Initialize the spinlock and make the data structures available before
registering the interrupt handlers.

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20220110094711.8574-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index fa0cc08f70ec..f6ba00bfcc80 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -975,6 +975,9 @@ static int rz_ssi_probe(struct platform_device *pdev)
 	ssi->playback.priv = ssi;
 	ssi->capture.priv = ssi;
 
+	spin_lock_init(&ssi->lock);
+	dev_set_drvdata(&pdev->dev, ssi);
+
 	/* Error Interrupt */
 	ssi->irq_int = platform_get_irq_byname(pdev, "int_req");
 	if (ssi->irq_int < 0)
@@ -1022,8 +1025,6 @@ static int rz_ssi_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_resume_and_get(&pdev->dev);
 
-	spin_lock_init(&ssi->lock);
-	dev_set_drvdata(&pdev->dev, ssi);
 	ret = devm_snd_soc_register_component(&pdev->dev, &rz_ssi_soc_component,
 					      rz_ssi_soc_dai,
 					      ARRAY_SIZE(rz_ssi_soc_dai));
-- 
2.34.1

