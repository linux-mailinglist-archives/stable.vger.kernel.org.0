Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E00019833A
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 20:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgC3SSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 14:18:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:34703 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgC3SSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 14:18:37 -0400
IronPort-SDR: SZBKxaFR//kXzATZrsEbOY2QA4UiOjQgDsyOVHfzIIbriVi8RMpnERq5oL3K52zkuEtZpO0vrY
 QckcV9FMlJjA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:18:37 -0700
IronPort-SDR: B4IGHahozMVLUZgTj4vgXloJOHX4x/spN4o1J1r1l8ACPD2tXU3Qqsc+vKRlPn8ftpP9KdHxM3
 SZbYml5lnTjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="294684511"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2020 11:18:36 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 11:18:33 -0700
Received: from fmsmsx116.amr.corp.intel.com ([169.254.2.62]) by
 fmsmsx123.amr.corp.intel.com ([169.254.7.47]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 11:18:33 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Deak, Imre" <imre.deak@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/icl+: Don't enable DDI IO power on
 a TypeC port in TBT mode
Thread-Topic: [Intel-gfx] [PATCH] drm/i915/icl+: Don't enable DDI IO power
 on a TypeC port in TBT mode
Thread-Index: AQHWBqcfnsCiQVK6xk+ajFqTX6qZK6hh57IA
Date:   Mon, 30 Mar 2020 18:18:32 +0000
Message-ID: <815ba1ab31f27a14de6ed5845d6ec07c6d56b32d.camel@intel.com>
References: <20200330152244.11316-1-imre.deak@intel.com>
In-Reply-To: <20200330152244.11316-1-imre.deak@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.15.8]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C122FC9C741F24AB64B3CE9197E0D65@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTMwIGF0IDE4OjIyICswMzAwLCBJbXJlIERlYWsgd3JvdGU6DQo+IFRo
ZSBEREkgSU8gcG93ZXIgd2VsbCBtdXN0IG5vdCBiZSBlbmFibGVkIGZvciBhIFR5cGVDIHBvcnQg
aW4gVEJUDQo+IG1vZGUsDQo+IGVuc3VyZSB0aGlzIGR1cmluZyBkcml2ZXIgbG9hZGluZy9zeXN0
ZW0gcmVzdW1lLg0KPiANCj4gVGhpcyBnZXRzIHJpZCBvZiBlcnJvciBtZXNzYWdlcyBsaWtlDQo+
IFtkcm1dICpFUlJPUiogcG93ZXIgd2VsbCBEREkgRSBUQzIgSU8gc3RhdGUgbWlzbWF0Y2ggKHJl
ZmNvdW50DQo+IDEvZW5hYmxlZCAwKQ0KPiANCj4gYW5kIGF2b2lkcyBsZWFraW5nIHRoZSBwb3dl
ciByZWYgd2hlbiBkaXNhYmxpbmcgdGhlIG91dHB1dC4NCg0KTWF0Y2hlcyBpbnRlbF9kZGlfcG9z
dF9kaXNhYmxlX2RwIGFuZA0KdGdsX2RkaV9wcmVfZW5hYmxlX2RwL2hzd19kZGlfcHJlX2VuYWJs
ZV9kcC4NCg0KUmV2aWV3ZWQtYnk6IEpvc8OpIFJvYmVydG8gZGUgU291emEgPGpvc2Uuc291emFA
aW50ZWwuY29tPg0KDQo+IA0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuNCsN
Cj4gU2lnbmVkLW9mZi1ieTogSW1yZSBEZWFrIDxpbXJlLmRlYWtAaW50ZWwuY29tPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZGRpLmMgfCA2ICsrKysrLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZGRpLmMNCj4g
Yi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX2RkaS5jDQo+IGluZGV4IDkxNmE4
MDJhZjc4OC4uNjU0MTUxZDlhNmRiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9kaXNwbGF5L2ludGVsX2RkaS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3Bs
YXkvaW50ZWxfZGRpLmMNCj4gQEAgLTE4OTksNyArMTg5OSwxMSBAQCBzdGF0aWMgdm9pZCBpbnRl
bF9kZGlfZ2V0X3Bvd2VyX2RvbWFpbnMoc3RydWN0DQo+IGludGVsX2VuY29kZXIgKmVuY29kZXIs
DQo+ICAJCXJldHVybjsNCj4gIA0KPiAgCWRpZ19wb3J0ID0gZW5jX3RvX2RpZ19wb3J0KGVuY29k
ZXIpOw0KPiAtCWludGVsX2Rpc3BsYXlfcG93ZXJfZ2V0KGRldl9wcml2LCBkaWdfcG9ydC0NCj4g
PmRkaV9pb19wb3dlcl9kb21haW4pOw0KPiArDQo+ICsJaWYgKCFpbnRlbF9waHlfaXNfdGMoZGV2
X3ByaXYsIHBoeSkgfHwNCj4gKwkgICAgZGlnX3BvcnQtPnRjX21vZGUgIT0gVENfUE9SVF9UQlRf
QUxUKQ0KPiArCQlpbnRlbF9kaXNwbGF5X3Bvd2VyX2dldChkZXZfcHJpdiwNCj4gKwkJCQkJZGln
X3BvcnQtPmRkaV9pb19wb3dlcl9kb21haW4pOw0KPiAgDQo+ICAJLyoNCj4gIAkgKiBBVVggcG93
ZXIgaXMgb25seSBuZWVkZWQgZm9yIChlKURQIG1vZGUsIGFuZCBmb3IgSERNSSBtb2RlDQo+IG9u
IFRDDQo=
