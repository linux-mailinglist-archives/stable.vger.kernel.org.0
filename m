Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75BBEC0830
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfI0PAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 11:00:54 -0400
Received: from mail-eopbgr130133.outbound.protection.outlook.com ([40.107.13.133]:26241
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727747AbfI0PAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 11:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw+LL5XcPl2HuHMrrzHGNR49TUEQq/4hnIp7YULUFpXhh6PNGK/6v3ZBz966Ynyj2yxvyLBwbbeZRJqgqiL5I+MsBPI6P+eUmHFuxvyN3yfGJltgVgeJtRtRi0dR/9LDObEDQmGQfShHEXTEUCJdFxuHvT2dkgouSRgjfIsjurRe+WfcejVwsbq57XWJqRU61jARnIl9S5UHm4o7J1i6FtqQ44r+FyoH4SWRmMcUZMvkO8zL/Ah0jexuhcUZX0O2EUAeMQAzL9rv54oCWoVJ5pEFR36uqPh6s2hNjHbWI1e03kEwKlDhzC3F7NoqNcA0hdsubdFT3s9shkcBUsA4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3kXpqDt/wo+MslpgXcOplOcgRRdN/Ynz2UJ8BQEBnE=;
 b=lu+f1R+VPSiAh3FiwDReS8fBNv+zi0jVaX5BHNnPKUXDe7oI7CcNjwXh3OZjrURBOJ17OQtn/0JlNvINgbItK3aqMGEQxYmp3zadyRsIMeW9Er5M0cqtoeIszrnra2C05j6mq+L7ioh3erczlw++hNJPiOj/f7kEIjLLzw7u9DhiLREF3OW+cMY5CXfB8dVi4CAaUnFjbJ0O5kITyP+tg5xyWj46Mu5HKdMkpU04+NLHLeab9R+kVVaSQROuQ+3kGfe0zZQk8Uh4y9pWdzZxXwmRNYqTo5625LaGxWjtFCy5z/ZYPRVUIHQVpTa0HU6wwFyClvMNbdBFpMFofXtdSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3kXpqDt/wo+MslpgXcOplOcgRRdN/Ynz2UJ8BQEBnE=;
 b=Pd5XiKj+NiFzVNdlE1qB1bD+Q3JitZtjAkU80HJRj/TDdJeai/RB0DBFwi7WpaoNmT6I4J2IQ5p9MlOz81ah/CscAyquWjCNuM3HAzku8gcghmeE9B58TNBKt3dWztslYUIppzthUxKEna8G1dT0Egzo3rK80ccZu2VIf2R0m7I=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3749.eurprd07.prod.outlook.com (52.133.19.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Fri, 27 Sep 2019 15:00:46 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::7497:742a:1167:30dc]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::7497:742a:1167:30dc%6]) with mapi id 15.20.2305.013; Fri, 27 Sep 2019
 15:00:46 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Mark Brown <broonie@kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
Thread-Topic: [PATCH v2 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
Thread-Index: AQHVdURXJWeZZLV7kE6zFiFPjGtWMg==
Date:   Fri, 27 Sep 2019 15:00:45 +0000
Message-ID: <20190927150025.26481-4-alexander.sverdlin@nokia.com>
References: <20190927150025.26481-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20190927150025.26481-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.181]
x-mailer: git-send-email 2.23.0
x-clientproxiedby: HE1PR0102CA0006.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::19) To AM6PR0702MB3527.eurprd07.prod.outlook.com
 (2603:10a6:209:11::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e6ea24c-0704-4daf-138d-08d7435b79a8
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM6PR0702MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB374920D0A6B06E2F10B0E92688810@AM6PR0702MB3749.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(199004)(189003)(2616005)(2906002)(6436002)(71190400001)(446003)(71200400001)(50226002)(7736002)(6512007)(4326008)(14454004)(478600001)(52116002)(6486002)(25786009)(76176011)(305945005)(66066001)(102836004)(3846002)(386003)(81156014)(256004)(6116002)(14444005)(186003)(486006)(8936002)(86362001)(8676002)(99286004)(316002)(81166006)(66556008)(5660300002)(66946007)(6506007)(1076003)(66476007)(36756003)(66446008)(110136005)(54906003)(26005)(11346002)(2501003)(64756008)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3749;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: faEgQJFQyyGU5gA9x4pzwhc5Bwg6kxDumXq/+qEFeimMGTFrxxWC8GjaIo3rlULzu8PLkHvTq6xpB+GOGi5OO4zx9qgP313Q1H4ft7Su4qTiotzfzDUSSldAgqv4huyQqJuPXmP7Gkk+NIBI+52RYFx6B0TepOFxZXoVaEOlP7IEWqU/5pESfCIrBCEQESjcdEKG02fwNY0GpbEAPMaBWCCezYQTQFCF912spaaA2Y/slKfcQHD3c5OfzfKiPzMvg11oVKlAx23uzk0jBXNkkVNs5X/d1Od/Q+z3rA0BhDq0623mqPrM/H/cDlHwuKAiPSsOiP1TaAfLsrF8cRaXg0aAlzVuPjNWHSGtANw1iI0Xe/fdNZ3cIgfV5df9jLlc7FpZMVQsKrezbiE0SaN2JCmZ7IJjv5pMX6XTivVvYzg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6ea24c-0704-4daf-138d-08d7435b79a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 15:00:45.9796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQIWb/CTinUdRB2ecrpwUP3qkMVXM7nktGneqLFftO2+ohsvgm3N9t04gJEl/2T9PsBsxl+nxftOgaA5gEftnYhrCk+BPh+5HQQgAdMxDDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3749
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

irq_create_fwspec_mapping() can race with itself during IRQ trigger type
configuration. Possible scenarios include:

- Mapping exists, two irq_create_fwspec_mapping() running in parallel do
  not detect type mismatch, IRQ remains configured with one of the
  different trigger types randomly
- Second call to irq_create_fwspec_mapping() sees existing mapping just
  created by first call, but earlier irqd_set_trigger_type() call races
  with later irqd_set_trigger_type() =3D> totally undetected, IRQ type
  is being set randomly to either one or another type

Introduce helper function to detect parallel changes to IRQ type.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 kernel/irq/irqdomain.c | 66 +++++++++++++++++++++++++++++-----------------=
----
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index ad62c08..4ff4073 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -764,10 +764,45 @@ static void of_phandle_args_to_fwspec(struct device_n=
ode *np, const u32 *args,
 		fwspec->param[i] =3D args[i];
 }
=20
+/* Detect races during IRQ type setting */
+static int irq_set_trigger_type_locked(unsigned int virq, unsigned int typ=
e,
+				       irq_hw_number_t hwirq,
+				       const struct irq_fwspec *fwspec)
+{
+	struct irq_data *irq_data;
+	int ret =3D 0;
+
+	mutex_lock(&irq_domain_mutex);
+	/*
+	 * If the trigger type is not specified or matches the current trigger
+	 * type then we are done.
+	 */
+	if (type =3D=3D IRQ_TYPE_NONE || type =3D=3D irq_get_trigger_type(virq))
+		goto unlock;
+
+	/* If the trigger type has not been set yet, then set it now */
+	if (irq_get_trigger_type(virq) !=3D IRQ_TYPE_NONE) {
+		pr_warn("type mismatch, failed to map hwirq-%lu for %s!\n",
+			hwirq, of_node_full_name(to_of_node(fwspec->fwnode)));
+		ret =3D -EINVAL;
+		goto unlock;
+	}
+
+	irq_data =3D irq_get_irq_data(virq);
+	if (!irq_data) {
+		ret =3D -ENOENT;
+		goto unlock;
+	}
+	irqd_set_trigger_type(irq_data, type);
+
+unlock:
+	mutex_unlock(&irq_domain_mutex);
+	return ret;
+}
+
 unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 {
 	struct irq_domain *domain;
-	struct irq_data *irq_data;
 	irq_hw_number_t hwirq;
 	unsigned int type =3D IRQ_TYPE_NONE;
 	int virq;
@@ -802,29 +837,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwsp=
ec *fwspec)
 	 */
 	virq =3D irq_find_mapping(domain, hwirq);
 	if (virq) {
-		/*
-		 * If the trigger type is not specified or matches the
-		 * current trigger type then we are done so return the
-		 * interrupt number.
-		 */
-		if (type =3D=3D IRQ_TYPE_NONE || type =3D=3D irq_get_trigger_type(virq))
-			return virq;
-
-		/*
-		 * If the trigger type has not been set yet, then set
-		 * it now and return the interrupt number.
-		 */
-		if (irq_get_trigger_type(virq) =3D=3D IRQ_TYPE_NONE) {
-			irq_data =3D irq_get_irq_data(virq);
-			if (!irq_data)
-				return 0;
-
-			irqd_set_trigger_type(irq_data, type);
+		if (!irq_set_trigger_type_locked(virq, type, hwirq, fwspec))
 			return virq;
-		}
-
-		pr_warn("type mismatch, failed to map hwirq-%lu for %s!\n",
-			hwirq, of_node_full_name(to_of_node(fwspec->fwnode)));
 		return 0;
 	}
=20
@@ -839,8 +853,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspe=
c *fwspec)
 			return virq;
 	}
=20
-	irq_data =3D irq_get_irq_data(virq);
-	if (!irq_data) {
+	if (irq_set_trigger_type_locked(virq, type, hwirq, fwspec)) {
 		if (irq_domain_is_hierarchy(domain))
 			irq_domain_free_irqs(virq, 1);
 		else
@@ -848,9 +861,6 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspe=
c *fwspec)
 		return 0;
 	}
=20
-	/* Store trigger type */
-	irqd_set_trigger_type(irq_data, type);
-
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_fwspec_mapping);
