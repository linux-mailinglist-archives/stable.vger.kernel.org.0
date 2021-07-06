Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC77C3BD11E
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbhGFLi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235089AbhGFLd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9201161D2F;
        Tue,  6 Jul 2021 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570587;
        bh=G2nzf0gXd2W5OSMmOy62iXfCIWuNGIizdeqqd4gYbWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPPLotg2hAi1hTdVWolIRcjqLLrAXq1iuOD3LHq9vfzdN2DYBtCn4vL+20hyz2asU
         1EJ7XRKmxzPvs4Mx7W+koldOYN3Wy70YS3q7cTSBFs++Yz/XyjWhniqzgerjDIN0gW
         zlEEaK7F7Mgbd5/DtS+MBPFFHFRHbbXqYOlbIyEKEqsM/PwwS07BwR/BIxkAIez8oH
         XhuJYBlK37ddAwuqPZ+SAARe9Wh5Q8qwA3zkx2lLwFLFikJCG/k7PqhYD120/X9Rsm
         QHPRX6URD3xGBWyUn1sD/KChONCuqPxE9iS4xd2+T6SuEU8OrPk1LA55jGpGxJSEnI
         ur85vzlF4KMmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 049/137] MIPS: ingenic: Select CPU_SUPPORTS_CPUFREQ && MIPS_EXTERNAL_TIMER
Date:   Tue,  6 Jul 2021 07:20:35 -0400
Message-Id: <20210706112203.2062605-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit eb3849370ae32b571e1f9a63ba52c61adeaf88f7 ]

The clock driving the XBurst CPUs in Ingenic SoCs is integer divided
from the main PLL. As such, it is possible to control the frequency of
the CPU, either by changing the divider, or by changing the rate of the
main PLL.

The XBurst CPUs also lack the CP0 timer; the TCU, a separate piece of
hardware in the SoC, provides this functionality.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 1917ccd39256..1a63f592034e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -418,6 +418,8 @@ config MACH_INGENIC_SOC
 	select MIPS_GENERIC
 	select MACH_INGENIC
 	select SYS_SUPPORTS_ZBOOT_UART16550
+	select CPU_SUPPORTS_CPUFREQ
+	select MIPS_EXTERNAL_TIMER
 
 config LANTIQ
 	bool "Lantiq based platforms"
-- 
2.30.2

