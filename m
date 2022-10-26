Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E615460DB39
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiJZGao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiJZGal (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5815631FD;
        Tue, 25 Oct 2022 23:30:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nr6g018282;
        Wed, 26 Oct 2022 06:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=o//y0Cp6BgYyfFiLLdEPDlAj7cD89w+6qAS9zX8vDFA=;
 b=eK9A2fu5iutqYXI6k6pdzevbjzMqGmmfmVwc0eZ7q4tpFYZezu8L6eMjhbwln22nFSjz
 JgGtGE4Mz0SDt+i82HAZ97FYONCk6lnxjSpMpQ9OK6E1BSZz+2KVeCcNjnCXUMLrOc6j
 Ekh6cre7bf2NWB3y6PqitJQ65IEth8GeF9/umAUsHWR7141CDWDZxFDZjxkvBAgpu+oB
 MnQHV/zmhxLEjOb3yWPPE+RzwIvGO4FX5Di+9xs1HeQ+Vr17RiLgGrgirvjBBIyOf4WR
 iWb81GWQ9paE8XGJDFvZFKvvmR/UxmxQpzh+yeHt9klkveXMCcOGBjvKs2+Ra+uxcQCg 8g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xe4u2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2s15N011197;
        Wed, 26 Oct 2022 06:30:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d99g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5A7aLJlD8TBP4aRztXmLyRKwPTNS177Msoyij+q57SjlNM3lGIWGSpOnmHogoo4TXN3iZuIhGl1y56xusB0s5vgPpnQ3HvnE7vBv/QjjrjNUbvO01oyqSKb/lGCWd8mUnMAFp/pDFquW3hpbvnUidvnMu68QskEbByJ5/nvoA7IH2yh9v2GeQGnM42YQW52rhnj9Dz9Z97hOOo9snJMiU0nkHehydsjMw1bTZWcKeNdNYzLQW1+RWhsT0QtsaGbU4sedORzeR9dOfc/RT3LvVly45rCEoyOsWElqTNI8ibGof4oSa+P/LGiuygIRzv1tYOSiKy9l0w7yMyzfccedQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o//y0Cp6BgYyfFiLLdEPDlAj7cD89w+6qAS9zX8vDFA=;
 b=hZD6r2ZS7ADXLjLIYz1tKYGFjHA1f4elmW/KQqMlCFL/ES8zWE07e+znotGrr/Z2DSLTk7YsHF57xT2l/ZOpvD9s3tFAjC8tnL1YbRrwADjtHUOVDcSTsMFp1/MhvbjprVkJJt1qEC5kHoHOI1PUvINRcnMNraNVv3qfrRL1O8xzYxsMXtwFfUbVHF/VrdUMTE4kVLi0W5UR7eywp7QuVGpjAB98JlpZ4FW34f3AjrJOpPwp4m8onAvO4tDwiRtnVrZlTAZkUX/XgpYdA1n1OPMNp5JsiL5bZ2bZ/fNKy2TRf+TISOHWxsAog+0DgsRzjTJr0VrUigWmtBJCeCJ5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o//y0Cp6BgYyfFiLLdEPDlAj7cD89w+6qAS9zX8vDFA=;
 b=ASu+6NbJ+rD678ZVzKtKpiQ74mTAgoDQmlVY2/3/oiVYQyXQh49/R7HbfvqbhIm5kdrKG5fy8+SEwztK08QPAvJOOaPge4ykfsh/uIQ0FzPMgGhJe+mC3oNi9Eu0WhZ5BZy7MP6w9JEqalmGCRdKDWoDYcv9Z9Ck4WsnLA8pJT8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:30:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 16/26] xfs: preserve default grace interval during quotacheck
Date:   Wed, 26 Oct 2022 11:58:33 +0530
Message-Id: <20221026062843.927600-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0156.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: a0257626-f574-4a25-33d0-08dab71b951f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jlrAdg7VthQJNbxkb6fcGbAqDKOv0mKrkL2RlBAuX+2DT0x4H090vUiEsuYL8kjLGp5vEHFvDE0N8sLzS5DW8mio943ipjdhIpz/MKBaa9hJb0bNUIKDAC3GY2kjWnZNUv5b0Hh+JtzTIeo8OSZDU4WcxbKm0/dtkU2xjGadevyFi5OWWn0Gip9ymwuniykza0PJmJCIKb8jjRwMmS6YqauzhPsFdo3EZDZ0zW5u3fDViZp29326Y2Rt04LlfZ3IEAZSVItL+2kbXz11QCn/nOB6kY9EZwaQv8036c4J7dz8UA40HHj1ksY0hX0eVO0J+Mir2led5FGfyXMimRQwIl2wTxsSiPVwGSKqhj7b+BzG+zHIuXnn6B7nR1MYLJLr8wifwszdjrrCAQ4jyrbFCax29lfFX1XWFpwtpR12ZsFTLK3StiVHlLqO5b+k++W/LPdt4oc6Lc1WTh+U72l8V3yXgs4VmZiuKo/XZZZx2uytlgY7lgH9lsNd6U1cC5iByiztfr7xQyWBC6EwIwYxTRcnrg7ynbqh3mq2EEOsZwg62TSXuW/1Qi78HCApwvIettFwq2APIrf/w9yyL91MBxj5kNAWbWocTU/O1mWfMbgP5RTJ6G3ITu647qBKJ7CAjFKXCI26027+BT7V+FHU03KGiQc6xKZGkRyzDQ4Wt5BXtmM8nBlBa5BMERR48D7pcNnYOoHHKevock/oBCxe/IGcmB+F9wUO6TBUMBuyXNKGYE0TQJwz53/sY9yl6Xgd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6506007)(186003)(26005)(478600001)(15650500001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zihAupv2ANHHiXyJSE4LMiIw0h9SJ1oxJz5lzbbU66z0bpoDEp1FAQIKlktv?=
 =?us-ascii?Q?eCb38J/K11pL20beRfHMTF42WEu55P5y/8mTv5mGksuGzCIV14G05hk7xBkz?=
 =?us-ascii?Q?VlirWRmKHFf8XYnMrtfbNyEPbrpOuPnKMwqhHKZ0YFdUL3/JCbBZnifuUsVL?=
 =?us-ascii?Q?kDjGTxfDxAPwfIVcJZw8qJaSAZCNIvhBC2IGSaOAajmMUWdmA5fvMIBgp4so?=
 =?us-ascii?Q?gUFkBsf+wQu9IhzVvOv+vwIh0N2cV1IudxcbizeFKNiAU7Hc+H3adTBIvybv?=
 =?us-ascii?Q?21X/SAQejmqOp2qUR55QZGvytKzNsAqZKeeiFnKYR3Sq/i7LNS7bUOHXEeUw?=
 =?us-ascii?Q?Ky67L/7YxOm7kmxEpo+JXaXTXBsQZiLD8sljW1Xt/Bf9OFvhx2N623cweJ4D?=
 =?us-ascii?Q?ahOj0RrneSMALbTbkqtF5viW6uaW/YZTx/PCDwesKi1RTbwS8AejaItVWwe3?=
 =?us-ascii?Q?jw+JYa103J/Rs6wqrho5g8eFHrzOCsUc3AWMWekj2PCwedEFs3ZQjHdm8FgC?=
 =?us-ascii?Q?wuxAal7d3FHZ0aF+xlkUsGY6VjrIOQvU8aMJUC/BNtObGwu8FpQj+Xm2v2Od?=
 =?us-ascii?Q?35rqMAvTQItiCuOIXrq06USZ4XKYOd5X3UwfBJaOjDIOdNBQ1azVhsAcXr5F?=
 =?us-ascii?Q?/890GWpjcQEeRdHVXgbDwkIaThAe8nChcWkI+OWOwUK/Vp6rZz21APpOIocC?=
 =?us-ascii?Q?AVmhk0Mf4DnxCYwvA6kCBmkin1KksIlN9ih87GsKe6hcboEMVFFOnFGGoGEy?=
 =?us-ascii?Q?SzEs766+EGgEu75YL4ODN8Knpb5pm1QB3P1AdCVupYIhHYyIpC/zWS2ONJ3K?=
 =?us-ascii?Q?hgfOSwT1HBzAmcTIo2fNq65fqf9DCnn7oE8l32sKisYlm+d+jlmw7EGXgOOl?=
 =?us-ascii?Q?qcsIxGSfWAiUdxFMgxI5iNY3BU+Hf5UqKwKTJ3J43XceW6RERCdzJwNek7dN?=
 =?us-ascii?Q?tMSOSzJLf8hrlvCHTQmxV0P04F5wCZo15qc5COZ2Jq30zKio0RRVVw6U84Sa?=
 =?us-ascii?Q?8nOkXHfRNHxwDFMuW9HK+T7/IP1R4pw1MN9Be/QGfBeD9sXc6eh0IuiUFz12?=
 =?us-ascii?Q?TdsC8VqxvW5rPpR1ua6S2hIG8xM9i4Jji1aovWISUSUukFJ/72bTfykaaIh3?=
 =?us-ascii?Q?4Xj/deZII7QnYI9EfKTBC+ifmNtwLsSr1c8mPBd9SU07Rmpxc3lpxhnJGhap?=
 =?us-ascii?Q?yg+uJxppJoRZU2FEJuDZew3Kf2lAuWdhVhYJN75GRn8iWdtuxuQc6p3/4Gru?=
 =?us-ascii?Q?DhppL3Hts7aQttsx3irzxm/SLxxTwvOejGCpz/uSEGtJwkn6tPl8sDAZl3bj?=
 =?us-ascii?Q?/WdKel38FNgchTmXtrs3PDUCen3K2Ns63Lr/MmV7HYuKZV6rus7RcGD2iWab?=
 =?us-ascii?Q?fDzfERB7BsIYQxBl++LyKiYr+XS9CVd6iLW9Oyds0dzIERih1u6sDcr3vRkH?=
 =?us-ascii?Q?PZwS2bl08Db3YarpzhXgz7VMvLlpy/V4Xv+Zzf6cTjd7EpiVjVHNRArRuF9l?=
 =?us-ascii?Q?4GZvqMByERCs692/grcQrZYWyQL35wUgfoWRlxdSUL7hZS9IdYa8Qp5Q4sTh?=
 =?us-ascii?Q?YREuEyzQeNZiIUNYK0frJKrBfsWTB7+08egKerbQX7NG7U05KzreOpW1Yp6H?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0257626-f574-4a25-33d0-08dab71b951f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:32.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: japBxkkqu5smL1AmgzMY4xArJmhut7rZDdzH15Ahq+QSeM+yBEa6jpArWwIqGHo7SACBwUJeWzJd8W5xQmwjLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: rxJ5ty80ck4JTjSH23PWsUlkVtfS78W1
X-Proofpoint-ORIG-GUID: rxJ5ty80ck4JTjSH23PWsUlkVtfS78W1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5885539f0af371024d07afd14974bfdc3fff84c5 upstream.

When quotacheck runs, it zeroes all the timer fields in every dquot.
Unfortunately, it also does this to the root dquot, which erases any
preconfigured grace intervals and warning limits that the administrator
may have set.  Worse yet, the incore copies of those variables remain
set.  This cache coherence problem manifests itself as the grace
interval mysteriously being reset back to the defaults at the /next/
mount.

Fix it by not resetting the root disk dquot's timer and warning fields.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_qm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 035930a4f0dd..fe93e044d81b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -875,12 +875,20 @@ xfs_qm_reset_dqcounts(
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
-		ddq->d_btimer = 0;
-		ddq->d_itimer = 0;
-		ddq->d_rtbtimer = 0;
-		ddq->d_bwarns = 0;
-		ddq->d_iwarns = 0;
-		ddq->d_rtbwarns = 0;
+
+		/*
+		 * dquot id 0 stores the default grace period and the maximum
+		 * warning limit that were set by the administrator, so we
+		 * should not reset them.
+		 */
+		if (ddq->d_id != 0) {
+			ddq->d_btimer = 0;
+			ddq->d_itimer = 0;
+			ddq->d_rtbtimer = 0;
+			ddq->d_bwarns = 0;
+			ddq->d_iwarns = 0;
+			ddq->d_rtbwarns = 0;
+		}
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			xfs_update_cksum((char *)&dqb[j],
-- 
2.35.1

