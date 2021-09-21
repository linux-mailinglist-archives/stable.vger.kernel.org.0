Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37079413BA6
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhIUUph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235054AbhIUUph (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 16:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2177060F6E;
        Tue, 21 Sep 2021 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632257048;
        bh=LCUdX9uaus9hJtoG/wSmG2uSRoCWQDUjyrmkh+aH6kc=;
        h=Date:From:To:Subject:From;
        b=HDHIRP7/WXmM4jvJNNVLSictF2mcoS6L+cTXdc8F9Rr3TriXUZ57LdioPbwsAHWVX
         GNnByI4RV4ddJBZLHCpGP1LjeCZ35h/zrISidcQtIZb/TveKgf75oQ53itSmJpDEyg
         d9KOQxMizdj1lN87A5GVy2FxBMrm7AncGtjCbH+s=
Date:   Tue, 21 Sep 2021 13:44:07 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, dave.hansen@linux.intel.com,
        jhubbard@nvidia.com, khandual@linux.vnet.ibm.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        o451686892@gmail.com, osalvador@suse.de, pasha.tatashin@soleen.com,
        stable@vger.kernel.org, weixugc@google.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  +
 mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin.patch added to -mm
 tree
Message-ID: <20210921204407.acmMlcibD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN
has been added to the -mm tree.  Its filename is
     mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weizhao Ouyang <o451686892@gmail.com>
Subject: mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN

Sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN to migrate_reason_names.

Link: https://lkml.kernel.org/r/20210921064553.293905-2-o451686892@gmail.com
Fixes: 310253514bbf ("mm/migrate: rename migration reason MR_CMA to MR_CONTIG_RANGE")
Fixes: d1e153fea2a8 ("mm/gup: migrate pinned pages out of movable zone")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: John Hubbard <jhubbard@nvidia.com>
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

Patches currently in -mm which might be from o451686892@gmail.com are

mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin.patch
mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names.patch

