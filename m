Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93A45E8CDB
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiIXM6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiIXM6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA76110E5EF;
        Sat, 24 Sep 2022 05:58:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OChGN2000722;
        Sat, 24 Sep 2022 12:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=Awy1HukiZokAA9PAQaBhkSK12KVC/4Qic3BhP9k+9+oqdeIhMR0ypQr3uc3dpMFzOW4t
 KX3YuSdmrOOv+PdI+kd10lHNv1bmd/V0n0O0RYhtaIYxnJI9G1iGaZXTUVddESjTLdZu
 TMlhbJuNpFBFJEtia6eJh+bp+U5C3BHUDeu3YRFmBxfnP30Y9iisumGtuHEmwzJAUc7e
 r6D7kPVTuKC54wCSt1enjyOxlcdHqFim6IVIyNZISdpzQcKFf0L11fYILl3/xGeXJo0i
 VvYDm4Tc5MSGAqAsbZCBIyWnW+1SMBCZdQhjvu4a6P/8QEdJAMR5+ZczNJn6vLyOQtUh vQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrw8h3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OBvwDu020280;
        Sat, 24 Sep 2022 12:58:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb7h8ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbIqRCHk+p8bXrJaXdvRFJYWmasdnWFxbz39xWr6Dq+YwouVCo02JTWIMNq1rSvC9EiP887OBwZqRcKGcUOfnocTaxFzlQTHB/28o3I1+F00Fra2QA8CShhVYwbZaFfQEmSTHLOt7vl+CBfi+xKG5ToOxzE5u20rBa7wb3IJjW0mm31eUU2j6lY4/xMVQZZg7fW2OdNiV84EniCQQD0NbPxZWw7phCjaTiky13VLzc2hhgi7bdgVK1QdZZGttRcO+AjEWs2jlBplw+LSB20lcz4dU8TxgqRRRu3oVLovw0tgh4dryTC4a0AKvUUuulFy5qff4Tqab/V+tEdV5Kh32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=cR6hbj540jaJN8v4S1VLBFm4GukCzoj9Ewsq0Xt8LoHJ3w6HOiXka2TknUjk7ZI8MUn3nYNh9Q1vUISbfM8A4wod6EDq4d8lEaRQFf/in8QiSZ07/bkK92i7xtvcn3CSE8Cj5TURSYDsDKup42ZA+AoP4tKGUWeOqDo1F7E/BOXu4fzGgi8GNJSitOKMALtJUtkfWvnzMcRwUkIWfT1Og39xvPoGet5apcor+FIMZydK4e4l1nWnQ1lIiwAXsI7KqAFLWt2hthYC6JjMs967TKlSrHjuj7C5avr9LcS5uCncov5aeWKb9YY5chGJ3F0XcwJFoQSkl3G9WFwJJvNrVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=foX3kgYPjCeS6Pr3GOgvO+Oyl+GtTzzl2Vyj9cgTT+/iVcYFoM2B9m31NJbS4hopOT8OGEAZcLg8CiTNfAByw+TKRTXIIjKpGEpdBLlqZATj38mojEjvtmhCVWoTjuHAeFwqfanihISZp0b6OTIdDvGzRDUJNbFgVS8LNDXQPNM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:58:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 12/19] xfs: fix some memory leaks in log recovery
Date:   Sat, 24 Sep 2022 18:26:49 +0530
Message-Id: <20220924125656.101069-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0151.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cab0880-4b8b-49d5-5ae0-08da9e2c79e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPYeXmRovkXnmtG8P3CXNSI4paEhqKlKhtLR0Zn6nzpB/j865QJe8GFEujK8ZHiUgvpHHQH8vYGtLWsa+E+hWjWkYAZ0ZP+04Zsoex5YFMMRIMb4gAKkvbAMF1KeR1lXft+53s8aOZVsUFE/RZl42URlPW/3UcQvDSO4+m5F+EhDN1851FtpueW8k/aIbR8w7vbmm4/Qe4RU4K70cbem6gEXAWgAHk6uYkrYJNNJ6uTzhbAR0iqDPakZ8/RSzI1k1dMDIhll2Zmk26ds2yodrpiRQ4wdHxrYFe2F0CbVzi8X3DGypypPQQt/HFibvs9sdYziFNoR3vCnTak7PtbkbRfPxOC9oajXo/f2DdeawbJbymE3I+3AFnDuhvzRa21Chrvj49ANcSi1qLO6s8btbb3GXNgi9uOn7RIBVReTFhlu5sv/ZBEV4Tdcf84OhN5NrbR2m4xfO/vexC7IFmaBq15sivY8r/joronrcJ2tlj5hvMUDSzMjOVnzNUpULCNtBaWF8qU+XuZ3tFs6dXS/4yu1FJSqbIKz2UkGztX8hEzsA32th9otom9f05mslAWKnQ6ms4r2PagOMvW5ixjBHv736TqjSNXsFXiMe7IGDEyX11bTVZZIRLirEzh+XGZ2R4C990qB3IGr5wrkUl0P2LWBFFv0+n0KPHVt7V5valpSbBKYtY1ZLIombVj7sCX3bOFN/iO8C+dWp0lYILlq6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(6666004)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ThFQVh3jEp4jovCrsEwDJXFoyQ+s9j9WIBZ6dpJLV8LHyytkLVDIXrM8DiuJ?=
 =?us-ascii?Q?aibmmwG5TkdpYLI8Q03HTbRQDQJ2IclWBoReQhb3irv2ETdGedkHJIAKwfrK?=
 =?us-ascii?Q?FTSIQx4GKWeSjBtd1wpm87+nyT2H1p92vx85IctfeGqigHHI/W6LLPqOXZuT?=
 =?us-ascii?Q?kjurZBWdb2KabxT5V9xM/c/PMBVc1//sk0fvnJDiygM0u3d+azyPk+g/c1B1?=
 =?us-ascii?Q?90Eh3w85gIFVfpBxR0Ge/j8YyYtc0P47hzko8xwXJHIv37HrvgGG/M7I/0Da?=
 =?us-ascii?Q?pyrjWsWH64hIYDWP7q8ptC6RjRZcjJX9+Tt1HTFahlmenrfX54aafFMr/BD7?=
 =?us-ascii?Q?ZZHDdr3XyA15zv78dv/Mbj8s3LWQpgXYSB1owzzot0fS/McOqETvJzUXHGPw?=
 =?us-ascii?Q?ICN0u9bKcgZsWy7x+Fc6zDkUKL7C+iz5O+q5DEe0cgma5FE/Ge6h/hh7CmgB?=
 =?us-ascii?Q?AfOMiZHZR53foTjmSNLIya+qPBMDuYbyQFPW2PL8GogAeasoh7NZN9dSRdnA?=
 =?us-ascii?Q?6AxNPplsDEOb5gzxj0fwMDBOHifgNjAuynRNlXwTfIjAjX6WOs3jQiiVam3S?=
 =?us-ascii?Q?8v+zazVea95pf51WWWVr3zpA5J5U1mTFOJTpienE5veTwydYXVVJDO6X1R4p?=
 =?us-ascii?Q?riU3092jRSUashwhfCcvRVkK4j/t/2apGmJnTmnY3dq3TrkP/sad+e3hRkZj?=
 =?us-ascii?Q?85soxtWpix6lroGprJO2GY4LhbLxtYH0MliNa1d4+/ciDN8vXcOBSna+PCea?=
 =?us-ascii?Q?jYaIlDCPhBi2cUCYQaYNOeiLhdIF8v1R+MJu7x/rUinjB1dkCAB754pGxb5j?=
 =?us-ascii?Q?vtVdIBuxvz4j3afa6q/cPscZM1jxoJ6fFwVjn22t5u9zoo9exhn2+0kRTL5Y?=
 =?us-ascii?Q?BUMpyIn16dmL1y2cqsavxoYFm1ckqFMVvGDkOfXlOI8MkGEaU9aiFyDDopwh?=
 =?us-ascii?Q?4B6MS+wzDBKmCZ7VvNqrXIFVJXqUb3nDngoooP5ZVo8jGfvl6W3/gEUudhbQ?=
 =?us-ascii?Q?rwk9+zwhYIht0qwwvVgaBAu7NOaDECenR9LNH5BHzZvOCJyELL/fAPIJyFpF?=
 =?us-ascii?Q?FnaEFLuOrvGP8cQkZEYZ5ESL3mB/ILypK8Iz3N8G3ydijMsKefzO0bnoeC8e?=
 =?us-ascii?Q?X2Nc8X3LSGg4gVF72xR0WcZCrY+dNfOtBRJL/kPbr1pB3ElkRYKEflsQT/Jd?=
 =?us-ascii?Q?rpx5E8QPG6BnG7jzMx2VUlijVpHIJ6BTMQEutZLlnV84C2rRk0I/iAKu+qgc?=
 =?us-ascii?Q?dfXP2iWBahjMMhcDHDTQBewn6X2mTTsSh+oWaPutUFnP1eiYjlMhmgfY7jnp?=
 =?us-ascii?Q?f2QZVcmJkKTqo+JQLSRGmY8P9gWyD2QuUi/oGegwbj8j1aNEboL48ykEBLov?=
 =?us-ascii?Q?8Ey0I4WNM4uyoTLA9oJCzfZDiHm/euuOI3LRHEKJonv86RuneKGqNYNqAci1?=
 =?us-ascii?Q?2sH9qKds0iQOjpwzh9HJFC2Xw04cUQQEkBtAkndq+pF/v4EENQV7W6UvS6Iz?=
 =?us-ascii?Q?JPzmnFx2RQdfjyAmKe4+d+A+fQ2XVI/ryL6w2QJIKE2ah2oB0sgYfsmaXGoO?=
 =?us-ascii?Q?3hyH7oU86/5761aqzD6unMUVj5R0ND9DhTHKPFmGvhdGJbJQvLh0UIPjHkr3?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cab0880-4b8b-49d5-5ae0-08da9e2c79e6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:28.9422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qr3YUSRRTIPyZ9+7zSBBHycwmPSrZZ8QDPQNk0zDpok3Z881rpVWRhScL9FDSDgazYPENfO3Ry9GbeejOQEC1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240098
X-Proofpoint-ORIG-GUID: 6FGPJvzbvaBZDu5rpXPGncEaVp19m6Wm
X-Proofpoint-GUID: 6FGPJvzbvaBZDu5rpXPGncEaVp19m6Wm
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

commit 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5 upstream.

Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
then bail out without freeing the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02f2147952b3..248101876e1e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1347,10 +1347,11 @@ xlog_find_tail(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
-		return error;
+		goto done;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto done;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -5318,7 +5319,8 @@ xlog_do_recovery_pass(
 			} else {
 				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
 						log->l_mp);
-				return -EFSCORRUPTED;
+				error = -EFSCORRUPTED;
+				goto bread_err1;
 			}
 		}
 
-- 
2.35.1

