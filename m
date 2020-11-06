Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9AA2A9772
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 15:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgKFOK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 09:10:27 -0500
Received: from mail-eopbgr140139.outbound.protection.outlook.com ([40.107.14.139]:20485
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726812AbgKFOK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 09:10:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6L1NPcBwh3YF36glbT4NEXD/xxXffRSPMdAeldgkQYiBNfVvKi2pCjQQX/DwnHcFFwS5/DQJFRMIvQoEZLsnSxCO1cmW/WiZD4XRVr20sE0GAviigz1+u44V9FXjepIde55ymN/5f85vsKIU3VDhBUtiUdxew0fUaTp4IXO5fK4OlVGuIWdNQkk/HIXUL9EX3VJhu+5m4Q25SbAAKZg616GylN2ddfxE2nFTQiS+HwLRqw5Y6epJ7zyFUFMKqJVh+fiX6GDrsnkDzlnX/9EjJo2oEXcJdfyHgURHGOLkMYeyeznHDbxPNpgrI7u3kq3eMNLGk48qau0UDVOt39ECQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+iONw1HG+Y6aPFExtXa7UY0+8xU2+GL7T43OqG4v9U=;
 b=IDu5U2hNGTcQUS0NDdh8tLrf4LJCVKaDGKDVFxrOP4ADXRJ9kNlTqaAT7fRyt0P/wUyQV5uvxEe1ZCb7DVc6WWEYlNIrzkIXIXb7ImnQPtmRGGWE38m1YdbRTCUEPOsuqVFqZhXutmA8AlD1okjOWmzN67fb1lTrjN3LU7h2joI4XjvQwE0aYDSrlqcYPRz0Bg8u9zAmKkJ5QQlGUaoYVYoEvYQBf7xR62Ot+HwbH1rKdWHKs5imM28uK6Jmg9QzLzUeG8d9WVCpRF6hdg7asdmvRY1VMlTTvZZWF7N4iAnCe/Pylq2nsbRpw0ku7jVi3sxC+G5gHsBIIlECcj5Z4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+iONw1HG+Y6aPFExtXa7UY0+8xU2+GL7T43OqG4v9U=;
 b=BkEq7gzMG83AoW2SdaZr6GSTeYhu7CD8gHO95SUDnSud+zhFo5D6mZ5TE68g0q8GGjGR6fMJ/jMs2y2D+vfutWaUBnFrd8JYFOYyK6cSB1ATpaE3DZT3kFPo+mA57NY+5k89gjv8G3jCtKQGTfRXgubj1HhKxbuJwPzP0rUuOGI=
Received: from AM4PR07CA0011.eurprd07.prod.outlook.com (2603:10a6:205:1::24)
 by DB6PR07MB3254.eurprd07.prod.outlook.com (2603:10a6:6:1d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10; Fri, 6 Nov
 2020 14:10:23 +0000
Received: from VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:205:1:cafe::a0) by AM4PR07CA0011.outlook.office365.com
 (2603:10a6:205:1::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend
 Transport; Fri, 6 Nov 2020 14:10:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.17)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.17; helo=fihe3nok0735.emea.nsn-net.net;
Received: from fihe3nok0735.emea.nsn-net.net (131.228.2.17) by
 VE1EUR03FT011.mail.protection.outlook.com (10.152.18.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.17 via Frontend Transport; Fri, 6 Nov 2020 14:10:22 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0735.emea.nsn-net.net (GMO) with ESMTP id 0A6EAGlV008549;
        Fri, 6 Nov 2020 14:10:17 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] MIPS: reserve the memblock right after the kernel
Date:   Fri,  6 Nov 2020 15:10:01 +0100
Message-Id: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ebf90ad9-1dfc-4735-5a73-08d8825db381
X-MS-TrafficTypeDiagnostic: DB6PR07MB3254:
X-Microsoft-Antispam-PRVS: <DB6PR07MB3254383D3C08A37EC9C9030388ED0@DB6PR07MB3254.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itHud0jNV1wS3vzNRp3DCVz7Vsry0H76ECShRWS+vwOdWUIXpnN8nX2F3h8SB9rLq/hc5qWKfdNLTyd4twT3iVYsbWCoD2LJPQMBr1IhxIfDI8xU3wmJ7qe6ptNXS3odic+Xi+mL7OhQWBhp9c9l9114iSMX25XfDnEEtb90JDXirj24vx5rT453Wo76QTl20puczOLh20x93N2AmYZdAK0ZLMLfMrZH4xXj+6v5Y5V1Jvg7sO3Ukxm0Wpe93zGmsQ0NHVFs1O5j+c0sfEDYivBM73+5yPp0f5IKia5JmDTa2kCJMn+gffO+/OyrDstzztltu/BL5TIzIEFH3EgEM56mfx9z44Wzk1at9pegmtkCc3MNiUlbq1IasqFtbl8aUg/HQmRjUjIxM9oZ7EweLg==
X-Forefront-Antispam-Report: CIP:131.228.2.17;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0735.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966005)(81166007)(8936002)(356005)(4326008)(47076004)(2906002)(8676002)(82740400003)(6666004)(86362001)(83380400001)(5660300002)(36756003)(110136005)(70586007)(70206006)(336012)(2616005)(316002)(26005)(186003)(478600001)(54906003)(82310400003)(1076003);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 14:10:22.6644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf90ad9-1dfc-4735-5a73-08d8825db381
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.17];Helo=[fihe3nok0735.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR07MB3254
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Linux doesn't own the memory immediately after the kernel image. On Octeon
bootloader places a shared structure right close after the kernel _end,
refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.

If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
memory block overlapping with the above octeon_bootinfo structure, which
is being overwritten afterwards.

Cc: stable@vger.kernel.org
Fixes: a94e4f24ec83 ("MIPS: init: Drop boot_mem_map")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 arch/mips/kernel/setup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 0d42532..f6cf2f6 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -504,6 +504,12 @@ static void __init check_kernel_sections_mem(void)
 	if (!memblock_is_region_memory(start, size)) {
 		pr_info("Kernel sections are not in the memory maps\n");
 		memblock_add(start, size);
+		/*
+		 * Octeon bootloader places shared data structure right after
+		 * the kernel => make sure it will not be corrupted.
+		 */
+		memblock_reserve(__pa_symbol(&_end),
+				 start + size - __pa_symbol(&_end));
 	}
 }
 
-- 
2.10.2

