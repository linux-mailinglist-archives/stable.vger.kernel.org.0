Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA0A1F612
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfEON4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 09:56:52 -0400
Received: from mail-eopbgr780054.outbound.protection.outlook.com ([40.107.78.54]:8883
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbfEON4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 09:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu7TxdjWrUtbYdwbYkCOV/k5XVlz0gZ47S8VZtELt9s=;
 b=COBA8uNRD3ktjiv9v4ujLjXFP4KZD1NSmRBUE8ZWVQFHgwHWa1Z4X4HELrPsr7ogcutJquDmweGzrp0+OkWvRRgDoGaBVTGkvsqhL/WJMmoPq/71R9YSCD4aZkn+z7oQKQPv2KRq2sxm6pCGnyDbJhQQ9e8YAUPwsbliBYtFKBU=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3531.namprd11.prod.outlook.com (20.177.220.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 13:56:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 13:56:47 +0000
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
Thread-Index: AQHVCyYELfi8Y6EzMUWYboZEUlmuhw==
Date:   Wed, 15 May 2019 13:56:47 +0000
Message-ID: <583de1c8-585c-e656-6251-84b6e563af42@aquantia.com>
References: <20190515090616.670410738@linuxfoundation.org>
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0265.eurprd05.prod.outlook.com
 (2603:10a6:3:fc::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aabe77b7-4c99-4b75-2e82-08d6d93d2bfc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3531;
x-ms-traffictypediagnostic: DM6PR11MB3531:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR11MB35319BCDBB9922905628EFE398090@DM6PR11MB3531.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39850400004)(199004)(189003)(6246003)(316002)(256004)(81166006)(4326008)(6506007)(386003)(68736007)(71190400001)(8936002)(6306002)(6512007)(5660300002)(110136005)(54906003)(2906002)(52116002)(71200400001)(31696002)(86362001)(81156014)(25786009)(99286004)(102836004)(4744005)(36756003)(53546011)(186003)(31686004)(6116002)(3846002)(26005)(486006)(476003)(2616005)(11346002)(446003)(53936002)(66476007)(66556008)(66946007)(66446008)(73956011)(64756008)(2501003)(478600001)(6486002)(8676002)(966005)(229853002)(14454004)(6436002)(305945005)(44832011)(66066001)(7736002)(72206003)(7416002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3531;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jlaukTdMgqR/qXRRJhpa7ZOF/DFXeTpvsOxauruFe14F7UqpBSWFLCcoEVJH8BZDZO9GcpAKmTk8yde+iJUCdlXJydTs3kVXZBxrXKO7O2fqceDVKJ10+05xni0Kkxzsxh33OcX13PSJSm3Dt0QimdLQGbv6SWS0nk2E8NA03qxSJVRFDkOXn/leBV8WAaFR1HasMTsKfI1OJNRSrW9+s3b3A7V3s+wR5odOUT+XpzZcGiYbrVJR3UvmxBnPpO7j2ECZu+YCrWguostUIBOOlKpx0xeKuqJaMFEEfcPxeICQFUHvUgR4uZ8Qnq+L+FegiItaL80RJTpEctsZ8wQE6OMmN7sM8uAzqjlwFi1Aztw6AzowXXFegduSswAvU3Kk0ptprFc38p5I8Fj7M5rrsW0DIh3JOH2hEE0lw2HCGEg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C46F7130C7BBD34A9AB554D52923C2C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabe77b7-4c99-4b75-2e82-08d6d93d2bfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 13:56:47.7091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3531
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDE1LjA1LjIwMTkgMTM6NTYsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gVGhp
cyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA1LjEuMyBy
ZWxlYXNlLg0KPiBUaGVyZSBhcmUgNDYgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwg
YmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFu
eSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cu
DQoNCi4uLg0KDQo+IE9saXZlciBOZXVrdW0gPG9uZXVrdW1Ac3VzZS5jb20+DQo+ICAgICBhcWMx
MTE6IGZpeCBkb3VibGUgZW5kaWFubmVzcyBzd2FwIG9uIEJFDQo+IA0KPiBPbGl2ZXIgTmV1a3Vt
IDxvbmV1a3VtQHN1c2UuY29tPg0KPiAgICAgYXFjMTExOiBmaXggd3JpdGluZyB0byB0aGUgcGh5
IG9uIEJFDQo+IA0KPiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPg0KPiAgICAgYXFj
MTExOiBmaXggZW5kaWFubmVzcyBpc3N1ZSBpbiBhcWMxMTFfY2hhbmdlX210dQ0KDQpIZWxsbyBH
cmVnLA0KDQpDb3VsZCB5b3UgcGxlYXNlIGRyb3AgdGhlc2UgdGhyZWUgcGF0Y2hlcyBmcm9tIHRo
ZSBxdWV1ZT8NClRoZXkgYXJlIGludmFsaWQgYW5kIHdpbGwgYmUgcmV2ZXJ0ZWQgaW4gbmV0IHRy
ZWUuDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8xNTU3ODM5NjQ0LjExMjYxLjQu
Y2FtZWxAc3VzZS5jb20vDQoNClRoYW5rcywNCiAgSWdvcg0K
