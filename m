Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019984F0079
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354339AbiDBK2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354322AbiDBK17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:27:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A1734664;
        Sat,  2 Apr 2022 03:26:08 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321ul3i013038;
        Sat, 2 Apr 2022 10:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=KGP5IQaFj0ujGHLwE2YF5gYQ1iuzuuyiFXTbkPxlF/o=;
 b=V0HJBdlP9tNiJcubbokZ2pOH5O6qxHoXp/fVdfaUxnWfyScPLp9FUBQ5lzdyqGEgwO0E
 CM+nvnsjjOSmFrrbEH+rFBDzyctaGixqlCUIqYjvvMG3OAuzuqpBXqbTAX2+7jZQ43bF
 RS8+RG8YhgluHSCP6yyvD3XchvzFQJyeE4si2CcnFAhWs1QRxYV5ImsBUwbhQx2uw0pp
 smbuKiPBbfy7ytLojrTnrNRSXQ6m7swwK5JZHTjJ2En6krvn67l8S2a9C/S2YBO/6yy/
 SHl4QGFRld8JTEOkWLY8wWSXNIS4Hv9GWI4++BwiTp/TZjEw2S9TluTaXgj5p//CgRRh cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92rc9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AL3ae004551;
        Sat, 2 Apr 2022 10:26:06 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx163fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njkp1uBMufORcQXeL9/giLQH95siXy4KvQ5uy0UJvtq4Nfk1hoC9DyEYn4U2LDrUHlWZg1CuGSJDuKuNJUwMnpZMGdWeQTahZh2rzRq/MarxrKwWG6Rl0zHF8cdKywaZ3cEDgxO/MoP0dyyYAyNIKBBlHK/FesLtY2uBQvUBnNPELD1qkKxOawFFDrFkrXPha6hnEZoqvGA5JGMDSsxlgjOizutiaw/Xhh/hOoQcsq1Km0emC7bVR/8RY97rYfpnGF31R0I7wyICsLPqhOqvh3uTcm+lOLHiWV6NG33027wjby6LIhAf3BnNGp4OEjtgKx1lze9JYShqrjpUl/1N0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGP5IQaFj0ujGHLwE2YF5gYQ1iuzuuyiFXTbkPxlF/o=;
 b=gk8DycmQToAqRsGduvtJt2psoLev5mdxXXVSvGGRtYj8SAMgDCJc+nvIK0hBOTSqe6MljFjQ/rL1g4VsRK6/aGOZtK0nwd9g1/oSXfZYcC0P1aVTVfBtSvh8YCaifUSGjKCol9p08MDQOsg8OC9dFObKjxi3LhIgcx8xAe3MhFYd6YgYDXtlUwgoQuy6r8nBXV1RwufOOzbzxxnZSOwwlSN1RyE56SVL4fO5AHGkIULjARqlRCRczmd36BhPkP6mKts6ZgHQbdQZCMc7b4+535j+11ky9YYMR+gj/H+k71RvUpG08xeuIKzgu1D1P86h9X0PlWTTblLR3JxqMTCTWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGP5IQaFj0ujGHLwE2YF5gYQ1iuzuuyiFXTbkPxlF/o=;
 b=gSpP2v6sCqMH1qHl+c39BswwmD2nD4wIVwvZkgsXAEyI0IQhOjWXFe1nv4FtznGkWhohT52JPGR9k98SSiCnemFytdgdfoFT4RC0+vEQ9AjvpxWFG8iZV2RwOqZcqB4RrxY0SMiskFiGShSAMlX26sJH9DH6hLLR1eVB4y2ugWc=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:03 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:03 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 00/17 stable-5.15.y] Fix mmap + page fault deadlocks
Date:   Sat,  2 Apr 2022 18:25:37 +0800
Message-Id: <cover.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c4e1ee-cd33-4549-881d-08da1493307d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30499673A47A6170914209DCE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0juuFLN8lqWzhduDVWEPpc2O/0kzJsF2haSKGluEXXLz1OAeWT4VMRjR9wh0iGryLvwnC7LZff6F8G8kyN0Gw4kS5bQsLbA8R0xgUiBvqk4YgDYiMbfgwVVaozPinZmspPoCsdTNIqe3YZJLOC4w72vMhIVIsFopsQHz49ePfqzObnKlCAjkwy9PSIiNxpA0CQLMg8QBkSH1HByVF7FXC+ETuh1AIoFMzkVXngs+k4aU/jhL+sJkblM5kosZrVgiFJsYlKjcEo9zl983KGmaMidep89Shbp/0an5Vg/llFYG6nWzAGXUKXc7BBx0IjvUsOKTNAb1ez3GmS2f/my3PnJ+KmESONQmarkVr/g8LqRSXchi6r/T3ux0QFyvTWHQF4H9fEYfm7denauZlLStgxbSyzijea9zo1CeN7SDLMjXLM9F/dmfDRYO/XWoktosX1Fxa/3+Q7NoKLkM7MyCiXwWt7Why3hIQDAtNZaDZ9+FYWh++BUpXUgU1ZVmo5yXjw3CYyBfb3ZtQ7ENBZVJwBh5DiS2Ie6Lg1xvCujxlvg/8jiI74hmWGL2qB3sgxLn6NMFkb3C+mD7hY/gXC0nMzofzwo3LzTlCZkYGJkNzt6C+JhZZN6RBNOr8xFmYz6Q/HFOGQ+hQOmzd0knxw5pCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(450100002)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yrk80Hhwy+kCyMaCpXYmXetrMQezRR+BxRr9tpgAJP9eTmQv3hsLbKS74iXe?=
 =?us-ascii?Q?e8+Uwu52cEI6INN8sqURzhnKUkHnU7jMGEigBFEo1fpwrRDPBC3Y3VLtSDcL?=
 =?us-ascii?Q?NulspvF0Cf8JUtVmEjZ21apHVfPUtB7gy7ch9IJZgJGjEkJXM2cua6DkJI9t?=
 =?us-ascii?Q?O/Jh+WHB8b/Nd4ud7dYEjC60sya8dJJ0ySw3CnGG4KtBzEZBS7xbycswXihA?=
 =?us-ascii?Q?ha4++GbUJWLj0k7Z61/E6+9QnXywz7o3ili61pteTVB2dPevB1pNthGPEGRU?=
 =?us-ascii?Q?Z0fPZyhAvdvhBKdzJn+zVsRwRdyGgiqYHiBbVMZlMQv8mcix6V3Fwy5TqtsI?=
 =?us-ascii?Q?9ZHhxAGZAOtrYpjuftkvMGNx+AJmYTciuYswzNqGvOB2LV/EvDQvWcUFAG2X?=
 =?us-ascii?Q?3PJlDSWLYCx4+t6V991UxSw3k34+TTVzHPb1VK52pOnHya1Vw/QD1vbR4AuJ?=
 =?us-ascii?Q?naQPl2D6it9oH1mLI0raDSwOYMvXWpQpR2xe2MgtX3Kw/wp0Qi4MVXUlAGT9?=
 =?us-ascii?Q?bSArak/B+Z0yEhH4HhRpiQzAxYyAHJcyOXfehOqjgGdpArC7MmF9R9wvftTj?=
 =?us-ascii?Q?aSReYQWUGTUWj6lYUaguvhv4T0jSvfthDCU/DDaQN1a5SXnWeEsbzq4arK9A?=
 =?us-ascii?Q?xrshWwL8wEBYi4sNIoykqWdWwmApW52y1F0j7S/iOBWPAUiwcyAuwhmMt702?=
 =?us-ascii?Q?5yUJSVfMWtjJCN/FiEnBCXNkYD80Upk26C5TB4NeBCVxfnsVi9jfgc+Dbf6B?=
 =?us-ascii?Q?/EtqJ3cD99ht2O5swLJ6uOfzaeK0uQ6dQ3xYSbp/9fJX5EgjrNhhtFfAIluL?=
 =?us-ascii?Q?CeqI9cFCJYYcY5f9vpCVoSo2nhTUv1XZZI2iiP74Z33UJOiQP55W88t1oWZ7?=
 =?us-ascii?Q?L465amf6T7QJ6yBXQQuutYZS6Iu75fevzpQ+6ftvS20XKUgVNT+rChFxxPCQ?=
 =?us-ascii?Q?1/+FpaWKhz+AlehKSy0fqSiUEkPbkeNwiA0eotbV8hQnH8X89S+qBSC5W1lg?=
 =?us-ascii?Q?b9hXSAXrou2sMqs6G0IZYv7u6abgcolHljRXMzrzaZgjNz8xCvyesFJJ8+VY?=
 =?us-ascii?Q?PgPUGvy8iqyP3JyE0d23OcjojWouawfvMuO2uc5Yn5N3fXrmkEH/Q5Cp0PHb?=
 =?us-ascii?Q?zI50kCCN4B29Ttji3XuZY3m1shUZzMl1jWc7cEKoDep7WTHrwgwcVb4XU9cz?=
 =?us-ascii?Q?Fk93qPKk/wkMGdsTS+F4f+MIMMyfBLGLKxJW/iEeUmmx1/HCj8HSaOdialnL?=
 =?us-ascii?Q?ty78L9Np0oRomcoW6f6ho0x8UgTxr3xqzAJJhqlw2QMuYYKi66/0Xe2uTlNr?=
 =?us-ascii?Q?48wV0loCbGXBSoISeLA0qgotWf7UKlmI1KGObRUHCPd+ULdwfMft5ladqghG?=
 =?us-ascii?Q?Tp8GwahtT32R8dCOcf/om1O63SWrh6LAYUB2efHAYvNR+XDtbn488qDN1D1z?=
 =?us-ascii?Q?cwA/uuNtHVv3NRn0thkW6ueZAhvfxGOWJXESFtg6zXY87uks8zphn7NK5K8j?=
 =?us-ascii?Q?H49pPu3Ut/6U33crKfNftenH+t1g1aGlvJtvhJGJMx+e8WLM+GElg4YaH7Ih?=
 =?us-ascii?Q?T6RJ00JDebYTjpWghkLgf32U461Lwoy+D/bjQ1+jRnjsxNVoEOPops6i3hNv?=
 =?us-ascii?Q?aWGCgxO/VkQZq8XE2MbgfcoSwDkrneQfsEGNM9JOifb86Ysv5zQeVBcQgMeT?=
 =?us-ascii?Q?phCgb+ceAUyo1Z+Cij3P9a8plFGCemnIY4one326bgGqrNxKwWa/jseBMb87?=
 =?us-ascii?Q?SUJrcDk58g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c4e1ee-cd33-4549-881d-08da1493307d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:03.3720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7inuLOp0R9gVF9+MVrqGEiLi9XqJf5ewrb2iDAyGDQOIb5Ix0L5sDukGiOlRwSvgZyIpP9D7XMuhMY8r39daw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=597 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: LHz2Rck-OP4TTa5bDsGDwnBhw7bx2fWD
X-Proofpoint-GUID: LHz2Rck-OP4TTa5bDsGDwnBhw7bx2fWD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This set fixes a process hang issue in btrfs and gf2 filesystems. When we
do a direct IO read or write when the buffer given by the user is
memory-mapped to the file range we are going to do IO, we end up ending
in a deadlock. This is triggered by the test case generic/647 from
fstests.

This fix depends on the iov_iter and iomap changes introduced in the
commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
are part of this set for stable-5.15.y.

Please note that patch 3/17 in this patchset changes the prototype and
renames an exported symbol as below. All its references are updated as
well.

-EXPORT_SYMBOL(iov_iter_fault_in_readable);
+EXPORT_SYMBOL(fault_in_iov_iter_readable);

Andreas Gruenbacher (15):
  powerpc/kvm: Fix kvm_use_magic_page
  gup: Turn fault_in_pages_{readable,writeable} into
    fault_in_{readable,writeable}
  iov_iter: Turn iov_iter_fault_in_readable into
    fault_in_iov_iter_readable
  iov_iter: Introduce fault_in_iov_iter_writeable
  gfs2: Add wrapper for iomap_file_buffered_write
  gfs2: Clean up function may_grant
  gfs2: Move the inode glock locking to gfs2_file_buffered_write
  gfs2: Eliminate ip->i_gh
  gfs2: Fix mmap + page fault deadlocks for buffered I/O
  iomap: Fix iomap_dio_rw return value for user copies
  iomap: Support partial direct I/O on user copy failures
  iomap: Add done_before argument to iomap_dio_rw
  gup: Introduce FOLL_NOFAULT flag to disable page faults
  iov_iter: Introduce nofault flag to disable page faults
  gfs2: Fix mmap + page fault deadlocks for direct I/O

Bob Peterson (1):
  gfs2: Introduce flag for glock holder auto-demotion

Filipe Manana (1):
  btrfs: fix deadlock due to page faults during direct IO reads and
    writes

 arch/powerpc/kernel/kvm.c           |   3 +-
 arch/powerpc/kernel/signal_32.c     |   4 +-
 arch/powerpc/kernel/signal_64.c     |   2 +-
 arch/x86/kernel/fpu/signal.c        |   7 +-
 drivers/gpu/drm/armada/armada_gem.c |   7 +-
 fs/btrfs/file.c                     | 142 ++++++++++--
 fs/btrfs/ioctl.c                    |   5 +-
 fs/erofs/data.c                     |   2 +-
 fs/ext4/file.c                      |   5 +-
 fs/f2fs/file.c                      |   2 +-
 fs/fuse/file.c                      |   2 +-
 fs/gfs2/bmap.c                      |  60 +----
 fs/gfs2/file.c                      | 252 +++++++++++++++++++--
 fs/gfs2/glock.c                     | 330 +++++++++++++++++++++-------
 fs/gfs2/glock.h                     |  20 ++
 fs/gfs2/incore.h                    |   4 +-
 fs/iomap/buffered-io.c              |   2 +-
 fs/iomap/direct-io.c                |  29 ++-
 fs/ntfs/file.c                      |   2 +-
 fs/ntfs3/file.c                     |   2 +-
 fs/xfs/xfs_file.c                   |   6 +-
 fs/zonefs/super.c                   |   4 +-
 include/linux/iomap.h               |  11 +-
 include/linux/mm.h                  |   3 +-
 include/linux/pagemap.h             |  58 +----
 include/linux/uio.h                 |   4 +-
 lib/iov_iter.c                      |  98 +++++++--
 mm/filemap.c                        |   4 +-
 mm/gup.c                            | 139 +++++++++++-
 29 files changed, 911 insertions(+), 298 deletions(-)

-- 
2.33.1

