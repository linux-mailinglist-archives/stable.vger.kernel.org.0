Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944FAC082C
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 17:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfI0PAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 11:00:49 -0400
Received: from mail-eopbgr130133.outbound.protection.outlook.com ([40.107.13.133]:26241
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727747AbfI0PAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 11:00:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7tO7Jcl/SJdnUxB41TRxJVom9/n9jLlvIWH3LASX0lT9mDBx+fyEH+jFg5yeAOdIRiMcfZeWok4dgHY9tlYSCCudGfUNlFQBr2SF9pnqa2BOlRRwlkBslx0ENxdOKzI/hzIxENve1rfrLxBIznmDEDC+A2D4UFu0DKtVp5vN1LQxbILSFt0s7lPAzOEG3zGOAfB4NZR8vdLiUmLIOlkpZy3d6r49eJjJvQh+huzGHmA9Ir62wV0RmNd744RZs9iAb1FygCtDsy9Sg0ogjcu0ieRtzfOlcQT18OZNU64CAcK53N34SgFZcp0xogi+BmyCdboZ6nF1JmDMIZyhEl8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjsntCvxgbycErllP6HmPFjLO3bpJlcz97Khbyed/o0=;
 b=TuonnTAkK4NQQPhZIw2EevheH2ptvFVTAU0Evv2WbC9l6Gxty7LJQ1fHNRaWIiMBTct3HHtHbG1GbpBqf8i+L1P11qLwvLPkfOPvoVjVdSMcdewhFBnoFLv6jUwpb/Q2TlGD7rlbZ39jqwBGgdAWbY6i8kgp/obLdERc/PLaHUt/7hYUZHesYN/0Ad64CgrLARQC37iQRfhPnfLYJnYPMR9H2KDWsLOs6HjIGCfCxxCs5T3V1OGxiATNsnUKAsaU1/8FCztO7uSsIBDFe+5e0IrPzCskHd+TXMoUjTuDYlyGzNhdzgNJ5yOUgOKVT7h0Y7XCTRNIPFDKvkCZ2UEXwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjsntCvxgbycErllP6HmPFjLO3bpJlcz97Khbyed/o0=;
 b=L50n3SGqMlFSusmsweThjKelJXmYDNFFuDxQxyWXgzYNSdn8KCp7csTTmcVgA7Y3wT5jGVUGnfvaf/mvk6Gc63xNwP1Fnu/z/mnq4WcD9119AVOA6/fQc9+SfYE932X5F+MnHSrpG6WcIivTJY8RGwwmsFEZ+1eUIMEWxmNc35g=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3749.eurprd07.prod.outlook.com (52.133.19.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Fri, 27 Sep 2019 15:00:43 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::7497:742a:1167:30dc]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::7497:742a:1167:30dc%6]) with mapi id 15.20.2305.013; Fri, 27 Sep 2019
 15:00:43 +0000
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
        "Bachorski, Tomasz (Nokia - PL/Wroclaw)" <tomasz.bachorski@nokia.com>,
        "Kosnikowski, Wojciech (Nokia - PL/Wroclaw)" 
        <wojciech.kosnikowski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] genirq/irqdomain: Check for existing mapping in
 irq_domain_associate()
Thread-Topic: [PATCH v2 1/3] genirq/irqdomain: Check for existing mapping in
 irq_domain_associate()
Thread-Index: AQHVdURVsc7OlX4VikCqdGHkQWSPSQ==
Date:   Fri, 27 Sep 2019 15:00:43 +0000
Message-ID: <20190927150025.26481-2-alexander.sverdlin@nokia.com>
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
x-ms-office365-filtering-correlation-id: 3aac3242-c1b0-4a62-4a4b-08d7435b783b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM6PR0702MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB3749798E2561E6E6C1BBAF3688810@AM6PR0702MB3749.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(199004)(189003)(2616005)(2906002)(6436002)(71190400001)(446003)(71200400001)(50226002)(7736002)(6512007)(4326008)(14454004)(478600001)(52116002)(6486002)(25786009)(76176011)(305945005)(66066001)(102836004)(3846002)(386003)(81156014)(256004)(6116002)(14444005)(186003)(486006)(8936002)(86362001)(8676002)(99286004)(316002)(81166006)(66556008)(5660300002)(66946007)(6506007)(1076003)(66476007)(36756003)(66446008)(110136005)(54906003)(26005)(11346002)(2501003)(64756008)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3749;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ki5vs1yHs5rbDnGQPfjhccHf/UQA2XuxFc3FvKDdphLusE23xR2G116UYJZGF5ho9e2YLXr3TDv5Ziit0NSJbbGcMTuDwOcFmSvEHq56JSRukcKydxocXHMyZQiJtBRl1cXaH41RIWdYENoGB0gOxXN/qSzLcUawWgg4SPmeRan9JAtRx6lrbcRXgchaJylAiibqG2lhfNW7hmL+pB0bndHpNQ/TAx/J2zNy+w+J8Of4CRw6s3O2j2EQfcqwDJDd98PJi3aYIRavMcdyrLU8V2GjqgBCaz6mgy7XzbBk1Iik/79w8a62ICSXisfZ4lf9yLqX4eShiKCx6tnOEpP8eOJWQ1miGxjxwgYCuc3m1OMJxLnLf4nhLQGUcLgud/bbhcSQZJO5CLIMmE0RWz1i7tBvb0eK6QdJvJOsQYCoTBg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aac3242-c1b0-4a62-4a4b-08d7435b783b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 15:00:43.8558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fx884FAnFiUE9t24gfbRg/7/Y3AwcWHQ+S2HcFF6wDjOVW4GfAbfQ91E0i2pwIzaqFgTFew0IjFSBuycUPecROrZrCSWcnXM2ZBWTCIltbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3749
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

irq_domain_associate() is the only place where irq_find_mapping() can be
used reliably (under irq_domain_mutex) to make a decision if the mapping
shall be created or not. Other calls to irq_find_mapping() (not under
any lock) cannot be used for this purpose and lead to race conditions in
particular inside irq_create_mapping().

Give the callers of irq_domain_associate() an ability to detect existing
domain reliably by examining the return value.

Reported-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Reported-by: Tomasz Bachorski <tomasz.bachorski@nokia.com>
Reported-by: Wojciech Kosnikowski <wojciech.kosnikowski@nokia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 kernel/irq/irqdomain.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 132672b..ccbb048 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -545,6 +545,15 @@ int irq_domain_associate(struct irq_domain *domain, un=
signed int virq,
 		return -EINVAL;
=20
 	mutex_lock(&irq_domain_mutex);
+
+	/* Check if mapping already exists */
+	if (irq_find_mapping(domain, hwirq)) {
+		mutex_unlock(&irq_domain_mutex);
+		pr_debug("%s: conflicting mapping for hwirq 0x%x\n",
+			 domain->name, (int)hwirq);
+		return -EEXIST;
+	}
+
 	irq_data->hwirq =3D hwirq;
 	irq_data->domain =3D domain;
 	if (domain->ops->map) {
--=20
2.4.6

