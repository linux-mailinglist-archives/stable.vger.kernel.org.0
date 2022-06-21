Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A9553D15
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355356AbiFUVBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355171AbiFUU5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:57:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC58631DF2;
        Tue, 21 Jun 2022 13:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD846618BC;
        Tue, 21 Jun 2022 20:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94911C341C7;
        Tue, 21 Jun 2022 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844644;
        bh=M5ZujuZ0mG33Rr/sqbkSj4dYDw6RrPY7vPQnXkZ/t0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrpR/9xiDHxi+iO5S33OTDTsVqTo7L2Kre0eotKOimzHAeLz0m8tkyQR2mBE05dtl
         HRH50XGX375YjHwYNhsDqnOb6YDAXaSxLMkvTdz8LAv4+9swRY4NQaon8/pJqDpWvs
         jGzQ92ZKhTYZyluZBj7hsBWrmJZlp6+lDeoP5/VtNFVs3meZLh4utwm+kimMXyB0mI
         SQKjkzpUO80DtFcpGdp4+bzu6FfDFQmPSd4YJuer7v7tWZ7mr8ki2HjJmyD3V706lM
         cK22btl/ywPDZaFH6iLmuDXor4RbBdzVyG0YbBMJOsvxEYBWKUXO3N1Ow2lpXR0Qj3
         uEWHoi8SCPxFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mhiramat@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 02/17] irqchip/uniphier-aidet: Add compatible string for NX1 SoC
Date:   Tue, 21 Jun 2022 16:50:25 -0400
Message-Id: <20220621205041.250426-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205041.250426-1-sashal@kernel.org>
References: <20220621205041.250426-1-sashal@kernel.org>
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

