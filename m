Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8839E553CEE
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355271AbiFUVCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355644AbiFUVAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:00:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1FC110E;
        Tue, 21 Jun 2022 13:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13D7B81B47;
        Tue, 21 Jun 2022 20:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CB5C341C4;
        Tue, 21 Jun 2022 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844683;
        bh=M5ZujuZ0mG33Rr/sqbkSj4dYDw6RrPY7vPQnXkZ/t0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxCvZ+GrotMBP5r2Gn4oyZBNZx0HyPODgIkaY3EA3w9bffETP1rKDBQ+6XpADle0h
         WviV6zxpnfFeZzYdbmzhc8iHj2jq7zty/zDJ/JLogllBK4min2ywvM280s+xCHvibY
         TJT8gw+naQgsaYJJqThrvo2qrJqMG5QiDX8h2X8j7pkGYtBiS4pxZsa67n7cpcWcS9
         7ulADEDIKgq+8gMgOzNQBjyFj7AzN7FEorgLt9ig/KBzSnI3RJgHsqBajZfFsK184F
         c9NEegt1VDlnHSSc1pWsjFsUuyb71y0n+sF37mkSB6bVo2T2JTsQKfv+kPL9TUPpQa
         1TP/z/9aBxILQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mhiramat@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 2/7] irqchip/uniphier-aidet: Add compatible string for NX1 SoC
Date:   Tue, 21 Jun 2022 16:51:14 -0400
Message-Id: <20220621205120.250779-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205120.250779-1-sashal@kernel.org>
References: <20220621205120.250779-1-sashal@kernel.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit e3f056a7aafabe4ac3ad4b7465ba821b44a7e639 ]

Add the compatible string to support UniPhier NX1 SoC, which has the same
kinds of controls as the other UniPhier SoCs.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1653023822-19229-3-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-uniphier-aidet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-uniphier-aidet.c b/drivers/irqchip/irq-uniphier-aidet.c
index 89121b39be26..716b1bb88bf2 100644
--- a/drivers/irqchip/irq-uniphier-aidet.c
+++ b/drivers/irqchip/irq-uniphier-aidet.c
@@ -237,6 +237,7 @@ static const struct of_device_id uniphier_aidet_match[] = {
 	{ .compatible = "socionext,uniphier-ld11-aidet" },
 	{ .compatible = "socionext,uniphier-ld20-aidet" },
 	{ .compatible = "socionext,uniphier-pxs3-aidet" },
+	{ .compatible = "socionext,uniphier-nx1-aidet" },
 	{ /* sentinel */ }
 };
 
-- 
2.35.1

