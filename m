Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1861EA05
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiKGED5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiKGEDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:03:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A660D6;
        Sun,  6 Nov 2022 20:03:48 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A72xwmd017547;
        Mon, 7 Nov 2022 04:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ucvSQw+aVhXfgUqiGQBDmCkEH2aHGArLUrEw4EncLME=;
 b=AuaKL+C22T/vinWtlyJFrqVdgBRQv/IrqbYTmC3iBXSOTErOHOoL0BArXeHbQ8ISuh14
 xkS9IQmgqd0YefdvIofPDe3JoCqwJTpknx/Mek2+TI9lKJmVSwDVmrS4k8yehtl/2ULZ
 2NQ/J5DGiCXlEuKsZj9ES1RF6zNJ1XyLRazUkbOvhA+eNVgeSm6viLscd6rKsV5NsPF1
 iTU1r17wm6Chpw8PA3/hjL9Hbq7w8jYbIk+EyusbwTokEE1/qmmcFZKP4dL0Quj6LHU2
 iG1Tg91QfWd9k5hUur2u5MH5bnGhv0JjTAXLY0D+SvViVpqiEF/YWmHzTyYq7UXmHzCb 2w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngnutfsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A73U8xf040240;
        Mon, 7 Nov 2022 04:03:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcym3pjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnMUMLnZDamwvAl1dAMVg1cW9TJGVAgBrrOuxcc1UEeN+EGti8bjKpCJtSHhUTlPfljMYQlH8SQmlNa7poQQ1IBuuI3nJsAZ5q5E/a1tQH44yongyFEzPvUROhVg0X6bLGdeqkwF5txdbhnNfEcP8v/CwvtB0uyJF+aOynMQU7H82FK//ED2IFT0vHMGsMTA7EMzcn/MyeOK/oh8p170lNh3s1/zqdy+zfyO1/GlBu3XwcnQxHVgjKSJF0AgZkobck9g/ddd2gYsMgTmfgbFC0/9rpAumczrTL6hj1S4ttCT94TXDW90dRg7TflDcNiFHKlraA57pDhTEv2s4XzPkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucvSQw+aVhXfgUqiGQBDmCkEH2aHGArLUrEw4EncLME=;
 b=EfPTcgq8Q96RblB6NbKzQ+3QYgzZ3HGP3L6KRW6WEZnieeq2zMywDaqAhdeI7mnL4DlKAUU05ANHwxs/JDbfy3/QSlu1s2ODTfqSA0WqIqQAmr632hfSXHy7St6QCHOpevdcp+mAf6FaM3BY7Lei8O4Q9JNGl2EETK2p9PY0Ob5EKGRJwKRC2MLO10tz5zH3MN+0kOZ5MUztqHmR3ycrOrwmYLqMN7fP6aFNOHnvgoldDWNg9usNqxif8cgbgV8gQi5V+mQN9oUmqkAvLBgBbo2tCt4pVpw5fDfJ9qeBoeOmXZO/PsfRGzqVpHKhQOpzR/TX+KnGO9L9eN27ZicWnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucvSQw+aVhXfgUqiGQBDmCkEH2aHGArLUrEw4EncLME=;
 b=sOJZySvyFtHfSQ6LB9MBhe+4p0dnZwbSZMEI3KSELNcc7kNUbweZ4+W/OM8ZdayD5SI0zLLiQD1GNOluqJdZX6d5f8boB2xGY02Y0Cpsrlm2mtDCWP6++DOEuVjD9TKlF8GVtt4wQbjmUDez2SBwPDc3O/CLYp5ZrRfaLASarHI=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:03:40 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:03:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 1/6] xfs: don't fail verifier on empty attr3 leaf block
Date:   Mon,  7 Nov 2022 09:33:22 +0530
Message-Id: <20221107040327.132719-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: b5a3cb22-8318-439e-580c-08dac0750e19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2c7YcppE9ppxqTUXSv3SvT46Zf3kENuQJAwGmyXhNy+B1OEvUYw3/Dv3wF9yf757TP6rNRTSQLf/8M13XJZuKSWceqCu/k8l3TKKk6x9KWW/J2wtZp0ZiEIw5R0hVztb2OseaBf95bDaO0/6xRaEccXIojLYUAyfdBShnVtyxIweEzGLezZGR2Sw+yQzy1hqpWaTxEFLZkdgxy65MGGZvljqtYnNTeYMq17xqyVzx04R68BbG7as7py1g6awVqXN07DXXHwOvHDTNhGujVI8CxDaQHM4ONg5Aa5Xy+DQFNziiKygEHJy74Lc5AlRBqwsyyE8Te7JvP3HKGppgGwZHl6Mvwr/VKHUT13GH70MQ+oTeYtcePh7iunbh4AHaYtvMJQ8UYRFZ4seQ2OH58MVtxSF0Y+JAe3/PwBkqLiZqJNPd4qXeinLp+PasQPzbwGLi7jwBYL/d4S2liGJg8tlL6+8+1VwiFX+R+5w9pRrbZJzGSLdAhm81S8AZgmxHjJraQcUhM97ZOb661JQ3mslQCFEYcqiMTmkPLo7caD2yZFKC8VsJCoqPHF+Z+WS2PEOOsm37FdrYo5dU0XWmkX0Gy4t9qObektgxBg+r4wherCK+gq+4ORG9QGce+P4S6VNB8RxIqHIWMfmsg9WmM3sX31Hin71DgzKcVLVibOUvB14IfJik/LqPSjOCU31ZViOymWqLPkWtBS4eV04g4Cofg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(2906002)(478600001)(6916009)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ebxKtzLWLn70R+TJl4EaF2Ix0wD2eEHiv/ZHJhTs8adKEOFY2fA4HYkr78dR?=
 =?us-ascii?Q?KZCdXcIhsV3MNh2OOnNYKjYTViYOFs14ICSCKv+3qppFL53iUhGBnqCu7EU9?=
 =?us-ascii?Q?l/hbBZqyPZrLKrbbIjFrvip6VY9SgleCYp/UZ7AMGna4tEAAwftMUztsitr8?=
 =?us-ascii?Q?AKLp8q+kf3WSzwSPKbI4wyq49K/ar2pTXxTDiu8NpUt8N9EqOnh4xhqAeCVM?=
 =?us-ascii?Q?wFesUSWpjwTobNXLwlWxhgad3OIEhnqVP7TC3bVjs6n8GtAjSqP7j5qb4j6v?=
 =?us-ascii?Q?Ca6Z1EhKvvJYr3fvygekOQjSaCllmosZ4i8fR07flu0vbAdXSoxbRoU8bU5R?=
 =?us-ascii?Q?EpMyoex6xDscuD3T6wDwlq5YJHIIHYc4cSFLbKKKibtHhjfsMS7wwGtvU7t6?=
 =?us-ascii?Q?TliKyhsfNz5ZSOqeJGVr/ybwSU+HA2tm2SBVHdpkJhhHkU9tcBOS4C24F0s6?=
 =?us-ascii?Q?K91neUn+ANeL+4zg+bv/Kt2QesbWk40V/Nzz6yIPnHu0u13gcVVsJfyae9bU?=
 =?us-ascii?Q?C15A9gQ2epkIj39fMw8dJxX1YcYcUy+Y02MUtSMhcLTNUKqO8lu4DtEhw8pf?=
 =?us-ascii?Q?OANBqxR7e/01nfaajMNR7cD4/buQ2gD88Zk47TeLzh+Stf+bg5gioAiv7/ce?=
 =?us-ascii?Q?M0Cof5oy/L7JohH0tTqUqSDzjhc76rERgay2oCRfAH+kdtUeiyymIq9i7DQQ?=
 =?us-ascii?Q?BnEeja2hS73pAg1+TZrkDqAy7hbMJDJfXqhIMmAqVI2MShMETedQSVHk4883?=
 =?us-ascii?Q?CqfGzEWpP/7Wrw6MvxnhlyCf5LWJ9AaWvIMXev4+2WjlfdycnfdrQYukYPNy?=
 =?us-ascii?Q?ZyTSJ63CB/eqgVDJ+/WpzNFWYrMForb2DhdFLzj+Lh8PjsSfiPW6coB3Jsa6?=
 =?us-ascii?Q?ADeRGb5nrtQuA2wqvS7OIrFTIBHZoYW1389GhOfTkSMr5jr1M3RPoGyCczTC?=
 =?us-ascii?Q?VR8nczMeKxa0B3dW4mp4HGbaA12+Ii2W69JOCa6PSK/lNbP6rb9kkHBzMO1d?=
 =?us-ascii?Q?35jJNPh8i7vvcd9Rj8NDEgZdHAJbRLd4D7XgzbEHvcarwbe5ejDReszhoA3T?=
 =?us-ascii?Q?J8wVSwTRTjmT9jE1lSDdN/wEPXNhC9wP6D2bqkXffx49a3sqmy5f/yFbdOCC?=
 =?us-ascii?Q?qpxfLF0R9YPT5Hv5uJC32egHSgmr5vMxK1bRG6FZHIfI9M113f8PPGZTcqdM?=
 =?us-ascii?Q?NkZOlNjGK3tO2uhXoTPKcFNeavNP+D1nBu02r+kf+OXM8p8cDiYM6upkO9M0?=
 =?us-ascii?Q?a7AGDhMcRk6nD5213xmK0N+d+M9X0kYjMjz/4hOfzuiV1s9VWtuWUVrZ3qR3?=
 =?us-ascii?Q?0mbQWW+eyATuWDlFTZZ88DFy3LnUMhzyHkw83Zdlr0uRq81wpuB5LnqSDIxV?=
 =?us-ascii?Q?HP7kk07SsLou/Mu1nwztphOM3ll5y17VNZX4ZgjB88YrqaGTjUAU2A2CzhI0?=
 =?us-ascii?Q?K3kyMSJ3W/BF0NSDzHzI5ddeDrDZI97daGVJpZsjNlPy8KkACCKKtTW0uCDM?=
 =?us-ascii?Q?Rn6+9i2cDtr2G9HbzlLwfNRug4HrnkVuRC7XXAszZ00H6V9OHRcwEmaW3EOi?=
 =?us-ascii?Q?XWDXfZcJ3emQb4HYHEQLSq4eGeO/RxCqGMnZ54cZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a3cb22-8318-439e-580c-08dac0750e19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:03:40.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKnbGPdcPwgMQv6WJ/Ndvlm9wfGN/HLQUPS4HLfKF6UV0hX9JSmxs9oVR0njXfI5ZrVdkTHHZ7rBccgdXvSs2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-GUID: T6iVejm3skmKbg1kaYKaqMVAIzQJPm7J
X-Proofpoint-ORIG-GUID: T6iVejm3skmKbg1kaYKaqMVAIzQJPm7J
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

commit f28cef9e4daca11337cb9f144cdebedaab69d78c upstream.

The attr fork can transition from shortform to leaf format while
empty if the first xattr doesn't fit in shortform. While this empty
leaf block state is intended to be transient, it is technically not
due to the transactional implementation of the xattr set operation.

We historically have a couple of bandaids to work around this
problem. The first is to hold the buffer after the format conversion
to prevent premature writeback of the empty leaf buffer and the
second is to bypass the xattr count check in the verifier during
recovery. The latter assumes that the xattr set is also in the log
and will be recovered into the buffer soon after the empty leaf
buffer is reconstructed. This is not guaranteed, however.

If the filesystem crashes after the format conversion but before the
xattr set that induced it, only the format conversion may exist in
the log. When recovered, this creates a latent corrupted state on
the inode as any subsequent attempts to read the buffer fail due to
verifier failure. This includes further attempts to set xattrs on
the inode or attempts to destroy the attr fork, which prevents the
inode from ever being removed from the unlinked list.

To avoid this condition, accept that an empty attr leaf block is a
valid state and remove the count check from the verifier. This means
that on rare occasions an attr fork might exist in an unexpected
state, but is otherwise consistent and functional. Note that we
retain the logic to avoid racing with metadata writeback to reduce
the window where this can occur.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e69332d8f1cb..3d5e09f7e3a7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -250,14 +250,6 @@ xfs_attr3_leaf_verify(
 	if (fa)
 		return fa;
 
-	/*
-	 * In recovery there is a transient state where count == 0 is valid
-	 * because we may have transitioned an empty shortform attr to a leaf
-	 * if the attr didn't fit in shortform.
-	 */
-	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
-		return __this_address;
-
 	/*
 	 * firstused is the block offset of the first name info structure.
 	 * Make sure it doesn't go off the block or crash into the header.
-- 
2.35.1

