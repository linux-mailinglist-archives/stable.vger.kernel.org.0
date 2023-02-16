Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC85698D8D
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBPHES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBPHEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:04:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9365525958;
        Wed, 15 Feb 2023 23:04:14 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2JorC013084;
        Thu, 16 Feb 2023 05:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hVgIGEf0NIPn+bR5gCQrF+AkUkuZRGpGIZxsvY+XcgY=;
 b=Azt1NqvFBDu6NLIWUMAKhsBsuzmVEg9RkoBtC9UKz3XnRFJQGzyU+y5/X5nUQw5wOXvw
 xSl49fvBUUmwqTDh6GKtEFYMyQMftWstbJBCvoVpUBVzOWbwqsZurV0w0DFA/9scvVo2
 23O7oBJijgfFgGjV5DjPdeejP7C4KZG44BYaWdvBYb1HqRwxNfa1mrueAKWUJWOADVDG
 XM1Z4PU1MYKiQtTdhjYz5xom111VDM8YOUsMR52y450qYtpLLJ77mJyaXpBpc2Ebm2Hr
 kHE7Po/owU0WbcylhNx0/joXQ08QhB/IfzvzEMXQzG4kAYEcjUXB1K9z8p3GYs4lQAOk xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xba7yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G4s434013558;
        Thu, 16 Feb 2023 05:20:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f7u1hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTxFr2sDmf/CRtalMA4+Ka5obCiWVMjjxkoSRcgNeZxDg9Z+FVckMtl2dg/jX8XK7r8UA0yHQg/EdVooq108GqYzk3+3VLSQoV7GEfztQuDBU70ulASXXw9CVGpFdTzvg3JtnjJOVqu/7RVJv26WDJcWwoE08lzkwZBFj3/nkhzsMzKibyf6PBkC9tGSjnN6tKpMQpneYiDonUu3LfRcNHkoAecwsWQpQ71GiIP25cqaJPGFLYKU7tvCq3L4JAtw7duguLngQbYOWRxEug1vhETgwPLeF1oCNkk/XunObPTIVORo0oo9KMs0TL10hse/eOz2u0hpjMf+sKSCW6inRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVgIGEf0NIPn+bR5gCQrF+AkUkuZRGpGIZxsvY+XcgY=;
 b=MWOJUYmuj2kI+ldhCn/4r6A4v2UPTQgcEobi0dNm0XcRGTswDifK3Rz9wLQch2m+XXweiGN08rY6LcTi9yTMgbn//C4oZCTn70giYlmyPAyFgwI912sHQdTnUEUlnmiA3alNYtI/RMjaa9nmtBBQeHGWHg1EoeNcEyshlpxyYtiWXE07QcahuB5AZFMzntYbblINVl8fUZy4CIC/LG5w1T00J4Ic0ZnI56h6dpM+H9pvy5EnrDu1KKXvfc4MWd4c7a5wjpbPQE9eIl8lsZYFOHky24QqhDs1T3yAMw/bSLa2ZgA/IO/gKLJ3gpGUdMeZZo/Np8x8qnsjk7jN0tUP4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVgIGEf0NIPn+bR5gCQrF+AkUkuZRGpGIZxsvY+XcgY=;
 b=HzQGLnK9u8qQ7485YBtRYNPhEG/26cEpPezY1lGY2FI/VT+N09Q0n8/aLFxMCMx8W43GA/xmjdxYZhgkQdUpVwhCVe0kMRxMtP0F+b7hnUliA1/Nm6u60azeZ86by7NbVtPkH4m3ZB0Riyk+XqfHIuqL/Ab29/g1OeVNafRC9Jo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:20:34 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:20:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 01/25] xfs: remove the xfs_efi_log_item_t typedef
Date:   Thu, 16 Feb 2023 10:49:55 +0530
Message-Id: <20230216052019.368896-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0137.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: f6adc804-7985-4df4-e0b6-08db0fdd87ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4Z0T6NL5U7H4ksImcVIG3C3FZkCTpDgGnNyQylW+ttQ74ZyMslOscYmGXjbOAJFRzFkuEklzXYUJUQxSvI2FSWCYW0ITGN4i9MDUtKohXjCr43Xa0irAvHTEA8Kicvy64EWDJuvI7S9sbrhtKLdpkqTkchQ0XXwSumYfQTHTyEC10WGZg+S5SwXlIujmpAdKT4L2XLc4chMHY8WVp+n8zPC9ThodhXWiJzpY8WXxJsxx3hNWytu95Szu+XSOE4zZIPNvPumYBQsEQKS2oj2Yk9OHBPfVoUexcWPi1f28R8nwISNkP34GpfI3/yMir31ukSi53Ui7hmAw5cdL0Q1HB3pVn7SIsfkkg1nxcjK2ZoZbCdbbiqa0iQE/U1UxZAIVdg3OOz3BzysFRfjkFxeKUVGKK0qqyYmnKRFP2BSGr1xe9t8D56qy/j6pm19V6Db02mVg4eSHIU4N70ngsCUsZgYssUcrTlf4m5jz8qF1ysuEgUhbi4bHs1F7GR6KZeZHW8z4wab6rq7OwHfvvpOa6sKb+6gX8dh2Pm2Zc+ik6ZS9doWquoh0cC9gV5i8VDErEd/RjC0rt162jqtg+/edoqG94+JBDnkXdzKyHdzE4cE1Oj10WCKPxByKr/JBgvckyLKClfnoGFlr2DTclbeWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5UTI8q4GokDPz1jjYQdFBECyFep0nt9GFEp+9tazVEowxVTZS5J9j40YnsF8?=
 =?us-ascii?Q?mh7inf+kvdLPs+OYiSoEUeimxdGfDxQCiGFT2ujonWbwnJ5lAy0KskvSHAqN?=
 =?us-ascii?Q?7BOH5zKv7Pyo1F1LLITNiB6zM4qCNcvYJxm0juZ6kD0ziUPoBilUDa5SqevN?=
 =?us-ascii?Q?d2gTgxi1hYvJjhdABGgUincb0ZWxbIVHx355uAtEh1xd2lxi5DPcSHbKiBrU?=
 =?us-ascii?Q?nupVI05PaiWlostO9BnoRsOGq+2YQzxNz50AVCU0zycUsQBg+O8w4LVogPDs?=
 =?us-ascii?Q?VP47Htk858/Gw3VdMgRkorLubCGOqnFrYErUAST4f/mBi++liLtcFR4GtSMV?=
 =?us-ascii?Q?KeI5GiOCd0EOX8ms+qoc35N7PsPV8cb9mUU1C56eHsruIR59St6JFMyccELg?=
 =?us-ascii?Q?EzgHw3NlHNvoxzdivOep32yvBD+pW6lbjOcZ5JMn4braf8Cf5P3LMDktVQHu?=
 =?us-ascii?Q?bQiRk2zHPfjSL4J+fzE93zotteeA2/SmTZ/e9EaMvTH391xGVNz1XLyeFzv7?=
 =?us-ascii?Q?M3FFYPXhiWKK+cmDQSe5kpWfbd0cRkKp++QyvH1glk8usf4CFOMZqTtatSKV?=
 =?us-ascii?Q?IXAK36FJPuHK3KCMaAij1LhXg/aImnopF8kjsx9Y06dFS1F2LorpljHwi59s?=
 =?us-ascii?Q?wRkEIa3YoaK/2t4MaT+J02MxfsheFuVtd8JJoQdvJYa8LexO9RnrGcCaIcGA?=
 =?us-ascii?Q?jUx87aNRkoPj4qj8YqBePVChLnc4bb1syDDBAgp7yxsCN/8nEDbjz+M+e5lt?=
 =?us-ascii?Q?cQBm7tDQpxqm46oNt3zrnTqmVFehfcNGU0YpWMWlz5QHx3JqIv0dtnGdFtJK?=
 =?us-ascii?Q?kuUZc9DfKlkkr3eIeWLR0sLnRk9/wR32vvj1KT6iO3DaRsWoVh0pnUPJyIiJ?=
 =?us-ascii?Q?9QmuP5H49MArRxwjzMLGPSZtDkJE4Fi0OeALWt9A/NAr3QaKXWGmFxNoREtY?=
 =?us-ascii?Q?Tlp/m7PTRCRmskx/M3dpmEj8YmgRqx5iybTdjnGX+/JbNUeG8sil9WDWyKml?=
 =?us-ascii?Q?KyViKH34yh5SedF89SImYspabpJaNYjeX5Yc6V6wPhrQ2VbAvVRweiM2d6wP?=
 =?us-ascii?Q?zXR47am+F5TUjaGSMpDQhZBpvjvxqbQkrxJ4lWwgOrohTkrrKB+wF0uyFcCh?=
 =?us-ascii?Q?towEm3WZxnYhw0q4YY44nEf6isX7uxQTa8IX/OawcZ9bM0b93C3EHcBC9HGC?=
 =?us-ascii?Q?sXY3PbFpQWossSstnPWUimm6fDxE9ZsG0u0A7bC+5/QzBlZq39v/lUk08eF4?=
 =?us-ascii?Q?YpfT2A+d+xw5WaKcUDLN09QCsb3tCeqDtCVXuVZCCDbruKB+Iemn7pUQxp87?=
 =?us-ascii?Q?Lx09Or3cON2hE6nQ5lZ2MnKQWTAf+FX0KDAd40y2ckQnINe2XQndA3hMurlz?=
 =?us-ascii?Q?GtH7HKyYflOZ2aHL2Wt81gaopg8SFF3AaGclMbsIC8d7k49G9oyzU3hUQEQu?=
 =?us-ascii?Q?DPxVgbkHyCih+jVlflSYTgH/G7woqWb1T/FIIJ4nOp2j/5ep6jjuZzlZZlcR?=
 =?us-ascii?Q?JNIulIVbqdmOfkIsg4nRpygioEV06bSwAQz5ZEtBS2FEWgCtesjyf2FOlj5/?=
 =?us-ascii?Q?lcRrg2kE99/n89U+BEr1tkdxOQwd3zpMo+xCqmFS6E4h818dG5pIFX82LEeU?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +7g5V3NSLVWmVd4qZgya/O3aSvQwnD3BJUkdXlISMdgHyL8ESEyt/+1oqTPeFnIWPa79BPtWbcqY3DIeLNpL60/KcIlLDprLHEqNtEGNjTiniIY93h2ldGMaTvO0xyP2uwljHGJz4Q5dX3eDXMTvcOLOJ0exoi7WnblGox0P6/M5MKp5wl8+Q3FsRWsDgEhLPWK6qgXBBGoqtkbca2DAgC3hAW2u/JFI4OJbspKVstG47q6/hXpxtaRpmo+hJ5nN/hB1W6G/2AExdCMPu35/T1Q4OWrLz+F46U8+EhhXROiWSpN7G8pVOTItJKx1SsLJ3Z26yaFWVBs8D3IKWYtp+VmnbxbeD1twWbgodOLsGqdbL/o9I5YPS80g1ONIhnjXOxoJQc2VcM5v5wUM/XhjjykU5GFXcbSDtnv27cZs+8jIn3aw8Dy+rxppqEbvYTHShZTy0MjBqcwic2aLpbM6d1h3AmQ+tJzOo/3zpkRMbbnrDrQNszjES/QG5DW1mjVzclVftBe0WLF+bEjTYzroTcuYibJGQrh8L0qr1Uui1/6SWVFHIsv731j1xG9VypLys0vmDkQ/clnhQk6rf8UQXbE3E8+/Xv1NhGsYpUJrXwyhBAt1B6soR+YK2ZMDSn7wft5xH9/AR7ltt4SPp32F0AUKzdTObvkQruUrsAXL3iBw4mISlyYK7aQQQRIfUlK2kMQw4iSkbyn7xQVBylG5SeXAUUhbINbk731QtZUd42AjYbivIQibFfyZKWMc1xV3vzoWz2Wq3TvPMOjT8HEUTa3UyI7KmBG4QR9ImQY+uk9Ehq3Fb6erd1MeC1W5zJmuQlpsUCCiyfF7wxvQgXXV/xkJfhF29ZVGfAQ3k7b0vsZw8kWHoXdvGYe5I560bN+E
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6adc804-7985-4df4-e0b6-08db0fdd87ce
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:20:34.5927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EqTqxmRDOA0H3eocgtxtIWtUj4bvbhLeDepILOpgjy7quT34cQAqYdp7p6l6qjWlKU9PUn10vrKZwzZaQtrsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: 3LmhG5geKoR_F7hPcnX30Av7c8jYH6a4
X-Proofpoint-GUID: 3LmhG5geKoR_F7hPcnX30Av7c8jYH6a4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 82ff450b2d936d778361a1de43eb078cc043c7fe upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |  2 +-
 fs/xfs/xfs_extfree_item.h | 10 +++++-----
 fs/xfs/xfs_log_recover.c  |  4 ++--
 fs/xfs/xfs_super.c        |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a05a1074e8f8..d3ee862086fb 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -161,7 +161,7 @@ xfs_efi_init(
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efi_log_item_t) +
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
 		efip = kmem_zalloc(size, 0);
 	} else {
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 16aaab06d4ec..b9b567f35575 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -50,13 +50,13 @@ struct kmem_zone;
  * of commit failure or log I/O errors. Note that the EFD is not inserted in the
  * AIL, so at this point both the EFI and EFD are freed.
  */
-typedef struct xfs_efi_log_item {
+struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
-} xfs_efi_log_item_t;
+};
 
 /*
  * This is the "extent free done" log item.  It is used to log
@@ -65,7 +65,7 @@ typedef struct xfs_efi_log_item {
  */
 typedef struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
-	xfs_efi_log_item_t	*efd_efip;
+	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
 } xfs_efd_log_item_t;
@@ -78,10 +78,10 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
+struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
+void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
 int			xfs_efi_recover(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 46b1e255f55f..cffa9b695de8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3384,7 +3384,7 @@ xlog_recover_efd_pass2(
 	struct xlog_recover_item	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
-	xfs_efi_log_item_t	*efip = NULL;
+	struct xfs_efi_log_item	*efip = NULL;
 	struct xfs_log_item	*lip;
 	uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
@@ -3405,7 +3405,7 @@ xlog_recover_efd_pass2(
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
-			efip = (xfs_efi_log_item_t *)lip;
+			efip = (struct xfs_efi_log_item *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
 				/*
 				 * Drop the EFD reference to the EFI. This
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f1407900aeef..b86612699a15 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1920,7 +1920,7 @@ xfs_init_zones(void)
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;
 
-	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
+	xfs_efi_zone = kmem_zone_init((sizeof(struct xfs_efi_log_item) +
 			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
 				sizeof(xfs_extent_t))), "xfs_efi_item");
 	if (!xfs_efi_zone)
-- 
2.35.1

