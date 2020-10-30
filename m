Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FCA2A0D97
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgJ3SiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:38:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51587 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726095AbgJ3SiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:38:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B31405C00E1;
        Fri, 30 Oct 2020 14:38:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 30 Oct 2020 14:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=from
        :to:cc:subject:date:message-id:in-reply-to:references:reply-to
        :mime-version:content-type:content-transfer-encoding; s=fm1; bh=
        a+yV5AyyQgbkAmuRGp5Grqx+CnaA6i6TKDg6E8EnuoM=; b=LZ8Y0MDCS5wAAvDj
        W/mWis1W9G0odlltD0S7OECXly0rCRiPR2ZI+MD6MeOesOj6WMVirhEtxtLoKG7B
        35sg9HQqvuMx5q2p4I9xPJ6+RWvjFH2jKh6lRiahr4y95PomUVM+UCzYg3Ny2X4c
        CAiqo50PgA3qcilBOhAoUENaF5gsGKS75BorMXKIvhWSyBskX5dTXVvTGduN4zLC
        rNl1Oaen6GF+krJP2i1QgxbaKfSvN6REn+JQGaEzWaOSuVCKcf9fCSyzLpJdrRT7
        ZANs6TEt7AQJkAAtJG0y5YJJ7Myu3+cLnkmKubRqC0PFyaS1i/NaVlZjdj/RVggm
        G36XXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=a+yV5AyyQgbkAmuRGp5Grqx+CnaA6
        i6TKDg6E8EnuoM=; b=pYIwQCSkN57JUFmVQ6O4s2dY2Sbxx4fBl/G65OYCu4zcO
        AOxDrwgu93EurxOU0Y0/FJ89QrPOjz9W8Qdommd6a6HVgdNIefIRhVCW701PEhA7
        g0EMCbjRMV3i3NbjN732xkb3m0kxIx3vsvo0JVwMQEmvovlvAlh9+GOemaEnBxeu
        fLl9pgm94LnBG4/gHWYJyUuI7oQPjo0j4wrzvzvNOSF856ZWjAWMcQtxKAbeDIUC
        pxMZhZ/Kh/rKSAnOqvYUSTXaEDKh71gA2q1j4C8sr8XLdSu9hY7JcBlEj578oT4W
        y6zzpcY5B3ZUNcX/IoUlmh5SKN0r0jDVedSBUow+Q==
X-ME-Sender: <xms:lV2cX8nuwjHPc6UNsnJBjpAgOyxvDynY3h9obQhtWnZdVyffMbtWVQ>
    <xme:lV2cX71dygnfrn920Pp7EYoSRlUJ32yfGkrcLYtN2Y5cSyKz-kcDhFpsm1mS3A58F
    wPgo_7gbAJT2Ryw4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleehgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfrhggtgfgsehtqhertdertdejnecuhfhrohhmpegkihcu
    jggrnhcuoeiiihdrhigrnhesshgvnhhtrdgtohhmqeenucggtffrrghtthgvrhhnpeekgf
    fgleejfeegjedttefhhedvgfffvdeffeekjeetgffhtedvudffkeegleettdenucfkphep
    uddvrdegiedruddtiedrudeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpeiiihdrhigrnhesshgvnhhtrdgtohhm
X-ME-Proxy: <xmx:lV2cX6oP_kJuI5Mg9FYpUcf2mluu1QOWF1WqOzZle9XQ1YDQxEiiww>
    <xmx:lV2cX4nT2uklsxFOrO40-FeGCl11P4_IGWW72ecMxIpQWkgjmHDlOw>
    <xmx:lV2cX63ryDjw2DQubCm2W0weenyItKKQMZYDFZbPUDIHoR9sYNPhVw>
    <xmx:mF2cX0qY3WZp_gw7oCr7Hrfkbf7-EB2XLqJh-0Uc9wEV2KsynYJB_g>
Received: from nvrsysarch6.NVidia.COM (unknown [12.46.106.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3443E3280064;
        Fri, 30 Oct 2020 14:38:13 -0400 (EDT)
From:   Zi Yan <zi.yan@sent.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 2/2] mm/compaction: stop isolation if too many pages are isolated and we have pages to migrate.
Date:   Fri, 30 Oct 2020 14:38:09 -0400
Message-Id: <20201030183809.3616803-2-zi.yan@sent.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030183809.3616803-1-zi.yan@sent.com>
References: <20201030183809.3616803-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

In isolate_migratepages_block, if we have too many isolated pages and
nr_migratepages is not zero, we should try to migrate what we have
without wasting time on isolating.

Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migration fo=
r CMA allocations=E2=80=9D)
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---
 mm/compaction.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3e834ac402f1..4d237a7c3830 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -817,6 +817,10 @@ isolate_migratepages_block(struct compact_control *cc,=
 unsigned long low_pfn,
 	 * delay for some time until fewer pages are isolated
 	 */
 	while (unlikely(too_many_isolated(pgdat))) {
+		/* stop isolation if there are still pages not migrated */
+		if (cc->nr_migratepages)
+			return 0;
+
 		/* async migration should just abort */
 		if (cc->mode =3D=3D MIGRATE_ASYNC)
 			return 0;
--=20
2.28.0

