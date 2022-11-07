Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C79F61EA0C
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiKGEE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiKGEE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:04:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE7260C5;
        Sun,  6 Nov 2022 20:04:26 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6KeFTp001570;
        Mon, 7 Nov 2022 04:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZphINpBIhQmNfF15ejJQJ0RLvRjwxBjYXzxjLaMeTqw=;
 b=SI4D73/dPCIGziEDl+4tByH5vVMv3eX/Dj3+HD+bY8Ou1Yq5emVrW3YMgRKZYk1uNvEr
 Xs9d9mMNe3KHcQxGNGIwCLUrOm0k2nFMnrOLwk8KQ1HyzT+cPwGoF+D9H0FHAfVGdEpJ
 /1VDf4i7wqr7BiGQRxiuRuAG61gj6BJ/h/vcirMMeRZkasIh4vpxged/nwePFSuvPKvE
 da8WWZYZpJSdk0I4nbj6HbvLBUKIPEMg2lb9NQWQ/cZXWJWo4kj48ynRZD/RlpF3MROx
 AV5hblyx8cXsyV1FmrQ1u1Yx0wc8VcvYdnHh2Xk0pa3f0X7UEjT0RQSvQWKn72tVhE+P zA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6akme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:04:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6LA8PY023074;
        Mon, 7 Nov 2022 04:04:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcthv0af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fr0KFrdLeFVEJKAa46FktP9QRLxFHQS437tL4I4mqbB84VvQ8ZHOe67kPL2CEFYMkzIUYurzCCsj+zIDuub0Yjz8L6YhfiJ2o6E+OkpWVQzIHhx/c8Axh4KPo6DVKzTtNPP9ZQWRHHe/RUtTGZ4e5VZYmsadcWXGYykkjmulM/0/qycveO535YpSsBGyZbSNEKTE/6MFegsqUUUJLjeYEOFyLNd7rSfJBCmFPT22J7FIXYuLYbf09aOfOxBpLvB9Awk4uAT/Ol4RtJZcHFidwO5rughYKfYvrcnw5p/v7SMV7HK/RYFpmxJQDq1SLZIdrnGzPypBsGVBF106jX3Uqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZphINpBIhQmNfF15ejJQJ0RLvRjwxBjYXzxjLaMeTqw=;
 b=GXtIS0wfgJ6zX3epaPOil7l3kDhwHk1bTZZsClkDhhzim4RHzjpB4W6E1gMdlTdyG3vanLziLeMzkLDeJgoBUS69UWE2qAIkRU6ARCVsJEl0quLD8nBn3xQXAEuDkNI0elmAkbF8iRYLPY0Nx8dY2/n6Ylc3f2HG+ep0Hyd/QB/WQKoUmOHK+YTwU/hWMCFvCVJjq+blqLihMbMREv7amWFJbb8p3vFbPHzYz4MDRpEuFCCgjG+dwzmqPNSekyhRWs63Twg0nfu+kfhcncedzXS1PgrU4mXTgej2/+b9IwyxYgsDzJwp7DgBMMSk3aAfOxsAl1UfY0ZLTn6cI0pZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZphINpBIhQmNfF15ejJQJ0RLvRjwxBjYXzxjLaMeTqw=;
 b=tdPo1+3ZPt1aOsqPphD8Y5PSawfOocc0rjIKoO3i6lxAsHfPqhyTo3QhANqZEPTDpOL02s+CG1f5l8vxhgY1R1cW309H2AFRIi637GEHUfxnQHmEPk+znXD0jpbTTCjoV2maj0F0VE7ojGIawT0XZWW+lgeFtRgT7ks24fC1C0M=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:04:07 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:04:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 5/6] xfs: don't fail unwritten extent conversion on writeback due to edquot
Date:   Mon,  7 Nov 2022 09:33:26 +0530
Message-Id: <20221107040327.132719-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 310447ee-2899-4d6d-d94d-08dac0751dcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //mFEKCily4pW84XI8kZ3SI/IzKbaf9tzVDxX+yvoQ2xr9OvQtkCSYhlJGgTSYFmxQkg3BMo7WIzoT+X6sDtPKHMBts2TjPVKpX8+G+eW7f8Hob2K4Gt23FhYB5ZsGLflXPTj2JaSyF1PinhSP3CPTHrQ1kbjZhk8oQvdDybmKzNlNeaq028RrycZNrnsMMJteYApDkScJo4mRY5ZNxjSnNpjglIqAR0G4qBi+EbtEyvuDxn81HfelhnO3Ka57k5vYGRfzuJAVykzb6sK7/3AGXZuZVK/mL5u/+AuM5ugcPg1y+EDZFaFUGaIWrncrn7MZPri/yvQQVu0zVaH03ydgIrQ/S3iwclT1EJW25k9Rq4kwthonIyyrxDoIkiEOQPqGjQQe7nmq7TsVnsoORaN1HMjOYUiWONsDo4IMyVEOcRE5lghGE0sz2aELPVBH6rmraN0apaVEsm/8uSm2frUXdcfzX/zHYgF7p5BHbDRoLNZaSBTi/Zeb02JM6fF73uKLr5Qt+5cLiU0ydvxdYGLyUxGWqHEtu4WLReYvq3BrTz5c+P6dTLPlQjgCTiSz/bWXWndNGvdyyPkEVAPDLkKBZ9OjEC/SUZ+uQs+mFExrnDv5A7FwI+U5XPJP7BPMgZXb3i+QgXlCM8cpXzPyR0eRenJu0fM0lEFWGk4O4d1pcRRcB3WLgx+qu4iIoU48CxIx6qVgPbUOg9C5Rpvxz9WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(2906002)(478600001)(6916009)(34290500002)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JyUPNt3o7Imuwv4GnKEZrb7Hf2mQ5GjeqaogU6EBVBznbkoz3l+UTjbeCfWD?=
 =?us-ascii?Q?l0Qv030YaY8XCRTwoXLzL4gF8TNsFT/0IxbVSj5NwAFShQDgm2CjDtQhj59S?=
 =?us-ascii?Q?TU+whgM+41x0hDq2+OvdHbaLaFIPUWguY7IuhOgmtEB6VVmzCbjT1KZCilq/?=
 =?us-ascii?Q?nTj/I9Cko+VPvOOmeuUf06iMHrb9BHfZAYBc4wOdxjK9fTQpLKY9c5j/Svyf?=
 =?us-ascii?Q?6sKFrUgBeV7uBWxw9srHKE+oSN40TbyIyugDkKls6c7+RVxE9yBxAOHvQ8Gx?=
 =?us-ascii?Q?yGsxOBiJYwqLb5D5DrkDYqGivFanryS/EPy/Wv6TAqCl6dBoqVnJYBjDfmbS?=
 =?us-ascii?Q?Xh1Wt/gVdv820r/7FLgWfUCYWQqZldLbBUvbvFKvKZQuKD1eTJ5VdxMuHOXP?=
 =?us-ascii?Q?E9TsrXM+IzB0HiAn9wAYvn8DHET3rtrg1mjdhfScK6vprlOTknCZfOgruJ51?=
 =?us-ascii?Q?af/3+2rNYo+HtdEHxHVzzBBdCK9uPiWgx/RtGzAyJXy6fRRc3aivvTq5UPH2?=
 =?us-ascii?Q?tTgjXTTaIT7dVkFb0WVTA//ZEStr0ZjkUo+K7j9Z1WqkngQNm3USDE8Thvbf?=
 =?us-ascii?Q?dpoHT4sllgaEkTqiHEkKq8mYagWf4/lvuUuatJistFiH+0qyPA3Uvn0/r0pk?=
 =?us-ascii?Q?QMTG+TiS8c16E8/PS/7g8jtjvLLAKnfQD5FSr1Khd3GZ39+AT8HsTH0oF7zg?=
 =?us-ascii?Q?okYYzIetkZBqYQt0NnzmNGUzm76UFPct6pcAhVDzQ958K2NSo6q04YtGnnnj?=
 =?us-ascii?Q?ADpMalM/IazpW5eE2s10Mp3CeSPolajrJh8Q6bgdUcMFoCxdmZvLLRat5S5R?=
 =?us-ascii?Q?+jEyn7qtvvDTJdIpp/DcKHzUHI/FBvhkOB6vwLpXd6sI78Iwh/BzzP6DpJN8?=
 =?us-ascii?Q?3z5WCFGSieZfxXmfYKxnXU9Etbab72ebSEdOjbU0C0Ntbe6N/IM/PyQxR+Oc?=
 =?us-ascii?Q?DzrrihilY7harvDGf38CLeE1jU88WLCFrS2WALquEQR681s/Rr2m8zFFbxVp?=
 =?us-ascii?Q?L/FIN169bgFMaaNGJosdQPeQYYfDOcEJa3ZoG10WCkSH+Pql8U0cHiKsViiS?=
 =?us-ascii?Q?I57xlq2zr+UDh+k59Yj0mQX4K7JgebmI31l29hWwBfDKdE4YsubeSg5lEIRG?=
 =?us-ascii?Q?d9yzlxUON1kksHDrvlrTjUMztHeLYnLjAygp9Ckbz2h6C1achBdUcRRrSyqs?=
 =?us-ascii?Q?yB+CYy8NggLTTO4ECrYX1MuejJ00P/xWfYdOdRgUqQxMwYhbKXqBTqqvFcf4?=
 =?us-ascii?Q?y/6rAe07Fi0nLD9d9i2G1qeUp02lZ8iyyvrBd5fRmuHuzJGGTjqRVpBB7Ebj?=
 =?us-ascii?Q?opDN3zjaHOqS6bZy5P2QqiJlkxgUG97aCHcPYpyLUAHM64/NueYDoTEcwmgZ?=
 =?us-ascii?Q?4BMQgQjJ1IBYrxn2Dl73A46PquCU8+9iL7wnQuYEYtO7kUND+liPvZP8LRP6?=
 =?us-ascii?Q?26ivCPoK/4tJPmU3EmBodnNQ7A91fRVwna7L/H3rPt25iLuZOh9ujA9Q1+7/?=
 =?us-ascii?Q?F0xXjTcfCBS+dXt2Xx7IL0yEUOOPOOQfJdDqLptIuN2DeXJ2Sp/rsCWMnxBf?=
 =?us-ascii?Q?Or/0//VrB3ZDOCaNdnprJoth+E3Cr9Z3jkaimin3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310447ee-2899-4d6d-d94d-08dac0751dcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:04:07.0955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNI0RYAri4qAjUkxg5L2be7TOurRGWzCgIUC3R3O2LHIrdLFx97M6ZhgCuhcgafekbuyIArpQsUMABY2sG489A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-ORIG-GUID: ymJgan9za5jEnAwCe5aGiarcSMnJg4lT
X-Proofpoint-GUID: ymJgan9za5jEnAwCe5aGiarcSMnJg4lT
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

commit 1edd2c055dff9710b1e29d4df01902abb0a55f1f upstream.

During writeback, it's possible for the quota block reservation in
xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
limit.  This causes writeback errors for data that was already written
to disk, when it's not even guaranteed that the bmbt will expand to
exceed the quota limit.  Irritatingly, this condition is reported to
userspace as EIO by fsync, which is confusing.

We wrote the data, so allow the reservation.  That might put us slightly
above the hard limit, but it's better than losing data after a write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b6f85e488d5c..70880422057d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -789,7 +789,7 @@ xfs_iomap_write_unwritten(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
 		if (error)
 			goto error_on_bmapi_transaction;
 
-- 
2.35.1

