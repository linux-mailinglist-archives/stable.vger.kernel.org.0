Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC06DEA65
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDLE16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDLE15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:27:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75AA2D7F;
        Tue, 11 Apr 2023 21:27:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLWEfF016806;
        Wed, 12 Apr 2023 04:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=0SCundu5zg5URGOYEoNxaN3lI+2Fw9374h+cbnqDs+Y=;
 b=wfYMa18cjQINnNgV9yF7PYZ6LSnijlT8TNUSxSudl02O9SilMMNF7dp8bfswNnUpDDk5
 SseFKJuIQD74AkgmKU0K2uylypKrz3coCXtICgOYLOjzNT9ooDNHg8poD73KUF7UeqC8
 sF2OUm9Bbz1JJ5PQLBlmmu1mHhPO5mkd8Dy7l6XHFvOR7No6+q4uCTBv8iSvrjsXbQeq
 HvARbtFZSzSy/GMhChtAyBMU+mySvXeAuY+Bq4sGOLMVSfEWFRSkpkgKILO8bp6sfwMe
 7w6817wheBZwtRescoSbp9wie8JCb2DOD0sk3El8zkFIESAIIAlOishzzZyDIACHOQTO sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc72qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:27:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2fjRW013074;
        Wed, 12 Apr 2023 04:27:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdq0nh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgrfzbAQd9z/YTKBNp2IioGDNXMH6WRX/wXebP1kI3AcTf7T4VOTvK+wY1bs9n5G//J+4guwSDRJbVWm3f9U7EOM/CJ/Ifuyc2hj0zx282Rvkqp4tznk4mAz461jlTHlElzC4sUTHF0xBO4vDhcBA4HOp/ONzq9g90UQ0B1LI181Z2Zfz+T0zOO7wAHPKijxc3PVXWbTxe7mJpnGf1cGFbfV/QZTNFzmqx8aVps2KPQw9QMbSpcghoOxUBFRRAj/o0UC09pHQ81zHSWt1j0ZVJHIMS1XIBzMP97p5a10Q9yvklUQtagD8Bkpfj/4GCKSAQhQ7wQNU8SK7CTddlIOCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SCundu5zg5URGOYEoNxaN3lI+2Fw9374h+cbnqDs+Y=;
 b=kaybD65NgkSfwsZ8PLaoeiaNz7bBExmUAqx4a4MHJwVqN+mAB8Te4G/xg277x++/HlsU3QxwdB1ywXuYFuwnUxJy7h6veBipPwSQW76MlidaBaVi2YoHGEM2bV3lJ+Pblg4ZHpQz9/f2j+ODQRjTIuZtRANWFPXNQHyT0we5XZhTEVtn9Fr3c/NDB7DB5hRQk3c96SC9ey00vKxor3rMFodDpTgS3yoP3Kp7QQFqvhOMrwOGO2S40d/EA+CMZ+KSNXhMQ6ecknin8EwG+wxfnP20PahF5rVsNTXkiri0KIBu8zZLb1+PSuhUPOL2q38C7W94OJzF5ZCILvXzGupMNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SCundu5zg5URGOYEoNxaN3lI+2Fw9374h+cbnqDs+Y=;
 b=ssHqgP4bNn1UfFb6jAzAFEs5/M0qDwJm2BqnVrdO+8/LeljNbGhYaIAGzJihQwWW6xpcGLgbP/EbPKuTofeQ81yL2qsPV0AT1hXP/UVMJcD2wTaOKW0HdIY7Jte+YQovRdTnrf1PnJtzXYoKfZXdkXVnzIqw9QUOO7zjp+2Kzx4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:27:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:27:47 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 04/17] xfs: remove the icdinode di_uid/di_gid members
Date:   Wed, 12 Apr 2023 09:56:11 +0530
Message-Id: <20230412042624.600511-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0188.apcprd04.prod.outlook.com
 (2603:1096:4:14::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 986ee780-4d97-451d-0823-08db3b0e4497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q6Ldl7SHvwJ1erRaUwLgNNttNYC2niryCY/MIlT+vBc7qy6RW63/9GRMOiqCUxxpCJfjrhVK8JqtBqENbdlhWDYkgMosVQbd3hYoNMcOihzXVQdv9duJQKn8j8GgaEQIW265bh6olGgmBYHdZP9yOco5bTKQdiGHln3b8O85urqlNcXs658rTtd4uaYSiRPTItrDgxVDOnY/AwQZ34LHkiEXG46K0ggxpE37/4PNjQsUJE0f2KYEjgc8Jr3UsMYtGx/vs185rtZQ1CB6hhoxRZ0kqBY/2E2ImGox0R9BNs3Td5NqJDO0pFao9OXZ+5ookApGp5W1ckjFsKtU3nsv8q33WpaLsLcSUoTq7Ltfyf9suBd8DdrkV61iVnsGruDo2MFHTrwc1VC5jCaAGWQXmt3dgSPtuj1yo2f5sk0u9Qd+++OpfgsAYiypjDePyor2MB0Ph2ldukdpWeTUHg89SwK9s9+zlknwvuEozIoSwkBlarBIII0miciirJlTiTd8sKfZpmwUUHXymR1g6N8ARdmcTR25pFS30mDUnuk4omTd2KT4bzyR+o2ivfsI/40f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(38100700002)(66476007)(66946007)(8676002)(6916009)(86362001)(66556008)(478600001)(4326008)(186003)(2616005)(26005)(316002)(41300700001)(36756003)(2906002)(6512007)(1076003)(6506007)(83380400001)(30864003)(6666004)(8936002)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3nWNFZUNaQ2i+/cNLMT2Op1HUUtLGfb59YkIHD8IgospDjq96/kOwX0gRW9y?=
 =?us-ascii?Q?Cd7fKmRzvHzE+VgF4TgXzImS+TMeDSYmkwHKUU6HYswPkYLoO1oh5Z5Sm8v9?=
 =?us-ascii?Q?TpEJZkh6djOcawQ7VVJu2S0SGR3w+JhCnDwhQloJmjptkRnf8pA9e4gBNAPJ?=
 =?us-ascii?Q?PUsf0kQk46UNeGD9oHzhuCT7OR6RzextZCq/rdV7s0Tmzl5dg8r6fRCYEalK?=
 =?us-ascii?Q?iZozXiw7LD7sXIbfJrQKn3l/Z4Xw+qzlBLoOJP41CadMvDEVrl/6efTN+qFe?=
 =?us-ascii?Q?08SUUuamfzuDIEvajJcceEaQnsxg6XKw+RiF/+ozSu3mMkfm/MwdWRlSJukD?=
 =?us-ascii?Q?X3xzHNbnEmPeplZaDeLJurbwY0h8NFsIe9MeikiYzDILKDY5bejh3OGcradv?=
 =?us-ascii?Q?PPGrYISpkFw5k6WPZ4JZdHs70xaUIq04aP/4ToQJ8Xh+FB5XtuCYlgR3gvkS?=
 =?us-ascii?Q?9pfVav81KlCNfdkUIETc88wJGIMZBDT3yXFAq2P3LNv7RjJCt+fY6w+iknPf?=
 =?us-ascii?Q?7+qFmYseYNXzYTT8idCwPsbuxYyTNokXqrbjh7GPWVtWKEcVkj8GpPzoNTcS?=
 =?us-ascii?Q?k/scMi2Q+DB3AXSic9DgKprtK8aw89sfZXOzMlquLbbgTf2Ikg1I6X8J8hI2?=
 =?us-ascii?Q?c1QjhEXUEeItF/Fre+me4exEDqz91ZM8oVvOActISBrzyjul+AMyId4o7PAW?=
 =?us-ascii?Q?w0eKXZyBPEfOZIK+iBMBjvRNWnUwd7EYDdMXB29mUDQaV3lihjKWp9JEBR6u?=
 =?us-ascii?Q?srx4kMmSouRvL17yjh7X4z+XmGrV3Q9zaSC/KZFHZew/NX/QVJNkpBKkdfnd?=
 =?us-ascii?Q?iaphVmNKSHeJi9A82Or/2IahfIPJQHdHvLWPiIq0ei5M6HuALjlNplmUObL9?=
 =?us-ascii?Q?EVx3SBnCuUxPxWZreaDpGEPL02aXwAjrbljX3NDSE3kh71NN85DJMTjiDVfD?=
 =?us-ascii?Q?WQfWSC/Xa1SMUwAm0dOC30k7EYSTnNHWjbZ0azVKdUiihChvNw8JuofExCma?=
 =?us-ascii?Q?yddu5BmlgF00ZDjij43jLMFMuDHmN5DSuq6cJ9s1OI2DjY5mNIwreS8O7Szx?=
 =?us-ascii?Q?laRjIz6U95HVxoB11WYXnCIfcJ3P9Xw6s6pLM6/kfLe9vfHYPuqWIZ4vuPUb?=
 =?us-ascii?Q?V6a/9HFWAd6tGsnDLFDdv/5XE9iPVgKSGsOJ0AWooMzW+UUVSc965LwqnsmZ?=
 =?us-ascii?Q?6ESZ5EdwYdj/mBKnJG++g3OPyWKvtfhLdiI3Jv6MJ1+7SL3d+jEP/e0RU1wW?=
 =?us-ascii?Q?I6Hin1vWmhPUaZ7ok2uTbTv9khapn+KTyuStrmvIM0rOBIgGSFRP3GiIK4fc?=
 =?us-ascii?Q?OmW9Yh6iRr7lja0cc17UqlSZTu3JYUH46UyMLX3LuaYCtCdh9u6astEL5Jtt?=
 =?us-ascii?Q?lxqzlWVt2LGwsgFk5vFskS0h/HlzzOP/HbEOD7srv7JOCR9actCd+V9TOKqZ?=
 =?us-ascii?Q?8VCdZOEqYKlqEzLzYk9s/n3cJ0RUo6wnv1thvul0TC5Mygq6CCgQ1Qw2W6od?=
 =?us-ascii?Q?qXPta9I2/TnOovjQ/u5QiZxX5c/XW5MJU04n0PqdwFNv6OEUEG7lCzm9klby?=
 =?us-ascii?Q?Gvl/S0zjast/qlIVucl66Js9sVgJVD0a6e8usUP3tH0BPlDzowygFYStb5bK?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D98rrpqppPN9RJdCpX7ZCtW2GibPe3PJpw2rGbfmbWgC2OqYTVfnmcRiJpr8zk8dk6DY8d4YCp4Spxkq4rXzitD4s51mP6pdTJ/mDLqOWQzw7pPZhqsvmupX+haen4+1dLMqn4HIty83bjGfqL/hpqfXdPzh0v4CGJGOdVb3ILcoy2fmH6tfud/b8EvoY/PNkc3CRz3ZND9zBSTQsd3K/fY18CHaBUJVwHNgwNZUWa/m+pIY4sQxNIdndQclVodZjJraKazY9GUsiVGfrpRRNI5xDanNulEY6qCx1XxWa+D7KBZm5DYuhBEqLgt5/Stlz8raWuUJ+pGeBODWYHLcyOktseWqPF4UGznT+OpIP5lPapnqqCUJoD1cSOEyWcNDlyTJsvf4E0C/IjdCPzqRryjFaaAY1LSlPb2RPGPLuhayovr5JUqLy9qqCc3dIkCgB18XPb7fVSSY++IuGDKIdXz6aNpI8cn5yCd45im3OLV1q0dLkeoIdZLP/MUgpg2S9FDRJTWj/PLRZ8HWQbL9ZEBsB7QzrAxh6AEy+FFzE5hXYq86opzKVtgpa9hcSaTnBHz/MqAIpKOl2b1eJV/2s9JeXYeb5SyuVbh8Fcz/bA8walxV/sziPj68awoikM2D2maeYXi+6zMVXzOTtO7T5Uo7sSTU0945TcyKlfk5uKRYCg3WAwY7/3kHGDG6lamk5JkB9F+cGBjA2sNWDoGSGoua1E3RH9+pN7d14xP8yFdtMufhYzmMZh+H4Ras4XtvV06q78mPSChQXUsMv0LPvtXY5/UZ1juT6bsSYZvo/f2uDEmvU5LEIy8KmWriyIJZ4vw3r7KgXrnuxKW9Espe0zpfqn+nsvtPIpqKNzvewtBNZNQkpkvZD82mmn8V0br1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986ee780-4d97-451d-0823-08db3b0e4497
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:27:47.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EB5zRjtfGHoeE5NfIvLzPbJrKoG3LNnbOGeLf3ltGzXRA6l0PsmFlDwlE5bsuwVzx/fo597NKmclHzExmO4Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: Bbw7fp49w3s_xcsum1tC3R_OafSWtj5u
X-Proofpoint-ORIG-GUID: Bbw7fp49w3s_xcsum1tC3R_OafSWtj5u
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

commit 542951592c99ff7b15c050954c051dd6dd6c0f97 upstream.

Use the Linux inode i_uid/i_gid members everywhere and just convert
from/to the scalar value when reading or writing the on-disk inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 10 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.h |  2 --
 fs/xfs/xfs_dquot.c            |  4 ++--
 fs/xfs/xfs_inode.c            | 14 ++++--------
 fs/xfs/xfs_inode_item.c       |  4 ++--
 fs/xfs/xfs_ioctl.c            |  6 +++---
 fs/xfs/xfs_iops.c             |  6 +-----
 fs/xfs/xfs_itable.c           |  4 ++--
 fs/xfs/xfs_qm.c               | 40 ++++++++++++++++++++++-------------
 fs/xfs/xfs_quota.h            |  4 ++--
 fs/xfs/xfs_symlink.c          |  4 +---
 11 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c7e4d51fe975..94cd6ec666a2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -222,10 +222,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	to->di_uid = be32_to_cpu(from->di_uid);
-	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
+	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
+	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -278,8 +276,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
+	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index af3ff02b4a8d..0cb11fcc74b6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -19,8 +19,6 @@ struct xfs_icdinode {
 	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_uid;		/* owner's user id */
-	uint32_t	di_gid;		/* owner's group id */
 	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f59c3265dae7..14f4d2ed87db 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -859,9 +859,9 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return ip->i_d.di_uid;
+		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
 	case XFS_DQ_GROUP:
-		return ip->i_d.di_gid;
+		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
 	case XFS_DQ_PROJ:
 		return ip->i_d.di_projid;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 99f82bdb3db9..9d6ad669adc5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -807,18 +807,15 @@ xfs_ialloc(
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
-	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		inode->i_gid = VFS_I(pip)->i_gid;
-		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else {
 		inode->i_gid = current_fsgid();
-		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
 	}
 
 	/*
@@ -826,9 +823,8 @@ xfs_ialloc(
 	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
 	 * (and only if the irix_sgid_inherit compatibility variable is set).
 	 */
-	if ((irix_sgid_inherit) &&
-	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+	if (irix_sgid_inherit &&
+	    (inode->i_mode & S_ISGID) && !in_group_p(inode->i_gid))
 		inode->i_mode &= ~S_ISGID;
 
 	ip->i_d.di_size = 0;
@@ -1157,8 +1153,7 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-					xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 					&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1308,8 +1303,7 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-				xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 				&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a3df39033c00..91f9f7a539ae 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = from->di_uid;
-	to->di_gid = from->di_gid;
+	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
+	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
 	to->di_projid_lo = from->di_projid & 0xffff;
 	to->di_projid_hi = from->di_projid >> 16;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fd40a0644b75..6d3abb84451c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1572,9 +1572,9 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
-					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
+		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
+				VFS_I(ip)->i_gid, fa->fsx_projid,
+				XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 838acd7f2e47..757f6f898e85 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -666,9 +666,7 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
-					   xfs_kgid_to_gid(gid),
-					   ip->i_d.di_projid,
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
@@ -737,7 +735,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
@@ -749,7 +746,6 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f1f4c4dde0a8..a0ab1c382325 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
 	 */
 	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = dic->di_uid;
-	buf->bs_gid = dic->di_gid;
+	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
+	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8867589bfc3c..c036c55739d8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -331,16 +331,18 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
-				doalloc, &ip->i_udquot);
+		error = xfs_qm_dqattach_one(ip,
+				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
+				XFS_DQ_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-				doalloc, &ip->i_gdquot);
+		error = xfs_qm_dqattach_one(ip,
+				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
+				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
@@ -1630,8 +1632,8 @@ xfs_qm_dqfree_one(
 int
 xfs_qm_vop_dqalloc(
 	struct xfs_inode	*ip,
-	xfs_dqid_t		uid,
-	xfs_dqid_t		gid,
+	kuid_t			uid,
+	kgid_t			gid,
 	prid_t			prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
@@ -1639,6 +1641,7 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	**O_pdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1652,7 +1655,7 @@ xfs_qm_vop_dqalloc(
 	xfs_ilock(ip, lockflags);
 
 	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
-		gid = ip->i_d.di_gid;
+		gid = inode->i_gid;
 
 	/*
 	 * Attach the dquot(s) to this inode, doing a dquot allocation
@@ -1667,7 +1670,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (!uid_eq(inode->i_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1678,7 +1681,8 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER, true, &uq);
+			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
+					XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1699,9 +1703,10 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
+		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
+			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
+					XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1827,7 +1832,8 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
+	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
+			be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1840,7 +1846,8 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
+			be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1937,14 +1944,17 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
+			be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
+			be32_to_cpu(gdqp->q_core.d_id));
+
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index efe42ae7a2f3..aa8fc1f55fbd 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -86,7 +86,7 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
 
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
 		struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
@@ -109,7 +109,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
 #else
 static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
+xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 		prid_t prid, uint flags, struct xfs_dquot **udqp,
 		struct xfs_dquot **gdqp, struct xfs_dquot **pdqp)
 {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ed66fd2de327..97336fb9119a 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -191,9 +191,7 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp,
-			xfs_kuid_to_uid(current_fsuid()),
-			xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.39.1

