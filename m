Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009196981E6
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 18:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjBORZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 12:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBORZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 12:25:44 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CD9298C9;
        Wed, 15 Feb 2023 09:25:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg6o5Gln4Y8LBFkb8aMwUQvls2zNsoqGL6dYet4nVABGEwK3Fl0c6xaPdWowSapSKJq/gMquJ1y/HPBYLYyzcfxqzu9fiHozaXBijPH4xN0Q5MvJ061SbR34RchgIsbyOgTH3/Mk5NtUvaWGnw6PFFA+2tmeXqlYoRkQKBsng0Hn2LX6hFAZol0M2n7nFuvcR88EIbrvHqktBB8VwFJIpKQQX9BtWKSWxrP6Bw1yzsb40EeN5Z0vCgqN89hdVlpq5TFqYpyeg+0IDZSC9A0zisdeU+4DM5dtQMCGX+xTWkahg1MZVFTWHZ+zjW0oM0j60ubaGB8fv94x5l8gcT62Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGdv21/+vENpJur3C0Ru+Ue2GazuIZiPJyMTgFIxUuQ=;
 b=AyGNy5QHAGj3IIZMef7vBxrx9fg8tqT/dXJ6l5+OH0JJ6oj/9tyDvlEMcovzP7g9zvwv6CgiDXC9tmc1FYz5vUPXgZGnaeTYNeSSp157RpLcraSsRJ8CPWnz+84vOFGQygoUfMsEtdHdX9TxBCjUHiVy+KPHo574TmAxqBq/gLC3Ioz9X3e1reqvRzDrgA4nWnuxbnh6lYmqD7HBNLQOUJzGQwmBS77AdX+394gmPAfJdhDIlUmL0Wy99NuVueo4X0H01sFGyZISF18OU4A8tXuoyUc2ZEs6gmDH7ygAqMWWfIvKGVcB9xfoWTlkUoQimZAEo8K5SkIgS7BKvhabRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGdv21/+vENpJur3C0Ru+Ue2GazuIZiPJyMTgFIxUuQ=;
 b=c53EKXE/cnlKMgk+Ctfw263JwPoPMUEIkoWGY8LDWWeDRvzN3WrcvcPR78BMFLwvvCGwvw5vbA3pQ4dK5eS8hzz3DbSGv11OsIGr9Qy4aHUBg3kKnD79gpfLda1DAoB0+Wc3Vx5zA0mVSRcuTXyR2c5mEslc+V5NtkCN1dLFO+s=
Received: from BN9PR03CA0079.namprd03.prod.outlook.com (2603:10b6:408:fc::24)
 by PH7PR12MB5854.namprd12.prod.outlook.com (2603:10b6:510:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 17:25:36 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::52) by BN9PR03CA0079.outlook.office365.com
 (2603:10b6:408:fc::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12 via Frontend
 Transport; Wed, 15 Feb 2023 17:25:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 17:25:35 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 11:25:35 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
CC:     <Sanju.Mehta@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] thunderbolt: Adjust how NVM reading works
Date:   Wed, 15 Feb 2023 11:25:19 -0600
Message-ID: <20230215172520.8925-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230215172520.8925-1-mario.limonciello@amd.com>
References: <20230215172520.8925-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT056:EE_|PH7PR12MB5854:EE_
X-MS-Office365-Filtering-Correlation-Id: c69039ac-b3fe-4c29-f071-08db0f79a653
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SR6b0MlmJLnXJDQhxd5m4vYERhHzV7h/0Uizr0/KL/K47YhfzioHjoU75kVg6XEKWbSbXv38m3s7uORJTyCluiSv2lLXANpPWNlTOH/+iavLDfbS2c4HEynaK3iXd0hdr+6DXZLvxYgxMbs0kzIcc8uf4CGvRNZrZ4BAzmDfKw9nAZ485P9PtnIGxi/x94XQ8DVguO8ULK8j0/IPG8rVvFeTTr4aBZd6wWqUGxT4Szj7458myDXWMX9E/bi4TYntCcFSucswAcwF+OD0P3LSB3XPBJFNsFGsg2INfvm26crPvE6xVOtNOlRUFRIxNZUyMxomvAjVegpxEiC1kp2f3PlapXs4TE86RmNToEJcFjsJsG0cU7yY4fTytPzaZgtEpbkX9BQCC3eILlJ3V/3ugTDqlmYwmuODDOgsu34Z9t+YEpa6BOoj+cgAo3FeFjfx2q1+Il3bEuvJe74Znc7b32Tf47aKbM4HNdnTwP17fyQPN1GbIkF3YZV5NadGGtceAngs+YSZx3LFq0PlAXEZLHynPXok6HzljG7D5IajgBf/+oAQq9eJE5w4ryZ9MIPB1HRM+orjNg5NELHfAKHTJ/6mQRAx+0NZesYWHI4unJ2pjD1kIrXVQAdggOu3lp+/soNROTQBGkafHISd1KbH9ZobncG+z0agBHbTOX01H7c95DkR7vVM7ecHN9FDBpEN1GSanQhc8d0WKUM/jOt2o302SSYjtqxqVg3AUT2h+Gk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(36840700001)(46966006)(40470700004)(47076005)(66574015)(41300700001)(4326008)(36860700001)(426003)(82740400003)(81166007)(356005)(40460700003)(86362001)(8676002)(40480700001)(110136005)(316002)(54906003)(7696005)(16526019)(70586007)(186003)(1076003)(70206006)(336012)(82310400005)(478600001)(2616005)(83380400001)(36756003)(2906002)(6666004)(26005)(5660300002)(8936002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:25:35.8566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c69039ac-b3fe-4c29-f071-08db0f79a653
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5854
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some TBT3 devices have a hard time reliably responding to bit banging
requests correctly when connected to AMD USB4 hosts running Linux.

These problems are not reported in any other CM supported on AMD platforms,
and comparing the Windows and Pre-OS implementations the Linux CM is the
only one that utilizes bit banging to access the DROM.
Other CM implementations access the DROM directly from the NVM instead of
bit banging.

Adjust the flow to use this method to fetch the NVM when the downstream
device is Thunderbolt 3 and only use bit banging to access TBT 2 or TBT 1
devices. As the flow is modified, also remove the retry sequence that was
introduced from commit f022ff7bf377 ("thunderbolt: Retry DROM read once
if parsing fails") as it will not be necessary if the NVM is fetched this
way.

Cc: stable@vger.kernel.org
Fixes: f022ff7bf377 ("thunderbolt: Retry DROM read once if parsing fails")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Update commit message to indicate which CMs are tested
 * Adjust flow to only fetch DROM from NVM on TBT3 and bit bang on TBT1/2
---
 drivers/thunderbolt/eeprom.c | 145 +++++++++++++++++++----------------
 1 file changed, 80 insertions(+), 65 deletions(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index c90d22f56d4e..d1be72b6afdb 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -416,7 +416,7 @@ static int tb_drom_parse_entries(struct tb_switch *sw, size_t header_size)
 		if (pos + 1 == drom_size || pos + entry->len > drom_size
 				|| !entry->len) {
 			tb_sw_warn(sw, "DROM buffer overrun\n");
-			return -EILSEQ;
+			return -EIO;
 		}
 
 		switch (entry->type) {
@@ -544,7 +544,37 @@ static int tb_drom_read_n(struct tb_switch *sw, u16 offset, u8 *val,
 	return tb_eeprom_read_n(sw, offset, val, count);
 }
 
-static int tb_drom_parse(struct tb_switch *sw)
+static int tb_drom_bit_bang(struct tb_switch *sw, u16 *size)
+{
+	int res;
+
+	res = tb_drom_read_n(sw, 14, (u8 *) size, 2);
+	if (res)
+		return res;
+	*size &= 0x3ff;
+	*size += TB_DROM_DATA_START;
+	tb_sw_dbg(sw, "reading drom (length: %#x)\n", *size);
+	if (*size < sizeof(struct tb_drom_header)) {
+		tb_sw_warn(sw, "drom too small, aborting\n");
+		return -EIO;
+	}
+
+	sw->drom = kzalloc(*size, GFP_KERNEL);
+	if (!sw->drom)
+		return -ENOMEM;
+
+	res = tb_drom_read_n(sw, 0, sw->drom, *size);
+	if (res)
+		goto err;
+
+	return 0;
+err:
+	kfree(sw->drom);
+	sw->drom = NULL;
+	return res;
+}
+
+static int tb_drom_parse_v1(struct tb_switch *sw)
 {
 	const struct tb_drom_header *header =
 		(const struct tb_drom_header *)sw->drom;
@@ -555,7 +585,7 @@ static int tb_drom_parse(struct tb_switch *sw)
 		tb_sw_warn(sw,
 			"DROM UID CRC8 mismatch (expected: %#x, got: %#x)\n",
 			header->uid_crc8, crc);
-		return -EILSEQ;
+		return -EIO;
 	}
 	if (!sw->uid)
 		sw->uid = header->uid;
@@ -589,6 +619,43 @@ static int usb4_drom_parse(struct tb_switch *sw)
 	return tb_drom_parse_entries(sw, USB4_DROM_HEADER_SIZE);
 }
 
+static int tb_drom_parse(struct tb_switch *sw, u16 *size)
+{
+	struct tb_drom_header *header = (void *) sw->drom;
+	int res;
+
+	if (header->data_len + TB_DROM_DATA_START != *size) {
+		tb_sw_warn(sw, "drom size mismatch\n");
+		goto err;
+	}
+
+	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
+
+	switch (header->device_rom_revision) {
+	case 3:
+		res = usb4_drom_parse(sw);
+		break;
+	default:
+		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
+			   header->device_rom_revision);
+		fallthrough;
+	case 1:
+		res = tb_drom_parse_v1(sw);
+		break;
+	}
+
+	if (res) {
+		tb_sw_warn(sw, "parsing DROM failed\n");
+		goto err;
+	}
+
+	return 0;
+err:
+	kfree(sw->drom);
+	sw->drom = NULL;
+	return -EIO;
+}
+
 /**
  * tb_drom_read() - Copy DROM to sw->drom and parse it
  * @sw: Router whose DROM to read and parse
@@ -602,8 +669,7 @@ static int usb4_drom_parse(struct tb_switch *sw)
 int tb_drom_read(struct tb_switch *sw)
 {
 	u16 size;
-	struct tb_drom_header *header;
-	int res, retries = 1;
+	int res;
 
 	if (sw->drom)
 		return 0;
@@ -614,11 +680,11 @@ int tb_drom_read(struct tb_switch *sw)
 		 * in a device property. Use it if available.
 		 */
 		if (tb_drom_copy_efi(sw, &size) == 0)
-			goto parse;
+			return tb_drom_parse(sw, &size);
 
 		/* Non-Apple hardware has the DROM as part of NVM */
 		if (tb_drom_copy_nvm(sw, &size) == 0)
-			goto parse;
+			return tb_drom_parse(sw, &size);
 
 		/*
 		 * USB4 hosts may support reading DROM through router
@@ -627,7 +693,7 @@ int tb_drom_read(struct tb_switch *sw)
 		if (tb_switch_is_usb4(sw)) {
 			usb4_switch_read_uid(sw, &sw->uid);
 			if (!usb4_copy_host_drom(sw, &size))
-				goto parse;
+				return tb_drom_parse(sw, &size);
 		} else {
 			/*
 			 * The root switch contains only a dummy drom
@@ -640,64 +706,13 @@ int tb_drom_read(struct tb_switch *sw)
 		return 0;
 	}
 
-	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
+	/* TBT3 devices have the DROM as part of NVM */
+	if (sw->generation < 3)
+		res = tb_drom_bit_bang(sw, &size);
+	else
+		res = tb_drom_copy_nvm(sw, &size);
 	if (res)
 		return res;
-	size &= 0x3ff;
-	size += TB_DROM_DATA_START;
-	tb_sw_dbg(sw, "reading drom (length: %#x)\n", size);
-	if (size < sizeof(*header)) {
-		tb_sw_warn(sw, "drom too small, aborting\n");
-		return -EIO;
-	}
-
-	sw->drom = kzalloc(size, GFP_KERNEL);
-	if (!sw->drom)
-		return -ENOMEM;
-read:
-	res = tb_drom_read_n(sw, 0, sw->drom, size);
-	if (res)
-		goto err;
-
-parse:
-	header = (void *) sw->drom;
-
-	if (header->data_len + TB_DROM_DATA_START != size) {
-		tb_sw_warn(sw, "drom size mismatch\n");
-		if (retries--) {
-			msleep(100);
-			goto read;
-		}
-		goto err;
-	}
 
-	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
-
-	switch (header->device_rom_revision) {
-	case 3:
-		res = usb4_drom_parse(sw);
-		break;
-	default:
-		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
-			   header->device_rom_revision);
-		fallthrough;
-	case 1:
-		res = tb_drom_parse(sw);
-		break;
-	}
-
-	/* If the DROM parsing fails, wait a moment and retry once */
-	if (res == -EILSEQ && retries--) {
-		tb_sw_warn(sw, "parsing DROM failed\n");
-		msleep(100);
-		goto read;
-	}
-
-	if (!res)
-		return 0;
-
-err:
-	kfree(sw->drom);
-	sw->drom = NULL;
-	return -EIO;
+	return tb_drom_parse(sw, &size);
 }
-- 
2.34.1

