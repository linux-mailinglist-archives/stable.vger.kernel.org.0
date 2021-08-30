Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD53FB598
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhH3MGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236771AbhH3MBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054BC6112F;
        Mon, 30 Aug 2021 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324814;
        bh=Omw1PFBQpa2oGnMIlEQ1ce+cdnCzeMg2fpLt5V870oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0/DyBiJdiutApfdaui9/qrFgIi+tSlJ5WRfPu/5D9whlR3iYI45T35mFfHmKqTtD
         MHpuTQtBchXOMBbOmdC76G6ygqAVjfbVL8U3J4ZC11Craa1g5YtYoANjQwDayLUifC
         J/iXyEZyYi331LPdCYUxed71cRucHSlERuCLqA5nT2Bwc3HYy3EUwRH/nbZwgWZyOs
         y7tof6eieTNVU6BHLo2bHETgBn7MzNDbf8Mjx9WIgOOilodSrO8DhTGK0bkpOdCWAV
         +IM+iSM2A6yfYNCcNoMrUsHZNujHnOxA24SgKfOFeMEGpOxX74AJvYr/zPj+H/5e74
         UezGdKGrbqNXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/11] perf/x86/amd/power: Assign pmu.module
Date:   Mon, 30 Aug 2021 08:00:00 -0400
Message-Id: <20210830120002.1017700-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120002.1017700-1-sashal@kernel.org>
References: <20210830120002.1017700-1-sashal@kernel.org>
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
index 16a2369c586e..37d5b380516e 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -213,6 +213,7 @@ static struct pmu pmu_class = {
 	.stop		= pmu_event_stop,
 	.read		= pmu_event_read,
 	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.module		= THIS_MODULE,
 };
 
 static int power_cpu_exit(unsigned int cpu)
-- 
2.30.2

