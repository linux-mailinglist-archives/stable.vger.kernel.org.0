Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6820296139
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504821AbgJVO5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 10:57:48 -0400
Received: from sonic305-20.consmr.mail.gq1.yahoo.com ([98.137.64.83]:44874
        "EHLO sonic305-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505519AbgJVO5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 10:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1603378667; bh=zwvCVywwXJPAfIYLckNHNuWz6WV1ugE9tkAOhdwuh+Q=; h=From:To:Cc:Subject:Date:References:From:Subject; b=KPVI26PfB2zvjqVtYl+hsGKEYFFkRf+eH1d/yODVyn2WtY5864tg5tv1jZs88BGYRRFUv7UMtJAgn9oOJrli2z4kxk9FW8U1aeu/v1GCbexQtmwqToI550kDqeW7FitdpHbM1Rnt5no6OMAEbfcbY1UD7bMLJmTdGdqodmxatzEE04UDvRcgG/dX+dvkrkjsuidb6MEexl+vfMxdnpKXOLtJ9kTuDTXMjMHU/ea1BxlF68bfJOwUZy80bn3cLBQTen7tnUPPgOayxndTMz4sb0D4qOZ2V8JoprotPMbtFJ4EKluDs5DGxB3J9rupGnRcrGmh5S81V/1qi5EeVVZn7Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603378667; bh=kTKfwPtRcMupfOfzpbJghKL1mSB1qE5MJA44VBqlRTg=; h=From:To:Subject:Date; b=Qs3JjbA4fFuSKhEPS5+H1EU0b9INW7Tw3MiIqGeFl19ZK3Y9uIpbe0ZzrAJZfatr8gzr8ZN0bRJM7j04UZWYmx1UT68EjKUm/94Ryy6J0cqhZdZhGlL3CA5OvYogktGb8C5cA41wYq5Jek9YpDy/OosZACKydmfvpMIcLS8U2MqnhX6x0K68Y99gOHs1z4hWZT4S0PJVPgIvh4macgO6CYJWhPr3yH6ju+xH8jXTGOucsQPaiAs1sxyvMURouCeYIy3gPoSXdPHldkUaaq2h1qLDGwDy3gWtlyZkwI7XrokMFGyWLfTbHOt6y2XQnlgPM5qDp8EuOl3SJ2/rln5LWQ==
X-YMail-OSG: fug733IVM1lyEPsuo0Pa6rWYM16GzXzkRydgiJ58pHeDptLq7cjSa5XN5GxaQZN
 ST1KP8o6.KOH.R9qw1EcLvgKxTrLzj.cIxclQPlhWVny2o7KBe1YQCNAgc6lLA6f5HAPwHhmKRw3
 h_1qdm3vk06pqWplzf4rOpOvJlVzV0H1ZpbuESBAZzSenXM76DxED87cKLdiYaoOImR.RxxgryxJ
 TjJPL6lWcs3lMCFe_pj._5x.x.PYa4hISlcykWAMgYMqx7_qqLM2G_9B2L0pSrBnfzuGdV9TEYv3
 jobnezwnb6ghBMwrm55OMxvsr6pZtYt.RE1rLHff5KftS.jsGnh_HCQmt4b7gyved5EDWE.56QQQ
 SN1Z2SCNwUaOQbIOrIqeXrZxoiwY1oaS6m4NBpYXkLw.zpwqt4rFOb7v9PBQk8.p7CB0zg2ifY2.
 NjSruitUMpXtWCRuBsse7W36A8WOu5gPACTyEmbx1B1o7HrY64rM3iz.3AmCPUdOcat9bQLmPFi8
 dkWw1B0_jXJaa8vluTSQ.427Q3vZZMH8ph2VyCktMXyDPbPl405WRnasR8u3WJ9lUVBSrO1UZKRP
 qOnSGU1GMui37SoIebcrLIfmgcd6b729N4SgFQXTfw6lZ7Jjw3G9xyOd54r3RVsCmamZu6F3plpU
 J2SN5ky8q1_6QGfFxuhZ_Tp.UQlAQHEGaO4uo0KRhVA8fjAvvd_P3MxEphhrNQcKMCaF_u.TIuOo
 PdRnA0CDcNMqdERrgTV4dQj1g51p2J7GFQYun4IYR_fo2TaQY.W9bK_4_9Pfwn1PUswk4eu0kmjx
 lt9F.44oxWdmID9gmx0P5gnCWJTuii6PaJxYmwehsJvgRc5q1TUxsI3pHE0xRaGbWcK2EdvrIItR
 NqGFX8bPgSts7IsgAZptSsP70G1YcSxYylypAXZXpqj0ppqxjc.sc69kG3shn5VuJHe9w8P1rtyH
 Lbs1yOPISBdoFmGFDByZ3_UR_0uST9IOxmGGP7qmOM6jOED1mjcPRbFSXXXEVJ4kSwzBP2UT6AQI
 efNbwr6Ss0ebq9c7PopvUYwGR0HKY__RJ5QGcuzZ1iPdxSKOMzS6O80fQCGLUCJSIaE5YrRCk9j7
 v4tRHFfRPkntp7kQGhJVJIiTVvZBh1n89y1yGlusLRq.NkxffBefsv7RIseCzrOwjtdYjPFAZjPG
 nDpNr2ySlDncrpQxU_1PXYUtUkA_SHfqxXBA9ySIlM8gw2lmriZzdwJrJ_VLdVqDhA5OOicw6aXf
 RIMCy4KtVj9vfUVUeaTr62OPro6PV9HrujpQoV23PxTMRvIrdwibOcwTbcC_1pCFJNHCASTO9QX9
 kTWSzRvACdGcYjQaL50c8Vx8f0DaAecPusGzMNSMbGFpmd7x6lyef7xY.OsGRoXdg.MWdlwS9Mac
 rXzTwCKJEbh6voo9NsL6fZZAWrcOiw01l2HQlKlnnk_BEMi_ZqHmjZQqOyEAccSm_cu2.6NDxlOn
 9yWAAfXq88vz7ePnu4293IsmTX7hbPX9QUajS
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Oct 2020 14:57:47 +0000
Received: by smtp401.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 354b2034a70b817070abfec37b60849b;
          Thu, 22 Oct 2020 14:57:44 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-erofs@lists.ozlabs.org
Cc:     Chao Yu <yuchao0@huawei.com>, Chao Yu <chao@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] erofs: fix setting up pcluster for temporary pages
Date:   Thu, 22 Oct 2020 22:57:21 +0800
Message-Id: <20201022145724.27284-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201022145724.27284-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

pcluster should be only set up for all managed pages instead of
temporary pages. Since it currently uses page->mapping to identify,
the impact is minor for now.

Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/zdata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 50912a5420b4..86fd3bf62af6 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1078,8 +1078,11 @@ static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,
 		cond_resched();
 		goto repeat;
 	}
-	set_page_private(page, (unsigned long)pcl);
-	SetPagePrivate(page);
+
+	if (tocache) {
+		set_page_private(page, (unsigned long)pcl);
+		SetPagePrivate(page);
+	}
 out:	/* the only exit (for tracing and debugging) */
 	return page;
 }
-- 
2.24.0

