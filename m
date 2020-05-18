Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7463F1D73AA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 11:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgERJPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 05:15:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:59264 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgERJPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 05:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589793323; x=1621329323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=/ZuJKY4azgY3n7LFEktAFgx9RDH9a25XL/lQJFTymdI=;
  b=m/BoaR3EPW0qiQ+FyzYtLP5lnhlgKlC4qCgW/Uz/uq0cqXFoyrBcvYBY
   R1Yhm64crbR6qAZLDbQRXTBfnv/662ls2KY1UqyHplFEbFXMAxz2QkMdn
   mYM6dxoAWue6SM9iQ3NM4syixBPrV0ZDBEqP+U61XO+Vvv2IlWjaB3Gz1
   b4UJknwKvqFniboJEjPUIXKMpDPkcnHxaAgmRIofynr56EAcRUvjsF66v
   Jvx2kAuVS7tt8ZzRAoCO32K46fpTc2hMuDFh9ECBhmBZityjKp1IWawNA
   SDkAxzo++iAuqRrx2rcQ856j1ecIwzvxJ2RxGVecQdaSX+4uYw/rfEYXj
   A==;
IronPort-SDR: tFe6WFou2RQjujk+1Ay+vxcE9jVawDxmX3WhOf2db4zeWmLwx30oV7BpGKMr67Z++a1gYuyVzl
 d61AnRe0se2BnMmWJufL/mP0VhcdqSz9j+H7BdO/JOoor48aQKZRwgC8S47QazXMtfONZwGJly
 F1w8km4SKUwbrvqMJ6UE97yUZNiQoYWQwH1+Pl9BaqiyJ4YZPEgTrwZPsrC4N0mBJk683pYXt2
 7ET9P0qE3K6Qeh4sxlvKpYR7ZO9Q7uzAc/jaXj5qz1tLlkwNbOL/NUsFVokWMN6TSzB/EHOXjJ
 nsA=
X-IronPort-AV: E=Sophos;i="5.73,406,1583164800"; 
   d="scan'208";a="139365906"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 17:15:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGm+EORIiU2GlFeh2HUK7dlujEkYgqPZVWe4RY71k0gF2AaCphVFfCuVhBqN2Z/IrBm1caHE5xZg3V3AajAexh4SqbMoryd8ClB/G6a2fnxSw9EKgFjL3CSe6Djhh1n9xUFrPuwEfT/ISTdZpCH34IutVZemOj6ak+IssSooPXH6rj9HwdialGl8x2nWu3N6XwzXisGjHTBo0NKjZ0Z1m89/RG8tqa5SEgEJs8nWVt/X8EJ+6BK+t5lY+6WocgrHVyXhu1C2pMgGMvl1Yn8tWns+jsGb+3C05RtXDDvNS5Sq0jp0lktA2XZ3Now4iwCbaUmmgtv08ugHktuPXec+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I2/Huu+i61h9DGM9qP1HNzIl771nf9e4bRXdN+SlCk=;
 b=SIgty7xSAoXQhVVc4DGOQ8XcDGAblYC0nvyccI5/DadopvhBM+1DfI6VGRj4R4wduBGNQCSP49W3zDULYB9oOEx5zDJF0hgUjLcRTgE+YYLYFBSuPww/883pIz+Ke0kierIL1cZ1bBfXFH5lQxPnwPnmurb+LS5bVlhQUwO7vaqfkAMjOGUScf/HI8nNqDiZaskbOuUXMhCBqK5vdfkY7yydHATz3kemUNTL3jcpudrgMhNDgfoNgZhkufhXaO3YKN/uwnKbaobjU73H2Rgf0j5pxjHAUwf/6N3g78Y2VJgkhovgSEkcg+bTV84aJ3avACxxfq5YjjGJ21uXCtVIIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I2/Huu+i61h9DGM9qP1HNzIl771nf9e4bRXdN+SlCk=;
 b=zv4rt+1/8utm2HVmRmsicthf2wo/dZFHtO4Vs88AkER+BfHxko2pEixiC2vzDDznkxM1yVWRBPj+PmHakpZLp1a8GcUU15tkXrajR1JYQHOpWYQb0h/L7zy3ZMtSjvq1pGscw6LiOSeS5jVcMlIhH0sst9SKIXsPvbOLHttHUmo=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4155.namprd04.prod.outlook.com (2603:10b6:5:a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Mon, 18 May
 2020 09:15:20 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 09:15:20 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@wdc.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] irqchip/sifive-plic: Setup cpuhp once after boot CPU handler is present
Date:   Mon, 18 May 2020 14:44:40 +0530
Message-Id: <20200518091441.94843-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200518091441.94843-1-anup.patel@wdc.com>
References: <20200518091441.94843-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0155.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::25) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.27.1) by MA1PR01CA0155.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 09:15:16 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.27.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d018a8c0-1397-4ba6-7330-08d7fb0bfd04
X-MS-TrafficTypeDiagnostic: DM6PR04MB4155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4155FC2E333DF6962A0648118DB80@DM6PR04MB4155.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YA7yFZ6+Fft7DG+9vUMXX1TIE2x9sLiV+49Amu2w7L/k26LadLE/9zaZdeKMoc1lnrPL1Bbwt+UcjjDqQJzxBDzY1NIq+R4RV2rFiqyDKudPlJbZgSM/JheoY8NrkeJV+pE9oBEM9kCMvaMR6mWlpzdlA+wN46hGY4if3APZZModk982rq1NvxRfHXrL+RYwJIW6uImKlFiGtKbXLvg0CxQRYPqTxxy6JVk1/rP772MiQfdCA4AbZwaGIVZNsWTXbRym+PbvD4T9192QXtqpLwXImNxVcIvWspPEKHiBlNDj02ZH+S4y/XDCYu0vn2NTqWPjrb88dpEVHyDpx+KznPOnZom3KHVTfWjf2pFbPjWxrfslUFWXsVugNCw6TwARz/QwVJEqaLTWzGAGF4q9TP2z8Poh1HYT+krqPUQsWql7Di0YMBicImqgtl+6o02p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(55236004)(26005)(36756003)(316002)(1006002)(2906002)(86362001)(478600001)(6666004)(110136005)(54906003)(8886007)(2616005)(44832011)(55016002)(956004)(1076003)(52116002)(7696005)(16526019)(66556008)(186003)(66946007)(4326008)(66476007)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WW9oqxWgNXD9GyCHDd5yCZ4o9ToDfz1a6XCe3aQPXEOG4A0B39qIeHlU3oIlJG3UiYwv9vO4SoMSKfN6+wTWW9hLbhA3m8aKx9/8qhrpuwTiBU/r1v5zJeIfV0Qqeo4t68gso/fDiq03kM4j7EMJeBOilwD16LoCf72PFi5y/hQ5Yy9V0RJB6cUINZtHv0b8aYsHjHA0IG4YUh+/R3MdxC8bRYUutrd0fhhYvmYKuFoStvzAQKHsR96yhujNHj/ikFaRFRKuJcQHoFa63nFw992PXF7YtILfV4/g4h+ZuTHj63BcqGVoe3q7MIqGVkAzoyFNmq5PgZIXBVuzutUQb/dcfXQWwhEuQ176d4zfa9AqqZsYAwnEE6YXMPc/PR9CtEe6sdGrPoaPmG7oq1yAZhKTtO26CPiit8Mya7CxJvO2FCzJuFwk3LBiBTTrsUWK1olHwb58w5ovzDIQAO2h8aufwmVGfMuUWqGhYl7viSc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d018a8c0-1397-4ba6-7330-08d7fb0bfd04
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 09:15:20.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JKt9zhW7gqu4eF2HIvegT/l/tt1RsD35DkrOubvLBI8EXfAdx7f7ZYv8FvmWwMKyt+0nOv3hRMBn8txUCPVKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4155
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For multiple PLIC instances, the plic_init() is called once for each
PLIC instance. Due to this we have two issues:
1. cpuhp_setup_state() is called multiple times
2. plic_starting_cpu() can crash for boot CPU if cpuhp_setup_state()
   is called before boot CPU PLIC handler is available.

This patch fixes both above issues.

Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 drivers/irqchip/irq-sifive-plic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 9f7f8ce88c00..6c54abf5cc5e 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -76,6 +76,7 @@ struct plic_handler {
 	void __iomem		*enable_base;
 	struct plic_priv	*priv;
 };
+static bool plic_cpuhp_setup_done;
 static DEFINE_PER_CPU(struct plic_handler, plic_handlers);
 
 static inline void plic_toggle(struct plic_handler *handler,
@@ -285,6 +286,7 @@ static int __init plic_init(struct device_node *node,
 	int error = 0, nr_contexts, nr_handlers = 0, i;
 	u32 nr_irqs;
 	struct plic_priv *priv;
+	struct plic_handler *handler;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -313,7 +315,6 @@ static int __init plic_init(struct device_node *node,
 
 	for (i = 0; i < nr_contexts; i++) {
 		struct of_phandle_args parent;
-		struct plic_handler *handler;
 		irq_hw_number_t hwirq;
 		int cpu, hartid;
 
@@ -367,9 +368,18 @@ static int __init plic_init(struct device_node *node,
 		nr_handlers++;
 	}
 
-	cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
+	/*
+	 * We can have multiple PLIC instances so setup cpuhp state only
+	 * when context handler for current/boot CPU is present.
+	 */
+	handler = this_cpu_ptr(&plic_handlers);
+	if (handler->present && !plic_cpuhp_setup_done) {
+		cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
 				  "irqchip/sifive/plic:starting",
 				  plic_starting_cpu, plic_dying_cpu);
+		plic_cpuhp_setup_done = true;
+	}
+
 	pr_info("mapped %d interrupts with %d handlers for %d contexts.\n",
 		nr_irqs, nr_handlers, nr_contexts);
 	set_handle_irq(plic_handle_irq);
-- 
2.25.1

