Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A016DA145
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDFTbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 15:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjDFTbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 15:31:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432886E82;
        Thu,  6 Apr 2023 12:31:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 336F8xda008739;
        Thu, 6 Apr 2023 19:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=faB1OeiSlZHGm+WIgsaMSHUGp6MH1xdRoONHTlLRqcc=;
 b=TWOTATWKf1RmRnvJDzMtzzwdTw2HYgOEAzqvYj7WBizI5cyOZmWaMHyg92bkQootgoHj
 AQxJ00S763yPEa00QueIE3WBoHyhuhEMSlCveTSxFoMTpp0HyfAiRgI7QaAwdq5J6WXS
 KrVKsS/mR449LZ86TmmYQQbZCU6A3j9n4Ak4G008QZiAXdZZKhaeAgBD4ORfyP7Iah6V
 u+cdeNxuGKNSZhoeyw1UC2VANHThKLVvF8H0UVPLxoQ9oiTP8Hbk4PjQxCSBNN1qR9/q
 mDSPmHVOB7WX5Vd5JnWIUKif0l9R6mXUG1mYaYeM0DtnWPV/6hhatqILJquyNEHaFyyf /Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppd5ukssr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Apr 2023 19:30:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 336IjIsp027428;
        Thu, 6 Apr 2023 19:30:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptutg670-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Apr 2023 19:30:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=graUOE/vffFyosu1hxS6gmKfu0wGm93mtHJalxQpig7USL0SR5WOlZEiGzh+iNGriheOnZUG+b9vHo+DSGT1kq3OYJbeyv4LYmfZ+vTp2YiYoiXCerr8805DT/vzU3kYBNJhXTGM5WYcv8buUf/x9bMOGSAaBt2XvHeLCzAf9FNlzWbMj+OzXVUnx/kmLdfzP3HZlaBGH457pZETHSVq0mQt4VrOYM9mkORqHTsJfkF31o+6NMm4fJAmUGPHpAX75mwkrICHJYhKEJIOFPFZ3LwlsQnr8M+9kO867d8WJX8d56UtTKrOYOtttfygWEnQqxSd86YtMr7Bt5fWPNYjvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faB1OeiSlZHGm+WIgsaMSHUGp6MH1xdRoONHTlLRqcc=;
 b=D9NJITdg5MUPtJWs8ckQidmmc7cvI4E4g+L/TSg4PphCq5gIyePq08Fzmy2zE5ipWpEq3re4NkNSQJJ3HcV903DffKRpCOzcRUdzdoZmVc6bJtVdoqZSF93RqvKR82NvajApVv6GHCsGXN/M12jpbwiTnM7BAC1B5sMyC3qPBS7Oy90LnZ1Cd4P9ccsbg+yuKTfdvesBaNQHNYYsSgfW+rD7trlABZU49tiD3lFes+5OI1bcNGhLKLMj1ZeyF6Sm2AJutlz4iBWWZo2Lnnfuqal4gifOrT8bZN8ot/ZDgwF70aM3Hq27DFU0fR2GpKqOt/sPOlwYVsALYzD1xA5V2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faB1OeiSlZHGm+WIgsaMSHUGp6MH1xdRoONHTlLRqcc=;
 b=d0zjt+Xo47lwhaUyiC8a3ChB7dijE/N41eN4IRbyTeOxVWmkEGLJQYZKt0J1QuOhrbsX/+NqxHBxsH7Yz4OCanhcP9AADk3Id+tloVTZc6J29qmWcvm9bEoh2/jrlYvs6Gdbt2171JJgG9U7O0u5/zdhTWO+0ZopWTmJF/K91Bk=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB7053.namprd10.prod.outlook.com (2603:10b6:510:270::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 19:30:54 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 19:30:53 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] mm/mprotect: Fix do_mprotect_pkey() return on error
Date:   Thu,  6 Apr 2023 15:30:50 -0400
Message-Id: <20230406193050.1363476-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::29) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB7053:EE_
X-MS-Office365-Filtering-Correlation-Id: e7809d34-28fb-4f88-fb4d-08db36d56fe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kA6tgqEHwS9G6NTqMbX8QuhS80r+SwUONn5D3BjeERVZy7YiR0440cpqvx4SyKDXxBf245MctkzJVpCU0WIXTDyay4TBSJcwobQSh878qcSM0gvtc6ZWBKAP7f02a9x+FMEq7DGAlHdQaXf4Rd8SwMCMH/otTwNFNtMBx7rSWgFfadLlclM3iGgx5Dru46mEXe2IpV3Xyz9QaCtuHLwVYrfVU3acUBJkjPK+oybLmQic+CKE9DiGXCvluccqoBB/DIRbuHVl4ql/jgpmX08O6ZLSxXfIDMZHAQZiP8wv4oOnH6HJTAKj7GtRzXUEqYwW0FETJnfXLzOLjetuI/8Dt1xkfnGOb3lFJ2+mEBL3e5cVmybgbQppigryqG1+pqJi5lX9X+dWQtPKe/PSrY5Y5PSc3pD+sSCBuY8yeyWgmp7Pjh1fxohbUWI2phaXsqc27APlTOTpEt0CnxqAMDBkRsKC1ujBbeRVDJDeMFppJvRH8IYEgdeGRnpxDVOfn462H5unxPbaJmRX+69tBLS6wjfxNBhO0qyu4pHT2welAlYOD8qALgy6cK9NFASqHnSr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(38100700002)(5660300002)(4744005)(2906002)(66476007)(8676002)(36756003)(66556008)(8936002)(86362001)(41300700001)(66946007)(316002)(83380400001)(4326008)(2616005)(6512007)(1076003)(6506007)(186003)(26005)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HZdboiY0KX755BfDkZROBwnPDSUdgBCsr8xaCAtUHIhBcj0m5Rm0HbMdCAwz?=
 =?us-ascii?Q?Y76B8fOW/Tmz/vdnyuA9BsTvVG6YeOYab099i3uwTOER6kOHOX9yRvQQy1ZK?=
 =?us-ascii?Q?taLfV4FU5lTs8T1HlqFoJfqJwiqkgTO7XXycFjdoh4AsVwMl3RLnnQ9Wcbtd?=
 =?us-ascii?Q?WhJH/iLH2uUzn8aYrceoM0GIy1l5S/yIA/WVa2bloTZC4n6tAXFHUTZUcBuB?=
 =?us-ascii?Q?Y1dqNohkpbvstGjo0R5/udW9/yVqPAGksNGRHkLPscW1HQn90FBFu2DOFSVo?=
 =?us-ascii?Q?0pErKjx8MIZW0qGaD3MH9YS3BHGxBSjCslLcetRpiUXjZsFPT2D0M+TJTQlu?=
 =?us-ascii?Q?2teg9a+ej2KIDM8Sxd+EA34/qDbf9FfSpfU7tfM8hd9nB8ezzliJr3qhrp4N?=
 =?us-ascii?Q?6coJIohBEtzJEFPUv/55SkmOrgYctCXcWd3tO0GhqilcY+Au7gBc1x5vFkjI?=
 =?us-ascii?Q?iAqgxMMSMGGxjx26K6aIXeCkmVlDa6dffoq3B4Q6L95Lft2MdtnBAUr7oSQt?=
 =?us-ascii?Q?agcsRgCr0ivfeAn4xaXvcfXZvw0Y3gg02R6jzrLLNUqC20vifU3Aq3fHcLhy?=
 =?us-ascii?Q?JGJEMM/ue2LR2NU5PZZozdmZeHb8UxpPWlcMOE/DHTBECg4mLDFNBXoQU/gU?=
 =?us-ascii?Q?NzDicp75GD0zitVzzwxv9JoGnpxFHMsfx+ekC9iPak89ihS7VUfD//AZBt/z?=
 =?us-ascii?Q?/togITrCBBIqx/9nM3SQuDsm+5o1CladbCqo5frPkcj4nm2InSPAkoHYj03f?=
 =?us-ascii?Q?5wh3oesdkyZKj483Rq14uHB9fSe2zu/pWh1e3ZC7UPrfo7mxAY+PLdJCJMhF?=
 =?us-ascii?Q?qdpPsneUvgOtV/ehpo6v/9Z4DRaR0Y6AI0tgbAEkcZKmuoGDqTi4mmVOZIsS?=
 =?us-ascii?Q?cqllv7/PeZsYV+BsnDsofnZYKZ5MC0WkKWBGBDdcAJZ/r62dzul/uRXZhg//?=
 =?us-ascii?Q?xI5lzsCh5pphMYs+3l6FcmE7js7m5Wlmckhsjp91nq59rDqR/QEJFt/6bUZB?=
 =?us-ascii?Q?sLP977dmX9/qxnBDUJhlSFRQmeO21dGp8raznpC9KBPvlFoUbYqlHCtMx6Nr?=
 =?us-ascii?Q?J1XyBx024SZNBq6zSJdP1KkSoouUNiLdXr+smJHHR91790j+lQlRspgHvcJE?=
 =?us-ascii?Q?QE7w3AF28qH7td/ZDG5wj6dH5w0Xb9Lf9wtyig5b4Ji7NqjHbawpK29wQH3X?=
 =?us-ascii?Q?cfK+PeY9Isljdx5AInJJHEw+w0DUMyWMrLzlqukaT7RfsRZMvfpxRfpkA0Ky?=
 =?us-ascii?Q?tGJvZyFEKZGs5NBxTX9A/DDHKIx7pMZXy6h3Q7B2r0AROGMfhmzAxirQaHyg?=
 =?us-ascii?Q?n2R+y4y/0lOdNAmR4VTVW6rJY+ZL0FnipO7b7DL2cFLkBymOcQarLQdyUDZr?=
 =?us-ascii?Q?zXslHrjHEcY1M3CQej2qQQv+RrGnnc+snaAvnwCapzGhxGZL/aXj4DyRRcHX?=
 =?us-ascii?Q?Ey2nTHwnRewgeKjV7WvaQfF1XUwNFBenSsxAvAvAbE4f3GPq6NX+L2ySLVGS?=
 =?us-ascii?Q?QkZdSZt8TaeKTKFCQdzAkZvM6UE8ipDlTdLnbt/Qvfh8OobhFKOKVnwYa6uf?=
 =?us-ascii?Q?7aZeyUn7P3zgxJQqn9gSlb87r+vnzHuV4nGAhAZtEzJgcQETh4m8WW3FjLx+?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: luspfuYmu1LSoOZ5MTFMZgsgYUtjVSwFW/P91zBDxQc0uOmrvd56SkvMdRSlWESve4aSAApyZgbie1hLWaErqY1Sq7TbyR4epKIIIUTWMej35pw+9Dy5nJsHIkveH0TyM6Pw2EgqdMDdJRnmpBUe1AOdOLrSA/7qP3BAiKdJV4kQ7o8gtsWNPtro0j9W+LZYwK+9Wq6DGuZdec/h/yrTeELBkBQ3+kKzN2FYQbiqJjoXkXD6aju2zaISaolEKaxQZkmjPSvpukR4T6B3qbdU0dmRzqYrTgtElzk1WX8fVvOFvZnq2sI3MH3IhjsRSHGIeURDZ5IpWa0dwKevLoAsGv4pe9CKl3upw7uw0rw01cXxVvsONxy3QORJU1NtG3i8bc83sOBJ/kNCPH/ilzs0RTGiX+NPbqPioXGo1URis+OM28k3t0syc9D5N7QmmrRSkAB+GQQvwyfOWbXxLjdLg75bSXTRYLy04t6L3g+4fMd3jAi1DJB2fK4EcUWs7Qe8RSD1+u7FQWjOZsEf97suGrevHEtSFF9VIqMivDqhlUFMkaf+A8w7x9jRbxZSbPNPgVRuM7tZIZdRGzwzABHmvTPhQpkn4cuhoubFZ/0fAfz07L/Zt7tBNyht8ILw3BBGCNBvYo8shLPq+eizZN09qx8p+v3LHykKdoiS2jn+sylSSPmNZPDNwZEmbemJJ00m4aH8bHU3zDbBUcEzz3CfO62b0iNDqmROP1y/0FWApz9ji76YJmSjzXKZpQsrg9BZ6k/AX9J0zmXTyW+chuZTbV//c0Mtr8vhWfKjkvz/9hrPUgqGGf6Tal1oO++fV6EuwcVOiavMQYSm/JuOdMvwEQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7809d34-28fb-4f88-fb4d-08db36d56fe5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 19:30:53.8511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uyzy/mBV+ytd4d6RChpFzQRBuNfxV0/Vj0xehjEPiW1dax5DfECdL20xMSBGTmv4gOvfmc6Ow53FbB7SXGqBPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7053
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_11,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304060172
X-Proofpoint-ORIG-GUID: NlOOFDXE8yEySdL3Ho6RcEnjUkqgemnC
X-Proofpoint-GUID: NlOOFDXE8yEySdL3Ho6RcEnjUkqgemnC
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the loop over the VMA is terminated early due to an error, the
return code could be overwritten with ENOMEM.  Fix the return code by
only setting the error on early loop termination when the error is not
set.

Fixes: 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mprotect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 13e84d8c0797..36351a00c0e8 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -838,7 +838,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 	}
 	tlb_finish_mmu(&tlb);
 
-	if (vma_iter_end(&vmi) < end)
+	if (!error && vma_iter_end(&vmi) < end)
 		error = -ENOMEM;
 
 out:
-- 
2.39.2

