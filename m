Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F14741806
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 00:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390376AbfFKWWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 18:22:07 -0400
Received: from mail-eopbgr790124.outbound.protection.outlook.com ([40.107.79.124]:46880
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388875AbfFKWWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 18:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEF0/6YRrQuQVDsC/LUq3vTX4iCJP/zqnEoMtQr5dtU=;
 b=Z4u6UOoXVojazErlg7umafdQlfL3avZaAs6dNZjRU8EKciQvzQgS/k25/UoE3UtAvJ/Bb7smyxrIurDZvJysaHPI8HqnFYDBZIBCf9fDDI6i52BJE5EYpS7Ml7JWkTCQDO1JpenXmQ3MYZVl8ql/NhQ7sqQ27ZIq2gqWwny/P2M=
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com (10.171.214.23) by
 CY4PR2201MB1367.namprd22.prod.outlook.com (10.171.217.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Tue, 11 Jun 2019 22:22:03 +0000
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::d571:f49f:6a5c:4962]) by CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::d571:f49f:6a5c:4962%7]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 22:22:03 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Paul Cercueil <paul@crapouillou.net>
CC:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <pburton@wavecomp.com>,
        James Hogan <jhogan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "od@zcrc.me" <od@zcrc.me>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: lb60: Fix pin mappings
Thread-Topic: [PATCH] MIPS: lb60: Fix pin mappings
Thread-Index: AQHVGvNR1qZ4gQD8hE2mZTClh06Tw6aXEkgA
Date:   Tue, 11 Jun 2019 22:22:03 +0000
Message-ID: <CY4PR2201MB1272B762656C4EFB45D0D026C1ED0@CY4PR2201MB1272.namprd22.prod.outlook.com>
References: <20190604163311.19059-1-paul@crapouillou.net>
In-Reply-To: <20190604163311.19059-1-paul@crapouillou.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:a03:80::45) To CY4PR2201MB1272.namprd22.prod.outlook.com
 (2603:10b6:910:6e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce5b07b3-7861-42d3-2dc1-08d6eebb3ab1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR2201MB1367;
x-ms-traffictypediagnostic: CY4PR2201MB1367:
x-microsoft-antispam-prvs: <CY4PR2201MB13675059F4E2458D78285E72C1ED0@CY4PR2201MB1367.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39850400004)(376002)(346002)(396003)(366004)(199004)(189003)(81156014)(446003)(2906002)(8676002)(81166006)(486006)(305945005)(7736002)(4744005)(6916009)(478600001)(476003)(11346002)(14454004)(44832011)(66446008)(5660300002)(66556008)(64756008)(66476007)(66946007)(68736007)(52536014)(8936002)(73956011)(6116002)(3846002)(74316002)(256004)(42882007)(71200400001)(71190400001)(26005)(9686003)(6246003)(4326008)(102836004)(99286004)(55016002)(25786009)(54906003)(52116002)(6436002)(53936002)(7696005)(316002)(186003)(76176011)(6506007)(386003)(229853002)(66066001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR2201MB1367;H:CY4PR2201MB1272.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4n9VVHNEk1u3ZLYYxQXW4Whr+OJtjUtzS0NtuVzTasCOjsh8ENXb93u8E2Nsdr7YCk4bElROKsTEo+ehVTbydlQbejE8ECyxROVu+1kszYUjPt8kamJp6DwXnT7rcoOLqsf5wO11GQZdkrV5P7n4K1nRnY59ynh9K42E6Trnj140WpzBj6R+TBkS9uLK8nkiBfEx4cpzun49QahUm30XGZtKoa3wHmTm19whkdKn0UqgaTbB75OtpUSJuIvEWVs8iowscYaumYnRCtQDB7PYnPmcPjzSiOn5rohqaoI1iPo/ihM5I13aj9t5jyp6+h2IN1zjPgq+XgH6ZXBfz26cjUfDzFh+fzEfpHvTtR3FCDzO0lM/r0gDK1NKxBq5FAF9NLB6PjJv58cF7gWvptLCImuGmXSV408DEE/ejap7t44=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5b07b3-7861-42d3-2dc1-08d6eebb3ab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 22:22:03.3991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR2201MB1367
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNClBhdWwgQ2VyY3VlaWwgd3JvdGU6DQo+IFRoZSBwaW4gbWFwcGluZ3MgaW50cm9k
dWNlZCBpbiBjb21taXQgNjM2ZjhiYTY3ZmI2DQo+ICgiTUlQUzogSlo0NzQwOiBRaSBMQjYwOiBB
ZGQgcGluY3RybCBjb25maWd1cmF0aW9uIGZvciBzZXZlcmFsIGRyaXZlcnMiKQ0KPiBhcmUgY29t
cGxldGVseSB3cm9uZy4gVGhlIHBpbmN0cmwgZHJpdmVyIG5hbWUgaXMgaW5jb3JyZWN0LCBhbmQg
dGhlDQo+IGZ1bmN0aW9uIGFuZCBncm91cCBmaWVsZHMgYXJlIHN3YXBwZWQuDQo+IA0KPiBGaXhl
czogNjM2ZjhiYTY3ZmI2ICgiTUlQUzogSlo0NzQwOiBRaSBMQjYwOiBBZGQgcGluY3RybCBjb25m
aWd1cmF0aW9uIGZvciBzZXZlcmFsIGRyaXZlcnMiKQ0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IFBhdWwgQ2VyY3VlaWwgPHBhdWxAY3JhcG91aWxsb3Uu
bmV0Pg0KPiBSZXZpZXdlZC1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8u
b3JnPg0KDQpBcHBsaWVkIHRvIG1pcHMtbmV4dC4NCg0KVGhhbmtzLA0KICAgIFBhdWwNCg0KWyBU
aGlzIG1lc3NhZ2Ugd2FzIGF1dG8tZ2VuZXJhdGVkOyBpZiB5b3UgYmVsaWV2ZSBhbnl0aGluZyBp
cyBpbmNvcnJlY3QNCiAgdGhlbiBwbGVhc2UgZW1haWwgcGF1bC5idXJ0b25AbWlwcy5jb20gdG8g
cmVwb3J0IGl0LiBdDQo=
