Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB365BF469
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiIUDZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiIUDZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C752474D2;
        Tue, 20 Sep 2022 20:25:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO686019481;
        Wed, 21 Sep 2022 03:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lDCGlSrEe4rABsl8SlYb9zS9tBxVHKuP69nXhLZNREo=;
 b=row9yHcNnA0rHjLEubtRidSDVYhYqJSPlsC3wCbQ4UmMQcGq4EJiVVZCQ/NdYcN7iq/2
 HFLzLxQLtEeRQeGH5iqxhJ8uJ7nDK7TLSUWDMJKJqseYP8ReyQXBI6y47cU7t4wqQ73o
 TrdZMJC0ydeRUNWfPjJ+k6ohHBxWDTZLjP1h5EYwZgNyPDFOaJ9Uc3Vz1tSVcXu38IeP
 60Keg8tTmb9jKpPH6bQrCsb+xMZ2NCJhMjUnGi49sr1rdKfiB5Cy4FV1uDr/v5mVs9l7
 On1Fk+/3nGZzy1olhTzlx0d+EeJfe7TWHcpJh2B7c2AYBWmjIDmDuGiXBWUKlVEOqssq Cw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m90p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2Cifa027909;
        Wed, 21 Sep 2022 03:25:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cnyv8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls+fOBD0kmneB/XjI01SKcIBdZYwt4ZLhxRcz6CLW1jhjdZ1gU+ydex0M11BcdcVB89651zJ/tZLiNy6rOzfCuTiB5AjbyZOFf5lHIOc6dEZ1etsqdVtBV1o0b8EJirIZpQ7hK1ANxMWaL+6Y6QGKXpCyn+f6BoyuXlpCYDjEOqFKeWByE0SR107NDp+oT3A0GVw6PGvm/R46llqVMDN9DOELduo6/tLUVAFgT+SS1tPRTJfsJVON8X5hui70Y+kdgAPHwnnyneHbmML/hBey6z5Ziv5SZs9AX1Is3RUb3CqYn8ySSqE/Op2wrxKiPXErd+1fGhITflDwq+7epeKyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDCGlSrEe4rABsl8SlYb9zS9tBxVHKuP69nXhLZNREo=;
 b=kKBSqS6naoX6PUAQRn49CjXVCrC1Vzjg+H07odp/Qq8dteTMh11HY2gbehT529nAOeJHE0uPytWVhr+3+DQNXbtVLA4AW61mG+VZPlpjOq31D/ekfcH/pqtF5HB49AX+qDKr4ZRfpxyoOYnPA/92MzE4FEmTeWsrtWToHcWatUetMDSzfLDDt0ofgPQ+suF75sMQfK4etVbTz30pCIfCzgnYDmbmHQP8Q2QJQTngCJ9YpIfNxgCAQrn3KkSiWOD8/F3NQsz6A2WAiTie3mSizq0vxoZBzzImAtFJYKAtMD7V1QimKhAzQwDjjH7xGQHaCeZZAeq+kdeJ2rcoBSqh7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDCGlSrEe4rABsl8SlYb9zS9tBxVHKuP69nXhLZNREo=;
 b=QuGS8F/j2I6hH1mojaekyrc29z8eXt+bxYaMp6Kkni6SUJgayrj12kkXASBDsRJcxbbzIDJAyeW6sdjKMeKXcMm6dmF8wopG2UkKykNu6MHnHwUHH9Cy6a2Cv170PtafHh/Iqj0cpZqk4bMXDvefpJ+4sjst7zYpG0Sm6R4mCf4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 14/17] xfs: use bitops interface for buf log item AIL flag check
Date:   Wed, 21 Sep 2022 08:53:49 +0530
Message-Id: <20220921032352.307699-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0035.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::8) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a0b66e6-8c3a-46a3-6fec-08da9b80f2be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYPj5W/c18Omlt76wr+eg3/0a/JBlUcGsk7wlD2reWiaXhId4gqaXlnRdeLb7yuWqctnog50KD4OIChzZfa9E+qDV2lt2fQsHYiytuU7c5/MOyeqD237INtQie6kmXBlY2dSfb5W2vtpngHxYmmg0sB1qelc5wNr2cFkUA66Rxx7igBQSrPqlmwUwCLpf2bf6cjBO2MNkqSLX6h5UICF4P3yuUV+9lzpKBcUAbQmVso2qtdhF2qoikn/Gv3Gk3H1kGwQ3faGV028VKTsLx6HBaePKhBSL0c9VEYUs542ZTFDIKOp6be8A73aD4/iVlHiHxL7wYxFHAon80LipbsVI0ntNq+DFVt24Cwb2nb2cndVFUa4qMjR+Q3TPLXmuaUUuDrFuSl+rlqRwwE1yTtgbTSer8qikpvRGjj07Xnombp869PH8KoXvOdX/UElZnqPzPo+cYv9EASD5YqfkWxTuTwxTzJYaHjjs++946/DArUW2XiZy3zr7Qh88DDnG4GCOrIChxhXQSS2KFHmd2DDUTzoZEKWHX+wCxNdVqMPpdtul9wjNxwjQ71B3x42Fh5a+LyEIJdOPMfXPIcgBX8GHe/XsavL4TMWV1K+svglCytdAtHpwGzYWjc5VanhFrGtZUR7+o659Wm0YqkgMNb8jvaucTXnQDLFOxtRcvk/iYjg/JuMneU0CVVsUrLIj5HNBKrzzw8kOCcsYnZ2UbvKYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WOsBadFMqahD2s0xw3SWN/UPtkZmwnuusgqkVs3WeuGJo3mA8zjwrDoGuEo/?=
 =?us-ascii?Q?FiHE7wTN1+fnc7K7BmdFaajWZPOUgJTxiBvoet0RqS5UgjfJix+qNbrddHbu?=
 =?us-ascii?Q?JhzkOCCNKP47UeUHc5wFdJgFu0B1l0qrmXmD5UvLRELUA/qqxEeKtORi5Fqu?=
 =?us-ascii?Q?hAVBgP4CJORjabywh8MjUBUDWVbVjwiUIg31HNM3+8T0+eXIMUKtEdJKW7mQ?=
 =?us-ascii?Q?3YspFM6s6u/uzHI8REhJzYtPBFxOdS7YmwIG59Rr0Cx3/mEMC5yM3MkVsYvt?=
 =?us-ascii?Q?F5dn8IFY33erxLylB1VFunRDczU8UM+iZ8NPRYf8KGLWdVbul1ZfzS0eBq36?=
 =?us-ascii?Q?Oeg/pZAT4tgagqMRzuixXiilI+z4d1MxJSqRNIy4WlJkfbc9FAYl1Q/jAraB?=
 =?us-ascii?Q?OhyNtoiqut9Aa+SRVmypzE4pC+UIK0KCX61vbO6JnRq/Z6O4+E3/Pd4a4eLy?=
 =?us-ascii?Q?QJKeZ7jwJCw/TicHfcIAayMVS9LEw82sGmvC3lLBcI6dtT1mnxqYMXzdqbLN?=
 =?us-ascii?Q?0N8CiMZwORf0p6nZc1gyDEZZ5bLdcTI2ZYIYMTsJh8Q0xFUlFDSL/4VCrUYe?=
 =?us-ascii?Q?UPDAJX8AYQoxwqb/7xSUn+2sPxc/YGsir8uL4gc7kBtzASS7vDd/4dINi7y2?=
 =?us-ascii?Q?CanW7JrhXWkUy+FC48PR+OYg2AG+h0+Vxwb6PF0wSTkhapuLrWUi4wpdXVyT?=
 =?us-ascii?Q?ykfwkLvbvmiwLo+98bF5c+czrd6CKqtFmfXzL+WkZ3w4sxkNzPNz3/I0UuO2?=
 =?us-ascii?Q?BF/eFDBfqDTF1kxlnT7BYk3bTGUNRRVL9cOx6LYehjJj9iQobfIbDOMFOwrK?=
 =?us-ascii?Q?HZ3CxE8NgRd1lzVkE/D3gKDXfEPme81AoG8XXpf9yoNGSqTyTQsO4s2vhHok?=
 =?us-ascii?Q?dg+2KiRZ52wrcJZ8KN7+j9uPL24JTnmAKXXMGO4LalZhthLQzemAJIlymE/o?=
 =?us-ascii?Q?iAUbiwpcxtR/YtlYvv7BBQt+hXbCT9/6INZtuwQ/yWL4Y60C300PvYuhlDaX?=
 =?us-ascii?Q?SXJpXq6Fbn92uqeEMFBbTCnqbuNwAHaho/oai7ghq0aryRwJSonv/+NQ4thu?=
 =?us-ascii?Q?p+mmYuphiZWK5s+hCa9uJN+ASmlJjZg5ZN8OcmPQoO11YaWn9tMHSHl6jXR+?=
 =?us-ascii?Q?3+xdNR+XThMFhc2PaReLbHCuAEnutPu8yJq1zg0uoCZ8fJPYjejt61JF849p?=
 =?us-ascii?Q?ShMYR0BurbHhp+Uky6qNsesqqxYocoqAiC56NY4Abn432TFE7bK9emBiOSXc?=
 =?us-ascii?Q?+hLdkrZyyknpKbUkuiMdLYBCCSWgazOFZSS4ouPe6DasVf+L93ybxA484OBN?=
 =?us-ascii?Q?SVjoeb0TLbfYf3a8LslDn/rEQFKiBZ78OjxonmX290Tqh5bNC8qJxjsMWnXp?=
 =?us-ascii?Q?T3E4Glq7/aNhDHiF7u/iqRjMjP3ETt489J5jfxyZK6ffMTPJpoF6dp35TM/b?=
 =?us-ascii?Q?jsP4bjdYxBDwtezJw3pwQG+ReM7Xvf1cGjGdLYLGfIWoWU4WJeRFF/y4EHCB?=
 =?us-ascii?Q?opi0vfRmSoAwTOR8UAQZnlGc0Pu9KCjgVKb2iA9UVOlbTgbPw3gvleXXQFXG?=
 =?us-ascii?Q?VpiegbgFZ3CUGa03WqyAPEgKTLxvU7fZU7reETiqGB3AZlRRSb29zsDJdQtV?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0b66e6-8c3a-46a3-6fec-08da9b80f2be
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:35.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOX3vG9ilpVA1r1ufIf4jr8mFMLsa1LVHFuLElgQZzxMcYGJFuwqNZ9eFnpct3dd+iyFUGsb8A2RyEDh7rB2Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=852
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: 4PjyfyujMNt9068iYTmg4EOxTySjwPh4
X-Proofpoint-GUID: 4PjyfyujMNt9068iYTmg4EOxTySjwPh4
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

