Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E5314CD9
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 11:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhBIKWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 05:22:11 -0500
Received: from mx.socionext.com ([202.248.49.38]:51004 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhBIKUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 05:20:03 -0500
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 09 Feb 2021 19:19:07 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id E69CC2059027;
        Tue,  9 Feb 2021 19:19:07 +0900 (JST)
Received: from 10.213.24.1 (10.213.24.1) by m-FILTER with ESMTP; Tue, 9 Feb 2021 19:19:07 +0900
Received: from SOC-EX02V.e01.socionext.com (10.213.24.22) by
 SOC-EX01V.e01.socionext.com (10.213.24.21) with Microsoft SMTP Server (TLS)
 id 15.0.995.29; Tue, 9 Feb 2021 19:19:07 +0900
Received: from SOC-EX02V.e01.socionext.com ([10.213.25.22]) by
 SOC-EX02V.e01.socionext.com ([10.213.25.22]) with mapi id 15.00.0995.028;
 Tue, 9 Feb 2021 19:19:07 +0900
From:   <obayashi.yoshimasa@socionext.com>
To:     <gregkh@linuxfoundation.org>
CC:     <sumit.garg@linaro.org>, <hch@lst.de>, <m.szyprowski@samsung.com>,
        <robin.murphy@arm.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <daniel.thompson@linaro.org>
Subject: RE: DMA direct mapping fix for 5.4 and earlier stable branches
Thread-Topic: DMA direct mapping fix for 5.4 and earlier stable branches
Thread-Index: AQHW/qowxPC004ZwL0WzBboqT0yFrapOzcOAgAAQ0oCAAAGYgIAAmb8Q//98PwCAAKOy0A==
Date:   Tue, 9 Feb 2021 10:19:07 +0000
Message-ID: <ed485ad069af4d1481e3961db4a3e079@SOC-EX02V.e01.socionext.com>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
 <YCIym62vHfbG+dWf@kroah.com>
 <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com>
 <YCJCDZGa1Dhqv6Ni@kroah.com>
 <27bbe35deacb4ca49f31307f4ed551b5@SOC-EX02V.e01.socionext.com>
 <YCJUgKDNVjJ4dUqM@kroah.com>
In-Reply-To: <YCJUgKDNVjJ4dUqM@kroah.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.1
x-shieldmailcheckerpolicyversion: POLICY200130
x-originating-ip: [10.213.24.1]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBIb3cgZG8geW91IGp1ZGdlICJtYXR1cmUiPw0KDQogIE15IGJhc2ljIGNyaXRlcmlhIGFyZQ0K
KiBGdW5jdGlvbiBpcyBleGlzdCwgYnV0IGJ1ZyBmaXggaXMgbmVjZXNzYXJ5OiAibWF0dXJlIg0K
KiBGdW5jdGlvbiBleHRlbnNpb24gaXMgbmVjZXNzYXJ5OiAiaW1tYXR1cmUiDQoNCj4gQW5kIGFn
YWluLCBpZiBhIGZlYXR1cmUgaXNuJ3QgcHJlc2VudCBpbiBhIHNwZWNpZmljIGtlcm5lbCB2ZXJz
aW9uLCB3aHkgd291bGQgeW91IHRoaW5rIHRoYXQgaXQgd291bGQgYmUNCj4gYSB2aWFibGUgc29s
dXRpb24gZm9yIHlvdSB0byB1c2U/DQoNCiAgU28sICJhIGZlYXR1cmUgaXNuJ3QgcHJlc2VudCBp
biBhIHNwZWNpZmljIGtlcm5lbCB2ZXJzaW9uIiwgDQphbHNvIG1lYW5zICJpbW1hdHVyZSIgYWNj
b3JkaW5nIHRvIG15IGNyaXRlcmlhLg0KDQpSZWdhcmRzLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+IEZyb206IEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0K
PiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSA5LCAyMDIxIDY6MjMgUE0NCj4gVG86IE9iYXlhc2hp
LCBZb3NoaW1hc2EvGyRCSHhOUxsoQiAbJEJBMUA1GyhCIDxvYmF5YXNoaS55b3NoaW1hc2FAc29j
aW9uZXh0LmNvbT4NCj4gQ2M6IHN1bWl0LmdhcmdAbGluYXJvLm9yZzsgaGNoQGxzdC5kZTsgbS5z
enlwcm93c2tpQHNhbXN1bmcuY29tOyByb2Jpbi5tdXJwaHlAYXJtLmNvbTsNCj4gaW9tbXVAbGlz
dHMubGludXgtZm91bmRhdGlvbi5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRhbmllbC50aG9tcHNvbkBsaW5hcm8ub3JnDQo+IFN1
YmplY3Q6IFJlOiBETUEgZGlyZWN0IG1hcHBpbmcgZml4IGZvciA1LjQgYW5kIGVhcmxpZXIgc3Rh
YmxlIGJyYW5jaGVzDQo+IA0KPiBPbiBUdWUsIEZlYiAwOSwgMjAyMSBhdCAwOTowNTo0MEFNICsw
MDAwLCBvYmF5YXNoaS55b3NoaW1hc2FAc29jaW9uZXh0LmNvbSB3cm90ZToNCj4gPiA+ID4gQXMg
dGhlIGRyaXZlcnMgYXJlIGN1cnJlbnRseSB1bmRlciBkZXZlbG9wbWVudCBhbmQgU29jaW9uZXh0
IGhhcw0KPiA+ID4gPiBjaG9zZW4gNS40IHN0YWJsZSBrZXJuZWwgZm9yIHRoZWlyIGRldmVsb3Bt
ZW50LiBTbyBJIHdpbGwgbGV0DQo+ID4gPiA+IE9iYXlhc2hpLXNhbiBhbnN3ZXIgdGhpcyBpZiBp
dCdzIHBvc3NpYmxlIGZvciB0aGVtIHRvIG1pZ3JhdGUgdG8NCj4gPiA+ID4gNS4xMCBpbnN0ZWFk
Pw0KPiA+DQo+ID4gICBXZSBoYXZlIHN0YXJ0ZWQgdGhpcyBkZXZlbG9wbWVudCBwcm9qZWN0IGZy
b20gbGFzdCBBdWd1c3QsIHNvIHdlDQo+ID4gaGF2ZSBzZWxlY3RlZCA1LjQgYXMgbW9zdCByZWNl
bnQgYW5kIGxvbmdlc3QgbGlmZXRpbWUgTFRTIHZlcnNpb24gYXQNCj4gPiB0aGF0IHRpbWUuDQo+
ID4NCj4gPiAgIEFuZCB3ZSBoYXZlIGFscmVhZHkgZmluaXNoZWQgdG8gZGV2ZWxvcCBvdGhlciBk
ZXZpY2UgZHJpdmVycywgYW5kDQo+ID4gVmlkZW8gY29udmVydGVyIGFuZCBDT0RFQyBkcml2ZXJz
IGFyZSBub3cgaW4gZGV2ZWxvcG1lbnQuDQo+ID4NCj4gPiA+IFdoeSBwaWNrIGEga2VybmVsIHRo
YXQgZG9lc24gbm90IHN1cHBvcnQgdGhlIGZlYXR1cmVzIHRoZXkgcmVxdWlyZT8NCj4gPiA+IFRo
YXQgc2VlbXMgdmVyeSBvZGQgYW5kIHVud2lzZS4NCj4gPg0KPiA+ICAgRnJvbSB0aGUgdmlldyBw
b2ludCBvZiBaZXJvQ29weSB1c2luZyBETUFCVUYsIGlzIDUuNCBub3QgbWF0dXJlDQo+ID4gZW5v
dWdoLCBhbmQgaXMgNS4xMCBlbm91Z2ggbWF0dXJlID8NCj4gPiAgIFRoaXMgaXMgdGhlIG1vc3Qg
aW1wb3J0YW50IHBvaW50IGZvciBqdWRnaW5nIG1pZ3JhdGlvbi4NCj4gDQo+IEhvdyBkbyB5b3Ug
anVkZ2UgIm1hdHVyZSI/DQo+IA0KPiBBbmQgYWdhaW4sIGlmIGEgZmVhdHVyZSBpc24ndCBwcmVz
ZW50IGluIGEgc3BlY2lmaWMga2VybmVsIHZlcnNpb24sIHdoeSB3b3VsZCB5b3UgdGhpbmsgdGhh
dCBpdCB3b3VsZCBiZQ0KPiBhIHZpYWJsZSBzb2x1dGlvbiBmb3IgeW91IHRvIHVzZT8NCj4gDQo+
IGdvb2QgbHVjayENCj4gDQo+IGdyZWcgay1oDQo=
