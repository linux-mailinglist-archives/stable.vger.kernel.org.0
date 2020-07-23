Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B622B067
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgGWNW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 09:22:58 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:56344 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgGWNW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 09:22:57 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4046FC0750;
        Thu, 23 Jul 2020 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1595510576; bh=TCKAM6fOQI8fPcbDKZE86qRK1ALFRTrqacEw4RA8wQ0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=eEbHXRdHPjWAAlDpGXGf3lHe+wPl+upIuuWtoUJJvGzLYbh8B1LW4XOt+zs7d97+6
         Ecpb4EwbAvmWZZewdpGmmTEoM9r7MxH/vu25tcjQbPVL4ym++f2pKBOMbRrW1WIz8F
         hgVvW84ambQyqpNdPdFDnHsHZ7JO+mQpZzw1FPCPUynRqL1si+KqRy3CZohQBvyACP
         ZfcMYdiJe57i9bnhM/eToUg6bfEN/bTWrnKIh2Bp/RJ7alSBPLlZdfW24/fHS1QRvV
         8bFZenn7VNynTc2t0SvIl8jsgBpBBN8VK3w1WDsakqeOydrQ1hl/wvVASw+UCqiMv+
         W57844C2750Yg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3C957A0096;
        Thu, 23 Jul 2020 13:22:54 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 86A72800CE;
        Thu, 23 Jul 2020 13:22:53 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=hminas@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="cKX5L4Bi";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrsP04SUqcLSCjXoBZ2au1H92/l+PTIrc4jPFj4WhoaTTQgYUOFounOoiVTKqGmxTCXW0xQ/udwtW9g/g2OqXUN80vpxlMwbPr8+P3iIhe6MNIU1T/JCApD+VG5dKj4O6/s693wMTUbu0pnkUN4q4xKCek8U3cwQfWKh0/89+7RpruANOeebOkXzPdBo5ZOmr9mA5B7iiVQOrfgbXylH1SFXqOk/JxFAcyVdnnK4IS0o6LivXSOCHgoUdkGor2cE57Eme/kBtz82IGrlnOS+Di0cvgm21IY3A9EOHG7nQ7m54OWgH/qvRoo5iJAhC/b7UN3jn06Y5ao5dfingWVUAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCKAM6fOQI8fPcbDKZE86qRK1ALFRTrqacEw4RA8wQ0=;
 b=ilw0mkZFCvqaQeCsH+gaKQ5PNr5hpBhTnCA6lGTRbtJWp+14MteClciclD/u3Pq09/fcnWNsqeZkZsIZ7jK68aJ/mc0Cn2kk4UXkziq+SLI3Q/7L3QGVpO4pNZuXJqOKhLS8SRDPEcAD0yDs3xYx8UQBqycR9EwvdH80txRnZGYwHBUDy4y1iAm4xgjTU2NZx9npAxRYuTfsPDpdyF27Stiy7h7FeMxdWlHbWm7MF58u2CaoBp+ZB+Rz+JXIoiU541p9SUSJ8TwECHugGgWL8CxEfjj8D2qmAz7z0lXjn+Q0lcB23M0+2gWYXMKtg7JlkIfCTrPHn4UxoaiTus6EVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCKAM6fOQI8fPcbDKZE86qRK1ALFRTrqacEw4RA8wQ0=;
 b=cKX5L4BiR/I/V8C8YeH+IzcaToqYD3xuh4xvLP11dN4q1HyC34fGKf9gzddgjF1TWiMWXFkcFFmMmAFSAzp1nL4gcd2KsoZJ3aZO6uqY6hEt16FN0S1nqpcGmi8UKEIxSIVH4xegHWFzHlHQVAxFQ5LzdRfqmDetwDf43GgSv/s=
Received: from BN6PR12MB1428.namprd12.prod.outlook.com (2603:10b6:404:21::16)
 by BN6PR12MB1346.namprd12.prod.outlook.com (2603:10b6:404:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Thu, 23 Jul
 2020 13:22:51 +0000
Received: from BN6PR12MB1428.namprd12.prod.outlook.com
 ([fe80::836:5425:da4d:cc8]) by BN6PR12MB1428.namprd12.prod.outlook.com
 ([fe80::836:5425:da4d:cc8%4]) with mapi id 15.20.3216.023; Thu, 23 Jul 2020
 13:22:51 +0000
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marex@denx.de" <marex@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [RFC for-5.8] usb: dwc2: Cleanup debugfs when
 usb_add_gadget_udc() fails
Thread-Topic: [RFC for-5.8] usb: dwc2: Cleanup debugfs when
 usb_add_gadget_udc() fails
Thread-Index: AQHWTj+WdJa7ovkKfUm4iPONUJfWFKjyUoGAgCL0YwCAAAVWAA==
Date:   Thu, 23 Jul 2020 13:22:51 +0000
Message-ID: <29131fea-55c2-c87e-9112-6f6d3469e4f9@synopsys.com>
References: <20200629180314.2878638-1-martin.blumenstingl@googlemail.com>
 <0ba4b7ce-3551-0453-bac7-4d86c53dd2e8@synopsys.com>
 <87eep2o027.fsf@kernel.org>
In-Reply-To: <87eep2o027.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f094f031-c2d1-40e4-8b92-08d82f0b8019
x-ms-traffictypediagnostic: BN6PR12MB1346:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB1346ACCC2D24F2D262A5E53AA7760@BN6PR12MB1346.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2OO5J4+l0eAeTDgjeoFu42lMk+HZz9DwmZuz5LY5GYW5GYL0hdQceWQR2qV6eBd4N3nYeX0fSpOaIsj/clz/hLPgxYPRRHhyTtQEEklV7RcqTc68DmdvKG7Yfp+OhPyy/YlbB4IWn/E4loN6POhbbMIawbDqtTvk2xCMYoTm44h0HTc3ZYsi6Lx/OZezXpE7p8Qvqjoy9JPt/6am4KO/FRvZMM/JWZ+BX2srjbrOtWjA+7wG2iBIWZo85PSXnJOngVn34dExrnRcdVSzXjiFKaGGQzyPfISHz8uxtXWnrOZyzuJby0velKuquMptNTh6Ad8egh+9tahXzFtMZ9VyoTIiWkuzHDbU9EPGvPoN4B0m/4o731vSxHL7daLYFV6y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1428.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(4326008)(53546011)(2616005)(316002)(54906003)(2906002)(110136005)(8936002)(6512007)(6506007)(71200400001)(36756003)(8676002)(5660300002)(31686004)(86362001)(66476007)(6486002)(478600001)(31696002)(91956017)(66946007)(66556008)(64756008)(66446008)(186003)(26005)(83380400001)(76116006)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qDgbF1iSS8lm8b6T5u55ri0Le3IG3GgPn8rkUhQSP1/DE14YTk4lum6GirCyYqUTbcGWclVoXNNqUbN/B/LEpq/AA5wf4W+BF2e6vWgoF0zyTbPfQnIvUbJpK2TMM3YrTw8VBrnRxG6N61n5GR5DlB7KZF3ZsDsd/niYydScRYGfa8SMn8XjpVLXArmpdkhJ9gyKEe/9zRYm8s2ezn/s8mGZz9sWr6AbombZUyzXC3h5hvKCyU4ESBz/p8QkQA3Oy4gJUj80BYxDAM/m6W/dXmtHhozmyz6rH91X/z75b7RQLG7a7PdQv3luaFi/pKFvHvZyZnWITT3e+5BhOXpIFP/2oMG2pAZoRM3RczZD+O2JgxbMHtxN/pjcfJqr18/lKY0RHOqfW0AObIwyKZvYSx2+nb1R9YjuWIZ+xICpFQmUUmsnMDtBTHU18P39f+qUoYYHKcOqIECWHn5sLR9r8zVqcWg4avEGctbllh48XAFBZ82eTOI7XoHFcR910Hjt
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1CAA405C1D0BE42AA632205D9D68955@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR12MB1428.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f094f031-c2d1-40e4-8b92-08d82f0b8019
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 13:22:51.1489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Her1vVr/xr0xOtMUvuKx+NFRgpbDoeVNNOmJLeT8NKkh7+EX/IattiE8mov0/fjx61osrqd9XTFGksaGTU+szg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1346
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpPbiA3LzIzLzIwMjAgNTowMyBQTSwgRmVsaXBlIEJhbGJpIHdyb3RlOg0K
PiBNaW5hcyBIYXJ1dHl1bnlhbiA8TWluYXMuSGFydXR5dW55YW5Ac3lub3BzeXMuY29tPiB3cml0
ZXM6DQo+IA0KPj4gSGkgTWFydGluLA0KPj4NCj4+IE9uIDYvMjkvMjAyMCAxMDowMyBQTSwgTWFy
dGluIEJsdW1lbnN0aW5nbCB3cm90ZToNCj4+PiBDYWxsIGR3YzJfZGVidWdmc19leGl0KCkgd2hl
biB1c2JfYWRkX2dhZGdldF91ZGMoKSBoYXMgZmFpbGVkLiBUaGlzDQo+Pj4gZW5zdXJlIHRoYXQg
dGhlIGRlYnVnZnMgZW50cmllcyBjcmVhdGVkIGJ5IGR3YzJfZGVidWdmc19pbml0KCkgYXJlDQo+
Pj4gY2xlYW5lZCB1cCBpbiB0aGUgZXJyb3IgcGF0aC4NCj4+Pg0KPj4+IEZpeGVzOiAyMDczMjRh
MzIxYTg2NiAoInVzYjogZHdjMjogUG9zdHBvbmVkIGdhZGdldCByZWdpc3RyYXRpb24gdG8gdGhl
IHVkYyBjbGFzcyBkcml2ZXIiKQ0KPj4+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBCbHVtZW5zdGlu
Z2wgPG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5jb20+DQo+Pj4gLS0tDQo+Pj4gVGhp
cyBwYXRjaCBpcyBjb21waWxlLXRlc3RlZCBvbmx5LiBJIGZvdW5kIHRoaXMgd2hpbGUgdHJ5aW5n
IHRvDQo+Pj4gdW5kZXJzdGFuZCB0aGUgbGF0ZXN0IGNoYW5nZXMgdG8gZHdjMi9wbGF0Zm9ybS5j
Lg0KPj4+DQo+Pj4NCj4+PiAgICBkcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMgfCA0ICsrKy0N
Cj4+PiAgICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMi9wbGF0Zm9ybS5jIGIvZHJpdmVy
cy91c2IvZHdjMi9wbGF0Zm9ybS5jDQo+Pj4gaW5kZXggYzM0N2Q5M2VhZTY0Li4wMmI2ZGE3ZTIx
ZDcgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy91c2IvZHdjMi9wbGF0Zm9ybS5jDQo+Pj4gKysr
IGIvZHJpdmVycy91c2IvZHdjMi9wbGF0Zm9ybS5jDQo+Pj4gQEAgLTU4MiwxMiArNTgyLDE0IEBA
IHN0YXRpYyBpbnQgZHdjMl9kcml2ZXJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqZGV2
KQ0KPj4+ICAgIAkJcmV0dmFsID0gdXNiX2FkZF9nYWRnZXRfdWRjKGhzb3RnLT5kZXYsICZoc290
Zy0+Z2FkZ2V0KTsNCj4+PiAgICAJCWlmIChyZXR2YWwpIHsNCj4+PiAgICAJCQlkd2MyX2hzb3Rn
X3JlbW92ZShoc290Zyk7DQo+Pj4gLQkJCWdvdG8gZXJyb3JfaW5pdDsNCj4+PiArCQkJZ290byBl
cnJvcl9kZWJ1Z2ZzOw0KPj4+ICAgIAkJfQ0KPj4+ICAgIAl9DQo+Pj4gICAgI2VuZGlmIC8qIENP
TkZJR19VU0JfRFdDMl9QRVJJUEhFUkFMIHx8IENPTkZJR19VU0JfRFdDMl9EVUFMX1JPTEUgKi8N
Cj4+PiAgICAJcmV0dXJuIDA7DQo+Pj4gICAgDQo+Pj4gK2Vycm9yX2RlYnVnZnM6DQo+Pj4gKwlk
d2MyX2RlYnVnZnNfZXhpdChoc290Zyk7DQo+Pj4gICAgZXJyb3JfaW5pdDoNCj4+PiAgICAJaWYg
KGhzb3RnLT5wYXJhbXMuYWN0aXZhdGVfc3RtX2lkX3ZiX2RldGVjdGlvbikNCj4+PiAgICAJCXJl
Z3VsYXRvcl9kaXNhYmxlKGhzb3RnLT51c2IzM2QpOw0KPj4+DQo+PiBJJ20gT2sgd2l0aCB0aGlz
IGZpeC4gT25lIG1vcmUgdGhpbmcuIEkgbWlzc2VkIHRvIHJlbW92ZSBoY2QgYWxzbyBpbg0KPj4g
ZmFpbCBjYXNlLiBDb3VsZCB5b3UgcGxlYXNlIGFkZCBkd2MyX2hjZF9yZW1vdmUoKSBjYWxsIGFm
dGVyDQo+PiBkd2MyX2RlYnVnZnNfZXhpdChoc290ZykgYW5kIHN1Ym1pdCBhcyBwYXRjaDoNCj4+
DQo+PiArZXJyb3JfZGVidWdmczoNCj4+ICsJZHdjMl9kZWJ1Z2ZzX2V4aXQoaHNvdGcpOw0KPj4g
KwlpZiAoaHNvdGctPmhjZF9lbmFibGVkKQ0KPj4gKwkJZHdjMl9oY2RfcmVtb3ZlKGhzb3RnKTsN
Cj4+ICAgICBlcnJvcl9pbml0Og0KPiANCj4gbG9va3MgbGlrZSBpdCBzaG91bGQgYmUgYSBzZXBh
cmF0ZSBwYXRjaCB0aG91Z2guIFJpZ2h0Pw0KDQp2MiBvZiB0aGlzIHBhdGNoIGFscmVhZHkgc3Vi
bWl0dGVkIGJ5IE1hcnRpbiBCbHVtZW5zdGluZ2wgDQo8bWFydGluLmJsdW1lbnN0aW5nbEBnb29n
bGVtYWlsLmNvbT4gb24gNy80LzIwMjAgd2l0aCBmaXggcmVsYXRlZCB0byANCmR3YzJfaGNkX3Jl
bW92ZSgpIGFuZCBJIGFja2VkIGl0Og0KDQpbUEFUQ0ggZm9yLTUuOCB2Ml0gdXNiOiBkd2MyOiBB
ZGQgbWlzc2luZyBjbGVhbnVwcyB3aGVuIA0KdXNiX2FkZF9nYWRnZXRfdWRjKCkgZmFpbHMNCg0K
DQpUaGFua3MsDQpNaW5hcw0KDQo+IA0K
