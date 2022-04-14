Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89766501E4E
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiDNWcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347047AbiDNWcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305391EC6F;
        Thu, 14 Apr 2022 15:29:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJ07dl018439;
        Thu, 14 Apr 2022 22:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=nYGjQgaKEbVGI7PYBS0b8Si+Y6hA9wC7fIbt1C7iAWheUq08kNv/5fbyXf0vmxlCjvw5
 3lMNtwr73Xx8qfld8ZDvvE0D0LRQygimicgCSxjKRgW/r1n01n7I5Znet2ycOHad2sqd
 Fx19vTU6VN4u8yEJCsq18jfb0PfcJyMYSbDKv42jPnsR8bf3IsMFPcIryWblgxfPMiSW
 YC4PaiD9wjMh4VZqzfW81DpqIyImNN900/6fVxAITaUENKyNipiewvMxnpaLa5mFt65L
 8vkts1uAdXRrS7fxAfSrU5F2FkWoUgCQd0WqgqAWMnoXBimN0ObXaD4p5oZ9ZRcR4Q/+ EA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1p62f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMHhD1014987;
        Thu, 14 Apr 2022 22:29:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5uc7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNaZikEaXtz9t0L7MWwbWFth8ccFCGlLDMz7rwiiPCmuPrFrFsL5WxHWi/v7JCfc0t7WT6Nd6d/8BoNFvul2KvcxP+iSXm/5ln/Ol4AOKQN/TMu+r0Ts5UmHQJnx69Q8GljNSjUt9mtcfExpG3F16ormlNuXFPWpnhcswZRYeDVLQGMMJYUftc4nCYfYCBwqlg5GYaD/y0H0sB+bk7g6AMb/F+iF/0hBYUstSEBVcjv/L7ld4XLEuxgUkejzDaIkqWI1K9LQdNdBwhfUvVQJP6TxLyLnK5wRC+Aq98ueD2e81syD++JrzclHnMcDGAA8k3Vovwq0lJwZR1kxcEYuAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=BX7VFed/DqNn6sfyJb7kPYi+83GyNVaztvIsRVIHZHEfBxwPXY/UqigcR0+fEiZFecEcD73RHIKupvMmDjDSfs1vbfJv9rv583LNOhZlFlA7Yb42DZ4vE+onUJv9BlioL02G3swuCkAS+2NsLLTft7ccoldLV5H5tJI3TCdswAZd0Xr38Ept/zWprJL+BIBuO4KoNVN85nnfbEThH/r2PqseIoVyjvwa6npT74rA21IbeuM655M1jPlVm0ysqOIVxDbhghhJzcqghVORn1n6bp9hIyURHrKxxDym+mnbYXTpKzodYQCagLiyu8+zDALO1Npg2SA/96eJIYU25+YN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=MoihSEWJ2RBGJdzcBMOfYbluCMJAIeck0zs5H5TvlVnlk4e/qkjcBlplPqxwCC8SFSjdRHdJlhGCLByZpNGu62Qy+SI5n6xF10e+MCI8G0/y5Edm04iUj6vyy72F1dZk9Wve0gz9K1Cy4+vEvfnStdftKkmfCRuzFgqjijWXO7M=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:36 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:36 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 05/18 stable-5.15.y] gfs2: Clean up function may_grant
Date:   Fri, 15 Apr 2022 06:28:43 +0800
Message-Id: <16061e1d0b15ee024905913510b9569e0c5011b4.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0095.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::35) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68555fc4-40eb-45a7-8a7a-08da1e664199
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20948913724522BC5179441BE5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19PnDl7cKhOJ9HieWz2wCjVemewqfdB5cFEF6f84Zfzm8jYHYOAmUIi1nhjNFhX7cfh05kZWmlPc9i3TaDLUuCx2LyNF+uyPZCTVwtvLy6N+rxThaDbeX8yELnGGxUVH87+FAYpW+VcM3OlVERjGig1+FUaJMkirrhYRbUv5xYD+3w+kCP+M1V6kzyeWouqwRwCGwPJuzEG0xxmMlHCMpa9hcfn1ANA8F648bns1yF7ktxjcb4bEdmuRU1thx9cYFQlhOyqgSXMcKIWCUsLDzicovOVjAUkBBzGVS35+ivuzgJHyunnxWUtwbN1Z/IeimRDSw6rlhZaIZFzYUlDMDGv8TfYFudmdKBy4dZ4iO0+5VEg2CeOj0WcvqrXuspK81MZl6HVInz4zdjKicVZHQXSZb+VPBOh/UFL3ePsv5oXe7zCnmPC905k2HhwxiOMTtHYbrlvadbkRlyLsONCOm+KpkroORsNIxjKnS54N4jPJ62unErEbNlRdxXAbdu3vvCCh/gnxd2J2ykM/RFbo+ilRRgXVbiE/Klyte5ZfSHMp1c/gGkADYNp12YKP3gfm+danjgNWjmgbVmzw9QnSK0tBrirdNDLVmtCtb2oGZoVotUz4a3xvACdXvs2FppVradxmAqXAGZxocpZNFq8MBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TG83qMpooXyixME9o7dFQTMby5Bz8rPAX0Spwmo4uodFa2DkKV/1Y4KhZ5Kd?=
 =?us-ascii?Q?cBCPqwmOXTqbFSsTY8xFTsFbzLW4MhJsrPswSO4kJLy6orF55jFR/bhczZxJ?=
 =?us-ascii?Q?LPQDvRdgtObnkNEqM6TelWitmvdQ58sLt8lfbX9DHbzduAnGdJvShST7PRuE?=
 =?us-ascii?Q?7kJQTfLxnQ4duViYsBHAjIQVjjIX0GTQVxhKLC4qoKvfXPI4NL3qOFCa8cJY?=
 =?us-ascii?Q?hY9Q3TcatlAl9LEqhvHFf3mNsxwXZ0DGYBMeBXOBGeaAMS26r9NzNRpFvjHx?=
 =?us-ascii?Q?rtC/I9VfIRNUak9RTZa72NzMEk6OaBhc86tABVcmJy0rNMAuy1MNLVpBPqa4?=
 =?us-ascii?Q?QFdYPqdDpiW3GARz5yA8B0uDzI4/VWNdILVhTPdJidv8ce1BGy9bVGTnvYU/?=
 =?us-ascii?Q?US4rhMpLG8sMgHi9FVrmnSh2eWEeAL2PiH5Noo9B6wyAgu3DPlMljV8Jjnk/?=
 =?us-ascii?Q?16QvwWxq/himPBw2C3nO7Xr8ShBS0HUxhwdm2fbuADHXAhfA1eNoecLcYN6m?=
 =?us-ascii?Q?lz5V6DiWEceXRvm/656dQJ0q/QQZOuT8u+GksEo4+82Hj58INW/rjv1DeehZ?=
 =?us-ascii?Q?tkFUWc3Z14EBka4JhIvcJQ4houu/JvjBZUR1SA6t/XstDN1npbai5raLRKlq?=
 =?us-ascii?Q?d2/Is/peXMuNr0fxEgAQjQlk/9espvlW4JqgsOsXLuW1KrH2Gku5xljt0HvG?=
 =?us-ascii?Q?K+PlQfrraeOo8l6d87zrH52/1cg8pTEwEzT+qF+bJmyw0I20RGfhV4rgn9Ml?=
 =?us-ascii?Q?vJtaQ5+K8PTcomhNVXByij8usd0be5djd3DWW9v9sb7AbdGupEbxwJOVnFpe?=
 =?us-ascii?Q?/braB/e+bk6BJ93i6iA2FftzwCZevlLUuenTAnoQPHPSUW4V1uH8JhoiQdlf?=
 =?us-ascii?Q?Pg1lNsCCH3YcK+lyg8GaZc2xB/A1P/BAn9fYPNdOnxlwiL5NeP5rf94IXRcd?=
 =?us-ascii?Q?5O6GoIANHWICGMi+kNEcQolnUZ2ZnxQNK5IVkSsLgs4em96PZ607vd5DmJIk?=
 =?us-ascii?Q?RuGzo4ZN28INKz19+CMWO6FxPLAYx8cSnULpNYYhWuC3kpFKX+pfL1JKz4qz?=
 =?us-ascii?Q?evOWZFe196yKg3JzrzeAQdXAtWnp2N+/+kYwYxpIG1XtHU3OYRduHJFlheKP?=
 =?us-ascii?Q?4WYDrtqsTKGhO4o6ezqHRJM5q/vBMCG+s2jhpM0UowMlwrN8tfYFt0Xm+xuw?=
 =?us-ascii?Q?SC7dK3aaEXM7eNtMSNVwZMjLmDK6+z6oNSjxsaacEVINfNSYKdZH8kk1QZZF?=
 =?us-ascii?Q?YdQy+igl1WQCVgAhfaXW4knLQBLVv0e+3+AlFOAyYvPset4u+49bq3q8hCbt?=
 =?us-ascii?Q?WPEOk0Q9Q3PlsOjzQDxIwyTjdSLlCL2+f/vXu1SQRSvSPVuho6fbT3Bw76pC?=
 =?us-ascii?Q?wZ/9R3hU8OZiGhqcbCs5VDQGIAE+n7a1PvC1SywtTTNySwbCA4F3HajXfKw+?=
 =?us-ascii?Q?7XEl3NGjoJW/LJnzyzfuRcPGJeaP40Fdc6kfhZezBcbJGSD14cOmmMECiBFR?=
 =?us-ascii?Q?XkCn9b8eJ5+ry9A7DiJsOmn7nm52fCptidZ5cRmHcrGZYfIAaK+FyFjjCriI?=
 =?us-ascii?Q?g1tG239fAKSPmEzOcpOIDwCTiTtzQ0DwdugFSEUQqMOAroZHNP6ZmhfM9D8K?=
 =?us-ascii?Q?ZIFNtQV+quxTnYZyZua8T/d9+nrGVVLoNDEOKmknVK9n6gfTKLiN4WzPzzLT?=
 =?us-ascii?Q?zEVlET2b9T5YJQT/BzkM30NpXa79xiNT6p92gXVfmAZ5Zx4UyFvrDfZZbyuy?=
 =?us-ascii?Q?SNq+vFnzF66/aHbgFpNgAGoCfu62olWRChqTRisI6Ld/DeS2Qn1L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68555fc4-40eb-45a7-8a7a-08da1e664199
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:36.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nvW1PXqRBeF5lbxOLma+a0F8M3wOqJ6cveJltK9VxGVhOfFWQqH6TSokCEvrYpenHxLxejWGaY40OKo/J8D9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-GUID: kJIJatnOFWpiZiyPm2kIGt_XqVulqQQ4
X-Proofpoint-ORIG-GUID: kJIJatnOFWpiZiyPm2kIGt_XqVulqQQ4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 6144464937fe1e6135b13a30502a339d549bf093 upstream

Pass the first current glock holder into function may_grant and
deobfuscate the logic there.

While at it, switch from BUG_ON to GLOCK_BUG_ON in may_grant.  To make
that build cleanly, de-constify the may_grant arguments.

We're now using function find_first_holder in do_promote, so move the
function's definition above do_promote.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/glock.c | 119 ++++++++++++++++++++++++++++--------------------
 1 file changed, 69 insertions(+), 50 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 02cd0ae98208..8f30ad956270 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -301,46 +301,59 @@ void gfs2_glock_put(struct gfs2_glock *gl)
 }
 
 /**
- * may_grant - check if its ok to grant a new lock
+ * may_grant - check if it's ok to grant a new lock
  * @gl: The glock
+ * @current_gh: One of the current holders of @gl
  * @gh: The lock request which we wish to grant
  *
- * Returns: true if its ok to grant the lock
+ * With our current compatibility rules, if a glock has one or more active
+ * holders (HIF_HOLDER flag set), any of those holders can be passed in as
+ * @current_gh; they are all the same as far as compatibility with the new @gh
+ * goes.
+ *
+ * Returns true if it's ok to grant the lock.
  */
 
-static inline int may_grant(const struct gfs2_glock *gl, const struct gfs2_holder *gh)
-{
-	const struct gfs2_holder *gh_head = list_first_entry(&gl->gl_holders, const struct gfs2_holder, gh_list);
+static inline bool may_grant(struct gfs2_glock *gl,
+			     struct gfs2_holder *current_gh,
+			     struct gfs2_holder *gh)
+{
+	if (current_gh) {
+		GLOCK_BUG_ON(gl, !test_bit(HIF_HOLDER, &current_gh->gh_iflags));
+
+		switch(current_gh->gh_state) {
+		case LM_ST_EXCLUSIVE:
+			/*
+			 * Here we make a special exception to grant holders
+			 * who agree to share the EX lock with other holders
+			 * who also have the bit set. If the original holder
+			 * has the LM_FLAG_NODE_SCOPE bit set, we grant more
+			 * holders with the bit set.
+			 */
+			return gh->gh_state == LM_ST_EXCLUSIVE &&
+			       (current_gh->gh_flags & LM_FLAG_NODE_SCOPE) &&
+			       (gh->gh_flags & LM_FLAG_NODE_SCOPE);
 
-	if (gh != gh_head) {
-		/**
-		 * Here we make a special exception to grant holders who agree
-		 * to share the EX lock with other holders who also have the
-		 * bit set. If the original holder has the LM_FLAG_NODE_SCOPE bit
-		 * is set, we grant more holders with the bit set.
-		 */
-		if (gh_head->gh_state == LM_ST_EXCLUSIVE &&
-		    (gh_head->gh_flags & LM_FLAG_NODE_SCOPE) &&
-		    gh->gh_state == LM_ST_EXCLUSIVE &&
-		    (gh->gh_flags & LM_FLAG_NODE_SCOPE))
-			return 1;
-		if ((gh->gh_state == LM_ST_EXCLUSIVE ||
-		     gh_head->gh_state == LM_ST_EXCLUSIVE))
-			return 0;
+		case LM_ST_SHARED:
+		case LM_ST_DEFERRED:
+			return gh->gh_state == current_gh->gh_state;
+
+		default:
+			return false;
+		}
 	}
+
 	if (gl->gl_state == gh->gh_state)
-		return 1;
+		return true;
 	if (gh->gh_flags & GL_EXACT)
-		return 0;
+		return false;
 	if (gl->gl_state == LM_ST_EXCLUSIVE) {
-		if (gh->gh_state == LM_ST_SHARED && gh_head->gh_state == LM_ST_SHARED)
-			return 1;
-		if (gh->gh_state == LM_ST_DEFERRED && gh_head->gh_state == LM_ST_DEFERRED)
-			return 1;
+		return gh->gh_state == LM_ST_SHARED ||
+		       gh->gh_state == LM_ST_DEFERRED;
 	}
-	if (gl->gl_state != LM_ST_UNLOCKED && (gh->gh_flags & LM_FLAG_ANY))
-		return 1;
-	return 0;
+	if (gh->gh_flags & LM_FLAG_ANY)
+		return gl->gl_state != LM_ST_UNLOCKED;
+	return false;
 }
 
 static void gfs2_holder_wake(struct gfs2_holder *gh)
@@ -380,6 +393,24 @@ static void do_error(struct gfs2_glock *gl, const int ret)
 	}
 }
 
+/**
+ * find_first_holder - find the first "holder" gh
+ * @gl: the glock
+ */
+
+static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	if (!list_empty(&gl->gl_holders)) {
+		gh = list_first_entry(&gl->gl_holders, struct gfs2_holder,
+				      gh_list);
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
 /**
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
@@ -393,14 +424,15 @@ __releases(&gl->gl_lockref.lock)
 __acquires(&gl->gl_lockref.lock)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	struct gfs2_holder *gh, *tmp;
+	struct gfs2_holder *gh, *tmp, *first_gh;
 	int ret;
 
 restart:
+	first_gh = find_first_holder(gl);
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
 		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
 			continue;
-		if (may_grant(gl, gh)) {
+		if (may_grant(gl, first_gh, gh)) {
 			if (gh->gh_list.prev == &gl->gl_holders &&
 			    glops->go_lock) {
 				spin_unlock(&gl->gl_lockref.lock);
@@ -722,23 +754,6 @@ __acquires(&gl->gl_lockref.lock)
 	spin_lock(&gl->gl_lockref.lock);
 }
 
-/**
- * find_first_holder - find the first "holder" gh
- * @gl: the glock
- */
-
-static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
-{
-	struct gfs2_holder *gh;
-
-	if (!list_empty(&gl->gl_holders)) {
-		gh = list_first_entry(&gl->gl_holders, struct gfs2_holder, gh_list);
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
-			return gh;
-	}
-	return NULL;
-}
-
 /**
  * run_queue - do all outstanding tasks related to a glock
  * @gl: The glock in question
@@ -1354,8 +1369,12 @@ __acquires(&gl->gl_lockref.lock)
 		GLOCK_BUG_ON(gl, true);
 
 	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
-		if (test_bit(GLF_LOCK, &gl->gl_flags))
-			try_futile = !may_grant(gl, gh);
+		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
+			struct gfs2_holder *first_gh;
+
+			first_gh = find_first_holder(gl);
+			try_futile = !may_grant(gl, first_gh, gh);
+		}
 		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
 			goto fail;
 	}
-- 
2.33.1

