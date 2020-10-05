Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C04283271
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgJEIsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:48:11 -0400
Received: from mail-vi1eur05on2111.outbound.protection.outlook.com ([40.107.21.111]:4352
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725880AbgJEIsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 04:48:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6FjCNYup6bP/WvkbSoV8HEI0ZPxZECpROFUV1fKYIw+IQLDasJ08UeITFvGtdvwjGUL3RAdE9ErJn6T3s4aFMASyl/VqeXVBxv+uG0RC0kVHumc1QA6cEm+rtKbC8LMTgc/V4STfqVjGJmBmnvvzea9xSI7iOVWqP1LGY93rTxg21RyMOMk23RWROJWAnEWxWwtfFPTSCR3CO3o7wLasKfjyKXqzDJY6Uo67YrEo7GtJ/8C8xmRXXQbTh4/GMng43IUqF+E2lvu1tOM/I8XXpGcqBnLji0bVrGB8jpGig6A95fBC0JiIEL5Iimry84p62ldtxueajHhQe8lUr8K4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CL34VxT1N4wjz/MGEmKojL1eFi3c95IK2kEnwLiDIgY=;
 b=SYyT7o45ALwJG1iY4cLrp/UhCFENDci3OE8qUotMaWlBrdnYCU4YFlAl5/hm1k/95jHNlCNIqfZm72pRdg48Iak8vXFvDNdAuiiBpCOytxYIIFM+2d9OHFwFy97+/RQGrzuZx4kSI8wILJvaJEbrnOxaLhg9smGOYRJ/RvxFT3trKQbYqwMUq4hkrJXph77Rk/m2LL514SFIbWSfXblRVjPM3PWgyRcOgKX8gvC9Zn0yK1WC4Gt/SOK4QDmY/cdsM6MXp6QSsJ4WsdQ6lB1OaJZXsDiZ/kuQHp5Fw1cjRKoRenhdOOPx4Sqy+IqQ05gairPjXG8wK5iyH5Af4nj6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.8) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CL34VxT1N4wjz/MGEmKojL1eFi3c95IK2kEnwLiDIgY=;
 b=A3+qUa6cWlYxXqq3JcnBHUbnR/eGcSGJ4+OVOilm2j9GaZJ97T5LUvLzb8gNSKC3OuEUHNmN2T4bOpa3jNITr6+vbMlST8MgD+CMn4QMOK812yXyyGe7v3fAWpS7JS5JY0iSLEqVcA6hrMuZEcV2/+9YLw7IJY3/S3jou17jurc=
Received: from AM6P193CA0126.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::31)
 by VI1PR0701MB2847.eurprd07.prod.outlook.com (2603:10a6:800:83::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13; Mon, 5 Oct
 2020 08:48:08 +0000
Received: from AM5EUR03FT062.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:85:cafe::e) by AM6P193CA0126.outlook.office365.com
 (2603:10a6:209:85::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend
 Transport; Mon, 5 Oct 2020 08:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.8)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.8 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.8; helo=fihe3nok0734.emea.nsn-net.net;
Received: from fihe3nok0734.emea.nsn-net.net (131.228.2.8) by
 AM5EUR03FT062.mail.protection.outlook.com (10.152.17.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34 via Frontend Transport; Mon, 5 Oct 2020 08:48:08 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0734.emea.nsn-net.net (GMO) with ESMTP id 0958m5tE029518;
        Mon, 5 Oct 2020 08:48:05 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Subject: [PATCH] mtd: spi-nor: Don't copy self-pointing struct around
Date:   Mon,  5 Oct 2020 10:48:03 +0200
Message-Id: <20201005084803.23460-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 998e2e48-7fb2-46e9-0a9f-08d8690b61e8
X-MS-TrafficTypeDiagnostic: VI1PR0701MB2847:
X-Microsoft-Antispam-PRVS: <VI1PR0701MB284799650678BB8084729C52880C0@VI1PR0701MB2847.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqsUy1WybPbw2bcmIWtq3XOkwrUGbUs4iTvInDR9H0tFugDzQdB/KuMXTGS+UtFELG6tBJi3QO9ambRZq4rhwRE3GhYxIManBNEPGrxnC6Rj355IUNuiLfA6vrZmdhuEeef7pAXuRyMNeWCHtSi80Hrpr4rSrtJJLYrljoiecGqY8qi52nH+GIdZPzHRuzDddd09hJ+s3I+8CdYz+A4mqhW/m4IaoRP6Y5+YBC2NAXfsRGUjdH+apYUQ4PGhWyJmcog2rEHZtm365j+ZAPoQ3MGtv/SRnhh6XY4SmgMMlpShK2a99EDP9ING6KGIwSlCGo697nbO35iWZs0/GVpI7cspKGuiwXFcxvOiFf+YRdh7Hjn4IQW+EGb/vsqMbVxpSL9Ptpfi0Qh/wWgMK4Cf0w==
X-Forefront-Antispam-Report: CIP:131.228.2.8;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0734.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966005)(336012)(83380400001)(8676002)(4326008)(8936002)(86362001)(2906002)(186003)(54906003)(2616005)(498600001)(26005)(70206006)(36756003)(70586007)(5660300002)(82310400003)(1076003)(81166007)(47076004)(356005)(107886003);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 08:48:08.0479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 998e2e48-7fb2-46e9-0a9f-08d8690b61e8
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.8];Helo=[fihe3nok0734.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

spi_nor_parse_sfdp() modifies the passed structure so that it points to
itself (params.erase_map.regions to params.erase_map.uniform_region). This
makes it impossible to copy the local struct anywhere else.

Therefore only use memcpy() in backup-restore scenario. The bug may show up
like below:

BUG: unable to handle page fault for address: ffffc90000b377f8
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 4 PID: 3500 Comm: flashcp Tainted: G           O      5.4.53-... #1
...
RIP: 0010:spi_nor_erase+0x8e/0x5c0
Code: 64 24 18 89 db 4d 8b b5 d0 04 00 00 4c 89 64 24 18 4c 89 64 24 20 eb 12 a8 10 0f 85 59 02 00 00 49 83 c6 10 0f 84 4f 02 00 00 <49> 8b 06 48 89 c2 48 83 e2 c0 48 89 d1 49 03 4e 08 48 39 cb 73 d8
RSP: 0018:ffffc9000217fc48 EFLAGS: 00010206
RAX: 0000000000740000 RBX: 0000000000000000 RCX: 0000000000740000
RDX: ffff8884550c9980 RSI: ffff88844f9c0bc0 RDI: ffff88844ede7bb8
RBP: 0000000000740000 R08: ffffffff815bfbe0 R09: ffff88844f9c0bc0
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000217fc60
R13: ffff88844ede7818 R14: ffffc90000b377f8 R15: 0000000000000000
FS:  00007f4699780500(0000) GS:ffff88846ff00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000b377f8 CR3: 00000004538ee000 CR4: 0000000000340fe0
Call Trace:
 part_erase+0x27/0x50
 mtdchar_ioctl+0x831/0xba0
 ? filemap_map_pages+0x186/0x3d0
 ? do_filp_open+0xad/0x110
 ? _copy_to_user+0x22/0x30
 ? cp_new_stat+0x150/0x180
 mtdchar_unlocked_ioctl+0x2a/0x40
 do_vfs_ioctl+0xa0/0x630
 ? __do_sys_newfstat+0x3c/0x60
 ksys_ioctl+0x70/0x80
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x6a/0x200
 ? prepare_exit_to_usermode+0x50/0xd0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f46996b6817

Fixes: 1c1d8d98e1c7 ("mtd: spi-nor: Split spi_nor_init_params()")
Cc: stable@vger.kernel.org
Tested-by: Baurzhan Ismagulov <ibr@radix50.net>
Co-developed-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/mtd/spi-nor/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 2add4a0..cce0670 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2701,11 +2701,10 @@ static void spi_nor_sfdp_init_params(struct spi_nor *nor)
 
 	memcpy(&sfdp_params, nor->params, sizeof(sfdp_params));
 
-	if (spi_nor_parse_sfdp(nor, &sfdp_params)) {
+	if (spi_nor_parse_sfdp(nor, nor->params)) {
+		memcpy(nor->params, &sfdp_params, sizeof(*nor->params));
 		nor->addr_width = 0;
 		nor->flags &= ~SNOR_F_4B_OPCODES;
-	} else {
-		memcpy(nor->params, &sfdp_params, sizeof(*nor->params));
 	}
 }
 
-- 
2.10.2

