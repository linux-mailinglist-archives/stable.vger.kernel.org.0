Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8795F48F9C3
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 00:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiAOXCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 18:02:54 -0500
Received: from mail-sn1anam02on2111.outbound.protection.outlook.com ([40.107.96.111]:15494
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233870AbiAOXCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jan 2022 18:02:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncb28DAgdCJw302Q4w3U59zbtMBcTXCXXFDoM8RjWG1R119Qi67rws21th+3+06zvZ2iZJ5irUMUne4XMKlP6Iefl5dAWE8NVVnoAPBsgJ64xC7pZQZ8BlKY8pfYyFfC+MOgDjb3CRNy28WyGGDUY6cio7YX0wIB3Lvgsvxs/WAcqTNMfvX/8DYCj+OS7205r5X8UkbGns3OFtGW42d/gnzOvz//Oku7NzvL3rV+smfQc3nnBfNArHX7yB+nPS0lnkfWEYv6PBsPnEeYzdAbhkNEAHlkyep3yDP/jIQ513bKhPKAjjIi0GJoIcsD1xnxGWUo/ZChXuvDQObpOplTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFaCisCEQcwCkTuPnNda1ENNEW13q+t3SkY0KWLAiwU=;
 b=ckoi+2swV8K4q4GQ+4vsEyAZqxDjESZ7piaFq7Zvxki/IOtPah6W1emPWpAD8sMiCcnwy0PXtjNqwjS5+5sROFMYDU6gjPMOCBlitwF6XL51dKB6RbMlWQcJffViYrqjtDLMxNJd/YYmLw1r+SVdKx/pbhsRPOgHSzzYh7NcD/u1T71MtfaJbn7FJn6gFSIp8dWoy+Xdwuvig/zZblQRKoXeCmF740nSqal6o3aOiAI6iRBZyMPWXG9Qa0OTNZ+JuU/VVnnK0sv8pFvmCIF6X4zEWCJt5BySNAKCneDUQ++aPd14ivjj9hlepTqXin+wFcnD+CSXRfQ8e9N6KT/ytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFaCisCEQcwCkTuPnNda1ENNEW13q+t3SkY0KWLAiwU=;
 b=TwO1XfQ4nelV++pqxh/w9hYEAFcJR3wOkmZcnoypWGT7XZbmEaGPbXeGYHVlsACnJUNPYvwksFij60CP81Gdm0/l8WTWBjuzM/rgJpcAkZPO3BL7aB7OgbIdv7kKWGBsjN8LGnGBA1RHOAJtuG8P014By0ucdjFy5HmZDDH9cioGPaMoNgnWKqFurcp8WuyQ7Eu/UJHMryRWyXf6ppxUjIPgyTa6RyQLzx68Hl+S2Pdxf9eE2wEfyEXuYlssGbgazf8ZxNAK3y5GmpMOpPy2HX1LCHx4DppNDRcNBWNAXITgGeggV8PdodqgnH5Ac8JydMv8zyCVUXS59T/Bci66SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 SA0PR01MB6140.prod.exchangelabs.com (2603:10b6:806:e4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Sat, 15 Jan 2022 23:02:53 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::110:392e:efd1:88d0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::110:392e:efd1:88d0%8]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 23:02:53 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: [PATCH for-rc 1/4] IB/hfi1: Fix panic with larger ipoib send_queue_size
Date:   Sat, 15 Jan 2022 18:02:33 -0500
Message-Id: <1642287756-182313-2-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642287756-182313-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1642287756-182313-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::21) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cba2973-c16a-4d2b-9a39-08d9d87b290b
X-MS-TrafficTypeDiagnostic: SA0PR01MB6140:EE_
X-Microsoft-Antispam-PRVS: <SA0PR01MB6140695DF0BE2580012815B4F2559@SA0PR01MB6140.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XGPONjfST9wmtuxbcHVyicTDOqQJO/e8poubmOd1gAotMs0QPSLOXUBwFrwpZQx+DTQ9BALBa45Ew1N77QY6zKFhRAzUZCgilxWV1WLhKCcIbYT8T2JpqvkXKskFk1+xqbzvzQnb/L6Gn7AisFvVrG+ORuN3QuyeUE1FWZ4uAwuxCyIh3Iawb4FHwlrPKgR+Ud52w0n7yIPsScdwQrv7Qz8NckT84VnCg2K+w5ec1BY/9j8Ye66FW4W3gLh3Kwkzpzwu67dCpnBoOleI9OENYLhy4GzVGEDgLf6xl/phQqXoSkfD3zNEKEFoR+TXFYkUITKyyOI7F6POxXUmf80LpcMblaqSErJ8ub3ghJ3S9hV+cZK0OzgJVt9XGoq5yTZtZ1MQW/IOSVEAWRB8xbkr/0fdziFJX5cm+BbTv8VWuzzJdQ5xQihYRH1OpB2kH+LWJTnHi/JDJBeyV4oP3tzfz6MuLBo0ZXHpagCmshSIL6YNkp7FXc+tYUU6FqzDI7/1+KqCCuxaziSDaXu+aDliy0teHicPrmOII04VmKufnVj4slZRPPgFeKRjX5wzwTUNH+ZbeAushQd6hZhXH2N9zUew0qMGHSg6E//ilJgW0qM3bIKSurQwJio3m3wFkNTDUHf7QoIQzduV41bhyNQm0ihZ9O52mqwG3Rh1X9Wu9muvHPl5iRou4V1bT3LmQrDwjUe2I8cBqRvv7mqgRmlzOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(36756003)(86362001)(508600001)(4326008)(26005)(52116002)(8936002)(6666004)(38350700002)(38100700002)(6916009)(8676002)(6486002)(66946007)(5660300002)(83380400001)(66556008)(66476007)(186003)(2906002)(316002)(2616005)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xna8/OQRvnG+/ZTwCBaLswb7yBj5C0cltxegphNL0n7+pgqIFzDtrp/YfUKg?=
 =?us-ascii?Q?4SWcGPRHf6y3dg+gfZRZtXDU7quhYmFi1t9Rcp5WJQ1+S8ntO7Op/YdpXj0n?=
 =?us-ascii?Q?wlVFngDjuTnsnVJ+QFQqKuJ/XUJEDPyTn6r2C7tTUVGB7VUc6RQtBc1Cz4zh?=
 =?us-ascii?Q?hhKvocBRMPI4csQ6AUBEBfuDAYldKthe1F53yelT5lCQdatjTuotXg04UGlw?=
 =?us-ascii?Q?3bMzXBcLS0VPbS8zZaZiqWHOni2SQvaPe5vWw2NOGhM+DBwFqNFak/DsGM+H?=
 =?us-ascii?Q?3ZTOR3IzsOfDpGEmhlGoDQWLZHnzeS0wVqAWY2jyXkfOerScGJUwwQ/yXnnx?=
 =?us-ascii?Q?kzaSdVQooeDY63fJjkh4wLDlU7CWh3tfnoTzigM4UYkgIiovt8/mQp9W4FMc?=
 =?us-ascii?Q?Yq6N50BLzbwu9MhCgNCpNtLUKz7ncBiBDvQKhOdRYopnzU5pBifyFjNVOYuQ?=
 =?us-ascii?Q?6mX+RVEP+tMvvB96jH08tZJl3nik/IMaPMe3HZlIegDqQs8ahz70r76K4Lmh?=
 =?us-ascii?Q?tcVBuQAyhGo4qT+oF6L0WRM3nvuZS7pdZR1b9LN8XuvcuEo8d7KWT+KT9PiC?=
 =?us-ascii?Q?WiZjpzxCdKTjcWmv6tyRMQ1KOgx+zZvd2LXa2LUjp+i2LGs1PYNO8+DV5Ns8?=
 =?us-ascii?Q?ae0bXz/p98e6NMrehbtvgW2BCO/IG/lOwrKGJpxOKWP7bIS0gf3lgfkXi1Uo?=
 =?us-ascii?Q?o6tmQZqXx3Ih35H+Ff/QHB+I08cEHFDgpG2cdPcsLH2DtGmcd/cs5loqJ+BW?=
 =?us-ascii?Q?IdIhWfJ5dRigXm6gBZ0uX9oqn8/wmtwVK0W9UUk38jenaty0MC1+DVPWm/La?=
 =?us-ascii?Q?P1IAWHxnqQ2PrTAZCnLXQ9U5c5DGe6QHzF94wt8zDW2e8uncXCJbIBliLq2a?=
 =?us-ascii?Q?YQtqmIlrXZbWBmr/JefgYEox0GRvnbGOTLqaD3/RYj2XBXKbBStjKpKUBa6e?=
 =?us-ascii?Q?MOQ9ENwLhDynszTDhQJyl4dSJQ9VqyJNhCf1h7czCgdQO9rfwnSdm9aaLaSz?=
 =?us-ascii?Q?8yVmizdh3nP90MFaRHLztN8a16dr4StewXtoWpbV7aS+sVZnaZ3TTXCwuyxi?=
 =?us-ascii?Q?biJbQj2hbudtNCB3yjGrXpy5FIlB6fLP1TvTIkwMvGM0JTy0ZimaFJEaXXY0?=
 =?us-ascii?Q?aDP66miDo5sRbwfPDiKQDWmxyuaVnXZE1w+/7gkJc6fpcUmBVWMmE8vTgH4g?=
 =?us-ascii?Q?/unA4IaUFHuhxvFidiqNwxb3oTQFF+8b2JSPQ8+6ctaYqXDxn41xiGu0Mqu2?=
 =?us-ascii?Q?IxFbbdsR2K1gmW/HogSW4Bt3Qau+O45b31lPdT7659VZpEQtkKWlEu0Dl/sq?=
 =?us-ascii?Q?R9izW+0prAhBRK/ZcQLceQnocR3FS8Ze0c6QYIOsvKJxquYbnssjwqjEF8nk?=
 =?us-ascii?Q?D68snLYxAT0tqQHIRGoO/7Wy3X3ErT6Bw9LJSp7hreyoiYZc5hQ75yUZZpKU?=
 =?us-ascii?Q?cj0jCy7zs16G8qf8wAWKaUEUpR316QpkSc6b2bMk70lE2IQxapiMMQD0UbOJ?=
 =?us-ascii?Q?er/mjMmBVySmRvn+asrZQ45rreStSrEfUv51P+x2GfwO+f27Shi9NcxuU8c7?=
 =?us-ascii?Q?n0oMi+VcSSDG7+eidd/DCG38wG2AZTeB55AHZT83s5VMpuxTEu3clw8l6+2H?=
 =?us-ascii?Q?7+98PIp0JliqBZbq6AtLuVy54YQgreNSx/uxBodG2Tw2uEMqTcczbMrb0Upc?=
 =?us-ascii?Q?XmKtNrjy3OoRJIFdZen5hPlf9Qy0F8Ljf1IuxGg1dkwSp6IyK/rztCW9SBZf?=
 =?us-ascii?Q?469Eu+z6kw=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cba2973-c16a-4d2b-9a39-08d9d87b290b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 23:02:53.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPEueRN4kZws+JgG92P8+CL4/gW/9gb5m4desvCa0JbjEeapbIJRPHUZNpWesQK6n4OXXQkZiiuS96ziLyns34uPNd+pJPUvrVgM1FIICQG/Psp0b0phGv3ll+ccvS2q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6140
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

When the ipoib send_queue_size is increased from the default
the following panic happens:

[  219.242960] RIP: 0010:hfi1_ipoib_drain_tx_ring+0x45/0xf0 [hfi1]
[  219.250708] Code: 31 e4 eb 0f 8b 85 c8 02 00 00 41 83 c4 01 44 39 e0 76 60 8b 8d cc 02 00 00 44 89 e3 be 01 00 00 00 d3 e3 48 03 9d c0 02 00 00 <c7> 83 18 01 00 00 00 00 00 00 48 8b bb 30 01 00 00 e8 25 af a7 e0
[  219.273764] RSP: 0018:ffffc9000798f4a0 EFLAGS: 00010286
[  219.280740] RAX: 0000000000008000 RBX: ffffc9000aa0f000 RCX: 000000000000000f
[  219.289842] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[  219.298864] RBP: ffff88810ff08000 R08: ffff88889476d900 R09: 0000000000000101
[  219.307907] R10: 0000000000000000 R11: ffffc90006590ff8 R12: 0000000000000200
[  219.317016] R13: ffffc9000798fba8 R14: 0000000000000000 R15: 0000000000000001
[  219.326100] FS:  00007fd0f79cc3c0(0000) GS:ffff88885fb00000(0000) knlGS:0000000000000000
[  219.336171] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  219.343639] CR2: ffffc9000aa0f118 CR3: 0000000889c84001 CR4: 00000000001706e0
[  219.352589] Call Trace:
[  219.356340]  <TASK>
[  219.359804]  hfi1_ipoib_napi_tx_disable+0x45/0x60 [hfi1]
[  219.366887]  hfi1_ipoib_dev_stop+0x18/0x80 [hfi1]
[  219.373313]  ipoib_ib_dev_stop+0x1d/0x40 [ib_ipoib]
[  219.379814]  ipoib_stop+0x48/0xc0 [ib_ipoib]
[  219.385604]  __dev_close_many+0x9e/0x110
[  219.391001]  __dev_change_flags+0xd9/0x210
[  219.396618]  dev_change_flags+0x21/0x60
[  219.401878]  do_setlink+0x31c/0x10f0
[  219.406841]  ? __nla_validate_parse+0x12d/0x1a0
[  219.412902]  ? __nla_parse+0x21/0x30
[  219.417844]  ? inet6_validate_link_af+0x5e/0xf0
[  219.423913]  ? cpumask_next+0x1f/0x20
[  219.428914]  ? __snmp6_fill_stats64.isra.53+0xbb/0x140
[  219.435648]  ? __nla_validate_parse+0x47/0x1a0
[  219.441564]  __rtnl_newlink+0x530/0x910
[  219.446818]  ? pskb_expand_head+0x73/0x300
[  219.452198]  ? __kmalloc_node_track_caller+0x109/0x280
[  219.458999]  ? __nla_put+0xc/0x20
[  219.463733]  ? cpumask_next_and+0x20/0x30
[  219.469166]  ? update_sd_lb_stats.constprop.144+0xd3/0x820
[  219.476325]  ? _raw_spin_unlock_irqrestore+0x25/0x37
[  219.482815]  ? __wake_up_common_lock+0x87/0xc0
[  219.488761]  ? kmem_cache_alloc_trace+0x3d/0x3d0
[  219.494917]  rtnl_newlink+0x43/0x60

The issue happens when the shift that should have been a function of
the txq item size mistakenly used the ring size.

Fix by using the item size.

Fixes: d47dfc2b00e6 ("IB/hfi1: Remove cache and embed txreq in ring")
Cc: stable@vger.kernel.org
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/ipoib_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index f401089..bf62956 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -731,7 +731,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 			goto free_txqs;
 
 		txq->tx_ring.max_items = tx_ring_size;
-		txq->tx_ring.shift = ilog2(tx_ring_size);
+		txq->tx_ring.shift = ilog2(tx_item_size);
 		txq->tx_ring.avail = hfi1_ipoib_ring_hwat(txq);
 
 		netif_tx_napi_add(dev, &txq->napi,
-- 
1.8.3.1

