Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584AC3BCC12
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhGFLSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhGFLSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 929B261C22;
        Tue,  6 Jul 2021 11:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570140;
        bh=yF3Xfk587sd+A00D3s6oJyfhF4EB3WXKxWmJ+VimC3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1g2dGZv7WL1Jq+uu61dxMaIfuLA9WZyWr2+9u6EldFMYLzWsPCA0NMOlJRxY19Gu
         pFXY006c1+A3byFxNctD44KcdOJC9Qt/l/3ViafnPoWefF4lEqkJDaoF+2YfVTrV3W
         UWcbuZPnPq7Z9o/3Rec/P3wcnlQd1yrPe4g9Vj1EA/4Hywmcjv+YC1xnAqlSf3ZuSi
         qfM8rJgtycVQ/hCbQ+nPoJ1+x8zttR7AB9JOWnoBChKOIoxyoBitS/AnLK05fKYOcm
         OhnMdIcDbnPcUO4+IId0p4xJGClLJlxe9qjazCLfhxUAo9H2eqmGS0+uLp2GVYUesW
         5SBLt7qAxAc1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 065/189] MIPS: ingenic: Select CPU_SUPPORTS_CPUFREQ && MIPS_EXTERNAL_TIMER
Date:   Tue,  6 Jul 2021 07:12:05 -0400
Message-Id: <20210706111409.2058071-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index ed51970c08e7..344e6c622efd 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -428,6 +428,8 @@ config MACH_INGENIC_SOC
 	select MIPS_GENERIC
 	select MACH_INGENIC
 	select SYS_SUPPORTS_ZBOOT_UART16550
+	select CPU_SUPPORTS_CPUFREQ
+	select MIPS_EXTERNAL_TIMER
 
 config LANTIQ
 	bool "Lantiq based platforms"
-- 
2.30.2

