Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388C0698D82
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjBPG77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBPG74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:59:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FF1EB50;
        Wed, 15 Feb 2023 22:59:45 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2JGSR000601;
        Thu, 16 Feb 2023 05:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=g3Vfn8+U8hUNNJcPHhJs+hzc/hGsqgvD6+54BeDNtIE=;
 b=Jd/F75SCIQee9W0MR0/doinJL5UMOjsKwjRSr+1OpHC1tSMjuS0yTXWqVyxWXvig0jIQ
 oE4nBy2K5y+wihtrpamvZq2b3XR0/Y7L+Bo6KTfHh4gJ5W1beXySw76NFLemi2geKxTt
 qE5mzxjnzNMmL+O1TEefyZeyJYJg2YOUlQQKvbgUgeH+YG85p6U1ubq9k8V2ZzdwkDwx
 YM7u1wzv2t07mnPgduKJVn+Mr0Pvk4orxeTpBMXKhkgRcV1n35DBLN9RWgsPI+wZ7+ij
 EFPdOo8er1vJUKatSmmdcpfc5N0q9QshG4W2NbP08KWVF+7LYgKNyK1lGAw8Rmu4sNQx Gw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3ju26t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2T9HV015162;
        Thu, 16 Feb 2023 05:22:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84bbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnYaKo6hhrKg4zycolTgG9s1VB93FabNqE+gB6GhaYrpaNHFjw+ZFtmCYg5xYHonkFtdcH7yoCqcsZU/brmbm0SyYqc4JhBKPRxf8qDrXcDjDcXWiMugloUabNjXjG9ksIlZ1rLytZ52iS1D0R4jd+ljzhZ7SumyNb/wLUBSxPUENOxS4qP9KUQqBC9L9TwITSADMNLMeLnxvwQWgfAR+Kz0g4BK4jY18zjpThmSu1yfmoZraRhLGUm3gQNCXmF3yFqbGGOTvn6N7FT2KoyOVOHutsXD0PPH5aGF9FsTiq/5LHmYKFOWyhvQ9Gh5D92sQOmCX+HXQfmAVykyDZ66tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3Vfn8+U8hUNNJcPHhJs+hzc/hGsqgvD6+54BeDNtIE=;
 b=jz8aSEJ1dxhnD5vZK0DSMmR0iiOi7/0y5FAj48u2SEZ1+o3VIKQ705zjWTsH7bxZh5saYYCVOqbjA250bi1yG8KPeP7CBcew81WEocbyoebNar2fQ8jkcy/1H6MzdOPE7aiM7Rke2a19gWTftEpHcSsgInWUpbIsNptZ7G0GBjOyV0A067+3MU3S6WmxtG7emHuY/JMUbE2lbjfHYZx74QrgaFnKbruXRetP0Ie2uRKrRw0T0DjcFqwiHiPCBbPB1s3SIzSzCWbwQjAUHoowzsSTP1TX394mYzDqFbqar1D6tnFPCcaOUhchAVo5IJb0lddI97KNrc1nsH8SUE8k2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3Vfn8+U8hUNNJcPHhJs+hzc/hGsqgvD6+54BeDNtIE=;
 b=ur11Ww14l3wt3StUNV62enwZENd9YItTvGkagbiWinisF2FP0UBDsNYT7qXhbQsrdTfyYBuRvP8S0IjI9gffr2h2AlZ+2i7X1mD07xQeX1Z3iXzgTIc7Jtj922ecoKszkXMJ3lf6MwLkhepgzya7SvCcgrNQHy/10P5kWCfcUXw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:22:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 16/25] xfs: fix an incore inode UAF in xfs_bui_recover
Date:   Thu, 16 Feb 2023 10:50:10 +0530
Message-Id: <20230216052019.368896-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 3653c996-9e5d-4402-0ac4-08db0fddca29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDg7sXYHf5+Sk3aAlEtdnFPfCNIn9YtrBB3BkncFkVH+XB3cIrUpgqlJ5GQPiMvEikioLwvT/26h79ANlBuy39F7aaPrTmyh0tL/KusRy5SlhWmZgTM1Rddx88PHiVXLaZviiGrv+yq4tW3JcRmyU492Q1gKybXQJRHU+EnYKPua21ay/jm0BG/jJkm77EIhronQnGFryZmrZ6NN+FQJsg0m3R/vWM6C1HeTIzLUEbMsqYqIo790N2IBmCYd0U3GQZdkeI+HT+jbW/RMyURX9eGV4leJ499z3vNjsKjr5YsnFTi11liXkhghUof9T7gfjiLV+xaWDjQpLikz1cBDI3t8ABcMkUzXvWi6/9NSPqN/fhw8LzKaQ7CLtaHtvQLpIy4JgtGdPTbuDEeGiES4XKfVAjhnmYe8w/ybcmF5zEspzHJmlowH5UgJEHyrEvX/Iz1FSi/3QSMDAZoiyQOByZj3l0lwwOx6GDJD90yj+IFQQ5mx6FQuQJjAooZmwZdpVFCUYxRV/z0mnw0UIsFrGZhER638J4x0dgP6yQBjOb6h7OP77Gh4Zsn0pazcM4Ta7K5ZNCXhbpUI5Y+Kg3I9TUY0+B/3fVhbdRoWbOfsVog99u5GoljnCBdZHmmzSTlY2glqZs3yynaixWnTB/bC8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vOTJgc6V4v0SjoCK1zDNAX1c85uYdndHX/Z3t4p5CVcRh6K/nS+ZTRj9mdS?=
 =?us-ascii?Q?XfPn3Xp1h2nnxvAtoJetxCWwRSbVbUU0SKbB9/fPq3RDALkxekiuiDtfK2Rc?=
 =?us-ascii?Q?aMmLHIZwD3uCns0JLCyiRyuJLxXir/b95Q0B7//EMT5CALANMZ0gvav9UJX7?=
 =?us-ascii?Q?i9Ggt91VMCZTZdwpT3VMpLI5B/hqhpm92Juz+ncPjH6IfaZu9z5w2Y1R9BJx?=
 =?us-ascii?Q?wQ7sUs4K2VuEwUzlzf/vEFK0Udl0zUW5lC+i5o5APcccl15SIMjOXnqI/aWc?=
 =?us-ascii?Q?W0bCaGXxEFe6xo/tN5l37O1SGiheS0OQffJZOFSIfimG1oOlqU59AUUGDnm8?=
 =?us-ascii?Q?qnB3GsLAKBRs15E07MJCiRHmyEHO7TSQPTSTIXZbt0Pez8aNr2E57fAHykRM?=
 =?us-ascii?Q?KLSAmKrdWWpk01M7kLsddco7QMpVtTIDbTq4CzAIG/Els9h8o/9LikzkxQZf?=
 =?us-ascii?Q?I2AnWN+3si+/ItgrYIv7SPykumwMiwKLyJAMmVdOl61Scm3TojJ9Zg95Y/wj?=
 =?us-ascii?Q?viuGQIWMmMj83gkV5PqdlxtaUeXc4Mgx7fV7liL9dMQsBAT+4UmbUM/z3USz?=
 =?us-ascii?Q?OVpS6ow96RNl8n+Fr8kdgwMrUMpxIOuGhnTg330o6STo2mDNuCDs5gYshNo1?=
 =?us-ascii?Q?RXBfdvfeUYHuKHPFE6NIOVfmJBaUAkPclanr65xDp2gPYByxQWHmeZGmzwXC?=
 =?us-ascii?Q?BiW8qLKayUtUCnZOO5oX77GLSYipJLSrcuEjG3d7tBdYjAgxEXmT8PdCaZYY?=
 =?us-ascii?Q?Oj40yWiEcik/vaznoxd8gCriXgsm7WfFUQXn+XGzD2j5S1WseFF9DhX3zYV2?=
 =?us-ascii?Q?zdmLNngEamNZLcgTKeBsqshpljgSepaWTX3rC2iCydllMN/eHUO8ZdaL3YEk?=
 =?us-ascii?Q?44DsP+XMYdRxXHaPPlDxrp/UfWvXfYysz8aIlc3UWFgr0ulLNfAryufEQpwO?=
 =?us-ascii?Q?m5hRFRHL79B3NwvUjOzzhjXhZRn2UXYzIdT3dsGDS4FW+wieGAZ/EF0+4ieL?=
 =?us-ascii?Q?s+8E+jCV/Gj9d5GYTov+UtU3SR9QPrvhgmYPhAoHxc4oV1RnFzzowCdHy7p3?=
 =?us-ascii?Q?FvtVH3q5QB2u3H9RhHsB0jorENoAMm2HNmqDTWkesb3dz50KT7jaiykmNeJd?=
 =?us-ascii?Q?iUPRmHnC5aNFfuKLkrCgwgdyVKscftTMWVVvVV4CHsEYbLHTK54f6qOQ2VhW?=
 =?us-ascii?Q?xFpy7kihBc/r+E90HwlibyjbesR9XJHYCxJnl41SF7LS3N8IgHpnNoTBV+j+?=
 =?us-ascii?Q?ScFl54Gd414bhNp5Fs7hKG4YsG3+gXUzf0B/h9SKcRyj3PMfSjfMBAyQTf+h?=
 =?us-ascii?Q?BV71VsJ6B3ggTQ2dRoYC/rWs5kxxXKxMBo1L6u5qkwNz2R+Hf3RLsqF09WfZ?=
 =?us-ascii?Q?LaGcrnAmOhoTiOgpgMqeexR2JcPkVbcF6g2/s3cOLtrm7majf/2Kw7V86hOX?=
 =?us-ascii?Q?F86BOu+z/B9J69KtrSRUuDDFUcTU6xs2kdTHQKRvi46elVahL/hIevKGl1a7?=
 =?us-ascii?Q?bB6kfQDmhE89lnVfmVwuqVabJ9tC2or6uCZhdztQITqvmpVb8fHDHOE714n/?=
 =?us-ascii?Q?ZhjH6punQSYfDYmcI2m4CNQU23YW3Dwd8xT/9rSXD27ByGY3cuW4eFdmHPPc?=
 =?us-ascii?Q?ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lZus1ecNEJmXs8z9fnQjj8MIufy+Q4YNAhGlR6+5CASSuRBkxQ3+5xbU7zPXTFKyhv33MJGrE3obYx8zPsULfNVjnRSeeNrOH+RCZ2/pPZHP6qv17uyYpRU7fwGOXD92BqmODtS8j50/5tcL1VzIEs1YJoo1aI0ZGhc5SSNOJA/aLz52tVsKFg++4u/R3wvDut5UA03cq+0VWidOylOy6PoCnzTTqaLOVln8UBn6R95HmwK20uTM7GAhjAJA/mo9A4/47atfonSBSO8iHYT+amJRWusiy83RN3I8Dfp8xNOMd/YXRO9rNf7yndTy/Pk4SJ+u7VMoixtVL7Lh0v+sH3G7M7/riZSh/dEVrM3xBBXMaMi1tFZUkcZZA+W1/LUY2/RiTi8pq6NHYrTTVyePqc/bCIhcUy6lHGtkFGkkNioLeAfeEZtdZoU/fvQqlS5PAhEBLMjPMI/fcoyC0U3vuedn69BNLZNQOi3boGeAG81s30KbigqVhfMMCY2yXPZiBCbF/T9Dfm00PFk8UDbw9f+NaUDoCBirY9Pn/gSpMELWND/3I2u2X5jDIna4eM1FjOkNmIU1r4ARjnoHBa1JFDw7CEfPmACCnEiK8RYDlEUHxM5xTmJfa6piv8AC/2RKiD+iWtjvafoofpUui0IAn+xo/TzZ0QAL5miIQ4zyO9rgkcy56Kg71Gmta+bH/8iaVpaVUV1y6LwYL2vge6wg5DQF2OOIppkyp7kz49oYCCwv3tZO324q8nclHIYwO/SZksWFvQ20nRbIdzEpO4E6bvktKc3sR7OSdtD3NnMvOB7Z8YHjqrG/Qis9yuJ0VkIP/0PX276j0Fhd3qxcekeQIuA4VF9Cn4p0+3W3ZRkeA6H1SJf6OrHpo58b/TTzfwsC
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3653c996-9e5d-4402-0ac4-08db0fddca29
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:25.9745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Po4GTTCeboxjwzeDi9JyrJU2g+z3yLHXvC+miYwTpoMsqPDBiMTkCkRG93t+g6RGIj8vEK7II1vh3CM24XPK0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: j7uVYba_waNHtcu6hidSPjDSFBomTeSA
X-Proofpoint-GUID: j7uVYba_waNHtcu6hidSPjDSFBomTeSA
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

commit ff4ab5e02a0447dd1e290883eb6cd7d94848e590 upstream.

In xfs_bui_item_recover, there exists a use-after-free bug with regards
to the inode that is involved in the bmap replay operation.  If the
mapping operation does not complete, we call xfs_bmap_unmap_extent to
create a deferred op to finish the unmapping work, and we retain a
pointer to the incore inode.

Unfortunately, the very next thing we do is commit the transaction and
drop the inode.  If reclaim tears down the inode before we try to finish
the defer ops, we dereference garbage and blow up.  Therefore, create a
way to join inodes to the defer ops freezer so that we can maintain the
xfs_inode reference until we're done with the inode.

Note: This imposes the requirement that there be enough memory to keep
every incore inode in memory throughout recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  | 43 +++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_defer.h  | 11 ++++++++--
 fs/xfs/xfs_bmap_item.c     |  7 +++++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_log_recover.c   |  7 ++++++-
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 7 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d92863773736..714756931317 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -567,10 +568,14 @@ xfs_defer_move(
  * deferred ops state is transferred to the capture structure and the
  * transaction is then ready for the caller to commit it.  If there are no
  * intent items to capture, this function returns NULL.
+ *
+ * If capture_ip is not NULL, the capture structure will obtain an extra
+ * reference to the inode.
  */
 static struct xfs_defer_capture *
 xfs_defer_ops_capture(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*capture_ip)
 {
 	struct xfs_defer_capture	*dfc;
 
@@ -596,6 +601,15 @@ xfs_defer_ops_capture(
 	/* Preserve the log reservation size. */
 	dfc->dfc_logres = tp->t_log_res;
 
+	/*
+	 * Grab an extra reference to this inode and attach it to the capture
+	 * structure.
+	 */
+	if (capture_ip) {
+		ihold(VFS_I(capture_ip));
+		dfc->dfc_capture_ip = capture_ip;
+	}
+
 	return dfc;
 }
 
@@ -606,24 +620,33 @@ xfs_defer_ops_release(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_capture_ip)
+		xfs_irele(dfc->dfc_capture_ip);
 	kmem_free(dfc);
 }
 
 /*
  * Capture any deferred ops and commit the transaction.  This is the last step
- * needed to finish a log intent item that we recovered from the log.
+ * needed to finish a log intent item that we recovered from the log.  If any
+ * of the deferred ops operate on an inode, the caller must pass in that inode
+ * so that the reference can be transferred to the capture structure.  The
+ * caller must hold ILOCK_EXCL on the inode, and must unlock it before calling
+ * xfs_defer_ops_continue.
  */
 int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
+	struct xfs_inode		*capture_ip,
 	struct list_head		*capture_list)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
 	int				error;
 
+	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
+
 	/* If we don't capture anything, commit transaction and exit. */
-	dfc = xfs_defer_ops_capture(tp);
+	dfc = xfs_defer_ops_capture(tp, capture_ip);
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
@@ -640,16 +663,26 @@ xfs_defer_ops_capture_and_commit(
 
 /*
  * Attach a chain of captured deferred ops to a new transaction and free the
- * capture structure.
+ * capture structure.  If an inode was captured, it will be passed back to the
+ * caller with ILOCK_EXCL held and joined to the transaction with lockflags==0.
+ * The caller now owns the inode reference.
  */
 void
 xfs_defer_ops_continue(
 	struct xfs_defer_capture	*dfc,
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		**captured_ipp)
 {
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
+	/* Lock and join the captured inode to the new transaction. */
+	if (dfc->dfc_capture_ip) {
+		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
+	}
+	*captured_ipp = dfc->dfc_capture_ip;
+
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d5b7494513e8..4c3248d47a35 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -80,6 +80,12 @@ struct xfs_defer_capture {
 
 	/* Log reservation saved from the transaction. */
 	unsigned int		dfc_logres;
+
+	/*
+	 * An inode reference that must be maintained to complete the deferred
+	 * work.
+	 */
+	struct xfs_inode	*dfc_capture_ip;
 };
 
 /*
@@ -87,8 +93,9 @@ struct xfs_defer_capture {
  * This doesn't normally happen except log recovery.
  */
 int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
-		struct list_head *capture_list);
-void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+		struct xfs_inode *capture_ip, struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
+		struct xfs_inode **captured_ipp);
 void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f7015eabfdc9..888449ac8b75 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -528,8 +528,11 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	/* Commit transaction, which frees the transaction. */
-	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	/*
+	 * Commit transaction, which frees the transaction and saves the inode
+	 * for later replay activities.
+	 */
+	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
 	if (error)
 		goto err_unlock;
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 2db85c2c6d99..0333b20afafd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -639,7 +639,7 @@ xfs_efi_recover(
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1e6ef00b833a..6c60cdd10d33 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4766,6 +4766,7 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
@@ -4791,9 +4792,13 @@ xlog_finish_defer_ops(
 		 * from recovering a single intent item.
 		 */
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_continue(dfc, tp);
+		xfs_defer_ops_continue(dfc, tp, &ip);
 
 		error = xfs_trans_commit(tp);
+		if (ip) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_irele(ip);
+		}
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index c071f8600e8e..98f67dd64ce8 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -569,7 +569,7 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5bdf1f5e51b8..32f580fa1877 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -593,7 +593,7 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-- 
2.35.1

