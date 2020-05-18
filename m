Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A2B1D73A8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 11:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgERJPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 05:15:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:34474 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgERJPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 05:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589793318; x=1621329318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AzuIogHzZYQvqN23TBsb403HWX2gEwjYaX7xsAYR0Y8=;
  b=pe/UcA4k5eGl1DdSo6yB2kmCZ5/7K0IVptFl09KGvcUymxVk8rh+ypdS
   RsBZbs84MYxu6PJL5Px0lrc7kH/RYRJLsSlHGc1fjVtZgEeTOV4CbRlHH
   B2lwYvMUVDN57G7DtrE32O9NtahxgRc9WLkHNRkVOmXS6Qkkxdoivi2gH
   tevdJcD1sezBYXmqNkRQ4wTn0nhiqU5NYfuXvxl1iq26unrt3L01L+YX7
   wZpyxdcKVu2yjXjuDUBIQDAO0RyzJL7nCXtAYZoMWryPT/GVxKrJ/EMI7
   blS2RuhTZi/Q4+VhVKwPlx9BgcAWt6NQAN8ZNCJRjhIRMDKiZUUvjzVka
   A==;
IronPort-SDR: 4q5FZKwOGvWBQMnajh8kfq+wbXtGbc8+okAtRgvrwOocg51LtnTAPsx/yKnkboPgmk/l/UF0f0
 1gg934MtkWc95OGsaH/xNf592Jw2OvarBPncexCAoOgX1BRhXpIpdsDZ4OV5a0Y0h8AG7OywPF
 Or9oQfWmCkokoSBOw+nj0uHjV9v9jKMAL1/iKyV6tZOrpvYmMrIBKhmiP7BJZvhumhSneDt+Sp
 wlpTWfmhD1A0zAdxScWPDpqkMLFyPCVXn8aGk/rZK3siQV/1iQI7rm+QXBgwYboI4DchL+a+ze
 ilA=
X-IronPort-AV: E=Sophos;i="5.73,406,1583164800"; 
   d="scan'208";a="246916598"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 17:15:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/lkny08xTsftgmJ15W/iNbQhkkBu9r74xyTmjIbEHQs8Cdl9WOgR+VdnzVS5drQRmK0IggKLdBcbzoKGrMbpro/1HRoFXpmFUzkKehmxM+D5jlE6tnqhtKZL5hJRQr6WdCHi63af/ihnxEe/dZ482znuYsnDXFbek5F74noLNAkn+CU9N1lr5LhD43htCmfMg2CZ3268t9hB6ma7bV6cyMOq3gnMbsZhonkOmU+adjQSvotKZqSAKiC/kAFDNRgy2hKCKMDpFMAMKwYt3qFJq/LiD5BVPwSz5d2JGjTxI8ZqfgIcrx6YtP2o5VCFiNYaPptTs56N44NGZke+UN9Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRrRMaOWFiYI9DDq3IcN9J4GqHHnNpZek9RYaNR/4Yw=;
 b=ggqrhDLOzoXuBItmaHQzMyfIePk666XqUhC3qH1LCzyjoiqWzrTa6mVWFFGI8aARLXW6HrydN9m81y3IeShnIT4XWA3GJSmw9taVAgVQexTd+/r0p2P4DXrvZdCO87mSAYFCnl1GYlpMgkOnnGDAEhHpiqWvNlusCyQjhrRBCni3TrRn1xU0BpYPjYSXbJgIYONYPvd+BdBDdFK0IFftCBFil7obNeMKfCytyKTsjSP9626cOP1Ja9/B0XnVi31bccRBTNK5bZrqyzL0zf11LZpK9AvGGTFYuZD11Aq9NJcOeIb81gSAyTgBo/5Wh2m2h2GFTyabUsjnOXCOIqgTwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRrRMaOWFiYI9DDq3IcN9J4GqHHnNpZek9RYaNR/4Yw=;
 b=ImAHvXytfVxixDvEREDFK+TZp8NdVjf1CMyr+4/a5O3Gyrd7mGfKt4orH1PX7yvZ7wEOlcwQkLB9O5ShOfMJDuF8Uj1Ih6Y74caPqMVPQGpbuklLAZEhJg5gB+kfy9e+4flbJ7aqbUW3QSCUBAT3FU3D7r3LKx6aFegXxIm+jJc=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4155.namprd04.prod.outlook.com (2603:10b6:5:a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Mon, 18 May
 2020 09:15:16 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 09:15:16 +0000
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
Subject: [PATCH v2 1/3] irqchip/sifive-plic: Set default irq affinity in plic_irqdomain_map()
Date:   Mon, 18 May 2020 14:44:39 +0530
Message-Id: <20200518091441.94843-2-anup.patel@wdc.com>
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
Received: from wdc.com (106.51.27.1) by MA1PR01CA0155.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 09:15:12 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.27.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e5d2f3b-48c4-4fae-ab21-08d7fb0bfa6a
X-MS-TrafficTypeDiagnostic: DM6PR04MB4155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB415555C5CA58D879D1BE9E998DB80@DM6PR04MB4155.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hqqb6oRFNkxTNjrAtI1HgLREv1kGeBs60SSex504367h9t+ZbbcZuWPqcUeswA4jOrCDMsSezR4H1IJp+2UE5+pgPTbfNPt9rwawuACWGuA1ghNAxiX+jhNuRUoDZjRJSLSoQTzApsd9hCp+1WFNfoqBPI4Gf4nAiv5GYgfxZVPlNOgtS3WBbICSnZw1M1ssgaJ0+uR1MiiKqTwFWPmBHmUAFx5aRVZ35L82XXgq8b1fqEHmfHePFl+50FbpaoqCrJbl7wZXB3yrsx/xIIAUjCTFqyIFEKoi+rJlXYJUn3KxQNcSlUA1dVoXkoa1T+1PhIkGPXI35bHvajwYh4l/YVhuXOgF6xmqmzNgyz1X7uxBSyeX9l1B62tSGquUx9Z39gHSy3jRBK/4CDN+RNm69hq8A9MLWJoBSvw6tAQwOA8bofRY6U6+lMh34TYTZJwO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(55236004)(26005)(36756003)(316002)(1006002)(2906002)(86362001)(478600001)(6666004)(110136005)(54906003)(8886007)(2616005)(44832011)(55016002)(956004)(1076003)(52116002)(7696005)(16526019)(66556008)(186003)(66946007)(4326008)(66476007)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GUSLyCvxRIUJRYon7Pz6xCHLtWzEvVdSZmARAIQYMEA23/oXbZlHuBe8dKOFAkMZ1VizRTq6fyDokUM/GGoUqJ7Q2fimRZzzWcTumdZSemq9P+XaXlHXpa+ktwNVrsk/GhtkbzLzH78g+MVNBh9lVAbaEFgvXbC4PLCnzHbQovOX2XmfSvXlZs5/jRZ7BpFOeFICfvzZO0KnlieWZCgHsxPWg4/gRawcmDTOiFCH8UwRaLeepMAq2YhrvKSH3/RGXMD5TFKuY3gyhxNKRC52oiwYTP7zGiWzi8DVW6Whj4/Bsj9d8SYJzq4N8E1ZrdEk4L6LEC5LnSY4x8NiTAyWy0ff3QmYyADkIgqrRxs72X9LqGQeJfrcqNVAUTG5+7W8DrVU+vxHw1zBK/VPxtcTSFzRA7YD0JrSHxmQ9OYfw/Nci3eb19QqGawJj7RTXhWTpbMMHrx1hHW1VhGs5uo3CWhRLaZR1QKM43f/c4rMoas=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5d2f3b-48c4-4fae-ab21-08d7fb0bfa6a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 09:15:16.5178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDa3eT6PUvQkvLLKFg1IJUfmAxKT2CEYJfYKTVUt+0kDClNWCtlkmaixwjSlVyDNeTLsPwlJH7EkmU/1es3clw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4155
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For multiple PLIC instances, each PLIC can only target a subset of
CPUs which is represented by "lmask" in the "struct plic_priv".

Currently, the default irq affinity for each PLIC interrupt is all
online CPUs which is illegal value for default irq affinity when we
have multiple PLIC instances. To fix this, we now set "lmask" as the
default irq affinity in for each interrupt in plic_irqdomain_map().

Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 drivers/irqchip/irq-sifive-plic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 822e074c0600..9f7f8ce88c00 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -176,9 +176,12 @@ static struct irq_chip plic_chip = {
 static int plic_irqdomain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hwirq)
 {
+	struct plic_priv *priv = d->host_data;
+
 	irq_domain_set_info(d, irq, hwirq, &plic_chip, d->host_data,
 			    handle_fasteoi_irq, NULL, NULL);
 	irq_set_noprobe(irq);
+	irq_set_affinity(irq, &priv->lmask);
 	return 0;
 }
 
-- 
2.25.1

