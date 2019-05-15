Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A09C1F614
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfEON6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 09:58:17 -0400
Received: from mail-eopbgr780082.outbound.protection.outlook.com ([40.107.78.82]:43540
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbfEON6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 09:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiAPiA8rsTJzVyRhrZcI0G0nNh1Y/Ov+R8RC755iPfY=;
 b=kIjv3a6Ramvxgo6QDkxe0SM+HG7nBmtW9U71lDNwNgDv2QYHZDUg7XUnYDZasGD0bUl7UqD6WeujkyYxBU0jkNVM/OTi5Skun+AGYY5hhzcQ15dPSPivVkkaeuLPPCfscbhXQyPEIaclp4ShB1mQVgtyvzJaBDz2iMmeOwA9ykg=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB2732.namprd11.prod.outlook.com (20.176.99.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 13:58:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 13:58:12 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Thread-Topic: [PATCH 5.1 00/46] 5.1.3-stable review
Thread-Index: AQHVCyY3Lfi8Y6EzMUWYboZEUlmuhw==
Date:   Wed, 15 May 2019 13:58:12 +0000
Message-ID: <816bb77b-8411-8716-b3ca-2804d40cf9e5@aquantia.com>
References: <20190515090616.670410738@linuxfoundation.org>
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR07CA0008.eurprd07.prod.outlook.com
 (2603:10a6:7:67::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a64c505f-4cf9-4710-8176-08d6d93d5e85
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB2732;
x-ms-traffictypediagnostic: DM6PR11MB2732:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR11MB27326FEF5EC37823CA7681ED98090@DM6PR11MB2732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39850400004)(376002)(346002)(366004)(136003)(189003)(199004)(476003)(110136005)(305945005)(446003)(229853002)(53546011)(86362001)(31696002)(52116002)(2616005)(14454004)(256004)(14444005)(81166006)(3846002)(6436002)(2906002)(76176011)(11346002)(6116002)(6512007)(81156014)(4744005)(6306002)(4326008)(44832011)(54906003)(186003)(486006)(316002)(6486002)(102836004)(7736002)(6506007)(99286004)(386003)(8676002)(8936002)(68736007)(25786009)(71200400001)(71190400001)(66066001)(26005)(478600001)(6246003)(72206003)(7416002)(966005)(73956011)(66946007)(66476007)(66446008)(64756008)(66556008)(31686004)(36756003)(53936002)(2501003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2732;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rfS2E2aAU8RCF53Aunq6aWXffF49xFNaCjaHejRczP6rNbahcxP/Fd4iZ/mlTyNG3Ar2gN/hDF7QGPlTtINeaq+4BK3kkFQsUxSOYLPIsu7O9BSoWAvapeek3RPZb38xdp3V0YnY2YIUhN5FLP+/2D6uXNtt7Dob7lrbtEm1/d8lyJs8Jd7RlH4X0NCLiVkFJLJ3fVk674Ojd9JyWMqaXKrrHl3Z2onbHs/ZX4MX4nsZMsVeaV1bOgLI885SDJZjtJBvD65NWi2nLUSxu4t4tUHfypBaelP7ZacRWn0dfTqy1KuMfYnIHs/6tC8FxbYECyfs3Dfs6lJKqHP1QAP6BOaN3kjVWfS9QyANbvsQ8IYGMukhoD/d3V1tF/3VMeFtCuwzkWF/NixjVpJPNTMmH6UalgZPrRSrStwhw+r2/TA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C231D9BD5D615A4D8DF4A7C88C9927E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64c505f-4cf9-4710-8176-08d6d93d5e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 13:58:12.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2732
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDE1LjA1LjIwMTkgMTM6NTYsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gVGhp
cyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA1LjEuMyBy
ZWxlYXNlLg0KPiBUaGVyZSBhcmUgNDYgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwg
YmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFu
eSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cu
DQo+IA0KDQo+IA0KPiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPg0KPiAgICAgYXFj
MTExOiBmaXggZG91YmxlIGVuZGlhbm5lc3Mgc3dhcCBvbiBCRQ0KPiANCj4gT2xpdmVyIE5ldWt1
bSA8b25ldWt1bUBzdXNlLmNvbT4NCj4gICAgIGFxYzExMTogZml4IHdyaXRpbmcgdG8gdGhlIHBo
eSBvbiBCRQ0KPiANCj4gT2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4NCj4gICAgIGFx
YzExMTogZml4IGVuZGlhbm5lc3MgaXNzdWUgaW4gYXFjMTExX2NoYW5nZV9tdHUNCj4gDQoNCkhl
bGxvIEdyZWcsDQoNClNhbWUgcmVxdWVzdCBmb3IgNS4xIHRyZWUuDQpQbGVhc2UgZHJvcCB0aGVz
ZSB0aHJlZSBwYXRjaGVzIGZyb20gdGhlIHF1ZXVlLCB0aGV5IGFyZSBpbnZhbGlkIGFuZCB3aWxs
IGJlDQpyZXZlcnRlZCBpbiBuZXQgdHJlZS4NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0
ZGV2LzE1NTc4Mzk2NDQuMTEyNjEuNC5jYW1lbEBzdXNlLmNvbS8NCg0KVGhhbmtzLA0KICBJZ29y
DQo=
