Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0505EAB90
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiIZPsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiIZPr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:47:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFC111A07;
        Mon, 26 Sep 2022 07:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLOZHYrEJTQx68KiU3nEP9odOVNbJY2xeQ8p5RgbsMHmMn/U1yBF+ssJGDuCIcGInyiEG1LVHjjPDXYJ6I098TcBy8NiIghh4KOV52exdje9LDyK7jYlOvOSC89rMs55Mt+EfpJfy4Q8sluYyLKAXg5IUOzR6LYlQ6G3/YyLyZoznuxbahnun7KlhvO17w9vPNrWrsoe4Vx0hKfeTgOblR6BPYUwBzYBRS5CvYRT0s9ddz57ErMuS03yspLbzFKkg+ZX0p3isjpmKyB6DJ5qaAVjyjCKxCuvfQz5prZT6CjoH77DAw2uCwh2LoSuSGF4ErblWdFqnTlfZZfRsW8v+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxIu2VIM2syklhCbENPFSfAMW7jQK4u32lpiI8bWdKg=;
 b=hfbpA8KchsW3iwOsvOshb5t6Q3yVpAjd19pUidAWTtvHG58VRf1zrXeFNcCB5J7s60tRogaUbPcF2nL/VJkSfGR5GTPqFeS93qT+4wOBz6Wf+iuBgeCwTnA8VTfFOuUGaUT628oKgWwdVrTQaEhMbsBJ1w4NFBbfctXvDcwzf7j/Cx2gHFdc8XHn8hal/DCVhr0YC6VrKq0NEw0DAaOEI6Ud9udBDFqDmkNDwtJaYub9fWswhBM/Pep+epQSm+nQ4upizvW15xEAjk5eAMcczifii+kbKpSZV3RoqmhfI9MNBxpALrpNo2LLjv+mgTXwZuzAzaozVLLyR4llQD8OgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxIu2VIM2syklhCbENPFSfAMW7jQK4u32lpiI8bWdKg=;
 b=WXyjrMdifZ1FfCnbOLpklZekYshFMrm73RVQY6ZatFzugz3B2VAQ17cPWtR4HjB/oU7+3tNBGr8GwUMwxCfwMy+dsk69H6ZgcvfVA8ng7y4tYDM7mE3SkeADZjak/GRQ+OGXydbrR5NlM6b6NaLiH9ahO+UbpQ+Wz7DbTFhKOQQ=
Received: from BN8PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:60::25)
 by MN0PR12MB6247.namprd12.prod.outlook.com (2603:10b6:208:3c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 14:33:56 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::43) by BN8PR12CA0012.outlook.office365.com
 (2603:10b6:408:60::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 14:33:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 14:33:56 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 09:33:53 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
CC:     Mehta Sanju <Sanju.Mehta@amd.com>, <stable@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotplug events at startup
Date:   Mon, 26 Sep 2022 09:33:50 -0500
Message-ID: <20220926143351.11483-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|MN0PR12MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 575e0834-6349-4c2d-7baa-08da9fcc24bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJVmwsVJY6AVO47H52kkX/pXIWdUzMQr4ocOPk0IENu/RgiHnjjmDt9TyOVSRqD20gtTlw5CRNboNxcBwuHjOiRPMc33qIp9KN9QC/arBMweElKBr3jtVYugZWt0J9kmxIHLBMzLfh4khezuR8kb5o5nnjd5P938l/zYwS8wXmdDBn3V+XsTzMfVFc7T5YIV1LXMX/qGAxHzGEaBQxm3Eac3/naQuPbh0+qR4DFASZ4HFOcLo/xJOp6SHAFT5kF3BTCK7hNOTcOdF9LYjiTGuRtq/umRuppbCkyaMxjcvQEgfpMNU7x7l7dlAgHQKw6pxOSk6NGcg4UWQrtb9ojSIezKuQ2Jz/82G+EXpTQF0WTQbhcQrZQTAogT1Zh+ICGtLLwoH2uDMF+ukwUpV+pTzbjsdxHjjeOyy3KQv3F83G9mw918OUHtLLmyrYGecTYCtUTpPubardwXcNtiSijzjekNjXAS2bZ98CcEHU8ucCDh6VZX598UBhMlEtjZnmWsh/+V6Ugjw31BfxOZeUW/0/At7sfVg1xoMXGd7l7xY7Xk22C460y+uZKA1TAKYlJJK+C34ylv0Q/Q7AzIs0LJe+eySOdwcW+lMore6DAfTmRlxgpP8XquDmNA804MsoOwcdMR8sULhyyusffZGWNgRVO9fXRM148AiYLKte/L7w5oPvVXD0znNLz+xDqkPNjIvQbOx7RhgthmajUx/ge9tJdHxsVbDV+sXh21BJOTqDjFoeEXgeTQrZAz01Qus2XjgKZRhkDc1hHUDVSC/jKvP4+c6xWAu3syJEffR/81gdJ3w1YsmX0NEplLLzrqHq7U
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(2616005)(26005)(186003)(1076003)(47076005)(426003)(5660300002)(44832011)(8936002)(83380400001)(7696005)(86362001)(36756003)(36860700001)(40460700003)(54906003)(40480700001)(70206006)(70586007)(82310400005)(356005)(16526019)(336012)(81166007)(8676002)(316002)(478600001)(110136005)(41300700001)(4326008)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 14:33:56.4198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 575e0834-6349-4c2d-7baa-08da9fcc24bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Software that has run before the USB4 CM in Linux runs may have disabled
hotplug events for a given lane adapter.

Other CMs such as that one distributed with Windows 11 will enable hotplug
events. Do the same thing in the Linux CM which fixes hotplug events on
"AMD Pink Sardine".

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v3->v4:
 * Adjust calling location from a new static function.
v2->v3:
 * Guard with tb_switch_is_icm to avoid risk to Intel FW CM case
v1->v2:
 * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
 * Clarify intended users in documentation comment
 * Only call for lane adapters
 * Add stable tag

 drivers/thunderbolt/switch.c  | 24 ++++++++++++++++++++++++
 drivers/thunderbolt/tb.h      |  1 +
 drivers/thunderbolt/tb_regs.h |  1 +
 drivers/thunderbolt/usb4.c    | 20 ++++++++++++++++++++
 4 files changed, 46 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 77d7f07ca075..e7851c926538 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2822,6 +2822,26 @@ static void tb_switch_credits_init(struct tb_switch *sw)
 		tb_sw_info(sw, "failed to determine preferred buffer allocation, using defaults\n");
 }
 
+static int tb_switch_port_hotplug_enable(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	if (tb_switch_is_icm(sw))
+		return 0;
+
+	tb_switch_for_each_port(sw, port) {
+		int res;
+
+		if (!port->cap_usb4)
+			continue;
+
+		res = usb4_port_hotplug_enable(port);
+		if (res)
+			return res;
+	}
+	return 0;
+}
+
 /**
  * tb_switch_add() - Add a switch to the domain
  * @sw: Switch to add
@@ -2891,6 +2911,10 @@ int tb_switch_add(struct tb_switch *sw)
 			return ret;
 	}
 
+	ret = tb_switch_port_hotplug_enable(sw);
+	if (ret)
+		return ret;
+
 	ret = device_add(&sw->dev);
 	if (ret) {
 		dev_err(&sw->dev, "failed to add device: %d\n", ret);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 5db76de40cc1..332159f984fc 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1174,6 +1174,7 @@ int usb4_switch_add_ports(struct tb_switch *sw);
 void usb4_switch_remove_ports(struct tb_switch *sw);
 
 int usb4_port_unlock(struct tb_port *port);
+int usb4_port_hotplug_enable(struct tb_port *port);
 int usb4_port_configure(struct tb_port *port);
 void usb4_port_unconfigure(struct tb_port *port);
 int usb4_port_configure_xdomain(struct tb_port *port);
diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 166054110388..bbe38b2d9057 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -308,6 +308,7 @@ struct tb_regs_port_header {
 #define ADP_CS_5				0x05
 #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
 #define ADP_CS_5_LCA_SHIFT			22
+#define ADP_CS_5_DHP				BIT(31)
 
 /* TMU adapter registers */
 #define TMU_ADP_CS_3				0x03
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 3a2e7126db9d..f0b5a8f1ed3a 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1046,6 +1046,26 @@ int usb4_port_unlock(struct tb_port *port)
 	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
 }
 
+/**
+ * usb4_port_hotplug_enable() - Enables hotplug for a port
+ * @port: USB4 port to operate on
+ *
+ * Enables hot plug events on a given port. This is only intended
+ * to be used on lane, DP-IN, and DP-OUT adapters.
+ */
+int usb4_port_hotplug_enable(struct tb_port *port)
+{
+	int ret;
+	u32 val;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+	if (ret)
+		return ret;
+
+	val &= ~ADP_CS_5_DHP;
+	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+}
+
 static int usb4_port_set_configured(struct tb_port *port, bool configured)
 {
 	int ret;
-- 
2.34.1

