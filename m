Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1717F1926FD
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 12:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCYLWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 07:22:32 -0400
Received: from mail-eopbgr130100.outbound.protection.outlook.com ([40.107.13.100]:40099
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbgCYLWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 07:22:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7BYoPJMQUJMX1y1HUKMNVj1PwG7M3DU1eoUoz+r32L6QrVzOtzG5cQyFHjMieWXy9UEopTEoNjFs39DSV7/EgUHTA/yQ/nVUyJ9U+/4HIRz1bFgLAICYCCE17G9nemcsBiugZqXzSAA4LbWMnoS39uKeze8pPkCpR0ZAAl145kvwulC0JWz2R6tVIlIQAC+bgKUR9JfKdI6wKeUlk00uI3bfJ7pHL4BbqirsaE079PWURM9tbMKOFGd+MFv3zZ+V2bYo3/BC3D4jXW5G7SRsUhjAHcKOIvuB6tBv0gFc585xZp2ZX77iqabxHP6kBNDYhrqcXi5bHGUjRH2MXitjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAlhFVNxKwfPwyBRDLdlaO0pKz1aMQ4CGcpFFAXpIvQ=;
 b=XmWHQcjE2TFghExaqlKgTfxbDRAki5dN250BeOo46ua0/NQHvP/Qx8AZPCzTUH+5yRg9RZLUS1h6aZKi4uHESRoXeOZu1AC2eVtZHyPlDd2P0nM6G0hqOwPUNqaBr0f9AFj6hMusdsDFpcIRf3xTBVNZsgcFwyA6K0f+ROmRm0HCD+Eu8M+7jdX3HTeFJKREmw+deibwySpZpPcM5KnvEMscfxUfC0WFj0QWz9qGA5MNvrJRZdjD76vV7iTUAFqQg/cJmeAogM6at2EFxdFTdKjH0tCkd6d5s8yGSoX9IAawMiG8Hz3NqE5WPZnBWY96OoDFmx82b9ZX/yW62lE+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAlhFVNxKwfPwyBRDLdlaO0pKz1aMQ4CGcpFFAXpIvQ=;
 b=xdu79fd0bev1DBgcE4E52eQ1hMaeZnp0q2JtrBBAqdWKKy1FNgNfDbfSPcbUkDBmoDn1e206AyQkshU6n13otV49VDNF6nxs3fEc49bJv4I+WQzAWlMlFVIjsMFAJeCgdy6qNVxdD9SDlxn7QYCkJyRfwr8iQW260XBup7kLHYs=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3596.eurprd07.prod.outlook.com (52.133.6.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.9; Wed, 25 Mar 2020 11:22:26 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2856.017; Wed, 25 Mar 2020
 11:22:26 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "snitzer@redhat.com" <snitzer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "osandov@fb.com" <osandov@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>
Subject: Re: 4.19 LTS high /proc/diskstats io_ticks
Thread-Topic: 4.19 LTS high /proc/diskstats io_ticks
Thread-Index: AQHWAoyFep1pzs45BEyxl7dts+ZHIKhZFVEAgAAU54A=
Date:   Wed, 25 Mar 2020 11:22:26 +0000
Message-ID: <8b876ed9753478764bf5ea74d00b3d54c381b9f2.camel@nokia.com>
References: <564f7f3718cdc85f841d27a358a43aee4ca239d6.camel@nokia.com>
         <20200325100736.GA3083079@kroah.com>
In-Reply-To: <20200325100736.GA3083079@kroah.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7aa42ba9-b73d-42f2-9f06-08d7d0aecc45
x-ms-traffictypediagnostic: HE1PR0702MB3596:
x-microsoft-antispam-prvs: <HE1PR0702MB35965B81AD42A8736D0634BDB4CE0@HE1PR0702MB3596.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(6512007)(36756003)(5660300002)(76116006)(2906002)(66446008)(66476007)(64756008)(66556008)(66946007)(966005)(86362001)(6486002)(478600001)(81166006)(81156014)(8676002)(8936002)(6916009)(316002)(2616005)(71200400001)(4326008)(186003)(26005)(54906003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3596;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IoXZq0o7PqdtvPD1SPceP14vhTUmF54GfzvZYJUEBm3IFIlnnMpAkF+ypHx2dw8wFo0ComB6hJH7YVPvf2qBfkz1T88aKeQqrRC93qdNvXa+eikQC1Yh/7OVdVNVJ/3BNk5J/cTXnMlcPC91rP2ckYjytHXyHmBr5XXg4XudFdLajsJWYqhUGC+TCDp8SK3AoLCwWWVBsw2+bYhk0y7w1oDPHYDYXB8DDMqNDhxQn0Jo/IDT9cSZQ41TqaRfXG4LPJHVNRoUh/z3I5D81kNIV4mEvswHsBmkI5ggvScKj7fI/Mkwa40fc90lnMoKi/ANaLH3fcXG5gA3pihgEGjV/J/RB69nlxBetVTW0gahQnvPL7VYELydRgcAHgtsaE5h9j/xStLLS4RMdiXRI/SqYB+3LjcJAg5skfTup0ogZ5TIxMKYvLPgYLhcBoHseJAshMrT84ZEZ/ArqAjIWp4YZfqv09Muc2gDSKMuQMKynbgwwNvGbvuNzoh0w23ucCYJj7zN1JtHjvi867xAsszWxw==
x-ms-exchange-antispam-messagedata: ozrz3q3xSnILLbXWQsb5J7cd3UvTTwYXBQ/Qv3oaboL5jlGIeSLxAD5vOq0CV5AJfypgZrkS6rhygBvVeh5vdvr3MUUnQJ9a2Fl1QRwUyJcOUsm3h/WweIe7RwfgIlS4uhudgzoZUpVutsR9rczkQw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6CBD5F35D7EFA40A635B176921F0026@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa42ba9-b73d-42f2-9f06-08d7d0aecc45
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 11:22:26.5316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jm57LF8wTK3lHC0epqvcNPncQdIk1mbgT7G6UV24a8kg7apvYqTSHhU92ijnnmXx6JzahMtb1MXhKW0zClrJT4kwXIKnbNN06rjkxSSBti4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3596
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTI1IGF0IDExOjA3ICswMTAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBX
ZWQsIE1hciAyNSwgMjAyMCBhdCAxMDowMjo0MUFNICswMDAwLCBSYW50YWxhLCBUb21taSBULiAo
Tm9raWEgLQ0KPiBGSS9Fc3Bvbykgd3JvdGU6DQo+ID4gDQo+ID4gT3RoZXIgcGVvcGxlIGFyZSBh
cHBhcmVudGx5IHNlZWluZyB0aGlzIHRvbyB3aXRoIDQuMTk6DQo+ID4gaHR0cHM6Ly9rdWR6aWEu
ZXUvYi8yMDE5LzA5L2lvc3RhdC14LTEtcmVwb3J0aW5nLTEwMC11dGlsaXphdGlvbi1vZi1uZWFy
bHktaWRsZS1udm1lLWRyaXZlcy8NCj4gPiANCj4gPiANCj4gPiBJIGFsc28gc2VlIHRoaXMgb25s
eSBpbiA0LjE5LnkgYW5kIGJpc2VjdGVkIHRvIHRoaXMgKGJhc2VkIG9uIHRoZSBGaXhlcw0KPiA+
IHRhZywgdGhpcyBzaG91bGQgaGF2ZSBiZWVuIHRha2VuIHRvIDQuMTQgdG9vLi4uKToNCj4gPiAN
Cj4gPiBjb21taXQgNjEzMTgzN2IxZGU2NjExNjQ1OWVmNDQxM2UyNmZkYmM3MGQwNjZkYw0KPiA+
IEF1dGhvcjogT21hciBTYW5kb3ZhbCA8b3NhbmRvdkBmYi5jb20+DQo+ID4gRGF0ZTogICBUaHUg
QXByIDI2IDAwOjIxOjU4IDIwMTggLTA3MDANCj4gPiANCj4gPiAgIGJsay1tcTogY291bnQgYWxs
b2NhdGVkIGJ1dCBub3Qgc3RhcnRlZCByZXF1ZXN0cyBpbiBpb3N0YXRzIGluZmxpZ2h0DQo+ID4g
DQo+ID4gICBJbiB0aGUgbGVnYWN5IGJsb2NrIGNhc2UsIHdlIGluY3JlbWVudCB0aGUgY291bnRl
ciByaWdodCBhZnRlciB3ZQ0KPiA+ICAgYWxsb2NhdGUgdGhlIHJlcXVlc3QsIG5vdCB3aGVuIHRo
ZSBkcml2ZXIgaGFuZGxlcyBpdC4gSW4gYm90aCB0aGUNCj4gPiBsZWdhY3kNCj4gPiAgIGFuZCBi
bGstbXEgY2FzZXMsIHBhcnRfaW5jX2luX2ZsaWdodCgpIGlzIGNhbGxlZCBmcm9tDQo+ID4gICBi
bGtfYWNjb3VudF9pb19zdGFydCgpIHJpZ2h0IGFmdGVyIHdlJ3ZlIGFsbG9jYXRlZCB0aGUgcmVx
dWVzdC4gYmxrLW1xDQo+ID4gICBvbmx5IGNvbnNpZGVycyByZXF1ZXN0cyBzdGFydGVkIHJlcXVl
c3RzIGFzIGluZmxpZ2h0LCBidXQgdGhpcyBpcw0KPiA+ICAgaW5jb25zaXN0ZW50IHdpdGggdGhl
IGxlZ2FjeSBkZWZpbml0aW9uIGFuZCB0aGUgaW50ZW50aW9uIGluIHRoZSBjb2RlLg0KPiA+ICAg
VGhpcyByZW1vdmVzIHRoZSBzdGFydGVkIGNvbmRpdGlvbiBhbmQgaW5zdGVhZCBjb3VudHMgYWxs
IGFsbG9jYXRlZA0KPiA+ICAgcmVxdWVzdHMuDQo+ID4gDQo+ID4gICBGaXhlczogZjI5OWI3Yzdh
OWRlICgiYmxrLW1xOiBwcm92aWRlIGludGVybmFsIGluLWZsaWdodCB2YXJpYW50IikNCj4gPiAg
IFNpZ25lZC1vZmYtYnk6IE9tYXIgU2FuZG92YWwgPG9zYW5kb3ZAZmIuY29tPg0KPiA+ICAgU2ln
bmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPg0KPiA+IA0KPiA+IA0KPiA+
IA0KPiA+IElmIEkgZ2V0IGl0IHJpZ2h0LCB3aGVuIHRoZSBkaXNrIGlzIGlkbGUsIGFuZCBzb21l
IHJlcXVlc3QgaXMgYWxsb2NhdGVkLA0KPiA+IHBhcnRfcm91bmRfc3RhdHMoKSB3aXRoIHRoaXMg
Y29tbWl0IHdpbGwgbm93IGFkZCBhbGwgdGlja3MgYmV0d2Vlbg0KPiA+IHByZXZpb3VzIEkvTyBh
bmQgY3VycmVudCB0aW1lIChub3cgLSBwYXJ0LT5zdGFtcCkgdG8gaW9fdGlja3MuDQo+ID4gDQo+
ID4gQmVmb3JlIHRoZSBjb21taXQsIHBhcnRfcm91bmRfc3RhdHMoKSB3b3VsZCBvbmx5IHVwZGF0
ZSBwYXJ0LT5zdGFtcCB3aGVuDQo+ID4gY2FsbGVkIGFmdGVyIHJlcXVlc3QgYWxsb2NhdGlvbi4N
Cj4gDQo+IFNvIHRoaXMgaXMgYSAiZmFsc2UiIHJlcG9ydGluZz8gIHRoZXJlJ3MgcmVhbGx5IG5v
IGxvYWQ/DQoNCkNvcnJlY3QuDQoNCj4gPiBBbnkgdGhvdWdodHMgaG93IHRvIGJlc3QgZml4IHRo
aXMgaW4gNC4xOT8NCj4gPiBJIHNlZSB0aGUgaW9fdGlja3MgYWNjb3VudGluZyBoYXMgYmVlbiBy
ZXdvcmtlZCBpbiA1LjAsIGRvIHdlIG5lZWQgdG8NCj4gPiBiYWNrcG9ydCB0aG9zZSB0byA0LjE5
LCBvciBhbnkgaWxsIGVmZmVjdHMgaWYgdGhpcyBjb21taXQgaXMgcmV2ZXJ0ZWQgaW4NCj4gPiA0
LjE5Pw0KPiANCj4gRG8geW91IHNlZSB0aGlzIGlzc3VlIGluIDUuND8gIFdoYXQncyBrZWVwaW5n
IHlvdSBmcm9tIG1vdmluZyB0byA1LjQueT8NCg0KWWVzIGl0J3MgZml4ZWQgaW4gNS4wIGFuZCBs
YXRlci4NCkZpeGluZyBpdCBpbiA0LjE5Lnggd291bGQgYmVuZWZpdCBkZWJpYW4gc3RhYmxlIHVz
ZXJzIHRvby4gOi0pDQpCVFcgaXMgdGhlIEVPTCBmb3IgNC4xOSBzdGlsbCBlbmQgb2YgMjAyMD8N
Cg0KPiBBbmQgaWYgdGhpcyBpc24ndCBhIHJlYWwgaXNzdWUsIGlzIHRoYXQgYSBwcm9ibGVtIHRv
bz8NCj4gDQo+IEFzIHlvdSBjYW4gdGVzdCB0aGlzLCBpZiB5b3UgaGF2ZSBhIHNldCBvZiBwYXRj
aGVzIGJhY2twb3J0ZWQgdGhhdCBjb3VsZA0KPiByZXNvbHZlIGl0LCBjYW4geW91IHNlbmQgdGhl
bSB0byB1cz8NCg0KQmFzZWQgb24gcXVpY2sgbG9va3MgaXQncyBzb2x2ZWQgYnkgdGhpcywgSSds
bCBuZWVkIHRvIGNoZWNrIGlmIGl0J3MgZW5vdWdoDQp0byBmaXggaXQ6DQoNCmNvbW1pdCA1YjE4
YjVhNzM3NjAwZmQyMGJhMjA0NWYzMjBkNTkyNmViYmYzNDFhDQpBdXRob3I6IE1pa3VsYXMgUGF0
b2NrYSA8bXBhdG9ja2FAcmVkaGF0LmNvbT4NCkRhdGU6ICAgVGh1IERlYyA2IDExOjQxOjE5IDIw
MTggLTA1MDANCg0KICAgIGJsb2NrOiBkZWxldGUgcGFydF9yb3VuZF9zdGF0cyBhbmQgc3dpdGNo
IHRvIGxlc3MgcHJlY2lzZSBjb3VudGluZw0KDQoNCg0KDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBn
cmVnIGstaA0KDQo=
