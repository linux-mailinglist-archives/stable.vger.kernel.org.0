Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E61698CAD
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjBPGMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBPGMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:12:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7EA1420E;
        Wed, 15 Feb 2023 22:12:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J3AT022205;
        Thu, 16 Feb 2023 05:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nfgGUkaF1vx4+Vyf7+7SZaErD12lr1IZ+Pni3VuHSZs=;
 b=UD+A9X1RA7JVrtTpKRI4z8PfiybgSgIl4dMC0AsmPYgYo7zCkzHh2kRCxmuzPF0lIsv8
 b/0YeCYYgXYX/wl/6Xc539wcV37IjXZWU1JhwRvMRMR4lQxeZsS4Kea/zwU8EQOaysKS
 iezZVo7uQStR8GkhIW5dmhUWV1FdyqenX2FRpBom52SEkeCdTkWTCdZKHD/wBMlr6lkY
 HsAaQy3YRoubE6qt6xca7FohZS08K7VkuH4KAx96Phx62fRY6iAIZwCO4xG+urZo16y6
 3iimeMJE9gswLBq/+M4u1YNDSw0LGswknJoI9syTv7FS9VK8gIMbzeC2szPWU/8tMaNi tQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12amf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G55O6h032433;
        Thu, 16 Feb 2023 05:21:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84j3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edB4SInDZDSHj306xzAEh0BS1IZ143jjalnivwH3Yyk3ipu2gKY8TNE6/iKaiTWDajpehE/q+qTLr6t68sizBwZqLWiAxmCDo0akbZTo4XUCdJOIcchznEoVo9yosUpDpPY4BhHbcLzuKGkdiMCThEElbFQKlzm+70MpFWGJ/k+m9W6jNzpx95ONqEqhdtUCEnbl655b95tbe6Mu+09M8kNChFoPu3WYqqThYDY4U0F1UYRa+iJQ0VHzaoQnaWIte7mbZKOf6a0GpseiK6ZTgFCFCczIP2S2yPZJ7meLAysTOUqTy8zdhXAa/cNwrFkQ5rvYSKWM4PW10aZNF4hGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfgGUkaF1vx4+Vyf7+7SZaErD12lr1IZ+Pni3VuHSZs=;
 b=MqVuFHBmqzXVgdQHXJR/uOA8CJhwPHjsCh/XZzemWZgPxqdfl2H8UaUAg5g7ZfvBh2DH21sf049nyDezuW3uzciAR6XGBOG5bp9d+x3NWngK22HnSwcqfLtGIWHwW16qMXQbbdSwZiY0gKGaBBO00ydBRZsToBLBJ3cVf2wlpkxX6lMWvhLvdg2SszpVc7PzbM/QwzfyRugPAmjkf2F7mBmEo/bTbacLsk+YazA7cok2XT0g87Oz8Llscdm3JsCakqc+X3+pSdsP3HhAgtiNAcOceNGe4lgHIW+mhDxsdYoSGrkKE41MdPl1ChEdisEIZdYKpQANRA+tGNybtq9D9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfgGUkaF1vx4+Vyf7+7SZaErD12lr1IZ+Pni3VuHSZs=;
 b=JwpdhU79jxWMjypaCMUiJB5WLKhvGJca8jH9z9HRip5QIlMDjPC16DpFUGhi/0fi3qW7ziiFhKT4IJjVyiB/l/uh+OLrgFLhdG13E/OOH7cI17txa/M537nfWGV6YM7DNxVmgVGikroFT55jQ6YMu8u+XZRI53CFLUKfnrTATqA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 06/25] xfs: merge the ->diff_items defer op into ->create_intent
Date:   Thu, 16 Feb 2023 10:50:00 +0530
Message-Id: <20230216052019.368896-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0006.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 3be53e83-795a-47bf-3d73-08db0fdd9c97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLVAqjtcQInwiASSHJrGKKr+2h5iTpkcx4awW1MEIi1o6qaskd3eFo2/9h+Qkyh3650ceNhp9gHDDoQco5oKpNQLwGwsvXPARTZYY7pPd2vJEkJjwIk6x9DRzplQSW/I6TZ+mjAytOlQPJ7Jr/Vocko/4U0+8cn7UUHtioO6PSUAwBkzRwKDBsBsxjS80rYkOV3xyTlcBo/Kj2Ivw29JM0nQju6On9lOyQ3PH4V17z9Ceq7FSQ5PXQIYpt9uerOMCbDezAu1I6Fb/sTzst6+avVCwjLPyyyD5SALV3Fp2a0+RnMbkIpvwIP8PHmW4H71o6wgzmGQEYdrmnHVGeJ7dMqY3cFNainrsBJaugOTakF0MNujDOTAEw3HzpWF70yG1r9MhuqZihEVbpuntKtsCmlScvIDieH1O+ivFqfCUwfu+BBBGxzv6vGEKrILtsAtKOwpSnJcridmtWuBLZqFA69sslofiDRB9uaiElQcmncVMtyYAnvQxqfKcby9eRLAeTOM4PRd2163lnpeNTFEqLBx6SZ5CB74N7IFCZneh0W6BL/d4DCoOpFhErzCO/8vgJQ4fR2r+IMH5pybWGI0LavfPpg6OVdPJreBcnJ2+lGG+kUdjwWNyIETDLMRxFpc6BeAoBsEYgmm61EYRYsBVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MUl9puJ2IuJNaVPlD/E+pMYSiTXZJCp4OuAuF3fJPN43nT+DwNVVdyEjSYdB?=
 =?us-ascii?Q?4U8pMuOVSqgNvcveDkgDOBW1qasd3WX8WQnsAzBjyh9QCaQ7yi2RYtddbMoD?=
 =?us-ascii?Q?CK2fAoM2AzZEnkzEUG8Hv3MGIynA/H+/ew87Hcy6odq6PL6X/mZZdPNgOqod?=
 =?us-ascii?Q?F8lV7696mFUMuZ2y73tqQbjErJcjnhhEKFdsPizA0q1MYIYNnagL4Idhl9bA?=
 =?us-ascii?Q?OEMzs0a+pZz1jC7PS6g12lohxJ6aTYY4n6/gk7ouvXL2cFpuISGtjoQikyk+?=
 =?us-ascii?Q?JwvmpfRNlDg0oT71mDnNNoFtcUYv6rRVjVhtjB2cOv/7yS0pJgVQOm0mtJFQ?=
 =?us-ascii?Q?DVG4nXjpPQYdGs90Wn4IuMMDbQEjbNzhjB1+xYaEmLABvJwodV9gYLVwK5pE?=
 =?us-ascii?Q?KKnFPMPpIqvpICZsXWy9l6VURkV28OX7HM4PyBs7BonnW4U5KC5NusV9kiwC?=
 =?us-ascii?Q?kfuZjRhUnvE84dpsqKFLLJR66bOqIQJUg5c7Tz9+8ccCGKsSj0GWiNhBb3vK?=
 =?us-ascii?Q?gnOj9eVmHIj6/XrykmnFNkMG5huaVREeUJHWpORTmNz4qsjuZJr0Njtieb7n?=
 =?us-ascii?Q?DPY2QT4i8D5+e+Ln96mTZ4QlMPLBXboeTw3EUDBjWK4QHMD1EfLPzSUxoiUr?=
 =?us-ascii?Q?HTFsuWMMDF4B14ALkpV0jL0Q+4bGs/G1qb6KbdxUgZRbUkJcA5D68wkMP8Kb?=
 =?us-ascii?Q?hxBomc0LjDh7gV7sVBbUMoicv27HJ9Rbp9bw1JtYZ9kLQf9ISGWvySCaXki7?=
 =?us-ascii?Q?mxqJAz9S+QgrXyouN7at46RFJdqVvTcgmV8/AlEghY0Y988K0s8pQdFreaf6?=
 =?us-ascii?Q?tp7UhQmE7+jAjUjv+peTtQRaNPm13MiQBQv6Xz5st1vEmFXldvakkF3t51Yq?=
 =?us-ascii?Q?yQWQtlHApLKj5y1CUH7CmZPOOFFKoQlRJpn4jz/P1vJ6mfNGB64IKJmIrdac?=
 =?us-ascii?Q?GGkiYnty7eKHmTAnAGu64TCC+NwNuaS1MgR+zjDu7e8EcU1JweVwfLT9VP/S?=
 =?us-ascii?Q?FcnDzuOscYPa2h3B2V1WktYFne5P9Qr8U+8ViEHA2hifErbCv6+gN0s3GuZt?=
 =?us-ascii?Q?Xklb45fZ7YkHyDQBc/xBuI28mn01eGCqAZaio24UUivz8GFodL+Jyefns6D7?=
 =?us-ascii?Q?2uF/YCHQzQhAgwq+aF5bbzAG+b3zvBYYmCKZpEm7vK2Fc5SRu6aPlPt+p3Ub?=
 =?us-ascii?Q?gH6nj8gmZ1VPkxhHfuJJ4TTj5QO9FplcrAj/MV6pYaW3mh/jLGY4u6m3SQrL?=
 =?us-ascii?Q?0mYjL+JnW1cEtkK3JIOt/hunSgAUtUJLS0mME9HZbdjznsMVl8S0qojZkvx2?=
 =?us-ascii?Q?UUmBRZTiFqfH1PR/7melPcBcUW5bLTqsuY8+ofRo8R+v/FjJs5JhkvWuBwXe?=
 =?us-ascii?Q?jJDpezgiRWYQ8hMjkVnDI6U57C3Uk7ENVHXuOCozLJBmkDfy6Cv4pNAgS0fV?=
 =?us-ascii?Q?Ir6nzr5ewNjgNlLfsJUH9fk9p+MEKmL1lblGqeKvdboeVuLfL/dBuWcJ2m+V?=
 =?us-ascii?Q?RmQcaRaNMjlIaRwZon692ZNmwZwebB0DG4x6qjrzWXMVd2PpddOUSCCOqla3?=
 =?us-ascii?Q?lCbb9T9xnCqypmaHHd1I1mPniJgDUHpWPwtE5hWeH3iNRb4LffYwJSwtRnjr?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oO4byU9L5QXxk4uJBr/+0Zs8S1qEy32cFfhRc4oTu4g2I6F+5vDR65jQtVShLbSHXBFSSTszPEoNeI4bocynn+4riciJjKEjrXUB9GkGalEC5Ei9SGb2NTG3n3IawpJTWMF+y/vYu50rzYOa1Ssal3yGmw6NxLDuZYaoR6H+xmtwJbm0y8LGuo/IVuzAplFm/q7Bse/HJ+JlHGcoFfNBQZLSoC0WOPFEGjsDf/VEks2A10kVJcCukSLFx5IbzMFF+nXrBZ0Pm+vPmtV2Ye+7P2ZRgSgAMGTZBco5xVvtUN+YjyJMsXlUGn8W22Brr1skMWeKh4kLZ1CmrJx3mPBji5mWdeO11CNeTqp33hYBm9NFgHhIDW7tTQd64cjjOeWjVMVmDNLCkxtabPGB2kTAvDlouIEfnLOBSxzRm6U5ao4h75MIW6iECsEr+uvuyxQIAaeYDcBOlqUuBQiedqemVfDMGCQVGHcvaeVdkT3wcDCuwYa47Scq6XzdU4mQFt2P35JV9v4NarxvnYCCjCIqDrEz9aivMBEm4pMGHPpOYY3sWcM22loImqu6aJIi2vBeU4BiVPHDu3L8B3J/1D+k6wFBj93D3xoDUmI+sG3QP1Ep/59Z2LbV/QShTZn4MUNts2+1pT11w916WUAS7X913RpIVvj4etwbEQzdB6mR3I+m3AncuKNt+fQdn+m+RtzNf8SuMuUrcVOj5WzVHx2mO6mFckxHi/n4WkNZYxnspdvwYUfa+jrD2Prf/khuGJ+PdDbNYCNU1dAt79vvLmZRjunZr0sOHBuUtPDHuZm70d9yVKQQIP8xrnAM5LRqCiPij1JQbC3cOrzF2Yy/2kjmduuEgi5S3oiEwgSTttPsKAHmPhjf+e+e1iqW/eibMRTF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be53e83-795a-47bf-3d73-08db0fdd9c97
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:09.4591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWl9FtrgFBUc2zxjdfkVYyUTqGOatoK6yFS8LUY4zuNtxO3ifulKgk3+qbWCevMWNqGPVUEEyh+kYHYZg7pkWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: r3mMR-t79iid0-9cup5bGU1RCjC7HD9J
X-Proofpoint-ORIG-GUID: r3mMR-t79iid0-9cup5bGU1RCjC7HD9J
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

commit d367a868e46b025a8ced8e00ef2b3a3c2f3bf732 upstream.

This avoids a per-item indirect call, and also simplifies the interface
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  | 5 +----
 fs/xfs/libxfs/xfs_defer.h  | 3 +--
 fs/xfs/xfs_bmap_item.c     | 9 ++++++---
 fs/xfs/xfs_extfree_item.c  | 7 ++++---
 fs/xfs/xfs_refcount_item.c | 6 ++++--
 fs/xfs/xfs_rmap_item.c     | 6 ++++--
 6 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 081380daa4b3..f5a3c5262933 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,11 +186,8 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	if (sort)
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-
 	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count);
+			dfp->dfp_count, sort);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d6a4577c25b0..660f5c3821d6 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -49,9 +49,8 @@ struct xfs_defer_op_type {
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	int (*diff_items)(void *, struct list_head *, struct list_head *);
 	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count);
+			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b6f9aa73f000..f1d1fee01198 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -334,14 +334,18 @@ STATIC void *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
-	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_bui_log_item		*buip = xfs_bui_init(mp);
 	struct xfs_bmap_intent		*bmap;
 
 	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
 
 	xfs_trans_add_item(tp, &buip->bui_item);
+	if (sort)
+		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
 	return buip;
@@ -408,7 +412,6 @@ xfs_bmap_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
 	.create_done	= xfs_bmap_update_create_done,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 45bc0a88d942..6667344eda9d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -441,7 +441,8 @@ STATIC void *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
@@ -450,6 +451,8 @@ xfs_extent_free_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &efip->efi_item);
+	if (sort)
+		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
 	return efip;
@@ -506,7 +509,6 @@ xfs_extent_free_cancel_item(
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
@@ -571,7 +573,6 @@ xfs_agfl_free_finish_item(
 /* sub-type with special handling for AGFL deferred frees */
 const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 254cbb808035..2941b9379843 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -333,7 +333,8 @@ STATIC void *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
@@ -342,6 +343,8 @@ xfs_refcount_update_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &cuip->cui_item);
+	if (sort)
+		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
 	return cuip;
@@ -422,7 +425,6 @@ xfs_refcount_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
 	.create_done	= xfs_refcount_update_create_done,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index adcfbe171d11..2867bb6d17be 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -385,7 +385,8 @@ STATIC void *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
@@ -394,6 +395,8 @@ xfs_rmap_update_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &ruip->rui_item);
+	if (sort)
+		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
 	return ruip;
@@ -466,7 +469,6 @@ xfs_rmap_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
 	.create_done	= xfs_rmap_update_create_done,
-- 
2.35.1

