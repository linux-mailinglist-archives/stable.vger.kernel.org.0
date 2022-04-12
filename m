Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8490F4FCEB8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiDLFS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiDLFS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10F1344D5;
        Mon, 11 Apr 2022 22:16:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BLtMIk029741;
        Tue, 12 Apr 2022 05:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=XShKdXazBzc8whg4ha4eM7lV02CWXU19Y963VZhMBg9KsjQh3WHGqOHZDdzQKUVvPjlc
 xGdgoW+leg7PEFkp6HRnbpqFvFZQpyfLGF6g91x7ysW1uDE6oSpInKsj07Dfmv3sica1
 sZOZ68U4MO0aUMXSyoh6r8ZkD6ez0Bde6Ojhv9z6p1dXvZHVV93rSXWyMKJROUf3Y/kL
 CVYuZeoLNPwencUlGIyVn8llSRsSYhpu1iki8+UIu7svlA5vWt7occXIMgig1wpf4V/L
 qwji18jpJnjyiuI4OriSWEtwh0WJce7xcWyGLMVtTZTSZ9BdIKWdFbEVr+1Mot5RZCwN qA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd5g2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BO6h006109;
        Tue, 12 Apr 2022 05:16:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2cks3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRHfxAF+tcWTGm6Y6J/gkNoq/BPVQZj8XKZazC2ywEcSrxnKeUZ1otIMwyeJEwoc30rGwXYhlA2ibo1SjXVqynDzhe4/RYiHklg4S/dnA9bAIrQNV5caplqkx9bqIP3ZrqfA6RZWKHEWUwCElbAbCWg2j6KmyLFoS95SfbnA5BrMPB5DZyx9CNfZsIgW/i9vFDAh4GNOg9auBL5LNBkFfc6fMawE8qw1n985TBwXiZ1BNw2C3/aNlRYt1XErqDBEJ49nOPa8I/v9Kl8m9eMkA2Xi3Xpre0PrBViplNL0Bgeme7UKRCMFYFtkyRnRZkYhC/ksoIyY2VnOO+mteKk8pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=dxlIQmNzhmKDQZusaNFP7OihFI7VCUBZ5zuzXxANiFI8QRO0sXe3RC19y9slMKSHdWS0o0B89UlHxrzPLruAKFJ4WvZ6Y5B0O6yn+XRd6uOH3Ozai6ZoGtLXSgPUKy8mHuKPSiJ1stluYd20qsnuczkgxyaiAFRpB/2HpBtAhbW0q8zS+Uu2/phSGlAMQM8mW5tJFXRSvLQmaX0IbKGB1vj/gwMnyGDDGIb+4IUVMj+I9osPOiC6qdXx5zv248VO2aRm0yTeSQzQzxuZfGYu1rKd4bOHKs+gF2I37VGGFBUiP2PvIlUWlBRP/B496p2JvbW5gBhCK87MEktM2ogykA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=esrrEdRWHqtISEb6/rFeTB6UPSN93ir7Q2ObLYFa/JH0DPKmPXC1LNoHgYo2kNCbWNZQgRkjzXtwg1tEfeCF7EFtv7D/J29hq8nGigicI8txm+E65Rqr97c/F27qZgpQ17ZaFb6+ns0yuVT7VCbvIclecevX5L4u7uTOATyXMrA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:06 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:06 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 05/18 stable-5.15.y] gfs2: Clean up function may_grant
Date:   Tue, 12 Apr 2022 13:15:02 +0800
Message-Id: <e797c2f5fe230f1ae5c732cddbe98f06531a3483.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecb785dd-e195-4358-501c-08da1c438bae
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329595D84E49EDB454B6733E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/yaZ6A3hz5wZUiepIpVjwuy+cSuh0w9s2fuT2JMiD6tqp30GoV2Y2wFGazv3lnn578Plfnn4rHigRd516PAKOa0AolBN3EroP2VlcVmVbZ5JeJzQArpKCbYcNtnLBVpIXr591X+kX45wyIOsAvZCBIh3lJr8zWoqGNMHTbasu/7aNscd++SZsGWKws9uoqMnsB3E/SkfYYep/iApK090NG2RhmcR1gwMzV4QjVeWnXXB7595GsREXKg/kM6dCQ8jJz7Nvqx/XyI6cuXH47CUSmd65rBxRxalMR07Vl84mWVsiSvPnGKx5oSGrAMiT5jw+7FaBgotUKDJXW47Bx/0dSAvsaQWpGc9Q2IGX84BgipkTKAtw3yGoEN1SNw2bPB+Ry05T8VoPHbyTFuyC3KssunJt6fQUI0lDlkTnjS+hi0Ylkek3t3kj572uBp1Gm365nsaB4AtrotjaLgCLmQsrQ0cwATg0upG0F44INaWQPZpR0IHtdT/glCXpHVTQRQOeqI/xKlgAFeFbAlZmEiMrcPkX+urtBHRQTDcQYZPXOvfeaLPAb0xXO1l1Tn3GvpeQMZuD9P84pvCbjOZTFLiS0rXLRQjDbcCTAycv3h4/kA4QyoThy7vq0hTLLlxd5fXnfKcyctcucxZy+Chm0LOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lxAk5Pb5JElDTRF2uFBPDqjx3I+SJI7tUz4TzqBWqN/pQhJTb2afrIQZB+e9?=
 =?us-ascii?Q?Dr2tGuKPQgO5uL2XGMM3Qn/WqMR5z+Iye2Oh18LxpRNVw3Q4VBZp5D4rlKP/?=
 =?us-ascii?Q?1RMOdLZM/Zbv5Oq6TjRuu8EXffgvsC5YxIzYyLeVvoc7BxrPg/KCTIW5CSFq?=
 =?us-ascii?Q?JD6Lq8+qJGYULqkMDFDGwZFyNail/lOefd0lHlDh67uKGlpAyhozU86MO7se?=
 =?us-ascii?Q?V9NteCCn3L6Cb700d0zpPXhqsNE7cSrjc4/1Ra0QolIbK9tUal03cBNfNwR3?=
 =?us-ascii?Q?feVjO4MdSagObOqUou+ZxSe4fNd00L4mXPgbYW5F/va2iKFgGpuK6nilt95e?=
 =?us-ascii?Q?1o8lckHCPMLf4zL4VMA8zHxIuQ1w0ZOsiW/CMoDz2p/0kCTCLpO4svfk77IY?=
 =?us-ascii?Q?WWi4PEQkT00T86BWH149V3phB4fh/jS4Bryiubles7YhflBgdF1TH9NHxrdO?=
 =?us-ascii?Q?pAVP/+RPT+MQTaPkhF9ZHdMAsiS7aJj/wAfNPcsd++De1bd69sE+85o/Rq+1?=
 =?us-ascii?Q?qxTDFmJS6iyb8GzH3nt0MRvt8yJfc/oatqQ/Zaj7Qn4//kyLmOug2ndeU6/y?=
 =?us-ascii?Q?gl+5KhnylcI0cLFCvhC31EiNh++k3JL+fFpHivHzmDWXVv/oDF6rZneJbJfC?=
 =?us-ascii?Q?DugeoxW77A7Bcxlh3OHkQ6GrmH+h5NGSbBf+3ba0NBRoSRuJWJJ33o0Td5p6?=
 =?us-ascii?Q?3Ntj0tfSWxXFJSJlKOkKmBOBk6DjgD1cKNLBQqn/hvvGHuvzQBoYkMEKbTgT?=
 =?us-ascii?Q?xhM6Ifk0Ae16nSDhZQYCtNVIvSvw7cRpybhA2mw5PcCksTQNfuRhHeOuACN4?=
 =?us-ascii?Q?/YDWL0I1iBLIDq7SdVjjhwehR60LqyYLrMG/dI6MlxlIgczuA0MHvfAl1WuP?=
 =?us-ascii?Q?bv4K/BSzZeAvOcgJnI7GdokXr7f9tZ7LTOWTLcvaeLHHS+n7OsdOTVvqskXK?=
 =?us-ascii?Q?Xe+fi0ci08g011l01wXHai0O3+dH0In7koKggtyOVwIGx2XBnFhwa6TMMrxz?=
 =?us-ascii?Q?HJEIjV2cAJUE97ZHX3EKmc2hlIATDh9biOGFHq2Tj5AXIKXWhJZWdW5BeL1O?=
 =?us-ascii?Q?YLi3Gtfn84EUYofSziwXYE4ZOTr4slwu5wwSKuhxSqvVopEyJTZa8MuAhYZ2?=
 =?us-ascii?Q?xHhb08qp5eLwSSPEDal9ZYvlJcccfxwD1hLA2h0aVVhM2IfBF7cVmFk82MuE?=
 =?us-ascii?Q?BZkZ+H3vCiPU8EUkjM1tE6G3+RPI/ZdKbXNeWyO3utC8VoHnzL185gdjDEPm?=
 =?us-ascii?Q?EKLfgyKbvaD0yKAsvrjql9p4kZ7wl4j0qR63zR6RecaDF8BgDrrslV3BTE62?=
 =?us-ascii?Q?3Obrw4GyyeZoktCOA6MeBFEx6vrPMJZZ+2GHKqjKSFFYFe+ZWfSaiKa/CBLE?=
 =?us-ascii?Q?Xcooep/4oZNsmE/lTw3RPw3mM2coL+YpU2pL34Yy18h9+WgijLHa8PV9moVA?=
 =?us-ascii?Q?zwVynPx4SmA+vvLxhVJHGSnwWHn8MHPia3wE5d8lKXtf1KFgSN0Py7J2YmeC?=
 =?us-ascii?Q?Cf/mPe5ADaoWb5t7RlwDIMkitgo864Dsn0mpNf68uonsbGGhCTbSVnvrhxur?=
 =?us-ascii?Q?nhm2jcku3mhG9ofP4NjA1OLJPgESivBFNS2Pet0mA3m5p12ImuusqYLAOTqH?=
 =?us-ascii?Q?EKnBbVZ7TUKWV6rrQVxGGUKx+ot1GigCT52zE2Hk/cj80Bllq+YQhdqd0Tn3?=
 =?us-ascii?Q?6iaw5R9XDGU+YmM8ez3Luc0t/hNaTJX9RIIQpc35DPgBT5m3CToYf+If2VpD?=
 =?us-ascii?Q?PSMNgOT4TmiFzNkSGafXcvHSWIPE+ZlLf7w/nVhEiP3sxH2lgJCM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb785dd-e195-4358-501c-08da1c438bae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:06.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiRUd47xagjMKsAqsowiUXLG9iI4+JwM3RMnYNUfQZKO/Vmt9D2OEKaeMZXzCmnFLjuwFkH1dBkNN3IKKV6eJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: NtsUGfmi7VjbifBEkJMwUcgvMnjlb-cn
X-Proofpoint-GUID: NtsUGfmi7VjbifBEkJMwUcgvMnjlb-cn
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

