Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25610394501
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 17:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhE1P21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 11:28:27 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:60448
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232852AbhE1P21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 11:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ihddh3QCYhvdgAW1iz0MpfcHo+8Ji5ROR0+SKDtcPLa5lrG9YT3Kg5V5t2zitbaPm9BENykZkFv1POfBqAMZBhJg6r6VwzGHuHQkDEQ62wv8AkWcgcrmUhMTsLGWbtNk70s/YqNqISAPnPaL/TQuRvLL8uQP1I2PIYd/ib359CGZBixsmKxOWtcqqwTtlCbMM85sQ5MPLNQizuwS2K7jybqdQpLVqvE/ulQd3anOebbm583+YXm+FnFRtDo6ru029KvJpawI/DSF8CA5bvnBmJcYijoafGlVX0cMs1OdTghyhnCI724RNTtAnmSOiX8PxZdnAFYIaQgDBI7dAo9wmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuuMdwvMdEUOVJ1WWLwTZEux0cuDa5D5+JvFOaCvaSw=;
 b=lUSeiXFYBzj37W782nLJ7TdAh12dxXyYmOEi9tV7rpFbHuy0wi3GMMZZc6fhGKuxMxY1iWKTSCT1t9MiJW3hcltIXUDXOa6QfoyQJ9oxNV6TKZi2/jTngDP00LDbHSy9VqgnGsutuHsYByZVZatoNA+yM6u6L9bXSs4CbZKQRbKyYjhqHFkE4EaYNJkvWMn6xCQbCxyIxDmJJduk4N1s8ilvTdq1afk3jJIpCV5nki5NMH/bzUFcAo+jPOQU9fa9+3mBwogBwaLQn9EN5hBzumdwQ0U3R9JBE5BYyp9Fu11g17TrS7tPJW+YSLLnPpH7ib3y0a9jtS7uHz9fGz/G0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuuMdwvMdEUOVJ1WWLwTZEux0cuDa5D5+JvFOaCvaSw=;
 b=OUhfkb5eaCjZKKjn2Oq0UPG/sjzXUPyvv0Y9EstubKkPUrNnCbnX35ubmfPlvHCbdz10R/BoPqHo8w3xK2M4ThQYuNH+mqYzcNxEFMudjTcC+yW6WjAmh+/XW+kvNfSY84ryMKLZ3IpxJePgVlkyeN0zV1YacstWoue0c0s1eus=
Received: from BN9PR03CA0904.namprd03.prod.outlook.com (2603:10b6:408:107::9)
 by CY4PR10MB1733.namprd10.prod.outlook.com (2603:10b6:910:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 15:26:51 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::24) by BN9PR03CA0904.outlook.office365.com
 (2603:10b6:408:107::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Fri, 28 May 2021 15:26:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 15:26:50 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 08:26:49 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 08:26:49 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 28 May 2021 08:26:49 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id CE1342A973D3;
        Fri, 28 May 2021 17:26:48 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id CA0CC20003CA; Fri, 28 May 2021 17:26:48 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-bluetooth@vger.kernel.org>, <stable@vger.kernel.org>
CC:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Subject: [PATCH 1/2] Bluetooth: btrtl: rename USB fw for RTL8761
Date:   Fri, 28 May 2021 17:26:44 +0200
Message-ID: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2021 15:26:49.0718 (UTC) FILETIME=[E0E85160:01D753D5]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01a1abc4-0f33-43b4-3c70-08d921ed03f0
X-MS-TrafficTypeDiagnostic: CY4PR10MB1733:
X-Microsoft-Antispam-PRVS: <CY4PR10MB17330037F54335004844D9C2F4229@CY4PR10MB1733.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9WW5fawtp+VXllzQ0Znf+mvbCaZTrzlwusNPLipCusIKXhzFW7u7X1iGXmbWT5P3fADF0FCSDbyxhTjEq9xZaG1OaZY+zEigE7zUfpDNyjLbx4WL0+BLYOYza+iGbKjFo5bBm1YvSRt/1MJCBYOR82PDjEr9b/Hcc/WPcKzKGb/igmcQsNoK7Ho6yhSDx4X0JQNGX8b0AZWffCVVx7KueaQMSHJgrPLNh1j2cTtIroXZaOdO5js6HBqu6asVseI3FevsjEToq4CUi/ZOMsLCZ+KD7ZgOoiFuI5D9FjDbKtYC+QzAXd2ERRw1prhWuhKJWSDOgkopV15qfjgMT+nY+O0we9Rddj1Ea1zHqoh/GcCLxjNdV0nmePL71/KkkxkG/mfpzXR4Y16XSYtNPo4Uh3rtOWUR2eZuH37tyQkUp3dwxuY2EGPZ3RCLIBNSR5rxw2qIwQJePrDu2tKz8SLExYphdvo3mNiG1brrJIeDgS/Ca8jeTCNCuZbrpjJgv/I3ZpivmOuLs+Asi19gNaLwlSPESTiSztloJtXltk4Vvlqe747x90Tu5Jt5fudYTnEXqi0xGZrkbyUP9b1qTJsST4WkH4P63TUO+Ke64RSv7KiHFgdFnahnYZW3DwaRaYjmACMs8gsSowEsNlpdkASLHNAxNhxDCPUIk6gGaQE0XBT7KKKbsgVnBTA6po0QOpZw
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(136003)(376002)(36840700001)(46966006)(36756003)(82310400003)(5660300002)(316002)(42186006)(107886003)(36906005)(83380400001)(2616005)(6266002)(478600001)(81166007)(426003)(336012)(186003)(70586007)(8676002)(82740400003)(450100002)(70206006)(110136005)(4326008)(26005)(8936002)(2906002)(44832011)(36860700001)(1076003)(6666004)(356005)(47076005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 15:26:50.5068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a1abc4-0f33-43b4-3c70-08d921ed03f0
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1733
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>

According Realteks own BT drivers firmware RTL8761B is for UART
and RTL8761BU is for USB.

Change existing 8761B to UART and add an 8761BU entry for USB

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
---
 drivers/bluetooth/btrtl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index e7fe5fb22753..ccef8b2cfee2 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -132,12 +132,19 @@ static const struct id_table ic_id_table[] = {
 	  .cfg_name = "rtl_bt/rtl8761a_config" },
 
 	/* 8761B */
-	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
+	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_UART),
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .fw_name  = "rtl_bt/rtl8761b_fw.bin",
 	  .cfg_name = "rtl_bt/rtl8761b_config" },
 
+	/* 8761BU */
+	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
+	  .config_needed = false,
+	  .has_rom_version = true,
+	  .fw_name  = "rtl_bt/rtl8761bu_fw.bin",
+	  .cfg_name = "rtl_bt/rtl8761bu_config" },
+
 	/* 8822C with UART interface */
 	{ IC_INFO(RTL_ROM_LMP_8822B, 0xc, 0xa, HCI_UART),
 	  .config_needed = true,
-- 
2.31.1

