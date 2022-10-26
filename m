Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6482E60DB2B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiJZG34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiJZG3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC241A070;
        Tue, 25 Oct 2022 23:29:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nEAY023399;
        Wed, 26 Oct 2022 06:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bnW6c8exk16svsRuIspMgoYceKSnsQQTUifrmtM2ioI=;
 b=2IrxgfFOLOaT8Qt61sL9iTMWXDn+XFZVZIen38+zB/APEAh3kSMYMNrx/W6mzchi289l
 M9zOY8LE95zfPMg3zIm/JwDXPpb/99r1sZolWB07JlPqdlpRkqyDeVIV218So9Z9dfxz
 ty3fnRI0Yk/m8QVXsohbg3N46gF1Uy2fS9qCSBxM/pmvv2eabu0BOOgFHtsg+Nim2dyP
 eeTNIFLQuZfZYparU8M8DSbcd/rH4eoXmhloXT97tfIk0UrNuYpMy22Xh1CNU8M03o9i
 VHH16gDsUcfMwG0GAzhNwibkJ21s/pDiH0UCuRJg65MzDu5RmsQ9QodOyIssY6Xodr8W 3g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a35np9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q33Vl0017308;
        Wed, 26 Oct 2022 06:29:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5mwty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NC8/dBznevDKHb4d60oDj3OJ0Jw6jC1i5F2Wmf5qCnd6eAza0sX5x7dMG57wzL8dlF9DCUaq+ZqJlaRZojXIWhn0rs4v+Nt5HpQyNCuc6Pkv1WJNQ0K1596VzQhjA/8tjdPdDoC6FMQ5U8B3pIuGsYtFJGD9nnDD4XwCnOyexL4Cv4hMHGfaG+X7qZtdysBaQbWJ5LCOcvLRTkafvEtADHeqrIjQmY7/OniUXLxD4D3kfoQh9KLgDf0OkBD4pKwi8+aC1HMU2Xmt/oWvYc6X8PMSqyVPQfhv6s1a9j2UeGqVeebtqgKcctxxuIE/px1BhjjkiyLHBXvIAbC5a1CEPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnW6c8exk16svsRuIspMgoYceKSnsQQTUifrmtM2ioI=;
 b=KekTtV20rbEfaNWeX0UoIhxHMuNPI9rDuYyZxbymbCx0XAJ3TAdCD+Wtm/2stXRxyPTzCbpI+RItmrHWD30ofkXYGl4C1iHkQilYVpzgzOW4Pic9JG50myQpU3UK9y8OOCJU4WYv7ORQODGu3V5lsaWig6onNDSYwFynWDk6rv6eWlW5W18WCPP12vjeNNvjaHwNVzLpniM+LJtn7nY2Ifd9gTPJJQViBBMr6+WQjWXFcQlwhds2setgXiBFGMHEqU0Yk2AkLOsGhTyaCQJ+RvKwrWMU97cGlY7Ipucri84mqPLc4D5LNsQJ7Cp0SGNU1aPizr939SRxN8cAQciNUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnW6c8exk16svsRuIspMgoYceKSnsQQTUifrmtM2ioI=;
 b=R6/q7yhHMb20UPR8jurp6P/x84GIabNhLvwEU4xk5SZOD2l6X6gymbCZygD0729yAu5CDv6CalvGrxXm/+PegpFDCPwyJhDBGqXA/DPR0CyWVljFNOksmSv2OJ01zuZEcUDgKLxSlzk4tqAolMRsv/8XkzrthrcoXh+wLjBTqdc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:29:45 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 09/26] xfs: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 26 Oct 2022 11:58:26 +0530
Message-Id: <20221026062843.927600-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0216.jpnprd01.prod.outlook.com
 (2603:1096:404:29::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: a28eb0b0-2420-4744-d338-08dab71b7925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPYnj1DPPLgZmGJE4fb9YS8Heo3FN/tS89Vp+H5dkd2zvKuPEJlLgZ+oLZe1m2/erqCRBn9vV395LULkyTNwjqjeXPRnsK+0mY5hOuRIUQeBGBkDVxXLYXC7AopX+2uAgP5wwc6c/JwKlLgiWvO8aIRG4u/w4tU2YVBhwUNNECVnPeIUw3xtFLx5Er8t2oN4RHIV5CMz6ypPj3z43AYg8AzM6dxa2B2K1t2aGmGXCj8c+K9KbiRaQDRdahzwAsxrwzkz3L94QuTmhlbMOSHEsa+VbBcqsJYGGbvzF2q104Ypf4/gxKVZ8MkA06J0tJP2cagSf+aJz+5wVousQBGBfr3B54Qbmvnwl1FlPLfVAHxO45z8gHSG0bFHsPRYQ3rSkvolUURqf4djV2TxSFbSz9FwK+ciUleEY7SGqWd28H7OSrTqPmLSJxt7FJOrWWUc/CWuQqGo98fcxfmADoF2lMOmJsCzTqpFsoF38p2S03ya1lhQZSjPT4ffyJ17erO5gc/d7ACxK3Yu1L9haN1AULOX/WYXXlmhoZVGp7njy3UdaMnKrhfuTwZZUZ1RH4mzAloMQptWs82Ug7R9+CoHxGkFvVq7n7x1+w/LFr4ysxWetHX5ZNlg4CJ5Sqe2GasgyXs2kwIrC+6O3Jzzrxd/xmdrtTGbgzPnQIEIuuQ32H0S7LHoSM4mcJEwm7u3eP99dRMxKws77HD9Pq/X9FNlCNe9CUnn4hBeuU7zf8cP+Z4/bA9U9+FOzzRDN/JjPcVA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gVltrkgP3SUpnxwK0Dl6quVErCYTxfF/NgIue8qZBgYulDNdZdPUP9RVFQOs?=
 =?us-ascii?Q?cI50vg3QMR0Hs7v8qPzC1pHUvwQwI9IfwWP3UZhsLf09JdNJzlG6FhCLLOJk?=
 =?us-ascii?Q?dTAUpflq61YPmAQxtRTPyHs2CBmYtTQknzEGq8jQ4v4P0N/m0t+FMsII4406?=
 =?us-ascii?Q?WUbPqr0d8VHHJlPdXRAZdcyWdnGqO1H2o/LbiA0QYVIZnpZZ9B5lrXpAfHQ5?=
 =?us-ascii?Q?+STYWRrcDZEdiVoReoFRUkjQ0fA1fSnT9WXKIJbnzmQmxXgP8n99JKmQWVWO?=
 =?us-ascii?Q?5J4LzKM6/x4foozHYP2LzBouyEE/z3XQYfnLv+BY256dtxKraJiguQUjQ+1s?=
 =?us-ascii?Q?4a2BBu2fDpnltMKS5fF4s8mespI1ejp2i+Jb1UxuYtnD+F3pKzrQNvZa1+HU?=
 =?us-ascii?Q?Krlk9IYg7dNa7oO0JX50i46cZ/K5xCutHS4kRcGrXs3e+NHWDM17f4f4lzuI?=
 =?us-ascii?Q?25eZjVOoNtIOMt5gxiOV3Qr5EiK1U3jMPmh2wJN553terq57MBzBOJDSR7QV?=
 =?us-ascii?Q?hTWcHMDDqsfHHKlpRvpZZCP6txmeGvakR5QH0WWgJDMNhYOLy5aC2sWOfAcY?=
 =?us-ascii?Q?ih2Y6FOXTP+6oVbTa6UyckI6PuvqoQgjfMUUNpk6zKvSXEhVjDaon5amCByT?=
 =?us-ascii?Q?Yi39vrI4darAHJo/vuXJc92DFIwFNG/X9TBjzzt+M1QPDTHdYMkcpyFjbthY?=
 =?us-ascii?Q?+Bhu6LEW+vrPG9H/B7V1fdU7hcSxq0XbWzop5ptrZNhuwLB1/WBCAZweme0M?=
 =?us-ascii?Q?WRyzKuCOwaoU73HzCu9uTIUZ5I4HStMvGpbMsO2zqpcjxY8T05a1OypWC11+?=
 =?us-ascii?Q?GtCOHE7pcYKSWitDIIKjUvLUwXD+SECYJrEryvyAx+HwZzHJaV3DP+MMTUMQ?=
 =?us-ascii?Q?Yu8r5kIigSft14tXkDf7IPpEKyxLr7/m/+nbh4HkBdVBE/HKcVzPcaqZaI3i?=
 =?us-ascii?Q?8I3pkeMzt6hx0wIemGdaaHhCQGnVrGtcNom4NJ90wZBDT3XvCfe5A1Nq/kzI?=
 =?us-ascii?Q?rOi5VUuphhFfOz5d1Iyii3ZU/rj6843qr0D6T6K7SkL0NeRtg0XOyim1MIi1?=
 =?us-ascii?Q?Zy36LYBwmepcwAn1eLff3pTzXkxyEBD9RaC8m1aGgRTZ2+3nlhSgPVzdAvT1?=
 =?us-ascii?Q?BEtijCCfkjIrdiVWdVxPmxHyM59lHhUF6lQl95GjXZ8O8aDVHRM0P4UaokhR?=
 =?us-ascii?Q?X0HNEhCkSpnbUl0m8avZcLHL5GKjKVeebE6qNoMt3d6m1xCLvH/+YRVTvX8h?=
 =?us-ascii?Q?wVG0D7AEGTQlGdQzUwOpY+LwGBGxKx7AMCPdGZf3Kg3GHbqIqcehpMwPlwXN?=
 =?us-ascii?Q?7dyQGB2yuw5NN25Kh5okye6tuGSy1B30SGmu+Stttz8s/xZnfeMALR/d0YHF?=
 =?us-ascii?Q?fo5bpQq0twDK1lNbyHQfzFRjUvMK6Sm8sRYGyp8hq8tZQt+jjCOJh1AiXDQD?=
 =?us-ascii?Q?27nlUmWMacNJ09cFCRza9TO0H38JupDwN+xzZ7OUhxo3Wy6CWQzaouPyOps0?=
 =?us-ascii?Q?4w9wj760vg/NUcxDF1b899Wyr3fPoj9sUSv12fU5V0ChXGomSi8BQ1EXzqlz?=
 =?us-ascii?Q?/r1hyU+dW425sP59BzQYLetfDK9uVOBKkjGJ2ud4Gy02pqwytjH1i06ZF4qw?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28eb0b0-2420-4744-d338-08dab71b7925
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:45.3054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGVS86ru9io3qoxodOyRCb82TxGTjODDIvJyxcwpn25+sMFiw7YWfwKsxxpFwmPdsRoHagf8WbQJNx1oKFWqUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260036
X-Proofpoint-GUID: kHkvfJDNC2YOKmfAA5dqdZ_pPH9F3pYR
X-Proofpoint-ORIG-GUID: kHkvfJDNC2YOKmfAA5dqdZ_pPH9F3pYR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 17bb60b74124e9491d593e2601e3afe14daa2f57 upstream.

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_stats.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 113883c4f202..f70f1255220b 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -57,13 +57,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	/* Loop over all stats groups */
 
 	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += snprintf(buf + len, PATH_MAX - len, "%s",
+		len += scnprintf(buf + len, PATH_MAX - len, "%s",
 				xstats[i].desc);
 		/* inner loop does each group */
 		for (; j < xstats[i].endpoint; j++)
-			len += snprintf(buf + len, PATH_MAX - len, " %u",
+			len += scnprintf(buf + len, PATH_MAX - len, " %u",
 					counter_val(stats, j));
-		len += snprintf(buf + len, PATH_MAX - len, "\n");
+		len += scnprintf(buf + len, PATH_MAX - len, "\n");
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
@@ -72,9 +72,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 	}
 
-	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	len += snprintf(buf + len, PATH_MAX-len, "debug %u\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
 #else
-- 
2.35.1

