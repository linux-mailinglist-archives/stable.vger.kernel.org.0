Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0912A0A83
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgJ3P5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:57:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55841 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726899AbgJ3P5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:57:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2BD295C02E4;
        Fri, 30 Oct 2020 11:57:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 30 Oct 2020 11:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=from
        :to:cc:subject:date:message-id:reply-to:mime-version
        :content-type:content-transfer-encoding; s=fm1; bh=GgFywE3sedM8p
        RqGb2GCUrt5KozSDzUlHAh3jMIZlYc=; b=ELu5vcLmJCPbE1orsyqdaspWVSIsY
        5oksyRCGM576vzsq89hLCxIBtbLPiCCrpDaFw83NsKi3/IznqGNNbiqhpTwgQhK+
        Ufls4ptpwl56aGFMNH6Df/oT3Wu+08VrHoUK+yqU72y2JeCEzoNkETULRfqFXcx3
        6oCb2Asj+gmC+Y2ZZCEJtz7EXKo1eNDHHRwHn7pGhXWCxaGQE+ZD1hoG7Ju8pSvM
        CyYf+VwStncPVVlBqmQ7GGbCb7yAEuyid1JVD9faaPMlLpPcD4tarWsAl95+voEw
        4sC0+/7hjoGctlNjU0tAZLv0Mzuo0WVb3UpYE4xYxvdHSwxv+tQslMSYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:reply-to:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GgFywE3sedM8pRqGb2GCUrt5KozSDzUlHAh3jMIZlYc=; b=kcys9TqQ
        hx/6X5aclY41cAAm2+CfJLf318GOtMzVEb/zdTO0t/7En4msj8YMVxEWK5DtkKo0
        p0sc/FfWfrwEvsGTXVK2R/zZhZ261K7d6pSKPJTw+H3V91x4fJxDxfo4ITgtejc7
        J1vhAC2//JgIyKVxNowH5HCr2Ta1qo1s7GXVQyP+VSohKjuJryAdbiFbLaMHwEAI
        9TjVqDghhW/QbkkhhJDsjd9mCJNsogaj5/ztJJR2BDoM5AsJH0QxdA03I500RqdX
        a4p8c2+VD+GQ1qixZkJ8OgaL9+hXQqkh4G9KUtXdLe2xaZ5MBInP2/P43rRZn6ng
        +KASUSrMSm1fuA==
X-ME-Sender: <xms:6jecXxg_gwZ5JGpMUQWVAkYyxETPf1H_nKX48ZCsvM7Rfi4AdJMBqA>
    <xme:6jecX2CJp_J4KLY4M2llGpto-z2f9BNE5qKVEueM5IKp1GjCQGTlDJOFYrvnpjc01
    I3L3yI5sxhim1x2dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleehgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofhrgggtgfesthhqredtredtjeenucfhrhhomhepkghiucgjrghn
    uceoiihirdihrghnsehsvghnthdrtghomheqnecuggftrfgrthhtvghrnhepudevleffhe
    duuddvhfdtvdehfeekjedtleeifefhgeehjeetvdethfefvdekkeelnecukfhppeduvddr
    geeirddutdeirdduieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepiihirdihrghnsehsvghnthdrtghomh
X-ME-Proxy: <xmx:6jecXxEWorKtSdxIzLyeaxLWpNqaf6Ga4dQDdayfjPA2Q273mekKqA>
    <xmx:6jecX2QXZgkVAUY8Feb4FjPY-rRDPkvlJT3HHxROI2guU0kNLvecpg>
    <xmx:6jecX-yR7z3thC0k-bOrAdvJOH5sU9sM8gjuFPLZLReLY813vPwfUQ>
    <xmx:6zecX1maHvD-O-QuMbHHXs7cUF5FpywD-m1hpxc84WUFIb0S7G6fTw>
Received: from nvrsysarch6.NVidia.COM (unknown [12.46.106.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B8B8328005E;
        Fri, 30 Oct 2020 11:57:30 -0400 (EDT)
From:   Zi Yan <zi.yan@sent.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 1/2] mm/compaction: count pages and stop correctly during page isolation.
Date:   Fri, 30 Oct 2020 11:57:15 -0400
Message-Id: <20201030155716.3614401-1-zi.yan@sent.com>
X-Mailer: git-send-email 2.28.0
Reply-To: Zi Yan <ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

In isolate_migratepages_block, when cc->alloc_contig is true, we are
able to isolate compound pages, nr_migratepages and nr_isolated did not
count compound pages correctly, causing us to isolate more pages than we
thought. Use thp_nr_pages to count pages. Otherwise, we might be trapped
in too_many_isolated while loop, since the actual isolated pages can go
up to COMPACT_CLUSTER_MAX*512=3D16384, where COMPACT_CLUSTER_MAX is 32,
since we stop isolation after cc->nr_migratepages reaches to
COMPACT_CLUSTER_MAX.

In addition, after we fix the issue above, cc->nr_migratepages could
never be equal to COMPACT_CLUSTER_MAX if compound pages are isolated,
thus page isolation could not stop as we intended. Change the isolation
stop condition to >=3D.

The issue can be triggered as follows:
In a system with 16GB memory and an 8GB CMA region reserved by
hugetlb_cma, if we first allocate 10GB THPs and mlock them
(so some THPs are allocated in the CMA region and mlocked), reserving
6 1GB hugetlb pages via
/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages will get stuck
(looping in too_many_isolated function) until we kill either task.
With the patch applied, oom will kill the application with 10GB THPs and
let hugetlb page reservation finish.

Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migration fo=
r CMA allocations=E2=80=9D)
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
---
 mm/compaction.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index ee1f8439369e..3e834ac402f1 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1012,8 +1012,8 @@ isolate_migratepages_block(struct compact_control *cc=
, unsigned long low_pfn,
=20
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
-		cc->nr_migratepages++;
-		nr_isolated++;
+		cc->nr_migratepages +=3D compound_nr(page);
+		nr_isolated +=3D compound_nr(page);
=20
 		/*
 		 * Avoid isolating too much unless this block is being
@@ -1021,7 +1021,7 @@ isolate_migratepages_block(struct compact_control *cc=
, unsigned long low_pfn,
 		 * or a lock is contended. For contention, isolate quickly to
 		 * potentially remove one source of contention.
 		 */
-		if (cc->nr_migratepages =3D=3D COMPACT_CLUSTER_MAX &&
+		if (cc->nr_migratepages >=3D COMPACT_CLUSTER_MAX &&
 		    !cc->rescan && !cc->contended) {
 			++low_pfn;
 			break;
@@ -1132,7 +1132,7 @@ isolate_migratepages_range(struct compact_control *cc=
, unsigned long start_pfn,
 		if (!pfn)
 			break;
=20
-		if (cc->nr_migratepages =3D=3D COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages >=3D COMPACT_CLUSTER_MAX)
 			break;
 	}
=20
--=20
2.28.0

