Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63846DEA73
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDLE27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDLE26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695BCE66;
        Tue, 11 Apr 2023 21:28:57 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLUDjZ017728;
        Wed, 12 Apr 2023 04:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=P+cy7efygKipfv8y2EO1jbbAjCSoDoKxHkrICI7fKy0=;
 b=CYUC4/9wZV0r8OnGO8g0m/HNKRwIye1Bo0zRLo1RjW73Ja96w/3ZvX3Ijz2WJLTyNrWs
 /mGkS40mYwXzeAOHDsHMaVIdUF3raCyhwq99DDFyKj33L74paGFj6HkbsijmXYLtCkEn
 C/XHkOVsI0VpxAArjsGq7IDYeaB7kB2Kqk3x4UKVvgEymMFLCJjlThjfl7jdt9zmUIrJ
 +kSc27pFyPHRHlx3IvbUJlP3OUwXyDW97Liq8zWvYTfGvO76f1HEScfB08/KwxTIXJvr
 cjjjnCdi76G7tSOZpY6+i5Sx3YOA4p7W4qYqBHlqUO78eUlH2lezlrrrW50Vb1BxRV6w 7g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvy3em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2WhHj008083;
        Wed, 12 Apr 2023 04:28:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc591m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgwGIm1uzP5SnNRvefDJICa/1ilw8WfYMEyxA0efvZiiGbPW7F74b5dVfDs6rV/1Z8yAlWlx4wrVNC9G3Ap2cPISwJSD0tcSGas64366wAh9/U1CHJqGubbiXiF4HFozD+kn9LW9Neb9IMKy3Gv1/rWZOVaIs7chrOh8Wy1HU3vvpWt/xxspwWkU2epSYduL/HICW4ByJSnT/cnoDcGpEE5oaJkZoHwfF0n2wdnTkkTlH87dErpCD0boAGkYit8PW7exgWF5Fj4f5zzb7aXGf3tIz7ntannuwmdpyNYVc6Fe7ZdsjJRSuwXONfIywHez7tbxnCy7/c2E3+ErwGT0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+cy7efygKipfv8y2EO1jbbAjCSoDoKxHkrICI7fKy0=;
 b=LsUYdHP5cEnab4m1Hm3TTv3v+yZSfqM0XFQrZzUvLovaXI3PdzFBTs66iexkLGWFRXoZ1ByF218quRTEmxbhAwXl/0Y5rsvCf9pxDm25oVSPjW9UQDVq90ivUXKpE0JyNR4M5JwBFE/xayYVHnTllKDOcPp39ycitH+xgeAouQ4RFglhI0nEriNubn4vGO1goiuie5A44wTiOzrhSBm/C9cA0DtaWnCQ9nr/xvxm3yDglaHK/3C+nzFagmxVVKcWt4NlT0Zwps9Sggrx0g5i4MuSm2DQKSR4uBCt6ZLvavUNpwNFNaXBSiq1uVcSWhnqu/jvZSWIfFqWQ54Sg9J2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+cy7efygKipfv8y2EO1jbbAjCSoDoKxHkrICI7fKy0=;
 b=CZuvJSf5HoCrJy80H5CgQhoHpF2ifgt02xAbc+PF6vNKIhatsHIfRP0g+jRXan4yeZgEnMtVX3gN3Su3nfafDnCmCODcGhZduCE7YlYNWIoWfQmamkBw//PTPeHRyaRyzheEDim2rKYMxXkAt60iWldaysXU28D1fkUAYUl4Kfw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 12/17] xfs: set inode size after creating symlink
Date:   Wed, 12 Apr 2023 09:56:19 +0530
Message-Id: <20230412042624.600511-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0086.jpnprd01.prod.outlook.com
 (2603:1096:405:3::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: bc3de8b6-b6c3-4f4f-617e-08db3b0e6a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IoPHnWNWGDWXF4vQZHmXWtittNBzGAGFfKNDboTlbBXwLI7sSFv54kygHvaI9mZjTF6JjJikZkX9i+mv9FwSCvu6MRlKMCyI4DIqm+V2auol1kLVmT3mOsxDgj/xnREBlSlcfpkJ7NEEnF6IikWQ787YT0a7ibIYd+cp1Xn/6WucKHl5K8BN6zv7G7doucEzfuTXEZCZsiYtGX60Saf1hK32sXtFt64OueBymIbW73glPM0Po+dMIaSFwA8GOQJMSNTskcsLpzLNQrwcrRuhVHwDIFiXFUP3J/mb2iBS3dBdtm2M6fx6I04p2w+1jxRMjMH08gaFiwHioyOnQ5JezKWtFElZ/wm/6nnp7py/Ngu3GlkWz3khR6a2449vLFdG09t7zWNOGoqAdXGzdA9N2QqoAcI0uAjHx1m8T4mK/O96n1BddX/Nkw6kcAxAgfFsnFfzma3l+3SCIHmZHTGiaC6cxszeF4CeGzxKGARGedTclKSsbRFSZ1YdhpAqRBKnoN1yYm+sgnOcd+FDQoXtcMqUPyc3GQcG5tcMneRw03kNgEtKJE+WOTBziMeFja/Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XOHFikO991oq39L/rGgXNIUBiMXE1W7on0tMhzf2YUNr+j2EDCFGWpagTWwL?=
 =?us-ascii?Q?36Sizx2L2F38ow8DGlcodTHwwbfOqC2laVE/uKQc2qH41av7OdUL4Nj42G0D?=
 =?us-ascii?Q?er1UOLd4SpwM6xKHtIjmaHae9l6IdANJSclLkRVCVrErNP5Ej3X0zW2SVbdR?=
 =?us-ascii?Q?u4wKXpZ5RfsboeI/nwvZ2ag6RdF/L/Rp24L5VRLJ973L8oYTfYwGRkNuPSmH?=
 =?us-ascii?Q?ehBQGKZIC45mFdQXrlKfbcVgtzSAbzmIwxx0eiEl/j2Spo/g/M0fYJgfXGjY?=
 =?us-ascii?Q?eQa/OSj+t2+VpPhufiPRV4pNPvLu7CoLpQIQtTwRq7i99r93dL4fbUQ5QMxw?=
 =?us-ascii?Q?Jdw/TK4qo2/Yp9N2uRncNFC+1zr/Y2Ucdhg/1eY43k1BBAcwpgOAI8mTq5mN?=
 =?us-ascii?Q?15y1EzG7pBfExmsFEKwhO/4HtqTzVd+DMZoZ+SRyr8c8ZI87PqdC7vj8wJ2x?=
 =?us-ascii?Q?Jl4tX1VSv2edvcy1UVKaWLyD0bEsWF1EoWQpbCgMnwEzFw5hicwavQZlQ6AB?=
 =?us-ascii?Q?QVv9Z4wGb1cSiL7niD7EyuCd6DCQPj+nQeP88DYLOS6nmU/mPEElQXS/Guv4?=
 =?us-ascii?Q?foAOu5ybGrj0x6au0I5ie45nSaxxZpuXj8seCaIGnU/uN/SwURrjX0mZ4dkS?=
 =?us-ascii?Q?NUHVlya+wquwB91wumc7WtWdzLHhVO9ae2CwcpIeyK7JMB4m6J8SDf4eGGQk?=
 =?us-ascii?Q?qP7tnUODLUo2f3PDgn75nmXWxHtj2WOoPVxo9kAqP2pH5s4HUD9iZmnDwlhj?=
 =?us-ascii?Q?oDCZohHfRthiTyAwO04dIIEW9isBItoiSnPon+JeBKLcdYKXuV1TbLWj68LT?=
 =?us-ascii?Q?V1A7KLCBBWa0H0wZpbl3EBqWIQw0fZMvFO5J+TrDVU6ufAyJzOBDzE+Ilu/9?=
 =?us-ascii?Q?+UTFYw/tKI7U3r/x/1r04bZnkdFQGHumr9RsW22oZo3AOGIRMn1xPL+Ct0o4?=
 =?us-ascii?Q?wNV6ay33tSN0NZ2NpBS6ax99AVt+4P0cjLfpIYIJPHs4JKOV/6Y6LWjFYezy?=
 =?us-ascii?Q?ibeLna9XIUikz4F6bx1WIYkHnzDwlxf6NKP1qGEj077j5ANtwzjEBZy+H9xc?=
 =?us-ascii?Q?ltdzQf+fnUoC043oG/I0RXix2McFskDYeFp9A4RLHdBq9raN4ovxxickOPV0?=
 =?us-ascii?Q?DBX5Usq76fo5Ma6dB6zci35Dqv7MofFUWurilqzzzG4mbFlddH6emEwvhI4B?=
 =?us-ascii?Q?tu6ibWBL6XZ1OBqhjb/b2y4GCapVDSgLCjHI72eBm8MrAXpOyepXEnOI5Bbb?=
 =?us-ascii?Q?Xgh1sNwYKUmMUtv00Yy15LFTkyUkgoczYZIBqcdGAlvTX+ykWIn+tSkDpZ3D?=
 =?us-ascii?Q?UmOwjhEizvqQW2waCIOYM9chB3SQBvY4Bcu1R0tmZHAZQWd2sudfPluaHdsB?=
 =?us-ascii?Q?16xLb/Xj62Z4bQKYnADfXY0yeS4nj9pEnfcZFgFOi5jl0IdY+yBS+PYIqRRw?=
 =?us-ascii?Q?DI8MmCC6ZuUYLl9gf8arF5NyGsNf2wvw+BmQ77BCLChLHEd7HUIqz0aFWSe8?=
 =?us-ascii?Q?LGV2pKq7EizL/z6kY5jVgbssM1kK7Qe5KwoP82ky1kRgkPRDlvR4DqQRg25A?=
 =?us-ascii?Q?lXlTYZt8cYr77omQ0xh6AWAKv7+AQTcn4EChZ7DkSqrLD/Nb8/1zJp/d2LsC?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bUn3hjSTJzgICS7Ew8MqoJH0rltX7wsazGSm+klkIUoST2FWReGXTeneNK2XiU/Ic50bqLEpbJnrMF3cYU6xmrypbAjtZ9EQX5hp0QsiPl+a8CbbosH3s/ZftsGQZDRdYPWKg1CUoIv0HRmcsrw29k2dK/+gkEQp5nRPfhHbW0EnI9wjk2Mwjh3CNhCRA1tbI6UUPv7/YZUFQ4prJByyhgKyvCVNYp4Ga72N1gfcA483RAQCICUq7Qk1J12et1iTc03hSkNjbtsfc9TyDu2JG3W/2TPjq/HBrwDrpM2QY+z4PUV5iRII9qbWqafaRqE8XKD+k5sCM6wj9cb7UGfNitQPnkt7HAgDWnRthdlhCj/LVUTYyDqcNslL/TKT3Vbp86sh4mLYBMFgG/q8ymPTq7apOHyoLz7bwacShzixmxWiqozbh+HQLwcFwVbZOc+S6Ija3L/EHlKn3DQFjua0+lWVT24dfPL0eBwvw890hzLKW7WheRQlvMcsXrgGQooNPEA9CrgeX/K77NKArofk4Ror1Y+oNkFwrjDSGYqtSC4kEeRjnxvZIJwvyiM6C5fBNtZX6bzmlE8xoV35d28i3E8Av/5C/uvqRBXn64Dai/7AMfoPvAA0scw9MiYEoABsCB+e6khsLZbu4QM7Z32HDmVSCaJ6Yj6zF8FFfI1hXEPsc4axkuvCBwpdAjQugIEt8cJBSl1TcnQDCnhsarOplXeQdxmbmTTB1PTT4Dv6Q3UT+vVNpjs9faLvTHfc2WF3in+vMKSinrJf2D6VeMS0n+lk9l87JqqDg9SR2eCIsuhiR5nxW3dLQjgBodwKTXxegQy4cYhV+JCqfd/VEAOjmXJY8shSHJhtyEnbMZjfOm/+hbA4SixQNe4BwOQQejFz
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3de8b6-b6c3-4f4f-617e-08db3b0e6a6b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:50.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqD9gXeOxhMTcCqW6A6cmENYBIsLQ1FvkXIB04LVd/Kjl5d0FAD4/3/9W5n9lhx0pind387SGHeIoB3Sj0b5ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120038
X-Proofpoint-GUID: _DFp_V-VuvEou8vNkcUsQZeSTJC0aRwz
X-Proofpoint-ORIG-GUID: _DFp_V-VuvEou8vNkcUsQZeSTJC0aRwz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 8aa921a95335d0a8c8e2be35a44467e7c91ec3e4 upstream.

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_symlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3312820700f3..a2037e22ebda 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,6 +314,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.
-- 
2.39.1

