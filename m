Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06431388A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhBHPwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:52:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:64785 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234121AbhBHPwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:52:04 -0500
IronPort-SDR: ojjhcOH5QspRINlkp3eYMuZhHoLsUdQwHYmoWwN5/FmQg0XeFYT40E29efX8LRtX/xclHzsaMd
 zdFI5+s4PPWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="180955070"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="180955070"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 07:51:48 -0800
IronPort-SDR: imBOcASgfHdI1d1C8IQTgLkAz83zVneV0bpq3DsXQrg4pRGbhL+rpnm/cC5o1weE7IZUdSaTLI
 4B7ztoeDzTNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="577702829"
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2021 07:51:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 IRSMSX604.ger.corp.intel.com (163.33.146.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Feb 2021 15:51:45 +0000
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.002;
 Mon, 8 Feb 2021 07:51:44 -0800
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Deak, Imre" <imre.deak@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] drm/i915/tgl+: Make sure TypeC FIA is powered up when
 initializing it
Thread-Topic: [PATCH] drm/i915/tgl+: Make sure TypeC FIA is powered up when
 initializing it
Thread-Index: AQHW/jEZADU92kFJx0eG4qzj/WaJQ6pO7r+A
Date:   Mon, 8 Feb 2021 15:51:44 +0000
Message-ID: <d48ea10f1079e42de97ec4d752a8b203d00ba087.camel@intel.com>
References: <20210208154303.6839-1-imre.deak@intel.com>
In-Reply-To: <20210208154303.6839-1-imre.deak@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BECD0507EE918A488A585B520BFFFCB3@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTA4IGF0IDE3OjQzICswMjAwLCBJbXJlIERlYWsgd3JvdGU6DQo+IFRo
ZSBUeXBlQyBGSUEgY2FuIGJlIHBvd2VyZWQgZG93biBpZiB0aGUgVEMtQ09MRCBwb3dlciBzdGF0
ZSBpcyBhbGxvd2VkLA0KPiBzbyBibG9jayB0aGUgVEMtQ09MRCBzdGF0ZSB3aGVuIGluaXRpYWxp
emluZyB0aGUgRklBLg0KPiANCj4gTm90ZSB0aGF0IHRoaXMgaXNuJ3QgbmVlZGVkIG9uIElDTCB3
aGVyZSB0aGUgRklBIGlzIG5ldmVyIG1vZHVsYXIgYW5kDQo+IHdoaWNoIGhhcyBubyBnZW5lcmlj
IHdheSB0byBibG9jayBUQy1DT0xEIChleGNlcHQgZm9yIHBsYXRmb3JtcyB3aXRoIGENCj4gbGVn
YWN5IFR5cGVDIHBvcnQgYW5kIG9uIHRob3NlIHRvbyBvbmx5IHZpYSB0aGVzZSBsZWdhY3kgcG9y
dHMsIG5vdCB2aWENCj4gYSBEUC1hbHQvVEJUIHBvcnQpLg0KDQoNClJldmlld2VkLWJ5OiBKb3PD
qSBSb2JlcnRvIGRlIFNvdXphIDxqb3NlLnNvdXphQGludGVsLmNvbT4NCg0KPiANCj4gQ2M6IDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPiAjIHY1LjEwKw0KPiBDYzogSm9zw6kgUm9iZXJ0byBkZSBT
b3V6YSA8am9zZS5zb3V6YUBpbnRlbC5jb20+DQo+IFJlcG9ydGVkLWJ5OiBQYXVsIE1lbnplbCA8
cG1lbnplbEBtb2xnZW4ubXBnLmRlPg0KPiBDbG9zZXM6IGh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNr
dG9wLm9yZy9kcm0vaW50ZWwvLS9pc3N1ZXMvMzAyNw0KPiBTaWduZWQtb2ZmLWJ5OiBJbXJlIERl
YWsgPGltcmUuZGVha0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvZ3B1L2RybS9pOTE1
L2Rpc3BsYXkvaW50ZWxfdGMuYyB8IDY3ICsrKysrKysrKysrKysrLS0tLS0tLS0tLS0NCj4gwqAx
IGZpbGUgY2hhbmdlZCwgMzcgaW5zZXJ0aW9ucygrKSwgMzAgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF90Yy5jIGIvZHJp
dmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF90Yy5jDQo+IGluZGV4IDI3ZGMyZGFkNjgw
OWMuLjJjZWZjMTM1MzVhMGYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rp
c3BsYXkvaW50ZWxfdGMuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2lu
dGVsX3RjLmMNCj4gQEAgLTIzLDM2ICsyMyw2IEBAIHN0YXRpYyBjb25zdCBjaGFyICp0Y19wb3J0
X21vZGVfbmFtZShlbnVtIHRjX3BvcnRfbW9kZSBtb2RlKQ0KPiDCoAlyZXR1cm4gbmFtZXNbbW9k
ZV07DQo+IMKgfQ0KPiDCoA0KPiANCj4gDQo+IA0KPiAtc3RhdGljIHZvaWQNCj4gLXRjX3BvcnRf
bG9hZF9maWFfcGFyYW1zKHN0cnVjdCBkcm1faTkxNV9wcml2YXRlICppOTE1LA0KPiAtCQkJc3Ry
dWN0IGludGVsX2RpZ2l0YWxfcG9ydCAqZGlnX3BvcnQpDQo+IC17DQo+IC0JZW51bSBwb3J0IHBv
cnQgPSBkaWdfcG9ydC0+YmFzZS5wb3J0Ow0KPiAtCWVudW0gdGNfcG9ydCB0Y19wb3J0ID0gaW50
ZWxfcG9ydF90b190YyhpOTE1LCBwb3J0KTsNCj4gLQl1MzIgbW9kdWxhcl9maWE7DQo+IC0NCj4g
LQlpZiAoSU5URUxfSU5GTyhpOTE1KS0+ZGlzcGxheS5oYXNfbW9kdWxhcl9maWEpIHsNCj4gLQkJ
bW9kdWxhcl9maWEgPSBpbnRlbF91bmNvcmVfcmVhZCgmaTkxNS0+dW5jb3JlLA0KPiAtCQkJCQkJ
UE9SVF9UWF9ERkxFWERQU1AoRklBMSkpOw0KPiAtCQlkcm1fV0FSTl9PTigmaTkxNS0+ZHJtLCBt
b2R1bGFyX2ZpYSA9PSAweGZmZmZmZmZmKTsNCj4gLQkJbW9kdWxhcl9maWEgJj0gTU9EVUxBUl9G
SUFfTUFTSzsNCj4gLQl9IGVsc2Ugew0KPiAtCQltb2R1bGFyX2ZpYSA9IDA7DQo+IC0JfQ0KPiAt
DQo+IC0JLyoNCj4gLQkgKiBFYWNoIE1vZHVsYXIgRklBIGluc3RhbmNlIGhvdXNlcyAyIFRDIHBv
cnRzLiBJbiBTT0MgdGhhdCBoYXMgbW9yZQ0KPiAtCSAqIHRoYW4gdHdvIFRDIHBvcnRzLCB0aGVy
ZSBhcmUgbXVsdGlwbGUgaW5zdGFuY2VzIG9mIE1vZHVsYXIgRklBLg0KPiAtCSAqLw0KPiAtCWlm
IChtb2R1bGFyX2ZpYSkgew0KPiAtCQlkaWdfcG9ydC0+dGNfcGh5X2ZpYSA9IHRjX3BvcnQgLyAy
Ow0KPiAtCQlkaWdfcG9ydC0+dGNfcGh5X2ZpYV9pZHggPSB0Y19wb3J0ICUgMjsNCj4gLQl9IGVs
c2Ugew0KPiAtCQlkaWdfcG9ydC0+dGNfcGh5X2ZpYSA9IEZJQTE7DQo+IC0JCWRpZ19wb3J0LT50
Y19waHlfZmlhX2lkeCA9IHRjX3BvcnQ7DQo+IC0JfQ0KPiAtfQ0KPiAtDQo+IMKgc3RhdGljIGVu
dW0gaW50ZWxfZGlzcGxheV9wb3dlcl9kb21haW4NCj4gwqB0Y19jb2xkX2dldF9wb3dlcl9kb21h
aW4oc3RydWN0IGludGVsX2RpZ2l0YWxfcG9ydCAqZGlnX3BvcnQpDQo+IMKgew0KPiBAQCAtNjQ2
LDYgKzYxNiw0MyBAQCB2b2lkIGludGVsX3RjX3BvcnRfcHV0X2xpbmsoc3RydWN0IGludGVsX2Rp
Z2l0YWxfcG9ydCAqZGlnX3BvcnQpDQo+IMKgCW11dGV4X3VubG9jaygmZGlnX3BvcnQtPnRjX2xv
Y2spOw0KPiDCoH0NCj4gwqANCj4gDQo+IA0KPiANCj4gK3N0YXRpYyBib29sDQo+ICt0Y19oYXNf
bW9kdWxhcl9maWEoc3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmk5MTUsIHN0cnVjdCBpbnRlbF9k
aWdpdGFsX3BvcnQgKmRpZ19wb3J0KQ0KPiArew0KPiArCWludGVsX3dha2VyZWZfdCB3YWtlcmVm
Ow0KPiArCXUzMiB2YWw7DQo+ICsNCj4gKwlpZiAoIUlOVEVMX0lORk8oaTkxNSktPmRpc3BsYXku
aGFzX21vZHVsYXJfZmlhKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsNCj4gKwl3YWtlcmVmID0g
dGNfY29sZF9ibG9jayhkaWdfcG9ydCk7DQo+ICsJdmFsID0gaW50ZWxfdW5jb3JlX3JlYWQoJmk5
MTUtPnVuY29yZSwgUE9SVF9UWF9ERkxFWERQU1AoRklBMSkpOw0KPiArCXRjX2NvbGRfdW5ibG9j
ayhkaWdfcG9ydCwgd2FrZXJlZik7DQo+ICsNCj4gKwlkcm1fV0FSTl9PTigmaTkxNS0+ZHJtLCB2
YWwgPT0gMHhmZmZmZmZmZik7DQo+ICsNCj4gKwlyZXR1cm4gdmFsICYgTU9EVUxBUl9GSUFfTUFT
SzsNCj4gK30NCj4gKw0KPiArc3RhdGljIHZvaWQNCj4gK3RjX3BvcnRfbG9hZF9maWFfcGFyYW1z
KHN0cnVjdCBkcm1faTkxNV9wcml2YXRlICppOTE1LCBzdHJ1Y3QgaW50ZWxfZGlnaXRhbF9wb3J0
ICpkaWdfcG9ydCkNCj4gK3sNCj4gKwllbnVtIHBvcnQgcG9ydCA9IGRpZ19wb3J0LT5iYXNlLnBv
cnQ7DQo+ICsJZW51bSB0Y19wb3J0IHRjX3BvcnQgPSBpbnRlbF9wb3J0X3RvX3RjKGk5MTUsIHBv
cnQpOw0KPiArDQo+ICsJLyoNCj4gKwkgKiBFYWNoIE1vZHVsYXIgRklBIGluc3RhbmNlIGhvdXNl
cyAyIFRDIHBvcnRzLiBJbiBTT0MgdGhhdCBoYXMgbW9yZQ0KPiArCSAqIHRoYW4gdHdvIFRDIHBv
cnRzLCB0aGVyZSBhcmUgbXVsdGlwbGUgaW5zdGFuY2VzIG9mIE1vZHVsYXIgRklBLg0KPiArCSAq
Lw0KPiArCWlmICh0Y19oYXNfbW9kdWxhcl9maWEoaTkxNSwgZGlnX3BvcnQpKSB7DQo+ICsJCWRp
Z19wb3J0LT50Y19waHlfZmlhID0gdGNfcG9ydCAvIDI7DQo+ICsJCWRpZ19wb3J0LT50Y19waHlf
ZmlhX2lkeCA9IHRjX3BvcnQgJSAyOw0KPiArCX0gZWxzZSB7DQo+ICsJCWRpZ19wb3J0LT50Y19w
aHlfZmlhID0gRklBMTsNCj4gKwkJZGlnX3BvcnQtPnRjX3BoeV9maWFfaWR4ID0gdGNfcG9ydDsN
Cj4gKwl9DQo+ICt9DQo+ICsNCj4gwqB2b2lkIGludGVsX3RjX3BvcnRfaW5pdChzdHJ1Y3QgaW50
ZWxfZGlnaXRhbF9wb3J0ICpkaWdfcG9ydCwgYm9vbCBpc19sZWdhY3kpDQo+IMKgew0KPiDCoAlz
dHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqaTkxNSA9IHRvX2k5MTUoZGlnX3BvcnQtPmJhc2UuYmFz
ZS5kZXYpOw0KDQo=
