Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9211A5E8CDC
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiIXM6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiIXM6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E9E10F70A;
        Sat, 24 Sep 2022 05:58:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OChGN3000722;
        Sat, 24 Sep 2022 12:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lDCGlSrEe4rABsl8SlYb9zS9tBxVHKuP69nXhLZNREo=;
 b=e0IOReD6EOXI2nMq2r/9IyLWv0U41CnbJ8lN+zo6vH6GFS9vj2DoRaTr8hMEnFljm9vx
 MSuDKnfxXksAqY2mEuDO3Rkuh/JJNl5P0wQZHccFhuiJhVGjiGmA/utynnc9oN7mqXtV
 98/6JYkXbraWQPo/eYT/OxgzEIOsOOBfkHXBoe71Kjg1OQHmOXbmsRtiF1d/Fgp1yAdu
 rAw9/9cNnEtWQS/rbTj/rKXlixsX04kVLzU5RKazlmMyLMk8u5wEaSkxf/Tgf4VchXG5
 5zYOCpI+dbtxBmBqfDIGoap3RErw6XvsOu18p37/fmfDENwqksNsKCYQJmj1FwelPgPZ AA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrw8h3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCVkbl020147;
        Sat, 24 Sep 2022 12:58:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb7h8hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwCOOkNpQpV7eJ7ndt/4JxPGuMjMBTKaK/CoYN6sekD2xJoSZ7ouWWJfd7+7gpuIDuDVI5ZWSTrK0gKmMuyCR6kbyaXWb+AyrGageZz7leRWd6SR5IP5XokJUw+e3GZNpK3Uw9ojL8YuDFeL1+laXbB1j9g21FclriVppl32KtZor8k7w3NnXUhTJLnSi2bA6RTM1MP7VYdj5/PH2XNZoBcloltpLxDXs0Pw4LInrzh+Bxrde0bN+iepsPTMkdDEYng+xKL+8+ipVTxy/pMZN1pfiz+aYbDeT75/XFrLuFXUDJJoTDoWfUi6qsu8TrFDEEbxhG/LC540qm3mqsLkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDCGlSrEe4rABsl8SlYb9zS9tBxVHKuP69nXhLZNREo=;
 b=ao95btbXwX6ak1U9jxs62VIa03W9iOHfkSws52W5TWX3gXShyH6VmblIKKFmoaFBy0Cvayb07mEs2toSUw6bAE8pHLcWGUYdqL8/U8047DCmIG/95PUe8WKjI2DPzA4Zh0sMXBzzUB/dtyA8bhIvHHK2381yfJXbd2uDoncpjbScwtRwD8NGTSrIj2d2R/ZPDfEUbTnIJBwn7rbN3Qk6/lcdcTF0gEzNdQNGZc8MroOnPtrde9ST+9wNecG1as5Vi1APNDJV/LgFjRqvwekIHCHk0SHcPbi4TGAuSym4BVoHfnqbSbpdK7MKC1zyvAWbXESWDnUscITu3zmRSXMF2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDCGlSrEe4rABsl8SlYb9zS9tBxVHKuP69nXhLZNREo=;
 b=a/7z+2fWYx1aTQIVzrOJEbebZWwYfCh7GZRZQlSCythINhzlOqOnboHGXmiISYoas2WmjuFBzle/P/qnXTfj36+ibdrBU8W6p3AjUGFnL83UraEWkm+YIwujxdiuv9KSFUZ8H4pEQgjXabqVsD+vc94dnpGRglzlSzF5Lj1Z7rI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:58:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 14/19] xfs: use bitops interface for buf log item AIL flag check
Date:   Sat, 24 Sep 2022 18:26:51 +0530
Message-Id: <20220924125656.101069-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:404:e2::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a91d8c5-8d70-4cdd-9356-08da9e2c81d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auW0xXfZrubQiBXheLkUYSzRb3oTMfw4tF1Lq3Ij2CSCCFWy9xH5L5HcQfolaDGmVq017srK/2GDbJ//HobWBhRRVVI7vHPSGLFXYb8UvAw2aGiH29yNApmhB8M37YI/QKuvgqUYtxtPRk6fNBX0kDPAy69GhvbGDA58XEATBODKw3sOus67bK+Ij1G/2fXuklLvi2pd8C4s5MIumT3G9Mp6pv2de5lZOgKf0/kbNkWgUxvQjDrkQas+wW8211N74s2eqSoj2n/UrVA+W3cNevBYnm1w/INR7KvmDFn0lw66rXEUEURAl9bKNTrLqH5SX1tonptty/JzbE5l8OvrR4yr6roczLtzf3ueGZgXmBY4q70vY+nBX5PaDINDsWJpgutPhDpVUpmrOx268fDidNFtPTHkkzigxQyMj41qY06DPSx97iGkalJuCrLFmBxTXsjKCAyafaqd8uTO27xFdnV9oST4rvwE7AJi3qn4m8hSfDNZhD9dJlAWI3A6u8amgx+cMjJ46bLLyX2ilADBOW0EJLxPQakaj7fmwIdriu6wFfYsW2KFRQUdo1LMv7y/m3N/Cu7aY0cb8cugAACSNkQcWXUOr5QUzt+Fvb/B8bCSJDYbePPt8+AwzneKSmDr5h/3T7OBCb6q7/3zFxGW9s6P/BZUMFq0to/kckHc4PLE6enHcRHnOWyUetpJR5hzYQQSQbFjhH+05hD7ZlPL0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(6666004)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wn66LTYPfQHf2MZcbwftjGWNHVpiUW7tVfahetqKWi2Fl0zxvn8SpEIB6rBd?=
 =?us-ascii?Q?bLArcqguR0wIALZob9HBzje7XlDjxWMA88wvpeq1UI9ux0EYb+DzhUqiLldM?=
 =?us-ascii?Q?9qYVRVWLM4iIMBZi0SBf82D0ge4OoibHX/HRKPOZ6ctUAVjhboZep9TUjKT+?=
 =?us-ascii?Q?I+Bm1ZPsJjQ2/vkRZXUypya7vCh5yM//lwQOTdVMrJISQEY417xnqn6dvuB5?=
 =?us-ascii?Q?YOuJBIE5dCdAgtQmq+4kQL5ADLZ4VjJC/+sJ21XEAYNz7Zlj2UfcBfCKgBIU?=
 =?us-ascii?Q?E4HCMdTb70aWCstXT30JFuHa4BFuhB9xxVL5menAZV5A56muRwGbZIDKxpR3?=
 =?us-ascii?Q?mIRF/vjeJrYw1xqKNSKa0dTGZgkFkAbkQi9K90+mpUTKogkaxvGHN98vj9O+?=
 =?us-ascii?Q?D8u4pO8N/EFt2eV37r4Dp6R5fZZbffozkWWUVc+5lEd+OayOYwLjEZDDEi6s?=
 =?us-ascii?Q?fvkUxOsTIWmcPu9Kmp6/7TQyftUt6EWZmD1mIgcnGTUJB670RgCQwOkzXsGA?=
 =?us-ascii?Q?Q3h1FynELoozeVSARr7TiFRxFmQouvIENiMYK3qCfNipq0+dX23gOdWGG9SV?=
 =?us-ascii?Q?m1aPQQ8jH0vj2o6lQK+gY3CDKpbadEAFmK7PEieiB6MQQPDXV0Sp/olYsJt4?=
 =?us-ascii?Q?9I1CIVERcivR99URiWStQL8HNAib1xG3xcLPy+kybKfcir9Zk/HmZaVuILiK?=
 =?us-ascii?Q?99kxnLg0JFPpMEZNhyAmfu52hGgZRuFdaofJge+qsjONHKq+KPd+YSN9cYG1?=
 =?us-ascii?Q?HlYIxQLrj6CYLLOU0a1Exr5isn50PokashQ1VBdzFTy3nxW9y3Qbru2bfoo1?=
 =?us-ascii?Q?KmuRN9DdDueL12VydiFSl+ZcIDRUY4z3kNILfGPCmVlIgr/4vUYvROxf2+kD?=
 =?us-ascii?Q?cfFjH1nib/nO5FZXLEm96ZQCLDb9ArDvMMUEAVr/ycVA+ZyDgTonugQNzTXR?=
 =?us-ascii?Q?FW4YSeRzQzg6fWESMXbbL5Mbb/8cWDjUKg/E4gWmQblu9au35r3L5kalu+XY?=
 =?us-ascii?Q?bWhbyBK6WMqeX+ZAC4uLz6dtIRQDa+ewIK3Y54Zk0jysXATvo2t6L3ZiUlWK?=
 =?us-ascii?Q?iyxNE67+DNsoe/XRvnENGPcFvLarSm/pztNw2f1h4KtQD+5DSRI6YJ2erUNm?=
 =?us-ascii?Q?ttr0OVsr3Y8WgwmrETAlfiCRQUugsfkkJEZcRVZcHUsl5wb6HPfhWwXW7OxA?=
 =?us-ascii?Q?7RQeox9QQOJakqrYL72zCsV3xd0IjabuA+n2pzL3zLtrflzmVd1sUDxGpz7a?=
 =?us-ascii?Q?FnNYgpiP1lnhxhxnfPYO9xJSf9nE+RvKT13KcXvpD/UGR7u14x9qNkFstwCx?=
 =?us-ascii?Q?j3GTFhNDkcFJ/kDPWTsQvJ1lYhwmwUQgRgNT8Fm/0oGr8YKB3jOpIEYeX2Xi?=
 =?us-ascii?Q?1yZZ1Ym2mLW/pfph4yxKYUzfyS4vrI6LaQqHfpc1XBRxX5anCJYKzhB9KOZI?=
 =?us-ascii?Q?jlZi/J5m4WC1mtCbFcX2Dj6C9OPFZd56pUUdxbPsCo/NhRZZb0tjs/KwkukV?=
 =?us-ascii?Q?+ZD6UnUnzzDFnduv9d0F0I9XixhYunE9sqVPBHfqHz12QTVo++i0pf0UHk55?=
 =?us-ascii?Q?psThwEpt/eigsYcGo8pJ+gTNRyk0xC1Kt1obfz5mGgbVTjqA3wSNDE1eSI0e?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a91d8c5-8d70-4cdd-9356-08da9e2c81d4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:42.2475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Y7UUGWC9qkxe4GqFkeS6XkZdzxK2RZElhlKNwyBeYdc4jf8wsDwV0MNSvoEmeUE8XwpeLOLY+q1NL4xlmwAeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=854 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240098
X-Proofpoint-ORIG-GUID: S9OeG9Ay50NIOnjytmMGSRCrrAWOz0JV
X-Proofpoint-GUID: S9OeG9Ay50NIOnjytmMGSRCrrAWOz0JV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 826f7e34130a4ce756138540170cbe935c537a47 upstream.

The xfs_log_item flags were converted to atomic bitops as of commit
22525c17ed ("xfs: log item flags are racy"). The assert check for
AIL presence in xfs_buf_item_relse() still uses the old value based
check. This likely went unnoticed as XFS_LI_IN_AIL evaluates to 0
and causes the assert to unconditionally pass. Fix up the check.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Fixes: 22525c17ed ("xfs: log item flags are racy")
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d74fbd1e9d3e..b1452117e442 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -956,7 +956,7 @@ xfs_buf_item_relse(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
 	bp->b_log_item = NULL;
 	if (list_empty(&bp->b_li_list))
-- 
2.35.1

