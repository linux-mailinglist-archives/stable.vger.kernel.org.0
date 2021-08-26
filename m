Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B323F8345
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 09:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbhHZHqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 03:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbhHZHqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 03:46:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94781C061757;
        Thu, 26 Aug 2021 00:45:28 -0700 (PDT)
Date:   Thu, 26 Aug 2021 07:45:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629963926;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQipVrCy1IUbXan70wnQxvoPiTbKRdUwkk2dkrVHTNg=;
        b=xvbfIWzFiIrC/cBJCZYeDO1x78UcEhi0fK3GvCVmQaf/A/hRnxFcEfH2FFcj+vYT3KPfSr
        69NCnYzhfSp91z+Y8bNnqbIbUPVFebozpspWkiUx/Cs89LYXAx0aIxRQg+wP8ME6bRUIpr
        4p6B897g4Ud72hPf0fAqj+Ykotil45yzAX3gfVXZfqb/lYBPzH+5HMaG8okZcLPB2+JMox
        MpwFDi7qzX53gW7pGcW0/cj4CL1CQqnJBkcCWF3A+pY8aPOubnfvgPbWZ+aWa/+YmcIQGG
        n1A73TgfkbenMpWx8bRaYNnF8A1Es4wWF+c5SiFTJZeo2+8CUDYZO+3w3mpiNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629963926;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQipVrCy1IUbXan70wnQxvoPiTbKRdUwkk2dkrVHTNg=;
        b=UyUdeGl9GfEmJQoLBCp5fSnUr8roiHdVqCHtFO0z9UrVDB9ZOefK1cOutFWrA82PX0ubru
        ZDZPDRW+qxZShGDQ==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op
Cc:     Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210817221048.88063-2-kim.phillips@amd.com>
References: <20210817221048.88063-2-kim.phillips@amd.com>
MIME-Version: 1.0
Message-ID: <162996392554.25758.14013242861301575176.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     f11dd0d80555cdc8eaf5cfc9e19c9e198217f9f1
Gitweb:        https://git.kernel.org/tip/f11dd0d80555cdc8eaf5cfc9e19c9e198217f9f1
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Tue, 17 Aug 2021 17:10:41 -05:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Thu, 26 Aug 2021 08:58:02 +02:00

perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op

Commit:

   2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for exclusion incapable PMUs")

neglected to do so.

Fixes: 2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for exclusion incapable PMUs")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210817221048.88063-2-kim.phillips@amd.com
---
 arch/x86/events/amd/ibs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 921f47b..ccc9ee1 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -571,6 +571,7 @@ static struct perf_ibs perf_ibs_op = {
 		.start		= perf_ibs_start,
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
+		.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
