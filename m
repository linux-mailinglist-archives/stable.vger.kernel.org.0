Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02045B8F1F
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 21:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiINTE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 15:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiINTE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 15:04:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C165D4F18D;
        Wed, 14 Sep 2022 12:04:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3MZnhLLRsGB4PliA9EhfW8klQCw1PIzaLRdwWmkb/VrehfMBQJVQEEmmwtOz8LSm2e9GL0cPAKZqcBjpHykVIUYYZtYuhj9IoMzF3Y5bXyirIHjly0Lx7q6NVJYcMzMxSx0fHhHSirmMnpZeXMEOVCLQz1namQzm3oR2GGbbcOL9KRXIEwlW7TOBl3vTAwJ2kazGAk/9Aa+4rb52NmBjRKMYFzx3kKLOXZSH6pAarHa694KRLC6VCf9kmP3dKgYvMVTo/5J6uNdfr+kFcyYLghnUmE9PsaZGwxtKBLBUuP9WfWM+3ijZ8iFjJz+l5l9ypBFusMvP1NViKSELoq/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fh+MujYit8jljxBhR5IEO+DPua0el8ztAonqqE4gdjw=;
 b=EGVrFTGcgOetB3jH1Zv8t3JF01NI8x6khfGyI7eroa79GOH7Zy0R7xjaSKirsUObj9/SKDlX/CD74tMM1CnKbbkwGGvMrQB9UJ/BjsNCBbIN5ePG0xsPf/KtdhL6dgfLl0vNNaPKfCJFHtKu3a14ED4bIUrAL/rVpA+XoZl4q5+k+dwfLmjo6dMmnxPIVEFu7ZlBsq8JYeoAlwt+eNdov5RVfDhe9dEgHIU/MbY3F/fSfYbi8UE6bPUyfFEIioLDGpDD1qugGy4s5RbMLcmpIKTukuSybfsCFMD9/C8jm8AgXE+rpQH1VMUC+Ktya9G3CC8m7qRc4r5cFJVh3EGnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fh+MujYit8jljxBhR5IEO+DPua0el8ztAonqqE4gdjw=;
 b=bF4TmPRFZTQaJKPbizegqWTFOh5GbAUtSui/YBJibUrmeLZsyFk5gWSzwLHCr0Ek3ELfiPS9gNrSRrKuQ7TqtsMW1vDaUSKQp9dx7C1ZHPXbIJ+U1hkvFK+4GUKNzERQy7Og5iWpL8w9/lQpOAY1giPdbBKWMa8o2b5zomNOC54=
Received: from BN9PR03CA0609.namprd03.prod.outlook.com (2603:10b6:408:106::14)
 by CO6PR12MB5490.namprd12.prod.outlook.com (2603:10b6:303:13d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 19:04:52 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::98) by BN9PR03CA0609.outlook.office365.com
 (2603:10b6:408:106::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 19:04:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 19:04:51 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 14 Sep
 2022 14:04:45 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <iommu@lists.linux.dev>, <joro@8bytes.org>
CC:     <robin.murphy@arm.com>, <suravee.suthikulpanit@amd.com>,
        <vasant.hegde@amd.com>, Mike Day <michael.day@amd.com>,
        <linux-acpi@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options
Date:   Wed, 14 Sep 2022 14:03:30 -0500
Message-ID: <20220914190330.60779-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914190330.60779-1-kim.phillips@amd.com>
References: <20220914190330.60779-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|CO6PR12MB5490:EE_
X-MS-Office365-Filtering-Correlation-Id: bd04de79-a930-4bce-188c-08da968400a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2P8qxbvvycHpQ3UquQiOFukND0j8MCetNI0WwMsHXeLkmG3lMhQI2t97sQHGwMTB+xJ0IXXy7UzHe+Ck1ckGNs5omVrKL/Y01/Xwnti/KTcG42XRB+6OpVAxPh/eIYdKgpSq2uC0fUTVUvA0Pf3zxXgcAiEqcq6P19O4xVkKmJpH8epS7y+xkv32moUkQgBIfvpVT/Niv4BL4SyikoMeJwxCr8fk9B97aB3oRvxLbLcNoUyLstfub6ZB9yorvm9PXBYH65JYqvEOWKP90/Eg4U5Fc5wJ9LibPMCkIga/yg/8yL/NCI+dkcjsik8rqA3XPbnHDJOvTuSFiWtliNl3FKkIQTm3yAo3Si6LX8F6do0cLAaExqb1Rja2d8iacfOAoTZHJi9n8pT4xmlQCcGcoezFnu6n3Go0snmiFQZuTkLpX85nvb97EJWzOkGZ+3qtUT0/jbdrpHIf4QHR/FQm5lFYm+vsmwr44WZVb/yZTtp5ketIF4+LMp3frlzMLdLhhnBZRr4lzrmiJHid1PFZqeGCwdhKyVrUtnabD09um45T0qJxjMcgkaXzVKr6HSgEbm0KwGL2FSdKZd3lewajGrR93vIapHLp1PBHS/puaLAu9e+mp8TrQfTHrCw8YU3r7p+gBallBsLEvBDbIb0ub3Jiu0bbUXV7kIoCmPhwIB0AwPoshf6fTS9CpHevfaDB2HMV3v8iNw4SrNGowckdvx5be6maSJLZgbsqVzFJNWP6UXgrP1ndHNGHJGfUnobH0AEALmjj9lRWoR/3dFHrE1DgX/hbHKFRO/ZTnFWClki8SqW0SHECM+el8XAUF+PmVxXzmvnuEjJpTg7VYqUGw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(478600001)(82310400005)(356005)(82740400003)(36860700001)(7696005)(41300700001)(426003)(36756003)(26005)(44832011)(54906003)(70206006)(47076005)(110136005)(8676002)(8936002)(83380400001)(6666004)(4326008)(966005)(40460700003)(81166007)(1076003)(186003)(40480700001)(16526019)(2906002)(336012)(2616005)(86362001)(5660300002)(70586007)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 19:04:51.5347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd04de79-a930-4bce-188c-08da968400a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5490
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, these options cause the following libkmod error:

libkmod: ERROR ../libkmod/libkmod-config.c:489 kcmdline_parse_result: \
	Ignoring bad option on kernel command line while parsing module \
	name: 'ivrs_xxxx[XX:XX'

Fix by introducing a new parameter format for these options and
throw a warning for the deprecated format.

Users are still allowed to omit the PCI Segment if zero.

Adding a Link: to the reason why we're modding the syntax parsing
in the driver and not in libkmod.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-modules/20200310082308.14318-2-lucas.demarchi@intel.com/
Reported-by: Kim Phillips <kim.phillips@amd.com>
Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 .../admin-guide/kernel-parameters.txt         | 27 +++++--
 drivers/iommu/amd/init.c                      | 79 +++++++++++++------
 2 files changed, 76 insertions(+), 30 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d7f30902fda0..23666104ab9b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2294,7 +2294,13 @@
 			Provide an override to the IOAPIC-ID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
 			By default, PCI segment is 0, and can be omitted.
-			For example:
+
+			For example, to map IOAPIC-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_ioapic=10@0001:00:14.0
+
+			Deprecated formats:
 			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
 			  write the parameter as:
 				ivrs_ioapic[10]=00:14.0
@@ -2306,7 +2312,13 @@
 			Provide an override to the HPET-ID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
 			By default, PCI segment is 0, and can be omitted.
-			For example:
+
+			For example, to map HPET-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_ioapic=10@0001:00:14.0
+
+			Deprecated formats:
 			* To map HPET-ID decimal 0 to PCI device 00:14.0
 			  write the parameter as:
 				ivrs_hpet[0]=00:14.0
@@ -2317,15 +2329,20 @@
 	ivrs_acpihid	[HW,X86-64]
 			Provide an override to the ACPI-HID:UID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
 
 			For example, to map UART-HID:UID AMD0020:0 to
 			PCI segment 0x1 and PCI device ID 00:14.5,
 			write the parameter as:
-				ivrs_acpihid[0001:00:14.5]=AMD0020:0
+				ivrs_acpihid=AMD0020:0@0001:00:14.5
 
-			By default, PCI segment is 0, and can be omitted.
-			For example, PCI device 00:14.5 write the parameter as:
+			Deprecated formats:
+			* To map UART-HID:UID AMD0020:0 to PCI segment is 0,
+			  PCI device ID 00:14.5, write the parameter as:
 				ivrs_acpihid[00:14.5]=AMD0020:0
+			* To map UART-HID:UID AMD0020:0 to PCI segment 0x1 and
+			  PCI device ID 00:14.5, write the parameter as:
+				ivrs_acpihid[0001:00:14.5]=AMD0020:0
 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joydev/joystick.rst.
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index ef0e1a4b5a11..13c6b581549c 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3385,18 +3385,24 @@ static int __init parse_amd_iommu_options(char *str)
 static int __init parse_ivrs_ioapic(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	int ret, id, i;
+	int id, i;
 	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-	if (ret != 4) {
-		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_ioapic%s\n", str);
-			return 1;
-		}
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
+
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("Deprecated option : ivrs_ioapic%s\n", str);
+		pr_warn("Please see kernel parameters document and update the option.\n");
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_ioapic%s\n", str);
+	return 1;
+
+found:
 	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
 			str);
@@ -3417,18 +3423,24 @@ static int __init parse_ivrs_ioapic(char *str)
 static int __init parse_ivrs_hpet(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	int ret, id, i;
+	int id, i;
 	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-	if (ret != 4) {
-		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_hpet%s\n", str);
-			return 1;
-		}
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
+
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("Deprecated option : ivrs_hpet%s\n", str);
+		pr_warn("Please see kernel parameters document and update the option.\n");
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_hpet%s\n", str);
+	return 1;
+
+found:
 	if (early_hpet_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early HPET map overflow - ignoring ivrs_hpet%s\n",
 			str);
@@ -3449,19 +3461,36 @@ static int __init parse_ivrs_hpet(char *str)
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	char *hid, *uid, *p;
+	char *hid, *uid, *p, *addr;
 	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
-	int ret, i;
-
-	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
-	if (ret != 4) {
-		ret = sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
-			return 1;
+	int i;
+
+	addr = strchr(str, '@');
+	if (!addr) {
+		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
+		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
+			pr_warn("Deprecated option: ivrs_acpihid%s\n", str);
+			pr_warn("Please see kernel parameters document and update the option.\n");
+			goto found;
 		}
+		goto not_found;
 	}
 
+	/* We have the '@', make it the terminator to get just the acpiid */
+	*addr++ = 0;
+
+	if (sscanf(str, "=%s", acpiid) != 1)
+		goto not_found;
+
+	if (sscanf(addr, "%x:%x.%x", &bus, &dev, &fn) == 3 ||
+	    sscanf(addr, "%x:%x:%x.%x", &seg, &bus, &dev, &fn) == 4)
+		goto found;
+
+not_found:
+	pr_err("Invalid command line: ivrs_acpihid%s\n", str);
+	return 1;
+
+found:
 	p = acpiid;
 	hid = strsep(&p, ":");
 	uid = p;
-- 
2.34.1

