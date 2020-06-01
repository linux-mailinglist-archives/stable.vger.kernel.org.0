Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59D1EA437
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 14:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgFAMtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 08:49:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:25395 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgFAMtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 08:49:49 -0400
IronPort-SDR: hch8NvS//qG21d6Ig3Nqr5Fhxwq4xB+d48ceNubpUak/WwTxJ7/fcC66GlibO63L7qaRWH7d6j
 ePv/3NhMeWUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 05:49:48 -0700
IronPort-SDR: K3y4zi83dtSyVMV6ygjQ3P3cdGILxAzIlvqBz/aNhvIYx2KaIxoOR2CxJQcjQ14cPv6eAFHzTi
 KF6KdR/w8r4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,460,1583222400"; 
   d="scan'208";a="293180025"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga004.fm.intel.com with ESMTP; 01 Jun 2020 05:49:48 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jun 2020 05:49:48 -0700
Received: from bgsmsx101.gar.corp.intel.com (10.223.4.170) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jun 2020 05:49:47 -0700
Received: from bgsmsx104.gar.corp.intel.com ([169.254.5.115]) by
 BGSMSX101.gar.corp.intel.com ([169.254.1.23]) with mapi id 14.03.0439.000;
 Mon, 1 Jun 2020 18:19:45 +0530
From:   "Shankar, Uma" <uma.shankar@intel.com>
To:     "Gupta, Anshuman" <anshuman.gupta@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [RFC] drm/i915: lpsp with hdmi/dp outputs
Thread-Topic: [Intel-gfx] [RFC] drm/i915: lpsp with hdmi/dp outputs
Thread-Index: AQHWN/+DXwK47U+O70e74aNiXdDPH6jDtRGg
Date:   Mon, 1 Jun 2020 12:49:44 +0000
Message-ID: <E7C9878FBA1C6D42A1CA3F62AEB6945F82516D51@BGSMSX104.gar.corp.intel.com>
References: <20200601101516.21018-1-anshuman.gupta@intel.com>
In-Reply-To: <20200601101516.21018-1-anshuman.gupta@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSW50ZWwtZ2Z4IDxpbnRl
bC1nZngtYm91bmNlc0BsaXN0cy5mcmVlZGVza3RvcC5vcmc+IE9uIEJlaGFsZiBPZg0KPiBBbnNo
dW1hbiBHdXB0YQ0KPiBTZW50OiBNb25kYXksIEp1bmUgMSwgMjAyMCAzOjQ1IFBNDQo+IFRvOiBp
bnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFtJbnRlbC1nZnhdIFtSRkNdIGRybS9pOTE1OiBscHNwIHdpdGggaGRt
aS9kcCBvdXRwdXRzDQo+IA0KPiBHZW4xMiBodyBhcmUgZmFpbGluZyB0byBlbmFibGUgbHBzcCBj
b25maWd1cmF0aW9uIGR1ZSB0byBQRzMgd2FzIGxlZnQgb24gZHVlIHRvDQo+IHZhbGlkIHVzZ2Fl
IGNvdW50IG9mIFBPV0VSX0RPTUFJTl9BVURJTy4NCj4gSXQgaXMgbm90IHJlcXVpcmVkIHRvIGdl
dCBQT1dFUl9ET01BSU5fQVVESU8gcmVmLWNvdW50IHdoZW4gZW5hYmxpbmcgYSBjcnRjLA0KPiBp
dCBzaG91bGQgYmUgYWx3YXlzIGk5MTVfYXVkaW9fY29tcG9uZW50IHJlcXVlc3QgdG8gZ2V0L3B1
dA0KPiBBVURJT19QT1dFUl9ET01BSU4uDQo+IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiBDYzogVmlsbGUgU3lyasOkbMOkIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbT4N
Cj4gQ2M6IE1hYXJ0ZW4gTGFua2hvcnN0IDxtYWFydGVuLmxhbmtob3JzdEBsaW51eC5pbnRlbC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IEFuc2h1bWFuIEd1cHRhIDxhbnNodW1hbi5ndXB0YUBpbnRl
bC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kaXNw
bGF5LmMgfCA2ICsrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3Bs
YXkvaW50ZWxfZGlzcGxheS5jDQo+IGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRl
bF9kaXNwbGF5LmMNCj4gaW5kZXggNmMzYjExZGUyZGFmLi5mMzFhNTc5ZDdhNTIgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZGlzcGxheS5jDQo+ICsr
KyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZGlzcGxheS5jDQo+IEBAIC03
MzU2LDcgKzczNTYsMTEgQEAgc3RhdGljIHU2NCBnZXRfY3J0Y19wb3dlcl9kb21haW5zKHN0cnVj
dA0KPiBpbnRlbF9jcnRjX3N0YXRlICpjcnRjX3N0YXRlKQ0KPiAgCQltYXNrIHw9IEJJVF9VTEwo
aW50ZWxfZW5jb2Rlci0+cG93ZXJfZG9tYWluKTsNCj4gIAl9DQo+IA0KPiAtCWlmIChIQVNfRERJ
KGRldl9wcml2KSAmJiBjcnRjX3N0YXRlLT5oYXNfYXVkaW8pDQo+ICsJLyoNCj4gKwkgKiBHZW4x
MiBjYW4gZHJpdmUgbHBzcCBvbiBoZG1pL2RwIG91dHB1cywgaXQgZG9lc24ndCByZXF1aXJlIHRv
DQo+ICsJICogZW5hYmxlIEFVRElPIHBvd2VyIGluIG9yZGVyIHRvIGVuYWJsZSBhIGNydGMuDQo+
ICsJICovDQo+ICsJaWYgKElOVEVMX0dFTihkZXZfcHJpdikgPCAxMiAmJiBIQVNfRERJKGRldl9w
cml2KSAmJg0KPiArY3J0Y19zdGF0ZS0+aGFzX2F1ZGlvKQ0KPiAgCQltYXNrIHw9IEJJVF9VTEwo
UE9XRVJfRE9NQUlOX0FVRElPKTsNCg0KQXMgcGFydCBvZiBkZGlfZ2V0X2NvbmZpZyB3ZSBkZXRl
cm1pbmUgaGFzX2F1ZGlvIHVzaW5nIHBvd2VyIHdlbGwgZW5hYmxlZDoNCnBpcGVfY29uZmlnLT5o
YXNfYXVkaW8gPQ0KICAgICAgICAgICAgICAgIGludGVsX2RkaV9pc19hdWRpb19lbmFibGVkKGRl
dl9wcml2LCBjcHVfdHJhbnNjb2Rlcik7DQoNCklmIGF1ZGlvIHBvd2VyIGRvbWFpbiBpcyBub3Qg
ZW5hYmxlZCwgd2UgbWF5IGVuZCB1cCB3aXRoIHRoaXMgYXMgZmFsc2UuDQpMYXRlciB0aGlzIG1h
eSBnZXQgY2hlY2tlZCBpbiBpbnRlbF9lbmFibGVfZGRpX2hkbWkgdG8gY2FsbCBhdWRpbyBjb2Rl
YyBlbmFibGUNCg0KaWYgKGNydGNfc3RhdGUtPmhhc19hdWRpbykNCiAgICAgICAgICAgICAgICBp
bnRlbF9hdWRpb19jb2RlY19lbmFibGUoZW5jb2RlciwgY3J0Y19zdGF0ZSwgY29ubl9zdGF0ZSk7
DQoNClRoaXMgbWF5IGNhdXNlIGRldGVjdGlvbiB0byBmYWlsLiBQbGVhc2UgdmVyaWZ5IHRoaXMg
dXNlY2FzZSBvbmNlIGFuZCBjb25maXJtLg0KDQpSZWdhcmRzLA0KVW1hIFNoYW5rYXINCg0KPiAg
CWlmIChjcnRjX3N0YXRlLT5zaGFyZWRfZHBsbCkNCj4gLS0NCj4gMi4yNi4yDQo+IA0KPiBfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBJbnRlbC1nZngg
bWFpbGluZyBsaXN0DQo+IEludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gaHR0cHM6
Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZngNCg==
