Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0A440930C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344416AbhIMORO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236260AbhIMOPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1FF61AF8;
        Mon, 13 Sep 2021 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540644;
        bh=5hD6q1pzoGrR6xKPjQolXDNYdii5N34BwihUufb8VPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oynlCXoiUoWhZ+Nb2vQqa3yrMesesiUPrziXw2L+2lNn/r3YQFYjoxCbun6JfCDVm
         MQypyn7ndzj0o+jjpNcB+KUh2YiJfayzPVB3cx8yyZWNi2KbzNAbAwXgSdK6XQrixF
         5BdZYc9hfRB9Se1yJFkQBeAPCm5PmxLcN8Brb3nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.13 278/300] perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op
Date:   Mon, 13 Sep 2021 15:15:39 +0200
Message-Id: <20210913131118.729192049@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit f11dd0d80555cdc8eaf5cfc9e19c9e198217f9f1 upstream.

Commit:

   2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for exclusion incapable PMUs")

neglected to do so.

Fixes: 2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for exclusion incapable PMUs")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210817221048.88063-2-kim.phillips@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/ibs.c |    1 +
 1 file changed, 1 insertion(+)

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


