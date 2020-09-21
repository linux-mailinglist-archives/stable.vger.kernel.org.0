Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A00A2726B9
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUOOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:14:49 -0400
Received: from mail6.tencent.com ([220.249.245.26]:41972 "EHLO
        mail6.tencent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIUOOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 10:14:49 -0400
Received: from EX-SZ018.tencent.com (unknown [10.28.6.39])
        by mail6.tencent.com (Postfix) with ESMTP id BEFBECC3F9;
        Mon, 21 Sep 2020 22:16:05 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1600697765;
        bh=FK1IIdsbjRSobOVqq+8Otfj2MX1TAYm1sfaSUJdAB5w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=Tg3Wvmpldq8qTEW5pZC+A/gA40gfHxy0JzKJQZ5qygxkRCdmB2YL7TfISmJ4hSs/9
         2tDAihvfixTZ4/E1NwNdN/8nTpLRzAqzlaL8pNZOofW6Z3XSPJwuTorr/p+zizjUCX
         LhacLDBeqvMuThhvbhZP7ajst9RGR67P2jvLPs3Y=
Received: from EX-SZ037.tencent.com (10.28.6.119) by EX-SZ018.tencent.com
 (10.28.6.39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 21 Sep
 2020 22:14:41 +0800
Received: from EX-SZ030.tencent.com (10.28.6.105) by EX-SZ037.tencent.com
 (10.28.6.119) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 21 Sep
 2020 22:14:41 +0800
Received: from EX-SZ030.tencent.com ([fe80::d886:80d1:7745:55f2]) by
 EX-SZ030.tencent.com ([fe80::d886:80d1:7745:55f2%5]) with mapi id
 15.01.2106.002; Mon, 21 Sep 2020 22:14:41 +0800
From:   =?utf-8?B?bGloYWl3ZWko5p2O5rW35LyfKQ==?= <lihaiwei@tencent.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree
Thread-Topic: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree
Thread-Index: AQHWkCGMYy80ZEVhl0ms/7ooRLtFsw==
Date:   Mon, 21 Sep 2020 14:14:41 +0000
Message-ID: <E0D58EE6-0CA2-4594-877B-FDE2C1806272@tencent.com>
References: <20200921104234.9C539216C4@mail.kernel.org>
 <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
 <20200921132850.GM2431@sasha-vm>
In-Reply-To: <20200921132850.GM2431@sasha-vm>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [9.19.161.105]
Content-Type: text/plain; charset="utf-8"
Content-ID: <44136985A202674788A10FA4C2651589@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IE9uIFNlcCAyMSwgMjAyMCwgYXQgMjE6MjgsIFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVs
Lm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIFNlcCAyMSwgMjAyMCBhdCAxMDo1NDozOEFNICsw
MDAwLCBsaWhhaXdlaSjmnY7mtbfkvJ8pIHdyb3RlOg0KPj4gDQo+Pj4gT24gU2VwIDIxLCAyMDIw
LCBhdCAxODo0MiwgU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPiB3cm90ZToNCj4+PiAN
Cj4+PiBUaGlzIGlzIGEgbm90ZSB0byBsZXQgeW91IGtub3cgdGhhdCBJJ3ZlIGp1c3QgYWRkZWQg
dGhlIHBhdGNoIHRpdGxlZA0KPj4+IA0KPj4+ICAgS1ZNOiBDaGVjayB0aGUgYWxsb2NhdGlvbiBv
ZiBwdiBjcHUgbWFzaw0KPj4+IA0KPj4+IHRvIHRoZSA1Ljgtc3RhYmxlIHRyZWUgd2hpY2ggY2Fu
IGJlIGZvdW5kIGF0Og0KPj4+ICAgaHR0cDovL3d3dy5rZXJuZWwub3JnL2dpdC8/cD1saW51eC9r
ZXJuZWwvZ2l0L3N0YWJsZS9zdGFibGUtcXVldWUuZ2l0O2E9c3VtbWFyeQ0KPj4+IA0KPj4+IFRo
ZSBmaWxlbmFtZSBvZiB0aGUgcGF0Y2ggaXM6DQo+Pj4gICAga3ZtLWNoZWNrLXRoZS1hbGxvY2F0
aW9uLW9mLXB2LWNwdS1tYXNrLnBhdGNoDQo+Pj4gYW5kIGl0IGNhbiBiZSBmb3VuZCBpbiB0aGUg
cXVldWUtNS44IHN1YmRpcmVjdG9yeS4NCj4+PiANCj4+PiBJZiB5b3UsIG9yIGFueW9uZSBlbHNl
LCBmZWVscyBpdCBzaG91bGQgbm90IGJlIGFkZGVkIHRvIHRoZSBzdGFibGUgdHJlZSwNCj4+PiBw
bGVhc2UgbGV0IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiBrbm93IGFib3V0IGl0Lg0KPj4+IA0K
Pj4gDQo+PiBUaGlzIHBhdGNoIGlzIG5vdCBhIGNvcnJlY3QgdmVyc2lvbiwgc28gcGxlYXNlIGRv
buKAmXQgYWRkIHRoaXMgdG8gdGhlIHN0YWJsZSB0cmVlLCB0aGFua3MuDQo+IA0KPiBXaGF0J3Mg
d3Jvbmcgd2l0aCBpdD8gVGhhdCdzIHdoYXQgbGFuZGVkIHVwc3RyZWFtLg0KPiANCg0KVGhlIHBh
dGNoIGxhbmRlZCB1cHN0cmVhbSBpcyB0aGUgdjEgdmVyc2lvbi4gVGhlcmUgYXJlIHNvbWUgbWlz
dGFrZXMgYW5kIHNob3J0Y29taW5ncy4gVGhlIG1lc3NhZ2UgZGlzY3Vzc2VkIGlzDQoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2t2bS9kNTlmMDVkZi1lNmQzLTNkMzEtYTAzNi1jYzI1YTJiMmYz
M2ZAZ21haWwuY29tLw0KDQpUaGVuLCBhIHJldmVydCBjb21taXQgd2FzIHB1c2hlZC4gSGVyZSwg
DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9DQUI1S2RPYko0XzBvSmYrcndHWFdOazZN
c0ttMWowZHFyY0dRa3pRNjNlazFMWT16TVFAbWFpbC5nbWFpbC5jb20vDQoNCkFuZCBpIHdpbGwg
cmUtc3VibWl0LiBUaGUgZGlzY3Vzc2VkIGlzDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2
bS8yMDIwMDkxNDA5MTE0OC45NTY1NC0xLWxpaGFpd2VpLmtlcm5lbEBnbWFpbC5jb20vVC8jbTli
MzllZjFiMjQ0MDNmOTBjZjk0NDhmNzRiOWRmNTYwNTNkZjY0YWMNCg0KLS0NClRoYW5rcywNCkhh
aXdlaQ0KDQo=
