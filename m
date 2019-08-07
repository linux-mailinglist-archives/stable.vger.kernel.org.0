Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C28853A7
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 21:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389303AbfHGThQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 15:37:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:16259 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389273AbfHGThQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 15:37:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 12:37:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="176292088"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2019 12:37:15 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 7 Aug 2019 12:37:15 -0700
Received: from fmsmsx117.amr.corp.intel.com ([169.254.3.88]) by
 fmsmsx156.amr.corp.intel.com ([169.254.13.183]) with mapi id 14.03.0439.000;
 Wed, 7 Aug 2019 12:37:14 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "Nikula, Jani" <jani.nikula@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kubrick@fgv6.net" <kubrick@fgv6.net>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>
Subject: Re: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
Thread-Topic: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
Thread-Index: AQHVS+AhaiqseKuVkE6+TWWunJa8g6buMyuAgAJZbwA=
Date:   Wed, 7 Aug 2019 19:37:13 +0000
Message-ID: <a9fb603fdbeeaf41c90ad5a793e1da0473a532cb.camel@intel.com>
References: <156498469082135@kroah.com>
         <20190805224951.6523-1-jose.souza@intel.com> <87mugmkaam.fsf@intel.com>
In-Reply-To: <87mugmkaam.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.9.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD9EE9A503422E4B853978122EDF8E89@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZw0KDQpBbnl0aGluZyBpcyBtaXNzaW5nIHRvIGhhdmUgdGhpcyBtZXJnZWQgZm9yIDUu
Mi44Pw0KDQoNCk9uIFR1ZSwgMjAxOS0wOC0wNiBhdCAxMDo0NCArMDMwMCwgSmFuaSBOaWt1bGEg
d3JvdGU6DQo+IE9uIE1vbiwgMDUgQXVnIDIwMTksIEpvc8OpIFJvYmVydG8gZGUgU291emEgPGpv
c2Uuc291emFAaW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPiBGcm9tOiBEaGluYWthcmFuIFBhbmRp
eWFuIDxkaGluYWthcmFuLnBhbmRpeWFuQGludGVsLmNvbT4NCj4gPiANCj4gDQo+IGNvbW1pdCA2
ZDYxZjcxNmEwMWVjMGUxMzRkZTM4YWU5N2U3MWQ2ZmVjNWE2ZmY2IHVwc3RyZWFtLg0KPiANCj4g
PiBBIHNpbmdsZSAzMi1iaXQgUFNSMiB0cmFpbmluZyBwYXR0ZXJuIGZpZWxkIGZvbGxvd3MgdGhl
IHNpeHRlZW4NCj4gPiBlbGVtZW50DQo+ID4gYXJyYXkgb2YgUFNSIHRhYmxlIGVudHJpZXMgaW4g
dGhlIFZCVCBzcGVjLiBCdXQsIHdlIGluY29ycmVjdGx5DQo+ID4gZGVmaW5lDQo+ID4gdGhpcyBQ
U1IyIGZpZWxkIGZvciBlYWNoIG9mIHRoZSBQU1IgdGFibGUgZW50cmllcy4gQXMgYSByZXN1bHQs
IHRoZQ0KPiA+IFBTUjENCj4gPiB0cmFpbmluZyBwYXR0ZXJuIGR1cmF0aW9uIGZvciBhbnkgcGFu
ZWxfdHlwZSAhPSAwIHdpbGwgYmUgcGFyc2VkDQo+ID4gaW5jb3JyZWN0bHkuIFNlY29uZGx5LCBQ
U1IyIHRyYWluaW5nIHBhdHRlcm4gZHVyYXRpb25zIGZvciBWQlRzDQo+ID4gd2l0aCBiZGINCj4g
PiB2ZXJzaW9uID49IDIyNiB3aWxsIGFsc28gYmUgd3JvbmcuDQo+ID4gDQo+ID4gQ2M6IFJvZHJp
Z28gVml2aSA8cm9kcmlnby52aXZpQGludGVsLmNvbT4NCj4gPiBDYzogSm9zw6kgUm9iZXJ0byBk
ZSBTb3V6YSA8am9zZS5zb3V6YUBpbnRlbC5jb20+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjdjUuMg0KPiA+IEZpeGVzOiA4
OGEwZDk2MDZhZmYgKCJkcm0vaTkxNS92YnQ6IFBhcnNlIGFuZCB1c2UgdGhlIG5ldyBmaWVsZA0K
PiA+IHdpdGggUFNSMiBUUDIvMyB3YWtldXAgdGltZSIpDQo+ID4gQnVnemlsbGE6IGh0dHBzOi8v
YnVncy5mcmVlZGVza3RvcC5vcmcvc2hvd19idWcuY2dpP2lkPTExMTA4OA0KPiA+IEJ1Z3ppbGxh
OiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIwNDE4Mw0KPiA+
IFNpZ25lZC1vZmYtYnk6IERoaW5ha2FyYW4gUGFuZGl5YW4gPGRoaW5ha2FyYW4ucGFuZGl5YW5A
aW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBWaWxsZSBTeXJqw6Rsw6QgPHZpbGxlLnN5cmph
bGFAbGludXguaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBKb3PDqSBSb2JlcnRvIGRlIFNv
dXphIDxqb3NlLnNvdXphQGludGVsLmNvbT4NCj4gPiBBY2tlZC1ieTogUm9kcmlnbyBWaXZpIDxy
b2RyaWdvLnZpdmlAaW50ZWwuY29tPg0KPiA+IFRlc3RlZC1ieTogRnJhbsOnb2lzIEd1ZXJyYXog
PGt1YnJpY2tAZmd2Ni5uZXQ+DQo+ID4gU2lnbmVkLW9mZi1ieTogUm9kcmlnbyBWaXZpIDxyb2Ry
aWdvLnZpdmlAaW50ZWwuY29tPg0KPiA+IExpbms6IA0KPiA+IGh0dHBzOi8vcGF0Y2h3b3JrLmZy
ZWVkZXNrdG9wLm9yZy9wYXRjaC9tc2dpZC8yMDE5MDcxNzIyMzQ1MS4yNTk1LTEtZGhpbmFrYXJh
bi5wYW5kaXlhbkBpbnRlbC5jb20NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKYW5pIE5pa3VsYSA8amFu
aS5uaWt1bGFAaW50ZWwuY29tPg0KPiA+IChjaGVycnkgcGlja2VkIGZyb20gY29tbWl0DQo+ID4g
NmQ2MWY3MTZhMDFlYzBlMTM0ZGUzOGFlOTdlNzFkNmZlYzVhNmZmNikNCj4gPiAtLS0NCj4gPiAN
Cj4gPiBTZW5kaW5nIGl0IGZvciBEaGluYWthcmFuLCBsZXQgbWUga25vdyBpZiBzb21ldGhpbmcg
aXMgd3JvbmcuDQo+ID4gDQo+ID4gIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Jpb3MuYyAg
ICAgfCAyICstDQo+ID4gIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3ZidF9kZWZzLmggfCA2
ICsrKy0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxf
Ymlvcy5jDQo+ID4gYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9iaW9zLmMNCj4gPiBpbmRl
eCAxZGM4ZDAzZmYxMjcuLmVlNmZhNzVkNjVhMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pbnRlbF9iaW9zLmMNCj4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9p
bnRlbF9iaW9zLmMNCj4gPiBAQCAtNzYyLDcgKzc2Miw3IEBAIHBhcnNlX3BzcihzdHJ1Y3QgZHJt
X2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYsDQo+ID4gY29uc3Qgc3RydWN0IGJkYl9oZWFkZXIgKmJk
YikNCj4gPiAgCX0NCj4gPiAgDQo+ID4gIAlpZiAoYmRiLT52ZXJzaW9uID49IDIyNikgew0KPiA+
IC0JCXUzMiB3YWtldXBfdGltZSA9IHBzcl90YWJsZS0+cHNyMl90cDJfdHAzX3dha2V1cF90aW1l
Ow0KPiA+ICsJCXUzMiB3YWtldXBfdGltZSA9IHBzci0+cHNyMl90cDJfdHAzX3dha2V1cF90aW1l
Ow0KPiA+ICANCj4gPiAgCQl3YWtldXBfdGltZSA9ICh3YWtldXBfdGltZSA+PiAoMiAqIHBhbmVs
X3R5cGUpKSAmIDB4MzsNCj4gPiAgCQlzd2l0Y2ggKHdha2V1cF90aW1lKSB7DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3ZidF9kZWZzLmgNCj4gPiBiL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2ludGVsX3ZidF9kZWZzLmgNCj4gPiBpbmRleCBmZGJiYjlhNTM4MDQu
Ljc5NmMwNzBiYmU2ZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRl
bF92YnRfZGVmcy5oDQo+ID4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfdmJ0X2Rl
ZnMuaA0KPiA+IEBAIC03NzIsMTMgKzc3MiwxMyBAQCBzdHJ1Y3QgcHNyX3RhYmxlIHsNCj4gPiAg
CS8qIFRQIHdha2UgdXAgdGltZSBpbiBtdWx0aXBsZSBvZiAxMDAgKi8NCj4gPiAgCXUxNiB0cDFf
d2FrZXVwX3RpbWU7DQo+ID4gIAl1MTYgdHAyX3RwM193YWtldXBfdGltZTsNCj4gPiAtDQo+ID4g
LQkvKiBQU1IyIFRQMi9UUDMgd2FrZXVwIHRpbWUgZm9yIDE2IHBhbmVscyAqLw0KPiA+IC0JdTMy
IHBzcjJfdHAyX3RwM193YWtldXBfdGltZTsNCj4gPiAgfSBfX3BhY2tlZDsNCj4gPiAgDQo+ID4g
IHN0cnVjdCBiZGJfcHNyIHsNCj4gPiAgCXN0cnVjdCBwc3JfdGFibGUgcHNyX3RhYmxlWzE2XTsN
Cj4gPiArDQo+ID4gKwkvKiBQU1IyIFRQMi9UUDMgd2FrZXVwIHRpbWUgZm9yIDE2IHBhbmVscyAq
Lw0KPiA+ICsJdTMyIHBzcjJfdHAyX3RwM193YWtldXBfdGltZTsNCj4gPiAgfSBfX3BhY2tlZDsN
Cj4gPiAgDQo+ID4gIC8qDQo=
