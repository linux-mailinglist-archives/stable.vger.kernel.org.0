Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B4F5E6814
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiIVQHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIVQHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:07:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8B9DCE9B;
        Thu, 22 Sep 2022 09:07:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cz9KEEnMSlmgWEFXFve9rqjqXsNjtwlPMHhe1uLACEng7FjOK2tNWOOo0i2OCrNTEq2OFj3mw6Kq0g1djP5cm2AilCjxIe4B90mkQ7WmTknFCJ/2rMt0u/2PbtbzhScOB7+4Ua2EiR9+9S9wcyJBAk9ofzUfWyb2RtL5blIhmG8YbCqeTf9EfNXqYmE1l4rtmCEl2gEUiXoyujbpFpu99kSWcQMsqdWGbh2hX4++h17vvsrFy8jbWGNKaUXnPvZ9RHDjqePBMCZ/mGaFV4gdbkN1x4WRCwH54OZbbYVq9dihLvBG12PIghgokEqMzGyHnE1HLDMjTfS6jhUmFx3c1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klRliMLEb28spxLVrJNh2jBaLNCJCWvRtCvU0dmulWM=;
 b=PPuB0NYj9NmUzzoZckDOQPTQ8Zwvqfid4BGVb8aRH/duGjQD6SW39AJbYeUQN4NGLBZ+d1o/MMHre6Kpi4UziX/nweTpz4TnjlVnUV4ag33nbsgzu5hMH5kpuiFtYl2AgQ1yFya7QO68QWrh4IZR7Wp7XNEXBr/Nybvr/qyMMcQuhUMW75RGUoBO/M95tYM2JTKek3q+NJBgPRGz1MaLVnKL1jJF4CtAH4mdANnYidYK0DKi6fGSnjktMaTVFhiPDRaiO/EjoyoEBIqSjWkZYW9HskJ+jC2EkApO49NdvN1703CeCwkggX1LL/cyc4Ku9esyzT56aRNxf6kpwRIXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klRliMLEb28spxLVrJNh2jBaLNCJCWvRtCvU0dmulWM=;
 b=whXwuEw5rYXKY4oSMusQOJn5lj1IA9F0NIO4wCWk179hZD3AMADzcL3Xp8kLdE1n3WGXVMVAZRGk3fJezD/cBAa1NDYwTxhK0BJ8BnE+bDJma0gbAl19swD8oXcs5PbsfbQTQ7/ZmZp8B2HJLNoViBSWGvLWigeeMZrBkUDa9ks=
Received: from DS7PR03CA0227.namprd03.prod.outlook.com (2603:10b6:5:3ba::22)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 16:07:41 +0000
Received: from DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::61) by DS7PR03CA0227.outlook.office365.com
 (2603:10b6:5:3ba::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17 via Frontend
 Transport; Thu, 22 Sep 2022 16:07:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT090.mail.protection.outlook.com (10.13.172.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Thu, 22 Sep 2022 16:07:41 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 22 Sep
 2022 11:07:40 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
CC:     Mehta Sanju <Sanju.Mehta@amd.com>, <stable@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] thunderbolt: Explicitly enable lane adapter hotplug events at startup
Date:   Thu, 22 Sep 2022 11:07:30 -0500
Message-ID: <20220922160730.898-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922160730.898-1-mario.limonciello@amd.com>
References: <20220922160730.898-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT090:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a51a5f3-d27d-4f86-1b6c-08da9cb493e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3t1jK9d9MR1ElEJ8Ivf3BkxzV7lysyG0Y4/Iy95hPeSM2BA7d1PcZgx6DvzyposeAyYURGmGvLYWyfX8H95G0xIUtgD+pUeS73y4mW1JXR+WUAtJ3VQIJz8IoqVD+ni47oNjo3qMTKg6cPCgqWUrpjMrVIu+jHYMDH1CkQ7R6CA6bO82b+x/j4gXrEH66Z0HpxZfdtYFGCnoAq8WH9K+hjiuH5r0BZS6/1tB06mtqypTLDGUHgDHnPaWe+Ec2fB7CKObfenB62UfRyvccvzKjf0sLfwIwCqL+2EaHRwV2wLLCkrpSkzgyssSElAyyqIjoDsCrnZ/kY0gfPhbcf5jZngzYmtzd0KK2eCV/KZ4n43e30INiw69HSYTRgG+Hcd197sbEvdROMvdp0tw34xyABXG/nUhMy1IgNzFUcoFw4IQwSK20BkfDM5axu+IC2dMWP5Zp16JjXC9iZGuSRlgZ2QTrEpasIEX6mljasblH5CbVxA6Fdk8f5iDJC+jycfr1EXO1m3MibjopJtlEyM/Lh5xM3uhx5lXTwEvJYIYu4rC9ynIXhHXXETltCxUSbG8TFy14AONvAiDDRTDBoSN/URtR6uYA0KpgMOzZjfDlSOIBYyOssx1NaeTeZQeQuxiBrJefUl90NQTkBq4Ysj/M87KuVFbS+xSNVaTclJWwpbiegX4Iu1n8CRpb1FF5TxKuzFXoEVg3gr9NX2K33zmlipHsZPyrT9DORIA9b0HQjD+seCKlg+Qlfu3Fzp78Wh+UcqYAl2WxOU7LaJJokp8Kh0rsJnaaPjPV/ugnLf1md3mw7NNWA331Ef6EuVdW/fh
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(478600001)(4326008)(7696005)(16526019)(316002)(336012)(54906003)(356005)(36756003)(70206006)(41300700001)(70586007)(6666004)(8676002)(40480700001)(110136005)(81166007)(40460700003)(26005)(8936002)(36860700001)(5660300002)(44832011)(2906002)(83380400001)(2616005)(82310400005)(186003)(1076003)(86362001)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 16:07:41.3980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a51a5f3-d27d-4f86-1b6c-08da9cb493e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496
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
v1->v2:
 * Only send second patch as first was merged already
 * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
 * Clarify intended users in documentation comment
 * Only call for lane adapters
 * Add stable tag

 drivers/thunderbolt/switch.c  |  4 ++++
 drivers/thunderbolt/tb.h      |  1 +
 drivers/thunderbolt/tb_regs.h |  1 +
 drivers/thunderbolt/usb4.c    | 20 ++++++++++++++++++++
 4 files changed, 26 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 77d7f07ca075..3213239d12c8 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -778,6 +778,10 @@ static int tb_init_port(struct tb_port *port)
 
 			if (!tb_port_read(port, &hop, TB_CFG_HOPS, 0, 2))
 				port->ctl_credits = hop.initial_credits;
+
+			res = usb4_port_hotplug_enable(port);
+			if (res)
+				return res;
 		}
 		if (!port->ctl_credits)
 			port->ctl_credits = 2;
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

