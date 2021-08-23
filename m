Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCE23F47A2
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 11:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhHWJdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 05:33:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39208 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhHWJdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 05:33:33 -0400
Date:   Mon, 23 Aug 2021 09:32:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629711169;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ww4vxget9G6Vzl6PKi1K2aPZYIQ1e0uDlZ5uHoc2P+I=;
        b=Grzr9LxgOG89MW+tqkM7AWCMvY2dPDipR9TJYfv5q9pP82Vsr5ECpcES1i/kafNfG3YUOE
        ZtnluP5w3jS/eIXtAXXJW99W4E99pTV9lpx75H1EFCYFE6U60DMI6BJ3lr5GJJLGlFbPCg
        7/TOlbytNoRbcSnhlDIGaio2pCNpMPpJQFBA1lnB3SU3MzWl7+AjArGfG8XhKGaqReE6PT
        E1vcKaJlH1YAxED00yM5LZZ3pqiJa6IxCXaIMQy7jTfJdAqfaMJ3w/PbTeoxNwSFHyU5xR
        z2fmmPYQUDzj3DC0wvTbDYI0nm1MZQlHtkoWquXGqtU7yzdiEsv01yHgzB4qfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629711169;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ww4vxget9G6Vzl6PKi1K2aPZYIQ1e0uDlZ5uHoc2P+I=;
        b=ZHIBK2HNeyYiShEyv8qpPAdU3V15mXPQdSo4Ap4sd9uuBg6aT7GpzyCj0PvMl8IQx7Gi86
        WxM1PjKT+zpb1VCg==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op
Cc:     Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210817221048.88063-2-kim.phillips@amd.com>
References: <20210817221048.88063-2-kim.phillips@amd.com>
MIME-Version: 1.0
Message-ID: <162971116886.25758.9267225679528727844.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     969d38d62fde952d57720e384fb09f60d9ad08d9
Gitweb:        https://git.kernel.org/tip/969d38d62fde952d57720e384fb09f60d9ad08d9
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Tue, 17 Aug 2021 17:10:41 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 20 Aug 2021 12:33:12 +02:00

perf/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op

Commit 2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for
exclusion incapable PMUs") neglected to do so.

Fixes: 2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for exclusion incapable PMUs")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210817221048.88063-2-kim.phillips@amd.com
---
 arch/x86/events/amd/ibs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 40669ea..8c25fbd 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -570,6 +570,7 @@ static struct perf_ibs perf_ibs_op = {
 		.start		= perf_ibs_start,
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
+		.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
