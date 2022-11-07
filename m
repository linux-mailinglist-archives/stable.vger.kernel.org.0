Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0E61EA03
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiKGED4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiKGEDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:03:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6C62DED;
        Sun,  6 Nov 2022 20:03:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6KeB5N015575;
        Mon, 7 Nov 2022 04:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=32IPUMWUItVJu02X89OdYQQZ2lO3pd885X5xCVIwic4=;
 b=tk0ebG4b7h33LaDTQKrZu6ZvKvvHUubDDQyIbJLYlx5GLzgkcn3z6MVaXQmLMGqM+2Y2
 joLZA0RXfDHhpSZWvg98APm+ohPtZm2yeItZ+HhE/z7ZNA6WJfRwJFL43VLUpjwMqUjp
 8SyiXrLenBEWfendA+6Juy7cj/I+HbMm9KePSateSuZRj2PWsftqm6uLWg4yZ/imuxoP
 z4GBykA6+Tg/P+7l6FmicWxiszBjryCMi57sayxnNgMQODiRF+TJz6FPiZnBqs3xvoP1
 2ZN5yTOntA66S0QlzHU1wV9j8GoHleR8x7lAehp0dbHsrZiJN4O6hBboICWlE6g2UaKS dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw2g0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A73p7Yx014452;
        Mon, 7 Nov 2022 04:03:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctakwv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxlHYzJ53Hw74EWoPeMZjYvF/5eTaFsgtPsyb7re1XR55H0lNb8q8WnYvRlUDzm/2FRMqlkAST9+uT84I15zU1p0iI0JHpjKiQhEUbjh16/YnFs5lvvCmBvqZ2IwNzu8uNwyY8+3TTLzpSF/8J2VxddsdMPHqPdqJN2M5geNZGsMKioSp2hsXD4hkH/zCFoxIxoC8265b7uD1sxXYiXIcSNX6nuMfI5XEzmlGTzhZHpbLVTermIzNh73R3zeqk3aZ1g/hp4bCdcx6JNtMbtnbu/5VqWxhRgUiJ4XWbIr96uzMniLOBhABa2jB1/I48Nay6wBladBP4fwPl9s18Xs1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32IPUMWUItVJu02X89OdYQQZ2lO3pd885X5xCVIwic4=;
 b=nyDRwWlqQgLO38DnCMi3NK8aE+o+53/oY3Hfp5aCi3+MwcGaiRRIPuvF7sJ6IkyskKSJj6GVJnevqIeDzZFjJGGmabHarS1uh4aoQUA7f9EB0piWT+B5JtAGtIaidWTEhvXII2jAgqdz7gUWsAMljfCzavSPAjAHMigBg51wKxE9594IbjaTjXgI/olNiBN/4ybvnqZqvgv/2k14VWe9wVdp8OgUoSnBf51X3zhDclw2s+ghNP9ORYcRj5MEg5aUqB+nJIfZYdfH2xxe+mmZlP+VvTdBwM+CNsMT6OjxeMbC2Bzn092YkdWVO9n7KJaI2+W3mUZH20pVCFhmObmsvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32IPUMWUItVJu02X89OdYQQZ2lO3pd885X5xCVIwic4=;
 b=QF803+lvr+uajRXsnHHdcuX5O3hCWLfA4fva/m3i/25DgqHCCcfJsWVMZR6J3vP21Yl09DFu/D4PD6PsWlWWShIvQYA1i3K839Vay4ZhR3z6/JJpxpfKu6k73wWvtML8whbOu9eqm2BwZgL68lIc3mjt6ZmMGurNMWqT2XeuX6U=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:03:33 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:03:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 0/6] xfs stable candidate patches for 5.4.y (from v5.8)
Date:   Mon,  7 Nov 2022 09:33:21 +0530
Message-Id: <20221107040327.132719-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0126.apcprd02.prod.outlook.com
 (2603:1096:4:188::11) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c80eee-830c-4305-3535-08dac0750960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jjnzlJQJ7HoZ7+AlWoqqZ/w/SlAzO2ghs/sJsi+7qYwT/gALqFLf5+0BbB17+Ha1AmIe85Luou086639Gmdv5S6gmBho+NRHBBmhHun+KAqjlr3/Tz4iQ2cKDdUsuTRJupvktCgGAn8gFp0db9TDkltfe8EjcH6vXITJQ5pzBUKezdIm/Vl4Exr9/vFKzjGNi0axvASwfO0u66E8/Wdt8nZibpRtB6+y07kMvnsXN9YMNkV8uhHX3ZpBuKOawTKoXSRXF0WFswRhBpFvT+u6GyN1fgpWjbgTf2A+TJirCGK1gIwu1u0Lt4w/cNXa0e64Os7WiaLLKZzbQ/HBag1HFC3jM126G65RV0LvkOven8Ybiq7VRc7JZwzbk4uFE0l2alvL/UHgSbsYzZChMkLXbEs63apPE9xIdWeVVM4Tojr86/CJxJNyBccEv8dO9UFLCW7VPSKfHbmZGuOjFvG16mITIp9kmoGAeG8XWYyJgHqYw53acz9k8cH+uxetJqC6LFS3g1s8V9SBXckZUGLMQ/gmKMdIq8Bc1bey2zdw3+MLGkKIN7Xxec2+pk+oXbIshtOfo/0PQVNW3KlBTwM2MNl7cB23YB0tHCaizQernyh/1dBSJZZ70zrgQG3aQ38Q76gejbzez+ZC0O3ejTLNub1BMsMVH8HRpUv664JDhjlVek/Ll874aoHDUiQODidkhOvV33OsdUF3m55YYhxfQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(4744005)(2906002)(478600001)(6916009)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BRoWNBRpZkuGH0rIfAlaBO0GoPPu2tmRT9BXwCgTqDspgzmDn6rFg/TYyCRD?=
 =?us-ascii?Q?XR9e543zJMam90eqsAxK76fUYAnQVM908SENysWfBnBPSsmvsEkuO8q6jV+r?=
 =?us-ascii?Q?xZiaUd4JI1yx/jcO4S+iAIHuzo6f2ApPONQo7p2pHvvaGryA5h41T8VCq74E?=
 =?us-ascii?Q?NxxoJNP2ZOGZMJmgg7D15ROFpmsbxlMGUx1zI8AjKJnmK0JwgLNNZk6KkvaS?=
 =?us-ascii?Q?2AfUDxl2CddbKQRQtX+/Ie0SX7CzWyBwtGWynYQwAycAfuk2rh0aPctFsR7k?=
 =?us-ascii?Q?iKqpAMLUKWxSNYQbOwBFUE5yNBo4S+1HPBo5Uua6sykHpTWgcoCjQ7gLPwdV?=
 =?us-ascii?Q?rTtcSJt3FclOfTsA/x+rbNog924lg0TaCzey+Pf7cMvxIUd+apDcxxN7kouP?=
 =?us-ascii?Q?EEULNsXWvM5QnRVzL4EZFd5jm1tFrfP+f1+drJwqfrUIld+ZYEEyFxfE8eua?=
 =?us-ascii?Q?VgjxuDa5fLkUVcCRncRiPV8a4wF/I/83A2OR9abMYGAuybPftcEiP41a4WaH?=
 =?us-ascii?Q?9KmM1zggWQlcM/wX96d5uR8Z/IMAu3clmLYfherrYj9LauL8uPzSC5ZzeXc7?=
 =?us-ascii?Q?pquHKw3m9UoDqgf87w8orK9Dj3ZNylerNDIa0FWn/T870/0F0A944ercJRX8?=
 =?us-ascii?Q?+0WrW4pBk+S2L0I7XwR6VPhl9XDAeygtZz5vCgiQ8NFwDKkMUhgJfStuA8ew?=
 =?us-ascii?Q?5rkZ66rmVkmIohq/FOIt8xnJpImDA5Y8yQyWwA8YrflQGoIQ00miqMNQ5zt9?=
 =?us-ascii?Q?tKsTkbJzLzlTpe1EcUui5a+o15I131Gp6T6cZm1MDqELz4Nsba6Ob+riuwmM?=
 =?us-ascii?Q?Se06FmtmI8QHRWcf8Fq+GniWprebGdr8mCLqXDqPAP3G4XYDJSdS/iBos5KZ?=
 =?us-ascii?Q?2V9VYN2USdC/xxzXtss7H1+ktCo9qkDkSgu+ZFfh2HrLMLxoejyFzcF6PjzL?=
 =?us-ascii?Q?F38jhGA0uMs9AEw7J3CvLt0hb8GSeU87JIJZIuOh/RvUEwcmq2wdWhE9gZT7?=
 =?us-ascii?Q?oSj31SQTCZ/fQo+lst5LcEEukFwLr+U7hEi9do0ACio9QxnuoeejyN7H0KR1?=
 =?us-ascii?Q?SGk9vV0ifgRPt4i0Gjr94i/qxFCBzDtn7+zhAkFerT/I6w48GqxycOSepOS+?=
 =?us-ascii?Q?ZxqRrVgZ4iFQHv3jaHk/d13bevskQ2yxtplBJXtFlcxKCoIYVZ2UXoIzYQij?=
 =?us-ascii?Q?dIQxfhKovhhzq9yUOZB15ua6KT8Kedvx8S7PwE8c6iUKacVxbvtZ651LiQ0m?=
 =?us-ascii?Q?sP67xCNZja5Dp1HZCVs4QIKHRXHiNN9od3BscFTcMrTQL8ze4h+WTN8VNUyp?=
 =?us-ascii?Q?KXyzQqjSzRRFPkGI1Ov3bnKhxwlGUY6StzvRiUkXFE3iX+rgYPxEOevRYgyr?=
 =?us-ascii?Q?tjtxnIEw7+CUETYQBQj8ZPPjnH1MkUi+1nslkdWR2vuNpBsSAvGQGc9849wP?=
 =?us-ascii?Q?UtrVCVSpvumHePfVG0zQLKfuuLv2BOojvotKcAonTBECx9MpLzj4dc1p4BYK?=
 =?us-ascii?Q?dpZfQZslOTegfY3fralUBHxQ8wzndPvQIh7zs13mYF0hmFYUkj4X594Duyvs?=
 =?us-ascii?Q?1U+5EsHmSBbLBNCfqr/RcK9bFzexoHbVZ6iaZYya?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c80eee-830c-4305-3535-08dac0750960
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:03:32.8602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npA4aitoe7i9xFHns6yF9ZGdDwRhs+mMtA1rUGWb1pQ9LDxtMS9XRK5aFiUMg8E5mJ4mkXzQ/Q28RDo7uhitrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=945
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-GUID: lK20oK0adb_yt1PRNB1STmwr2Clkol54
X-Proofpoint-ORIG-GUID: lK20oK0adb_yt1PRNB1STmwr2Clkol54
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This 5.4.y backport series contains XFS fixes from v5.8. The patchset
has been acked by Darrick.

Brian Foster (1):
  xfs: don't fail verifier on empty attr3 leaf block

Chuhong Yuan (1):
  xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()

Darrick J. Wong (2):
  xfs: use ordered buffers to initialize dquot buffers during quotacheck
  xfs: don't fail unwritten extent conversion on writeback due to edquot

Dave Chinner (1):
  xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()

Eric Sandeen (1):
  xfs: group quota should return EDQUOT when prj quota enabled

 fs/xfs/libxfs/xfs_attr_leaf.c |   8 --
 fs/xfs/libxfs/xfs_defer.c     |  10 ++-
 fs/xfs/xfs_dquot.c            |  56 +++++++++---
 fs/xfs/xfs_inode.c            |   4 +-
 fs/xfs/xfs_iomap.c            |   2 +-
 fs/xfs/xfs_trans.c            | 163 +++++-----------------------------
 fs/xfs/xfs_trans_dquot.c      |   3 +-
 7 files changed, 78 insertions(+), 168 deletions(-)

-- 
2.35.1

