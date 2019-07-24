Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78E67356A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 19:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfGXR1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 13:27:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:33862 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbfGXR1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 13:27:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 10:27:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="scan'208";a="174952744"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga006.jf.intel.com with ESMTP; 24 Jul 2019 10:27:43 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 24 Jul 2019 10:27:43 -0700
Received: from fmsmsx117.amr.corp.intel.com ([169.254.3.88]) by
 FMSMSX119.amr.corp.intel.com ([169.254.14.143]) with mapi id 14.03.0439.000;
 Wed, 24 Jul 2019 10:27:42 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH stable v5.2] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Thread-Topic: [PATCH stable v5.2] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Thread-Index: AQHVQONsXO34TlSG+0SkyFodNctzFabaJCaAgABZngA=
Date:   Wed, 24 Jul 2019 17:27:42 +0000
Message-ID: <05339e812e35a4cf1811f26a06bd5a4d1d652407.camel@intel.com>
References: <20190719004526.B0CC521850@mail.kernel.org>
         <20190722231325.16615-1-dhinakaran.pandiyan@intel.com>
         <20190724120657.GG3244@kroah.com>
In-Reply-To: <20190724120657.GG3244@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.193.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <28BC2974802650438AF6F53CFF819321@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDE0OjA2ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBN
b24sIEp1bCAyMiwgMjAxOSBhdCAwNDoxMzoyNVBNIC0wNzAwLCBEaGluYWthcmFuIFBhbmRpeWFu
IHdyb3RlOg0KPiA+IEEgc2luZ2xlIDMyLWJpdCBQU1IyIHRyYWluaW5nIHBhdHRlcm4gZmllbGQg
Zm9sbG93cyB0aGUgc2l4dGVlbg0KPiA+IGVsZW1lbnQNCj4gPiBhcnJheSBvZiBQU1IgdGFibGUg
ZW50cmllcyBpbiB0aGUgVkJUIHNwZWMuIEJ1dCwgd2UgaW5jb3JyZWN0bHkNCj4gPiBkZWZpbmUN
Cj4gPiB0aGlzIFBTUjIgZmllbGQgZm9yIGVhY2ggb2YgdGhlIFBTUiB0YWJsZSBlbnRyaWVzLiBB
cyBhIHJlc3VsdCwgdGhlDQo+ID4gUFNSMQ0KPiA+IHRyYWluaW5nIHBhdHRlcm4gZHVyYXRpb24g
Zm9yIGFueSBwYW5lbF90eXBlICE9IDAgd2lsbCBiZSBwYXJzZWQNCj4gPiBpbmNvcnJlY3RseS4g
U2Vjb25kbHksIFBTUjIgdHJhaW5pbmcgcGF0dGVybiBkdXJhdGlvbnMgZm9yIFZCVHMNCj4gPiB3
aXRoIGJkYg0KPiA+IHZlcnNpb24gPj0gMjI2IHdpbGwgYWxzbyBiZSB3cm9uZy4NCj4gPiANCj4g
PiBDYzogUm9kcmlnbyBWaXZpIDxyb2RyaWdvLnZpdmlAaW50ZWwuY29tPg0KPiA+IENjOiBKb3PD
qSBSb2JlcnRvIGRlIFNvdXphIDxqb3NlLnNvdXphQGludGVsLmNvbT4NCj4gPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICN2NS4yDQo+
ID4gRml4ZXM6IDg4YTBkOTYwNmFmZiAoImRybS9pOTE1L3ZidDogUGFyc2UgYW5kIHVzZSB0aGUg
bmV3IGZpZWxkDQo+ID4gd2l0aCBQU1IyIFRQMi8zIHdha2V1cCB0aW1lIikNCj4gPiBCdWd6aWxs
YTogaHR0cHM6Ly9idWdzLmZyZWVkZXNrdG9wLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MTExMDg4DQo+
ID4gQnVnemlsbGE6IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9
MjA0MTgzDQo+ID4gU2lnbmVkLW9mZi1ieTogRGhpbmFrYXJhbiBQYW5kaXlhbiA8ZGhpbmFrYXJh
bi5wYW5kaXlhbkBpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IFZpbGxlIFN5cmrDpGzDpCA8
dmlsbGUuc3lyamFsYUBsaW51eC5pbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEpvc8OpIFJv
YmVydG8gZGUgU291emEgPGpvc2Uuc291emFAaW50ZWwuY29tPg0KPiA+IEFja2VkLWJ5OiBSb2Ry
aWdvIFZpdmkgPHJvZHJpZ28udml2aUBpbnRlbC5jb20+DQo+ID4gVGVzdGVkLWJ5OiBGcmFuw6dv
aXMgR3VlcnJheiA8a3Vicmlja0BmZ3Y2Lm5ldD4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2RyaWdv
IFZpdmkgPHJvZHJpZ28udml2aUBpbnRlbC5jb20+DQo+ID4gTGluazogDQo+ID4gaHR0cHM6Ly9w
YXRjaHdvcmsuZnJlZWRlc2t0b3Aub3JnL3BhdGNoL21zZ2lkLzIwMTkwNzE3MjIzNDUxLjI1OTUt
MS1kaGluYWthcmFuLnBhbmRpeWFuQGludGVsLmNvbQ0KPiA+IChjaGVycnkgcGlja2VkIGZyb20g
Y29tbWl0DQo+ID4gYjVlYTljOTMzNzAwN2Q2ZTcwMDI4MGM4YTYwYjRlMTBkMDcwZmI1MykNCj4g
DQo+IFRoZXJlIGlzIG5vIHN1Y2ggY29tbWl0IGluIExpbnVzJ3Mga2VybmVsIHRyZWUgOigNCj4g
DQoNCkl0IGlzIHN0aWxsIG9uIGRybS1pbnRlbC9kcm0taW50ZWwtbmV4dC1xdWV1ZWQgLQ0Kc3No
Oi8vZ2l0LmZyZWVkZXNrdG9wLm9yZy9naXQvZHJtLWludGVsDQoNClJvZHJpZ28gZG8geW91IGtu
b3cgd2hlbiBpcyB0aGUgbmV4dCBwdWxsLXJlcXVlc3QgdG8gTGludXM/DQo=
