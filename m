Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204E46EA9F2
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjDUMGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjDUMGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:06:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E424C0E;
        Fri, 21 Apr 2023 05:06:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myUgFQI8Zsg6fwRqsPqvFrgzBcf7LU9gn+M/RACnp0mjMQgzcTOK6+ZY73hGo5u6bJOzd50KIOO0Qy1nIyFH6OkfSXv6uyxhTUfwztH3Gzn0tv4gEYG5PSkLQLf7K+S/CN3UJiDZkVdcPlYNBwYsSfkUDP8bncEWewnfphGGwVzAYeUionP9gngvWFLOTMdyTyk2ebhpCPNKQSq0vzhckAn4c4bGmnnbf/FtVMzAafIJ5sgxW6DcGcSnX9h6uR5dUMywAlkTvG+Qr6rImlQmAVl26LY67kyIMVbuBLd5WIspP4Ip8T/0FBd/Z7AcnMQObh75SQfMuem5arHbkkkSsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YhhrKRfm8Qm14pxFEeFtsPFmCjIErz7kop0TLDEapY=;
 b=TzyaVQo4bbtvBwssEf31fJGZnF+ztFHh6SSw75XnjsT9KFPlz8SbE69BrmaCpXdQ7nEQ5/w+lFTT1Xy3IA/g2Riom3cJw62RnAfYXk0BaRE74GwM4pQ2z3cIHQ0pKnEIFFjV172nQeK8/KA6w6eUbaQLMN/c1WM8Efy1kLqDE9zsxjEcJSTiN/c8FQpZ3LdgdYLhRvhi3KrqIDZIXQznl3y2gni6MaNz6YQAEN+67165UR8R9xsjKNiC4eIFGqyRczjqWWN74stPaWfFOQWpzPQAww2+t+RWd90S1YGJ7BarQuMiO7GXoLmSW34oWzh37iVNDM08+oXhbD6iLoK3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YhhrKRfm8Qm14pxFEeFtsPFmCjIErz7kop0TLDEapY=;
 b=KmeCMNSR+WQiBqrtRjcaq5ovHfZBz/8NhTBVbyigtfGJp1jtemy/ZF911GKlJk1+fLLhiY9FdV9f1lxN9mha4Ak44p3rzsm3LMQrEA6y5ZKNSKCx4LjFl+/yLnRZrGRiIHb+EHj+vCJVnleI2b2s0bsiG09SUquS0N5wCAFSALQ=
Received: from MW3PR05CA0025.namprd05.prod.outlook.com (2603:10b6:303:2b::30)
 by DS7PR12MB5717.namprd12.prod.outlook.com (2603:10b6:8:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 12:06:39 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::5c) by MW3PR05CA0025.outlook.office365.com
 (2603:10b6:303:2b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11 via Frontend
 Transport; Fri, 21 Apr 2023 12:06:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 12:06:38 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 07:06:37 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <linus.walleij@linaro.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
CC:     <nakato@nakato.io>, <korneld@chromium.org>, <richard.gong@amd.com>,
        "Mario Limonciello" <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] pinctrl: amd: Detect internal GPIO0 debounce handling
Date:   Fri, 21 Apr 2023 07:06:21 -0500
Message-ID: <20230421120625.3366-2-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|DS7PR12MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: dd49c4da-ae9e-4680-3091-08db4260dcb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XxI/LxDBUDw+SusDb9hkY5HdYmUuRGkyLIm4rkq/H98wec2ZKE2tpOE4xg8mgRYH43bPjwFpmdEJlph4Pe1aoGDh39B3sV1bx8Bw3BnEN9bxYrbc142ZYbcksZuYXbIszpeTN/AFSxwafQBZGXEsITpWhr3ctpQ1aCFf7q52EsRgD339KYotQ5mM+Iki4nehFJhXwftmP95A4zizZFDYhKixKHDOMDqXv3DKd0JAK2iDxx1DKoW1CMfpOO3HIYJsfmSBSkh/z0l8PovWQoHZmSg08k5pjNclsL46GOj8z4MCgFuKyXWVm8JTbi7USJQvIfJLK5DeWBzE9OUfRTx5gH8VAPauhYuWMy2aqXkYCvcHYDJlAqqWwmv7gRw/ZzqX2+FrLlmee6t/UsyR2um1jG5e61a3VBrvkrwvSJ8teGQgRfm30T2zr4UqdUX9qw2lqHZssIWgcIvmseH2HH2GWzCazomr9LEhRE2RcnuybRyHbIGlk8LW9a+dGntUgIuC2VgLv72IA6Ky+guG6xK2m5Z13ORNOLfLPtQDDyPEbdCuxJLTYD88ic6xvSupmlQDnZyq6JQ1F5PCI1ShBfBIMTv1icBJW93b4HBwlFUQgTLZhQHmw8ymCKHTuKHsa7yw6ynlbkbg6swLHvWC1uiTfVGMvbbgsAY7O6WCv9REfIwKyOFQfyEmi6WwlxmMLM5LsMRDg93WFE4LXanG2LZc0HnYc7YVIfUre2iolIMnXCs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199021)(40470700004)(36840700001)(46966006)(54906003)(6636002)(47076005)(83380400001)(478600001)(2616005)(36860700001)(40480700001)(7696005)(1076003)(26005)(966005)(6666004)(316002)(70586007)(70206006)(82740400003)(4326008)(110136005)(186003)(426003)(336012)(16526019)(81166007)(356005)(5660300002)(44832011)(40460700003)(8676002)(8936002)(2906002)(41300700001)(86362001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 12:06:38.8584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd49c4da-ae9e-4680-3091-08db4260dcb4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5717
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

commit b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
actually fixed this bug, but lead to regressions on Lenovo Z13 and some
other systems.  This is because there was no handling in the driver for bit
15 debounce behavior.

Quoting a public BKDG:
```
EnWinBlueBtn. Read-write. Reset: 0. 0=GPIO0 detect debounced power button;
Power button override is 4 seconds. 1=GPIO0 detect debounced power button
in S3/S5/S0i3, and detect "pressed less than 2 seconds" and "pressed 2~10
seconds" in S0; Power button override is 10 seconds
```

Cross referencing the same master register in Windows it's obvious that
Windows doesn't use debounce values in this configuration.  So align the
Linux driver to do this as well.  This fixes wake on lid when
WAKE_INT_MASTER_REG is properly programmed.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217315
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/pinctrl/pinctrl-amd.c | 7 +++++++
 drivers/pinctrl/pinctrl-amd.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index c250110f6775..6b9ae92017d4 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -125,6 +125,12 @@ static int amd_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+
+	/* Use special handling for Pin0 debounce */
+	pin_reg = readl(gpio_dev->base + WAKE_INT_MASTER_REG);
+	if (pin_reg & INTERNAL_GPIO0_DEBOUNCE)
+		debounce = 0;
+
 	pin_reg = readl(gpio_dev->base + offset * 4);
 
 	if (debounce) {
@@ -219,6 +225,7 @@ static void amd_gpio_dbg_show(struct seq_file *s, struct gpio_chip *gc)
 	char *debounce_enable;
 	char *wake_cntrlz;
 
+	seq_printf(s, "WAKE_INT_MASTER_REG: 0x%08x\n", readl(gpio_dev->base + WAKE_INT_MASTER_REG));
 	for (bank = 0; bank < gpio_dev->hwbank_num; bank++) {
 		unsigned int time = 0;
 		unsigned int unit = 0;
diff --git a/drivers/pinctrl/pinctrl-amd.h b/drivers/pinctrl/pinctrl-amd.h
index 81ae8319a1f0..1cf2d06bbd8c 100644
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -17,6 +17,7 @@
 #define AMD_GPIO_PINS_BANK3     32
 
 #define WAKE_INT_MASTER_REG 0xfc
+#define INTERNAL_GPIO0_DEBOUNCE (1 << 15)
 #define EOI_MASK (1 << 29)
 
 #define WAKE_INT_STATUS_REG0 0x2f8
-- 
2.34.1

