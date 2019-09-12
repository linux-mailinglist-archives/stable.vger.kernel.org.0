Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC16B0BC4
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 11:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfILJoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 05:44:12 -0400
Received: from mail-eopbgr70097.outbound.protection.outlook.com ([40.107.7.97]:50646
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730593AbfILJoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 05:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLj6qeLGZIwQpv0KUZBxbRgX8a3+y0S4FAtxtgXpAz+fyxKQ0WmpNErpuaF9SYI4MEBy05zVwMkx/Hw+PqDgSHngidD9zt0oOeGEVN9cLMGgLde8CDgC8wfFrnt+NzXMU1rMbtC7JnXJ1FiBcUU6A8MpD+0pt+H8zN7I00+p7iWjWz/7lphBaFVJLDIebxE890rEPvvC9iDhgPE3yHGiwH5ZTqIZ2UG9qVq5ZyAUpgQA3JhcW2nvkzMu/M6hMlyATjTvbDFoUEoUYP/ziOIqXFvH8KlFgEAms4KC4OPevTUm9Lt9X0luhXOzBUv4n/CfuSYGhkdobQHDJWsy4IEhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxQs9qrkOQTGlFLkEqTfXTcRyCtzfF1dByH3D74lr+A=;
 b=dZ7pRCvy3dlFIUczyKbSvLekwY3X2mTm9i277kwV7SYWno3H1FCYINsYCSiWYKlx7KqBH/FqwN95WAnje1yOpgCXHmkA8DPvjhTfiMBZg79ZV628ehg7BEU4x+nqgqvTVKOkk0VqTBf3h3NiKD5QvvHE0ws2G7alm9hx7B7IoFzCsBtLfC0WFsTSONNGPbma3hp+H9hhNWZPKnZ6Fk6bC6hCqfn5TtdBvZgMv2d8aY+frH5m9ODYWCaUOU46MXk9+Cwnz6HlhlbrWq1Muj3TgC0HmBsllBqO2ptA4Z1cFLDa19HNbQV5vzr50mGtNiFnRje3JZMe9uuN9k1TAOnTsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxQs9qrkOQTGlFLkEqTfXTcRyCtzfF1dByH3D74lr+A=;
 b=rx2RsVVhjdbZ3M5xt8ld/+ICUjCTUqLFG5gOhBc5oSRqnFHoX0ixKO8uPl+8f0Oj5CYsze9MIZVaRnNsns2/GUU/zVSW9e4BIBLFi/BBA8UjZ5vk6qKjk+Ob60+pLCVDxzgWKyeyOG1opGFs9VXGiMdVoZ+0C8MT4d21A84q0/A=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3654.eurprd07.prod.outlook.com (52.133.21.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.7; Thu, 12 Sep 2019 09:44:07 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56%3]) with mapi id 15.20.2263.016; Thu, 12 Sep 2019
 09:44:07 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/3] genirq/irqdomain: Check for existing mapping in
 irq_domain_associate()
Thread-Topic: [PATCH 1/3] genirq/irqdomain: Check for existing mapping in
 irq_domain_associate()
Thread-Index: AQHVaU6fbsvmL4kmNUmeKw2Ifb7zFw==
Date:   Thu, 12 Sep 2019 09:44:07 +0000
Message-ID: <20190912094343.5480-2-alexander.sverdlin@nokia.com>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.2.21]
x-mailer: git-send-email 2.23.0
x-clientproxiedby: HE1PR05CA0342.eurprd05.prod.outlook.com
 (2603:10a6:7:92::37) To AM6PR0702MB3527.eurprd07.prod.outlook.com
 (2603:10a6:209:11::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edaf5580-a0a9-4ac9-5e02-08d73765c179
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0702MB3654;
x-ms-traffictypediagnostic: AM6PR0702MB3654:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB365414556B6E5CFE7FB4DC4D88B00@AM6PR0702MB3654.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(64756008)(2501003)(6116002)(110136005)(5660300002)(53936002)(486006)(66066001)(386003)(6506007)(86362001)(6512007)(102836004)(186003)(26005)(316002)(76176011)(446003)(8676002)(11346002)(476003)(81156014)(2616005)(81166006)(6436002)(50226002)(3846002)(256004)(14444005)(6486002)(54906003)(1076003)(71190400001)(25786009)(66946007)(8936002)(2906002)(66556008)(66446008)(99286004)(4326008)(14454004)(36756003)(52116002)(71200400001)(305945005)(66476007)(478600001)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3654;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zt+DAR0KpwV+6VWbHDjcHfx0ryjgvpUhydEMFWNVpDYMGcUKz69LgYukVlpzt4J0Uf2JrZIsccKW/GwdlynwRX5sD+lx++Gti7hwyszv0B0sd4UsV7OzyCa3Ml6DQ9mJ2brpOjd+71CJnJOBc2XD+70E4ZzUhe66MKfsFkHvVOGBW50+8xLk00iywEJ5FI0jDoIrpWhSlzz/aBc/wb/fwxWWvpM3c5YqGd5svXU6SMrmIKsQo0Cs+N60AE0RY5r1JEShEDMB7NKSTTCe/cx58kryGo0Sj5kLIZS5WI6zkVfvU7Au4Ks16WyfnzD7KDqpjKMxvjxmF4k+t8GaXk0vHGMSjb73mafnwG7Y3kIabAtfGjrThHUwv3EmS6cInZHfRMSmbD7zyKLkGBJ555UuHYpbgX1cBx0g6SMg+VsBGEA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edaf5580-a0a9-4ac9-5e02-08d73765c179
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 09:44:07.5114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: svDLqBUDASaJxx9w0XI2HLum7ctvNZVYxlBmtc3Yw+Fs6pf7Us6MYL6YRyY/NSqf4gC/jr6EQHIl3zACh/ATtRkReGbUuqCIy9rMEOI9m6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3654
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

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 kernel/irq/irqdomain.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3078d0e..7bc07b6 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -532,6 +532,7 @@ int irq_domain_associate(struct irq_domain *domain, uns=
igned int virq,
 			 irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data =3D irq_get_irq_data(virq);
+	unsigned int eirq;
 	int ret;
=20
 	if (WARN(hwirq >=3D domain->hwirq_max,
@@ -543,6 +544,16 @@ int irq_domain_associate(struct irq_domain *domain, un=
signed int virq,
 		return -EINVAL;
=20
 	mutex_lock(&irq_domain_mutex);
+
+	/* Check if mapping already exists */
+	eirq =3D irq_find_mapping(domain, hwirq);
+	if (eirq) {
+		mutex_unlock(&irq_domain_mutex);
+		pr_debug("%s: conflicting mapping for hwirq 0x%x\n",
+			 domain->name, (int)hwirq);
+		return -EBUSY;
+	}
+
 	irq_data->hwirq =3D hwirq;
 	irq_data->domain =3D domain;
 	if (domain->ops->map) {
--=20
2.4.6

