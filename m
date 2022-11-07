Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1761EA0F
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiKGEEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiKGEE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:04:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00B49FDD;
        Sun,  6 Nov 2022 20:04:26 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6Ke1LJ032427;
        Mon, 7 Nov 2022 04:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0Vif5w9mRuPcPMAMljlU0OVB4EIQsL8wGrbrgq93f08=;
 b=nqQchH6Eie60phJzMpuKJV1tqzNt53prreZycsoPxTfG9vAhp7+5JCMY7nhagHuSb1d3
 l3I/wFYuTgwyYr0EN3KvzKlS7uuqxkqUVHFokxYgQx0IymUdYe5iHn92kpN+6NSXCVtY
 AkGMvRU6m/ZWq3xQZsExSHIupwXNZwxFoSaEf91nnLcZMZkl4yI1yeLIWuVdXk3EHTy9
 7m9ck0UiIWyYPOd05afnysNH8V5hGWEs69KhLs0MK5yqLLmU82bkKQEJZSuxV7sSOpTS
 iIuoNkwBv/XfhEmaZGiNUJ1Iad4dMTRKVy3RyTE/EwF9dJiEqNHXYGiDVpBXZ1pXNrnM aw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6akmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:04:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A73cvTs001476;
        Mon, 7 Nov 2022 04:04:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0c0wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFpTxSb8e1B96mL5tVpGnW563iYgCL15BIhWi5BqKKCiORhU6Bd63o8+ieoXVTM84yI1A32B6ahI74fdq3zfwYCEuQIMdW6rceEG/kUzwYzBvwurRvZycf1rp/ZPQampy696Iy2DOXVMOlVCvLdfmxb9dU8EscrS4d+B2meJn31iio0wqPkypbIGSWayz8H/7RA2/TuqDkFCy43jM3nOl83z+aK8TSQrUy6nme770ICXCdiCS1mTPLYMCHg7cfK+QHmB2ZM12f6yOGpfPDAX8hW4xyDk7u4Mn5FMwJvt7KE7yXV7WGk2bgxWvI9ZI8ME6WOZTz8nS6rTerDYXzRPRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Vif5w9mRuPcPMAMljlU0OVB4EIQsL8wGrbrgq93f08=;
 b=XyyycfV5Vf5UhwUwMAWxIQNCwiE2puXG4N1DA3bJp8WOYSexCUZkfosa47s+tzSFWYV3UpymD9zm/dJ7OlW7iThHHIUH47AY8nszVW2GWW+OBqSNx7eVNLsxHsitEsUte0NiGI3TYCAEF5BNVc5hLfErDleLley7FDaawIICHY05ogOWQfo3quup98i70oz8+Hb786vawm956wGMdVMpAiX+KjOm/hoEEygJBlA3V9TQAcGibqeaJMVWPfdbQU2GhUmDBqre0RgbfVtYjFTOddJrbHH66MT9+Grfr5xOSSSdFNp+kqYndIdpRFvc44BsMXij4vqDc+HRLdsTiW+rJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Vif5w9mRuPcPMAMljlU0OVB4EIQsL8wGrbrgq93f08=;
 b=hd93R+xZh5666liOpVnWXi7YpTRJleFoD8gzJFiX2ahO1eGKF4OeWOPRh9bdUnPH2HocyQdNjCnX+WH3P8COS27pWUPSd5l/toXmFOnDIx6F2C+XmpgrSKwATzzU+XGX2wp9lg35TQoGcbJZOlqifYDyJH30lnSupVNmzGJeKUo=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:04:13 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:04:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 6/6] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date:   Mon,  7 Nov 2022 09:33:27 +0530
Message-Id: <20221107040327.132719-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ce62766-41de-4f09-0c9e-08dac075217b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YdDzPdbXzzO/8XWxRhcv1xqNFVXEnltdHpFl8ZhRzPWNwmh6wXmL/hZLdo9t2M3dovrV/EhMEkIjHgyo+ALhggovOPMbVRpxx/p1UJwwHc7JN7FYHgvEJa74cxBU4T3Q/sLRwZ0wLU7SluRC1Mg0CjvhgQLfbdBCYgqVeLPTPuk3854PQLS1JaE6w8NAUb19gNO2/JSnXKEQmGRP246cjKf8IfX23I0xA/sClBYnpCcG8g51GTozlIWmSfewHpe2hVThEKxD0rESr1VSLo2uaCgQ9bLIIDzA80UcEDfm0BsCNnBs6VUwlI3WW8KXAd/2ExMmoZxey/JVFGHOK+Kd20U0MlAmbZ00SQeF5lTXPV/ImGovwXp5ip9kLP0AFFroW3d62WAw8tIADrzo7iDFWiVtjZ7YJtHMEi5SSePVUDDgq6OcY4aiCk+mDcggjLAHcsbPh3urHRFvENP4xtKfWmm2iYdoQFLgvBQF6HzgYy22bWwZLC+8KONzr2uZBtWOp25CYXq35GI+GJEz/fL2kns36pKyh/dpOHJx3qVCDCdI6bod60g2Olv0zOWlMW7D31PV1XA7EjPlVZyfuTN5330YVOhnLPo5ePY8NOhiJAvN6mhvUgiPNG0nuZr20V8M5NshxE9skrufJknGRNZoT9yrUU2aQMd/VHIl9pM7diVwxljruoOQHxA9nHdqAnoCIeRUgvBsu88T9Jbm2acsLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(2906002)(478600001)(6916009)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEtpZR/hblSKYwMC4Be2GrvG4L0o5CbrVvWR/tLajJyk9VOhArmtv1pEhI8M?=
 =?us-ascii?Q?Ufz857Co0n60lRl0jbhsRt5vIUgB3kWbE79DQj2E98LaPARiCTQk/d3fkjbo?=
 =?us-ascii?Q?TdIB/NHzfKQDJ0I5aFt4UoYArWJBMQlIpoMzCfSErbp0jn9ILS4hHyp5Tqtf?=
 =?us-ascii?Q?+Jmroy011BCkDzsVVJmJDsH6LOqvisnDyh7kBNeVR7KfaS0KFDm1uCNeDhgA?=
 =?us-ascii?Q?7mJOFmrvQOrfEt+aLBHtvYY2C4aIJZNFNRS3FkTxf91DmlwmLlWb4NWNJ4QI?=
 =?us-ascii?Q?evy+xmQMc+F9u6hrZRjnzcpuMKH9J0fVZ16TjiWumB8WMSfyGGdFA60UPo+e?=
 =?us-ascii?Q?HHijeN+7ORzSwfy1NRrbtmalbaWZmSVBTGW4gcvMgaMpgBZespUIL8rBNPK/?=
 =?us-ascii?Q?YnpkbulDKV06L9+lDeYNWfNa2tEqEwqgG5knJiLxOjCpXkLSqlu5hL+X6hH3?=
 =?us-ascii?Q?2Anb46HVVQs2Bqh6lHXHZWrecoPnczpVvSoeHECWyyA8nASen6y79k2cis6B?=
 =?us-ascii?Q?NZVwaHSi35tmdx9liGmRCKxlSwsBxaMUM3skdT2nKpGtoZ40WbxvmBMmN02t?=
 =?us-ascii?Q?wesYKtGCBY4ZKDF8T72XWPfKhyOT6NYXnSEYjjfyE8vDz6pBtWlKC3zbpz6+?=
 =?us-ascii?Q?VwZs7CvvzPMtkmW4wwVuW/zpcPz9h4THF/+NiSZxPwNWOJOGox+E3TOa+c7y?=
 =?us-ascii?Q?Hsg3+vLxJ6GJ89Cawf+A9S47Afq2cfHdj45aSlHG9xIDp2LmEjxyeYJmOUfC?=
 =?us-ascii?Q?hx7rZSbwJd841ox5GsFflfQYiSHKc0dO8ql8avokYFaQehhJZ+E8eiWq+r7t?=
 =?us-ascii?Q?d9ym6xUtuO2Wti3Uf5QB2mH+vMgZfFQmqsS6t5o6u8sSRLW89w+775BV9JJy?=
 =?us-ascii?Q?JsjKwuEirmfeRVYWrI0ZHJxQleKEd7ctFrpEcoTeRf0HhJlFan5Gi/SaPQqF?=
 =?us-ascii?Q?kAJKZ6upAxez3bSHSHnXoBL0BttRYcDaLiCQo5sQdFmSeuzutIqEZyMPN8JA?=
 =?us-ascii?Q?ISyEnLOpf2Hs/lzVwXo3p3IiHFlTcDGPbeBRB5lCXU9gSuANB7lsZqedEZUN?=
 =?us-ascii?Q?hR/sd4e+NdZqPXRkzs5sm8vZoRcSa8I5GU+TpZ9P8WGyp0D8vFn3P9KvOBSq?=
 =?us-ascii?Q?w55Wm8xNopA7lr5u59IdqpWXgf6HVLs09UdRgZg/vBzph3L9c2sK3JMs9hnX?=
 =?us-ascii?Q?qboElxfoxhUnumywzk9fiUAjNJEQG9EM9p7x9E2FhY8A+InqbjQf8rXHP9qt?=
 =?us-ascii?Q?3pPrS9XxbfmIXwlZzbmDaxlpuqMNm0WROe0P+BCBlN3/CGYsHnb0UgP1C4mi?=
 =?us-ascii?Q?ExoQti7zpk0Ma97I2I3dk2LtJf9ZCirDvNcYUX+J39JOwVmJgwI1LzrztilW?=
 =?us-ascii?Q?0UeF0PG2NMW2laeLkEbKbB/WFF7dIbmoatSU4Oxzqh2SSOhpadCoEwggxaeq?=
 =?us-ascii?Q?BDddWtiTMAdq+vmFmUBFs/UD/CjHxapODzAEevJq1+B8Fw0Z5CSgeFM3vjuL?=
 =?us-ascii?Q?fC4pYqdvedXuc/ijBT/SkcbZjHp4+Nz5G2FN/LpjxqtTGR+TBGM8r3gD3Aa4?=
 =?us-ascii?Q?JwbcwTFQY44SGeuCUeS0zlzdgkG9ucVRmTQrn34C?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce62766-41de-4f09-0c9e-08dac075217b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:04:13.4577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Yq7V7jt1R151BNGGiEzVv3KG/DRdkB96R5IK8JOXIZWtjrRzxe2A4la0pIvq5KbHeFqlNZw1IEqyexa73ArnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-ORIG-GUID: KIEPCMYYDVKe9GWN3-TcMb9A_j_mdG42
X-Proofpoint-GUID: KIEPCMYYDVKe9GWN3-TcMb9A_j_mdG42
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 8cc0072469723459dc6bd7beff81b2b3149f4cf4 upstream.

xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
call xfs_perag_put() in one failed path.
Add the missed function call to fix it.

Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f8b5a37134f8..e5a90a0b8f8a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2592,8 +2592,10 @@ xfs_ifree_cluster(
 					mp->m_bsize * igeo->blocks_per_cluster,
 					XBF_UNMAPPED);
 
-		if (!bp)
+		if (!bp) {
+			xfs_perag_put(pag);
 			return -ENOMEM;
+		}
 
 		/*
 		 * This buffer may not have been correctly initialised as we
-- 
2.35.1

