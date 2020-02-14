Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6897815F16A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731543AbgBNSCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731201AbgBNPzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A37B24686;
        Fri, 14 Feb 2020 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695753;
        bh=tbsB6vHECRwHjZ/VQdlleAytqMHIOfGHbwngLBFASr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLzpgYs9ecIaDxiKNm4N3FB0mVUy1F40aN2hSU7yzLgEISVZZFOg5StBA6leaWBU2
         dE/6TYaE7U6W0GbBisGDnp0OX5e3W6+xfNoRyNtNC2eQyMcSpulT0rJ29JhMOFV2SQ
         J0/1oVjdrGrytmg7bFcBfN+MTe6UF44pQRQOTSd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 322/542] ARM: at91: pm: use SAM9X60 PMC's compatible
Date:   Fri, 14 Feb 2020 10:45:14 -0500
Message-Id: <20200214154854.6746-322-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 6b9dfd986a81a999a27b6ed9dbe91203089c62dd ]

SAM9X60 PMC's has a different PMC. It was not integrated at the moment
commit 01c7031cfa73 ("ARM: at91: pm: initial PM support for SAM9X60")
was published.

Fixes: 01c7031cfa73 ("ARM: at91: pm: initial PM support for SAM9X60")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1576062248-18514-2-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index d5af6aedc02c4..03250768340e4 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -751,6 +751,7 @@ static const struct of_device_id atmel_pmc_ids[] __initconst = {
 	{ .compatible = "atmel,sama5d3-pmc", .data = &pmc_infos[1] },
 	{ .compatible = "atmel,sama5d4-pmc", .data = &pmc_infos[1] },
 	{ .compatible = "atmel,sama5d2-pmc", .data = &pmc_infos[1] },
+	{ .compatible = "microchip,sam9x60-pmc", .data = &pmc_infos[1] },
 	{ /* sentinel */ },
 };
 
-- 
2.20.1

