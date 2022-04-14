Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4729C50047D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 04:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiDNC7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 22:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiDNC7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 22:59:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F83B2A242;
        Wed, 13 Apr 2022 19:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2CiVu58k5HgIKUJ0Hl0WakBKTiW0ECRcXI9Ez4B9EAHlMkF57p0/rodkd6s6PsctDAoWkSlglArPFEoa/XHYVp+AonT+2Uc+TQS7EEX1N6x2ZKxZCcZgJD2C6DkdDzre2bkNvqJ6Gnq7J3Jyl92oCT2bLJe/h8jdutEjn2Kwwz0kCiFMu8aPddUuFxteLHUq6Ba4Sgflw/avXaFXO4V6uAFeIp7lxzH2VdvZrVeaOwilJzZMXgEw+VT1Cu5gdmUEBzirVgKb0heIph+XyktAS/WZnG9InS6ffnZU8zeybxywvEgEQImSw2g5DadrXl7Wbx2SuFAR/qLsPA3R+P5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEwzrxNRbZg+1oZEatvMAJWFGSSaIp1QNnEFmaufk+M=;
 b=Hs1gm6FUvMsC4NvtSE7cznn0fucE1jRWd59z4GOp7a0GwmcvU4N0P5mHikmzSmV2+K/rBwkDS1tljGCMjFm9DqNS8HguRH91zwa9PkLER0x1D9b8iJANbmhfJ2GTDb6WUmEoI2dExOgmn88zPo7gxQxtNoWgn1ZepZDGX18VohCd02rgW6SMeuHQHz4OmnTmesw5XskmzQDFSSlFq4kzyO2PNK+qjfc5lChxWk/K5Ujci6D38LOOC2KWHipDtSb2OzBYu9w1ijbJ/y5CD63nGugYGRiUKmFiQe/vYYY38Z55JNEjM2t5LAjQ3AMKpiJ8OLMfUyB2MiLEl3ar8kr23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEwzrxNRbZg+1oZEatvMAJWFGSSaIp1QNnEFmaufk+M=;
 b=k5Vdda/QZJBsbZ/YycAzT/D+f3pOl4oM5t87VSdcQfKgLbLN9xxWn+dt1zpnSu0GWV7rkb8F90xZ1kUa5rGO12L9R4EAAgiRQYWL7KsNB/exA7TzBZNN5Hkndr72SRuYz9avOlC40faF1EpqQswDvp1qRw9KbDKDl1tFPaQzqg0=
Received: from BN1PR13CA0022.namprd13.prod.outlook.com (2603:10b6:408:e2::27)
 by DM5PR12MB1225.namprd12.prod.outlook.com (2603:10b6:3:7a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 02:57:22 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::10) by BN1PR13CA0022.outlook.office365.com
 (2603:10b6:408:e2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6 via Frontend
 Transport; Thu, 14 Apr 2022 02:57:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 02:57:21 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 21:57:21 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     <Basavaraj.Natikar@amd.com>, <Richard.Gong@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] gpio: Request interrupts after IRQ is initialized
Date:   Wed, 13 Apr 2022 21:57:05 -0500
Message-ID: <20220414025705.598-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9fede45-7311-4687-2a93-08da1dc27f26
X-MS-TrafficTypeDiagnostic: DM5PR12MB1225:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1225AD226CB1C51B58DE3A90E2EF9@DM5PR12MB1225.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqWm4xBcq007CZkKMAewFoIR/OTYXZtBxYBTT08TIcwEE+Nb0QLqSVVUAYZ4427LvPs++qLUh9Osd/C5k484uSityPyZ7CemlmBBFNiINoR5EkcIHIlya91uUBJ1SxT66ZxjYLDOFP0Wzrtt/RXIKX/4j9zqD9Of8/g8Kp0xC3FjTZwANxWiiPuZ70o0FYjU1m8OZd/9TVzmVvfi/D89KHhCTvIu+mTuUiVAJ8Seoe6T2pBLKZVaeIbJQ4XpIFnTRtCX3UTFtdPE9toFKKGmXQXNvAo7y05ca8TYHBu8VdVBtU/oGcoFajISnnxWVG29slVN5B9+gXy9ESS8orLyilZl/V5s0eZ8Es92tvRMkrV89gWp5f5rq60cPSaecPkhWqa7OXKU6LK4syMb318O7p95vHQX0JcFIXO7R1ZJNH/A8NzLkiYZXdK9H+6++8vt/++Cn4B/WGqr55GC5J/3T+mqEGOEPdfuZunHjk30nYw5PfcfFY07Qo5zXB+zGK23tlDH8TC35/BJbILRelU5OURmcZL7DEkr8pb9ZasiX3Asv4sZ5XYPMVMBXKnkjUqGFefM1inTN5u7q1vKXU0lqqRXWYIGEHvcMRIwSqDxiWv9SUHGdUYgOM//0fDpb+874bxXtvpqm0OLQaiOVXCmkFtr3PBqeV1KxplGG45ifXKsc6Cgt+A1aKDGUQawjjon3SQIxY00sLhJ1GnPL+EiwwzTw4M1vJIWOUDgFabH8kA86FsMZO769UcVz6q5LF833kqK5nNDATEQLy5EjagVA8sPqv2M0lsfmh9CXBHX/5w=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(966005)(508600001)(2906002)(316002)(356005)(5660300002)(1076003)(4326008)(8676002)(70586007)(70206006)(26005)(186003)(16526019)(81166007)(2616005)(47076005)(36756003)(6666004)(83380400001)(86362001)(8936002)(40460700003)(82310400005)(44832011)(110136005)(7696005)(54906003)(36860700001)(426003)(336012)(45080400002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 02:57:21.9790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fede45-7311-4687-2a93-08da1dc27f26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1225
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before
initialization") attempted to fix a race condition that lead to a NULL
pointer, but in the process caused a regression for _AEI/_EVT declared
GPIOs. This manifests in messages showing deferred probing while trying
to allocate IRQs like so:

[    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
[    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
[    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
[    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003E to IRQ, err -517
[    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003A to IRQ, err -517
[    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003B to IRQ, err -517
[    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0002 to IRQ, err -517
[    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0011 to IRQ, err -517
[    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0012 to IRQ, err -517
[    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0007 to IRQ, err -517

The code for walking _AEI doesn't handle deferred probing and so this leads
to non-functional GPIO interrupts.

Fix this issue by moving the call to `acpi_gpiochip_request_interrupts` to
occur after gc->irc.initialized is set.

Cc: Shreeya Patel <shreeya.patel@collabora.com>
Cc: stable@vger.kernel.org
Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 085348e08986..b7694171655c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	gpiochip_set_irq_hooks(gc);
 
-	acpi_gpiochip_request_interrupts(gc);
-
 	/*
 	 * Using barrier() here to prevent compiler from reordering
 	 * gc->irq.initialized before initialization of above
@@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	gc->irq.initialized = true;
 
+	acpi_gpiochip_request_interrupts(gc);
+
 	return 0;
 }
 
-- 
2.34.1

