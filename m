Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AFD3FB573
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhH3MDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236848AbhH3MB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0E1061205;
        Mon, 30 Aug 2021 12:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324828;
        bh=X3bhiUlAufGCTM6lTGf8Zx8nIqp8Pnl4bDwRLSOpxMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2ILfCmfO3bYCRiGl1tEkurY9d163KKxV9SyHMA/nFn5EK6waYdBeR88E6keVA/tv
         OIQJqVgDW8NlElKIxBLbi0EzbB1hcziud2g0eEkV63BB0pe56hkOSG9pUIdN5+9BaX
         HRu74P7rKUfPDoGABhL21C/IVlx0Poktbjpv+jgAY8k/rXk+hKP+l8ealOwqJm3R/j
         mszxoxqNDZbtwKEIumGkXvjgnsKGXWe9X+/J+lvwDts6V5A/S+DLuS8l6tv2pT1d1O
         HMnYBGTvUPCcoO0YLNkydQT9FNPkzN6qhmcbUQDZn1uSMZrR6cpki2MB0+QHPe4GIx
         6+v+LQoAmlPTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/10] perf/x86/amd/power: Assign pmu.module
Date:   Mon, 30 Aug 2021 08:00:15 -0400
Message-Id: <20210830120018.1017841-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120018.1017841-1-sashal@kernel.org>
References: <20210830120018.1017841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit ccf26483416a339c114409f6e7cd02abdeaf8052 ]

Assign pmu.module so the driver can't be unloaded whilst in use.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210817221048.88063-4-kim.phillips@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/power.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/power.c b/arch/x86/events/amd/power.c
index abef51320e3a..c4892b7d0c36 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -217,6 +217,7 @@ static struct pmu pmu_class = {
 	.stop		= pmu_event_stop,
 	.read		= pmu_event_read,
 	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.module		= THIS_MODULE,
 };
 
 static int power_cpu_exit(unsigned int cpu)
-- 
2.30.2

