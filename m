Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E75B417DE3
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 00:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345445AbhIXWp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 18:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345228AbhIXWpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC50D6125F;
        Fri, 24 Sep 2021 22:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523431;
        bh=HCu43QJN8fFUzH4pAk1RQ0of9jxD2g34gKG0VdTvrhM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iYum7Ix/m2ny1WTeBnle6o3J3a4o0vmG1Q35VZplyKSwWuDwYWODHxebIaxSyPMzM
         hEhRiXILvtiIbJ0l3IvyfeA/RNkoE20UC918snJLXIyeaDqrewlsyzi9FlVGS7KQO4
         5dduA5axwqbfr3qCXm2lWQfb65mcJwXNdrOoxoIs=
Date:   Fri, 24 Sep 2021 15:43:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        dave.hansen@linux.intel.com, jhubbard@nvidia.com,
        khandual@linux.vnet.ibm.com, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        o451686892@gmail.com, osalvador@suse.de, pasha.tatashin@soleen.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        weixugc@google.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 11/16] mm/debug: sync up MR_CONTIG_RANGE and
 MR_LONGTERM_PIN
Message-ID: <20210924224350.E8gKVdmtm%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weizhao Ouyang <o451686892@gmail.com>
Subject: mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN

Sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN to migrate_reason_names.

Link: https://lkml.kernel.org/r/20210921064553.293905-2-o451686892@gmail.com
Fixes: 310253514bbf ("mm/migrate: rename migration reason MR_CMA to MR_CONTIG_RANGE")
Fixes: d1e153fea2a8 ("mm/gup: migrate pinned pages out of movable zone")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin
+++ a/mm/debug.c
@@ -24,7 +24,8 @@ const char *migrate_reason_names[MR_TYPE
 	"syscall_or_cpuset",
 	"mempolicy_mbind",
 	"numa_misplaced",
-	"cma",
+	"contig_range",
+	"longterm_pin",
 };
 
 const struct trace_print_flags pageflag_names[] = {
_
