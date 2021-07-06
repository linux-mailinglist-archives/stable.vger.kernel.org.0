Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1143BCFF8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhGFLb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233212AbhGFLZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D084861D54;
        Tue,  6 Jul 2021 11:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570379;
        bh=lFRZNA2axd6y0gh1OLNz3qNQ8ml1pC4bSsvWlDJIezE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuDnwozQ1mpDOL9HYaIHzmibBVTPB+81lDiSvUPE/tLcj0O+XM4hrxiJnyI46986/
         PnjPkHdRVQdfgZV//Ii3qblwPSesfl5bO7YzqbSiDE6neeoFMY3SWUnuulvsslGIr4
         Y7nuk2YxI18YxUtdof0bllAjSO2hXPNbNLtFJ3TYgzdNaWwwgHhqKHQlt3LuqVvwoX
         mzrUdJrQxvnr2VJ9dHHQNLrKBRbruWlLaFPxYHWLrW5AOYxNDXeKPzEhV0trFj/tF/
         LVNsmZF6JxZjtB0hoAhg/9LLzbTc1kACQI2DtVXJybBAgCumgayfqLZMVs59F0V9/N
         pOiLDdTnCRZIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 054/160] MIPS: ingenic: Select CPU_SUPPORTS_CPUFREQ && MIPS_EXTERNAL_TIMER
Date:   Tue,  6 Jul 2021 07:16:40 -0400
Message-Id: <20210706111827.2060499-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index e89d63cd92d1..ab73622b14dd 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -425,6 +425,8 @@ config MACH_INGENIC_SOC
 	select MIPS_GENERIC
 	select MACH_INGENIC
 	select SYS_SUPPORTS_ZBOOT_UART16550
+	select CPU_SUPPORTS_CPUFREQ
+	select MIPS_EXTERNAL_TIMER
 
 config LANTIQ
 	bool "Lantiq based platforms"
-- 
2.30.2

