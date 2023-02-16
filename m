Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA8A698CC6
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjBPGYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBPGYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:24:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9A83431E;
        Wed, 15 Feb 2023 22:24:13 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IcHm023093;
        Thu, 16 Feb 2023 05:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=QukE08kxxAnXZ7JDETauc0JPXkIJNi7XnHJzcJUeQ4E=;
 b=DT2CRPi3V7uzy8AIfsWcZ123vHE5sDrxVZGSBfWhInoA/rl3HnfUs/n2AX3pf5Bkrys2
 +1oWZmsQSOXumDhhLz9mWaJYsjuZVa1IV312A4XwUbYgNIkCg/zP2ar9lEfF8FL03OEX
 OV35pR8/W3Yd1fhU3fSZT4vP5qjZzu+DGtmwcBqzKH7GMYzjVvbqE9PdrLFfGz6kXHm5
 VRgnA4neeTx4klHLWb76HugrUmfnzlhDrS4JrvVzWBUaIAU2a0zgNFkJEvaRJDZJ/l0H
 p8zL99TtJz+tTE3TUEfY8gEgnHRfOnLwXulPhOPsaK9+liAk+sHYZTdESZ8yMsTKqml3 Eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np32cj6x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G4Ij6l003568;
        Thu, 16 Feb 2023 05:20:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85e6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2W0gvRd9eUyRbBy8GaX25VG1lgQvS8c504AAj6Njutsh8WMDuH6ZEa1YGfMJGa+Kkrq8vz8ONKoWlw81xvThtuugkhYb1a4Vyj6ydksuwax0ON2j/g4KxNj5AgguxdNEd6v8xPW41nAVQC3aKUc1XX8rH0bLFSmBCuY0hiZWQk7w0ii2e+2FqzLTtQp6L202NU3VexOT7OWi01YZZ1hG4w/lX3qNabGMkuD5X+lygQ7TJ3Rh3U5x2/1Hk1RUHT9XpyTB6RJyMw8r+J+Jqcbghz+XqIn8XMT2XKhZFg4VsI2BJz9ULYz7i60IajgAnlNBQp701KhPRaXnvmwr6Sx/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QukE08kxxAnXZ7JDETauc0JPXkIJNi7XnHJzcJUeQ4E=;
 b=M3pi0aOszqzlQvyyYE8XFAyW5MU5q4qgRre3uYBq5r4kgMf6yi/38AGa2Yibmo7QV1exgymoTulK4FG7pNobkYtUkkoonvqsuCGTc7SWvmagF815VwsutCiDb5QCPKn14+h8oMGcmc3CzIQexhR24f1Jyfh4d3Ahog3ld4t0Iv0wZjudcf7Tyu+P8Z5Br9d5Vw7LALX/l1fb4Bja7DPHqjTWKkhr517ZoJ2OYQhx9BOa2o1du4sl6dOUQbGAcPKBwn5kpQMrAgv9V2yYHYCeOgP09hSUE8lEd6JtdfcaXqzZe4mGqXTfIpaNL60FFJM6BkDxBz1cANRYdC4EV98VOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QukE08kxxAnXZ7JDETauc0JPXkIJNi7XnHJzcJUeQ4E=;
 b=n+jP9K3HGDXlBxAIFadx+jE5V6bM1mLDORAXec0czLkHfPQLvFSkns6tlGh9xkigSVP0Sk3Wm+VeRa9hA0iJ8m38kPyPjE6sxGPx7XetgUxbucUbx8/gZeb0O4JKQ17nkXVCxJF61qdlLBP/cPjJV4o9wKQJg1CFT46mrG/SCIM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:20:41 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:20:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 02/25] xfs: remove the xfs_efd_log_item_t typedef
Date:   Thu, 16 Feb 2023 10:49:56 +0530
Message-Id: <20230216052019.368896-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0016.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:381::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a357b05-b0a1-492e-cec9-08db0fdd8ba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CW3DtNOkxlduk7S3iI3TQENUWdhly5X0FbicG3tNS/VFu+L9hqhQ2uaTU1tZvUOv6sbsfX7VFBshbahvwt7XIw6N1amFvRbKYAHqXqPZ/x5sH/D0/8ADxxSx9GTZgRTpAp17VYC4ZqmylgDVuzSorzLAMaCV7HwjmOpegiLR1nMm/AYKKYfPuGY8Lh64v9ueO/KxkM9jk7bOoIIKuOeAni61paqCHcKe6eLRsnkfZ8AcLr9DeiZls1ITc5zrYzd6pHpXZiKQXw0OcD59Lkd900W7CzUjSfcZDDHhhd+Ku8lDg1DRhA0OIAJ1cRfQ4MUxrhoh45JbLT5kLYLXNgqtvr/uNP1c4xHwmBYcxFrgLXpiV6LMi/NiX4m8M4JJkNNMwF/3eRaIvFieh1e6O/q2DpaF/KJFT4KeRRq6k0d0NNY7+Y8t/aYD0RFkcRXrQbIIe7tOab+w0zkoFseX6abdbpOWZnDjN0wEvQ1Q49XILQZqoeYGGyylx4F+o3ye//xRjvKptu+kWwtajfXpP7XpnEf0YEe7xcH9iQ2wyVAuH+bY77c8qU7yxKajzCw4AOtQ/kP5581aT+eHbDYMStVcmALBTLTsWmbcmX/qBg4FTOoM++7zd/pXHhytDjIeTqYOBHIEa3tsWNyQu+ajAeJtwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HgVms1UOamqWLhBaHliGGLeBPSbhRnJtBnBmHmAnKxdh8auPA7sAW4SBggRg?=
 =?us-ascii?Q?0j8LUqtR2l7ljCPoGk6apXwzORF493n46YN4RTx8st0WuzhYYWPXJa0cqQor?=
 =?us-ascii?Q?UpHYnPfaRrDF1qeSH5z3lsoq5nSRfN1vYidprk1tEoRy+udu23+jjYlNlW4m?=
 =?us-ascii?Q?3pSdfNRWwdE9UqcHcHTV8YGqilMQsAv7/zhmwpd+8Iwslp1hvAf0zQeQ+RpP?=
 =?us-ascii?Q?a2uwcy4YtnX+qKdcu7Hy9Fq2oIIe2/4BqbI75qgnjBtLXTMgkdW1K9fHEWSO?=
 =?us-ascii?Q?PcTYvP8muvefsqCJq8uQbtgEcMGS8fWG8Zp84xqkkMaFn3bpjVcc2bap2Z8E?=
 =?us-ascii?Q?RJY0f1fdLX3D1mATJNOfHcRoAPrsQGnAiIpTqWml88W7oVax6OcHfosl/0o1?=
 =?us-ascii?Q?YWiWhIZkBgyEAov3dhAQPFLddPA7xyaexYOTCzqV1OH50tVsHIqQY9oq04lS?=
 =?us-ascii?Q?kb1dtJKwZrQMy7a6s+O94Neu4gmn+S15yyVE805WwswWjH5xJ4Ca7WvY4H3l?=
 =?us-ascii?Q?8zNnNujUxDZfmJGM8q7as+WmuxwzV28Jae3kwiOfKqO+1y6dqx8TRa70/rYS?=
 =?us-ascii?Q?US9Pv0Zk4GuGveWiCcr9mD+/qckyf0lTXx3TDrxGj2vFK4SdmQ6Val33I488?=
 =?us-ascii?Q?xN3vR26iPTUGaF0fLUYDt2IF7KewA+B4a60aY7hJNoO6EpbLavQiF8mpuZ6C?=
 =?us-ascii?Q?5j1nPWPvdCMEPZzxpowdTqlGphaxVNoGoiN/s3QVZbTo6zjCmdg2k+E6bsaA?=
 =?us-ascii?Q?RA+QfYUOFHEu1CnWJxa5yRAb1y5x6KIJaXK/plkCZisov5VNHjG7b6Gs4aah?=
 =?us-ascii?Q?FdGD1Y8t9DyZhpqRdHUZfYCsFApazSktGioOaPWswGZ7ZEo9VnZCQQts4kBw?=
 =?us-ascii?Q?gc6lOPCX044CDhmCr4nKpB/rTGWAyWkNeFekOWjY0TrxcMrnEfsQH1hdiTQF?=
 =?us-ascii?Q?azgJKLYpE6mrXPYNnXwI59IStRQ49726+Ik5G9jUYBd7JkjR4Lel+u9ZpN1X?=
 =?us-ascii?Q?xlz0NeUv4mfq48pzCSJh5mEjx4OAq0sfVNZv65sbrRBDjPYMrFgPEAJSrXIt?=
 =?us-ascii?Q?4hc2X23/3R5vivEK1CNz3IDehVxIiv+DSQ/ZV46Up621S0gTeRoec9iJyPvY?=
 =?us-ascii?Q?wHlIby/4VlvN5H1FVIMEsDCXgts86Zg0duORwvV3S8f9OFisDzJRTyNjlRkR?=
 =?us-ascii?Q?p42V0Xuw55eLQi2MPKkOEMxqFhMjCiHNQA68PlLLzBAAQfeUMXBmqaHryGti?=
 =?us-ascii?Q?ObVymN0Dpbej1PEGte0RT8wWYhX2VzfYsUTEXg7tvUovpXMTG5QPqvVdQ3Z+?=
 =?us-ascii?Q?5yfxIPwVb0vUE3VTHzQ6drh4/GaYlvIsCIj6PyO1TUjhCA11ZowaLPpkgN2D?=
 =?us-ascii?Q?YUuW5zPewADAiaezzjftT4mEX5UGrAWF7yo7d4TxeDntock3jY64OA6B0Yma?=
 =?us-ascii?Q?qjmtwV0hyjmtwKK9O05wNtWp1utr8p/AzZLjxKv5nRr0I1wJaAb4D7bvAc4s?=
 =?us-ascii?Q?9jpniqcmbq6SsonTo/1QV3F1RJEywznsfq32QQ/RV9kScoNLBE7m1kRgV+NC?=
 =?us-ascii?Q?UL/iCGwVKKjd1mUsUoiRrt8YjavktYYTfuH6X0u8qPgfVkLID4djLZ/FpKWO?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v+uby/sqfmFsGZi6yi1llwn4BfpYle24WcNgviW0aRS7JmDiCx/dBn8OsmxYL393ugR+rU08qRDQi7yVKgxaqpdTeIRFKfa6tIQk6HZGpvovP9V+osSGSaHljmEJdfdWkaMX2qSsessyzGngn1cchLbA47W77Wg2qKPALNqNSHn9moZsL0uB1u16KEsrh5TsuO8m2cTE03amemoF0NcrUSVUzKPxheQ87hTYvChMRfHRPuDC89GOHtrOLhp7XyQmRjwzd2dvM7U2SkFaLPYtabh0MB/D4pfBgKIo8/4u/K8GrdebnJ1/JcNZstEoZy9DH4A6z/ggKF+Ciu07WHp6dSNZrfwIqkB9WU80kH9ueBYDOb4w+XllaMpn/xU729o28kc5k/6bfUv2B5aNzMyZaHVJf8SPnM35HaarswQMUgW3K4q7Bo9iDGgCyuvQQFxMCn6/CJZIui26/s439gC2X1R0kn8tVlgsztArl04IaPopBAqTbYRWDmJtxgcRFv31uIbelm2G4RXC66Gg0K0dt5VvxResrWwM5YxZ+1b6nNqb65pTbSPKT9UwnWchrko3RIMrChkkr65huRXdAqXz2q85N2LlWVFX0DhrMdQ5yEuOj+ZceqpbwtCBMUOTlHMze0wWW72driKccNtx237IJtJ94tS4ZRmfJYPTxRd3Y7CYdwijrcc2IJUhA9Cf698qKqEAZ3lX3pCIukJWYDVRrFSfjcLFErh66Whj56N9SXYdFuViOs7dFjcNnAoDkP0mVyGSIZ5LHbH9Vt5U5srriHszXS5BzkHuCd/pgq24Y4FvDm6OYvY/mlPxSsXj0CG0z3gUocNat5GB19QPXbbSPSbsFmx4GnCgXTismgKL0kCxjhmRdU94Ggxu0c7mKBk2
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a357b05-b0a1-492e-cec9-08db0fdd8ba7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:20:41.0478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UqORAOjtAGxFD8hdyg5/Ys/NJtNZTztTk6EHUnl9T7Dkxa8jsE9xSlL1YTTT0PEDahKIU2fjYzBWRaqrBkeVTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: 33T5S6gXIUInrHgQw16XV2JNr-3GujsT
X-Proofpoint-ORIG-GUID: 33T5S6gXIUInrHgQw16XV2JNr-3GujsT
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

commit c84e819090f39e96e4d432c9047a50d2424f99e0 upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.h | 4 ++--
 fs/xfs/xfs_super.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index b9b567f35575..a2a736a77fa9 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -63,12 +63,12 @@ struct xfs_efi_log_item {
  * the fact that some extents earlier mentioned in an efi item
  * have been freed.
  */
-typedef struct xfs_efd_log_item {
+struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
 	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
-} xfs_efd_log_item_t;
+};
 
 /*
  * Max number of extents in fast allocation path.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b86612699a15..9b2d7e4e263e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1914,7 +1914,7 @@ xfs_init_zones(void)
 	if (!xfs_buf_item_zone)
 		goto out_destroy_trans_zone;
 
-	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
+	xfs_efd_zone = kmem_zone_init((sizeof(struct xfs_efd_log_item) +
 			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
 				 sizeof(xfs_extent_t))), "xfs_efd_item");
 	if (!xfs_efd_zone)
-- 
2.35.1

