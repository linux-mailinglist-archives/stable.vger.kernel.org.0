Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DD95E6812
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiIVQHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIVQHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:07:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A05DCCDB;
        Thu, 22 Sep 2022 09:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SK4JwZJRPBJaze73ilxWTJGvSkYrBgoKK/AtFTBSKob1jkeVDwnhby36ZtfsxOe7qFA8o50yqS40VNoG0BAQWKoRbI+gYQng6ySipPXPG0D9sBvE7j7k4T8RZSyGAkDZjqRCUknMMJzDmvQPddDuoZMP7PEmg1qyz5tBGN4yIuMCaLVbQRg9UMiTMnLlTbgfXPKwBlfQIVnJPJ32h2972IGtKiL53w3UseUi9ahH2NCEUjHx2ELkS2jc4F3SlMG9lT9xvQCIgip+M1vO9sUOxLE9SVYc5KWPtj5I/8Hd94rsU32ZTryYHDO1cRSvkUo+NbjXrLYp6Dkt2P49egquDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klRliMLEb28spxLVrJNh2jBaLNCJCWvRtCvU0dmulWM=;
 b=SfLehKuZdPF5yxWw6JF3rjFHj6Bce0Dt36p62zBTwY/38Ck9wl3tIYYrH9RJm+o04vGqqlOL9gFUPmg0H2kmA8MnEIBTepi8NkiqQ7fvWdCnQnfYwXYvdDRvhfO6hGPiChrDMEfeeU4f+ERoXGtBcpS36Z9wuh15ENPyl2NJ347VKokQ6kctsKMcf9dJHayU3ATsRRnSlW4OzehbUlwb2HjDZUZFIwBK/uSVw3WFYU/VE11hc0ZzNm8y4rRI462bOUwnWF7WXVb+Pn2nVh/5MokfXdoOJS1WnsAxmQKDg/ozXqongFL3XqsrVDrvpXAyQPcah/rtokwG25Pisy4J7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klRliMLEb28spxLVrJNh2jBaLNCJCWvRtCvU0dmulWM=;
 b=zQKQH4OJq7d8XTXsJmZkNqdf5G5s8qlltBdRMQtBuWoXPdQUKuuOFmvejcaM0eR+F9hxVMKL1UkRENv1Wki+D70OSaoE2CASphFJFpeo9qaAe1wlEO+PCOl75SVUoAAwzLQEcx5k5oMlV6VIo9T0JpEYNnmSQyJ7/7rco2QEerM=
Received: from DS7P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::33) by
 DM4PR12MB6160.namprd12.prod.outlook.com (2603:10b6:8:a7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Thu, 22 Sep 2022 16:07:40 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::b3) by DS7P222CA0018.outlook.office365.com
 (2603:10b6:8:2e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17 via Frontend
 Transport; Thu, 22 Sep 2022 16:07:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Thu, 22 Sep 2022 16:07:40 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 22 Sep
 2022 11:07:38 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
CC:     Mehta Sanju <Sanju.Mehta@amd.com>, <stable@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] thunderbolt: Explicitly enable lane adapter hotplug events at startup
Date:   Thu, 22 Sep 2022 11:07:29 -0500
Message-ID: <20220922160730.898-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT040:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: d20ffd9b-c083-4d4d-1428-08da9cb49316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9Cnn+3jyMaEZFNsLv+HfF68q1JzUQ1KxggFK+6vXziAMRnE/mIbZnrk924fUjZ87srJJzTIjfnjU/OyQ0dbGqIja+ukic2FUIFoYIVpj1AIUsSd2xvMypW2bXmPV7yESeDnr/IGJGa0icqRMYwl9V2DkMfSg2mR16buqs+By5XR0Ik3BX6bCjsRyq85jpPCsN1IoMFY9DupFU/yB1IlPqI7kDK6rVijquRUECQWMD+XVsz5a8gB2tWcTijj2fFzCCsBIV2A4I3D6vdVs/whU1FMnx7RYQAbTYZ9+1YLBbM6jR88xCMh4oMhRs+TfFEp4cC7j9qHTPalLhNFGg3odJ0IGvRBsY54BBOedF4isVUH6gSzMh4y5PdChK3etLMa6mzowkmHbsC42wcbbDNsy8RB7/dSBwDpj5mOkAHA1ssiDDNlTvaQ19wPFPQNZ+Ly9icbjFebuy8GnB2GJeCHGRkmfxZCdjWOOZK8xzrplLyOwdfcnocKgvy5r4T1Eh8lgebpogrfSlJigke07a2izVDysaBmc/8NXNr/IeA7cv7NSH3tJCb9iJ8Lje3WS/U60zEvV8vtxqMjmMzOzFevuY8OSn32UXk2ouQ/l0C8mfYn3Nd/hd/y6wi+INbXVY9kJnf2X8taNiLPSefsLMmtZsNOJTjBlLJJSE4+fmMzNZ2+2Yoa2bYbKq3Mn3P8+ZTSXh5eeF3jt3hbsAz4egYcjQyq8i6ha5qZEJLEyEjd6zF1BDcJDV1yx4WPyj7b2AUctZUNiKzDc9za8Ve/undeYRezaQ+7voGhN2nqV+mmL3i6NPFeaYr0pqWTXyOyGl8r
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(54906003)(316002)(110136005)(70586007)(478600001)(70206006)(5660300002)(41300700001)(6666004)(82740400003)(26005)(8936002)(336012)(2906002)(47076005)(426003)(2616005)(16526019)(36756003)(4326008)(7696005)(8676002)(1076003)(186003)(44832011)(83380400001)(36860700001)(81166007)(40460700003)(86362001)(40480700001)(356005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 16:07:40.0996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d20ffd9b-c083-4d4d-1428-08da9cb49316
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160
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

