Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FBC5BF447
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiIUDYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiIUDYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9D27E826;
        Tue, 20 Sep 2022 20:24:07 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO6iU019476;
        Wed, 21 Sep 2022 03:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=/y0g9rJaAwmOveGLAG52+iazcaqRwj7ePgevHkgE9eI=;
 b=lrk+5QLJedkvAfslOJ4E+EuXER5+mOQkx/xSsdkAB14BFW6ORWtVdvUPgljDBde4tJsM
 lNYuxu+brx/HlBDA6hhNboDaYKgr0vZEFi3UQl9wivTWf2FN4NebdawygxdG8E5wfni5
 SjMmDIJW84ePcueMMGorhfYFcSzPePgrFYw2n+R7T2BcTG38TUyMYI+UVPXZYLJH98Hl
 IHpIMSioAkSv/oZ+2MYO+d9plXoKAzywYXcml6JxUKSRLY1Czy8Ir1l5c4H6S8PArLP5
 nbf3QmaGN1V6lj9xIlBlfOml3yuWFkFC12Gbzzd7IiyHXeJsRoVDh+IGjzsoJoqFe4iM SA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m90ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L0SY9r008010;
        Wed, 21 Sep 2022 03:24:01 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39m004k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6XfwXcuYZS0Ub5/IW2wiZ4yRe2NmYIYoOieJra4DVLPxvdarmcSEs8AzILViT3NXXzc3HanbYazzoBSDXiCB3z/4KakJX9NA6DniJicyHYYVowUVbJfl2wMuugaPJPirsud7jwGOCblMIQOGUPVgrIVhEUN464KDnpu394P2ukEnXUQWQ5a+0hfmREm/ktMTrvTdr2kOlfcjmSrMPQUYsHnGb3TgjS2DItEDfIffq6HeZJYllXKqvqUQ9enWZMJeMgug1/6Y4Xui0TG+Zuf/9wxJlr9x3XS4GDC4fWDbh320cD4dJV2hPl9AsqfxvVi191zBBBEAblBMnvKeN3hSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/y0g9rJaAwmOveGLAG52+iazcaqRwj7ePgevHkgE9eI=;
 b=hQt7ocfbvG4wyrTJ+8rdU8ZP4iFZEz4yaz0a8NCHwSmtW+nWqpbCc5WsaFGIYKPBuuZ9lnYX4uRDYqnx+9n9561Pr1YCsHv1ZB+wWHLznsQAloOO1zYu57emosztHuRoyUqw/TJJJ2iJfqzcIOHGHART6rZWjxe43jx364EM0NNKH6+AdrGFs41i9AVsM4Ib9olLcRvvXYBzA4s6n6fQiFnEAzPT2JpyUZPB029r39hPXHFTivKxyU6iZI/amBlOTkaCSnCfGmoNVJGPHOsQSIwxSuM81GOgFIbhqDb5i8MI492hw9zD3/fqkOoPqMhJf1An/4nmiY29+an2jI9q7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y0g9rJaAwmOveGLAG52+iazcaqRwj7ePgevHkgE9eI=;
 b=DVkaJdFn5C9qlc4hS2SA6cB7moYeu5TqFj9vNgO0KeYjlYZpZWZZqPtQT3ljBSgmpz5/tKsHrbSEVEyaYLbj3vxtOhQR2XKDhHQ3OWArV+SnW4bm2qcdJHIQAkIPL8RY1u4LoGi+UJtMY01/vPPXa0zPkCAqGZ3kuDCek8c3HOQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB5838.namprd10.prod.outlook.com (2603:10b6:303:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Wed, 21 Sep
 2022 03:23:59 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:23:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 00/17] xfs stable patches for 5.4.y (from v5.5)
Date:   Wed, 21 Sep 2022 08:53:35 +0530
Message-Id: <20220921032352.307699-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:4:91::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: dccef4bb-9b92-446f-12f7-08da9b80b901
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwWrIpwJPs1i9H3aHNGzlsCi4Y+yHIy1cLLCtiQc38afOt4Z3bNyWcuio1nJC667uGjCsv8D8UVHNgd7kbI+xm4wcfqQdNWrR9KWx6db/RQsEW4wnvtTfC2YvIJs42R5Gr5KvU75wVY8tdXt3XNtCXeuYY7GDy3DgthDnK/fMFWJJxW/HJ10V+4sKsj+ALEHKyGYdZkiZagU43hKi/zG7/M2mcP10Sl5CSJxecblmarxcnFhWxvhSTcOw1s2QR1LGBM7dh4pYlbUgeaumM3yWqK2Vm4wmQDnto53eRD2A7B07absBJ5Ius5uV+lIsjlzayk6dvMWJgzcA8c23Nh5nL6CpXBa33qPyU0txH1Sv1JyLVRacgBI6pRGe154fDu24XUemVOe6FPT1qpWm0V3h7mzrVXUAnMZ/eea3YHs2zzCvLsl6PVcn7vkR+f/FVPw6SNPUJkw0l4vgMwudt++I2t81wtIYuBZDe3viW7C2eQGGoFWdV+mJ4C8ceuzvABuX41ObU/9TCDvvwaqb9W98RcYRA+lHUTSSYrqLuXMuTTqK6aYmusP1Yz7gXvMJUkvWWDeKxQGPruq1t9RvzrXuHlzwEM1Xazko733fRVYL6y8ieTtOzBmyikYXcdniFVMCipnYlJIDhjx5GjQJ5MpnRePZU2uMWBoPmfCpDkAyGckUZUdqK7Awh50G9irCCqetzjIh5HPjb9O2AQD4mTl2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(186003)(2616005)(1076003)(5660300002)(316002)(478600001)(6486002)(38100700002)(86362001)(36756003)(6916009)(41300700001)(66556008)(6512007)(6666004)(6506007)(26005)(83380400001)(66476007)(8936002)(66946007)(8676002)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SGjkNoyeElt+1y9EeDBPIqzkm/XCmjCD/FQL2Sl6sbNpwUcrXakkomNlxAsc?=
 =?us-ascii?Q?LvKa6xyXyyN43+uHToJ4SUII4ydFSx2EWexks8ckCdvjgNzmI0XeNVgHLRaQ?=
 =?us-ascii?Q?nY+9jL3PHyCPUwpXodrAeBZmGj2l9a38OXllgCvtZLHbNdJR2hn6Rht1KyfP?=
 =?us-ascii?Q?RpahJmqMEGKWExqCE7CjzuDnQLS2AT6CZtM8wSCNZY4Se0/6T2NnNq59ploW?=
 =?us-ascii?Q?Z3T1OAL91waT7+dBwQz+0HUZVUrxz5IFtoOzfL8HMq1g83d1to5m4W0cs23u?=
 =?us-ascii?Q?MBj7it94XgU2/xhlVLxD/5ydk784DKze2XqZkFHd57wyPnsQvlGPJKPhfMbx?=
 =?us-ascii?Q?hIA0uA7M/ttaIJmsJt5jw+5x4kGT9kwK8/xN7qko6rD07jCMPDXBnYqrvR+4?=
 =?us-ascii?Q?SzJTYrLFUrlFns+UIMnP4DcbeKOW4uVXmbbPYXjjhRPqb4KXsoKa2lTGZaAO?=
 =?us-ascii?Q?D2jTAFhus4K8XEcF2SGjY1uSzFQZRFGjIjFEYUiuxrSRUhosBW4JOqFJngF/?=
 =?us-ascii?Q?JkCdyh1CoAnSxZ5//npkpjCuTZYUjN8bcAjJ6uHtMKjcFgxQRH4L/78zJkFX?=
 =?us-ascii?Q?AkEoS7fMGuZDB4qXvTrmDNBU3Ys5v18j+SUuRRMtwOPUYbQwxlQIMKpmF5A+?=
 =?us-ascii?Q?wg4rBCqpa+4L6W4qodJu0okilnc4RncfDwVTaeM+y20r/3vcxzBjrKq9LB10?=
 =?us-ascii?Q?vNzkS73jFwrWoG3Y680JLbQqLsPnpRK/LszlqGQkPhf0YefLIr6BzO/Y1UVO?=
 =?us-ascii?Q?9lXixcjzSp2PltEOsL13FUN8M7nEV5IdcvnThEv+Gqwz3L/H5WHWgH3QAlBZ?=
 =?us-ascii?Q?0y+Q36XB343Je0LLPBeKumrzJNH7wI+P+aNijZDwHfZhkxKQFVEDMESnmTpd?=
 =?us-ascii?Q?0M5VeZCmm5EWRMSpI24flS5Pg0VLrrUX0opL2Cnr3Iw5YdxOkR8E+9WW9VCe?=
 =?us-ascii?Q?MBs4scuZyM+l8dgIUwD8vkOCrxTjL3srWklQuTdYV4xRPHBEpglaFEHYTE5X?=
 =?us-ascii?Q?ei/wgLcWNBewGU3aZCBWeNMr59huE/s4MNHEzSz1gJ8CMwvwbZ67cOUL5dzD?=
 =?us-ascii?Q?Cif/tup5MM+tShqLsS0hJYzV2s4EL11yTNURZdJRxtmqYMUQL8Yuz98TR64X?=
 =?us-ascii?Q?HftmPtweWOfyYp/VLdhzXalPsRkiCzNzYQg/VdG3B5e+BnHpHlGBFaaCxNc8?=
 =?us-ascii?Q?9RDo/zThWPRAd7YSNsIKXxyi0zA16ii9eZRLTxNoX2s+Vr4wHWC1g1z0DUv2?=
 =?us-ascii?Q?cxpaE0Szage5Qr6XiQC+7JtKxyu6880KONngylCVnunwF3XeK2fWOweE6ttU?=
 =?us-ascii?Q?TFfwb8A5o+iso33W/CovILY3ViRxPCObNq8+O4tECPZkwMN6Ew+VqOuIIoSr?=
 =?us-ascii?Q?tdNDv1Hu09Ikhny9DjPNXZWJTVHmTT0ZKhRyUEmugua874V4uM7bFrjYv0mU?=
 =?us-ascii?Q?vvepFmYXOV6l/7JWlZpwu1HgCXRjgPUc+THs76AEVqzS8Npi240AJnKwIvop?=
 =?us-ascii?Q?Vh9u2Ls4r0zKcbtTe+vs6SZscRLdLbu0ZI6Nr85T+BY/NLThrziPMio98WRk?=
 =?us-ascii?Q?jqVPHUz3QorgAjPDMhPoT60Bsrff0bX4CMUfYAUgLclU8L/DLo+PT0WZKYNV?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccef4bb-9b92-446f-12f7-08da9b80b901
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:23:59.1613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHDHOHVKMlXdLfgjsJPOOJ9nMAhxYB17oRgKvuqwaa4wxWMn38LafLgoVnaA020jI4twSp2LqV4b4nidKsDmgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5838
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: M8dnb5vbAotaLkzLCPe1j0r0eCYi7MTM
X-Proofpoint-GUID: M8dnb5vbAotaLkzLCPe1j0r0eCYi7MTM
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

This 5.4.y backport series contains fixes from v5.5. The patchset has
been acked by Darrick.

Brian Foster (2):
  xfs: stabilize insert range start boundary to avoid COW writeback race
  xfs: use bitops interface for buf log item AIL flag check

Chandan Babu R (1):
  MAINTAINERS: add Chandan as xfs maintainer for 5.4.y

Christoph Hellwig (1):
  xfs: slightly tweak an assert in xfs_fs_map_blocks

Darrick J. Wong (11):
  xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
  xfs: add missing assert in xfs_fsmap_owner_from_rmap
  xfs: range check ri_cnt when recovering log items
  xfs: attach dquots and reserve quota blocks during unwritten
    conversion
  xfs: convert EIO to EFSCORRUPTED when log contents are invalid
  xfs: constify the buffer pointer arguments to error functions
  xfs: always log corruption errors
  xfs: fix some memory leaks in log recovery
  xfs: refactor agfl length computation function
  xfs: split the sunit parameter update into two parts
  xfs: don't commit sunit/swidth updates to disk if that would cause
    repair failures

Dave Chinner (1):
  iomap: iomap that extends beyond EOF should be marked dirty

kaixuxia (1):
  xfs: Fix deadlock between AGI and AGF when target_ip exists in
    xfs_rename()

 MAINTAINERS                    |   3 +-
 fs/xfs/libxfs/xfs_alloc.c      |  27 ++++--
 fs/xfs/libxfs/xfs_attr_leaf.c  |  12 ++-
 fs/xfs/libxfs/xfs_bmap.c       |  16 +++-
 fs/xfs/libxfs/xfs_btree.c      |   5 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  24 +++--
 fs/xfs/libxfs/xfs_dir2.c       |   4 +-
 fs/xfs/libxfs/xfs_dir2.h       |   2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   4 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |  12 ++-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  28 +++++-
 fs/xfs/libxfs/xfs_ialloc.c     |  64 +++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h     |   1 +
 fs/xfs/libxfs/xfs_inode_fork.c |   6 ++
 fs/xfs/libxfs/xfs_refcount.c   |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   6 +-
 fs/xfs/xfs_acl.c               |  15 ++-
 fs/xfs/xfs_attr_inactive.c     |  10 +-
 fs/xfs/xfs_attr_list.c         |   5 +-
 fs/xfs/xfs_bmap_item.c         |   7 +-
 fs/xfs/xfs_bmap_util.c         |  12 +++
 fs/xfs/xfs_buf_item.c          |   2 +-
 fs/xfs/xfs_dquot.c             |   2 +-
 fs/xfs/xfs_error.c             |  27 +++++-
 fs/xfs/xfs_error.h             |   7 +-
 fs/xfs/xfs_extfree_item.c      |   5 +-
 fs/xfs/xfs_fsmap.c             |   1 +
 fs/xfs/xfs_inode.c             |  32 ++++++-
 fs/xfs/xfs_inode_item.c        |   5 +-
 fs/xfs/xfs_iomap.c             |  17 ++++
 fs/xfs/xfs_iops.c              |  10 +-
 fs/xfs/xfs_log_recover.c       |  72 +++++++++-----
 fs/xfs/xfs_message.c           |   2 +-
 fs/xfs/xfs_message.h           |   2 +-
 fs/xfs/xfs_mount.c             | 168 +++++++++++++++++++++++----------
 fs/xfs/xfs_pnfs.c              |   4 +-
 fs/xfs/xfs_qm.c                |  13 ++-
 fs/xfs/xfs_refcount_item.c     |   5 +-
 fs/xfs/xfs_rmap_item.c         |   9 +-
 fs/xfs/xfs_trace.h             |  21 +++++
 include/linux/iomap.h          |   2 +
 41 files changed, 523 insertions(+), 150 deletions(-)

-- 
2.35.1

