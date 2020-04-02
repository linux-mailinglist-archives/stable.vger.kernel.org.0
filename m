Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72A219BF15
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgDBKHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 06:07:47 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:24687 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgDBKHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 06:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585822066; x=1617358066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MKZR/RB3na+J3TRzmd+RKfsjGXibvkM8M/kiXa7rRa0=;
  b=dhLgZ1k2eM3ofHxTr64BLYjhRM7hIrAWQr68+eXLcgmBnoUpnnGGfmyt
   Kj4QnPWNnHW0apb8VyJ8iUwK5QnhJA6wF2g/DX5USR8LfED2Qxqn6XhxY
   3Cj1dBXVJ/6ZHCrj4fz/bfQUzru+aSoYsLqgPAdu3YRuQXtWDhUXGx1Vy
   1lTWDDNY/t+q7nL9mI1KG5dVWkAomyeGf2SosQDjqWG+qV6hM3lNr28Uz
   bPEfeJ+veujXuIT3EyhY3DI5tFtq4UX2pOmmsOAvAUFvIknVDOiQGhG4b
   0f6qIGAMFJGXI0sBC9vwrqypzbqmEXdMOxNHY83zayFBDADJ20AlGzbNt
   g==;
IronPort-SDR: 8xHe2f95JAIDo8Dd/bjKXKlyixn1j0H4P605U5wfFMTKEwWgwoYB39EQRzPRAHiXFDPy+BaS4z
 DPj7NUedmc+eF+HimYbw6Mgz6deFDqA49rYwc3HEQVaup1wu/NNMdrHy44Uv5VTUczk4JmC9MU
 jYOOvC0N6KZZyER1aBv46jacbu+MotZoFNQptoNq7rli2UDzdhF06QHqLtMHzKVmE6JPQlLH9U
 WSpGw7YiPSqKTrmq2aN16o5m3wm1h1rzG3PMHW8uL3q2bvnevuoBN199fAS/r/cahNPBah63vx
 QIs=
X-IronPort-AV: E=Sophos;i="5.72,335,1580799600"; 
   d="scan'208";a="71003402"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2020 03:07:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Apr 2020 03:07:45 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 2 Apr 2020 03:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfhPBpxtoSWS8q8BZ8wYSh1b+PWt8Aj+dlGVESWXk1S/1EmtoEhudx07YxqnXStv4PlKf7jJluK8LFaqIhTIM0jIhTpoIL1iixqKEHB8c8Sa6nDQPCd6T359yK5GMhuKy3zasK0yH9T2QYgbPsTvUg+6iPiFhogVV+butBBCZbBqvBvl92Z4IS5BH5r38To1tvqkdS4ZM/uPbPYuqQbiQfWaFepTXtQito4kSIuxBV/VQL0COcbftalDj8woJ6UFln+ttaUjFO1CN3QsvadNsZPmU7D/zoERrLFLHwMFe/uWQXfiuJfwjGyHWhuBUjpJkDbpxgIXuof7qB7N85OGzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKZR/RB3na+J3TRzmd+RKfsjGXibvkM8M/kiXa7rRa0=;
 b=EgyyQQH+qnGUm2U67CM+JkeTtiTrwpEi0bqnNSVMgCJ4AOuRMlDlVqSO75rVwsuUsDVZPGhnDs1HnHiYHZCTiWb3gU+MDFSdiFl3plyORSsmzca25eVwg8D+/xbvJEt+mBJXUDUday9UvS/8E3pA1ywzpkmBOG68tqpOnsOKDLMyZzYXE+ZYfiJyJ+Z1nqlkP4tVO2sjbbuOpb3qqDMtWpHNtBfu5NrbiwiYxbFMTRcvK98QZg6blpOyiV1ejdv/4neMBMMycWYsQ7MA48qlJzYXEn7oWI46ho4E9jfOw1pxdLA0N4BBw7h+z5+NTaGaSa7yB7Uo3EXT8raMeSVfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKZR/RB3na+J3TRzmd+RKfsjGXibvkM8M/kiXa7rRa0=;
 b=rD1gW5CSqpZiM/KD5sEOAwR4no+GhMax4UjphLk7nqKqcuqanCs83yJ4Pe9h5FbxafQDP1wAd5J0d249i+J3BUoIDbdf8URiLAD2zC7HLZody1GQR4jmQmFtsTBtyLxAy02+fYaOeRLNC9UFoHL2dY+yniv5u/+A5f9fVF8YIg8=
Received: from DM6PR11MB2777.namprd11.prod.outlook.com (2603:10b6:5:bf::31) by
 DM6PR11MB4548.namprd11.prod.outlook.com (2603:10b6:5:2ad::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.15; Thu, 2 Apr 2020 10:07:43 +0000
Received: from DM6PR11MB2777.namprd11.prod.outlook.com
 ([fe80::3903:ed89:1141:fca6]) by DM6PR11MB2777.namprd11.prod.outlook.com
 ([fe80::3903:ed89:1141:fca6%5]) with mapi id 15.20.2878.016; Thu, 2 Apr 2020
 10:07:43 +0000
From:   <Ludovic.Desroches@microchip.com>
To:     <Eugen.Hristev@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <robh+dt@kernel.org>
CC:     <devicetree@vger.kernel.org>, <Tudor.Ambarus@microchip.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Codrin.Ciubotariu@microchip.com>, <Cristian.Birsan@microchip.com>
Subject: Re: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node
 description
Thread-Topic: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node
 description
Thread-Index: AQHWCHML62OsZNg8VU2miyKNJtKsbKhljvEAgAANUoA=
Date:   Thu, 2 Apr 2020 10:07:43 +0000
Message-ID: <5f762bdc-fe07-adbc-af8d-7670b5b4b286@microchip.com>
References: <20200401221504.41196-1-ludovic.desroches@microchip.com>
 <b4fe14af-a812-8798-187e-704541a6a75f@microchip.com>
In-Reply-To: <b4fe14af-a812-8798-187e-704541a6a75f@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ludovic.Desroches@microchip.com; 
x-originating-ip: [109.210.131.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f2c0146-7ad5-495e-309c-08d7d6edaf83
x-ms-traffictypediagnostic: DM6PR11MB4548:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4548D2AA6EE3BF7158D37286EFC60@DM6PR11MB4548.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2777.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(366004)(39860400002)(396003)(136003)(346002)(91956017)(66556008)(31696002)(81166006)(76116006)(4326008)(81156014)(66476007)(186003)(66946007)(64756008)(8936002)(86362001)(66446008)(31686004)(6512007)(478600001)(8676002)(26005)(6506007)(107886003)(53546011)(54906003)(36756003)(71200400001)(2616005)(316002)(110136005)(2906002)(5660300002)(6486002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: agTtK3k9w0v5q5DOtDSxjp0caRBzEKGzClQh5X7AValvxjPzlmT+7OhZiMneA1Hon/3449aN/ddOpYF0BgRtujo9gE4bQkPYhVzVX2h9AtDTp45kU8fPYDxPEXfeksjVonkaLdjnh/wMu6PG4oxSPDGQjQAr3Wrn9jk9RTbiE9glZUDT3jDazcZvOG48nPEZa8T6zZnTR+TQ33QBKLZlXHQ/AReCm83u/raHVpNLOY1svwcJtXlyhMT9QS0Whxso5RRkG7OjZVAVacHaOUk6uwjYmtW0iTxINHP3G2WGXCpxUZbLETT6NJmeqQHA777bxYGMefoor23+nYyoC2Z6mmSEh9GVOvropvVnWQVkDTCMxAbS9/SFGkbOchZRlFaRgSkp0srNbuUHtyJZFSHIwHcGOyh5sC4lggcnncYmzvgdwOwsS0Vpg09utkx1+qow
x-ms-exchange-antispam-messagedata: LamDJTfUIdE+uVA+jrhgja2yavZa0po5Xs+M69GUyf0vbzvM7/IdlLNc4LhNHGDzl5+d6jnbbJQMpwIa9kkZBaX/FLNrhckHsC9BQtTOGepa2amILcgJWQPYYfp202TkSE+6RMaI3rkTfx0kBnHyhA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCB1BF68517C7F41994CBD4EB142EED8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2c0146-7ad5-495e-309c-08d7d6edaf83
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 10:07:43.4999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IvFukyciQ5VYh1EYVcxvspOVJB/ofLIzyAvdv1qb1rRyn7e5r+j9f3soaO3k3SoRCFcFwxomRrL7dttSu+x9w7ZfXrpJOF7SWoD8vmmBa24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4548
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNC8yLzIwMjAgMTE6MjAgQU0sIEV1Z2VuIEhyaXN0ZXYgLSBNMTgyODIgd3JvdGU6DQo+IE9u
IDAyLjA0LjIwMjAgMDE6MTUsIEx1ZG92aWMgRGVzcm9jaGVzIHdyb3RlOg0KPj4gUmVtb3ZlIG5v
bi1yZW1vdmFibGUgYW5kIG1tYy1kZHItMV84diBwcm9wZXJ0aWVzIGZyb20gdGhlIHNkbW1jMA0K
Pj4gbm9kZSB3aGljaCBjb21lIHByb2JhYmx5IGZyb20gYW4gdW5jaGVja2VkIGNvcHkvcGFzdGUu
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogTHVkb3ZpYyBEZXNyb2NoZXMgPGx1ZG92aWMuZGVzcm9j
aGVzQG1pY3JvY2hpcC5jb20+DQo+PiBGaXhlczo0MmVkNTM1NTk1ZWMgIkFSTTogZHRzOiBhdDkx
OiBpbnRyb2R1Y2UgdGhlIHNhbWE1ZDIgcHRjIGVrIGJvYXJkIg0KPj4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcgIyA0LjE5IGFuZCBsYXRlcg0KPj4gLS0tDQo+PiAgICBhcmNoL2FybS9ib290
L2R0cy9hdDkxLXNhbWE1ZDJfcHRjX2VrLmR0cyB8IDIgLS0NCj4+ICAgIDEgZmlsZSBjaGFuZ2Vk
LCAyIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2R0cy9h
dDkxLXNhbWE1ZDJfcHRjX2VrLmR0cyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9w
dGNfZWsuZHRzDQo+PiBpbmRleCAxYzI0YWM4MDE5YmE3Li43NzI4MDljNTRjMWYzIDEwMDY0NA0K
Pj4gLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQyX3B0Y19lay5kdHMNCj4+ICsr
KyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9wdGNfZWsuZHRzDQo+PiBAQCAtMTI1
LDggKzEyNSw2IEBAIHNkbW1jMDogc2Rpby1ob3N0QGEwMDAwMDAwIHsNCj4+ICAgIAkJCWJ1cy13
aWR0aCA9IDw4PjsNCj4+ICAgIAkJCXBpbmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7DQo+PiAgICAJ
CQlwaW5jdHJsLTAgPSA8JnBpbmN0cmxfc2RtbWMwX2RlZmF1bHQ+Ow0KPj4gLQkJCW5vbi1yZW1v
dmFibGU7DQo+PiAtCQkJbW1jLWRkci0xXzh2Ow0KPiANCj4gSGkgTHVkb3ZpYywNCj4gDQo+IEkg
YW0gbm90IHN1cmUgYWJvdXQgdGhlIHJlbW92YWwgb2YgbW1jLWRkci0xXzh2OyB0aGlzIG1lYW5z
IGVNTUNzDQo+IGNvbm5lY3RlZCBvbiB0aGlzIHNsb3Qgd29uJ3Qgd29yayBpbiBoaWdoIHNwZWVk
IG1vZGUsIHNvbWUgcGVvcGxlIHVzZQ0KPiBlTU1DIHRvIFNELUNhcmQgYWRhcHRlcnMgYW5kIHN0
aWNrIHRoZW0gaW50byBTRC1DYXJkIHNsb3RzLg0KPiBXb3VsZCBpdCBiZSBhIHByb2JsZW0gdG8g
a2VlcCB0aGlzIHByb3BlcnR5IGhlcmUgPw0KDQpIaSBFdWdlbiwNCg0KSXQncyBub3QgYSBwcm9i
bGVtIHRvIGtlZXAgaXQsIGJ1dCBJIGRvbid0IHRoaW5rIGl0IG1ha2VzIHNlbnNlLiBJbiB0aGlz
IA0KY2FzZSBtbWMtZGRyLTNfM3Ygc2hvdWxkIGJlIGFkZGVkIHRvby4NCg0KV2lsbCBpdCB3b3Jr
ICdvdXQgb2YgdGhlIGJveCcgd2l0aCBhbnkgZU1NQyB0byBTRC1DYXJkIGFkYXB0ZXJzIGFuZCAN
CmVNTUNzPyBJIHJlbWVtYmVyIGRpc2N1c3Npb25zIHdoZXJlIHdlIHNhaWQgSFcgY2hhbmdlcyB3
ZXJlIG5lZWRlZCB0byBiZSANCmFibGUgdG8gc2VsZWN0IHRoZSB2b2x0YWdlIGZvciB0aGUgSU9z
IG90aGVyIHRoYW4gdXNpbmcgdGhlIFZERFNFTCANCnNpZ25hbCBvZiB0aGUgY29udHJvbGxlci4N
Cg0KUmVnYXJkcw0KDQpMdWRvdmljDQoNCg0KPiANCj4gVGhhbmtzLA0KPiBFdWdlbg0KPiANCj4+
ICAgIAkJCXN0YXR1cyA9ICJva2F5IjsNCj4+ICAgIAkJfTsNCj4+ICAgIA0KPj4NCj4gDQoNCg==
