Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AD860DB19
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiJZG3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiJZG3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FBE80E8B;
        Tue, 25 Oct 2022 23:28:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nEip013483;
        Wed, 26 Oct 2022 06:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=nyD/4jvZQbqhQe6rvKtiYJHvRmzdiUSDtuKKIf0McDg=;
 b=ei9PadoXOiAy+RydU9QT8HJR4256mnjNgJZ3OmJ2sB4VBiExqKoHPL1wydyw+WlaiYJ1
 SnVNPlySYL3bn7TITX0zalB7I6KewLm35sFEQg6zI+VWzCIMh0CBQLccqFqaeZpwoYwu
 IeuI4ufM9cNPthrtL2g3jNSwxX9RxKKS6YPiLJcXEQ5Ex47aVpYlYb+De7WxP6QAcT4R
 5Z6Tc/qVn2QluaXiMEFHct6U/hKSddGy45hpK+UaOKzvDcvyGsIFshNQ9S6dP9yJEzXz
 eIhuC+8plXZPITtMIoDlsfttvhXdy5tRYh/d4HUZfq+MDNXxmY5HWlRflfQNYEy/WJD7 rQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84t5hgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:28:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2t2ga031996;
        Wed, 26 Oct 2022 06:28:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybe708-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:28:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jA3Ycp/LzIrfFLBYZ7sw1MUOUi4rzYQFsEB1ydPxVhoMJCMN91GmIDJhLAd03MK4W6CHWByC66byKs0FJCsOQFB25dYihrf7fMKvURg9BsSQ2UNha9kFoGH0WZbT+pGgOjVk/RrBDDa1L11QVd9pH2lVq0pbI9Kz7IwGq2j9aLA80MMZe/wixKPJviDtmmvP/9p2NWspzun5BXHJqWBiCFyQFzRmkj163gJfOfYD3Cd0DPwlj7y9j6tXKsF7Qio1lG+kruj6iWhjTM5LxnPyOazPEgX4n7TilPA8eBpVVelss+X9A6oxBHPv6TOCjGTrkrXcs8Mr8Ws9Dy8ojoAOPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyD/4jvZQbqhQe6rvKtiYJHvRmzdiUSDtuKKIf0McDg=;
 b=HIOmUUkmmlFNyS3SpROtFX7KRIzs1iEkLbqULuJ6ELLTS2ELOtp8y5fJrMWUwSZPC7MvMDkO4LY+nQEhvGMNZc2YCQaaSLwBCq4QUgJFKJKeLuf/eTFGs6m4F6e4kmp0vUFrl16RPEX8uLaqL3m1VA5Y07W/FtivYcEE0JHSau3i3kb2YYyzk/EZDYZlali+bJUM5Onpcai0bc5n5BF+Wnm4vAOXSLHOCHzA49iSgNETp5dYbvutenTDqpgxxlY7en7RWNTu6qaBKMISSzphbuWLt3M5oFsn+RH+6leUq/3dzWeA1C25lO1f26Oa0vi4gmWd9G9aMVLDG/zsMDdO3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyD/4jvZQbqhQe6rvKtiYJHvRmzdiUSDtuKKIf0McDg=;
 b=Uqc/yD+vDD6bJjkf5FYOsJmlWARmB4v0po8Lj6lW+2GUMtH4N5ArIlgjnuFEi2OqNidJpihN964QA4SMqEucsanEijXNKg/hieeOgawVObaAQlCXmAbmkSvMzf/JAq3IovaUmGblDFJ6aA4gKcm9WvLwdUT9o2MO1+35ZSDzcGk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:28:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:28:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 00/26] xfs stable candidate patches for 5.4.y (from v5.7)
Date:   Wed, 26 Oct 2022 11:58:17 +0530
Message-Id: <20221026062843.927600-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0111.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: c153094c-37aa-41a6-2dc7-08dab71b5802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txHjEc59QsAyJFXfxCLwVD8WPM2n2lZJJh9PN310FMJ2e5e0yKTQkbJEVt5J3mK9iSOSsgBgIU9U8bFQbnApUIOVm0QQ4iYLPfRIOwNzeMJz3Vd6uztzkf2DI19MkgGtSd/1WquxvwU2wQjTOSg4SuMSs2taiBpbyrOrC3Abgh6adbcpu8jdjKHuc8nEjkWgFaOo/oXWhAQleGOuNXz5AqMJdRbR5CIjnlmWS7ehjsuwf5wQ9dzkoouONJNg77A1ucdf5fFEWXpu6KuAW/nNE8TVN7R5OxoHIbaC2a0qtfcImwV6ue8JB6XKOOyW5SHR1HL7qEH09W12iFz253bJH777ymd4hUhp+G+2fJJ3Rd8gw1U8OZyCfaY7DvQUlWnlcu0AYMKr+a7ICnqszgWRCd4T0SypyyRrunMTd1WNPhZ6NcE95daBtYVDq//T8WyzCAhzeAK2NZIAXjQLYDVO8pSjj1vtBSv4kjf/4/G6HA5WePGWG6mjneOwzjWK3L/D5w6f0dNx7zQ17o+3949F8h+9vPOaRnvoQufUpRWFSlJLPR9XWQiuM1fy2kP+o03K4t0rh2P7KuhZvugPIeUs0NgcG9Qd2s0pPDXK1TlGiHclGqVZvEIsPcXr5ZHSs3M0A21fjqSuyTsznZQKd23NTQl+A3ED7m8RBX6KJawTV9f92hOv96Pau5MLoPzU3rCuTnpLsHpB24p8iEmzAKB9+H4t6DRMrH45xdWSDPvDokL825cNAb60SdmKFntwC7yL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(66899015)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hHWdRMMC9rMqBLZBNrhRj2V3/0D/EdLpHTpIlH466DYfPMtprXcbGYHsLcWm?=
 =?us-ascii?Q?5YHL0hvAa8IcGpSkNs0yw/YbxtuG9tHwzNhi1QKTHIpjQoHn0xIC09WEcEDV?=
 =?us-ascii?Q?aecqZ9Fjd1V7GtImYSxKcEA61O+FJkrJVYmKLEH5tnoqbC7ZvuckYENqIeET?=
 =?us-ascii?Q?x5MZyKOAcLpg9MEbNXVx5uCZtyFQTtWnCRnJrYIaRa/f+oQj0X0yvJIJuI41?=
 =?us-ascii?Q?Y3JSa8NGYsZdcAmwmfMfIXZL00ruX93U9zIMMCrGa5pg3sn4SWYygX5FbzPz?=
 =?us-ascii?Q?2fEki3zXtB3A86qz10iWH53qHXdNJSvoXgX+vm+X/LZfT09XzZIR3tN7MxIh?=
 =?us-ascii?Q?XDD4R0VxP9WGnZB8m5Mcs7QpaVWEUN4bT1JTt/9V5+kJ4bQO3VUXiHDN9AEy?=
 =?us-ascii?Q?Gadt9CKun+68qOyp9/9cF4Gy2klAk/fbCjw1XSBn7cXD6lC1WZ9CSlfGjagB?=
 =?us-ascii?Q?JS3MTEbBkaqAz3W9AIdt0zRWmgMUn1yUKB/1wyNWScPZAX5F5QqXf115t32g?=
 =?us-ascii?Q?XkrW1PggGADI2BxPkNiGwYAUK6S2Cjm93nRLLXWE7sFxCG7bQGTBGiyCYP9n?=
 =?us-ascii?Q?F/QlKNiqK1/13bEPciMrxdpjPzL4nl2TlxMRYHVIZUuVKqK31rVp2XhzrW7X?=
 =?us-ascii?Q?drMX6/bAFb4L9DxL6jYXwbG+CA7A8Z4tGwC0PmMjYNHuEJ31jsEFmDSQrTF6?=
 =?us-ascii?Q?STH9Xz+Od+n0wg3yj54bCwfh5PFA4LQHbLTxx6AZDw5p1KbWI38nWllraqa9?=
 =?us-ascii?Q?5V3AfZeyAmMJrBj9PV6G4yaj8qFe+BkOaLVB23Dg2tbAaUFFKBxNc6FdLnLN?=
 =?us-ascii?Q?pfGiyllUkYES6+ANwm8D5iLoDUPGEX7drQLB9OUTDM3jI/N0cNHGz+tipH9S?=
 =?us-ascii?Q?1q9A7b3kIvICFT4nNLjr6jReTHAJVQG7uzDztsMB6PfhFNOceuPYkA2oif2L?=
 =?us-ascii?Q?Q8CuRY5pX9qqwmwwhxZsCOUH0u10po0GpSQRIzxgSCIcg3NvtZelGDFqAB8Q?=
 =?us-ascii?Q?DEVikDoovod2gogr7IFnxjauSUs5tXp2ruXCRK8Aq/KFvDYLWA5Ye0JUKdZ+?=
 =?us-ascii?Q?Xxkgao+/nqkorXG0mhFVlykqYrMz2x5Oewb7wzgjOsP+nbTZcVcnG8U/zhJK?=
 =?us-ascii?Q?2OBt48/5w2bxsbbHOGecQWynEvBN866yolPq5TovBRLINR/d1+zGhSkZnpIS?=
 =?us-ascii?Q?/ZDHvsJH66/Ob0bJlmpMspQT6Z9xHuJt3itqB4VfbyJOLi76ZDLejfpCDOdd?=
 =?us-ascii?Q?f3mDQlS1qnEY0JW30679G+JDNk9TlhhVl1AdkgnuunazhvoU7PBpCLtiULbP?=
 =?us-ascii?Q?1vX23zxS08dqhhOSKrO7ptw2prqDnassXe7N+RDGO+0rZpNhPoCuw0XwyBQO?=
 =?us-ascii?Q?jK94tUKrRbGZBjpmppoyfM+NjTemRTPGbzfQ4cuhNpFJFQNBq5BH4yQK4vY3?=
 =?us-ascii?Q?Px1e3J3IrQJcGHa0xmaCj4ApczwsUkliObGHCEuuLerartqVEaOK+2p9A64h?=
 =?us-ascii?Q?kiCqOpUw/jJwDUHWJ4/EzJaGHM1ikP1aQLpWl4sK9B8cYNuIbn3/WurLf78E?=
 =?us-ascii?Q?wJZXM2URz5Yd35uvvBKgUWPHnR1mq+DRbdWXnT+A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c153094c-37aa-41a6-2dc7-08dab71b5802
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:28:49.7383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bz/Yu755qpH7KTY8j/wTShhEJw7Cl154Bk00xwkUWo8UOzItJQWHcXRnrDvjWIJf9+VbdbVAJGu7Pus0yu4yMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: PvGzUShinZIj0pCZOKgXFtB4P1MP_h8L
X-Proofpoint-GUID: PvGzUShinZIj0pCZOKgXFtB4P1MP_h8L
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

This 5.4.y backport series contains XFS fixes from v5.7. The patchset
has been acked by Darrick.

Brian Foster (6):
  xfs: open code insert range extent split helper
  xfs: rework insert range into an atomic operation
  xfs: rework collapse range into an atomic operation
  xfs: factor out quotaoff intent AIL removal and memory free
  xfs: fix unmount hang and memory leak on shutdown during quotaoff
  xfs: trylock underlying buffer on dquot flush

Christoph Hellwig (2):
  xfs: factor out a new xfs_log_force_inode helper
  xfs: reflink should force the log out if mounted with wsync

Darrick J. Wong (8):
  xfs: add a function to deal with corrupt buffers post-verifiers
  xfs: xfs_buf_corruption_error should take __this_address
  xfs: fix buffer corruption reporting when xfs_dir3_free_header_check
    fails
  xfs: check owner of dir3 data blocks
  xfs: check owner of dir3 blocks
  xfs: preserve default grace interval during quotacheck
  xfs: don't write a corrupt unmount record to force summary counter
    recalc
  xfs: move inode flush to the sync workqueue

Dave Chinner (5):
  xfs: Lower CIL flush limit for large logs
  xfs: Throttle commits on delayed background CIL push
  xfs: factor common AIL item deletion code
  xfs: tail updates only need to occur when LSN changes
  xfs: fix use-after-free on CIL context on shutdown

Pavel Reichl (4):
  xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
  xfs: remove the xfs_dq_logitem_t typedef
  xfs: remove the xfs_qoff_logitem_t typedef
  xfs: Replace function declaration by actual definition

Takashi Iwai (1):
  xfs: Use scnprintf() for avoiding potential buffer overflow

 fs/xfs/libxfs/xfs_alloc.c      |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |   6 +-
 fs/xfs/libxfs/xfs_bmap.c       |  32 +-------
 fs/xfs/libxfs/xfs_bmap.h       |   3 +-
 fs/xfs/libxfs/xfs_btree.c      |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  10 +--
 fs/xfs/libxfs/xfs_dir2_block.c |  33 +++++++-
 fs/xfs/libxfs/xfs_dir2_data.c  |  32 +++++++-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +-
 fs/xfs/libxfs/xfs_format.h     |  10 +--
 fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
 fs/xfs/xfs_attr_inactive.c     |   6 +-
 fs/xfs/xfs_attr_list.c         |   2 +-
 fs/xfs/xfs_bmap_util.c         |  57 +++++++------
 fs/xfs/xfs_buf.c               |  22 +++++
 fs/xfs/xfs_buf.h               |   2 +
 fs/xfs/xfs_dquot.c             |  26 +++---
 fs/xfs/xfs_dquot.h             |  98 ++++++++++++-----------
 fs/xfs/xfs_dquot_item.c        |  47 ++++++++---
 fs/xfs/xfs_dquot_item.h        |  35 ++++----
 fs/xfs/xfs_error.c             |   7 +-
 fs/xfs/xfs_error.h             |   2 +-
 fs/xfs/xfs_export.c            |  14 +---
 fs/xfs/xfs_file.c              |  16 ++--
 fs/xfs/xfs_inode.c             |  23 +++++-
 fs/xfs/xfs_inode.h             |   1 +
 fs/xfs/xfs_inode_item.c        |  28 +++----
 fs/xfs/xfs_log.c               |  26 +++---
 fs/xfs/xfs_log_cil.c           |  39 +++++++--
 fs/xfs/xfs_log_priv.h          |  53 ++++++++++--
 fs/xfs/xfs_log_recover.c       |   5 +-
 fs/xfs/xfs_mount.h             |   5 ++
 fs/xfs/xfs_qm.c                |  64 +++++++++------
 fs/xfs/xfs_qm_bhv.c            |   6 +-
 fs/xfs/xfs_qm_syscalls.c       | 142 ++++++++++++++++-----------------
 fs/xfs/xfs_stats.c             |  10 +--
 fs/xfs/xfs_super.c             |  28 +++++--
 fs/xfs/xfs_trace.h             |   1 +
 fs/xfs/xfs_trans_ail.c         |  88 ++++++++++++--------
 fs/xfs/xfs_trans_dquot.c       |  54 ++++++-------
 fs/xfs/xfs_trans_priv.h        |   6 +-
 43 files changed, 646 insertions(+), 421 deletions(-)

-- 
2.35.1

