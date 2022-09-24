Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2878D5E8CC9
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIXM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiIXM5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F103310C7BA;
        Sat, 24 Sep 2022 05:57:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3wqHq003741;
        Sat, 24 Sep 2022 12:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=t6zN8lVUcgIC1obRfKqOihaMOpQBdbP5l0hIdOAn7D0=;
 b=dcvRdkEFSsdCSJP2u7kracHYH3JvZMMeytT0ghlf6M9ThR0VTO6avGlOEF4oJSfa7ckn
 cd/Exrk34zUxMXKVShtfZa6VSH9L3s6j3Fv3qx4j4NJG3EW4mkU7/3OYHPPDCHTOHfeG
 yz7jyrNuJ0IGV+8Qf64gmCGzlvOowwCmf18zgIki07vfBSWVUQR+lU23FCYndWtQwcUB
 JmbbdPsS9hcfbDRK8cpxt3TVlKAKtx1fqEjwCxcnJ62kLpesKscLZEmVioi1Mv0yM8yB
 2YOHKCNejcIDcfSvzUjjxN6Sb/1jUY44vw5DRQ0OyBws/ULevpVjbdNILXCL+hZiKzpd tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstesrfv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCtw6q020261;
        Sat, 24 Sep 2022 12:57:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb7h83d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cL6EOruaykprYqk+WWQB8OV2jZ2ZOqdIV+6OBp8gFEjeMLrXZDoQq+ymtKvR69f6GHxMQW/OSlprvLSaIoenRkDofgyK5YIhLINk0+qWUrlx85I7rtYFAMJT6yQnjakcrolLCMUdyyu8q8ODWQcnQTNgZmgRsbcMCSHkEaaZRaMPuxH6yqFumfUiga/C/yxiBHDUHFnv85eZBGcDTlm1/GQJaWCZMop3Nur3/U+RSBY1POu8XpOnTO8yJupM/t3qUhewUuqcwrZFV/qxyngN5j7S6xJf63K7u3JJNq6Y/EThzNOm8G0BJCREOQIyshgbkO6EgiRp2bf8d7jRIgNv0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6zN8lVUcgIC1obRfKqOihaMOpQBdbP5l0hIdOAn7D0=;
 b=jaEvOrutc0QK9mCzTESMYUQQcPoXKRT469ILhNCeUg9VvBHAiZ2cVt1N3RXehvf2vVbPb9hPRtTXMHfkPJu8tvHTxmfxYH2HP5xSPJi7Xq/Yn/EpkITYOm7rUy/QliXJnTR/6uGtmu8CVHgbav8ntKwZ6kgAmY59+FfLLQrj/4EbEHZmEFWwyOmmxMl70F8Tl0CrogOsorY51crCdf9D97Nmhob0zDBFyh4KHWxbsb+448gN9NfHOvAAt4WcCwEX6K76mpavkzejjIcD/mlakmJvhrTN8VNk5TXvcT7qyThgaAz0ozJf1lo78XQwRSZR2nPn7P0c7q+ZRgjHqYLIGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6zN8lVUcgIC1obRfKqOihaMOpQBdbP5l0hIdOAn7D0=;
 b=n0K+dN36E5vu5IG6RQTcs/SahJYa280wRvitoRcFJEBMgemvFGphnlbw+7uSeoJhs6ELXxqBUmUn4afVOeeSvanvUwBWwZ6ZBptUe1RXjHSIAPq1IUZ4bC0SoN/mScFE9E3lxxhSsHiWU2MJltsp+Tvy5J11bp2VUwHflUqn6ms=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 05/19] xfs: add missing assert in xfs_fsmap_owner_from_rmap
Date:   Sat, 24 Sep 2022 18:26:42 +0530
Message-Id: <20220924125656.101069-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:194::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 00280196-6bdc-4f3b-0e96-08da9e2c5b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eBUSBpNYIo4sLTfjGPLKtmrReujR5lwQO+GgyOe3ekyfwBNcqORhb+B72bLAkOzmq3AgOfFj9a9B7De9pO6T6vbM35TsOg2CPp5KseqwoQ4UsLXj/lXb8BPXcH0j+IbwTN2RyaAFU5qz8Uk2QChGiiRBCiHuSMhmQQhQuX+AnbH6L1RjqWlBtKczVlkGRY/NNHstzYpvFvSy2GuIE5Yw9dr2yOBQgqTH/b/cYdeyOu5g3WnnwxpaF2IkLBp0/OqyDOnqZDYz4F5OYiRfLWL/cfIBv5dPnDSxOHJPfSGg+ChUDJrb8Ylvxn151W1RlBTThonpAUtzs65lRWUh4ahzhbZndmvYK0ePqMImcxmP74Tj0tvVDxxfAcLpc/q9MWyfNku99nnzuBDCsJlEWiTDseDWk9t7fwy7Wd8lEV4fM7E8RwRkWdprTPcoe75e6HZk3MQhiYMXpgNlePX2yuowkhxMfsy9YaIU8t/8cRZbzpjEIp4t6B/uzK014MCrvj1DVIwEztyXvE8eqW+VnMc+6oXLy6F1DhFFrF/RgQiDrPCTcQHomEiWOgJ7oHs3nqzi2YHhr3D5u7IdNeXbQvH/60VR6rPAj2EmFsfbMgcEkQoDr38PVS1I7iZe+SJPgG/AINQmLLZGgf5ZrWYB8tVfpDc34LI6MK8RMQTdOIRjelheh3ZPXjcAu83z/lia83N3SuB3RpUzGcHrU6XRHp4g1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(4744005)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qy8LSbshRYrf7nVVx4ZQBJhF0DgdnvSGiy1/5EIjpvB4gz1UyrXV6T50cUsB?=
 =?us-ascii?Q?D8S5PjCDdF7IP/gz+XOtcbcMVgFEx6Zlae43bCAo4ywK4RrCxDt8EwHHjwdZ?=
 =?us-ascii?Q?Kl+gMdA7rF/11IcJlF+iwJGUc2EII0gUTFYmGFwvEyb1CnjqdqBI8l5SlLbC?=
 =?us-ascii?Q?2ZN9cqyxwLrxq8rt+bP9n+SNP8Cjipi3aQts9v/FzpBwMcGon7i9S98zbcFD?=
 =?us-ascii?Q?P9+Jhui65LWYdf8ndRhy9e9dxUE+rTFN060NLyMVWiJ3nTgI+YlObnVD9EWa?=
 =?us-ascii?Q?7k5bQ0WUzz7UgjyrIyVt0II7PWxdyK0tpQyJ2zJ3IFjQH8MmdLJNg5WcxpjP?=
 =?us-ascii?Q?6lFf8L4WKuX2zwt/Qd+OPfZV1ZCa7tSKSD4X6ZvVS7TMGTsMpC+jkeeRCfMZ?=
 =?us-ascii?Q?NIrZxRrNsKQTiFIlBDcS1mMnn+8JZ3NTcS3Loa6Jp0FnhpToQMnSWHE/Tv9u?=
 =?us-ascii?Q?o4HAEVyWtC3DfpoBxsvLevKD1J93REcLZnP5ojdbojJSy9IS7wgHDOHqz0+J?=
 =?us-ascii?Q?lHJNQnPsUxst2sqoTcJ8CXHw7yamtVZEPKdSc3IF2VIXM+X/fwpi3a21IJlN?=
 =?us-ascii?Q?UI6ai+qzRowBE7ZLqYca5az2sclUX2XwTG/+7gMV0/gFtJwAq38UBRy7GWqg?=
 =?us-ascii?Q?eTOm3Wi5XTYl7sFrCIKqYY2s/nyPSnpDmQFibSZrV/BhnqWvf5O1YO7FxC44?=
 =?us-ascii?Q?gGRQRSyf/gmqo/4XcCveidkmaOAuJYlLTNuNbYunO7AixClrO9Xhqn54kHSm?=
 =?us-ascii?Q?njPpjNs0AefJ5jG380ZhxIvaRtHN3X/9d07D/yQe42nZMHuxFxi+WaogpsXA?=
 =?us-ascii?Q?CyGGk4vMikLBRKTBkFdohnuCGDoyCnKkPE/sryl/MZfXV9atJsC3J3pkiHR3?=
 =?us-ascii?Q?oCiXdz76/v8/IiNm+6KN8Brkp73Vs9tsmFi7xmEXwrsYD9AluaKYrdlbiyZG?=
 =?us-ascii?Q?lNskrCvIYptDM+alV71OMJrTfEAN1MhltNyWlsv11bftcdyUSkznxhzRXgbj?=
 =?us-ascii?Q?YybUAY1K7od+dNACrAIzo9gTZCYxaC6xGQ86pxqCHatLv8rAHzpjWebXRCJC?=
 =?us-ascii?Q?GVkyDKcnPFHyjiYn4f6L18ytprdUGkMAil8hAvO1WB3bhlo6phe62k5lSAKN?=
 =?us-ascii?Q?klhW+hJl1efzh3qXDXgTRmXueJW3T/rp7Cx2aSU0Fuwng6a9arQlkqXC1+fs?=
 =?us-ascii?Q?c5rOS3dpfn7Sy41WmkeTjPiQrMCrwvJ50lsHC6yJT13eRCuGBy/y4bz8kJ5p?=
 =?us-ascii?Q?4oy5KXhfGKghw/vxrhEGEYVsp/gVHRqiiSXh7Qqt0m4c0AlwRXfNfUcAMfeZ?=
 =?us-ascii?Q?6Mmn08dWcawjz7svP7RbCIEpeQD6FNujiO6qCBp23GjVMv9hzhj2a4kUIDES?=
 =?us-ascii?Q?EAQ/6UZkeg41Wx3A7K/NbP1Jq1GGnmdXOn7lTeo2Z7u42bPdSgueM0gL6eT5?=
 =?us-ascii?Q?iaP3u31sqPmOSCYGVNdXj0hBBP3HiSx0bhnoT7x438LxpG6krxdUXTn4APB5?=
 =?us-ascii?Q?gS4w7MytDubFnrNCHjHmAI4zqWaXhL4pQwE3RggKHoH42mbOsEn8FpxwydZB?=
 =?us-ascii?Q?toPfzEvPhKsxUmaZieyrkr3IMHdzYqkrXhksEl2B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00280196-6bdc-4f3b-0e96-08da9e2c5b37
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:37.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NJuGCL4QmfQAeASkUjlhHgBAvNUGu8nFSMiTNmCCLYwPRqVl4qIbsJ6nRmT575OOn8Q1EaV55YQ6/v/Y8+vmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240097
X-Proofpoint-GUID: Q27W-1sjKAVXtlXnXc3L6a9zWA-FQcQS
X-Proofpoint-ORIG-GUID: Q27W-1sjKAVXtlXnXc3L6a9zWA-FQcQS
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

commit 110f09cb705af8c53f2a457baf771d2935ed62d4 upstream.

The fsmap handler shouldn't fail silently if the rmap code ever feeds it
a special owner number that isn't known to the fsmap handler.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 01c0933a4d10..79e8af8f4669 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -146,6 +146,7 @@ xfs_fsmap_owner_from_rmap(
 		dest->fmr_owner = XFS_FMR_OWN_FREE;
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 	return 0;
-- 
2.35.1

