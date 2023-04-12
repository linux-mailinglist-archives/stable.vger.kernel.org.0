Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0B86DEA6B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDLE23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDLE20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD95260;
        Tue, 11 Apr 2023 21:28:19 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLO8aQ029967;
        Wed, 12 Apr 2023 04:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=5wTQ0L2nZqeWDUd3IC8lKHvRUYUTd59pdAJS/6DMDyo=;
 b=E/c/OQJu+X2OdEteNY8/BZYYtZLSxP76opRa1SivmHuSqY4o0lAhU/G/n/CfXZoY7aHj
 WkhW6T5ZqljeHuzzeKCCcPZuOwS9F2aIDZnibE31KHm2VEOQziPZrLCjE6BPXvLm+G8K
 IYXNme3Yc9R+5M8/pXHl9TpQ0jP/AiuSFw27dw0qTZCl2RuqR012HxEFtS46ty6RKzx3
 4z4Bh5yTOpEAkEviI7YZC5Qo58gWjF1JyofkDYo4d4MkYApVokp2r3xgHn08HksQjbPK
 jSk1Gi1FLZqAZeMCw/nVEWSfyT76/6lKx3mNcqZ2Vi7yDHOSpA4n1Yp4YXAgIjpDfK3C 3w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0ttq3s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2ZJ4s012882;
        Wed, 12 Apr 2023 04:28:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdq0nxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsqwwwQY/lN42/1Vdf6u2nUeMXtZzlgT492zUR865UGneuzHMPvOkb7BmKmVtWATZQxSSfp5QcxZEvdyaXDTpOVGIU3SdppIespDKz1gn+gvabKd3DegxVsppKMAdyglpMCaMM3/RBkG9oQ84upxwnsWNKl3I29bHTtAsXLhKmADQe6/iLn5/hQkEK5dWQStmWgQqnSUGssG1K+HevUMoYzZ7mfLAb9tIQWeJlW5bAw/DUxOmPqh1yEuuAJclmHppI/B3XPgf87i/GWIh/SThYEd05qkFxdt+Z2j1svcqiAEzMLuQjVlpz6LsL51hYx3G9sEcor5CVd7cvkiqiAitw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wTQ0L2nZqeWDUd3IC8lKHvRUYUTd59pdAJS/6DMDyo=;
 b=Y+3Kf3HLnFa7M8w9llh7cGOXljrQPEIhE4ZF0g6zKjto8RHriLjNZOY3LrcMf4Ozyt2szNp1YEwtrT/DczQTmu57474aqDdaBrKGecAGiLE1mHNDAVW9ezFaHF/gLRbuLmQnd3muTJcaUv1oHCXVKA6G7kaenB1QW0JHmLXp4A+IKTI4NIpYeTfi31OOpXRJe/owrhWpmwo2v/e1WeHd0nTHqkLxdmUI5YczDeqnY/R/mU/07TTPxYEkazGQMuYivMdq0dz44IhKENcjGTPH9VtindXYVnE62Tl//yL6MgbWQOPAbaAvLANue3SFvziH3IPTiRMaNhCNLYG/hhtc3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wTQ0L2nZqeWDUd3IC8lKHvRUYUTd59pdAJS/6DMDyo=;
 b=TF+gg7BK1Q9N8fTsdyoRzrRqGoTiRklJ3psSMd2u89T9Zlyq1ud6tPOZ60rIlMlPw7DRgVSUlYpkAXvjqolD+gcEBVWQ6VgHAte4DmmL1r6wOQdRif1JMc+XZHJheoWnKpCtr5LtMBCRqqtu8KRw2GtVghSZK5gMtuz8DJeVqUA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 07/17] xfs: only check the superblock version for dinode size calculation
Date:   Wed, 12 Apr 2023 09:56:14 +0530
Message-Id: <20230412042624.600511-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:3:18::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: ddbc1e8a-818b-48b8-8135-08db3b0e5332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSJNuxfQHrMgc3+E0eLMHUcVOTBLuUz+KMJn2woTid2i8vUq3KsmA9hxtEaUUsJKV2By8b7NHgzl7KSawJnpBiVeTWW+fgDdk0FD+dz+tTZsNd7O16TOwP0csEdPtc0Oj6KDWRbdcrlxHP0t1j17uPfALIALPLU4SJ9iBots0zDMo/e8WN6YsxR5x16m14mkSunhkj76RVjj8ZkvnybQX6CznChVowBMXjtnPKTOyRTf4vdU8PCR9bgUsu9/pUhczPNIZiUY+9z6QZYwdQO2o/1kO/vspibRxWen3ztX7nticenBVVDmXj8S1iqbpCTOY+5ohVKPm90je0dOBOF4seLVJQ7cqIlU+/ETyyMsX2Mjo29E7218rXIYeD8EM2JMGbvnUWXsAgz0cKuVtZLy/EW5GroxYLXai3muKOviSEPLd6JY6mJJVB2e5vYd2yG7U+JuKCLGDiIUkFAnbZcMOksktWFnp8hWF7tiHeiEC10AYdT9peh7dP0NH7pkQhsD/Akzkc8PMGBRLQ73v76GbLw7CKsgeTpvj2yAZDPXniylyfweF7S6yPaYkpOZ7lRX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nqPV+PcgIhkZ0GxaWzqlS1WkhmFCGVTQ4CpRjvmdHTJkMJsQzamtTPgTHtIJ?=
 =?us-ascii?Q?T8tTu4zuIurQTATzUdyGw8wVffMqXPTtnQoYWMWpN6I443zWcsg1x+T9h5u1?=
 =?us-ascii?Q?zTGGL1C4bDu3tWocGHW2Txoiwf5nx+g/y69GWn+ZDZhUN7SbPNCTqHwLR6xw?=
 =?us-ascii?Q?NKHmSU1S2HVyDiaxyUOOsI36Zz9lfcx3+OhLaGzBL/kKqtPZ2sDZCc2hmdlL?=
 =?us-ascii?Q?qugvZ+2QfZ8tV/uMM3ZwlOwoA53EWaORTOjnqgMkLxZpCcwNsHfNXbLtGwFP?=
 =?us-ascii?Q?vNUVlGjmnkZ7baDDuT43lYPUPYs6gHSWBamD/bDWhaZqd8JXhE6dZWZKwv8I?=
 =?us-ascii?Q?wovKriI2mUAI7M//MxlrMeJW7p3TASqAJsxN9xwnRZROwhW0LSNBs+W/pRbE?=
 =?us-ascii?Q?GnZyMfrospvVXdduWdN5CS6lwZSuidrgRXOJ7CA6aWjV3vly7IqPApMdIFC2?=
 =?us-ascii?Q?vUjn4HuhRyss1/QJfNtm1MBg4nrJwpbU62TEobiLs9Wc0frEWIL4EORsGBcW?=
 =?us-ascii?Q?mafbKJOTRGSZkj6SMW4I6nLlU04u9zp32CpJQRjRGb4QRGwhRkTXMlQ01W5C?=
 =?us-ascii?Q?KfwWdoRmtubYD+HC4stIUmQmg3kLYwgEZySxTNh835maCHqOcPt4EH1H6xHi?=
 =?us-ascii?Q?4c8a9jYwv1pV1dy+3CdrOzQ2D7WcxYkE9kaw1SZ2SmZi2NpKD2zelsDUvF9Q?=
 =?us-ascii?Q?CWEGv08txrlz6ckHMgizBHZ05/xIdGtzJMKsDONvgO9wxohs23GNGB/0T+xu?=
 =?us-ascii?Q?yX+XFp8h6IdG+d4zl7jZr4w60X+M/R5hdfeaAPqcpsLAJQsAEuffr220MJXy?=
 =?us-ascii?Q?84X7gyDWj2/lJx0YPK9cLI/M1xEBkpD/1dUCwBk757lrgCFPrTeWLQ57eOCg?=
 =?us-ascii?Q?IpE8Tozwz2D/YB+FZpBY4wMNr9h5wQ35nbpoBWutTeoON3qMPXJIR2050I7u?=
 =?us-ascii?Q?i81eynktDkvhJgMO9lLJNr7Mx+k1klGsQ13kvXLd19LoBPZOmcGle40Eyu0q?=
 =?us-ascii?Q?eOAEDCHAU0mux9uxX0SWjXx5IocJlEjTdYAe70WSkgTLY1KoNdZixWdkOEJw?=
 =?us-ascii?Q?ExvcfuG4PNgszCofCKPHQOUG9ldi4Mpoghg3HuZ9CzKEuXWAwFmEsUIyde0u?=
 =?us-ascii?Q?+USPCyfc/t2ISUv9eOV7WN42+c0Y8taVQzLH2IBsFHmwfQuq5k6QKTe7fQIR?=
 =?us-ascii?Q?ixK89L8EGDdm+WOVqXOn7cPLxmmHLU9nNBzVo2RKA38yz3R777zK9xI1lgS2?=
 =?us-ascii?Q?CF3El4wU5G8kwdiOnyGai3L9kgDRMUhhsdkQcUHwsjvPyA8ipu4aN4syCAj/?=
 =?us-ascii?Q?lsB/a8JvMd06uHepTPkbcEw1Xrgl160AVyJMfKjePoKboWCOEeh6VDCcP32J?=
 =?us-ascii?Q?6Qa7fr3nNvueTlAkTXSR3SGfWTu3wAG/a1w1I7gYsF2rMZCtpfBQoqAegFlO?=
 =?us-ascii?Q?R1lOLWHJv+Z0grJqX+E5t1MGcbZAE+G8IDiZiy/VuGcSeVWkX3w10agBP4+0?=
 =?us-ascii?Q?cFbPEsiD/yHWTKm/8ZoFIXVI+vuceasfNoaw5YeWaiTuRs6UMQalmuu+94Y/?=
 =?us-ascii?Q?ENFtTWfHiKrqPbavPYtgzrYU6zhiUrqZO1c9IgsX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sC1QVHRqForoOGeyTU/gf8UlI8K+SYTidmpMdzTDEVq7I5IIeEPi/UQJdjtFUFbcGEO9oRn1o+1v+Zsm0JvSj76lmHVPlYs88RQqzU+0mk634WIv78q8vsLb4YCsmgDZlPoTgzHiexwkFiQRuKCWwS7Ld9InJq3/HzyBYa1B066yRhY6B49rXfhTl1x+CBvlCmRyT1xPBS1v23KjuYbLohw6ja99Thr0kqBWeFPSwF0JYROCC8fZykkbcvPvkPoW7t/CkJWg4aIm8AIpTKEJlbD1d1HSmtmXO/XZASuGcgIt4IdxnqJWE6kK6ii8J1dIMqOYzLQ/WH0iTvYxeMk4pAtwIR08bvRYj1MoxGMCQmvWqHhHzyS9dbT7Gbt9RBz37lRyab+eL0JFQoO91VAyuDMlDHpo+4gG+jgkqQT1sPHukavwn9m5a5M52744VBj9nOX4TmZjgXButi/0YEYOiffaYQy8jnb70AuRi3hCeBhXMHmCi4XNozP6JkexydchBOEShyn4LHCi2IxiBoUbLW1TnyT1vCf2VyreocNGh3SHR81qiJTuxYvc89gL4Q4E37CuDBCfV2pEIA0Kh/ijRDZDB6ePpjfHHPqponGA4p4Ih6DOOIRs91y1qHFya3LZ0wJ2VAqFT09MR2/I4X1NyCw4nqZqdhilVJbAzOjtDBG/lypSALEzlCmHE2RhEizEtQPPUH+pCrYNBIMVCpeI6DvezozQooU8sW5b5IvO2c2JU/vQF0tO38yre6CpBrIk3DsIjs9D+AYxco5lzUW2WVcG0w/Gt7YVlYkeDX8n4fqnDQVO7sScAgy2GIguXOpj9PkqbU8TWg/Zjuw0aFFwBcQWaUc9Fv9wbRGemv2azBhDE+CP2oe2qwP33oFAgUFJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddbc1e8a-818b-48b8-8135-08db3b0e5332
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:11.7242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3i/g80NvcTE85IcOWRmOeZRCaVjioWjz5LS3oSKqKDupyB5HcLsv/6LbiP6WfPwTjLG6Qws8xcXqKGSn9f2wfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: cXG0AVcji3UBdEiETes0yT8WT64tlpSb
X-Proofpoint-GUID: cXG0AVcji3UBdEiETes0yT8WT64tlpSb
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

commit e9e2eae89ddb658ea332295153fdca78c12c1e0d upstream.

The size of the dinode structure is only dependent on the file system
version, so instead of checking the individual inode version just use
the newly added xfs_sb_version_has_large_dinode helper, and simplify
various calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
 fs/xfs/libxfs/xfs_format.h     | 16 ++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
 fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
 fs/xfs/xfs_inode_item.c        |  4 ++--
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_symlink.c           |  2 +-
 11 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3d5e09f7e3a7..f5b16120c64d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -456,7 +456,7 @@ xfs_attr_shortform_bytesfit(
 	int			offset;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
+	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -523,8 +523,7 @@ xfs_attr_shortform_bytesfit(
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
-			XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d900e3e6c933..1e0fab62cd7d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -192,14 +192,12 @@ xfs_default_attroffset(
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			offset;
 
-	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp, ip->i_d.di_version) -
-				XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	} else {
+	if (mp->m_sb.sb_inodesize == 256)
+		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	else
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-	}
 
-	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
+	ASSERT(offset < XFS_LITINO(mp));
 	return offset;
 }
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c20c4dd6e1d3..31fa9ab2ab61 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -963,8 +963,12 @@ typedef enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_LITINO(mp, version) \
-	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
+#define XFS_DINODE_SIZE(sbp) \
+	(xfs_sb_version_has_v3inode(sbp) ? \
+		sizeof(struct xfs_dinode) : \
+		offsetof(struct xfs_dinode, di_crc))
+#define XFS_LITINO(mp) \
+	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
 
 /*
  * Inode data & attribute fork sizes, per inode.
@@ -973,13 +977,9 @@ typedef enum xfs_dinode_fmt {
 #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp, (dip)->di_version))
+	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
-		0)
+	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_DFORK_DSIZE(dip, mp) : \
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ddf92b14223a..391e441d43a0 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -339,7 +339,7 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = xfs_dinode_size(version);
+			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c4fdb0c012aa..3505691a17e2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -417,7 +417,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
+		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
 		break;
 	default:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 93357072b19d..e758d74b2b62 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -183,7 +183,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
+	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7b845c052fb4..a84a1557d11c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -46,14 +46,9 @@ struct xfs_ifork {
 			(ip)->i_afp : \
 			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
+	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
-			XFS_IFORK_BOFF(ip) : \
-		0)
+	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..d3b255f42789 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -424,12 +424,10 @@ struct xfs_log_dinode {
 	/* structure must be padded to 64 bit alignment */
 };
 
-static inline uint xfs_log_dinode_size(int version)
-{
-	if (version == 3)
-		return sizeof(struct xfs_log_dinode);
-	return offsetof(struct xfs_log_dinode, di_next_unlinked);
-}
+#define xfs_log_dinode_size(mp)						\
+	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
+		sizeof(struct xfs_log_dinode) :				\
+		offsetof(struct xfs_log_dinode, di_next_unlinked))
 
 /*
  * Buffer Log Format defintions
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9d673bb1f995..2f9954555597 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -125,7 +125,7 @@ xfs_inode_item_size(
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_log_dinode_size(ip->i_d.di_version);
+		   xfs_log_dinode_size(ip->i_mount);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
 	if (XFS_IFORK_Q(ip))
@@ -370,7 +370,7 @@ xfs_inode_item_format_core(
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
-	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
+	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
 }
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 598a8c00a082..884e0c6689bf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3089,7 +3089,7 @@ xlog_recover_inode_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	isize = xfs_log_dinode_size(ldip->di_version);
+	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 97336fb9119a..3312820700f3 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -201,7 +201,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
+	if (pathlen <= XFS_LITINO(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-- 
2.39.1

