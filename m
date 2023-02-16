Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE8C698BD9
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBPFZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjBPFZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:25:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3F54A1F0;
        Wed, 15 Feb 2023 21:24:22 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J1wC011384;
        Thu, 16 Feb 2023 05:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=MyIPZ6XvuICwylYIbQIrGa+PYPBrtGu8LSjQD7eoTpo=;
 b=ft1XZfM0ypYGkmVu4ANBdxuT3hEadifowrPKcTDlsDcZOiSgbX1cVEXlDq5/hTZI70JR
 VT1fvDrCcF/ZmXyEFTnCRjBt7uO6XiSUbCZS8njcRGva1eLlPO/QCtgrIlJsLe5JVynb
 xC99J/hU/EKjwV9rdutqi3DLpt7PGrY2rQANRfFxOIFzt5CKqJyv91poRs39CyCfLZJZ
 xH3zaV/gaBgvYE5QFlP2VK6G7bmnrt5pcbl2mBLUtzWrpxPDGSCKDDqGIhwmFVwGsOHh
 RmzArnEwfrVdHS7fzqCw8SXSTU51Nq20OTgmoNbTrGd+t0xXHo8NCWwaDjXfCtbEVlR5 NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t3j55r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2OgYk024574;
        Thu, 16 Feb 2023 05:23:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8myy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjvPTyZj0NS/GJGzvLUukDXryXi8uAM1fcNNRs8vhgXvDTPl/oiB/R4hdI2PiG8igvpNXhFrTY93mngIbVKgvEvqyDG6B4D3uWqaBPZRQnjehcAEZsZrorrLDKfG5nKEcTxV32snNCCEH6CuMcGXD4sAeZsS1F58Jb2PhKcTNRE3VhWWMFfkKHJadxNFEI5pczN4RzhaVqXDESXJcpi+flntU1hiCEhAZPUO5Xoo6/sCzri7/LXLkseI5SlcFEbAcoICjPS1Yjrnuot3P3aqvxb58QjDuIscbpsk5Jhl2eI3tORNnAezgOezIaDCd76BeJGEo2X++pPHe1tTk6a4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MyIPZ6XvuICwylYIbQIrGa+PYPBrtGu8LSjQD7eoTpo=;
 b=GRZrXQ4pZFVf5w1FXBtLRTupW50pV5an+w1DJwO3ftV/lYOuoHFLrbLigFuE/+d89PSN+yy76uvUzEl6XiYJbf+NUYA01GYqxeAlVwzbRWEmEqxSfwRO0Dch3DeyWoQDNeGab+WVfJ6beDczELMn1LcuWLAawouFgPlnzfNIetLvZChFCeEfi9Wx2GoOBKUfXfwZy3Y0VK28XaCQHbjg4I+k8SojYWyL+1NFpZQZbkWTWFYvEbR+PiNS5d+pZavF0qYlf5q+vSMGw3PKHcP+WF7x6L63EZ9epIit2cTxr+gb+u4dTmXirvLJ6ekmoeSiyOnBT2nbGjXgXh2LMC23YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyIPZ6XvuICwylYIbQIrGa+PYPBrtGu8LSjQD7eoTpo=;
 b=GOTZtmu1SDz0TvK9ivnYdO+B13HVIFopC8PPqVoREPIQ2loaZ89/jr+GpF0fRpk/og1qeX+NeEHjOij/OuoFI8aXRZuSaPijm8IzC2HUfnWvuJVPl5zSysDA2PJEiE756rJyoEf6Yj+JmHsq60LpmZ/QnAKf3AtFoN4laEZlI6A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:23:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:23:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 23/25] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
Date:   Thu, 16 Feb 2023 10:50:17 +0530
Message-Id: <20230216052019.368896-24-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0105.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 5140deec-a38b-4e12-888d-08db0fdde6ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+YVNKS1Zke6KHAkR6Malxpeor4w5yrxmcb1YjHYsUZWZQ/DHvKYq2INTEhNmT6kREwJ35RF/3xR6FQt0hA0sTSJlkZTM0KIdJHg/4z73y2SqvO4kFLyKzFny/Lv6BpeMZL7iOvfoSHLwBQRoDCFDfsGENgzHQGtCIyDe7yW7/uem3p9wtnbZNzIuvdqyp1USL6tz51BYfm5HPJGN84I7hVpkXEUx5G7dr3yAhDaKmQSDSbItcIVP9rDcjn53ZHeM1lJK+sNSV133wcr7A/3glWcM6RPaJN6BcCDLhRZ+SKd12mGcRqjc2HCWA19ObOX400OeYgBwK8Hvp6ryQlrjGowQVSynQmLDBv32UErg2kreNfPIfscQ1fHVun3elpwdwMpppa78UKxaFU9awqRKJBANUlPG7RqBOAN9PUxlCnOEVK086WL+/JGcbTj83+N5lLlxNryIjK45zEmbhQJmxTnRtQQtWlYI4UvPk+OsJCfNMuvrXDsaRW7V9tqYOOFzOvvfeQc3b1xcx4x0ZdvVXf2sKGR5NuSYNxQzJ65nsYGPiiE7dqK6PP/un1oE9GUGUdbM/J78LXDb9Exgchnw9gD8hisgwTgmggxZsdRXc5nCGDMv3p8nMxzUatATF8Ze6CoMYZub0IWzkofzFaKbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7TmPzl3hds9eKlZAO1s22nR95xL/d5gvT74pnjnPNhx0Kp52bteEn3V+Y1CN?=
 =?us-ascii?Q?BG3FHaqkxN5AMTWbxp1ohShNTyndII+jFJw93ruOWdolczIyg2q/jdZLenij?=
 =?us-ascii?Q?XpOYLIIoR/VpM162BF+2UjLZsBLwYWIAGNfhNX9lKNvQJonYCJPFnCNTgF34?=
 =?us-ascii?Q?TRX89NfbasZF/RwWfP0oC9MLIGy9a9e9FCsdmO99xa4HWAQV8W8I+lfIZAk+?=
 =?us-ascii?Q?IL0LFP5v5QWKR+ebKTr0N4LdjoiIM2daux79d4Cc8KZ9l+73hDLacSNlGOjO?=
 =?us-ascii?Q?Olff/mlh5M7IzslamNUl8dhRejq7RgQOTrTckmW7s8mbyKS0K9uP8gE8lvDK?=
 =?us-ascii?Q?uTlGE+4dj7E2xBt6Rv3N70psGhtAUNALqJ5ubcsro2Bt9pCMWU34seHdQ0Dc?=
 =?us-ascii?Q?pFoQygQGuge62lMVfp6XaIk+MX9iE7BmF+uYFtyoQ6ZNZY/W9JPUxTsGTRCA?=
 =?us-ascii?Q?1Rk34poDmEBz8pkRjjZZWCiplDgKV+Q58r3zyBkEqcs28nRhs145MUnAtOgL?=
 =?us-ascii?Q?WbmZiJUN1oj0UTGrllTVVqKFaqNprAsUmRH9kgNium+uLWR+TcWf8N8N2JyE?=
 =?us-ascii?Q?xcrZIzCKrAgkWxrpjhAqc7oPDcZ+fLblR5ShngqDpc7c32bxY6dzOLL2D2kA?=
 =?us-ascii?Q?BGuEGGlAs1mFmLZWGzwvGlGX2O7aWqzTriwgEK4K/8Ut1ArPanQ+H6APnOjZ?=
 =?us-ascii?Q?e8zs/4Jt589G0ObfJYlqbL3l7X8C/dIIcnYekaNP4MNQy66pliL1F1T12X9p?=
 =?us-ascii?Q?ltBU9Rn89U74pV5d1kOH4npdoYBGFc/tTOaPQPae+0Wa2Psvj6G8BSDxj0uZ?=
 =?us-ascii?Q?lr4OK8ekRCzpztvROtkwwBye8ERBOI9yKqn43GKAsDJgTGrVKjunBcCFS46f?=
 =?us-ascii?Q?W/fYCX9tR0KrsFHBywrHYuZPkT9OCnpEV4cwRgXmlrYJWWVMXiZQMjSyl3hd?=
 =?us-ascii?Q?7U0j3OMIFiQ5wiCQPWlCsb8p7YBgQT9UKa+9cJ1wDTN0yiUMIBawDvgToRdT?=
 =?us-ascii?Q?TFk3huraTu/pHnUzM8XVdzA0ZH30O7pxGXcQEtdpK+FDCjmGhANGO9RWdILd?=
 =?us-ascii?Q?4upWMBzE+5ZMBcLPiRlebxJpuvT/1D4bsxY8/6dQgi4XrLNmBucfNgxkGwGD?=
 =?us-ascii?Q?SJB/0dcdGaXU9pKWf6mmBbthp5KDhVyvs+9OPkv2Iykxdk9m+F/Nh4cxS8uh?=
 =?us-ascii?Q?E6GUYR1AtF7atJ6fOgCY3Y0Iqx4yb9KpqaKPxE4WFNeIF2eqAjOdT2VDWwnG?=
 =?us-ascii?Q?+DjuR21R7pJdT52wyqNEAEPe6zhq8PNlKoh22rMDggbmZS4WOKRLzpWDnyDZ?=
 =?us-ascii?Q?+cj4vgAEXz3vfJVTMbSHENVUMPVxRllmNm1Z+NHTj8SUDBb/zEbKA0B/5KZy?=
 =?us-ascii?Q?6qh/ix+4l180h3vvbHb4/CZQDyLD4Fnd84NjBaP3zYY9LGnerLtX82UvP2M6?=
 =?us-ascii?Q?GNqElGimzl1kY6MVSC+hjhhLZWfWzcobVv8GYpaXPE20rbZs7LKC3J9lnAkD?=
 =?us-ascii?Q?WL4dy/k5/VPJpEQsjbJFdi79H2gkJsQiNEGTaBBOF4n2zIX1fl2CEdn3fc/v?=
 =?us-ascii?Q?0MM7PLfmRZFmHmVnfO89fmqK0qnbcokG86qUVb3XCxbk21s3d0yK4x7wcbpC?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: doyxheYeUjENCrSyEe9ptAW24Nu2tXvaHGmmm1co/IxRsnHNsSCHI/zkRd/JZocProrXUgffXkPSQ6VIXhViEZx5ncex6XT+ZmfhEN95XN5GZCU4yuKGI4Vu1sKSox7liqQDmtjGD4HyIZCRrgIkUCGwpUWSpz7HAMVBOpgmxi+9fM2cVpE7LJ1MiWai40yVbMKrMywr9JvKbodRh1ycHCDq3vMKCNyR98aFlbVhGKxtNH1BkeXsXLeFBO5ZIKfN4sP7CNjIaZT/yzhjvfxKSqo5+8uVZlAQJV+JbvtKMlHOmjNmqVIcKuyZT4ljUWSwu3VWuhXHhE2pmGvyXdcoEsJOEWGFQL2Bhxbs5x43Kagg4K1IOuBSjNxgIR4rHQ9PqEyPWnZAHQEl0z/awpHMMfKbWhUxM3xvCLPEj3zfrHpwDiHAgxKV4DBBW0JFunrhTdBDClhv2KlqW/3IqLe5xsyDV1So/DUHLHJ0O6G6hjOVYNbXi8fC4pTwuYL8WPZpRHMTnJiry7bxQ9acp9QWVJwjqd0DaANYOPbt1KFKfrcteX13rydU/YrEi18rcXd3R41L7Z+hTQxyI+1+6izK3cS+exofZOjE2hn0E8bF43vlH1L9rPQhofnKnrI14fzUAkje8PA8eFD5d1en+TBMZ9x9k+XohbXuQJTN8efUwXyCtaSI57r1/sTg4XI/VDxMc61ocmsrCKICOV286boUcYxsrcp+fgED8bYyWcdcKjh5dIXcEq8NMXPdVxJfg6XnX0r4d+Vi0g7qau63D1XWpgBCJr9uAX//LcBFDOEEK7AEzhzUw7YwdKtMMJpUga/0LIWfPxCRaeCCAYvjADvqTlVuXlFQ1X8fgIaACfwpQO/6D9Ie1CGKbtYa54SIVzdq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5140deec-a38b-4e12-888d-08db0fdde6ff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:23:14.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkfZvbY3Sq25GliW56c0Bw76Fdcz6nIYrQxK1S80AXGpMoMgjq8RdGcunEH0qOIjt4jx8XHpaRTlWeVj9c9mGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=962 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160044
X-Proofpoint-GUID: 4YVeXHdYLyh5QUOdX_tr5kOV-y4iGKx2
X-Proofpoint-ORIG-GUID: 4YVeXHdYLyh5QUOdX_tr5kOV-y4iGKx2
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

commit a5336d6bb2d02d0e9d4d3c8be04b80b8b68d56c8 upstream.

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 1f53af6b0112..cc5c0c835884 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -362,7 +362,7 @@ xfs_iwalk_run_callbacks(
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
-- 
2.35.1

