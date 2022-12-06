Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA66444F4
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 14:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiLFNvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 08:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiLFNvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 08:51:43 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2070.outbound.protection.outlook.com [40.107.6.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AF02B613
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 05:51:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOxnIlBCs76qxL2uxHgRrvBCbVFQmCKep3VzuXrZIsQVb2R3NsZ9Y2HlqV+a3TjJcxenJPuBAC03jTKHC1kHcH8Ib1RFg52upfbhykC6Vk8jkktQGvm6SHXMTdc4bYl2vG054u810VE+h9e84I6FaTT2nbu7DSy1KqQdQwkiNc8aW1PeCjVL7/p8/P8gAE9Jmnqa/oonOUUnAQfnTMj8gDYWtsooQlBzZEZ3LAk9cj3smA58Go23t8ZMMtWLo10Q8cbuIaA9VjE3YmZXkrwRLO5Ma7L9rj/YrGKF3wNdabNfOQUOrwqFQGiHJtH/QUC+1KCG6UgiNCg+WbS/Y7/8pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2CUqx4ZU6QRu5AG5cwBthARIx1hCkCdhfOodNvAiig=;
 b=lyv/mAn8mWikXDgqjv9gfPDL0WndtsYlLQYH2faHfj66v07YSvCu10K1EdWW6qkepnvuSIo2iISfsTXY5mL33e1+YkKY4+Y5YVMpfGsOmWBnGdHUgPmBrvFe7Rac8/2ZfeoDS91IG/1Hp0BwWpxJpYH1WtRJoHUSdilqupQ+JHTgcvtpo2gtmmWRQjcYPUywWdMvKzI/ECFiGBVLujD96Ug4KQRWXE5KHoN1DjtjKEmmVBXMq06WweqPcJDTDWt6C9kGAfaUo2F/kBe3mdtYkTkSyV92zI4aS0398KYYMR2+RmwikkrHY+MU7PUr3OvoRlVKx+PL5vvnmbHb8H516g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2CUqx4ZU6QRu5AG5cwBthARIx1hCkCdhfOodNvAiig=;
 b=b9K6hfv0HCclFWfOSl7NXUNGaMl6z+JshKut+4sv+UPQhg7E3SZAGn6lj/tJe/aRwOkovlW2CInhRgg0IVUCCm3a6j27zeBr0AT2IQVFkjyNl6+t/bwSpfOwU9FPaIWUPwlybEv564fXZdDk1NFwEBWS14OnX1xu0W3vBYotNWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM7PR04MB7142.eurprd04.prod.outlook.com (2603:10a6:20b:113::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 6 Dec
 2022 13:51:39 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9%8]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 13:51:39 +0000
From:   "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     olteanv@gmail.com, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com,
        "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH] net: dsa: sja1105: fix new_retagging table size
Date:   Tue,  6 Dec 2022 15:51:04 +0200
Message-Id: <20221206135104.734446-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0010.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::14) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AM7PR04MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: 666c12e4-0448-48ac-8c3b-08dad790ff84
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 014FM5bFrlVeTCV3y2UTaWI292Mznhqzij0EdDxM14AThFIZXPL+6pfcRW7sLKdTLJYmhOS0NQ9blBnojPjsQI3sRXevmAyARY95swctmglfECb7oKVF7c4yaWVdFkH48wJ8JdJb6lWdX5oMsr69vnj9yEYDRD+UtAamTtM1hwqmEFRDoDC7NzbrtHKTo3jysDYvrou5Y5Pova/xtKGofpx5CLimauiozaWIp0uE0Xg9wc1N+agDRYgak2NNnbCxGFf3Z6vZiM3ACVSyq0/4xRkkBQm7Cc3ORKzek5BlSPOOKz8h+5HfLEkpo3d8H7dvaWUNF68eCFE7UxAX3Hl8xnlTbtlyP1TWipRgWNM5FwjqY2DHiO0e+Dh4lUyER8V4jtjUH6a5ojClTzjuSl0E3kTIGipSL21kfpQa+N0sLhg5I2Xt35T3vdJy0jK7+ULAI5fKYADfukgGBQJke9+Zkl8k6p2IRAGWvBe0+U84UNMcf1f5NZhTGOn5Ugyvu5J83CxZP91z2rZXWBv7O/vNdUZ2A2XQLN+OkEGOdomd42m7REti0zo5jTyh2pvvnoOhC0gVkLYp0pUj1DUpe7Krgtx4ZKit0gqc39jeY5Ttqt+UbAg9CWvrzAgt6FvylXTTMEne4Tj7nDm5MtJeukR9QqDyKWIcTupx3sSrR3zEjqY8Mad9bdeBrMPeA9/QWzDqm8GWLKma+GaQPVYUjaDDBBIexfMENNZAfIyTw14iX9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199015)(38100700002)(5660300002)(86362001)(8936002)(2906002)(4326008)(41300700001)(83380400001)(38350700002)(66556008)(6486002)(66476007)(2616005)(316002)(66946007)(8676002)(478600001)(6666004)(52116002)(1076003)(186003)(26005)(6512007)(6506007)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KovZVoleDM17D7Hob6BRqDEvwcv/QumHv6boizHgC6yd0RgYEWiZUOdV8ymn?=
 =?us-ascii?Q?GfCb9J8jJB6ljgIl2rzqjPSVp0OGJH2uuEGh9L6I4gXZgNFwJ+mFFOhabNx0?=
 =?us-ascii?Q?N611PzZe60fLxsgTcYElBakn4m9bOXa+eR54BM34/CDD2l9iu1KGAGJVs+HQ?=
 =?us-ascii?Q?5hTwBgf3zFSBd51UZbav7SZzjIxTyLVvRQTYLTJX4IDh7AMZcpS6YrZEdsA2?=
 =?us-ascii?Q?7uKcrSSGPvjc59SMd/v0/RBVdW1atJ+A9XdIPYjfUvTM7E/255FFoWJx5UfD?=
 =?us-ascii?Q?Lx035QFbspIVUq42jPqpkkO+DRjhnsutBCrk+q3Ej5hpvKyBgHEcqFzbRO/h?=
 =?us-ascii?Q?uIFWjMyaQW4fl2ALAp7fkGX4IPL7QUo2S4p6d17dLjQ0t1ujNsxlbhTN29d2?=
 =?us-ascii?Q?6/wELGUja8suX6STMs9B7wSjeKjABtoWrCGcq+JoGJKlrUiQi9NRFV3LI7hG?=
 =?us-ascii?Q?sR8BqkEBiJjpBMCJ3cFNbfXFwGKEv8McY737XvorVub/Uj/6pbMMDaeeFcAV?=
 =?us-ascii?Q?a8MOsREInhRaK6AmSkAXQzZtarvMHtGJ4lHzOibOFFP3IWLGSc9zK83se5hD?=
 =?us-ascii?Q?Ok/QV68rICVkdEJBegvbluu+AwUklRwyOKthXEcge+/BtMmS/WCSx/5qucJP?=
 =?us-ascii?Q?TWjAgMaB1mnacrGSZuGi1TjhS1FBGbo8rDdOOowEcMBaQB7ZZ1XvLisd/wne?=
 =?us-ascii?Q?S7i1CkoQcUU/nCA+I7yYw/7H9H1+cE2qHhOkZ8SVxBHKfybVL/sutzkqUVhz?=
 =?us-ascii?Q?USOy4fLjySj7biQdjR456FVI/hWSqlgLYtLE5H3Q/iAaleqNd/0HTxT/B8qb?=
 =?us-ascii?Q?cHtk6x9EJ2aljrqv7CO1qUwu4OMAV4zqQU9Vnktnp6ifKHhkU9bfGk5lrh9U?=
 =?us-ascii?Q?k+ImvKqZdvCQaJKjlNOLBomM+bMA2uAkTGHFlKKvQFpnfGEa52fuh3IDYZn9?=
 =?us-ascii?Q?BPDtCWfk3YpW2QT2b5xlRDNRMAxZf4cKj0eV+Qp35s1nVm/q2dCaxwUg77OP?=
 =?us-ascii?Q?hCrx6mXz0JPgQQ7rocv9OHmtfYd8ERfq/9usv3Hvm6BC88QUGInUbq/b2xX5?=
 =?us-ascii?Q?7bOgyr3++5z2ityw/BAYXf6KQJrWGrGo8fFTunAiiIeTkW12FpmREYzZPHna?=
 =?us-ascii?Q?1wxfVguzBFvaQg708mK2w/nftyYTYVRYKhSKjoAer58vZcW5q+ZYc6P4+QY2?=
 =?us-ascii?Q?Nk92SJncPt34o+ytm7sjS6iwWlB+ytyQftrPfVtuIcQMewODdxQ27xVT+c4f?=
 =?us-ascii?Q?HrAwJbq52TZZaCFDb3dblr/zZgoeqk8dF+SlNd81cd4AzGjLk2HMacomCHqA?=
 =?us-ascii?Q?NnBKIcrQkXpMJvywInP+z0PRfK9WxmsVdhDK7+kX6JVpDqwnxTfHdWLziGu6?=
 =?us-ascii?Q?lDfSiAfHhNJKdQuE7DYee8YcYzZZXqoRPrZNdxBWq66SqXoGcLWxvkyczfn1?=
 =?us-ascii?Q?5rmm0yO+Pz1ZDxA484HXoN76x/up6fRnRvRg+/esu1od1kWsoXBKUsTrlhIe?=
 =?us-ascii?Q?fpuO4yLrX2eo0jXdWSllcqXJo3480c85glE7ZI9//VrDZ5d0AmHHCrPkxsUW?=
 =?us-ascii?Q?K4QD5At0z9yDf9Hh7LUhA8J0T+jmDij9PU6rJ5W8pkEx15ZtdFMfm17yry1i?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 666c12e4-0448-48ac-8c3b-08dad790ff84
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 13:51:39.0204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: deZr1MkWcmMfWaxdybtrobaO7GW7sYn5/cBmWWLRFNdsUzeAV+8LCBskuzK/3LrVs3Uo8Sh56APwH8iIFAzmqYRbnvxeYRuhxwuIXa9877M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7142
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allocate more memory for the new_retagging table according to its size.

Kernel log:
[  208.509460] sja1105 spi5.0: Probed switch chip: SJA1105Q
[  208.647821] ==================================================================
[  208.647854] BUG: KASAN: slab-out-of-bounds in sja1105_build_vlan_table+0x1b8/0x1b14
[  208.647928] Write of size 8 at addr ffffff88081cf630 by task kworker/2:5/247
[  208.647955]
[  208.647972] CPU: 2 PID: 247 Comm: kworker/2:5 Tainted: G           O      5.10.145-rt74 #18
[  208.648003] Hardware name: NXP S32G2XXX-EVB (DT)
[  208.648024] Workqueue: events deferred_probe_work_func
[  208.648080] Call trace:
[  208.648089]  dump_backtrace+0x0/0x2b4
[  208.648137]  show_stack+0x18/0x24
[  208.648178]  dump_stack+0xfc/0x168
[  208.648224]  print_address_description.constprop.0+0x70/0x468
[  208.648276]  kasan_report+0x118/0x200
[  208.648321]  __asan_store8+0x98/0xd0
[  208.648363]  sja1105_build_vlan_table+0x1b8/0x1b14
[  208.648405]  sja1105_dsa_8021q_vlan_add+0x60/0x80
[  208.648446]  dsa_8021q_vid_apply.isra.0+0x11c/0x140
[  208.648501]  dsa_8021q_setup+0x224/0x610
[  208.648545]  sja1105_setup+0x398/0x13b4
[  208.648581]  dsa_register_switch+0xad8/0x1430
[  208.648620]  sja1105_probe+0x50c/0x744
[  208.648654]  spi_drv_probe+0xb0/0x110
[  208.648696]  really_probe+0x150/0x6d4
[  208.648734]  driver_probe_device+0x78/0xec
[  208.648773]  __device_attach_driver+0xe8/0x17c
[  208.648813]  bus_for_each_drv+0xf4/0x15c
[  208.648847]  __device_attach+0x120/0x26c
[  208.648883]  device_initial_probe+0x14/0x20
[  208.648921]  bus_probe_device+0xec/0x100
[  208.648956]  deferred_probe_work_func+0xe8/0x130
[  208.648995]  process_one_work+0x3b8/0x650
[  208.649031]  worker_thread+0xa0/0x72c
[  208.649062]  kthread+0x23c/0x244
[  208.649101]  ret_from_fork+0x10/0x38
[  208.649134]
[  208.649141] Allocated by task 247:
[  208.649155]  kasan_save_stack+0x28/0x60
[  208.649195]  __kasan_kmalloc.constprop.0+0xc8/0xf0
[  208.649237]  kasan_kmalloc+0x10/0x20
[  208.649275]  __kmalloc+0xd0/0x180
[  208.649307]  sja1105_build_vlan_table+0x160/0x1b14
[  208.649347]  sja1105_dsa_8021q_vlan_add+0x60/0x80
[  208.649386]  dsa_8021q_vid_apply.isra.0+0x11c/0x140
[  208.649435]  dsa_8021q_setup+0x224/0x610
[  208.649479]  sja1105_setup+0x398/0x13b4
[  208.649513]  dsa_register_switch+0xad8/0x1430
[  208.649550]  sja1105_probe+0x50c/0x744
[  208.649583]  spi_drv_probe+0xb0/0x110
[  208.649619]  really_probe+0x150/0x6d4
[  208.649654]  driver_probe_device+0x78/0xec
[  208.649691]  __device_attach_driver+0xe8/0x17c
[  208.649729]  bus_for_each_drv+0xf4/0x15c
[  208.649762]  __device_attach+0x120/0x26c
[  208.649797]  device_initial_probe+0x14/0x20
[  208.649834]  bus_probe_device+0xec/0x100
[  208.649868]  deferred_probe_work_func+0xe8/0x130
[  208.649906]  process_one_work+0x3b8/0x650
[  208.649938]  worker_thread+0xa0/0x72c
[  208.649967]  kthread+0x23c/0x244
[  208.650003]  ret_from_fork+0x10/0x38
[  208.650034]
[  208.650041] The buggy address belongs to the object at ffffff88081cf000
[  208.650041]  which belongs to the cache kmalloc-2k of size 2048
[  208.650068] The buggy address is located 1584 bytes inside of
[  208.650068]  2048-byte region [ffffff88081cf000, ffffff88081cf800)
[  208.650099] The buggy address belongs to the page:
[  208.650114] page:000000002c3ceac6 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8881cf
[  208.650145] flags: 0x8000000000000200(slab)
[  208.650192] raw: 8000000000000200 ffffffff1bfc6518 ffffffff1bfd36a8 ffffff8800000400
[  208.650221] raw: 0000000000000000 ffffff88081cf000 0000000100000001
[  208.650237] page dumped because: kasan: bad access detected
[  208.650250]
[  208.650257] Memory state around the buggy address:
[  208.650275]  ffffff88081cf500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  208.650299]  ffffff88081cf580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  208.650325] >ffffff88081cf600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  208.650341]                                      ^
[  208.650359]  ffffff88081cf680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  208.650383]  ffffff88081cf700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  208.650400] ==================================================================

Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Should be applied on top of 5.10.157.
It is not relevant for newer LTS kernels.

Cheers.
Radu P.

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c03d76c10868..868303d931fc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2592,7 +2592,7 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (!new_vlan)
 		return -ENOMEM;
 
-	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+	table = &priv->static_config.tables[BLK_IDX_RETAGGING];
 	new_retagging = kcalloc(SJA1105_MAX_RETAGGING_COUNT,
 				table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!new_retagging) {
-- 
2.34.1

