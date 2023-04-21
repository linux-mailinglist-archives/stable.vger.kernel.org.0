Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF406EA9FA
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjDUMGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjDUMGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:06:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC5AAF0B;
        Fri, 21 Apr 2023 05:06:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvZpzesNM8Dwq6XepkdWNmuQ32tlx4EN4on6kQHvLvCXmfoGqDLYeIQcFUGcCiId6XNXnWnqJLwHHbLdKv5YxG7Fj+u/Lvf0vZnV2UMs+mD8TawN995U5PRVr3buzFcldu9T1q0KOObDgCCtCcHgRVMt7IMiIhW1sHKtqlwT/YKv5/zY2sH0YZK5txDDzOjOASqX26SjLlhbWxLwmv07CchkTC05oZpnKIO/Svk4eXv1MwlkE8tS+AC+JefQrcM3Np7XFmGD1k8pnQdNE8OSCAeP5wbAUsIZ5RkqHGGp3lK0AUTcVJZ2+tvRN3mV330cWKGf+O4203rFb8P0pN5X5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSghTiE8e+IGcheBiDSlWQY8xUYxEi2/dKPPQDGBeS0=;
 b=ahRCI5BFmtp74+6Cz/ApVV7sd99FcEQcjz6zCNcKbtSgXZhfE1LGStgitA3gQKO45JsrUh5h+Tc9mIfxjPuuw5LUZZriCu6NyDk0DxSyAUjzfIGtXVqF+OviE7S70aSI4E1/gZNG5OFmpXExKPpANHkLnSkesJ2/HEi613KtPe7rcXblxkMity+5URNlAGX/hjad6HzeQJDPTQiE5y2rN9uY6Q+yvEQ7lw50ynkGwmvTdu8lejprpiY8x0o6bwSClWzBSvjdBRSqGERN9PG14uFZ2d1whBNPn5L04GyrG//hq+d1lEpFr8ah3dc7auitTuuMw76qnpKM+4nOuheR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSghTiE8e+IGcheBiDSlWQY8xUYxEi2/dKPPQDGBeS0=;
 b=BMnXyrnvebUFKSUkVbEg6zlF69u/oUHfwYYSmNuT5FjHW9Azv1OJvOHe8EYXbVvcaii/gEJb0KKZVyAqgsFZo7vaGL5mQqwrc4UUfUwK/6hW6sW1T10ckD7jkHxgGb1C+URXIIIHsEsRquMMaKoZL+UOFsBJ7uK9iXcBlwZkCiY=
Received: from MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34)
 by SJ2PR12MB7963.namprd12.prod.outlook.com (2603:10b6:a03:4c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 21 Apr
 2023 12:06:41 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::5c) by MW3PR05CA0029.outlook.office365.com
 (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.15 via Frontend
 Transport; Fri, 21 Apr 2023 12:06:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 12:06:40 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 07:06:38 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <linus.walleij@linaro.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
CC:     <nakato@nakato.io>, <korneld@chromium.org>, <richard.gong@amd.com>,
        "Mario Limonciello" <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] pinctrl: amd: Fix mistake in handling clearing pins at startup
Date:   Fri, 21 Apr 2023 07:06:22 -0500
Message-ID: <20230421120625.3366-3-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230421120625.3366-1-mario.limonciello@amd.com>
References: <20230421120625.3366-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|SJ2PR12MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: c3289306-9855-4543-f4e4-08db4260dde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /AxO49MNux8Tq10wmgb/JxVRFcmu3MhvQ9uOkD6Aom3ATMe07orxI/xQ4wPtZ1lqFC+u2ZA7sT4D6nrSvS6Olj3XOk8xHgTAHbXuLUhGWgU3I0PumOy3Fmb0n1vzIlSggzHP/WDYU8A3MHwOpY7mtLeF2ftOLiPatAuOZ9+JddUFHAQP1qB4+ePRj+GnjktS5t2x8PYDBuZv4VwCgTW5lI4jEXmVUTrmA2+vPTl3f1gIawbi3DR2m2aK0qWFNX3oXDKTTqrvcsJG7a66KDjR80MgElobStYZNDP7lIai/jPYraW/1dFs+ok2KmW0oKn236Z9Qk7/obC8YOOjNEFD//jEISB6/hv/QnwHZIQrmMrUmm2BpbtCqtnjgvBqIRr9UaFrJTNVtVF+Ze7NdsfrXqk+yl22YegQKsmL/xB9e4qcGpYYy4l+JcdBYTJl4RwbUvnWarvsbe3JQBpX+LVqc+Nt3kNqLHw7UgIXFesb399kGC6rcjTmH9OyW4G7ktt/Jl1K5Sl1gPowC/UkMtNHr6essByLQfp4QM2EOHYmGUjfOrg+aHumuLMN9ItxT3r1b98FpY/lGCVOVR/sWSyfSCrIEVTGjd6lIvebX+ji6a7a/kMougRn8JFpFJanv2c3xfk7/JPQDRKlOQbnmF57raCLqGYh6zFJKYCQD9uVPLTMAvHmyUrBiqrV8B9LrAM91A9Va+bXXXb80Djww5ccLfg4qFpPZYBdVG+s7HNXofQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(40470700004)(36840700001)(46966006)(86362001)(54906003)(110136005)(44832011)(6636002)(40460700003)(316002)(81166007)(41300700001)(478600001)(8936002)(5660300002)(70586007)(40480700001)(36756003)(426003)(8676002)(356005)(336012)(26005)(1076003)(16526019)(186003)(36860700001)(82740400003)(4326008)(83380400001)(70206006)(966005)(6666004)(2906002)(2616005)(7696005)(82310400005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 12:06:40.8583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3289306-9855-4543-f4e4-08db4260dde2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on probe")
had a mistake in loop iteration 63 that it would clear offset 0xFC instead
of 0x100.  Offset 0xFC is actually `WAKE_INT_MASTER_REG`.  This was
clearing bits 13 and 15 from the register which significantly changed the
expected handling for some platforms for GPIO0.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217315
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/pinctrl/pinctrl-amd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 6b9ae92017d4..24465010397b 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -897,9 +897,9 @@ static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
-		pin_reg = readl(gpio_dev->base + i * 4);
+		pin_reg = readl(gpio_dev->base + pin * 4);
 		pin_reg &= ~mask;
-		writel(pin_reg, gpio_dev->base + i * 4);
+		writel(pin_reg, gpio_dev->base + pin * 4);
 
 		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
-- 
2.34.1

