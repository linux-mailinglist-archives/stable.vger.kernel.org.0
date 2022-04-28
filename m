Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA8B5135D7
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 15:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347716AbiD1OAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiD1OAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 10:00:35 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715BC2ED5B
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 06:57:20 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SCOPGt008894;
        Thu, 28 Apr 2022 06:57:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=mSHQPLE1tL0y2QFgOK2qSZ5zYRzWJxnAgm9IlF8QJIA=;
 b=kM5IKkPfkB81h2ra/ruIZQ217stxGvWG3bSRSn/izeG5VGVpRb0MiNKSzV+jrz00r7kV
 NSrWboDdqVeiTSLE3Ci8WjJ5sujkQfZhvzIHuygXyk6JhEEe+2QTKTj8i3q4uTSIuH5f
 XjnhI2oz9wUA/EP89exHlTBCuBU3xB2LOkOi9dKTp3HIcnYYxN3GzZB+8zsNWkwBXNKI
 FP8L5hgJus4CkjUklkZx1LKfYlqY2CZ0I3YvXyWt0phPrCl4IsJKGqhKCr/BaacxEG4t
 VfemIF6fl8Eac613lB9rU2ew8nWJIuVIVnHEWOB4XkY905bjcgijegS4pooOa5KPDxtW MQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fpshjsd42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 06:57:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UH0qbES2QCCsYHFTZaTqUxyRhq62yy+NEN7uvqN+i+BW+7Z+z8BxEbhR9pZ+OpgbCK4OYgiI8iveqPMJSAj71ecvVRUB0gX/4cyrAypd+l31DBL5bgGVbcyjL/ZUcxMAthFyjv/Ig+a2vdTJwTQQS+kPT8xbNubmmhny5cMhSbBNIBZAmv3p3vTnaqvFHnYQaXkB4HrM+iuF9y/VAi4wBVNM/AqRwDhZENi8NGGdidmbwodf6knfsvdMi0sxpZim2W7SV4zFF0WcfoTZ8rVP82LQGCnDyRZI6RXQENiFBhd1L6yV2OlfJeLyjyaGP44SiodjkrNBaQ0tWDMsUF3i/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSHQPLE1tL0y2QFgOK2qSZ5zYRzWJxnAgm9IlF8QJIA=;
 b=dUWo0PGrAMV6OOQ3Nm4IOATTooehCrLg8YgaYjJmj6TontpKU6safGz30ttwfrx/tgd/XRMZkzajW0A8V/zd9kVbirC1ZLwb0urD9hEI4T3XlgpQBfcswCl3mEa3J8wlLFtc0IEUWnzVG9FxQmhA7cLsGL5br7/RjwHfxi4w4sRC1SrjJ78l4gOqRQJf0ELnp7TFK2xPFIa0GU9bqK5NZdzLz4PFWkz5iLJ1wwZJtA8K3McFGa4ta8jrlxvdKiUYuc1FSpvc/uIakebaTcko1YLo2Shs/5D26U58APBtlj9hvTrF1B6QndPHCF6hbwysEJNP3la/j2+hDYZnBtgDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR11MB1586.namprd11.prod.outlook.com (2603:10b6:405:f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 13:57:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 13:57:07 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Jakub Kicinski <kuba@kernel.org>,
        Xu Jia <xujia39@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 2/2] hamradio: remove needs_free_netdev to avoid UAF
Date:   Thu, 28 Apr 2022 16:56:48 +0300
Message-Id: <20220428135648.958508-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428135648.958508-1-ovidiu.panait@windriver.com>
References: <20220428135648.958508-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0051.eurprd04.prod.outlook.com
 (2603:10a6:802:2::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27be9011-98f0-43bc-acb1-08da291efb7c
X-MS-TrafficTypeDiagnostic: BN6PR11MB1586:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1586C3982DA1C2231393071FFEFD9@BN6PR11MB1586.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jsIxuX93ag6SgWfOW4wK4Z/eSdfWPFrlLVmjzdbQXr+AAl5peZrRtA9xx2x86zDNkiNDFUNgAyJ7e3n9qSJKjnPqeQ6y6aOK28ss3aa/dmesgs7vNBfwkd7bgNT3kFDN1f57gFC4dIlJmFin3JcZYrLe5AGdQP0Kvu8KF8xuoPljJKcWFw2IId6QlVkBPx1dmHrk2qB5YCKXCfQvQf9JgQu5cYgDVGT6HUvv6D74eggHNdRWU6A7MVIBoaos2I6ziP3AAgkUXv4WPJMonnVmNQ48wglysFvPi9fTEq/pxNMKmPZ30JxnxNQHLTeykn3w5Fc2SbvdfN4NTx6LsDLc9NTj0AEhVXCspMWpinaAfSc9qMBBsaIrvanojUTITZgJr8uzRsNmx2M/6AzU8bIjilPwZhQSJCoC45dimav5u1kqUsdyDmoJDGcVGRarpkz+m6EHx9OezXfUplaGPiiyRR4qykkXoSn4Dtqmx2jo25l2Ws+vj8uYhpknCQzsBU+0LNVqHtgyOZTNRbLm/7u4h0VFyYhOsDZqw2gKckz5BPPYRhrYqXixSast8vOh9QtzoIvjHYtcLLAcOUcrZENN+2EmXBh5eWUiwiMU7kUF/4tdBfgDV1u51eX12fcBB/dB9qDaOuzgHy5fx2wXou/yYE96YpvVUVMmPAsYsuSpxZNrJb9MgGOQ0gx3/SiGeYUY8XuzCNSfis3JWBonBbYOAUjxD+FVGKm6/lks0bNCqwDtiNffv79sjikeFOHzyU1A91M0DWlsHJtxSY/YAs6u3V4pDJUw3vN9itfR030A0Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(44832011)(36756003)(5660300002)(66946007)(66476007)(316002)(186003)(66556008)(83380400001)(8676002)(4326008)(6916009)(8936002)(54906003)(52116002)(86362001)(2616005)(107886003)(966005)(6486002)(508600001)(38100700002)(38350700002)(6666004)(26005)(1076003)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7VhoHNxXbvd+6oAUKHRAUyOJY7TvbiGDBv3o7+r1Hp2TtyNd4Dw+LURoPN9c?=
 =?us-ascii?Q?6SFkJKEcuqndfSSdIdJcXndffRsrlv4H0GpD9wVzxIwhTIhymgxGGBvMNgkJ?=
 =?us-ascii?Q?e1Px6J/QlAljx2CRcYkhWdeZzrg7NOREkHt3k2HjkP4MwSpXTRNt4vJbsVHx?=
 =?us-ascii?Q?bEtHnheYEf6RMExAigOEHsKwYXmkzY0e4bMSbDbcGqPYNrpt25iBaM4ge1wI?=
 =?us-ascii?Q?Ndr1yN8QTnTsdfUprClZIY3qylzydHT5bNJoULt0mydnOGnrXuRsQ2OoKTaN?=
 =?us-ascii?Q?H4LZTTLnTddMRRhrPocsG2GSwB6DPYtiZJvtr8Uen84iWcE45XtybVf0bXCK?=
 =?us-ascii?Q?Fz7ArX8B3/fmOcaZvybRP6JUJI5UBf2g/IKLbY3nk/ot5DY8p2hCAwq5naYR?=
 =?us-ascii?Q?kpbPelQX7jepGNXT2cSjBOpZqNA2jGgxRDb/v1gMfGr27mw1bUnUBNW8hBFJ?=
 =?us-ascii?Q?2eM8trU4ieTqoNx3wX3AYPNAys3k1cU+ZL4+ms9gvxjIhn6gXQiEYPz77u20?=
 =?us-ascii?Q?Qvdcy8ih25EHhA8i8iWZ6B/QIIzWYXriYmHSFT4om0CZJZUFs/DoUtqpfmDT?=
 =?us-ascii?Q?nGmPORRZPX6dWarrJ4zQwQN7zetyBR3JEUz5izVuiMypvqg09MWxAARtI6Ga?=
 =?us-ascii?Q?MFv7jaKeiFs29JHyUJAZttumVIaBIo88nQW2stBLG1LDVSguiZTBQf4DrViS?=
 =?us-ascii?Q?PSSlvq0nw8b8tclFJVtXZrLUEDsjxzaTlLRuxuFmd8IJyNojI6s9nvHhY3j5?=
 =?us-ascii?Q?3ck3gHMh4ZfH5O5+z6ZgS+n6k3gbiWG0c9b3p0Po3b8exxCtmboSyg2Al/JF?=
 =?us-ascii?Q?U+Xn8uj/je2Tj0YookgsLqoNjVFy45WmGbpvBO70+yjmfQ8USDqrrcP8IFJm?=
 =?us-ascii?Q?3idtPa7lk2YmnzDWQUPXH2NHYBYjqbvtds6ljC58cjkJzEXvQ51f3RbEzRo7?=
 =?us-ascii?Q?i7zAS5Bjdsa5GQGKFwhKwBnQK4CVu9LCvdKuExqzVgzPTouSoM+MUK60iphI?=
 =?us-ascii?Q?1lz/1Jl6BEb96Jl3bTEvoNU9IV3BgiFgnOc4XOL60ZVg4YqO2mfmXtl29xh5?=
 =?us-ascii?Q?gBPuUgSgboLmUwJAzCSVtLaDXY4aUMrCtCKVYmn5IavCME0eFR63NbA++pCg?=
 =?us-ascii?Q?eNO+S2j9lI3eo6m5kDoh8nutgAa+093G1OzlI2dVoLkFEDs7zD8BXlL3zzen?=
 =?us-ascii?Q?IHl/FRMhzaNUCVtl4F9OKMX3grs4Lkq3xh1+Im3vD7Gx7hgcTQbaRkjjxQyD?=
 =?us-ascii?Q?ygYthJcZTlPsubrtNgCJgwyhqYQysaMd0SqyR9PySGK3kLeAPCdbPWoIijpy?=
 =?us-ascii?Q?KS4v/P5+m5pxwvKZ0WfLZF6FQjX61lJmsng6U4QMR5tC0Pm+t3WAFKOlU/gh?=
 =?us-ascii?Q?MwZpH6xWwbRq4bebi+DYTYVVTpIrQ7E07rwEiHC6PpM08WM7Z6jpoOVk2Jhv?=
 =?us-ascii?Q?hY6ookwdiERisu1GCmoQ2fMz0G1n7tdE2sXF9+2ClDUxyhtA3Y4YAN6Gqxxz?=
 =?us-ascii?Q?cVGUhSn4lXETAXI6BSRH5pjtOjyFKAuFTQu8sAgaJ9iziOfWb9YG5hixF6yz?=
 =?us-ascii?Q?9D0sDfim3NNfZsuVOKfQiH7w8b7AUty6fS/CNhfyU+nvpIQz+8N/qMndVaI3?=
 =?us-ascii?Q?JwQEYmhjBg7kk+QsK04lZ7Cx4KdA+MHXJG69ODY7hIchErhSNj9y5/syXM0d?=
 =?us-ascii?Q?CEdaNOgH1OAcCmeuyTXtupZh6NZbYpKckpcEuusoZwYhcQFgY4NwQeeACBgK?=
 =?us-ascii?Q?fCeeH/1eSRiJCrRjNhWiS45AwhDiIy8=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27be9011-98f0-43bc-acb1-08da291efb7c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 13:57:07.2760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IJ3x/pJSlibFpo5pvExGQkbQ4EObWyCztaGbPJXZsfiLuiFL2jFPsrIlFHiGLEDmI+8eCfrhepu79wPk9KAzG6eGF08H8U27YaDwp5o3Ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1586
X-Proofpoint-GUID: TMHncyvZQYdsnSgpbh6tG9Gusjow40wZ
X-Proofpoint-ORIG-GUID: TMHncyvZQYdsnSgpbh6tG9Gusjow40wZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=838 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280086
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 81b1d548d00bcd028303c4f3150fa753b9b8aa71 upstream.

The former patch "defer 6pack kfree after unregister_netdev" reorders
the kfree of two buffer after the unregister_netdev to prevent the race
condition. It also adds free_netdev() function in sixpack_close(), which
is a direct copy from the similar code in mkiss_close().

However, in sixpack driver, the flag needs_free_netdev is set to true in
sp_setup(), hence the unregister_netdev() will free the netdev
automatically. Therefore, as the sp is netdev_priv, use-after-free
occurs.

This patch removes the needs_free_netdev = true and just let the
free_netdev to finish this deallocation task.

Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20211111141402.7551-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/net/hamradio/6pack.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 381febb99bc3..87094189af74 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -311,7 +311,6 @@ static void sp_setup(struct net_device *dev)
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;
-- 
2.36.0

