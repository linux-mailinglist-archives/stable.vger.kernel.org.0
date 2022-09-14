Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA45B7F14
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 04:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiINCjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 22:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiINCjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 22:39:21 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769B06CD16;
        Tue, 13 Sep 2022 19:39:19 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 246C4320083A;
        Tue, 13 Sep 2022 22:39:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 13 Sep 2022 22:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1663123155; x=1663209555; bh=UyQg+UYkEM
        Eqgkib34z1ZNSZrOkT0Dwdd9lIBX0BM4c=; b=y6BAqpqcti7o5bm7grFiMvxCDe
        hU2DngYxiF9pkm3wdDutcZ3rBABTAIlXN37kCK6FW54FCUKpgen/wndpwXm7rHhD
        a/enXSyLHJv6/HHlCSNKLYvDhc+BSmOm01X3T6jdVUns2qVRtkQ53kJqFKcLu+0+
        P3F8/8DmiNgAU7sl/l6R23wKvDB37NtaEWpSMBvAD07n9IncvVchsT17Ke6UJbLa
        auXfxBdebCJDGyzebUg32PXVdQY9Ec7SaEd/eNoaJ3cbK8rDpmALHhv9Axenq6DF
        o08WbiC8mR0MgPCykFaoXxJQqMK0HBMcAKvt+injo/IenxU5zPjLep3d/NTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663123155; x=1663209555; bh=UyQg+UYkEMEqgkib34z1ZNSZrOkT
        0Dwdd9lIBX0BM4c=; b=zCwVoRQ2d+oN0Ys+Eo5YOPSg5fJBfCJgsNZ6FMP/YuEh
        zkS6Dcn11WmAcPuLM5ZPETUCv4hiVRG1Hd9q7bgSaxOVdTDoYVmuifOZNaX1wdJK
        a1dTAnkz+7EMGE9CpAncrrtOc/sa7pG6w9YL+yIxtNQjvG6WiydJAv3QHF9eNXhH
        Fxx9GkDJiJdtEQ3cz6a96GAValhy4INuIaOND6/4RdG+mF70Ejnq4Ci6Xu622nnp
        DDL//uyVekxgr9fEbXhuJoL/u1FDZVgZCdZENs5f2gMaw6a3JxyxwTp3uES6FtHz
        kkK3VGXo5yY3UyXqjKaolMN+eRckEqzC+m+vJA/ZnA==
X-ME-Sender: <xms:0z4hY83J6CW0ImvBht43dSSMc6ECYx2PYq0qeEO_Soe6R7hDqXD6vQ>
    <xme:0z4hY3E2XmDc_Behuqhya_tZ88gNxHgsSqTXfNzAdtoToVF32OqLocpuIfZiNb29w
    xa9ioj7-WsvX9fWpw>
X-ME-Received: <xmr:0z4hY04Mk9LktDxz0uCyZyKuHNi9CbvTarDLTjK7V45T5_ezSVsTo6eY0depG-EBCK4HqBbr_jxRlc2uhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeduhedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofhrggfgsedtqhertdertddtnecuhfhrohhmpegkihcujggr
    nhcuoeiiihdrhigrnhesshgvnhhtrdgtohhmqeenucggtffrrghtthgvrhhnpedtgffhtd
    etledtkeeihfefueeuhedvudfhvdeifeevtdektdetgfeiieejuefhtdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeiiihdrhigrnhesshgvnh
    htrdgtohhm
X-ME-Proxy: <xmx:0z4hY129dQbjJkvqqyflF2O1P-dF_HIEWlueGepl7IuOgy4LGMKeQQ>
    <xmx:0z4hY_HyQvxYFrGsDncyQI4o_-_GFdHyzCqaDYWfL_3LuK-Umjo4Sg>
    <xmx:0z4hY--S2AMlzT7zSg7Rai_tflsLFsT4I-3rwUo0r8URGMoNi42fVg>
    <xmx:0z4hY048AG5tbxRZZY92DiK6Jq7IVwbwz9jlNclaZ3BkwYBzGVPKzQ>
Feedback-ID: iccd040f4:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Sep 2022 22:39:15 -0400 (EDT)
From:   Zi Yan <zi.yan@sent.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Doug Berger <opendmb@gmail.com>, linux-mm@kvack.org
Cc:     Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm/page_isolation: fix isolate_single_pageblock() isolation behavior
Date:   Tue, 13 Sep 2022 22:39:13 -0400
Message-Id: <20220914023913.1855924-1-zi.yan@sent.com>
X-Mailer: git-send-email 2.35.1
Reply-To: Zi Yan <ziy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

set_migratetype_isolate() does not allow isolating MIGRATE_CMA pageblocks
unless it is used for CMA allocation. isolate_single_pageblock() did not
have the same behavior when it is used together with
set_migratetype_isolate() in start_isolate_page_range(). This allows
alloc_contig_range() with migratetype other than MIGRATE_CMA, like
MIGRATE_MOVABLE (used by alloc_contig_pages()), to isolate first and last
pageblock but fail the rest. The failure leads to changing migratetype
of the first and last pageblock to MIGRATE_MOVABLE from MIGRATE_CMA,
corrupting the CMA region. This can happen during gigantic page
allocations.

Fix it by passing migratetype into isolate_single_pageblock(), so that
set_migratetype_isolate() used by isolate_single_pageblock() will prevent
the isolation happening.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granula=
rity")
Reported-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---
 mm/page_isolation.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c66d61e0bc72..04141a9bea70 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -288,6 +288,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_=
pages)
  * @isolate_before:	isolate the pageblock before the boundary_pfn
  * @skip_isolation:	the flag to skip the pageblock isolation in second
  *			isolate_single_pageblock()
+ * @migratetype:	migrate type to set in error recovery.
  *
  * Free and in-use pages can be as big as MAX_ORDER-1 and contain more tha=
n one
  * pageblock. When not all pageblocks within a page are isolated at the sa=
me
@@ -302,9 +303,9 @@ __first_valid_page(unsigned long pfn, unsigned long nr_=
pages)
  * the in-use page then splitting the free page.
  */
 static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
-			gfp_t gfp_flags, bool isolate_before, bool skip_isolation)
+			gfp_t gfp_flags, bool isolate_before, bool skip_isolation,
+			int migratetype)
 {
-	unsigned char saved_mt;
 	unsigned long start_pfn;
 	unsigned long isolate_pageblock;
 	unsigned long pfn;
@@ -328,13 +329,13 @@ static int isolate_single_pageblock(unsigned long bou=
ndary_pfn, int flags,
 	start_pfn  =3D max(ALIGN_DOWN(isolate_pageblock, MAX_ORDER_NR_PAGES),
 				      zone->zone_start_pfn);
=20
-	saved_mt =3D get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
+	if (skip_isolation) {
+		int mt =3D get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
=20
-	if (skip_isolation)
-		VM_BUG_ON(!is_migrate_isolate(saved_mt));
-	else {
-		ret =3D set_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt=
, flags,
-				isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
+		VM_BUG_ON(!is_migrate_isolate(mt));
+	} else {
+		ret =3D set_migratetype_isolate(pfn_to_page(isolate_pageblock), migratet=
ype,
+				flags, isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
=20
 		if (ret)
 			return ret;
@@ -475,7 +476,7 @@ static int isolate_single_pageblock(unsigned long bound=
ary_pfn, int flags,
 failed:
 	/* restore the original migratetype */
 	if (!skip_isolation)
-		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt);
+		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), migratetype);
 	return -EBUSY;
 }
=20
@@ -537,7 +538,8 @@ int start_isolate_page_range(unsigned long start_pfn, u=
nsigned long end_pfn,
 	bool skip_isolation =3D false;
=20
 	/* isolate [isolate_start, isolate_start + pageblock_nr_pages) pageblock =
*/
-	ret =3D isolate_single_pageblock(isolate_start, flags, gfp_flags, false, =
skip_isolation);
+	ret =3D isolate_single_pageblock(isolate_start, flags, gfp_flags, false,
+			skip_isolation, migratetype);
 	if (ret)
 		return ret;
=20
@@ -545,7 +547,8 @@ int start_isolate_page_range(unsigned long start_pfn, u=
nsigned long end_pfn,
 		skip_isolation =3D true;
=20
 	/* isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock */
-	ret =3D isolate_single_pageblock(isolate_end, flags, gfp_flags, true, ski=
p_isolation);
+	ret =3D isolate_single_pageblock(isolate_end, flags, gfp_flags, true,
+			skip_isolation, migratetype);
 	if (ret) {
 		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
 		return ret;
--=20
2.35.1

