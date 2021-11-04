Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26873444C95
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 01:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhKDAfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 20:35:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:65415 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhKDAf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 20:35:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="317830396"
X-IronPort-AV: E=Sophos;i="5.87,207,1631602800"; 
   d="scan'208";a="317830396"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 17:30:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,207,1631602800"; 
   d="scan'208";a="600097810"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 03 Nov 2021 17:30:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 3 Nov 2021 17:30:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 3 Nov 2021 17:30:18 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.012;
 Wed, 3 Nov 2021 17:30:18 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Zhao, Yakui" <yakui.zhao@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Nikula, Jani" <jani.nikula@intel.com>,
        "Roper, Matthew D" <matthew.d.roper@intel.com>
Subject: Re: [PATCH] drm/i915: Remove memory frequency calculation
Thread-Topic: [PATCH] drm/i915: Remove memory frequency calculation
Thread-Index: AQHXz032Lz1jntkprUGxox/18SQDWqvyBjkAgAD4ngA=
Date:   Thu, 4 Nov 2021 00:30:18 +0000
Message-ID: <fb21fbc6b8b03ffa3df2f629112132664cccda4c.camel@intel.com>
References: <1635599150237240@kroah.com>
         <20211101183230.89060-1-jose.souza@intel.com> <YYJaklqD9XAj16Lw@kroah.com>
In-Reply-To: <YYJaklqD9XAj16Lw@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEFC8E587DD68349BEEB79BED4917908@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTAzIGF0IDEwOjQ2ICswMTAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBN
b24sIE5vdiAwMSwgMjAyMSBhdCAxMTozMjozMEFNIC0wNzAwLCBKb3PDqSBSb2JlcnRvIGRlIFNv
dXphIHdyb3RlOg0KPiA+IFRoaXMgbWVtb3J5IGZyZXF1ZW5jeSBjYWxjdWxhdGVkIGlzIG9ubHkg
dXNlZCB0byBjaGVjayBpZiBpdCBpcyB6ZXJvLA0KPiA+IHdoYXQgaXMgbm90IHVzZWZ1bCBhcyBp
dCB3aWxsIG5ldmVyIGFjdHVhbGx5IGJlIHplcm8uDQo+ID4gDQo+ID4gQWxzbyB0aGUgY2FsY3Vs
YXRpb24gaXMgd3JvbmcsIHdlIHNob3VsZCBiZSBjaGVja2luZyBvdGhlciBiaXQgdG8NCj4gPiBz
ZWxlY3QgdGhlIGFwcHJvcHJpYXRlIGZyZXF1ZW5jeSBtdWx0aXBsaWVyIHdoaWxlIHRoaXMgY29k
ZSBpcyBzdHVjaw0KPiA+IHdpdGggYSBmaXhlZCBtdWx0aXBsaWVyLg0KPiA+IA0KPiA+IFNvIGhl
cmUgZHJvcHBpbmcgaXQgYXMgd2hvbGUuDQo+ID4gDQo+ID4gdjI6DQo+ID4gLSBBbHNvIHJlbW92
ZSBtZW1vcnkgZnJlcXVlbmN5IGNhbGN1bGF0aW9uIGZvciBnZW45IExQIHBsYXRmb3Jtcw0KPiA+
IA0KPiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyA1LjE0LXN0YWJsZQ0KPiA+IENj
OiBZYWt1aSBaaGFvIDx5YWt1aS56aGFvQGludGVsLmNvbT4NCj4gPiBDYzogTWF0dCBSb3BlciA8
bWF0dGhldy5kLnJvcGVyQGludGVsLmNvbT4NCj4gPiBGaXhlczogNWQwYzkzOGVjOWNjICgiZHJt
L2k5MTUvZ2VuMTErOiBPbmx5IGxvYWQgRFJBTSBpbmZvcm1hdGlvbiBmcm9tIHBjb2RlIikNCj4g
PiBTaWduZWQtb2ZmLWJ5OiBKb3PDqSBSb2JlcnRvIGRlIFNvdXphIDxqb3NlLnNvdXphQGludGVs
LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTWF0dCBSb3BlciA8bWF0dGhldy5kLnJvcGVyQGludGVs
LmNvbT4NCj4gPiBMaW5rOiBodHRwczovL3BhdGNod29yay5mcmVlZGVza3RvcC5vcmcvcGF0Y2gv
bXNnaWQvMjAyMTEwMTMwMTAwNDYuOTE4NTgtMS1qb3NlLnNvdXphQGludGVsLmNvbQ0KPiA+IChj
aGVycnkgcGlja2VkIGZyb20gY29tbWl0IDgzZjUyMzY0YjE1MjY1YWVjNDdkMDdlMDJiMGZiZjQw
OTNhYjg1NTQpDQo+IA0KPiBUaGVyZSBpcyBubyBzdWNoIGNvbW1pdCBpbiBMaW51cydzIHRyZWUu
DQo+IA0KPiBXaGF0IGNvbW1pdCBpcyB0aGlzIHRoYXQgaXMgYmVpbmcgYmFja3BvcnRlZD8NCg0K
SXQgaXMgb24gTGludXMncyB0cmVlOg0KDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD04M2Y1MjM2NGIx
NTI2NWFlYzQ3ZDA3ZTAyYjBmYmY0MDkzYWI4NTU0DQoNCj4gDQo+IGNvbmZ1c2VkLA0KPiANCj4g
Z3JlZyBrLWgNCg0K
