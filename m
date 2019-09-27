Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7EC082E
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 17:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfI0PAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 11:00:51 -0400
Received: from mail-eopbgr130133.outbound.protection.outlook.com ([40.107.13.133]:26241
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbfI0PAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 11:00:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpIMf4CGYLuiaaXAVlh4Zr0edcX7S/StJ7KbIMTCeRd0/gsyx0MIhyNegt/Ayjxik6vYR18OS0IBGCnigUminFmAkROxJRjQEsxWnB8zaYOULHKTisRb9JNbE5nsKxZO7AghrwpfahKOva5gjWf5gA2ZzuIE0hvbTOkyyCzOGYwIzj0ZMKE7tvd0oiAaEjtXT09ZLHJFyat6Hb3Nlkv2YjtGCS7r8+4N7JuNRPW9cG3h+owph7vKBnx3PeDpcYgHKmawTE54DF+N258+9frQqht8fW7Bh8ZYhiFJ4nvxbvs7/fb3vvLXhHqCmcdQy8QNqZ/fwEpTccahLdJ37ZeL8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YT8+wzWftHakEc1re62sJrKaa211nWSY2l7Yb5P1tw0=;
 b=cH6Tg72/fq2s2SPcE5uzUDNJXTWPBG+YzzrlE0sEnFwhhcaXrXytgZNekSVUjGJPBbQzUppQPI4M6eqWirN3kmJmlUNj9+P7kiGbeFJaE/fkJnCKeb5ymC5+5z/jzudgsoKOFylsdONcdNd7OVjvQiLjFXD6Rzn20WBELfim8BqhgEzESSljKfyFPw6DpmdAlwrT/WdhHVHK4Di/s7zaF3vJYyMcl/ms/Mr7AdR+A34lawI4VnGVdHj044tx9BPtRoTBXMjFC23OeGLhbCDBVyogv4PCxR4Wc1/qsnHEodTGJPpznTV1dHyh6rdVTNByOVjRBg6b1fJW5UM551W7mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YT8+wzWftHakEc1re62sJrKaa211nWSY2l7Yb5P1tw0=;
 b=waAuhWJICeH7+JayFf9+rm1mzGVBkK74J1hNVs6xuKv90vcAXIfuH4yDLT5SjSBsrcOFbB9nu5R6lcjP6k7WdluSBn1AjhUajjCIX3kW5dKMKt5BNBxMNJp/ebwkY6NDtw894OhbwdTVQgmnRaHW2HndEKdYHiGFSxdzirwLRr0=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3749.eurprd07.prod.outlook.com (52.133.19.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Fri, 27 Sep 2019 15:00:45 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::7497:742a:1167:30dc]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::7497:742a:1167:30dc%6]) with mapi id 15.20.2305.013; Fri, 27 Sep 2019
 15:00:45 +0000
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
Subject: [PATCH v2 2/3] genirq/irqdomain: Re-check mapping after associate in
 irq_create_mapping()
Thread-Topic: [PATCH v2 2/3] genirq/irqdomain: Re-check mapping after
 associate in irq_create_mapping()
Thread-Index: AQHVdURWbbMnVh4mSE22zcVCt2yGKQ==
Date:   Fri, 27 Sep 2019 15:00:44 +0000
Message-ID: <20190927150025.26481-3-alexander.sverdlin@nokia.com>
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
x-ms-office365-filtering-correlation-id: 51c664f0-e556-4fe9-8e6b-08d7435b7911
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM6PR0702MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB3749BE77089707CE5029B34B88810@AM6PR0702MB3749.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(199004)(189003)(2616005)(2906002)(6436002)(71190400001)(446003)(71200400001)(50226002)(7736002)(6512007)(4326008)(14454004)(478600001)(52116002)(6486002)(25786009)(76176011)(305945005)(66066001)(102836004)(3846002)(386003)(81156014)(256004)(6116002)(186003)(486006)(8936002)(86362001)(8676002)(99286004)(316002)(81166006)(66556008)(5660300002)(66946007)(6506007)(1076003)(66476007)(36756003)(66446008)(110136005)(54906003)(26005)(11346002)(2501003)(64756008)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3749;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iNpc4zovw+vbw9UvyaMVqNLAdv9DSOUz1D1hvEQRcd7am8bsgJ0alEXQmlDXmnNP1wQ3atbOgdZ+DWqhJJJ+pF4awhTXP0ceiN7LxJyTFgHkiKV7EBUqSSyjn9eJgQSvSx0BbQyhRA1vWroFjbcSuJ1Yw6qTddH+zzRCqIstKIMsPbjStWY6rG8DE9CoiFpQT+aUBNdGxvgsJHp+mXUqbaOB8NvrQIDCmkSw0axbYjScF/gTT/JFX0KQSzMm2ObzZF9QKHQADZD/pO+SJ6cekEKb6qN7eOJHAhFNRJVfIQ1ArmafAEKjsK3y30Ys+UKJ9MUgaUdEf5R3bi3Gbzb/7UUSUqsxP9ODLh+WmtB7wA3PdfJwBvrTwZBuc4a1wbAavcpw4ubRuqyOCoX7p9y8ZOKlShx06RpspqwIWXf9zJw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c664f0-e556-4fe9-8e6b-08d7435b7911
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 15:00:45.0032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jVGVFc6M6QtYg0d6ASiAydFyPakely4Az2F2RSLmfAxVfJ4ogGot1LmfpfKwE3dwEOOtW1mcM8AyGirO8lSM67aJYHswiOoMhCQphon+VqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3749
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

If two irq_create_mapping() calls perform a mapping of the same hwirq on
two CPU cores in parallel they both will get 0 from irq_find_mapping(),
both will allocate unique virq using irq_domain_alloc_descs() and both
will finally irq_domain_associate() it. Giving different virq numbers
to their callers.

In practice the first caller is usually an interrupt controller driver and
the seconds is some device requesting the interrupt providede by the above
interrupt controller.

In this case either the interrupt controller driver configures virq which
is not the one being "associated" with hwirq, or the "slave" device
requests the virq which is never being triggered.

Reported-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Reported-by: Tomasz Bachorski <tomasz.bachorski@nokia.com>
Reported-by: Wojciech Kosnikowski <wojciech.kosnikowski@nokia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 kernel/irq/irqdomain.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index ccbb048..ad62c08 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -661,6 +661,7 @@ unsigned int irq_create_mapping(struct irq_domain *doma=
in,
 {
 	struct device_node *of_node;
 	int virq;
+	int ret;
=20
 	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
=20
@@ -675,13 +676,6 @@ unsigned int irq_create_mapping(struct irq_domain *dom=
ain,
=20
 	of_node =3D irq_domain_get_of_node(domain);
=20
-	/* Check if mapping already exists */
-	virq =3D irq_find_mapping(domain, hwirq);
-	if (virq) {
-		pr_debug("-> existing mapping on virq %d\n", virq);
-		return virq;
-	}
-
 	/* Allocate a virtual interrupt number */
 	virq =3D irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node), NU=
LL);
 	if (virq <=3D 0) {
@@ -689,8 +683,11 @@ unsigned int irq_create_mapping(struct irq_domain *dom=
ain,
 		return 0;
 	}
=20
-	if (irq_domain_associate(domain, virq, hwirq)) {
+	ret =3D irq_domain_associate(domain, virq, hwirq);
+	if (ret) {
 		irq_free_desc(virq);
+		if (ret =3D=3D -EEXIST)
+			return irq_find_mapping(domain, hwirq);
 		return 0;
 	}
=20
--=20
2.4.6

