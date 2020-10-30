Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2104C2A0D99
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgJ3SiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:38:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58917 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgJ3SiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:38:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B3DF25C01B0;
        Fri, 30 Oct 2020 14:38:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 30 Oct 2020 14:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=from
        :to:cc:subject:date:message-id:reply-to:mime-version
        :content-type:content-transfer-encoding; s=fm1; bh=WHa0SDu+o/Klm
        eJ7jdg6c0+1vR3M09ykjvWEYKJShPk=; b=WL7U4SG3EyfKXayCNo3Wc90uaP7yR
        ex/cFhD399XwftJhR13NsWFiLKA28wwbzRPGShPoNFk9l3e+jkx8wMPtTOl4rapV
        xL1a3P/VLC0+03aFdBaHU9OsYGcjytJj1Ws9G5zEuDv/Cb/FuuWF/DKQJMI6s64/
        utb4B39d7Q4apl+gux/EJy3tv9j/+M23UoZ1ztLLA3BC29K4o3BPa/I9+otoi8fu
        OOurMM/reUMSXotBaZcGgLa6Nw0SgIPCXbXPaFuPQJ3VEZdze7JYSEa660ODuz2C
        O8f4b9KKD5Lw9ZK5tOMjVUDVra1jtp7v29N6MVAMNSmxBZYqppYu8K0LQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:reply-to:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WHa0SDu+o/KlmeJ7jdg6c0+1vR3M09ykjvWEYKJShPk=; b=PFdhSCBI
        czjbLSxl1+LquOZu4uQ4k7uTfrDtBwAmoiRwmJ+rUnyB/hz1uCW559BZMWjKJz6u
        G0repYGim34yzi+aMrcsXr4vvtJDSEK/W2ft23A4v6BcEZ/tPwf4j0DpbwUzkZj2
        s90gWU19OWAgrk3ESqR6GwISf6mXOqayecSU+ueC6g2HFU+Xu4LrSGBuntJ0sgM/
        uIu9ez7YhgwNrkReyKTR+4ZmlSZOZOUmRXyJfyC9Sb8LipnUluB4cD/t4vHbBfkY
        8ZUuACXgc5/9SI+gMhVRNFMT2tCF6sWH36a2artw0eQG1P3ERR3vNyM2bSZWoOit
        RQMRCtjqdlzOEg==
X-ME-Sender: <xms:lV2cX9WFbI56iqq3vXP7WOTGQwEMQn0rC-06nu8vv8pIgVsyRSnQ4A>
    <xme:lV2cX9l1xIIwgPUAZ3vYFJqi81ttpgpwGlSI1SexV_WwGOHmU9Cak2pI8jRN2VhtH
    Gw1cuQRwpRpgKCY_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleehgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfforhggtgfgsehtqhertdertdejnecuhfhrohhmpegkihcujggr
    nhcuoeiiihdrhigrnhesshgvnhhtrdgtohhmqeenucggtffrrghtthgvrhhnpeduveelff
    ehudduvdfhtddvheefkeejtdelieefhfegheejtedvtefhfedvkeekleenucfkphepuddv
    rdegiedruddtiedrudeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpeiiihdrhigrnhesshgvnhhtrdgtohhm
X-ME-Proxy: <xmx:lV2cX5Z78_h0U2ZW8JZWNjBX169USqAWU135EFDnhPKSx1CrplPexg>
    <xmx:lV2cXwXP3wc-TJkuS-2mo6JpZzqupZ28A6ZRRVja27BeF1BMqLH5mg>
    <xmx:lV2cX3lnKdmBYvPocJmLtnb1_6vn7q9pIOn7af2vqO7KE1Ly5ZVPpw>
    <xmx:mF2cX1YKizL0LU_4FdfZhyFvxVhZytcWR_hyBr_TEyzff0QXTFbUaQ>
Received: from nvrsysarch6.NVidia.COM (unknown [12.46.106.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0D153280059;
        Fri, 30 Oct 2020 14:38:12 -0400 (EDT)
From:   Zi Yan <zi.yan@sent.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 1/2] mm/compaction: count pages and stop correctly during page isolation.
Date:   Fri, 30 Oct 2020 14:38:08 -0400
Message-Id: <20201030183809.3616803-1-zi.yan@sent.com>
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
thought. Count compound pages as the number of base pages they contain.
Otherwise, we might be trapped in too_many_isolated while loop,
since the actual isolated pages can go up to
COMPACT_CLUSTER_MAX*512=3D16384, where COMPACT_CLUSTER_MAX is 32,
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

