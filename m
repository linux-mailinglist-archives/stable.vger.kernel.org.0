Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F2E408DC2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbhIMN3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242107AbhIMN1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE45A610A2;
        Mon, 13 Sep 2021 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539385;
        bh=oku3pLsjyovZf5YixxUHNZcpBZYcguqX0BLtEYNXb6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBIAlHqZ4zut0lFdw28s41yFvqWKHUIz4FymvfoNYGwYbdn6BUdINMNUVGCD+uDlr
         sNZO5N5IwtdiubRJiFVOaSOMwjkKDXY4khyRzDxxIYf9JWumThUSwye+fuJLGbGQDv
         glAEO8HcwT6y43JNQwcF6+U9gl8fd35FtVZrY5dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 133/144] perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op
Date:   Mon, 13 Sep 2021 15:15:14 +0200
Message-Id: <20210913131052.385500911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
@@ -562,6 +562,7 @@ static struct perf_ibs perf_ibs_op = {
 		.start		= perf_ibs_start,
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
+		.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,


