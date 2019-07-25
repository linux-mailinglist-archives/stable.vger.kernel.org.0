Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E30746C9
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfGYGGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:06:48 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2167 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfGYGGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 02:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564034818; x=1595570818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A/NceXgpE6uzHFTHuGJb3/rpgKwV1yEURhG25dpgxlY=;
  b=mTaFbCAkAa7oeIbJtDPwEcbrQGv3OeopcvrkjzHf4I9B/0MrLUcrFaQw
   qS7bMzMJUOGbTvLCROrERuXPIx2ZGBbVbYEY+mGHGd+6qC5anxGC1B+G+
   bSWPJzc5AsFARyNpygTbwp8cYtjNUZpBPt+t/2ahMzx8gzl3NFTYiL2zx
   b8x4XsUyG6zIA7GCbY0RPbXoBkWn5SPqqY0sgxTxnqaUGSGFhllcujw7k
   CCFJB2Ed0rM0fESFrdYzV5s+QabkUxMYaSCmSDnoPBZd7c/ImIGyHV7Yg
   vDWgeWkNTgtaPlYslymxcNER+9ZOBxp89PUIPZQbAx8DwSmDnwfJs0R39
   w==;
IronPort-SDR: n8dq7IrIHvPzEyNHBBaupz5lMzsNuckVb/zOm6YOhhz/GtCnIP5HW3l6uLjF9vOjpzwq/dg2NM
 BV4myOyTQ8ChYpcHENH4Ne10sRjTNkdwZMQ7y1TOOxBLSI8e4lwS44y239bok6kiTC5Hm+fGdf
 +gjKw5BFKuvegFGxiFs2VYqR4PGtClbDwaTaNeZ1jyhCI03iz5MuK/LuRWoGFHL4eaLvSNEYsY
 tEdoybLGZa+x0g7atLq6NeWmtJhvvXcDV/e8RIVFF0N/CK/P06Aq8Qq8rtPaAHkZkt4FYC9U2t
 vJ0=
X-IronPort-AV: E=Sophos;i="5.64,305,1559491200"; 
   d="scan'208";a="214070346"
Received: from mail-bl2nam02lp2053.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.53])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2019 14:06:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsd9fbgpFx60X/eEsgPnNlTXayGqWS8IsrmdPRxwJw8LjEx8s7UhvneRJXux7hVtOTV6z9O2rXkpuqHSISaU+772b5la2ja4M1abobe6MkQ18pMwZB+go+E3LkBBuEa38fRlVzeAgGPcitCkP8yLZus34C2ozbe14OgncV/bi6gd+6U1h4BQkOnNpHQI6jFquB7lwNu4zIxGjD5jNZZnpzD6krgYJn/2k6F3WrYPRsXAQFZfIIwhWds+Qq0P9vTLvP4Psii27amulABXDKC4JQcVMJ850kKpaL6W4ahT/5O8KyVQrPJ1JSfhAk3+G2blR57B0BuC5lVgjxkhTrIE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/NceXgpE6uzHFTHuGJb3/rpgKwV1yEURhG25dpgxlY=;
 b=ei6/tTHrekXUHiewz5wM8Ba3HCrQu8dY7K5lqE+jsv/ixy24ZrXqEOPKUZ+cbnDli1cZHFaJ3fUchaO2F+tikvus1tnMXmrQX4HmKHB6f44PxodlxLhVGC396iy5hRwXcTU7kFZ9V5YbRprmXnLW07geUpZYaPwGok0iCB4Wb9UH2WeDhPU2eG/kHiri4RZJqaBb6MTOZfhfoyfMoIwzjCtZ3DAOZKcgVckK7JD5PhQhO+jonODEqoDmc2OZABg4LBo0TtVeWbF6GT2sizT+9vaiWqcNZ8l5dbvIRkMdn5rEDvhlfiXYDOZ0KdCezUFCetqfOQLA7eyY90r2n9WQrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/NceXgpE6uzHFTHuGJb3/rpgKwV1yEURhG25dpgxlY=;
 b=cPUe36xGQYybewCSqcWuvWk7Lxf9oXGUd1INEBdNBmG3vkmr0kPHWLAW2dxkg+e8dpKsC3JuQ/QGqKq7+4bk8hv2MvHfBcwwPYQ6jO5QTUI4seKn3uhqDEXQF6hVHXwsnJeRUe5eY3zWTR80eI+bwQx3+KQQmnFeWjwJVo0IOqM=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5894.namprd04.prod.outlook.com (20.179.59.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 06:06:45 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::65a9:db0a:646d:eb1e]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::65a9:db0a:646d:eb1e%6]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 06:06:45 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@lst.de" <hch@lst.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] block: Limit zone array allocation size"
 failed to apply to 5.1-stable tree
Thread-Topic: FAILED: patch "[PATCH] block: Limit zone array allocation size"
 failed to apply to 5.1-stable tree
Thread-Index: AQHVQU3FeLJlIR4aIU2+m03jiRGu86ba26kA
Date:   Thu, 25 Jul 2019 06:06:45 +0000
Message-ID: <c1ed04aded7fb0e68cd4095cb4c7049c02a11e3f.camel@wdc.com>
References: <1563883019244153@kroah.com>
In-Reply-To: <1563883019244153@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c21dd24-4fc4-4f9d-4f44-08d710c645f8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5894;
x-ms-traffictypediagnostic: BYAPR04MB5894:
x-microsoft-antispam-prvs: <BYAPR04MB5894B81AADC8165BBFFC61F1E7C10@BYAPR04MB5894.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(6486002)(118296001)(6246003)(186003)(25786009)(53936002)(4326008)(478600001)(26005)(8936002)(2906002)(2201001)(76176011)(76116006)(2501003)(5660300002)(64756008)(66556008)(66446008)(66946007)(102836004)(6506007)(66476007)(91956017)(36756003)(71190400001)(66066001)(14454004)(476003)(81156014)(68736007)(81166006)(6436002)(8676002)(486006)(110136005)(71200400001)(58126008)(7736002)(305945005)(11346002)(446003)(86362001)(3846002)(2616005)(229853002)(316002)(4744005)(6512007)(256004)(6116002)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5894;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jsEBCRoXeUtMg78fZGGQ9g7fU2XtzKTVI53Eehr1KHFAG5Rpdnfu9q72CcdLyWWi6Fx4FJzmAcuXXLoqZAl7VT5FLoV8B1RsiQo+xlI6eUX5Y8e5Mx3DsKZSCBnIIJKzHsp31iQXkB8AxcU5P5GU4+QUkPs5PVaKyBnNhNxVpvI9mTwuwZaXJtwECud3WZzJtXRrhibRG9pmTtkqQbddUKjDC/eTKxU6SuygUIDvaa/eKivWm5+MC7HEsb/axAnEB8FLnjoJqwj0vjfRi6z91Etb4yMyCttlGkvI+DbEJWcTH3P2ewqq72OcjPkHQNPBqG+nVJucXKGj0qcsJeCh5y5W0LCsbWjngk5AO7JOtHLpT0K4KrYSnf0MyORwa3uFZ5a0hLLUCNEA36ziyXBx8l2nxUnkOL2M2lmPoKpdb/4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27C7AE25F49F7543BEAFAB8703E9B77D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c21dd24-4fc4-4f9d-4f44-08d710c645f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 06:06:45.8175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Damien.LeMoal@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5894
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDEzOjU2ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gVGhlIHBhdGNoIGJlbG93IGRvZXMgbm90IGFwcGx5IHRvIHRoZSA1LjEt
c3RhYmxlIHRyZWUuDQo+IElmIHNvbWVvbmUgd2FudHMgaXQgYXBwbGllZCB0aGVyZSwgb3IgdG8g
YW55IG90aGVyIHN0YWJsZSBvciBsb25ndGVybQ0KPiB0cmVlLCB0aGVuIHBsZWFzZSBlbWFpbCB0
aGUgYmFja3BvcnQsIGluY2x1ZGluZyB0aGUgb3JpZ2luYWwgZ2l0IGNvbW1pdA0KPiBpZCB0byA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4uDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0K
DQpHcmVnLA0KDQpJIHNlbnQgeW91IGEgYmFja3BvcnRlZCB2ZXJzaW9uIHRoYXQgYXBwbGllcyBj
bGVhbmx5IHRvIGJvdGggNS4xIGFuZA0KNS4yIHN0YWJsZSB0cmVlcy4NCg0KQmVzdCByZWdhcmRz
Lg0KDQotLSANCkRhbWllbiBMZSBNb2FsDQpXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gNCg==
