Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FBE419B77
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhI0RTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236082AbhI0RQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962F960FC2;
        Mon, 27 Sep 2021 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762698;
        bh=29GyCaD1ikDILXH7yBzcgukVcn4ho7Jl2MVyobPvy3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leALLyXzIvXXkeaPCk6mDZaPwTl/YZyHKV6nltEFqDb7izOXkkd/X4FxZHT8DR4co
         uB7+UHcI1t9CGoQcrWE+RDc5R3PBhrhKYKWNLmq/w5UVMFSu0tHap0YAKMsvlRA9w6
         Yu2jFD72QcGbztpF5dYwSllP+o9Uc/bA6St3niyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weizhao Ouyang <o451686892@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Yang Shi <yang.shi@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Mina Almasry <almasrymina@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Xu <weixugc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 003/162] mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN
Date:   Mon, 27 Sep 2021 19:00:49 +0200
Message-Id: <20210927170233.584244117@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weizhao Ouyang <o451686892@gmail.com>

commit a4ce73910427e960b2c7f4d83229153c327d0ee7 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/debug.c
+++ b/mm/debug.c
@@ -24,7 +24,8 @@ const char *migrate_reason_names[MR_TYPE
 	"syscall_or_cpuset",
 	"mempolicy_mbind",
 	"numa_misplaced",
-	"cma",
+	"contig_range",
+	"longterm_pin",
 };
 
 const struct trace_print_flags pageflag_names[] = {


