Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0833F51353B
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 15:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347277AbiD1Ngi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 09:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347272AbiD1Ngg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 09:36:36 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E89674C0
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 06:33:22 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SDVkuK011009;
        Thu, 28 Apr 2022 06:33:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=CpIRz8I+aNU1NAv5F+azGnufrahGImcAu/jN7otehdo=;
 b=sjRR+QmwPPUIN31ndsAe/8reFC8HYl0InM1VXNYTPrLiQjnM5NvE3I6eeSVvpQZRz1sY
 Z/Mwqr1/DWbTUM1Az7Iasq0HwlePZXbTRlfp55WtpQ3PWs8d6Ezt080TX10Se37Q0Mz+
 tRzE/PeqKuibMJMPrW+/uC9ULNZSRbkT61I+t5SjNTIMu/TdXzdAJwKkNlhajaP3lGoc
 l2hSKQ2Q+88LdGbZg4bhnYsGPM5tzr7y/8z40Pxmgnq4luSCZa3K+9nuUNjMOhIeMM8o
 uOeXL+PkcwLcyateFG1ehE37NR6cH8HCvANQxuXCJelRRiK2v5rl4qCHYQGtWsEadh1G MA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fpshjsc6d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 06:33:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkrw1iwiqUY6QfKTsgGf4sEPn7GAv+c7Tic5hdXHuMNP5rvLqgHm9m/YhBy7OiR54PaAs6DcZJg+G94xznD7GedPrPPcMEDj4Ra0ZP9VP18NrBYfJuyVpsDlJxiAvWo9RYX1UcpM4vatHb1mEQZZ/7qTQdOb/PC8HQbcwmlSpdsNlMd2IGu/QfexgWpTdlTev6QOm59I+OCHCpvM4TOcaJ9iERLNZlEko0wGDqHQBxEb24SADlGY6VQOEKDcWfm1TyCvvFswPmhnHNAru6PBCyYA1h7yYDKaxMQs16qy0rw61RLwf7a1i3rZwPnvaY2xejOQk7AGNfFSmOzKEyxqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpIRz8I+aNU1NAv5F+azGnufrahGImcAu/jN7otehdo=;
 b=mtxyvu27OyWNVEmTW4G9GHkaTSE8s9tz8j73d+m3Iwu/UJ01cFEHSzp8d00LlNwIpk1UgV1yF7X9QZkcG4BYmJhsXhJYpfQxDv69ZGoMcYpHSfx7XDs0MTw7ArXl6+vg1s+LlNPbCGkYnksYekUAzrHxrdJ9EgbpPS6cs6e/yc9QeYLbpoISkqze8Vz9vl4rVmx3bnnm/rSmSI0poRNXIJDK1lCSGdmBViKYZsMLYPJHMpBwsbE67JNsuTVb/HPMmo8+o2zEQFdYrU61oUw1xvh5/aDL/sRR/JI9uhqy52jN/b/MSXVYdyNKEWoTUivBtCdiJI0dlDjAYSwcGyPICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1467.namprd11.prod.outlook.com (2603:10b6:4:a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 28 Apr 2022 13:33:06 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 13:33:06 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Jakub Kicinski <kuba@kernel.org>,
        Xu Jia <xujia39@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 2/2] hamradio: remove needs_free_netdev to avoid UAF
Date:   Thu, 28 Apr 2022 16:31:11 +0300
Message-Id: <20220428133111.916981-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428133111.916981-1-ovidiu.panait@windriver.com>
References: <20220428133111.916981-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0120.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36194ddd-a09e-40e2-6b2a-08da291ba0ab
X-MS-TrafficTypeDiagnostic: DM5PR11MB1467:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB1467E9107D3B81CD92CE40B1FEFD9@DM5PR11MB1467.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jii85v6M8LJPzwp/w6JyRCntl+3cScTs13zx6WBVJdtKUFbrP+GvNn/pW13lDtlS1EUV2xTOHoSHfbgOxYAYfA4s3R+mCcwJV4J9SPVlD57LomEaCFAMGduLwm1vwRUBL3TJIJr/I/4BxfVcxPilvdsIanijUD1M6XCo5Q81kN4q85+cPrXiGOqlDgFzOyuEBcvERExYq6/HzgKBhV1tJj3r3PaJQreyJ/gLzouA1bdZb55k1RfpQSjZJnhAmydeeQN5I5OujsM+1CIW7Qw9VICbgr/Eah08FE5K2nAtoJ3/55aOjXPAxh40uyJd1nQdvl6t8mvXDKkejf5igQa5RIbsgIUaftoM7egZOjROEHVtqliudHBNlj7l/AjBTA2u40510zmRzM+58+Vkz9z6tSdZM4yK8nIWVCiy7rbAMfj4+3Ecrhl1CY0dsmFsfmbJzJXg+9SPzQshRJLS7P41nNagQaX5mO8KYdeByzVGUe/3mxq4FYdtYmlA9pRr5yME3CdfPsp04Q9IY1cR+ucJ02V6P3J7A1cSwcj6P+huBlZPZiZFRQxFm4ztjmcem3g6ZVNuhdnAvw5VDBGJCWZgHJm0AbNhXUHtxY4Xv8mgUI7lo8hmN1CCdko8YDmHFE5sDPcCk2IfFKMPswjIEjxDad3bvc0qOh4Jg6MOzQB3LcRsV7HBusYwlexOojcYmH3qgsueyJYKjevGTFp/Z/iXQzS6TyKgzhETxnifItpTYe3TyWDaSEjknL20YbND1n2iJPrF0s2FIoh5n4R1SLGj5uUjRC+TEC1Yi914IzKCKDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(38100700002)(38350700002)(6666004)(2906002)(6506007)(1076003)(52116002)(44832011)(107886003)(26005)(36756003)(6512007)(186003)(5660300002)(83380400001)(8936002)(6916009)(54906003)(316002)(508600001)(86362001)(6486002)(966005)(4326008)(8676002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sN+CfLaqLjTFK1z9mjRJODWT/OWVd7JNoHbctCr6OBUqGgm1U7r9ArpOtfVD?=
 =?us-ascii?Q?ursFlnNBCZ5eGDJGythwAmZfQ0IGpUNzEAIruvdDd2BGslyQZ3H2zXYUo1mX?=
 =?us-ascii?Q?0daVhkeOx61PVJhVr3wu1vvOmP/YGp7V2c2PScalzuQb880/PeIDdGX5w0K1?=
 =?us-ascii?Q?CUDkRjEfDjoNhEgV7uPc35UhmtEEs3u3uynWBbNTZLUWlqaQQBymyDQHdHI2?=
 =?us-ascii?Q?ttsDjPP12syzfSw5dIAZcT3gSoPuz3M2Rb2DB50S7xk1U8cWCwDRQWd4d1qU?=
 =?us-ascii?Q?/NJzm7O1FOBqa6Q+jvzA6zI3J9ZCoqk/w1xEv6Hql2041sjshA/oyNpy4IBv?=
 =?us-ascii?Q?U1D+ZqQR52V9nPMwYceDHtm89z2blMeXij/lyMeihPr1wa6A6KQ67Td1Jzl5?=
 =?us-ascii?Q?B82zpfARL5nY7ELJzq9H1sT2qpq79ddZ18IVPUbkn5WaXRUgIZGxx3aDbbaW?=
 =?us-ascii?Q?F6Gr3QK5lKe3Q93JPFX0mgQTTm8TbHEGcF/I+AaLZU2p8NP951+hb/6QCg3w?=
 =?us-ascii?Q?O86LqTL1uhsq4vJcrdOheOd8MMsaoyD0Nsh36Eu6AGnddbBckF7f1HmLQNjE?=
 =?us-ascii?Q?bxT1JscMxyIHjcNu/WBRv2NQsUMqNReYwkmH2BJqslO1MzOwZdNSSb8Uxqgi?=
 =?us-ascii?Q?kmzHp/v/zyLxJYWpxXEInz0tRSjY+7VExJ63e2Jbt8zxAQQ/xsmNlmBeLT3p?=
 =?us-ascii?Q?5FrB5CRpcJogLHDr+ddMzO3Y2BAORG5+UbV+cVQ/tbYCD7LYQ3n2/kDO4zrk?=
 =?us-ascii?Q?eVcHYh6bQH0QBWp/Y/wb/XC2qONHVaZchBz6SrqTeoaLG1GCxBiS3MoW8SML?=
 =?us-ascii?Q?G9/lSVMVmeixwR+HY7GtCMBaHgPC+/WvsVluuKYwW9K6/sVKwsaSaDJVNlun?=
 =?us-ascii?Q?3y1h2P5MXAi8IvGYDxiw1nesYJa9XS27wEZVByRDkcgQTQdSCU6hBrs5PzDw?=
 =?us-ascii?Q?HoWgACsv7l6S1zesVNSbxDAyoPCSAjuu78BH3muR/HdNABLUcDWSc5ViCcx3?=
 =?us-ascii?Q?IdDGFrU/dND8EoBU8cu/LptwjDsKMyTCriHuqFUF/DxKA2ZihnsHWf2D20Ai?=
 =?us-ascii?Q?R2FlZ9gF0tRJ9pc4HDgiizRm8UNm12WrPZkixHMvRf4oIsyOLOqd2BpBqxJ+?=
 =?us-ascii?Q?rWHyq6+KgugXWUhEESvtbVMXAXK1Lvsh4dsAWmzlLVo+1ZCzBT085653pdGk?=
 =?us-ascii?Q?bE09ZDsBj81kreLeuQwAFX6wSNtuokyga9cCtj/1kdpuQ0jUrIZEirwSEX9q?=
 =?us-ascii?Q?EDnf3Dw4zyuP4YYvBswImOQxl6kgrYKc+AI9Va/lciKWqI5N0tapuS4LDomy?=
 =?us-ascii?Q?0N6wFqadpx+AUsWlHNo9Ld/3HJGPNSAqk1zCta05sOwDABLhO9q5bAcXwq10?=
 =?us-ascii?Q?EegqVxpztUaVvUU0SrcI0HWy14EPXAxmbP23rNGSd0MEfqIA3USL9KsNlBHv?=
 =?us-ascii?Q?4a5GIagi8Ju9LAE3tXJYBtmabyve6758nLSLjdzuO3WIS6aELoWqYjdsDKxJ?=
 =?us-ascii?Q?iuggQo6xWcPWrNjyOriPZ+1OFr6/XTWkopb6FsYXIxv2qeKSSU6EFABm+FoD?=
 =?us-ascii?Q?/Yt6Cg6a091K+0V3P8UjUZVvmpqzEQLtYylG2U2ax/WyLhq2bJSmCVijEZDa?=
 =?us-ascii?Q?qgNOxTHHVskhnUOWPDQnRCm1hr4a7/jZWdcjsyXkNY+bCpiwYNu1/D6KWCIP?=
 =?us-ascii?Q?S7+3OR0GQ0MOswFae4MYGvc6BqxLQ/Y6nzh8evBjChvHgZ5fOaPZGnyNSbgu?=
 =?us-ascii?Q?qUA1C6YelimaefMnk651+QtGlniFGwY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36194ddd-a09e-40e2-6b2a-08da291ba0ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 13:33:06.4665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFU7FCiJda/v2NoewrT2oU9mpkagXFEy6szzT1/1xVVXF8G/4t+TKpGFGH24ByLhOC1XdRPQxVVhN5Ems2iAjkDJvzPSIwE5Cyki86KOTA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1467
X-Proofpoint-GUID: SknsB0V4kMsRZ910KW1V7o-qNpU3oPND
X-Proofpoint-ORIG-GUID: SknsB0V4kMsRZ910KW1V7o-qNpU3oPND
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=838 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280083
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
index 82507a688efe..83dc1c2c3b84 100644
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

