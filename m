Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAC26DEA5D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjDLE0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDLE0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:26:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA56468D;
        Tue, 11 Apr 2023 21:26:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLFxAP005450;
        Wed, 12 Apr 2023 04:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=5LHqjfptjS1ALk/1GfSTNMkOiGnbarqU3hcZmJG2KkQ=;
 b=wfOji0KkSJAFG6xlrv+3gWN8OVAGpgXGkrNLIopEpf1EI/I8ShGstkXO4jEwPB+ZOCmI
 3aAAlvdxNz1QM6f/jbEQtuC4FcQEtJHPNZ21CjI1a5/w83/M5eM/KBRaXgZLNB9bILMh
 6fxlAY1NaOSASnPyjrxgRxhIM+cqWoqC/Cxlwiy9x6ecnaJQnKngiQjoLtU4VkY28Zm0
 TYBq0Jw+BDTdFv1R1oFxslozphpooR4cnGkNFYbcSkBD6GDz2IM/AvHMGMW6bz3o8s1u
 9fFEUR5E38KWOuqFKZ1UlprG35IaPdt4BTz/O9utSc8s/EJxPRXxZ8MOX5PDqLhvlWAW sQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7f0hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:26:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2Voof009839;
        Wed, 12 Apr 2023 04:26:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw880bmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTQIFYkhJrs4fqXvikVmyvZLVv6IbQV5VwtmeLP1I+bjRuFW1iSZpIXek9Kic5JY1ABdE427y2kutCdFD5WQNvBfk1Ehe9ECCGjJ/lDQAS0RP9LuJ6iV/CUCZzON4Xspc7ycNMsz0nkZ/dNg37+kyRfq00gwmkG1H1KyFLA9Wxbwn1EQu8cbOiQdhukQN2aixqXH9ByGxoBRIIsEKsuMkybIvI+gaP+HOEQVTPv35W9O/ov1WTXsnfEGyrM+Q0TQBoZSusXuuQw360W+vZeeJ4VEXYpRiRX9lL5DzRRmuUQroogdTQDZxy3hZwRNcGRONdkpxWGINcicNuXBhpMwpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LHqjfptjS1ALk/1GfSTNMkOiGnbarqU3hcZmJG2KkQ=;
 b=MmI1ftb9Rq6cs2QvPDDJ5oSlqLDxq5nNjICuXGWLc4Q5FEsuxT1Xsje3Wncvcd1fj8Oo1WTWzGIfNWlefAP8CB1ndCDVIS0mrM1hBbQ6He9MYKzs6/bI7QclbRBOxeauQL6bSUi7B/kRYHj3jCKxhr9iNSvgafHXzfxjaxQw3ZDFEtKs8RVzC3BOuPT5wXtjtK0/DZZujDBUQnFmHElilyUklvEKj3+hblKkXewHrT7i28WrPY1vfMrzG0mTomHRjbrY3Yhsqbmkcdx1HAzPoqCqGBK2XFMtfKwPQPH2BnKwSGTojKRDVwP4YRbe0jgPwgbdwp54BX4ULmjOR0lONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LHqjfptjS1ALk/1GfSTNMkOiGnbarqU3hcZmJG2KkQ=;
 b=M0NN7OJQRqMmH91cCjrplbCijxwaK8OVWqNSiZwUkZonCUamiLljkvr78UB58Jj97+O8Kc+kS2ino4S9Fy3/Wxs2vxaetH+9wl/zyAGlSNqlPV5saSb3TD3PVG71+08RLgSYZLEU4VAzifc7CeUe04DNsYbZhpLXeKS9Br3f6MA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:26:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:26:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 00/17] xfs stable candidate patches for 5.4.y (from v5.11 & v5.12)
Date:   Wed, 12 Apr 2023 09:56:07 +0530
Message-Id: <20230412042624.600511-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0198.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:385::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: a989072f-dfb9-4f8f-b073-08db3b0e1817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FfLaxsCR+NckmhXuU19enULdtUfZ0nS5qXYhpp6MTPLIxnP+WMwGrOiy4ycz3VINDD/UY/019rPeXwp3yAiBLCohYBU+cqPmPiLZ5vUfimZoeX4o7swSSyBxmQLlATVTTS31rDVhxfavBsUGK/6OBqFk3RmebfTA8M1lbQWPXR8QnrZ5GHPPaJlxTGzwrTi6b9HcKZJjDEi4zdPr77kyrxBkCF8frXZ8UUtWGQTpZJFfnd11Ai8Iu0Kx6gAKOM+s8SeEo0tw9RqvL264QLG+xn7cJY+dE9lv/NE/liaQM42Umj7J2SZakZoqKyip3jQx16bVXHeKNVdblCILmpDN0iA6upJnzCOdfUKuzN8VWjqPfaab2FC1KgyPnIRuCSiLCUr/kqNSOERnHVQgnamlssbgXe+8bbLxDz2wyve9XWeDE94XKdbzme+YmDmNEttHENsipn/WFtztHDMO5iH+yt5HoBCdCdW5CYK1k3zHWYYUGIYbsgMdpwbsMABns7DFdr61ZFobg1MRlLU2l6x3a7nUmeQ6R8Q3YjimT5rOQNxp/CaPMgG4PhagpY0p1hi7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(38100700002)(66476007)(66946007)(8676002)(6916009)(86362001)(66556008)(478600001)(4326008)(186003)(2616005)(26005)(316002)(41300700001)(36756003)(2906002)(6512007)(1076003)(6506007)(83380400001)(6666004)(8936002)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6MLqz4l68B3SSk6NCqD7JVzP0Hsro25RVUZvOCqKZgUf/i/MaHLLI8HCtDvd?=
 =?us-ascii?Q?fvBLvnmxE10IxSoUxlnWdIW7APA1z5bOVUwu2MnSuTCn6UtXzNbxU9uB2qn3?=
 =?us-ascii?Q?gQ6uckCNzLlM9igu2Q+kqDVUX/uVsCy5o6lmw1sys4iaEm85iyzQQW3E/luQ?=
 =?us-ascii?Q?2tWjYnqrjm2WRhqakZuhctfFF6hzFF2qmLLCpy4l2xXflDic6vpnblvFGj63?=
 =?us-ascii?Q?YGRsZQ3P2V/sNqrhrL3PERE5mwjYUX7hrZ42wt8fSaAVx3CZpPtmMNMGV6WQ?=
 =?us-ascii?Q?LkkPgf/7sTQccOkOcIjz7SJbI/45yFWU8ouhurZCj7wa5GzzbwTZVX2GwxMV?=
 =?us-ascii?Q?yV2YdU3Tj1k4fQMCFY9wP1lEch4plt5892uoGLkyAI+60A1r1Sw58DLn0fzL?=
 =?us-ascii?Q?+ag2/tBH58L09906zbcm2BHTByUboEuxKVxmOcDmv/w1VkX9clDf6DmU9UIs?=
 =?us-ascii?Q?Q7ubC3wKnef5dEKOXR2cLTJVcFww6h7GlbXlP1Cc0vgAmSjecCZ2Yoc2f3Sd?=
 =?us-ascii?Q?i+Gcetk37r4qJcSiVCPK6Chb2IFENebRprsFTb2w1sLynrk6qvyAU3mTfrzg?=
 =?us-ascii?Q?gxptkQBsixOve1uLqJKKl8pjeOafSXsI56jQ43+5l+GOfE6E0v3piSvFuil1?=
 =?us-ascii?Q?vxCJtWgI0pYBw2WMJHm0QhK59gBtA3d1FSX1QEHKBlEC6khSvA1d0oXethvW?=
 =?us-ascii?Q?NuyzZYX5gtCr20ikl2jFTL2yQ1fUA/d/Wi/qJkUTsyr9mkuhlDUrYNg9eFu9?=
 =?us-ascii?Q?UDx3lH8xGPIRI3cIQrFOOzrkERRzFsmxgEVB4K4WGJlEscfttCJhOb9NSEOa?=
 =?us-ascii?Q?rwoNoSPHEhQ4AT2ftimrSDciOmO13DvQ8JUbzh1cqkb7hJwQNNSmjgvayyWq?=
 =?us-ascii?Q?RE6W7bueIxaRgFTqE6LYcYTW4vqqZvZyuWX61ineumwifgW5wmLHSpq4KufA?=
 =?us-ascii?Q?K31xg5W+vwjDCP6A2vigk2ovsNTj0YdlrMYxJzh5KVJwLXDY5q/nhiMSXRfc?=
 =?us-ascii?Q?gdkabwI4tGCRbTRJZmGQZjehUIQPNSy2W+bfY6R7roa7CEbUIqZg3AIzSdZm?=
 =?us-ascii?Q?zJAKXLxXycu2GFWxNDhgQS1dO6TK7ZKVgrLSNTgjtTxBTzDDaaJ1oW5kFn7H?=
 =?us-ascii?Q?fLAjQ8CsZ0MYEcGo8bqdlDVEf5Qoea2zViRpPZROv0ORkMHj2t0d+XSM0oLI?=
 =?us-ascii?Q?OkP9xYkEUJzXXdKO3MMwTYzi/0PAZuU4c61q06B3vxb/bfpkW8Y9N+kZ37oQ?=
 =?us-ascii?Q?ORTmxM5sHReoUpje+NEt/aXsKAph53HSN0eA0Tk5tUl4quc9MUITCIdnsMHk?=
 =?us-ascii?Q?wU+h0hmkc1TWOvNvz7TTK2slUV4dsU2C2p1V4yMrSW2omjJ84+M8rPmkvLSk?=
 =?us-ascii?Q?AfWjoZy7XnrJnn/GAXzZmRzET6REMabuJ1as2bQ661oiH29uYrHdHEsJ2iZT?=
 =?us-ascii?Q?IY+rfiAyy4CMDesn/cRUhsrnjO7KGMG3/rkzqNdHcFR7XcQjMwuOjUV2sawv?=
 =?us-ascii?Q?HSAdAIA/xtIEJFK5g6xms/uy/SxiKI1jnnyctlslC//I80X53dvTGnPHkHMV?=
 =?us-ascii?Q?Oc9wgqvFGOOwk6lb1avmq9rcVRYd2LRMUNBiSD5D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WS8bYP9kZ4cXDdN09vnF6ad2R/Dk35gKvoO7a5rPkdsmNgsmK/3QklKjg4ynIq+1/OoAz7LtyqmfcrBr7yNeRaGKxyslwYjGpMqpCXUK+kd/nV2eHqbmjBCXGFMl8gKi/OecRE2ibV1hgkx6BaQtpXttWnQZMbkSv1v2SCG0PsKINjjzOhHywVX2MG2JM8oaaRjs28ycx+rSOTknKtzh0o7/wkpg+6KZcV+9ndRbC5XKtxbeUh3CS/M/RPxxiMMEJr3yLlM0Rt9iSfzS/Uxd7gSDgLr6CQMEwnLeRL4HRtBe1PnYLx66gm6IbbET0Rs4JUk2wovQQeEq9KLw71F/s/Uby7MHYpAx93z35mwqvj7RKyPnagfLB/deNDY0Fpwr34/Zrx9A+8llQ8F5LGv0BGtUGYDgHpH35hbp881yxgoagMEer0Q8mdN7L16RWP3TFl/rgq2g7284M0By1+c6kRur6d6xioKKIoNrYi5r0qprWqKn89oW6wW8byBehUrob1mVamuXFQwCnQlXBFWQz9Gnlq17Orewp0uvG2BvTatz54S/HZYtBTEPF0zm/8eabDT60LV/Eldqojrcbo3cieVDcom1IcRseS4AAx+gn9rS/X6d7MosMXsAkY2nfVAvEvpYBYzGuo3o9M3Ca5C4tHfnW05fDLDl61cQuU0vuPzRWvptWJNlQouBVNijiLhUz+QxyICRTKX1NOUIQZh914impo8mTKlhXEScfsEtEPHYfx0SUgyy45Xtju7N/cK0B+l9Yve1tISiWxysukbs4jNfyqt1dhA2NUDHR0WG5gSD4D6+NyvIOZie7elaHDtPhsF8p9OGBRbM24U7nxCZANmZV83/ANFFbGJpjGCKz0WM9RetcRaO0iA7Hr3T+iHi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a989072f-dfb9-4f8f-b073-08db3b0e1817
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:26:32.4441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEfx3DxRkgwJCV2uAnmJAcjodTgSZQ2j8UKzSfANPAAeYHLlIMN6zx/MzI8iIhmqFF4G6X9Sau9Y4/yDaVUOVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=934
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: 6muG1YHV32tAMWYGxO3V2W864tIN8eJo
X-Proofpoint-GUID: 6muG1YHV32tAMWYGxO3V2W864tIN8eJo
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

This 5.4.y backport series contains XFS fixes from v5.11 & v5.12. The
patchset has been acked by Darrick.

As a side note, where applicable, patches have been cherry picked from
5.10.y rather than from v5.11/v5.12.

Brian Foster (2):
  xfs: consider shutdown in bmapbt cursor delete assert
  xfs: don't reuse busy extents on extent trim

Christoph Hellwig (10):
  xfs: merge the projid fields in struct xfs_icdinode
  xfs: ensure that the inode uid/gid match values match the icdinode
    ones
  xfs: remove the icdinode di_uid/di_gid members
  xfs: remove the kuid/kgid conversion wrappers
  xfs: add a new xfs_sb_version_has_v3inode helper
  xfs: only check the superblock version for dinode size calculation
  xfs: simplify di_flags2 inheritance in xfs_ialloc
  xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
  xfs: remove the di_version field from struct icdinode
  xfs: fix up non-directory creation in SGID directories

Darrick J. Wong (3):
  xfs: report corruption only as a regular error
  xfs: shut down the filesystem if we screw up quota reservation
  xfs: force log and push AIL to clear pinned inodes when aborting mount

Jeffrey Mitchell (1):
  xfs: set inode size after creating symlink

Kaixu Xia (1):
  xfs: show the proper user quota options

 fs/xfs/libxfs/xfs_attr_leaf.c  |  5 +-
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++--
 fs/xfs/libxfs/xfs_btree.c      | 30 +++++-------
 fs/xfs/libxfs/xfs_format.h     | 33 ++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c     |  6 +--
 fs/xfs/libxfs/xfs_inode_buf.c  | 54 +++++++-------------
 fs/xfs/libxfs/xfs_inode_buf.h  |  8 +--
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  9 +---
 fs/xfs/libxfs/xfs_log_format.h | 10 ++--
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_acl.c               | 12 +++--
 fs/xfs/xfs_bmap_util.c         | 16 +++---
 fs/xfs/xfs_buf_item.c          |  2 +-
 fs/xfs/xfs_dquot.c             |  6 +--
 fs/xfs/xfs_error.c             |  2 +-
 fs/xfs/xfs_extent_busy.c       | 14 ------
 fs/xfs/xfs_icache.c            |  8 ++-
 fs/xfs/xfs_inode.c             | 61 ++++++++---------------
 fs/xfs/xfs_inode.h             | 21 +-------
 fs/xfs/xfs_inode_item.c        | 20 ++++----
 fs/xfs/xfs_ioctl.c             | 22 ++++-----
 fs/xfs/xfs_iops.c              | 11 +----
 fs/xfs/xfs_itable.c            |  8 +--
 fs/xfs/xfs_linux.h             | 32 +++---------
 fs/xfs/xfs_log_recover.c       |  6 +--
 fs/xfs/xfs_mount.c             | 90 +++++++++++++++++-----------------
 fs/xfs/xfs_qm.c                | 43 +++++++++-------
 fs/xfs/xfs_qm_bhv.c            |  2 +-
 fs/xfs/xfs_quota.h             |  4 +-
 fs/xfs/xfs_super.c             | 10 ++--
 fs/xfs/xfs_symlink.c           |  7 ++-
 fs/xfs/xfs_trans_dquot.c       | 16 ++++--
 33 files changed, 248 insertions(+), 334 deletions(-)

-- 
2.39.1

