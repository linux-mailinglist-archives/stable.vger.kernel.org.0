Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB1D4F0082
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354299AbiDBK2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354294AbiDBK2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:28:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057831AA059;
        Sat,  2 Apr 2022 03:27:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2323C7Ip021137;
        Sat, 2 Apr 2022 10:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=ePyieswIzBizGucfNaUk3n7JpO1ypYL3VhjbyHdi50vIRHItHIURw5qDi8r6l8fNbN6A
 5v0hpN9Tm9QVpsbnnirKVs0Kp8nu+GX9YjgT3RB0MddbUkmuGg8weJ21g3Un7jsyWXiT
 PitOM8buAf7jdwuGNYyqfegKKOBnyBmEQsN9mm9XN21/Cc//dtYFP5F7YfLJE27Po4yp
 GpIwJPjXGn44ewacjnmxGWYRJnGKTzJNp7VueWczA99qxa5UyrO1b2hPWxxwa8FoJUrD
 fvjmTDHbt4tRVBtDw+xvqq5i/9RQVysvEjpTzqg+eITgnyp3yEkZoHWMd6IdooBUpX0j CA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9gbpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232ALZ31024447;
        Sat, 2 Apr 2022 10:26:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xcca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCvv1kXYnZ8LuIRxKz+cWLQ8Cj97Az+GA+wKYKFVgH8fIplH7LPkzxhQQxY5Yq0/vMB6yaQWOOwya8MmLyBtBKZIBLw+Z7DovqvVpwHNLUSlbe5gPrJkCmiMtV4GIPJotN+sgeWg5iXePsekglsbKQY/lYnhU+V1BFqSnZu/wW3/RSR82zLYP+jn6GrsjFc38Ado85IoEdsTA6A5OYUryN59h4n0gYluTRprqdWCkDtYIUzIEL3AroU5gJRIaOhZgOpyCQ12BtA608UVovC0TSiT7S4rgm0q7VdyT3tkteEfHUTwmWN8uaeaNzaC2fQDnEzaRaN3DC8fex+g4rRVEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=H1tbQI7jpORqsSxzyA4wKWVx4ud1zMQ9C+cQGt2th7ieXZmuuU6LA1bttQ7L2kG3xH870n/RdA72uv6bFy+NzkgEcuSg3gHZHyZ710Z0ij9rOEvTqPx/xL3zc84pcq9bEV7X2vUoq5ZVpRsKh/y793NI3gpRPIfwKHr5XgNQElgLt6ndRVboBo+CYmJlqP40ryQPXdXu3vaqVDl2ZBNXqZHGc56xMWyFPqlqT/ap6fSoVMid0SQkv5jOG3GldWqW6MYxqLFtufAP+6YGpjQAD2pgh01PVMZJYS4/8N9w84wXDFLbAKhYz9QvKnvtH0kbjkgbcyqBgZHMJNUXPoQMag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEndfXy9jiOzWuwTkMw4OXx/3CbSemHQeUkLPmGuOhc=;
 b=G8wz4L2e+82uJCTNP2LYzMp/oHWx86jL5MBJ2fblmydlsMPBvVJi94UaLFzER6HRZZs1i6o39ABBZT7NdxzmVLb3btDAsgOtPaDcm6BRlsXVlUxE2IW3humY/TI3jFTGjPLNgId3JIphgxVwrbDSU0Ra1edbsZBo+Uwbv2/+OMY=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:54 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:54 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 06/17 stable-5.15.y] gfs2: Clean up function may_grant
Date:   Sat,  2 Apr 2022 18:25:43 +0800
Message-Id: <024079277802b1a380f1f312ad635cf6484c1ae6.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0134.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::14) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd97c358-e7ac-45e9-f84d-08da14934ecf
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049830C12FFEA940740ED7BE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30FAgNmDWZx1w8TekOR0gqu0RmRBiYCNfPUZU8XUkIaOOEn1YoCPAk61CneGW5UnYWRfE52XZ75v08vT3UfQsvb2YnjK8TcYEk2XpcQDyeXDENrxhSwDlOgEns12yO0b+aPDIlvNO+DHr14K3OpaZNZvp6B6S1fCdKnrpL781EWbQFUFlqMUu17swj1SeKYeyHGk2mlh3I0aMdD8AcWE5C7LujId+1WQrLKX8o1fMxXyVHU/t8OxEyPDdNQYcbKb0x6IfnAc7TrNvbNtA09xXHGWCaZLVIEgeaixQDp73wuZMyEs9W9J2/a7FGKA44oxil5AJEE8o56LOs7w0TrYgRPddQ5O67IC3raVU+/iQ+PZPsxvTCDRkwSgBPfaK18bG+90/OnXbw3xI1xOZ195O0W21HG/Cc1sHDtwsfve6Fy6FozS26GboyI5fDksmvF4eI8YKJYJscKgaIA1W8fyGqdOC2r0dshSGOodgfsbbB/sBXORLhAk67XxBa6IhD/02iApUoyTcdYuUx1kZrRmS2kj/ICrrSbw/HEzT+24HOj7YkWitmr6qrhYDTiGIlE6Jfl2iUK4S8lYceoyEDfyupVgLneELutx1U0cdpkR4+jUD4guYec67gNEuw5B4CasUaipBJwooXtJDCjcD7bKaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0pPcIEsnh0KIpTwo4jAaccGLIR31dqHzFMJlXC1nLibus7K74hvGrM4g63Ur?=
 =?us-ascii?Q?VnpS9VlevS+s9HqffbmyXL5UaZq6UfYGTMawECSZZRoQ7MN77rwJ4d408OBG?=
 =?us-ascii?Q?HYxyanFRd7/q0xAJZ9PyCGqZzj8cAL5XHwRtbc0yGulZU/L7ujgqlnYEspNp?=
 =?us-ascii?Q?evC5jArz3TO4anDiINZ/CLseHmdCyuZrKfwLkUEJM/oFmd93f6rmualKojUT?=
 =?us-ascii?Q?SxuNY82FANUp5gG+vynOrFjey3i3r+Y7bi7E9oeah36w/gSOkGf1VE4qjU0X?=
 =?us-ascii?Q?2e2deOj5kHxVq/tP0cHmqrrOuPhyalD7KkXo/0EXa9a8E68RfzUyWvqO008T?=
 =?us-ascii?Q?+Zu+NWi22HGov5RShGelhp8fu87SkX7EqJ3GRmr5HOsqpefnFMgKBTm42iDI?=
 =?us-ascii?Q?Q2WLk8iS5ggEdDOJ6jqB12QNk9HwOCp1Nj57xinIWwYwAF1AaRQ5aM+p1I+0?=
 =?us-ascii?Q?bAYsFFO8GGN5c9DxWsylARQwOwIUkS59QTZ5qCQI188xV/eQ+1hVXCVgREdh?=
 =?us-ascii?Q?eXe1YKabd/hn4WKhdk8DM2aj2cS8V3KcDrymJVXOjxh88JEJAz3+KVcRtoBc?=
 =?us-ascii?Q?h3d2BXa4m80OT7e/lgaR56wlc7Hn8RORoDzP4ELuQtTqWtP8Ih8ll7WEMuqp?=
 =?us-ascii?Q?XzwAT+Pmxhwmn1ILGXSVcRSIn62ezPEE3qO8XaKMuywTeEa+xcyla1MEX6Ek?=
 =?us-ascii?Q?PrLmNkKq8+j7PyOkauLNmgcT1fEpNBITxf0qoFX4UnvWFJEL6+bDKx+O/7Vr?=
 =?us-ascii?Q?RBxCdZ1IAN3vQKY3KoYxMiq1h5toauItx3F6bCbiWT0FevKOCcOwqaQ3hS0m?=
 =?us-ascii?Q?h4pWOxwHdSbim5mVKpDMRsiasX2gwmDYfyPBPL3MagwS5rqptzyBe0JivdzQ?=
 =?us-ascii?Q?NMIS+jrIQFQ9O3ldTfggKQJXqoXs3PAi41/XW6Keas44m92FZ5xf/EXzN72h?=
 =?us-ascii?Q?qs+dCPC+0RQo4kx52dlHkAV12fVgIdQ3sRdTQfM4lBg/XRBeobcpUEVIY7Pk?=
 =?us-ascii?Q?OP9r65k3vnEgDECvF/ixh24vdMjMYxDoHxEpvG19mPdvFuKJH2s+5ih84glC?=
 =?us-ascii?Q?43hpE9htffNuHNCr67VrjjNETSKqn9y3A+p2pW32nwJSIdpDrylqMUzTCfQE?=
 =?us-ascii?Q?vLsRvnGP4pQ6GNpJO6KNA5MAEGzJJ2RcanLSjxI+YIp71auUjiTBVTMWeA8o?=
 =?us-ascii?Q?hKULSGK4zVkW4TwaI9QPS3d+RepMf0Vo34ESfv+4E/9u2BsX3nqGyhZJru8y?=
 =?us-ascii?Q?ouClWEnNCHMQSjMlCzplFYVa1aRgoGy+DsM0okrc3jAun66daR0CqE/FdTuM?=
 =?us-ascii?Q?pKHGxPEWYblu/hgoPjJz51nOu7XTbgtT2PzA8tKye/nHuwICF/g4c0FbyFqb?=
 =?us-ascii?Q?pH8QsZasF28owipRFmvzzCaJsYuxePVS2EiWCuQUijTaCzlUETmK+NLU2+ou?=
 =?us-ascii?Q?n6SwNcJZTh/OyF7PiwL8TUaTenqp66PaZ0h6XyzCp3ugEADOys/ySzGqMwao?=
 =?us-ascii?Q?HAU0ijj3CHuvrNB5JFS7JwPwaEIKsT6NlhB8SJTHjRZHU7GNDSceFrv9x/T2?=
 =?us-ascii?Q?Y4WIh3+TrXhQkuY13V0a9tWVCvotBCFxu1pS1ow65/75lLp2HrRWnYImmeKV?=
 =?us-ascii?Q?Ur9y7k1K3AwSJ3ZL430adYPL2coWQt9Zc27bwKzcTrAcl5/8O2PB+qPkgxIM?=
 =?us-ascii?Q?chox1iymyt/8DBeJSszIf6mxp4en8u4kvKRaApSfhQZu2E4NfVr2QJCI/7Zu?=
 =?us-ascii?Q?IWKPIK4NJA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd97c358-e7ac-45e9-f84d-08da14934ecf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:54.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SSaCNkPbxUBxfrXX+fzDj1aqhcWkViaDpnqHk/XUE2GjuH/wJtVxp77PBwX+ScsRfzq0DiqKSOFVdv3dgUvcKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-GUID: jbZXEQa5EmNdE4YluvNBN05yucoU-gD_
X-Proofpoint-ORIG-GUID: jbZXEQa5EmNdE4YluvNBN05yucoU-gD_
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

