Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5B92E63D
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 22:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE2Ufk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 16:35:40 -0400
Received: from mail-eopbgr790110.outbound.protection.outlook.com ([40.107.79.110]:21178
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfE2Ufk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 16:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3oFy+oYdW9aJ/TQnqOCxCJ3xvE5EQo6R/TkY5C9Jps=;
 b=jcEYIgDU0KSss4CEG5l1p06eVFcPKuPXS2l/KLqqF95rX1vii5/jdheZ5/i5Npb4ttSNq3kSmX3BWZt5WlVhzMGitYfCLFYMDs7GdKB/H7wpN0Pg/+Hy/UEONrrv6Irs+9dfqgvSyH/CpQsCHnvFN0b0O5k7jYquYd/2tb1xaXc=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.174.162.17) by
 MWHPR2201MB1071.namprd22.prod.outlook.com (10.174.169.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Wed, 29 May 2019 20:35:32 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 20:35:32 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Paul Burton <pburton@wavecomp.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Kevin Hilman <khilman@baylibre.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: pistachio: Build uImage.gz by default
Thread-Topic: [PATCH] MIPS: pistachio: Build uImage.gz by default
Thread-Index: AQHVFXnH89+CQ67b4kKYpTCf9/D2IKaCkSkA
Date:   Wed, 29 May 2019 20:35:32 +0000
Message-ID: <MWHPR2201MB1277C6425EC8849644C11178C11F0@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190528172111.3843-1-paul.burton@mips.com>
In-Reply-To: <20190528172111.3843-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:24::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c66d7a8-9a52-48c0-80b4-08d6e47531c4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1071;
x-ms-traffictypediagnostic: MWHPR2201MB1071:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR2201MB107162E9B477673647E8EECBC11F0@MWHPR2201MB1071.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(376002)(39850400004)(136003)(199004)(189003)(54906003)(26005)(74316002)(6116002)(2906002)(66066001)(71200400001)(7736002)(52536014)(102836004)(5660300002)(25786009)(486006)(66476007)(66556008)(64756008)(66446008)(71190400001)(3846002)(476003)(11346002)(73956011)(305945005)(44832011)(186003)(66946007)(446003)(42882007)(81156014)(7696005)(76176011)(52116002)(478600001)(14454004)(53936002)(4326008)(256004)(6246003)(316002)(6862004)(33656002)(8936002)(229853002)(9686003)(8676002)(6436002)(966005)(6306002)(68736007)(6506007)(99286004)(55016002)(81166006)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1071;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qGcB6/dUmOLW6TzAjshTzEJZBWXhC2CoMF8JLHPlzTbJV0TXwzUk6QH124vF8RkK5r7KuLL8/pfPAc+v7PSyixzFi7dmwbjxtn/YDvZSIZX3TIjD4Js33XoQOIvgrklMH0m7+aQ7uoUNpLqtjKoupD8/D7MsY+1V5DMkp0aW3ZC4NZXCPnRwtpGzqXHiF+udRN8x7VFR81nIiUuH5l9oqQl0D0L0tZda5/InldY6idHhgZ3zE7UjHrpSYiCjkkA/q63QXKFTZ/yulhdCTWIHzaVA5/sZmgPn3I/dQRm0k98HtrAUuKLZTXXerBLGQTiDl9y+mE8/Ju4byQcZ6rTFNIfH4tsorCS7EHUdNPfTrW6X269tPYNerxqaYmWn17DGAYeXFkw3D//ynifnRoWoacy5Ce9SUVKDylNCFBtosSU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c66d7a8-9a52-48c0-80b4-08d6e47531c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 20:35:32.1265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNClBhdWwgQnVydG9uIHdyb3RlOg0KPiBUaGUgcGlzdGFjaGlvIHBsYXRmb3JtIHVz
ZXMgdGhlIFUtQm9vdCBib290bG9hZGVyICYgZ2VuZXJhbGx5IGJvb3RzIGENCj4ga2VybmVsIGlu
IHRoZSB1SW1hZ2UgZm9ybWF0LiBBcyBzdWNoIGl0J3MgdXNlZnVsIHRvIGJ1aWxkIG9uZSB3aGVu
DQo+IGJ1aWxkaW5nIHRoZSBrZXJuZWwsIGJ1dCB0byBkbyBzbyBjdXJyZW50bHkgcmVxdWlyZXMg
dGhlIHVzZXIgdG8NCj4gbWFudWFsbHkgc3BlY2lmeSBhIHVJbWFnZSB0YXJnZXQgb24gdGhlIG1h
a2UgY29tbWFuZCBsaW5lLg0KPiANCj4gTWFrZSB1SW1hZ2UuZ3ogdGhlIHBpc3RhY2hpbyBwbGF0
Zm9ybSdzIGRlZmF1bHQgYnVpbGQgdGFyZ2V0LCBzbyB0aGF0DQo+IHRoZSBkZWZhdWx0IGlzIHRv
IGJ1aWxkIGEga2VybmVsIGltYWdlIHRoYXQgd2UgY2FuIGFjdHVhbGx5IGJvb3Qgb24gYQ0KPiBi
b2FyZCBzdWNoIGFzIHRoZSBNSVBTIENyZWF0b3IgQ2k0MC4NCj4gDQo+IE1hcmtlZCBmb3Igc3Rh
YmxlIGJhY2twb3J0IGFzIGZhciBhcyB2NC4xIHdoZXJlIHBpc3RhY2hpbyBzdXBwb3J0IHdhcw0K
PiBpbnRyb2R1Y2VkLiBUaGlzIGlzIHByaW1hcmlseSB1c2VmdWwgZm9yIENJIHN5c3RlbXMgc3Vj
aCBhcyBrZXJuZWxjaS5vcmcNCj4gd2hpY2ggd2lsbCBiZW5lZml0IGZyb20gdXMgYnVpbGRpbmcg
YSBzdWl0YWJsZSBpbWFnZSB3aGljaCBjYW4gdGhlbiBiZQ0KPiBib290ZWQgYXMgcGFydCBvZiBh
dXRvbWF0ZWQgdGVzdGluZywgZXh0ZW5kaW5nIG91ciB0ZXN0IGNvdmVyYWdlIHRvIHRoZQ0KPiBh
ZmZlY3RlZCBzdGFibGUgYnJhbmNoZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYXVsIEJ1cnRv
biA8cGF1bC5idXJ0b25AbWlwcy5jb20+DQo+IFJldmlld2VkLWJ5OiBLZXZpbiBIaWxtYW4gPGto
aWxtYW5AYmF5bGlicmUuY29tPg0KPiBUZXN0ZWQtYnk6IEtldmluIEhpbG1hbiA8a2hpbG1hbkBi
YXlsaWJyZS5jb20+DQo+IFVSTDogaHR0cHM6Ly9ncm91cHMuaW8vZy9rZXJuZWxjaS9tZXNzYWdl
LzM4OA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY0LjErDQo+IFJldmlld2VkLWJ5
OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDg8KpIDxmNGJ1Z0BhbXNhdC5vcmc+DQoNCkFwcGxpZWQg
dG8gbWlwcy1maXhlcy4NCg0KVGhhbmtzLA0KICAgIFBhdWwNCg0KWyBUaGlzIG1lc3NhZ2Ugd2Fz
IGF1dG8tZ2VuZXJhdGVkOyBpZiB5b3UgYmVsaWV2ZSBhbnl0aGluZyBpcyBpbmNvcnJlY3QNCiAg
dGhlbiBwbGVhc2UgZW1haWwgcGF1bC5idXJ0b25AbWlwcy5jb20gdG8gcmVwb3J0IGl0LiBdDQo=
