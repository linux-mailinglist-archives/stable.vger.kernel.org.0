Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C81501E55
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347047AbiDNWcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347051AbiDNWcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1843CFCF;
        Thu, 14 Apr 2022 15:29:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJKxnN032238;
        Thu, 14 Apr 2022 22:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Kt0CnLsZZY0ne5qnhahnih47bah4v2LKeMfkhFr3RkI=;
 b=FPr/O3ocXqftz4PX8OmDBE3ZzWm6BoYQ2PJ5wBf1WehC90k0gOSPQoldaknNssGJMXwc
 sQB4rAaqN1sYQqVcX4mCRFFhlyIY07JBgFoP+pRTITyAyN+bIuYlumtkuWhZ1AYUmFu8
 Jn8c8ZnrES+tRoD3vTT61pIc+rX7ZmFvH6Tklytvehr0uK0J+kRp0ASKAxw1mD+eKKpz
 InnzwJaf+WCYS5QLd5eEPyCbJzGiAGfAVLeI/KFkEN3P86q6fLAFi64xpH2dbw8S7p3b
 QArQg/5imxbGlTc5TIybI/HNrI2/t4fq/d/mBM9p5KQuxFVHFAGmg/xtThx+PrbVz022 rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jddp22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMFolS007650;
        Thu, 14 Apr 2022 22:29:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k5erts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4jGGtUgEvG2HkihiCp+f0rjrzU+kQ3F8MELClZiTTEkQLnikp0URjv2votQGvGXJ0PBMQUqkkJq+WBpeS9CP7C2EdcQ6oGqPkA1Nhjh/2DdHKZuR4a2Gult++4wvNASPWpSBqhEGlm2BdwW0evghvAnU06PnmDL6JTDBHznLyTQVDimy1ogL20KvqvuX+bQlTy5j2gzfYMrt4iirpq/XeXpJkgn5rjNy6fa7yaz3pBeXSKQrAPXTNz79jh7lm+riPX+ihNsweYRccm5WOg4SLEI8Vp2AXaQuCMDc0tsRD1bfkwDXyVcVIU9rJ2q5JISluHhPB/SDtxE0wIJ+2VhCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kt0CnLsZZY0ne5qnhahnih47bah4v2LKeMfkhFr3RkI=;
 b=VVUuUbHBbCTzlYJKbpQ5v4U55g9SCpcDm8H8lqynJFJZDKqGdWevnljlH6HEl3DlXFygJ3Y8npxkpOWbM9tpjUSbPfVpUmKee4L8Myo/cicjJoUbkVITBYQ17YfyKVuLL580TD+NvvoON71l0LYjtoKyxqPcd0wb1n9ILICpiwvVELNMUAS3FqjPSbrosIkQLr2K9ID2rV86W0m5qm+tJh3rbBOoi0AsB/jOEQs9skjDJkX4MZFxn/Rd4slpNaYFbkp9mIcizhx0zvK36vNmdZ8veMe58lp7UmERTd4Oa5cfAP6TuELhCAaHfTPort5pcsybUKXH/gtUAo8Maqmd9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kt0CnLsZZY0ne5qnhahnih47bah4v2LKeMfkhFr3RkI=;
 b=PW+F9dXOIgR2VketykJotaIlyAopTkR1fHEsMxFxOBCqraPUtP3ZKSw0Lu4n9VyC31FYp8hWkee+7A6uzJ03OXZFedokUsIPm3aNrZexORfOJVkOlLE32DYH2YE50enpIl1eFsthoqcUdgOfzZFinUVP/kt8ow8vDRtLeKIx2bY=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:42 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:42 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 06/18 stable-5.15.y] gfs2: Introduce flag for glock holder auto-demotion
Date:   Fri, 15 Apr 2022 06:28:44 +0800
Message-Id: <51a4309baa83be7f31064db7fad3b9d3649d239d.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::7) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23a7d680-4b23-4f51-5bd7-08da1e664507
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094E89C91D739DEFCCBA8BEE5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBjSZ9QnGWXmAz/IyZwC0ELmchU8Ag9f006ND87JLf8ecsLqWlA0JsUMd2yP6naLGYmlwjQlo844d//1EcJ6Xh5AAf2Ze/igg1iaFUiVEmVTsVXHf13pR4f9GUzvykzrbjNva5+L6fPhnIrf6tv8G0fHFtiy0IyQqI10qbuWSMb3BRseFMGtViEKaMDwwuSTug+luveHXYumpt6rLfCbttG61PzYXUf8Lwr29yVJEUegWdmy26mlTkKeMv/v6w6q0mwa7l1lMdHimuKyj9qlgi1GlUL/SnshEQPXO8W40HO5w0ypRpqa7I68F4hFFGilpvfaeHUJQcE8nObLmFWe+gEJ8z3UYeVAKmMp2rIXO1VRA22e/00pnh5KJmcYJUeLc8+uy7IzJHk0G7ZFaV3SmGZx5FaMnbCbnZ8AE+/Rk0H8SuYXinx2+mbkiQ0WHpRW/PIsDRXqOAyyMMRUdcXl5ZasS3O8yJBAGRK/JeikBrY+Vzm7c+C/UkG+ZoReWs/eL/Ytr1G9+NOm8FBWa3C8Lea+aClbUfwY/hV6nOPSRnVBfVc+CMmwH0F6P6jrSO0kqHHMGd9glO4TMWINk2SuxacAx/xXiDVOoFb4rrD9sSYHdPOq9ViNT9wIATgt9N9L4BZoOKV/FzzuJAs1F394vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(30864003)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IyzL7ayczvcQBehPXH7iBlhDTOHYJN4OpaRXy30ceyyntX2eo7b6uNTZYP3v?=
 =?us-ascii?Q?xbX1HPhp2XPVSUDX5dJUjp1DrO19ubi1kgW8Nm1v4JrKUCOM6iOA00feH3Uv?=
 =?us-ascii?Q?uQ2W8Qzs7O5jYeDHJHX5b5kmMyYI+hyVkQ5VbA1OSYYBzaU+QWnvDMiSN1tZ?=
 =?us-ascii?Q?bEihif8wEyZzgxpa6NmAExzzflyeR5JBKbP8HK8ZwnNEx5h6aovzFinKReOy?=
 =?us-ascii?Q?lCYi01gMHe3uI0KUtOWAUOUIJY6DAMYMYzYtV0JojhtOny1+Htxlye8Pqc6q?=
 =?us-ascii?Q?GNruMdKrd4aZ1xWTP2GzU8/q1r5XVz7QTwKxTHGz+cQcMPQ+GB5LMptCLC48?=
 =?us-ascii?Q?xKgqU7MhRe3NryF3ItxrEQ4TO0lvMHQ8AhK7gpm2KZMQ6DC/7g35ftOIDI0H?=
 =?us-ascii?Q?2rGrKSpDlGEbTVeoEaulqSLhpR5GZrmXwzx3Bhjm5wrX5KFMwIGuAsdR6w8B?=
 =?us-ascii?Q?6d2KW+CBVOTK5chKFEcCJG+uIA9zeEqN2c5exkCX9jCSdgbzC6mIAWyyx1ts?=
 =?us-ascii?Q?a11K48JEzmu8wLr9i4HG3ZO7qcMEoogcUUogcqgFWmsu6tWonk1OCA2eNZbv?=
 =?us-ascii?Q?BzsWy9i/hFnZDyxJcAhgxPxusri9y8bYFQRiWQWezWo3ORdc5E7TSp2fhHe8?=
 =?us-ascii?Q?LJaUm9oVDJRYPbswpzgWJ4LbRU6B8WKnBKPE4QdSpwbh4PbJPER0m8/R7VgY?=
 =?us-ascii?Q?RvV4LSbFD+H+NaBLM9bkW4VtaNjLktjBgDD8NoFkVgzRIKNFDkJ7drMcqkil?=
 =?us-ascii?Q?7FZR8fBNjPzUTqpCNvNEZ00KG2y3Hgca1kDaV7fyTG8LRD0vD3KSZRyo2hqz?=
 =?us-ascii?Q?n7fFkIrvX2LDTBu99StwAOItUEe8tznvYX5zAWrJdTi2RrMHId0DWqNUqB6s?=
 =?us-ascii?Q?cT2rLzIHgR+KcHzWqOSWCGqQRsjcqW3pTPD11/i7pXXJZTXdPqVUA1kgBMQX?=
 =?us-ascii?Q?2kRMcitDxxlV9JKR6JKRrP53VkrB/6QYUwt/OltlptMruuU1iyxw9ipXe1v1?=
 =?us-ascii?Q?NDlN7TsZryf1ULMLz5kkmb/m26eDtqtfd03vvZP0RNvTodQEmpkNq1kqX1uy?=
 =?us-ascii?Q?FEkPn7fukxkcRSp9DobqLYkxC/018Qn9yU0CtkZHduq+lTLSp8LKNgJj6BQm?=
 =?us-ascii?Q?d5VTjXK8ElCGWdqMCqNjwcbetjaVocnp2qpJ20ZURZgjewMMpnO4hlp1XdHM?=
 =?us-ascii?Q?wxiSP41UmuCWBjpaxGxW268fDlcfP72B64T8683F1ZapGS0bcsB9U4ssacPE?=
 =?us-ascii?Q?8fmscyBfz+oR5poJxERxeEksIWgCfN8HobgmB9IOb8sObC7pXZvRvstFHAds?=
 =?us-ascii?Q?1Nzg6Wb/l6s3Jbh1JLObR94RIQ4RT9OZFVcQ8E2KrOG+9cN4EhGwyw5wJR73?=
 =?us-ascii?Q?YhkDHg/+CZfjPaVpWv8SFNVbxD76WmVvhdbubX28zSutMzu5qibcdheX6uZd?=
 =?us-ascii?Q?nplGN2Yh4qtIUgOATR4qzRAVxuGl3kvU9RNYmnBPOtRaWenm0d3XPAaPStTU?=
 =?us-ascii?Q?yzNiT+Dd5IszNwEMe3wzRWneAQw1Y3lqDbWHGlC6Z8zoEPqDGD/l3nfY/Icw?=
 =?us-ascii?Q?qEiPViJmgBAYyXPrI6FP5UiO2OkZzD6RQHmdU13i30GwZjMYQIn27hqBhi1u?=
 =?us-ascii?Q?mtBZv0lbAIQvEh5gLI0TLgSVFMizSE9hBfP56+4Wzi6LGqcpI2DQJcARvGYJ?=
 =?us-ascii?Q?sEtE3w4HvH0jRW6hq0652qfo7ewM27LvZC3K9xI/4mMuq6vgZw60M94vDrM3?=
 =?us-ascii?Q?MyPCRKtqLZpMjJ8BiHR4TN0g8OIKBJ4hFn5mfNXGYRSt827z05Ph?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a7d680-4b23-4f51-5bd7-08da1e664507
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:42.1360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TGxSbrg8fD1OZu7UR7X+zsxaxxgRjuXkHTnU1I/sVLm2yJ5ZSsyTjOIifbCb2Br8DOd5gKenYaRz5EmNmUX1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: 904HYRj0v6FKP4etJwtA2xFXHk_DHJh_
X-Proofpoint-GUID: 904HYRj0v6FKP4etJwtA2xFXHk_DHJh_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit dc732906c2450939c319fec6e258aa89ecb5a632 upstream

This patch introduces a new HIF_MAY_DEMOTE flag and infrastructure that
will allow glocks to be demoted automatically on locking conflicts.
When a locking request comes in that isn't compatible with the locking
state of an active holder and that holder has the HIF_MAY_DEMOTE flag
set, the holder will be demoted before the incoming locking request is
granted.

Note that this mechanism demotes active holders (with the HIF_HOLDER
flag set), while before we were only demoting glocks without any active
holders.  This allows processes to keep hold of locks that may form a
cyclic locking dependency; the core glock logic will then break those
dependencies in case a conflicting locking request occurs.  We'll use
this to avoid giving up the inode glock proactively before faulting in
pages.

Processes that allow a glock holder to be taken away indicate this by
calling gfs2_holder_allow_demote(), which sets the HIF_MAY_DEMOTE flag.
Later, they call gfs2_holder_disallow_demote() to clear the flag again,
and then they check if their holder is still queued: if it is, they are
still holding the glock; if it isn't, they can re-acquire the glock (or
abort).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/glock.c  | 215 +++++++++++++++++++++++++++++++++++++++--------
 fs/gfs2/glock.h  |  20 +++++
 fs/gfs2/incore.h |   1 +
 3 files changed, 200 insertions(+), 36 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8f30ad956270..e85ef6b14777 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -58,6 +58,7 @@ struct gfs2_glock_iter {
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
+static void __gfs2_glock_dq(struct gfs2_holder *gh);
 
 static struct dentry *gfs2_root;
 static struct workqueue_struct *glock_workqueue;
@@ -197,6 +198,12 @@ static int demote_ok(const struct gfs2_glock *gl)
 
 	if (gl->gl_state == LM_ST_UNLOCKED)
 		return 0;
+	/*
+	 * Note that demote_ok is used for the lru process of disposing of
+	 * glocks. For this purpose, we don't care if the glock's holders
+	 * have the HIF_MAY_DEMOTE flag set or not. If someone is using
+	 * them, don't demote.
+	 */
 	if (!list_empty(&gl->gl_holders))
 		return 0;
 	if (glops->go_demote_ok)
@@ -379,7 +386,7 @@ static void do_error(struct gfs2_glock *gl, const int ret)
 	struct gfs2_holder *gh, *tmp;
 
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
 			continue;
 		if (ret & LM_OUT_ERROR)
 			gh->gh_error = -EIO;
@@ -393,6 +400,40 @@ static void do_error(struct gfs2_glock *gl, const int ret)
 	}
 }
 
+/**
+ * demote_incompat_holders - demote incompatible demoteable holders
+ * @gl: the glock we want to promote
+ * @new_gh: the new holder to be promoted
+ */
+static void demote_incompat_holders(struct gfs2_glock *gl,
+				    struct gfs2_holder *new_gh)
+{
+	struct gfs2_holder *gh;
+
+	/*
+	 * Demote incompatible holders before we make ourselves eligible.
+	 * (This holder may or may not allow auto-demoting, but we don't want
+	 * to demote the new holder before it's even granted.)
+	 */
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		/*
+		 * Since holders are at the front of the list, we stop when we
+		 * find the first non-holder.
+		 */
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return;
+		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags) &&
+		    !may_grant(gl, new_gh, gh)) {
+			/*
+			 * We should not recurse into do_promote because
+			 * __gfs2_glock_dq only calls handle_callback,
+			 * gfs2_glock_add_to_lru and __gfs2_glock_queue_work.
+			 */
+			__gfs2_glock_dq(gh);
+		}
+	}
+}
+
 /**
  * find_first_holder - find the first "holder" gh
  * @gl: the glock
@@ -411,6 +452,26 @@ static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
 	return NULL;
 }
 
+/**
+ * find_first_strong_holder - find the first non-demoteable holder
+ * @gl: the glock
+ *
+ * Find the first holder that doesn't have the HIF_MAY_DEMOTE flag set.
+ */
+static inline struct gfs2_holder *
+find_first_strong_holder(struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return NULL;
+		if (!test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
 /**
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
@@ -425,14 +486,20 @@ __acquires(&gl->gl_lockref.lock)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh, *tmp, *first_gh;
+	bool incompat_holders_demoted = false;
 	int ret;
 
 restart:
-	first_gh = find_first_holder(gl);
+	first_gh = find_first_strong_holder(gl);
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
 			continue;
 		if (may_grant(gl, first_gh, gh)) {
+			if (!incompat_holders_demoted) {
+				demote_incompat_holders(gl, first_gh);
+				incompat_holders_demoted = true;
+				first_gh = gh;
+			}
 			if (gh->gh_list.prev == &gl->gl_holders &&
 			    glops->go_lock) {
 				spin_unlock(&gl->gl_lockref.lock);
@@ -458,6 +525,11 @@ __acquires(&gl->gl_lockref.lock)
 			gfs2_holder_wake(gh);
 			continue;
 		}
+		/*
+		 * If we get here, it means we may not grant this holder for
+		 * some reason. If this holder is the head of the list, it
+		 * means we have a blocked holder at the head, so return 1.
+		 */
 		if (gh->gh_list.prev == &gl->gl_holders)
 			return 1;
 		do_error(gl, 0);
@@ -1372,7 +1444,7 @@ __acquires(&gl->gl_lockref.lock)
 		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
 			struct gfs2_holder *first_gh;
 
-			first_gh = find_first_holder(gl);
+			first_gh = find_first_strong_holder(gl);
 			try_futile = !may_grant(gl, first_gh, gh);
 		}
 		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
@@ -1381,7 +1453,8 @@ __acquires(&gl->gl_lockref.lock)
 
 	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
 		if (unlikely(gh2->gh_owner_pid == gh->gh_owner_pid &&
-		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK)))
+		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK) &&
+		    !test_bit(HIF_MAY_DEMOTE, &gh2->gh_iflags)))
 			goto trap_recursive;
 		if (try_futile &&
 		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
@@ -1477,51 +1550,83 @@ int gfs2_glock_poll(struct gfs2_holder *gh)
 	return test_bit(HIF_WAIT, &gh->gh_iflags) ? 0 : 1;
 }
 
-/**
- * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock (release a glock)
- * @gh: the glock holder
- *
- */
+static inline bool needs_demote(struct gfs2_glock *gl)
+{
+	return (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
+		test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags));
+}
 
-void gfs2_glock_dq(struct gfs2_holder *gh)
+static void __gfs2_glock_dq(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	unsigned delay = 0;
 	int fast_path = 0;
 
-	spin_lock(&gl->gl_lockref.lock);
 	/*
-	 * If we're in the process of file system withdraw, we cannot just
-	 * dequeue any glocks until our journal is recovered, lest we
-	 * introduce file system corruption. We need two exceptions to this
-	 * rule: We need to allow unlocking of nondisk glocks and the glock
-	 * for our own journal that needs recovery.
+	 * This while loop is similar to function demote_incompat_holders:
+	 * If the glock is due to be demoted (which may be from another node
+	 * or even if this holder is GL_NOCACHE), the weak holders are
+	 * demoted as well, allowing the glock to be demoted.
 	 */
-	if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
-	    glock_blocked_by_withdraw(gl) &&
-	    gh->gh_gl != sdp->sd_jinode_gl) {
-		sdp->sd_glock_dqs_held++;
-		spin_unlock(&gl->gl_lockref.lock);
-		might_sleep();
-		wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
-			    TASK_UNINTERRUPTIBLE);
-		spin_lock(&gl->gl_lockref.lock);
-	}
-	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+	while (gh) {
+		/*
+		 * If we're in the process of file system withdraw, we cannot
+		 * just dequeue any glocks until our journal is recovered, lest
+		 * we introduce file system corruption. We need two exceptions
+		 * to this rule: We need to allow unlocking of nondisk glocks
+		 * and the glock for our own journal that needs recovery.
+		 */
+		if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
+		    glock_blocked_by_withdraw(gl) &&
+		    gh->gh_gl != sdp->sd_jinode_gl) {
+			sdp->sd_glock_dqs_held++;
+			spin_unlock(&gl->gl_lockref.lock);
+			might_sleep();
+			wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
+				    TASK_UNINTERRUPTIBLE);
+			spin_lock(&gl->gl_lockref.lock);
+		}
+
+		/*
+		 * This holder should not be cached, so mark it for demote.
+		 * Note: this should be done before the check for needs_demote
+		 * below.
+		 */
+		if (gh->gh_flags & GL_NOCACHE)
+			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+
+		list_del_init(&gh->gh_list);
+		clear_bit(HIF_HOLDER, &gh->gh_iflags);
+		trace_gfs2_glock_queue(gh, 0);
+
+		/*
+		 * If there hasn't been a demote request we are done.
+		 * (Let the remaining holders, if any, keep holding it.)
+		 */
+		if (!needs_demote(gl)) {
+			if (list_empty(&gl->gl_holders))
+				fast_path = 1;
+			break;
+		}
+		/*
+		 * If we have another strong holder (we cannot auto-demote)
+		 * we are done. It keeps holding it until it is done.
+		 */
+		if (find_first_strong_holder(gl))
+			break;
 
-	list_del_init(&gh->gh_list);
-	clear_bit(HIF_HOLDER, &gh->gh_iflags);
-	if (list_empty(&gl->gl_holders) &&
-	    !test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
-	    !test_bit(GLF_DEMOTE, &gl->gl_flags))
-		fast_path = 1;
+		/*
+		 * If we have a weak holder at the head of the list, it
+		 * (and all others like it) must be auto-demoted. If there
+		 * are no more weak holders, we exit the while loop.
+		 */
+		gh = find_first_holder(gl);
+	}
 
 	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl))
 		gfs2_glock_add_to_lru(gl);
 
-	trace_gfs2_glock_queue(gh, 0);
 	if (unlikely(!fast_path)) {
 		gl->gl_lockref.count++;
 		if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
@@ -1530,6 +1635,19 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 			delay = gl->gl_hold_time;
 		__gfs2_glock_queue_work(gl, delay);
 	}
+}
+
+/**
+ * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock (release a glock)
+ * @gh: the glock holder
+ *
+ */
+void gfs2_glock_dq(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	__gfs2_glock_dq(gh);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -1692,6 +1810,7 @@ void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 {
+	struct gfs2_holder mock_gh = { .gh_gl = gl, .gh_state = state, };
 	unsigned long delay = 0;
 	unsigned long holdtime;
 	unsigned long now = jiffies;
@@ -1706,6 +1825,28 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 		if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
 			delay = gl->gl_hold_time;
 	}
+	/*
+	 * Note 1: We cannot call demote_incompat_holders from handle_callback
+	 * or gfs2_set_demote due to recursion problems like: gfs2_glock_dq ->
+	 * handle_callback -> demote_incompat_holders -> gfs2_glock_dq
+	 * Plus, we only want to demote the holders if the request comes from
+	 * a remote cluster node because local holder conflicts are resolved
+	 * elsewhere.
+	 *
+	 * Note 2: if a remote node wants this glock in EX mode, lock_dlm will
+	 * request that we set our state to UNLOCKED. Here we mock up a holder
+	 * to make it look like someone wants the lock EX locally. Any SH
+	 * and DF requests should be able to share the lock without demoting.
+	 *
+	 * Note 3: We only want to demote the demoteable holders when there
+	 * are no more strong holders. The demoteable holders might as well
+	 * keep the glock until the last strong holder is done with it.
+	 */
+	if (!find_first_strong_holder(gl)) {
+		if (state == LM_ST_UNLOCKED)
+			mock_gh.gh_state = LM_ST_EXCLUSIVE;
+		demote_incompat_holders(gl, &mock_gh);
+	}
 	handle_callback(gl, state, delay, true);
 	__gfs2_glock_queue_work(gl, delay);
 	spin_unlock(&gl->gl_lockref.lock);
@@ -2097,6 +2238,8 @@ static const char *hflags2str(char *buf, u16 flags, unsigned long iflags)
 		*p++ = 'H';
 	if (test_bit(HIF_WAIT, &iflags))
 		*p++ = 'W';
+	if (test_bit(HIF_MAY_DEMOTE, &iflags))
+		*p++ = 'D';
 	*p = 0;
 	return buf;
 }
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 31a8f2f649b5..9012487da4c6 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -150,6 +150,8 @@ static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
 		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
 			break;
+		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
+			continue;
 		if (gh->gh_owner_pid == pid)
 			goto out;
 	}
@@ -325,6 +327,24 @@ static inline void glock_clear_object(struct gfs2_glock *gl, void *object)
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
+static inline void gfs2_holder_allow_demote(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	set_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
+static inline void gfs2_holder_disallow_demote(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	clear_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
 extern void gfs2_inode_remember_delete(struct gfs2_glock *gl, u64 generation);
 extern bool gfs2_inode_already_deleted(struct gfs2_glock *gl, u64 generation);
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0fe49770166e..58b7bac501e4 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -252,6 +252,7 @@ struct gfs2_lkstats {
 
 enum {
 	/* States */
+	HIF_MAY_DEMOTE		= 1,
 	HIF_HOLDER		= 6,  /* Set for gh that "holds" the glock */
 	HIF_WAIT		= 10,
 };
-- 
2.33.1

