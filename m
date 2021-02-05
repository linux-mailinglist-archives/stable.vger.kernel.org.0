Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8CC3104FA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 07:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhBEGaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 01:30:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:49392 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230161AbhBEGaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 01:30:02 -0500
IronPort-SDR: UQzEv8TO6HNzIlgR+hyxs/m4IJfmJ2PqCxJFIxQ0zBU2R0tjkkO1NPHhdxU4/UWG6e9ssSDb4x
 BQ2aes8bxA3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="161140189"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="161140189"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 22:29:12 -0800
IronPort-SDR: hVRtrQ9aUZYcFE9DAT18m1WVRS2k62Nkcuqhb4e9JSJEJ686yS0BFNmtLSDGZOAb4Xy0V/mQ8a
 u+GRXb8L9jPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393719114"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by orsmga008.jf.intel.com with ESMTP; 04 Feb 2021 22:29:12 -0800
Received: from irsmsx605.ger.corp.intel.com (163.33.146.138) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Feb 2021 06:29:11 +0000
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138]) by
 IRSMSX605.ger.corp.intel.com ([163.33.146.138]) with mapi id 15.01.1713.004;
 Fri, 5 Feb 2021 06:29:11 +0000
From:   "Kahola, Mika" <mika.kahola@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH] drm/i915: Reject 446-480MHz HDMI clock on GLK
Thread-Topic: [Intel-gfx] [PATCH] drm/i915: Reject 446-480MHz HDMI clock on
 GLK
Thread-Index: AQHW+g9Kly3g348hI0ioRMgIYXo5IqpJHCAw
Date:   Fri, 5 Feb 2021 06:29:11 +0000
Message-ID: <daf4a8d667b048b5800b433b01791387@intel.com>
References: <20210203093044.30532-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20210203093044.30532-1-ville.syrjala@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.0.76
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC1nZnggPGludGVsLWdm
eC1ib3VuY2VzQGxpc3RzLmZyZWVkZXNrdG9wLm9yZz4gT24gQmVoYWxmIE9mIFZpbGxlDQo+IFN5
cmphbGENCj4gU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSAzLCAyMDIxIDExOjMxIEFNDQo+IFRv
OiBpbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFtJbnRlbC1nZnhdIFtQQVRDSF0gZHJtL2k5MTU6IFJlamVjdCA0
NDYtNDgwTUh6IEhETUkgY2xvY2sgb24gR0xLDQo+IA0KPiBGcm9tOiBWaWxsZSBTeXJqw6Rsw6Qg
PHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPg0KPiANCj4gVGhlIEJYVC9HTEsgRFBMTCBj
YW4ndCBnZW5lcmF0ZSBjZXJ0YWluIGZyZXF1ZW5jaWVzLiBXZSBhbHJlYWR5IHJlamVjdCB0aGUN
Cj4gMjMzLTI0ME1IeiByYW5nZSBvbiBib3RoLiBCdXQgb24gR0xLIHRoZSBEUExMIG1heCBmcmVx
dWVuY3kgd2FzDQo+IGJ1bXBlZCBmcm9tIDMwME1IeiB0byA1OTRNSHosIHNvIG5vdyB3ZSBnZXQg
dG8gYWxzbyB3b3JyeSBhYm91dCB0aGUNCj4gNDQ2LTQ4ME1IeiByYW5nZSAoZG91YmxlIHRoZSBv
cmlnaW5hbCBwcm9ibGVtIHJhbmdlKS4gUmVqZWN0IGFueSBmcmVxdWVuY3kNCj4gd2l0aGluIHRo
ZSBoaWdoZXIgcHJvYmxlbWF0aWMgcmFuZ2UgYXMgd2VsbC4NCj4gDQo+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+IENsb3NlczogaHR0cHM6Ly9naXRsYWIuZnJlZWRlc2t0b3Aub3JnL2Ry
bS9pbnRlbC8tL2lzc3Vlcy8zMDAwDQo+IFNpZ25lZC1vZmYtYnk6IFZpbGxlIFN5cmrDpGzDpCA8
dmlsbGUuc3lyamFsYUBsaW51eC5pbnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBNaWthIEthaG9s
YSA8bWlrYS5rYWhvbGFAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2k5
MTUvZGlzcGxheS9pbnRlbF9oZG1pLmMgfCA2ICsrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Z3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfaGRtaS5jDQo+IGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvZGlzcGxheS9pbnRlbF9oZG1pLmMNCj4gaW5kZXggNjZlMWFjMzg4N2M2Li5iNTkzYTcxZTY1
MTcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfaGRt
aS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfaGRtaS5jDQo+
IEBAIC0yMjE4LDcgKzIyMTgsMTEgQEAgaGRtaV9wb3J0X2Nsb2NrX3ZhbGlkKHN0cnVjdCBpbnRl
bF9oZG1pICpoZG1pLA0KPiAgCQkJCQkgIGhhc19oZG1pX3NpbmspKQ0KPiAgCQlyZXR1cm4gTU9E
RV9DTE9DS19ISUdIOw0KPiANCj4gLQkvKiBCWFQgRFBMTCBjYW4ndCBnZW5lcmF0ZSAyMjMtMjQw
IE1IeiAqLw0KPiArCS8qIEdMSyBEUExMIGNhbid0IGdlbmVyYXRlIDQ0Ni00ODAgTUh6ICovDQo+
ICsJaWYgKElTX0dFTUlOSUxBS0UoZGV2X3ByaXYpICYmIGNsb2NrID4gNDQ2NjY2ICYmIGNsb2Nr
IDwgNDgwMDAwKQ0KPiArCQlyZXR1cm4gTU9ERV9DTE9DS19SQU5HRTsNCj4gKw0KPiArCS8qIEJY
VC9HTEsgRFBMTCBjYW4ndCBnZW5lcmF0ZSAyMjMtMjQwIE1IeiAqLw0KPiAgCWlmIChJU19HRU45
X0xQKGRldl9wcml2KSAmJiBjbG9jayA+IDIyMzMzMyAmJiBjbG9jayA8IDI0MDAwMCkNCj4gIAkJ
cmV0dXJuIE1PREVfQ0xPQ0tfUkFOR0U7DQo+IA0KPiAtLQ0KPiAyLjI2LjINCj4gDQo+IF9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IEludGVsLWdmeCBt
YWlsaW5nIGxpc3QNCj4gSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBodHRwczov
L2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA0K
