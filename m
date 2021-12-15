Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5262247540D
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 09:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhLOIEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 03:04:13 -0500
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:3870
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240719AbhLOIEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 03:04:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iElnFogqoV/FQ/lN5RXszTvWvkddbaQ2pbmNncktb2hqo/5Ot+VzDA6uf7zrrq7iRv17rwUdxcRbr6Ke4e/2DUJDoIIFq+T1L2zayTSdrER4WhT8EYmEZImROEzfKkBO754HTP3+mK5pv6NH6YV0S9z4g7TYy6WaEPz3Ce5mKeut9xtx2xTTsIbhjzH3CdEXKicTWE5Bo1El4V8HanYl7uOcx2UxySYR0m8tDzYrGF0R5OsIQ2YSRNLwMaGvTq5+1ASuV/VmcK+fpa/9gXerjdls7B/6etT4kHqMMHTWwhHOgClRTGw8ua/zCo4Y3xBG078sqOso5FW2You4x/LWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86ZzTMGlao7UUs+VZSPkNo0TBddflHFTbpwdw9+OD9w=;
 b=cfiwZf/y80b0oXsRU/9hbeJ2fqKfO51RVWSFhhd28Du+62N8+RiN544dVr+cv5oua7ZdTsKpkyZuAdCHWNsLpO3KkdD4p5tI/3SgV9by91DpwzjoZ6hF/r+/pXRhQWr5w3Yqh2nfXBl/CYVfEJwWGqA9ndAbGBIT9au667obWE8vItrZyB8EEYto6/hKtawhMBmIdCec2PqsiMh3NvUgCmnqvFblBtE4rqmztQqJ3c5jZMZHsQu82nyqdp3LGzqWYK5uM6x0TFKzsoumtO/7DcFSMKR5Nuh9McrSrElZKEJPs+SN2SkGKqZEnIqv24rMIHVQ5JZeCsi8gKKE4Y5h3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86ZzTMGlao7UUs+VZSPkNo0TBddflHFTbpwdw9+OD9w=;
 b=c/n5y17I0S4pfVYU6dXo6NVAK8wAh/gwslKiEXekW9ZGVofax9OKWlIiB/8kue0nJ0LIGnCho3Se62y2PFm5oPZe5Dl3ASQaU1WJ4yova99I2Xhzkx3F3fGQs/czDu3iTD2hDFvrVYU1aCbwgB+dGi5YdYyqdaSmFAs2+eJ48ZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DU2PR04MB8725.eurprd04.prod.outlook.com (2603:10a6:10:2dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 08:04:03 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 08:04:03 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, dongas86@gmail.com,
        linux-arm-kernel@lists.infradead.org, jason.hui.liu@nxp.com,
        leoyang.li@nxp.com, abel.vesa@nxp.com, shawnguo@kernel.org,
        linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        david@redhat.com, vbabka@suse.cz, stable@vger.kernel.org,
        shijie.qin@nxp.com, Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH 2/2] mm: cma: try next pageblock during retry
Date:   Wed, 15 Dec 2021 16:02:42 +0800
Message-Id: <20211215080242.3034856-3-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211215080242.3034856-1-aisheng.dong@nxp.com>
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 118447be-be79-418f-e57b-08d9bfa17543
X-MS-TrafficTypeDiagnostic: DU2PR04MB8725:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB87259E01EF1BD8E04BF8950380769@DU2PR04MB8725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Jet7kkxn7Wdi95nFh3a75oCC8SUy3X5vLA0/I6BsSD/PeWKB3TmfCaA0+3DAlxhkoa5hjYh11mRogWPZukhB7GNviTSv4JHyhsS7QKbmUpxnRnMkLkxTOBPbueMx/nHBUsLTRqaqQJkoBms2ufM7F4OQXJYcEDdgvJUQbkVPFsuLBq97b3VIRRCoIqDeFXxe43f1uasTGSZwElImhN8NHX+TS9KoEPHnwRtA/u723THZDrrbfyiYtmqM8EGOZ81FhpGFA+IRmL+2pRNrzlF/SwzkYlncqWuB1oUYiTX/2587iZ2O2UmV4u4rs0pkzwk7nUDQ5XE6gPW0DRRW7qDwsXKHfM4qan67sSHw10bIEiH158GxZMAOn2YICMc1msZcLkCt1EENApyI2UfXrVIfvvIrExgX7gkSkL17ijo9bYGuV0lLsqy2Qjdld8UafyNxGdwlx/Tq+K9upnJTqkvoF4bFqW417pM0L4e8bBaR9JVFa7ZKY5On4xaL6qXTtSxI8/usb2zW66EtNLjzSJSDnludVIAM+7PA3GuTVMLsdXPcyuQPIXzTGBQM3DEo9rbrhORbjrahDvQg9U2f8azPVu3QvGXVn0xdr+MRqYaIVZlBWAgB4Yg+kktDEQnWSMx4dneIUyuVSQ+/yDxiVYHGcRW9+aTepGfuHbFJWyQuJF/4wsz2jPfpNmD4F6+xwWU17i92zHuNoDN57ocq6I9yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(26005)(8936002)(83380400001)(66476007)(66556008)(6506007)(2616005)(7416002)(186003)(508600001)(2906002)(66946007)(6486002)(1076003)(4326008)(5660300002)(6666004)(316002)(86362001)(8676002)(6916009)(52116002)(38100700002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xvQ5CFy4vvd45vhyd5Cwfd59cVQAURjZntAoy3cQxncHI2lZAo+uvlL9n3ys?=
 =?us-ascii?Q?k9KRvahZgVqjY1Tj2hKbn0LcXM17TUWnNu1T5Ju9og2j7q98D7YNMGR66ID4?=
 =?us-ascii?Q?YQspHYHbf/ih+3HtuoOtIcuBNJ2lDlOPwLVXbPi3DQfAxhv44xTSYO9RgJgm?=
 =?us-ascii?Q?urjW2kHjDFKtSbEPb7tvfbhH5k6kcC7Ow37otZEJLn1N2CnUg0IRumQNUVXU?=
 =?us-ascii?Q?tLNQmuJ4W4pScRVHGtiozmMbIz+hIqzMq+ZV1LGR4UE5FZTVFVYoa4J7NKtb?=
 =?us-ascii?Q?2/Ug3XmsQXvS5KLrTtYqpRilple2ecn3xSVWhLzZHdnsPVSa8Zlhvqnqy3Ce?=
 =?us-ascii?Q?4NBeneU9I1Yi3wXYUldEFoX1XN6pXV4SlB/NPv3tbsfpo8ATIUmOe3IDwWUD?=
 =?us-ascii?Q?/9Ht0EPjwBt8drM5wC5SpJooAYlp7cmWDQ/1/36CLbkr9favuq9xqbNCzjAN?=
 =?us-ascii?Q?YjbcN0416Ceeed0dOuM3nbFIgrTkSfKvq/qSgQzqF7zOtqPxE0D3aX+2x/ea?=
 =?us-ascii?Q?M4is1wr3KZEFTET9TwY6AzRPk8zxuuYWYZyPmqPjf3eJjkAsJh6F5ey3UwQS?=
 =?us-ascii?Q?auBj4ZHoprjeGNOLEwCLSKA+MlMmm0Z0SbTa5QOVxMN8HM/+LQmwF+bIb/uO?=
 =?us-ascii?Q?RT3Z48AUx+8zv/pWMn9seUeE5CAdlje2TrIFDV373meyRa0th/0o38L4jpcq?=
 =?us-ascii?Q?EKisyMr+zAsHO8pNVNcideoVj1AxqqAaM8FEK85tOZ2MMNnPrweOqB05WfBQ?=
 =?us-ascii?Q?u3jFSjtslrSFkJvYEEdgZG3jVLmxY8DB5N95NV4PswiYsjWp62DIGSbi66Bl?=
 =?us-ascii?Q?vbtk10+CbqQc98CODH03P1u5eNSVIrmODbyyPUM2Qm9AoSAcYdOYI/tus/PJ?=
 =?us-ascii?Q?ZmzqSC7tGYSRNu53KVg4AqtIucP07uRfYblXGfpWjEmsqlpfDswmvYwrj2YX?=
 =?us-ascii?Q?vUCQa/9F5ZSNfEHEq7AOGWEy9vWu/Oy04+hcCBi1l3gzJ9PpIOe8vfQBl/57?=
 =?us-ascii?Q?VDWTUIIwufNmUp6UFSANysi8/okHsKYWBeWfqMeXFZ6qA7lqc7UgjUcqkEgc?=
 =?us-ascii?Q?uzmVjmr9Xe+t+mgIFKnDFDPxtka/dYFp13baZlUafiOFC/rKKGGX6zE2wo9u?=
 =?us-ascii?Q?pYN9TV9SCL2TD+sUBa2rPS6U9TNusz+Yevg8cAaansoyGQ14RTyM6JbshxPc?=
 =?us-ascii?Q?4oap9U1ivI23A6RltDUpy8ynvV3sL/N2sAhzW0LrX+8ZDqI+fJvugR+tzu8e?=
 =?us-ascii?Q?D+T6yeQR/WJPEoK6gGFuGC++O9qta6Ty6qPyHx95kQOqnmEEqRL3yxQdINuV?=
 =?us-ascii?Q?mc5MQo0ai0KUdDiCYdpDNaFuiJS84ijSIVmQmAd4E+JWOlTMHYPyjKHctXA/?=
 =?us-ascii?Q?kF/ZmPSqf/UEpz0Gq4kn7JkFY9UBra+F0nNs/1vWr/QatJcuLCP7EahKWMoU?=
 =?us-ascii?Q?ZkbJ+oHux91o+NQp0bb+Eg+z5dmIKK4lEcohyEilOko1VrrY+V5dk9cULcTc?=
 =?us-ascii?Q?FOP36jUYBiuWBx5JC1HKe+Luvm0ncSMvvHkrD0W6X2EBPqxqM9QsBY8iapIh?=
 =?us-ascii?Q?6bW8Gzd+XfqFkXMij9Q3j2mTelZsMHDQ9Fgsaio+CLhdpbaY8w7j3uPCV7MZ?=
 =?us-ascii?Q?MlSMHzjmtu1xpVOkbHSzP8E=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118447be-be79-418f-e57b-08d9bfa17543
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 08:04:03.0278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0ba5/s2jB5hIVZcCCG393nWYSeQi5FhLZnLZ3sUCky1Dj6BBHbCQXtHvQ8RR677Or+kEnjUrVf/aECUHEbv6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8725
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On an ARMv7 platform with 32M pageblock(MAX_ORDER 14), we observed a
huge number of retries of CMA allocation (1k+) during booting when
allocating one page for each of 3 mmc instance probe.

This is caused by CMA now supports cocurrent allocation since commit
a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock").
The pageblock we tried to allocate may have already been
acquired and isolated by others, then cma_alloc() will retry the next
area of the same size by bitmap_no + mask + 1. However, the pageblock
order could be big and pageblock_nr_pages is huge (e.g. 8192),
then keep retrying in a small step become meaningless because
it's likely known to fail again due to within the same pageblock.

Instread of looping in the same pageblock and wasting CPU
mips, especially for big pageblock system (e.g. 16M or 32M),
we try the next pageblock directly.

Doing this way can greatly mitigate the situtation.

Below is the original error log during booting:
[    2.004804] cma: cma_alloc(cma (ptrval), count 1, align 0)
[    2.010318] cma: cma_alloc(cma (ptrval), count 1, align 0)
[    2.010776] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010785] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010793] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010800] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010807] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010814] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
.... (+1K retries)

After fix, the 1200+ reties can be reduced to 0.
Another test running 8 VPU decoder in parallel shows that 1500+ retries
dropped to ~145.

IOW this patch can improve the CMA allocation speed a lot when there're
enough CMA memory by reducing retries significantly.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
CC: stable@vger.kernel.org # 5.11+
Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
 mm/cma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 1c13a729d274..108a1ceacbe7 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -500,7 +500,9 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
 		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
+		start = ALIGN(bitmap_no + mask + 1,
+			      pageblock_nr_pages >> cma->order_per_bit);
+
 	}
 
 	trace_cma_alloc_finish(cma->name, pfn, page, count, align);
-- 
2.25.1

