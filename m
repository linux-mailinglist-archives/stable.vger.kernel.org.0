Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F2C698CDD
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjBPG2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBPG2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:28:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9203B3D091;
        Wed, 15 Feb 2023 22:28:42 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2JLcO023440;
        Thu, 16 Feb 2023 05:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vq3W1bIN6r3DXh4BBJruEZgr7KXwQaKmY8/Tmf40B5k=;
 b=CE+8m8F+CiyGMt0fSmgm/uTB67c4Hhk6Ak5HbgTSOckvkWmKqlooNRV0427xHN18meQI
 CeWYuBhedMpynL4qTFLwIlYmTtftyedXWPBb4tt5yeVNbE/o3PK8Z4s+GYkKNqtI9QZ7
 fQ7BE26Xja/eSpxxSrG9KoeSW4i5b4nandoeyQ9m91F7QkyLCIt2vab4Cm9nB7S8cu/L
 XWGBId8KqUmWqjjCkLxCumim6STYZL6AX/6FjZiwZwiDEMVYqknkP0DWsTM7UooMf1LQ
 mfuetSqZ4ChGI5JMAfZN/g7oTovBaIM1gxa0QbEwmVHttHubFokAmi9NjShSzfRP+bUZ 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12apr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G4ft2i013591;
        Thu, 16 Feb 2023 05:23:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f7u3n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlU4GpfRONJtrr51KeRcQ3ny0WaAZlvVvWw8++Ku7lJVkVbBJ5kR1irW+MFJKGC+DTbE0mqlAL6+BXO6B9JubXAaL7Ld0HJP8Y78fU9JzVNKldaWnRjvmGrqB8CtAnyYDXbivi1tsao5zrzTNlICzNNX7anr230YhivAphhBIp9WgqCN5E+67UfJCioIev0U6a3SISfVHZZpuYpwJTTImbfdYkESwMFqCJMzlD89h8ak9YAu8vMWpE9ZNo7yls1+mHFWDUxWaipsFutvlmfnMjfTfgkpTsD23M4rMpF8nJktAmZl9SNNax/mD3+dtTrYZ1f/t5egv//qzeRKlDvqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vq3W1bIN6r3DXh4BBJruEZgr7KXwQaKmY8/Tmf40B5k=;
 b=YNpWTHnPWBYmXGOuK7XMwGWDYYnFQqIw/yO0fef3uoXfIsVSel6uNU2BvXREfC6IGIInLgfjzTcwG6vIN2mD0URVvTKihN+KpPzRvGMQr7wuYWL/eIl52XaAkf+jn3pR15V0ph+K2lrAS3PAbWjqkV5uK670KyLjbZ+rDcfMBRQIuYzmfFR3Sm9x1o3XBQMPtpO9RrHS3+iMSNAHvy2aFB3VCxziovWii1SUG2bDtradm8ez/8OAV4XQPiyNcpNqMtr5DB2VLw7tZwjecRQH9HMOFUnV/NpiNxPuGbwgApSgK1CDUL0Z/emx4aHRYg/wUQF9QaFK4kChc+pycikIOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vq3W1bIN6r3DXh4BBJruEZgr7KXwQaKmY8/Tmf40B5k=;
 b=THS5TzOJa3QOhXcVJ0ElWJXDV38sUhcU8Dj+pUHThx2/Ra3f8BocMKlCIEJ7nFT9o2XHXDs5+bKCetqKfs1wEdk4zd2ekjjSSffLBVBU2zSa8+lfBvJw/X1RGaaJhiS0IIusRzCtquOWuw6+RUCQGYZIT9hZPgl/l41IU1pdH0E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:23:07 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:23:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 22/25] xfs: ensure inobt record walks always make forward progress
Date:   Thu, 16 Feb 2023 10:50:16 +0530
Message-Id: <20230216052019.368896-23-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0114.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c9206a4-7267-4ba3-3e2f-08db0fdde30b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +XLtU2NnreL1+wn866WokT8JaMSdvDc/WoOBGvx+E3/t7GPvoo+53/ArgcsF15oNnaunfEinkQ27sO7o5yAr11dy5tNGdP66LW6PV6O7Nc5nlRNDiWqohk7zdd5T+4s2t/NjZFA3bPz/Y040kt7WfpGZNggSWz2PjoJ3opDYYrMGnNzh4uYOVygrIO/ByflEgUZUJQYwQzytL2h6gh1uhVKk/9zU4wVQHE+tSYNawnsFrvBH35N4g8NXq086iy9umc9VbGKoPh2HDduo+2uRVvzNCdESpyOWjAHoqe/yeEd+aYBWr/0iLY2B9g/4BCFA1+kjJDxR1E6b+GyYEouiibmhzP4fxUQ8iZ9zRGQvC6TSWcqERbaedoigKcCWMXZuHcZ2W1ZAcSUIMUkxQdahYf6TIRZD43XwPDx4gjx3uVnd1TmW4tOPsHe0Lc5nYroAnvUpSMeo7xF9oBD/OYyJHj3ivm5ZhxkrBJMRLF/oSDOI6EwyaNYmDhypFGLqik7dJ5B5gXjqEMTm4ljw09aIqhsS8TeRXAJa9oaHd6CSx7dOskfl+yufRsMlyDztQpRytls51zt6a8SaNlGK+0PoPDBjOot3uGM6oAaysR3YlvH7GpYfaNMhkD+LwqXXQhQsJTktcYPw28/3KjQwdUnwog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yquEiXsPXAAbwNo7bXsm03pEA6ZjwojicQlCVX4q9XhhSsChrIsdPSGTgcNJ?=
 =?us-ascii?Q?GhiUIgJIjVffAjTJAtOstxHhxe2hsA7GlwfaCvXQiCqDEYdmLAElleu9M/I5?=
 =?us-ascii?Q?UkhTeI5UMsPu6omrJbqF4JY2HqRUXOPBF0aOumDut1rZmao4sbxbj9j1mKSy?=
 =?us-ascii?Q?OS4O6PffTNoQ6enxtMjggUXS33tJVDtlEahx9aMwb/38WJ3dsXAEcDSJk7Oy?=
 =?us-ascii?Q?VczF2tt3wilW+uulL663CuWxP4zgIx+dM2oRoPIdkgkXXQ/yDcQh+fIoOsX9?=
 =?us-ascii?Q?A6EWpI03tNHrHgbomw26T6ikgwSnd5NhSrMCof8A0k5Yqr9RTN7Wi6p4QPuJ?=
 =?us-ascii?Q?NNk19zwpJM0w23jgpHEFJE8LS3ItkWPR4aAdd4l39sScGT1rykkq6fSggp3w?=
 =?us-ascii?Q?OKAGP9GKfijd+iAJaGaojbCKgO3JdYVHss3EYcaM//K74nB1xv3IVzTBssqp?=
 =?us-ascii?Q?tWkk99VN4rDoU77xT2meD9zk7HPUbHSQELMNmKLfHp9mrx7MSe3gZKic4IQL?=
 =?us-ascii?Q?4jHTkccOCNA0qY2CLbBxSbypIZDm8gUYxuF+Af1o2JB+ZHtpx+s3exFSyq1d?=
 =?us-ascii?Q?r9ZfzrOu5oqEymM7ZCJSvw1ZJfyAabzDJxQghqZbQPpKzAQ+UZ709sMFQShs?=
 =?us-ascii?Q?G2D2Mbf5XtEPe3HRHn+OBUPPJ3/fqU0ARsgKhEku/YwzufJ792dGyXQGjVT9?=
 =?us-ascii?Q?dooiGSVfPAD/MmGkIwqXnoxGzbR2zDEs/QD6n/tlM3lBbBW5O1ggqcglKpIC?=
 =?us-ascii?Q?N6H60y3yPtdR12A95SujFSazKnJ9qSw09dXz1ARh0LQD6hPsXDaGL1CahfRP?=
 =?us-ascii?Q?C26fDvavas3xxu0LfwLGmV89Vi+S0HFVErRo4G5YlmzqDVaoSiQ95qCmix/R?=
 =?us-ascii?Q?fZtPPelI3w3ho0YXKkfnlU9vWt9INgaiXCHTdi3btUoVN3NU8qsgzeiFKah+?=
 =?us-ascii?Q?lbGyE+wLTA0J7zPJ4WrLiR+RgR7HRvWLjY9+ms2guFWdj+Rjt6sKu5ZKtMhU?=
 =?us-ascii?Q?sVcA43Uc3veDxS+/HCxwhByPP6oiEHSlg6hE+ErW8rw3tP+LbvsOxRwwRnzQ?=
 =?us-ascii?Q?6WeQt6dki0RlDIOTqhewsJJ5ClKxvyRbmeyJbIK6iCxmYMbWS5iBZxJW519U?=
 =?us-ascii?Q?x+EEly9OtSr55NakwzebHak6PkQcO4jEXRr9ySKxB7pDca8fuPdD++zjxQ5D?=
 =?us-ascii?Q?bQJXwE8bVr7AjEoQJ08B4z87DYdcpXUn7nXGLElpmYAo4v8/i+WCkioL8R6Y?=
 =?us-ascii?Q?JfVmba0/ZrIiNGGLtfF5o/8lXU0IpYDaab55Q6nI3L8QeknEh0rpcweSavjo?=
 =?us-ascii?Q?PTphaEjJQY3bIiSH2y96sQckniwUAYymjl41KQkcylorL1zcZ2MRH1YB+T3H?=
 =?us-ascii?Q?X3IP/W1DhTwQ9hCRRHdF3sBWdqjVuRujOHTffk9gpnMDde67KEwWmWxj3nrm?=
 =?us-ascii?Q?4sp+rfcWQOFKRNw/jNm2+cVwOK8pYTXuOD2JtXx6gTfbcONlY+7aDBTY/SmX?=
 =?us-ascii?Q?EZG3WgUN4hqzFHSEQxxfpXOvIlu5A63z6Y1KFv1niiekvyAF4mWiK0dNBe/5?=
 =?us-ascii?Q?w+JUTf4wDAXtsHbNKB4i5WyvWYAvqslQzSUBnf0jAgcUHyy8Mq0E78y6aSnh?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5l7qkZMxDXsFnwnSSz6ET4vwiSR7PhzCuAycgdbtR+k+wS4Twj5uPs3hudEwDKIeJN5lqNRJiOGrMMcu+kEFFAWqs1VC6a6lTUEUan8KLkUHpDW039tLnLw3XqakpyxS/iPl8wY/5RUbx0SJzkbWmoWRXzIHVVc8NY2PruF9QV24D3tzngOBKIVOmm0bN3pW/gDay4dxml9sqAiv7wCayq+wkGYlLz141Q4rQxEambprqlirpwVSnHIT3Gd/A4l2/WTV5VvNxJ9pZqAfvzgdEEhtoJx3+Z5oG/DEd6jDOa8qOSBtnhqOk8zGDFmt/2efKSsEnCT5TDTDOu7lF0YaeP3vYET0hGVyelVZWL7EFIFDE+7+pFkE8wrJ6r1P9NMeFoySFVjmmGhgQkzMJBTNeTV8zuzgc5RNqeIikAjYPhkZdgszepq/t2yOrVhFc8heA4Jgbr8uHd/AH0ljQoh5di9Lvb/EoLQFZmkD4EM1jyD361QNQqzNaZCfuHNE6cn2HGj10i3MFUZ63GPy8mZXyRiLylTBXbv32A1yaS2CzremojCixuPpfQS3kNoHi4e0DdFIhcgQL80diESuJ1B6CM295AqY7z660dXIbmetqppxPuZR2ODRJEYX037bAmHyJHBeWjhSMq4U1oOWEul9PgjNHjYnYxN9wS/oMQ1NK+2RLVAPDNZUlC1M9LsOhWjeapZdh+osQKJwO33g/lsKBnyAAkcUFjI/MpaFNrvCiwfGgGzvZQMu12K7yFjeu5rOgu5+2HC+tp7mkhMBmHQ5QB/oB2dXTzBwsQm7xOGUvucPkuBlzotTJyjfjDnDilyby0R/296o91gqzK9CwA3IkT91xu6PpvucUxA4rDM/TrfcQOwnn4pTNcyzYVpkx5VY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9206a4-7267-4ba3-3e2f-08db0fdde30b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:23:07.5504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWDJBj6pkiIH54/YbmQ3MMTJsE/pXhl5Tp0JUPwSTVn7SnyDM9Hg5nVAyKA8PI7NYnmyEuokJ4155BJAi1MJqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=867 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160044
X-Proofpoint-GUID: ehLeeoL9KQ3eo55R8a-lf322GGTQWEDN
X-Proofpoint-ORIG-GUID: ehLeeoL9KQ3eo55R8a-lf322GGTQWEDN
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

commit 27c14b5daa82861220d6fa6e27b51f05f21ffaa7 upstream.

[ In xfs_iwalk_ag(), Replace a call to XFS_IS_CORRUPT() with a call to
  ASSERT() ]

The aim of the inode btree record iterator function is to call a
callback on every record in the btree.  To avoid having to tear down and
recreate the inode btree cursor around every callback, it caches a
certain number of records in a memory buffer.  After each batch of
callback invocations, we have to perform a btree lookup to find the
next record after where we left off.

However, if the keys of the inode btree are corrupt, the lookup might
put us in the wrong part of the inode btree, causing the walk function
to loop forever.  Therefore, we add extra cursor tracking to make sure
that we never go backwards neither when performing the lookup nor when
jumping to the next inobt record.  This also fixes an off by one error
where upon resume the lookup should have been for the inode /after/ the
point at which we stopped.

Found by fuzzing xfs/460 with keys[2].startino = ones causing bulkstat
and quotacheck to hang.

Fixes: a211432c27ff ("xfs: create simplified inode walk function")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index aa375cf53021..1f53af6b0112 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -55,6 +55,9 @@ struct xfs_iwalk_ag {
 	/* Where do we start the traversal? */
 	xfs_ino_t			startino;
 
+	/* What was the last inode number we saw when iterating the inobt? */
+	xfs_ino_t			lastino;
+
 	/* Array of inobt records we cache. */
 	struct xfs_inobt_rec_incore	*recs;
 
@@ -300,6 +303,9 @@ xfs_iwalk_ag_start(
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, *has_more == 1);
 
+	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
+				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
+
 	/*
 	 * If the LE lookup yielded an inobt record before the cursor position,
 	 * skip it and see if there's another one after it.
@@ -346,15 +352,17 @@ xfs_iwalk_run_callbacks(
 	struct xfs_mount		*mp = iwag->mp;
 	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
-	xfs_agino_t			restart;
+	xfs_agino_t			next_agino;
 	int				error;
 
+	next_agino = XFS_INO_TO_AGINO(mp, iwag->lastino) + 1;
+
 	ASSERT(iwag->nr_recs > 0);
 
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
+	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
@@ -371,7 +379,7 @@ xfs_iwalk_run_callbacks(
 	if (error)
 		return error;
 
-	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
+	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
 }
 
 /* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
@@ -395,6 +403,7 @@ xfs_iwalk_ag(
 
 	while (!error && has_more) {
 		struct xfs_inobt_rec_incore	*irec;
+		xfs_ino_t			rec_fsino;
 
 		cond_resched();
 		if (xfs_pwork_want_abort(&iwag->pwork))
@@ -406,6 +415,15 @@ xfs_iwalk_ag(
 		if (error || !has_more)
 			break;
 
+		/* Make sure that we always move forward. */
+		rec_fsino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino);
+		if (iwag->lastino != NULLFSINO && iwag->lastino >= rec_fsino) {
+			ASSERT(iwag->lastino < rec_fsino);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+		iwag->lastino = rec_fsino + XFS_INODES_PER_CHUNK - 1;
+
 		/* No allocated inodes in this chunk; skip it. */
 		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
@@ -534,6 +552,7 @@ xfs_iwalk(
 		.trim_start	= 1,
 		.skip_empty	= 1,
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -622,6 +641,7 @@ xfs_iwalk_threaded(
 		iwag->data = data;
 		iwag->startino = startino;
 		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
+		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
@@ -695,6 +715,7 @@ xfs_inobt_walk(
 		.startino	= startino,
 		.sz_recs	= xfs_inobt_walk_prefetch(inobt_records),
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
-- 
2.35.1

