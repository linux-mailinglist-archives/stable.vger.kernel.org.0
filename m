Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C9EA7061
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfICQiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbfICQ0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C15723878;
        Tue,  3 Sep 2019 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527965;
        bh=30QEGkxfn5pSm9e0Kcd5LEab6oRuUPRrlQwwUsRbDsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Smsp2NbKvr96Da/Eb2NEoman4yufVh58Rp3fwCyHX7S7CVhf34q0j5Nv+A00oetp0
         0nS8zIV448KlFD0ltCq3OH6ONUl2Q4k8ikbq8mhn2/RphNX3hpI7YrFSBHHz3CTacO
         mjOjWFtRiJNuG/nbdG/4jJRy+4fwJ1pG5CANNLu4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 025/167] ARM: davinci: da8xx: define gpio interrupts as separate resources
Date:   Tue,  3 Sep 2019 12:22:57 -0400
Message-Id: <20190903162519.7136-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 58a0afbf4c99ac355df16773af835b919b9432ee ]

Since commit eb3744a2dd01 ("gpio: davinci: Do not assume continuous
IRQ numbering") the davinci GPIO driver fails to probe if we boot
in legacy mode from any of the board files. Since the driver now
expects every interrupt to be defined as a separate resource, split
the definition of IRQ resources instead of having a single continuous
interrupt range.

Fixes: eb3744a2dd01 ("gpio: davinci: Do not assume continuous IRQ numbering")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/devices-da8xx.c | 40 +++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 3c42bf9fa0618..708931b470909 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -704,6 +704,46 @@ static struct resource da8xx_gpio_resources[] = {
 	},
 	{ /* interrupt */
 		.start	= IRQ_DA8XX_GPIO0,
+		.end	= IRQ_DA8XX_GPIO0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO1,
+		.end	= IRQ_DA8XX_GPIO1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO2,
+		.end	= IRQ_DA8XX_GPIO2,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO3,
+		.end	= IRQ_DA8XX_GPIO3,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO4,
+		.end	= IRQ_DA8XX_GPIO4,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO5,
+		.end	= IRQ_DA8XX_GPIO5,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO6,
+		.end	= IRQ_DA8XX_GPIO6,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO7,
+		.end	= IRQ_DA8XX_GPIO7,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO8,
 		.end	= IRQ_DA8XX_GPIO8,
 		.flags	= IORESOURCE_IRQ,
 	},
-- 
2.20.1

