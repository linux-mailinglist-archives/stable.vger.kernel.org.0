Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D896DEA7A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDLE3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDLE3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:29:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B41CE66;
        Tue, 11 Apr 2023 21:29:18 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLLAFk005408;
        Wed, 12 Apr 2023 04:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=YofKBUOk9PSXj/j+L3bwE6+MdBcw9mffs04sVrPYD9E=;
 b=RHbuI4JvAI0dGwFYUcuPUXzLdpatj93lkaJRPEfvsXYjcE+mlpxDEz2pw1E1K/Ab6PIn
 ORKw01LT9ET9pwSn3hnIX66ZJ1KKq97x22BAA6x2WuKZcOJ4SJ6Q7mvzwTPOTJKiWWsr
 N0mWQSE8EyhUtzZ6MN6PSziIpyaQD8Fe6d/eFsJyjVtBznjb99+tKo9AbsIgdpFSd3mK
 hbbdQcrBj2D/G+ff0debSTn8i7mRXIHpCpxkmaYLAZKlM0Iz94QsIKM2AU5osy2Yd03r
 npbzpSQzxiCVhyABPkV3NMMwHn8mlo5/rqqMMCQPr9maOtqknRLe/9c3VdLApjH4Uwfd Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7f0mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2j73J030921;
        Wed, 12 Apr 2023 04:29:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbp83r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZdFsXFOs5FpBr264D8NahCs1oB5Zb9QHNydgXFj8hLmQxl7Zt3/OO6Qr7Zu89KUU/F/p+zR4VBS30tmf0sOnXGXzMqpyzNny26yT7aNfjoRgY5SMNbblohx1M7zBlrZzxA4gVG5HFDznbu0HMC4fBYE+1t9e+D+bsgiMPPLikS8jO8O4ZkUg904Ur4NTX8bB37h0XBNARNUjClVnLjMSSuaArJkiKuiLhFm0oqtM7fpnECkVPIaRU7mEbugVuD95xZPCun2n2DAtU3gUev/fYJJG38VovK7zazSa8+wF8k38MFIqs0gMwiP4hN9WelmCxeEaJjFNtOWK65/kCBTvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YofKBUOk9PSXj/j+L3bwE6+MdBcw9mffs04sVrPYD9E=;
 b=BKIM3NmUnV+07vuj2rKJhuws8K4pwtU4cuR3hP0ircGW1ysS+WLCWKMouNMJaxbEy0cTaZ8jNF+qhBESqDlnJI/L3IchgBKNhMAEIm8zgfShZ5GVAs4PtopEL0yvA8aVU0RFlaMng1mjRYLu9Tf89qqZDhs7uX/OqISgIJ9bTpmsXF5MdAR3l/HE4usrdcBryogOx1rEztj33pumLQdk/qR8Ml/hHKDGYR6gFI/R+ABSvsLakkNGc9JhXCR/9tTyrtbTLqEjxRBVPGpAQDGWuWvuWDTRYdLh8RdFH2Pupzmz1sFyuv0dEQecO2HfFl9B9xlLoa+LJLYxtCPOLTyrjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YofKBUOk9PSXj/j+L3bwE6+MdBcw9mffs04sVrPYD9E=;
 b=S3MONcepp24MXAyZplN3XKLq4NdD7KAtxQBTvCSa0KvnncjA6O+I3B6pzl64dacqNm3ohDHKC+bgOxJ+NO/nUpqPKznmaMe2mu/6Lbjgts8DpC8Xo2cpt+18npRKRRZqNNSrmmB+bEviErEPcRxxZh9MTYK689MeHeo35C+F5pg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:29:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:29:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 15/17] xfs: consider shutdown in bmapbt cursor delete assert
Date:   Wed, 12 Apr 2023 09:56:22 +0530
Message-Id: <20230412042624.600511-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:404:15::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 72bb504c-b107-432b-df0b-08db3b0e770c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScEHlfC+eE2AcnTC1AV+tV2lY+2NL9R2rx8obvE9TF92DohHpnj1MBizrKyiZ08/Y6UPhrZYJC925mRwnUzf2iBw8ii/Cdjb80LKt8vy/uMSvRrSsV/gEekuK2laNg9DTQ6tUujwtioYu6cLxSiLmUgAfCDih6buUWkgwOQlVlMZzEBR7rO2LEyaxPVGdZwcEnBPupDewKxI9eQ9J9R9xQz0PjcjB39GV62ZSlrpwPBwsHGMp8cOQS79DTyVHBNAqIBii9du6rmCeK7AjdWzPOe4oE34IONmR0Co7rA+Qz7AV5dGFf/eKrinsDIIYMRfRKFGAdBK0ZBUAHe+6q1+S1g3WaaKHoY+zkEiANK9Hyfx+J7ZAdHD9mWjTMmUHfL5aNkQNgGylWWSdL37cAPDZM5QPHki2A1xxFXHIilIWP/1QqE2dQBi4EQzyOkqbet/umSO67Iz8PTwSNi/0LyIX2gIoezo1SFsLeb5f+2DHOd5Kzltvb+ChjfWnHLbjP8x7kQI0J23ifaAqCvJUn67Nt+qge2g2kdlFVe16iEwQl0nUplwkZIVWI4ZNhweLCIW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(6666004)(8936002)(66899021)(6486002)(5660300002)(86362001)(6916009)(66476007)(66946007)(8676002)(4326008)(66556008)(478600001)(38100700002)(2906002)(83380400001)(1076003)(6506007)(6512007)(186003)(2616005)(41300700001)(316002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VXF5nKKi9u20+zD632OSWTrHks8Jku7ja5Tf4NB0c0B3DJT6/QjdxaALAIo3?=
 =?us-ascii?Q?i4fbRG7Gj24Zjr0fyFkjm4zkLb7vr/zYIGC4N+/qBmhfP+Y25o30+b3aG3AX?=
 =?us-ascii?Q?65LIE3zFwAb4ermq/E8bBEkoU0vdhULvYPK2UJG0DA9QUi7u2MR31H4Np2e+?=
 =?us-ascii?Q?1E+j1EDyN82U2QKZNV4mfnOt8ayYr18wrtAkzEtehd/86NFxXGD8fR2usDhG?=
 =?us-ascii?Q?1v1OP5tSB/tJXQwjwUFfqV5JEmysZyrMNk2Kza4ZoR/0xkOWXGqPXSlE8DOn?=
 =?us-ascii?Q?9k2ZbdB+AuAA+EWfZsBusFTd1TtknKy3uWOd0ZQx5Nruq2boW88c0/Sr3L+G?=
 =?us-ascii?Q?k9mZndoTZhFM9K2VYHlB5KyH5hLW6EGOBmW/zI/MrSJ7JRjX/so5ztlWjqGo?=
 =?us-ascii?Q?+kDDG8XSp/AKW2ja6gIezFcVrAy2MnrKiOcT1Q3yns1KDxlg8t7+U/NWgpF4?=
 =?us-ascii?Q?X/JxBeoQpnDE5O5XZL8L5AeddizbKR6+uaErUgmjVhhoFYj925QKXdSCcNxG?=
 =?us-ascii?Q?WdK8QUrnVEhR/oZSVFWdO2wKU4fsa5DrPTKtlObUsfXgp1uSWIJc+KI/Pkvo?=
 =?us-ascii?Q?g0/RG2ubSBqq86eJfMG7z75ae0DJQSa0xsoeUsKHhuhFxGkRMyc2mTGftjPq?=
 =?us-ascii?Q?IKrke0rSSnvhRLEMOlO8EDJ2ei7qvCiSjMLmY5KoXkNbXqSqKd2veguWGe+G?=
 =?us-ascii?Q?wxCgvCv4Ad8AJhamE+Rnj/nZLU1P0nkumMvV3Rzoo36hQCYao448DiLj0PNt?=
 =?us-ascii?Q?qIp+GEDMy/p2sqIK9wCOwRZQFoXSrKjCWK2Dj3vBsNSYL+3AOauMVW9+irsa?=
 =?us-ascii?Q?XDLBzQg2LgcD8L9PUfqi28blQzShYwtIWJoEs6b/VjhPA3ZbksvNS7s28Esp?=
 =?us-ascii?Q?pd/cofwKxb1srPuQwaudyp7Ewuf00n3GBw2spyW2y0XKJrQmNzlM+ZzkZQ6v?=
 =?us-ascii?Q?IJHsWvB5Caq2u4gOnYD2jtj9M5tNRzObwIlv2J7E5ir8z/MkJks6KZRiMQfb?=
 =?us-ascii?Q?gjGN57I/wwBBFld9S5mhxiimArzfh3YCiARR3z5UBIcaXyBZnTabWAx0Anil?=
 =?us-ascii?Q?MlmnKOayo9EScrE/w/e+IxGJChJWVWLXaSru3my7ABIo88s04tGIJsNoNyV3?=
 =?us-ascii?Q?MD4ud6fO6xwCwrBFxc8D57CTiiFq/+ynwhoj0aHgrEzf6y7iwbGapu7ZMeD4?=
 =?us-ascii?Q?6H1A9XI+R0eqGKV2uSTDskzksdsH9LVf8DhhAc4YgesNsIUqtLbabqVW2LKY?=
 =?us-ascii?Q?Tb7EQJ0UL8pElIv/j8N8cCOOp5PbjINQS8c+tlZCN7oQolXVfP5NoKpue2us?=
 =?us-ascii?Q?PwimHP19Om8Tgg0C6CDjyKP7v7tO2aWamMsFrbyNTS+mYHLdNnE7CKLQIFAj?=
 =?us-ascii?Q?obA0pvrHBHJj7MatGAmB+zDlDQeDBuKLIm305itCQ++YjJzggmoGixm7IvGq?=
 =?us-ascii?Q?wp/bJlzj6j9AVNV/JZwATNf/zy4sIfEHvMkLTiqxYX1Vs1+CkVNBcWPSVkyT?=
 =?us-ascii?Q?zPc5FsyPomZivzscT8q8rXRmaDNVzVvkr6Uq5JFAUqPeXXIcyfuFvD2/MY33?=
 =?us-ascii?Q?ldm4LD9uXy1PeWZLGW9jdIfFtPfLyT6Onlb6QSRSUIPRY3f83330FXr8Ro2R?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XNLCD7LARF4fmWtHvjP1bc00pdNNzuzIyy4a7WcdE4FKKz+wySplCZlLDTx6vwqiPGorhdZdJGQOgf89CWnyvFchvX6cmV9aaKv9cEAZGYkVdR/ukw9DUqMrBHEkzSVKS5GWSuxae8jvNtYMn63km0d7BExJetn422/zCQUXE6Tun9aVJj+dmEhHsRYWc8sDgbJTOnGghE0Yo3Q7CF5+c41QBdStRUdovLUAR9tezU0kUHizJ5ZTCusw82cWEyJp1zDMew8Frl7mr6qe+4xczCXHAO2KKkiiOUwlc01hNvt5fna+8L2C5tYnfU5jKWmjMEVb3hpnz6DjgEI8QI1KWq1SNfmIFlP3YPBq35d6DXoQmJueMlnTzDNRP/LUo0mcYTUwF+Ac/V8efKdSp2oUm+Gk8IYQ0yRFpGcUMxXlOPzZPO/ZVLx6QESde6oiNzYgWhln3R4aJifu3ngSuLkwTDXSlIK2/kD102cdDFalCw9SUYPF7aWHSsZJNlLcHzIR9oUbNvwxWHtKZm9ffXFo7dOBW8a68Rj/dnifAIBHG0FCaOk3FnaZvSaPytolFMNCKacUJRc1tZBOo3CleAFCfsfyVA/F4wX8sbForo3mP5CFHrXHHZu+zK9I6SbwaDJD4R7WWsTwO6z1lmS9AzbJZu/7Zg9QQCcg978sqMYtf5rEXk6jgSkoDhPREVEGV00BOP4o8WlXIHn5YrEjwCtlYWAY5bBW3dJwXAlbNhB1nzDa4ySYpRMs+mGtSrTsi/2DX9Epx1eN0jXilumDIHykk7W6vrg2he+H0YsCdN3/fLxSpFSw4GqDcJL5fQKEs/VtLgJW8+5pjw2Qp2bELG8UXejc2HNkuVTEVVr5bSTpl2jtPw43WNN8yWi3W4RIjeki
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72bb504c-b107-432b-df0b-08db3b0e770c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:29:11.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ke/Rk1OMe8nqV8Q4mla7wqqpJO9qN2yyfJU6BsbSGmwBW4F7cGVMD1WingxiIlRprrvHvjCjmtj1ysaxl9R0vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: id1pZxyEZutcEXDrwvoSjR_RiSq9UGh-
X-Proofpoint-GUID: id1pZxyEZutcEXDrwvoSjR_RiSq9UGh-
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

commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.

[ Slightly modify fs/xfs/libxfs/xfs_btree.c to resolve merge conflicts ]

The assert in xfs_btree_del_cursor() checks that the bmapbt block
allocation field has been handled correctly before the cursor is
freed. This field is used for accurate calculation of indirect block
reservation requirements (for delayed allocations), for example.
generic/019 reproduces a scenario where this assert fails because
the filesystem has shutdown while in the middle of a bmbt record
insertion. This occurs after a bmbt block has been allocated via the
cursor but before the higher level bmap function (i.e.
xfs_bmap_add_extent_hole_real()) completes and resets the field.

Update the assert to accommodate the transient state if the
filesystem has shutdown. While here, clean up the indentation and
comments in the function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8c43cac15832..121251651fea 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -354,20 +354,17 @@ xfs_btree_free_block(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		error)		/* del because of error */
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			error)		/* del because of error */
 {
-	int		i;		/* btree level */
+	int			i;		/* btree level */
 
 	/*
-	 * Clear the buffer pointers, and release the buffers.
-	 * If we're doing this in the face of an error, we
-	 * need to make sure to inspect all of the entries
-	 * in the bc_bufs array for buffers to be unlocked.
-	 * This is because some of the btree code works from
-	 * level n down to 0, and if we get an error along
-	 * the way we won't have initialized all the entries
-	 * down to 0.
+	 * Clear the buffer pointers and release the buffers. If we're doing
+	 * this because of an error, inspect all of the entries in the bc_bufs
+	 * array for buffers to be unlocked. This is because some of the btree
+	 * code works from level n down to 0, and if we get an error along the
+	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
@@ -375,15 +372,10 @@ xfs_btree_del_cursor(
 		else if (!error)
 			break;
 	}
-	/*
-	 * Can't free a bmap cursor without having dealt with the
-	 * allocated indirect blocks' accounting.
-	 */
+
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_private.b.allocated == 0);
-	/*
-	 * Free the cursor.
-	 */
+	       cur->bc_private.b.allocated == 0 ||
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	kmem_zone_free(xfs_btree_cur_zone, cur);
 }
 
-- 
2.39.1

