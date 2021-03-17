Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEF933F4D7
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhCQP76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 11:59:58 -0400
Received: from mail-eopbgr60112.outbound.protection.outlook.com ([40.107.6.112]:14261
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232097AbhCQP7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 11:59:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQRhe5kKhW0Texq15rYfL6xfdCAd/qxuACkOKmPTQWcNkjhOJcGHVaXBNzX13dG1dcVzIFwgpCrOF98TIso4UNnssf0enHfjft/c2kn4q+MIaEFYANj3fpnL4TUPovsrQqicDfcidQdNQtMX7ch4MRmLYAG+RcTUN3mwwbTB/GzsIySKZ63Tbh38kOUxXm0tttR86rmLUUn+8r3dvelyufg8f+SwTztTO5TjFRTwnvOIE2O30bovcWlkIUNZ2lA4Q6MX9Epyor/Ok39d/HD3R4E9FZMmLJUHuuR4wL6PcKXjU886kPwkwF0tfnJIVb16nhmcKMmX212Awsw207DRNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DWqM+nIiyToc6tqulDetCnmws2igtNY24BaqWBt1SI=;
 b=ZyLD+T25Q9Gf8jjyQfjGsUCL9AjV9sY0wLLOp9AIS/LnTBFS37N6PyuAKMD1ThqhUc69VRhzwP4ui/8PriQiO5hAfgXIr+AlVxo1LEm0PAJMN7in/T6PUBatAF/VgbWNesThn6krDsvJ6xoVGTfFyq8XkgR32lSiEpaYp/foZwj7CS/BuqpF1bT83lHdT/zBH6XqLuLOLxXBWTbkuT/lPM8Oq6hR06Ec7ZdxanzngEqOV7wZNanEtROACWMrRpiJVlHkClHwptsXMJzEFk5drPSWjEXTuSZmF77XkqZPRMUjv2TKgko/KK0e9S1sN1Mhb+DfRRXWgIY7/DM42GyBfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.8) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DWqM+nIiyToc6tqulDetCnmws2igtNY24BaqWBt1SI=;
 b=Y4CU/MvaGF/ZwrT6RMYDoCFWe7dY1ZuR+jJnnznaZ/WcNVDjN3wFgE6vnyduiHanNexdSdJqGsBAZ5yCYlXr3vZK33Zt3dU8wZj2hAtLV0DDoGFN2SMtIcElc65azRsXZypDPkHrcK9I6FBWsxVrlKtq2L+KM5ltKcnt8RerSbE=
Received: from DB6PR0201CA0020.eurprd02.prod.outlook.com (2603:10a6:4:3f::30)
 by AS8PR07MB7462.eurprd07.prod.outlook.com (2603:10a6:20b:2ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10; Wed, 17 Mar
 2021 15:59:31 +0000
Received: from DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:3f:cafe::a0) by DB6PR0201CA0020.outlook.office365.com
 (2603:10a6:4:3f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 15:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.8)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.8 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.8; helo=fihe3nok0734.emea.nsn-net.net;
Received: from fihe3nok0734.emea.nsn-net.net (131.228.2.8) by
 DB5EUR03FT041.mail.protection.outlook.com (10.152.21.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 15:59:30 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0734.emea.nsn-net.net (GMO) with ESMTP id 12HFxRUR016614;
        Wed, 17 Mar 2021 15:59:28 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] rapidio/mport_cdev: Fix race in mport_cdev_release()
Date:   Wed, 17 Mar 2021 16:59:17 +0100
Message-Id: <20210317155919.41450-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: f9a4b88c-9d09-4c58-20c1-08d8e95da6a7
X-MS-TrafficTypeDiagnostic: AS8PR07MB7462:
X-Microsoft-Antispam-PRVS: <AS8PR07MB7462836B7E258CF58D0C444F886A9@AS8PR07MB7462.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iw+4ShiuttMqNGa3mnKqcmb8dtukppKtdVUjSDo+oK3oFmWdNcY8qII986TzkFsu2ycHzUOtQ8iAOpPRecI14bWLRQ5vtnbELyF+LxszjzTX5VS5c4xz8dAV3n1LFLETknulVIIo/pnAhTaE9haB9ixCnqiE9QHXF7pep3xMGU9J9GxA5nrE4ZWWWkNM7GIdh6i2px4doXSOra9dmvBIJC+NpMJdGCD98YNOS9hmRjnFXhQsM3h0uaKhQ92uD3bIrEHQ1yWvaI3iFRDlbz5yOdgYxrrNMlS00gX2Uv2CEhwocBvycHGXHMSXO0IzYQklSd8UQquZSBcQhRI0mzp7bmtlZeM5hMuP8JrLe4VYSvYhV+zoaNSxYgqlyxcdRAgcbQsf1v0QVSsg8gCk56LRsWzawnd8LcVoWAT+aF69ltjnbJ1bh/FE5QqkWnNbB0Ys4oj8aKDk5JmeyeOi2XVsmmny5IXGByKfiLafu3oWvUd9w5KVBmgxGS+mA3pNC0yrLR5amwfW5l0jOzuTIaiVxkjY2GWMxYBIJwLCOlU6Syh4aAYxLAsb5sRZ63VGPoVJhzvhYnCGmxjXT6Xoif5SaXsyVVcKM6YEShY1mmhS0dStTdmrj7uANlTS7c+Vl904pIlCMFa6dvCDQhwAXV3J7LJia1Q4vtk4mVmsdNV8y+vC7QAOsNGUqVbYmDAh4W1F
X-Forefront-Antispam-Report: CIP:131.228.2.8;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0734.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(36840700001)(46966006)(356005)(70586007)(6916009)(81166007)(316002)(82310400003)(2906002)(36860700001)(86362001)(478600001)(70206006)(54906003)(83380400001)(26005)(8676002)(82740400003)(336012)(186003)(6666004)(2616005)(36756003)(1076003)(47076005)(4326008)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 15:59:30.9236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a4b88c-9d09-4c58-20c1-08d8e95da6a7
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.8];Helo=[fihe3nok0734.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB7462
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

While get_dma_channel() is protected against concurrent calls, there is a
race against kref_put() in mport_cdev_release():

CPU0                                        CPU1

get_dma_channel()
 kref_init(&priv->md->dma_ref);
 ...
mport_cdev_release_dma()
 kref_put(&md->dma_ref,
          mport_release_def_dma);
                                            get_dma_channel()
                                             if (priv->md->dma_chan) {
                                              ...
                                              kref_get(&priv->md->dma_ref);
  mport_release_def_dma()
   md->dma_chan = NULL;

which may appear like this:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 12057 at .../linux/include/linux/kref.h:46 rio_dma_transfer.isra.12+0x8e0/0xbe8 [rio_mport_cdev]
 ...
CPU: 1 PID: 12057 Comm: ... Tainted: G           O    4.9.109-... #1
Stack : ...

Call Trace:
[<ffffffff80140040>] show_stack+0x90/0xb0
[<ffffffff803eeeb8>] dump_stack+0x88/0xc0
[<ffffffff80159670>] __warn+0x108/0x120
[<ffffffffc0541df0>] rio_dma_transfer.isra.12+0x8e0/0xbe8 [rio_mport_cdev]
[<ffffffffc05426fc>] mport_cdev_ioctl+0x604/0x2988 [rio_mport_cdev]
[<ffffffff802881e8>] do_vfs_ioctl+0xb8/0x780
[<ffffffff80288938>] SyS_ioctl+0x88/0xc0
[<ffffffff80146ae8>] syscall_common+0x34/0x58
---[ end trace 78842d4915cfc502 ]---

Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 8155f59..a6276dc 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1980,6 +1980,7 @@ static void mport_cdev_release_dma(struct file *filp)
 			current->comm, task_pid_nr(current), wret);
 	}
 
+	mutex_lock(&priv->dma_lock);
 	if (priv->dmach != priv->md->dma_chan) {
 		rmcd_debug(EXIT, "Release DMA channel for filp=%p %s(%d)",
 			   filp, current->comm, task_pid_nr(current));
@@ -1990,6 +1991,7 @@ static void mport_cdev_release_dma(struct file *filp)
 	}
 
 	priv->dmach = NULL;
+	mutex_unlock(&priv->dma_lock);
 }
 #else
 #define mport_cdev_release_dma(priv) do {} while (0)
-- 
2.4.6

