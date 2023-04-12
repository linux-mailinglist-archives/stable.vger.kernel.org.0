Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985D86DEA69
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjDLE2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDLE2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B1B5257;
        Tue, 11 Apr 2023 21:28:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLWEfG016806;
        Wed, 12 Apr 2023 04:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=mZsG48Uprx1Vcze8tF6Dx4M/tuJtysWoG1ltiBq0diA=;
 b=fr8H4HD3GekV+H0O+nsCeAHdd0DdOVe5vMF/lwn1GXJ5JEgBuVSadtVzGO2UjvVqljNf
 /0G8lFDy6iQeD+cI18z65jrxo8+OCOsCKK0eMIfHE8+Y22LiBMPmYCAeCSVHmc8QaCQT
 gjiJvdaAIUg0ujIbPIJtjVQX+zFb0HZZ/kYugOJ0pC1MHG02hrRvka8RA3MOmQBTTs08
 s3vDGhOskil9OO4m8DnnfFbYf0lSYyFtjHh+/+nSg1flRi/+aH6xkJ9nWZPrS5LtwyAp
 7NLgQxi+H4dh1dWWEqqui91ORZKNre3IYgQP+BoOvzmPo1hsMQt3NIJ6q+sNZsyOkjGu KQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc72rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2UYlZ008038;
        Wed, 12 Apr 2023 04:28:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc590vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5xUtYJMv//CcnhVdM3o7h3/rDL60hoxTB7pKdQr1X5K5TVXUkRd+DUxSRo1mWecpKJo2hXDtzdowPECFFdEsyXuToXvxRERbUYP43tUnMR3GFipLpOzBmw/pvHMKYPZhZA9PyYk4ndNg7tC42SJYpzEsBQK99fWy4rJXzHDvNisFsGpn311o3H8CY2Nn46aehpr7cUPSTu068RiBnoIHob1yB8zteMyq6tT80tmMCQYEU1N0CsvpqFf85NY4fPE0lGCXLO1zRznIUDLfVjAjF8LEPK1xhVa2ifhi6nedl8SqlofGIljJPvPPtA7l8w6M9ogOYTsb+LxauaE4IC3QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZsG48Uprx1Vcze8tF6Dx4M/tuJtysWoG1ltiBq0diA=;
 b=EWO4WNuqTmBD0qJlgqLpT+fA0DD+7jJRjHIqgMdxGxM3SVzUtDeCaEVnKUxEWV6oeMir0vYx0R560cuNB4SJkjntlDDL14pxpshfqsIPc5FzOG+j4p3ePnSeifBg0sB1jh4U6s9xP9UNnIMOjVa61AKPJShYknLHCI4yhEJ0ATxAwqVgbV1uIDwxedhX/HAlig9iDmdjahzh28mMKpR0nmtC8G/QQ/rKagaVCwij2lII4hxTRYRy99Ix5OJi1ygAqdErYNqhox5bNcLc/HnqzFRDy5gMPA44rYE1LrDdC+o4RBXn7M0nTYPFRxX0ybPLebMzjwcBEJ9QYvM8ZzlURA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZsG48Uprx1Vcze8tF6Dx4M/tuJtysWoG1ltiBq0diA=;
 b=UCofILIzRWBhWoww0ssm+3HOVZmTywGB2wTqVaG89e0uCXyR8TuyViq6As5xKzRbdMphZecpJNyCK3pQH9Th2XRKeHsN/FnnmneUAbYSTVLu/s2SUueRPcCvXH7XzMIfPqnGnjRq9eRYzPilITpP0bPjDRS0hP39oWmcOwvhn4c=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 06/17] xfs: add a new xfs_sb_version_has_v3inode helper
Date:   Wed, 12 Apr 2023 09:56:13 +0530
Message-Id: <20230412042624.600511-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 525df732-9df5-4b1e-47f4-08db3b0e4ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMlZyAOIWDRX6YREv2g+XbNV5TccVErVYyTNoHQaI9tCQW+v+l3bvGNheZjnJAAdaruGaLGgxF1qZwp81rf3st2Zq30WNAc8xzUHxP+pQuo1u+yGrGwipL6gncwvQ/AteVHHTFJ+NrZsbpyATXWvuta3M9ETuU+nhDihY0f/NUhSjEY7w6rj6VqoXkbXLSByfAtEmJH0Ao/ryBmb51EXFNrWFG1nX1/5GA2WkHuKK8SOxV6CdRJtyNNIaGiinjZwINloCGrlzJLIm9Z8id0rPBXDA15+mLIOlz+MtEnxw0J8QptgePbCFXfRke4feyqPSAmiI/NuXlwGQk1+/T6QI69KnLY+kzpq4DSlCoezcJLu+8mf/FelL8id4Fuyt6sGuSXc2qNQKHJ6KN1oZyWoblnj3BNs5hiIaVZ77Yn0N8Tw4E71pk02xZgEcBEKryMotBSwQhARdCFOA1BnD6Du6JzJBCXqeeiU/Vg/QgdVBPRfd4GkEufQFGheUcOXMO2OYoxr436mVGuRzho+KtWYVAYqcin38iQpHxEKhd9BgEadDHq8CFsiJayuo65koWAN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(66899021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+qnEPLvWmNT0V38pOWUeVJlZeDHaPtdIGHGTWffovZMF5VcbA0koPXCeM0MO?=
 =?us-ascii?Q?q5jgL5mSDyW09jY0PdjFF+bhbK1FrTJC+DrqgDUn6BaUsV1Fmf613Vj3OUIB?=
 =?us-ascii?Q?8xVaFJdERNQ1L5gmfTT5Cyv9FTfiBmVMsoElRS7QnaOkLnu1HSh6II95olCn?=
 =?us-ascii?Q?r3LF0LQ+PLqgITcZD3ISbEi4/n9iHJxgn/jlJzVhO9wAYDKjyzCCEirKH27p?=
 =?us-ascii?Q?hIZPtCJFP5c4DKUhW9+plo2xgAxRX8H1qkG3aVVALlu148bcf/gYZRWDCxxa?=
 =?us-ascii?Q?iHrPyYVzTMb7okYPILu6KWdPMVKgSy80JmEhMaFzt5h0XLoMuXwQPpEuiMmn?=
 =?us-ascii?Q?PY4MUrKoIi2HxaHufRQEM3LuKxgDd4KejjQnxm1E77pxO2X1Iuy9x3ue3R1G?=
 =?us-ascii?Q?+c+CDN7xD+gJ3EsdRLbWFOYWK5NyO+Z4eFV9+7cxkC5B0w6WzgzcLVWkt5gp?=
 =?us-ascii?Q?6p/XALPFKPJnDcj5vtEF/1Pixp3biELKom58KBKjX0sC1pMkGhb2LxDACrmC?=
 =?us-ascii?Q?6UfcjfTDmvK+SjYaLomYr6OHj1jwIDdxeyMjRjsM05Tk50GKUfdJgZGYwCh/?=
 =?us-ascii?Q?Mm0k1ygcJFs/VSpqNFYYo9RDOV5tAs8FiU5r75y8QA3byoniM3D1rMgwXLpn?=
 =?us-ascii?Q?cGQMHBaGNr33HfBPV3yVhG4OWm+g1TFihQjBQ3uMAj+KiWw9nWO7zXrFH4IL?=
 =?us-ascii?Q?Phrphy6bCSTIeR8HKCni6eRDM4u51JvvzOIOcUXh5/89EgvfDXJDvIoMKxvP?=
 =?us-ascii?Q?BwDTaqDkHAaFmINCZGoR0HoXQfRqVlNwcYzY/QcPy6utaUsm3AA/Hw496Tf2?=
 =?us-ascii?Q?BnB5I6/O19UXQcl7WXm5towrgzE0pEcmFuJxJengNmUMLNzTWO8L6yX4Moav?=
 =?us-ascii?Q?BCnCGuxvH1QayHpSJZ/3/Ble1qVhP5Yae6HtfqKrX0eAIWn7AY7EsDMgvDyc?=
 =?us-ascii?Q?L1vB829GOBBKTEXyBks5dttxMQh4JfrxvGNsnYqzNH7A6WgQG2N2+Y6JcKZt?=
 =?us-ascii?Q?kgfcV4nJWAlKuXl2BXkFAlCN9i5/KfZ8W3wqIiwucYiwWNriYvT5eZB9UTH4?=
 =?us-ascii?Q?jTrRIRmvzC/+6wLBn4PN4+JOoyOtCzZTTsuyzNPqFTci25mvRlfW15xctg68?=
 =?us-ascii?Q?oltqpZz/Nrl2ZHCXMeF5e+xXyuMpa7sQYwab2OFlboiCcy0dMLn1seUAD1ek?=
 =?us-ascii?Q?Wb8+zzkielxBJbO691SudxnQ5scacOEaB6JrlwFoOKK1H0TgqWlvCE3IcNEr?=
 =?us-ascii?Q?cAj6EbxKyOBPuDI8Jo6lOSpj2qIIwWCl7wdqv/AB7jRMwXsAnzXGGDCEvqDV?=
 =?us-ascii?Q?RGJX/5Mb5cRYOmGZDl2NZCcjiAC7Q44wm9Jzt40EY1TgITwm7M6ay6FjwijZ?=
 =?us-ascii?Q?hVjfM1OAxsiI2+1tpEaKZaNH28hiY7lDJR3NWuK7n760ZhMZJa0BmjRoaHrq?=
 =?us-ascii?Q?dfwYFd5JrFQraYDwwyG+5Uh26nEtge4hJjq+AFBTVqH1l7BscHCxdNXjfyoS?=
 =?us-ascii?Q?ruiYgFXyCQm30mmrCxr8SlY9Qy/HimMR5ZkJ4hJ6QN4xTKTUIFub5gDb+C6t?=
 =?us-ascii?Q?hA4dWvcoC1EwjlN0Zj6PKPbmnjqc0BNMM3GLZ8HC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: j4BvXPFl9hA5M9ddEdgZKQwlW/UAQEcfBzVYSwoWo9Mt5cvY5feN8ummt2Ocm70bztIzLTHmSpYYto6TQ4ZukXmxggEMtWqE6mnn+VVg5Vqo1/e7e5NIsYHhXId5cUFjU/N8L/IpJ8vTwpTc530Kx4/U/MGBEaA1HhsGhGYr0VHo2BY/2oHIE4j5W4rDFF8rWgUSNQCG8f2QUL03OEkmC9fb7634A2HLyCtX0TCTyTi1UJ9zlxf3IfLoaF0ns0kjoUV9mYP5x5BDwhY8rs2z867pxHiJ2UaK6JmVGL3EddL1vrveDoBm4EQWv6PLVO3WjqfuxW9q75xUI4qyyWsuYpyboDw1YBVuaT9JZleTLhHn8KFpbzOCNOi4iKbbRWYRUpUSC5cQrtd1CSrUu+2x9xJGH8In+dtEssYZmnks3jKOe94Fvaezc1AM4xoA49Cw+b3MB3pDt0SVdHs3jVXiSF7gF5K8OJtYuP/LeOfZJBOLVdXzpJD440aCQ+O/fW8ITyQmnA7pypjbSHywL93WQ+ZmimMxdudCLFvDUMfij//ZVljJgmxSu6I9gSa6+Vixu/d9Ge64MA0Dddev2d/a3IWzpX9oZZw7eA8vBcwemLNNeFeeUxL5YVrjCHes1FS3kzsMMzbZG23VxKwru/f5XxFwCj9bbO9a3EWqzJyfypTo4Yv8kEe57OGBaBJ3Y/p1EKjx02NL2xKnBo/nD1bv1k5vOo0RQ3MGxoD6vhnHOnubGRK6/mEjCc+sla80whDc+PbPuBQnyz5/K3f+5W9aDSBPjiSN6an5Z40g8HY7JoEMK33b2BJmN3yauh5jH5Nwlh9T/qXa4EMl2aDWGF60pETfhk7JAO24s46z3g/0sW83Gxho8fIPUXC/gFSzpkns
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525df732-9df5-4b1e-47f4-08db3b0e4ead
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:03.9581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 778BzW1ComUL9jNrg4IcJubYryMNT60eASJp/Hqdx4dOh1vjvkEr1yIn6ZfR7jDPS6NZ1bEJwqmTRfUIzMc4ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120038
X-Proofpoint-GUID: sz5ziLjxtSaONgkJ7O7UNRkrNzsjAsqR
X-Proofpoint-ORIG-GUID: sz5ziLjxtSaONgkJ7O7UNRkrNzsjAsqR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b81b79f4eda2ea98ae5695c0b6eb384c8d90b74d upstream.

Add a new wrapper to check if a file system supports the v3 inode format
with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
that, which is technically correct but a little confusing to read.

Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
so that we have one place that documents the superblock version to
inode version relationship.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     | 17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  | 17 +++--------------
 fs/xfs/libxfs/xfs_inode_buf.h  |  2 --
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_buf_item.c          |  2 +-
 fs/xfs/xfs_log_recover.c       |  2 +-
 7 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1f24473121f0..c20c4dd6e1d3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -497,6 +497,23 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+/*
+ * v5 file systems support V3 inodes only, earlier file systems support
+ * v2 and v1 inodes.
+ */
+static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
+		uint8_t version)
+{
+	if (xfs_sb_version_has_v3inode(sbp))
+		return version == 3;
+	return version == 1 || version == 2;
+}
+
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c3e0c2f61be4..ddf92b14223a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -303,7 +303,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -2818,7 +2818,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 947c2aac66bd..c4fdb0c012aa 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -44,17 +44,6 @@ xfs_inobp_check(
 }
 #endif
 
-bool
-xfs_dinode_good_version(
-	struct xfs_mount *mp,
-	__u8		version)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return version == 3;
-
-	return version == 1 || version == 2;
-}
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -93,7 +82,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(mp, dip->di_version) &&
+			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
@@ -454,7 +443,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -629,7 +618,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 0cb11fcc74b6..f1b73ecb1d82 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -59,8 +59,6 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
-bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
-
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 824073a839ac..8ece346def97 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_has_v3inode(&mp->m_sb))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b1452117e442..f98260ed6d51 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -328,7 +328,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6c60cdd10d33..598a8c00a082 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3018,7 +3018,7 @@ xlog_recover_inode_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
-- 
2.39.1

