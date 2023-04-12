Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0ED46DEA63
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDLE1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDLE1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:27:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A357E2D7F;
        Tue, 11 Apr 2023 21:27:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLFwHE019886;
        Wed, 12 Apr 2023 04:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=KSj3scrn2U1idIr0piBZU49O11f7HU/3HtMJX0vueQ0=;
 b=KgFi/g2MYeunhWYBgzPgmpm+5KPcLYMk1lo6lS+koRclaoPwDRI/xl3x90HqX00HkOox
 kPqwSSli3saJpa0RBI90ury5MNXE+iB1yGZkzmKhK4VDKpXt/F/9PcrpdFAPszWbUKlb
 txiTSHgYEbVZtQ+NnkND0sokX2obaUazHS2E31VHLhtt1dKuajfM1f42Fu051xSm2WQv
 IrbKMbO67ilaPZDmgR2ORE4n3xvNHBaIQYgHQNXtxIDL0pk00UHXYu2S0VqxIAodEHL8
 hUZAQN48AMt1+nrpuUU0ZAvU7k9eCDD6lzd9DYPCUycFWO2z7XgIDG4HajMGWzHMaLBH Ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2y276-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:27:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2fjRS013074;
        Wed, 12 Apr 2023 04:27:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdq0nd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgWJhPRsNMvgVZp98K9XEeSKIgpcs5ADUP1FfmKZST6CaHyndQwkgzhQJLA2QZdKEvQlYqX1TLOptvmffzpL7LKp8nGDjJzy3a75MF5l5/57dlE6dTF/AIqkg3nkwcENcafs6Huy0tVkPShCs4pW27r9IdV7LT7qDzOaYIDfZO2IHeOr8Z+bTrCH/kGC1ysdFpr7n5fWsF3s8JZI/PS4NnJsxeEZLgY1oCxUr6+ylfebfNm58MUeTIozE5/jqcRSw4qJ9ZYtzQLhdXk01icQCZMrc0EqKOP7zaLhGT7n7/x1TJDIOy4+G0NH3aZVsj685/XW2IBxZZOc5hnfexJL3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSj3scrn2U1idIr0piBZU49O11f7HU/3HtMJX0vueQ0=;
 b=ByUPGFmknQpjPRoXzsPvm0VLAhIMtAjLscmHOq5LmSwrfI2WfHVpQtbnmA6b+c0+nuuZrs7sxO4i/3J+AhQTBBLhNE4MHLAnSAkRpqYQyYTp58mPKWYkJLPwLzsOqn/rSYKIHL+nCHxqse0O/R5zknIcIegHJJafxo+15L5/K1uLGwWtlHkKlWdriTEW6Gz9sEqlJfY7fIkQHIToHn/KJY9n4ElBRBRnwa+VVTA/iwlgLWctJGhwbAMZ8MlihagsuP/sGetqMI3r0QHbYxs5w1LatJn+Bf/g47wFsUy4TNnu8TwzrJQho2Npao55DYV0BVijVH+ScIf4Nzc+q1JLqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSj3scrn2U1idIr0piBZU49O11f7HU/3HtMJX0vueQ0=;
 b=H96V88Gm4Po3dmt8Kf48C1ILVy9ZIZcSVY5My7kaZe74i6biHSnmCM+ToYZI0NI8jy347fDbwgofP3vDpT60F7EqcP4/2i8tkfGmkr+udQ2YxV8AeBEAw/mISS3esvm3ibOi4YFlDldjcRAolNM1VDeQ33R7qP9YZnGXnYPFzWA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:27:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:27:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 03/17] xfs: ensure that the inode uid/gid match values match the icdinode ones
Date:   Wed, 12 Apr 2023 09:56:10 +0530
Message-Id: <20230412042624.600511-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096::28) To
 SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 4268d4c3-4ebd-4976-3ce2-08db3b0e3fff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3s80mi0+zRMq/VJBe4Z82Gabkwg03TT1mhMqlRey8hXquCEZ7ndMwaIUlFGLC5swQFdVSPslYxzmtsBIWp8/rTM3veEcbFRxN8l552cbAFPskqr9O1YmE5MT4+a2FSIS4YoRFRs1FGb+dTysbmAXkWh4EKtSM/GTrhoLXLgLtcGWjgo/ZFgZNNRSIZf6dlFAzUEV5OffwS15pyLZMQzRuuokH8Vicn1WEXxySx/ZNk2sFxbB/GDsqaVrGg0iWZvHOtfxNaMyW7ci/ZnIL5ZeR53rYSMU03ldX2xGLgT6nU0jlJa/iCMyCqPpse/YgkLZMn3sQ/BBipPlpJZ2s7MN1Z7GBZFPhu48FSBumnqONmwhbotH2tfDEW/4KyBaeeD4gCTU7aqD7FxAJALVvB4M5Fb99LrkyAQferZPs+LHaaluSh3rKkptsRnNEorRk4pBWUSjH5UGG90VQZc4Oc68owpaYYCK2LvRDz6w+AkenLHGn2TCtgJGT7aWMZE52FouHcTsd9NBGsLBA3QiXF0RXVCUP5aIMe6Lz4KwkfHXOUWe5RlYAD/AL7dvWVslBZYy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(38100700002)(66476007)(66946007)(8676002)(6916009)(86362001)(66556008)(478600001)(4326008)(186003)(2616005)(26005)(316002)(41300700001)(36756003)(2906002)(6512007)(1076003)(6506007)(83380400001)(6666004)(8936002)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PmhOgY//K37dEvLoYpTo4zYmTgS6MhE1HsWxE5513PGYp/M6jMCXwthunsW+?=
 =?us-ascii?Q?LMHsG1SJs/52UNPKYZo3PQ7l6F8LWqyb5xEUUuGGqVYyEnQh69a+UfTH4hVj?=
 =?us-ascii?Q?YwHsgEm9s5OX3gZfzEFL8gXHNgu1OkXxXklE1lnOTmga3rx6ly5Zw8TtmQxI?=
 =?us-ascii?Q?7ysBwygvGXWUSyEL2PPatC4YYy0AuBWU00mvkKZQQcqo0aAj53/gQCxSAp1f?=
 =?us-ascii?Q?V1lj4JyrmGz9GUtTn5OfNmGMwabT2UB7eyqHBGeejNf8XbxGvjGXUs9KgoK/?=
 =?us-ascii?Q?ERaK30Gm+vWGbPFKHY2rs7iSCGpnibEWnIwwAkhY3TC2S0/qwxfxS7miGJN4?=
 =?us-ascii?Q?exKMGJFkWu2IxiVeLUvK6Bvcjdeg4l3r0Hzm2B7i7QsRHa79r1+3ypewryFC?=
 =?us-ascii?Q?liyHrROkMQ2fjAUROEcgI8YS8S0iWdAQKTS3dkQ7JnPePo8edvwIOPieYEpg?=
 =?us-ascii?Q?hVJlBOnDCBOSndvrXIAqAW7B6g54+wWK29f7bNYcO4K8XUcUOpC2LFq3JhSE?=
 =?us-ascii?Q?VcSsk+hizaWGruqx8W+iCNB/MGpOjm0EmRqi4EjTGCLt3GVYOC/LLCGlXMnN?=
 =?us-ascii?Q?Gzyt+xikHrUGj7lOCgjfFUf5Pxhz6sR5tZQz9n+DZxp8eNv854wbLtZ1kISr?=
 =?us-ascii?Q?kFgV2MJz0AEUWNqSmy0nm5ANWghYDWqV7K5bMRi8U/WYMIZvHUOWk29Ppliz?=
 =?us-ascii?Q?48pXwjEv+sn5IGIH7JlEDUOK9TsKSAU1x4fyv1O6c3S+cnR6wwai5z3wOr9G?=
 =?us-ascii?Q?Vies2usbGaG5Wb4grVy/LwFP7DqHiNYE3KuUfyQUasz6D2tLFgNCKP+P/sl5?=
 =?us-ascii?Q?O6FVwkCclcbd/6Ewt6lJa7vu+0Zqd5Hy3W96m1oRX/lBF3exkDqhOtpyfaHP?=
 =?us-ascii?Q?au5YIdMhjewCPgqKIPknanGoV/IoCs+Qp42KLG6Ci+FrVXXQYIX5+0FHQFhC?=
 =?us-ascii?Q?06jroZ5VrqbRtv6x9wSz37SOGTC2Vb8grSo0KmT9E/uTKEwIp+YuiTiPD4E2?=
 =?us-ascii?Q?k7nCjAfNszhOGToARPT2KtpOFvxEiUcfYjng6Rw1xmWs+1fLKtfSEvUowKQT?=
 =?us-ascii?Q?EDMguNH2tTEc4QXm0TBI8fjx+CwGQXT7J8y9Q9pUS5IENN9xoVlkj6eEpDs6?=
 =?us-ascii?Q?valR4w5+DJazFTAJjRlAI1JMLpZxanW1J0Kx4dYJAp/gGePmKVCeNsftQHoC?=
 =?us-ascii?Q?FJSFGNfMxpFpJP6b+uJuy5Cmv0IPY1VnM3IsuprEs/DdIBzVvLBty9yUsqLm?=
 =?us-ascii?Q?g10pjW9hipOnxin+z76jwCWDgsovZ8vNSCOnOZGJuYOmzKhT88PKMwAGmBIk?=
 =?us-ascii?Q?xFTHfeYW3yvngJa1IizEMGCpE/Z56TIwzTsipJ08pOryzRU0DFHIQq6NyhDh?=
 =?us-ascii?Q?3lO+oCZLeDJ6fZLy1B21yeT9JjnbIi2dVks/kP8swyTJMmyCNF3h/NHxGcRb?=
 =?us-ascii?Q?/tRmL0ilzswOdnEo89GK9/n8vzQ/pHEjEHRlsBXm0SrcvhAJCJpr6xNxks4h?=
 =?us-ascii?Q?Z/GTaYvAiaSw6dZ9yXTu04Nw4bjuySu+n+3jlS3/6zxv4jkjbfPnAE8zTeNz?=
 =?us-ascii?Q?EKX/OGKKxhLzFUudSRUG2N59qCxp4MbRuewZu0Pf5xKmvcrOIKlc6QZEPulV?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: stbEsk4llurVeFMRZGUCMPgV7wlaCYmu8MR+sMoUui9RxLLYa8kK11acVOOdXdk/XJnkzoNho4S5hzVnBI041/0eH0oAcpjchXoAYtSUYruG3Q5fkjrSSieNGIcRgddAWgn6/PUVoeu1pyL1nJJ0QB6jUvzMEtFS4o+itmN1sk0XZU5dmKu1bR26+xYJFzDoleiX1WOgH06uJ7bv7kO3/NtMO4EU8VQj375GMe/D4xAuZZm11I/akG9ElnO24X5uvWEFjF+hkj0vY/sfXmNB4MuTCZRdwy4dtxMDwdiXpmBtiZwP3Rg6mhPRMNkMGUTQ6BYJUqXBPVnwEHVPlPyqaHw6XhQ/qbO3KSu/fBOEgNF2UDZ2wGuj9ydPBj5IzDNP0kzuy7ZYhZo/r7U8pwFnCD8MVlefk2yPe0GR6YdrdHCNZy5JrCVWSIJnGWzPHiBaFaRJzHekTKhSYy0xpg6Y4jq8eUR0f9P2KU5xts38+CRDTNUJqKm1v8DbN3daT5V/KOjhSmIns/W2gWTZl68U8jY6E/vMSLAyvtTs1d9TinchUB5HgkEoayIVJvb9luKVTz/pqoIvVm13pvZYAbK4WgJIl1NjrsW9N97xA0UjNxeivfl1IXhHRgnkBl9kz93oqhbv2gkvXE0N2w6EVB4OXcsDL2aZtgSuwZkHF4CQUiFiagznmcRZZKmHXMojpdmJYlOL69fSddkRL931LMWlBM2g81hpvlfxky7B9eHW73D6HoyTBqGjWAytZJphTfvYz7bg7oHSwFHwcemcoSFBCG2wGXhdxi6EHX7fSI4Ul2mAo+RBpv5ZuiC5RZ9aLalMWohOj2ObEsSTkAQzeChKo3CdghrwCwRWaBgnCEebLSCSBH9iFMTVcw7L3ZML1+HN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4268d4c3-4ebd-4976-3ce2-08db3b0e3fff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:27:39.3339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rb/qhmFBbDQv12f7W1epruS6fDEx/JR1FGG4oqtbhbXn0CVrkCFp1YAllxrM6EWOqSEgdJ1HeG1ay+VzUSDIDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=785 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: -hmkrHehAgM4EdxbVRP_7oO6AtzRdHSf
X-Proofpoint-ORIG-GUID: -hmkrHehAgM4EdxbVRP_7oO6AtzRdHSf
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

commit 3d8f2821502d0b60bac2789d0bea951fda61de0c upstream.

Instead of only synchronizing the uid/gid values in xfs_setup_inode,
ensure that they always match to prepare for removing the icdinode
fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 2 ++
 fs/xfs/xfs_icache.c           | 4 ++++
 fs/xfs/xfs_inode.c            | 8 ++++++--
 fs/xfs/xfs_iops.c             | 3 ---
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e1faf48eb002..c7e4d51fe975 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -223,7 +223,9 @@ xfs_inode_from_disk(
 
 	to->di_format = from->di_format;
 	to->di_uid = be32_to_cpu(from->di_uid);
+	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
 	to->di_gid = be32_to_cpu(from->di_gid);
+	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8e6dc04c14d4..f1451642ce38 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -289,6 +289,8 @@ xfs_reinit_inode(
 	uint64_t	version = inode_peek_iversion(inode);
 	umode_t		mode = inode->i_mode;
 	dev_t		dev = inode->i_rdev;
+	kuid_t		uid = inode->i_uid;
+	kgid_t		gid = inode->i_gid;
 
 	error = inode_init_always(mp->m_super, inode);
 
@@ -297,6 +299,8 @@ xfs_reinit_inode(
 	inode_set_iversion_queried(inode, version);
 	inode->i_mode = mode;
 	inode->i_rdev = dev;
+	inode->i_uid = uid;
+	inode->i_gid = gid;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 891f03a3fd91..99f82bdb3db9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -806,15 +806,19 @@ xfs_ialloc(
 
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
+	inode->i_uid = current_fsuid();
+	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
+		inode->i_gid = VFS_I(pip)->i_gid;
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
+	} else {
+		inode->i_gid = current_fsgid();
+		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 05adfea93ad9..838acd7f2e47 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1288,9 +1288,6 @@ xfs_setup_inode(
 	/* make the inode look hashed for the writeback code */
 	inode_fake_hash(inode);
 
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
-
 	i_size_write(inode, ip->i_d.di_size);
 	xfs_diflags_to_iflags(inode, ip);
 
-- 
2.39.1

