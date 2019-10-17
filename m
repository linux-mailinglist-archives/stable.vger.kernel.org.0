Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9A3DA929
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 11:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393734AbfJQJtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 05:49:35 -0400
Received: from mail-eopbgr00111.outbound.protection.outlook.com ([40.107.0.111]:36430
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408604AbfJQJte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 05:49:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwC5W+z0DZ0LWyvVd3hbhu7jR67LHUXmUz8xJRDLb6ZCrr9pgvHqYGfzCNot2EPV6C7Izqb8UI7ZNh3TzCCtE+qlMrKgIQxUmUukULjb4tNJdvzFEpdsrgmy/VBUbrsbtl0cAjfdLqZo8Qp+AT1v2pf5gCgrLdNPa+hyhn7JsxSd/NYDTMoYMf5CT3+t7ZouhnDBW2Gt+naEFepwHd4Xi1cYkc+DYQKJBmg8Vs6H9CeGkVgVzcqz3VvW9QInpYG8NxLUWbqoB3r7MiVdadt5kZSA01iPDJbuF7uCdTNyc6kFfK8SZqDB7Vflhji6D5ptYfFhnJxdltY1Vx6EJ0U+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzWGnT4TnrM9aYvkdn87wU1dHZ/J0gIwvBS8ewwQ2vQ=;
 b=cK2EdCSV51RlD+mGaqY2G04LXq2PtPZnpVNF9Ed/NWXujLOrS/6AM5qiGy+aJD1/8hE1lEqdyyXo9HFnzU2xglrRYVNtmSRuJcs4oDyH6ZPYMqqMrn7B9DoWrdEhMJWcMhyftYDRBMZY9M84tw3jxXPUkfe0CU4/3MegMYbPZG708xEkxwiR8SC1jZU9KaMCR22H2ZP4Zd8r70DaMcjZL5bqjT6ougD2Cjq8ZUpc3Fr6wKiICR/FaFkGov7O5Y3gUZEdObQ7So+ZmXDe3ESyPKWICFg5/Zvuk9aWWBW4m7uWgJlIvsQEoPO97LnsEflJ6lRP/uOzthYHtsEgFvOUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzWGnT4TnrM9aYvkdn87wU1dHZ/J0gIwvBS8ewwQ2vQ=;
 b=DReowP9PrA6jyPpG9nM2S7ihKlXFmNqM7aN2DeerjY15gbzEyoecnXLZ1k4/glj9Vt14nL7rlxe/vHnzKQzmYQqSbpd3Xe8ENijcbyAwwZPEgMvMAXt7dDDdehpFCE9oDum1Hy9Y1UgTl6hS9YKJbhBN+Vu9DjCgKBr+WqIgQbw=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.212) by
 AM6PR05MB5752.eurprd05.prod.outlook.com (20.178.93.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 09:49:29 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35%5]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 09:49:29 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: Fw: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Thread-Topic: Fw: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Thread-Index: AQHVhG0Ij7c91vwKuUSFHKdUuJ/EO6dd0XYAgAACtYCAAAbzAIAADZkAgACmrgCAAAL9b4AABQSA
Date:   Thu, 17 Oct 2019 09:49:27 +0000
Message-ID: <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk> <20191016221025.GA990599@kroah.com>
 <20191016223518.GC11473@sirena.co.uk> <20191016232358.GA994597@kroah.com>
 <de9630e5-341f-b48d-029a-ef1a516bf820@skidata.com>
 <AM6PR05MB653568E379699EE907E146BDF96D0@AM6PR05MB6535.eurprd05.prod.outlook.com>
In-Reply-To: <AM6PR05MB653568E379699EE907E146BDF96D0@AM6PR05MB6535.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:208:fc::14) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:74::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXFxm2q5WyUVTnxMM8xw52UMqOjUTRMOKwrhkQOY9w9jLu7dSRu
        Xqk4T+0LsFXaZ8DUKsVEsz+OMZyWKoWqQUyLmLc=
x-google-smtp-source: APXvYqyH2ppRmiq9VrxhsH6fAnFBjlgOAv2elKu6LcbUoPIPKIb6dF6A//QqAEa/PGft7UANMmORAJAPcWmAICBzP6w=
x-received: by 2002:a0c:ff2a:: with SMTP id x10mr2955793qvt.44.1571305763269;
 Thu, 17 Oct 2019 02:49:23 -0700 (PDT)
x-gmail-original-message-id: <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
x-originating-ip: [209.85.160.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f11cd712-64ca-421f-5ffc-08d752e74c75
x-ms-traffictypediagnostic: AM6PR05MB5752:
x-microsoft-antispam-prvs: <AM6PR05MB57526397B29089062F7DDA50F96D0@AM6PR05MB5752.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(136003)(366004)(39850400004)(51914003)(199004)(189003)(54906003)(95326003)(5660300002)(478600001)(186003)(14454004)(316002)(110136005)(2906002)(71190400001)(14444005)(86362001)(256004)(71200400001)(25786009)(6116002)(3846002)(11346002)(8676002)(8936002)(66066001)(55446002)(305945005)(66476007)(64756008)(52116002)(386003)(498394004)(6506007)(7736002)(81166006)(99286004)(61266001)(102836004)(26005)(53546011)(55236004)(450100002)(81156014)(107886003)(6246003)(76176011)(9686003)(446003)(476003)(486006)(229853002)(6486002)(44832011)(6512007)(66946007)(6436002)(66446008)(4326008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5752;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1cC6s2aAIjXeh4AcWBs2CL3bTovSul/TXytXgLTEG2y83yVaP0mJDV5aYvQe9PDzZ8KJPXngfKrLhXsvB3QdfoZJQKn/qip/0md/OIQTAalPEYNrIXhd23DiCni9beywSyBCNWroCcOgVqvMX8Wj5CKFrsrfaCX/Q85K3fTPAh6LJeiS4ifyq22nnXTnw7vC4rnCq3Jng2/W4QivfC2RAfEydnheGm+kNg+kYarsNAjCyDdp0RSJYFGQPjGE7iOlFEnQtHrqXmqf9Fo1OYn4tZhkIEjdmzk4EeSASlT5saDpKr+wAMwGbh1Sw9mhoxpSpoMOqyOFaAmafOYfTumRaHQaVTk0f30KqzlkM4Ej3oEz45HXM2UI1wZSZBP9wA4BfFpuaYyjl4xLgzdLupZwQmjnYJoYArJGh6IQUORn1c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5938ED5D0A95C44D9EE88C6C6FBA92D2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11cd712-64ca-421f-5ffc-08d752e74c75
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 09:49:27.1347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kYRA6FV/n5wade9sGxK4U+jO44+eqgfW5WY6Cue23x1If1TCBimeuFABdxLIjjj0OpBodnIBROieJW6hAF2UPGkN2y4YiZa/mtkMPF8betE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5752
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPbiAxNy8xMC8yMDE5IDAxOjIzLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+ID4gT24g
V2VkLCBPY3QgMTYsIDIwMTkgYXQgMTE6MzU6MThQTSArMDEwMCwgTWFyayBCcm93biB3cm90ZToN
Cj4gPj4gT24gV2VkLCBPY3QgMTYsIDIwMTkgYXQgMDM6MTA6MjVQTSAtMDcwMCwgR3JlZyBLcm9h
aC1IYXJ0bWFuIHdyb3RlOg0KPiA+Pj4gT24gV2VkLCBPY3QgMTYsIDIwMTkgYXQgMTE6MDA6NDRQ
TSArMDEwMCwgTWFyayBCcm93biB3cm90ZToNCj4gPj4+PiBPbiBXZWQsIE9jdCAxNiwgMjAxOSBh
dCAwMjo1MTo0NFBNIC0wNzAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+ID4+Pj4+IEZy
b206IE9sZWtzYW5kciBTdXZvcm92IDxvbGVrc2FuZHIuc3V2b3JvdkB0b3JhZGV4LmNvbT4NCj4g
Pj4NCj4gPj4+Pj4gY29tbWl0IDY5NGIxNDU1NGQ3NWYyYTFhZTExMTIwMmU3MTg2MGQ1OGI0MzRh
MjEgdXBzdHJlYW0uDQo+ID4+DQo+ID4+Pj4+IFRoaXMgY29udHJvbCBtdXRlL3VubXV0ZSB0aGUg
QURDIGlucHV0IG9mIFNHVEw1MDAwDQo+ID4+Pj4+IHVzaW5nIGl0cyBDSElQX0FOQV9DVFJMIHJl
Z2lzdGVyLg0KPiA+Pg0KPiA+Pj4+IFRoaXMgc2VlbXMgbGlrZSBhIG5ldyBmZWF0dXJlIGFuZCBu
b3QgYW4gb2J2aW91cyBjYW5kaWRhdGUgZm9yIHN0YWJsZT8NCj4gPj4NCj4gPj4+IHRoZXJlIHdh
cyBhIGxvbmcgZW1haWwgZnJvbSBSaWNoYXJkIHRoYXQgc2FpZDoNCj4gPj4+ICAgICBVcHN0cmVh
bSBjb21taXQgNjMxYmM4ZjAxMzRhICgiQVNvQzogc2d0bDUwMDA6IEZpeCBvZiB1bm11dGUNCj4g
Pj4+ICAgICBvdXRwdXRzIG9uIHByb2JlIiksIHdoaWNoIGlzIGU5ZjYyMWVmYWViZCBpbiB2NS4z
IHJlcGxhY2VkDQo+ID4+PiAgICAgc25kX3NvY19jb21wb25lbnRfd3JpdGUgd2l0aCBzbmRfc29j
X2NvbXBvbmVudF91cGRhdGVfYml0cyBhbmQNCj4gPj4+ICAgICB0aGVyZWZvcmUgbm8gbG9uZ2Vy
IGNsZWFyZWQgdGhlIE1VVEVfQURDIGZsYWcuIFRoaXMgY2F1c2VkIHRoZQ0KPiA+Pj4gICAgIEFE
QyB0byBzdGF5IG11dGVkIGFuZCByZWNvcmRpbmcgZG9lc24ndCB3b3JrIGFueSBsb25nZXIuIFRo
aXMNCj4gPj4+ICAgICBwYXRjaCBmaXhlcyB0aGlzIHByb2JsZW0gYnkgYWRkaW5nIGEgU3dpdGNo
IGNvbnRyb2wgZm9yDQo+ID4+PiAgICAgTVVURV9BREMuDQo+ID4+DQo+ID4+PiBUaGF0J3Mgd2h5
IEkgdG9vayB0aGlzLiAgSWYgdGhpcyBpc24ndCB0cnVlLCBJJ2xsIGJlIGdsYWQgdG8gZHJvcCB0
aGlzLg0KPiA+Pg0KPiA+PiBUaGF0J3MgcHJvYmFibHkgbm90IGFuIGFwcHJvcHJpYXRlIGZpeCBm
b3Igc3RhYmxlIC0gaXQncyBnb2luZyB0byBhZGQgYQ0KPiA+PiBuZXcgY29udHJvbCB3aGljaCB1
c2VycyB3aWxsIG5lZWQgdG8gbWFudWFsbHkgc2V0IChvciBob3BlIHRoZWlyDQo+ID4+IHVzZXJz
cGFjZSBhdXRvbWF0aWNhbGx5IGZpZ3VyZXMgb3V0IHRoYXQgaXQgc2hvdWxkIHNldCBmb3IgdGhl
bSwgbW9yZQ0KPiA+PiBhZHZhbmNlZCB1c2Vyc3BhY2VzIGxpa2UgUHVsc2VBdWRpbyBzaG91bGQp
IHdoaWNoIGlzbid0IGEgZHJvcCBpbiBmaXguDQo+ID4+IFlvdSBjb3VsZCBlaXRoZXIgZHJvcCB0
aGUgYmFja3BvcnQgdGhhdCB3YXMgZG9uZSBmb3IgemVybyBjcm9zcyBvciB0YWtlDQo+ID4+IGEg
bmV3IHBhdGNoIHRoYXQgY2xlYXJzIHRoZSBNVVRFX0FEQyBmbGFnIChyYXRoZXIgdGhhbiBwdW50
aW5nIHRvDQo+ID4+IHVzZXJzcGFjZSB0byBkbyBzbyksIG9yIGp1c3QgYmUgT0sgd2l0aCB3aGF0
IHlvdSd2ZSBnb3QgYXQgdGhlIG1pbnV0ZQ0KPiA+PiB3aGljaCBtaWdodCBiZSBmaW5lIGdpdmVu
IHRoZSBsYWNrIG9mIHVzZXIgcmVwb3J0cy4NCg0KTWFyaywgb2J2aW91c2x5IHRoaXMgaXMgbm90
IGEgTkVXIGZlYXR1cmUuIFRoaXMgcGF0Y2ggYWRkcyBMT1NUDQpzdGFuZGFyZCBjb250cm9sLg0K
DQpQbGVhc2UgbG9vayBpbnRvIG90aGVyIGNvZGVjczoNCg0KJCBncmVwIC1SICdTT0NfU0lOR0xF
KCJDYXB0dXJlIFN3aXRjaCInIHNvdW5kL3NvYy8NCnNvdW5kL3NvYy9jb2RlY3Mvc2d0bDUwMDAu
Yy5vcmlnOiBTT0NfU0lOR0xFKCJDYXB0dXJlIFN3aXRjaCIsDQpTR1RMNTAwMF9DSElQX0FOQV9D
VFJMLCAwLCAxLCAxKSwNCnNvdW5kL3NvYy9jb2RlY3Mvd205NzA1LmM6IFNPQ19TSU5HTEUoIkNh
cHR1cmUgU3dpdGNoIiwgQUM5N19SRUNfR0FJTiwNCjE1LCAxLCAxKSwNCnNvdW5kL3NvYy9jb2Rl
Y3Mvd205NzEzLmM6U09DX1NJTkdMRSgiQ2FwdHVyZSBTd2l0Y2giLCBBQzk3X0NELCAxNSwgMSwg
MSksDQpzb3VuZC9zb2MvY29kZWNzL3dtOTcxMi5jOlNPQ19TSU5HTEUoIkNhcHR1cmUgU3dpdGNo
IiwgQUM5N19SRUNfR0FJTiwgMTUsIDEsIDEpLA0KDQpBbmQgZXZlbjoNCg0KJCBncmVwIC1SICdT
T0NfU0lOR0xFKCIuKkNhcHR1cmUgU3dpdGNoIicgc291bmQvc29jLw0Kc291bmQvc29jL2NvZGVj
cy9sbTQ5NDUzLmM6IFNPQ19TSU5HTEUoIlBvcnQxIENhcHR1cmUgU3dpdGNoIiwNCkxNNDk0NTNf
UDBfQVVESU9fUE9SVDFfQkFTSUNfUkVHLA0Kc291bmQvc29jL2NvZGVjcy9sbTQ5NDUzLmM6IFNP
Q19TSU5HTEUoIlBvcnQyIENhcHR1cmUgU3dpdGNoIiwNCkxNNDk0NTNfUDBfQVVESU9fUE9SVDJf
QkFTSUNfUkVHLA0Kc291bmQvc29jL2NvZGVjcy9zZ3RsNTAwMC5jLm9yaWc6IFNPQ19TSU5HTEUo
IkNhcHR1cmUgU3dpdGNoIiwNClNHVEw1MDAwX0NISVBfQU5BX0NUUkwsIDAsIDEsIDEpLA0Kc291
bmQvc29jL2NvZGVjcy9tYzEzNzgzLmM6IFNPQ19TSU5HTEUoIkxpbmUgaW4gQ2FwdHVyZSBTd2l0
Y2giLA0KTUMxMzc4M19BVURJT19SWDEsIDEwLCAxLCAwKSwNCnNvdW5kL3NvYy9jb2RlY3MvYWs0
NjQyLmM6IFNPQ19TSU5HTEUoIkFMQyBDYXB0dXJlIFN3aXRjaCIsIEFMQ19DVEwxLCA1LCAxLCAw
KSwNCnNvdW5kL3NvYy9jb2RlY3MvYWRhdTE3MDEuYzogU09DX1NJTkdMRSgiTWFzdGVyIENhcHR1
cmUgU3dpdGNoIiwNCkFEQVUxNzAxX0RTUENUUkwsIDQsIDEsIDApLA0Kc291bmQvc29jL2NvZGVj
cy9hbGM1NjMyLmM6IFNPQ19TSU5HTEUoIkRNSUMgRW4gQ2FwdHVyZSBTd2l0Y2giLA0Kc291bmQv
c29jL2NvZGVjcy9hbGM1NjMyLmM6IFNPQ19TSU5HTEUoIkRNSUMgUHJlRmlsdGVyIENhcHR1cmUg
U3dpdGNoIiwNCnNvdW5kL3NvYy9jb2RlY3Mvd205NzA1LmM6IFNPQ19TSU5HTEUoIkNhcHR1cmUg
U3dpdGNoIiwgQUM5N19SRUNfR0FJTiwNCjE1LCAxLCAxKSwNCnNvdW5kL3NvYy9jb2RlY3MvYWRh
dTE5NzcuYzogU09DX1NJTkdMRSgiQURDIiAjeCAiIEhpZ2hwYXNzLUZpbHRlcg0KQ2FwdHVyZSBT
d2l0Y2giLCBcDQpzb3VuZC9zb2MvY29kZWNzL2FkYXUxOTc3LmM6IFNPQ19TSU5HTEUoIkFEQyIg
I3ggIiBEQyBTdWJ0cmFjdGlvbg0KQ2FwdHVyZSBTd2l0Y2giLCBcDQpzb3VuZC9zb2MvY29kZWNz
L2lzYWJlbGxlLmM6IFNPQ19TSU5HTEUoIlVMQVRYMTIgQ2FwdHVyZSBTd2l0Y2giLA0KSVNBQkVM
TEVfVUxBVFgxMl9JTlRGX0NGR19SRUcsDQpzb3VuZC9zb2MvY29kZWNzL2FkMTk4MC5jOlNPQ19T
SU5HTEUoIlBDTSBDYXB0dXJlIFN3aXRjaCIsDQpBQzk3X1JFQ19HQUlOLCAxNSwgMSwgMSksDQpz
b3VuZC9zb2MvY29kZWNzL2FkMTk4MC5jOlNPQ19TSU5HTEUoIlBob25lIENhcHR1cmUgU3dpdGNo
IiwNCkFDOTdfUEhPTkUsIDE1LCAxLCAxKSwNCnNvdW5kL3NvYy9jb2RlY3Mvd204NzMxLmM6U09D
X1NJTkdMRSgiTWljIENhcHR1cmUgU3dpdGNoIiwNCldNODczMV9BUEFOQSwgMSwgMSwgMSksDQpz
b3VuZC9zb2MvY29kZWNzL3VkYTEzODAuYzovKiovIFNPQ19TSU5HTEUoIkFEQyBDYXB0dXJlIFN3
aXRjaCIsDQpVREExMzgwX1BHQSwgMTUsIDEsIDEpLCAvKiBNVF9BREMgKi8NCnNvdW5kL3NvYy9j
b2RlY3Mvd205NzEzLmM6U09DX1NJTkdMRSgiQ2FwdHVyZSBTd2l0Y2giLCBBQzk3X0NELCAxNSwg
MSwgMSksDQpzb3VuZC9zb2MvY29kZWNzL2VzODMxNi5jOiBTT0NfU0lOR0xFKCJBTEMgQ2FwdHVy
ZSBTd2l0Y2giLA0KRVM4MzE2X0FEQ19BTEMxLCA2LCAxLCAwKSwNCnNvdW5kL3NvYy9jb2RlY3Mv
c2d0bDUwMDAuYzogU09DX1NJTkdMRSgiQ2FwdHVyZSBTd2l0Y2giLA0KU0dUTDUwMDBfQ0hJUF9B
TkFfQ1RSTCwgMCwgMSwgMSksDQpzb3VuZC9zb2MvY29kZWNzL3RsdjMyMGFpYzMxeHguYzogU09D
X1NJTkdMRSgiQURDIENhcHR1cmUgU3dpdGNoIiwNCkFJQzMxWFhfQURDRkdBLCA3LCAxLCAxKSwN
CnNvdW5kL3NvYy9jb2RlY3MvZGE3MjEwLmM6IFNPQ19TSU5HTEUoIkF1eDIgQ2FwdHVyZSBTd2l0
Y2giLA0KREE3MjEwX0FVWDIsIDIsIDEsIDApLA0Kc291bmQvc29jL2NvZGVjcy93bTk3MTIuYzpT
T0NfU0lOR0xFKCJDYXB0dXJlIFN3aXRjaCIsIEFDOTdfUkVDX0dBSU4sIDE1LCAxLCAxKSwNCg0K
Z2l0IGJsYW1lIHNvdW5kL3NvYy9jb2RlY3Mvd205NzA1LmMNCi4uLg0KOTI3YjBhZWE5M2JiMyAo
SWFuIE1vbHRvbiAgICAgICAgIDIwMDktMDEtMTkgMTc6MjM6MTEgKzAwMDAgIDg3KQ0KIFNPQ19T
SU5HTEUoIkNhcHR1cmUgU3dpdGNoIiwgQUM5N19SRUNfR0FJTiwgMTUsIDEsIDEpLA0KLi4uDQoN
ClRoaXMgY29udHJvbCB3YXMgYWRkZWQgbm90IGxhdGVyIHRoYW4gMjAwOSwgc28gSSBkb3VidCBt
eSBwYXRjaCBjb3VsZA0KYnJlYWsgc29tZXRoaW5nIGluIGN1cnJlbnQgdXNlci1sYW5kLg0KDQo+
ID4NCj4gPiBPaywgSSdsbCBnbGFkbHkgZ28gZHJvcCBpdCwgdGhhbmtzIQ0KPg0KPiBNYXJrLCB0
aGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uISBJIGhhdmVuJ3QgdGhvdWdodCBvZiBicmVha2lu
Zw0KPiBhbnl0aGluZyB3aXRoIHRoZSBiYWNrcG9ydCBhcyBpdCB3b3JrZWQgZmluZSBmb3Igb3Vy
IGFwcGxpY2F0aW9uLg0KDQotLSANCkJlc3QgcmVnYXJkcw0KT2xla3NhbmRyIFN1dm9yb3YNCg0K
VG9yYWRleCBBRw0KQWx0c2FnZW5zdHJhc3NlIDUgfCA2MDQ4IEhvcncvTHV6ZXJuIHwgU3dpdHpl
cmxhbmQgfCBUOiArNDEgNDEgNTAwDQo0ODAwIChtYWluIGxpbmUpDQo=
