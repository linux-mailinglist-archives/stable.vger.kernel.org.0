Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2E46D390
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 20:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfGRSQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 14:16:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:41525 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbfGRSQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 14:16:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 11:16:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="367438718"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2019 11:16:24 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jul 2019 11:16:24 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.252]) by
 FMSMSX154.amr.corp.intel.com ([169.254.6.214]) with mapi id 14.03.0439.000;
 Thu, 18 Jul 2019 11:16:24 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] libnvdimm/region: Register badblocks before
 namespaces
Thread-Topic: [PATCH v2 3/7] libnvdimm/region: Register badblocks before
 namespaces
Thread-Index: AQHVPQc/XREfWGrWN0m6ePEPd1eCmKbRJRmA
Date:   Thu, 18 Jul 2019 18:16:23 +0000
Message-ID: <60f1c499243c2e46fcc5aecc0922a0a5b730b16a.camel@intel.com>
References: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
         <156341208365.292348.1547528796026249120.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156341208365.292348.1547528796026249120.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.185]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BA1DF32AB703E448A19BBC12618BA43@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiBXZWQsIDIwMTktMDctMTcgYXQgMTg6MDggLTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToN
Cj4gTmFtZXNwYWNlIGFjdGl2YXRpb24gZXhwZWN0cyB0byBiZSBhYmxlIHRvIHJlZmVyZW5jZSBy
ZWdpb24gYmFkYmxvY2tzLg0KPiBUaGUgZm9sbG93aW5nIHdhcm5pbmcgc29tZXRpbWVzIHRyaWdn
ZXJzIHdoZW4gYXN5bmNocm9ub3VzIG5hbWVzcGFjZQ0KPiBhY3RpdmF0aW9uIHJhY2VzIGluIGZy
b250IG9mIHRoZSBjb21wbGV0aW9uIG9mIG5hbWVzcGFjZSBwcm9iaW5nLiBNb3ZlDQo+IGFsbCBw
b3NzaWJsZSBuYW1lc3BhY2UgcHJvYmluZyBhZnRlciByZWdpb24gYmFkYmxvY2tzIGluaXRpYWxp
emF0aW9uLg0KPiANCj4gT3RoZXJ3aXNlLCBsb2NrZGVwIHNvbWV0aW1lcyBjYXRjaGVzIHRoZSB1
bmluaXRpYWxpemVkIHN0YXRlIG9mIHRoZQ0KPiBiYWRibG9ja3Mgc2VxbG9jayB3aXRoIHN0YWNr
IHRyYWNlIHNpZ25hdHVyZXMgbGlrZToNCj4gDQo+ICAgICBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0
ZXIgbm9uLXN0YXRpYyBrZXkuDQo+ICAgICBwbWVtMjogZGV0ZWN0ZWQgY2FwYWNpdHkgY2hhbmdl
IGZyb20gMCB0byAxMzYzNjUyMTE2NDgNCj4gICAgIHRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRz
IGxvY2tkZXAgYW5ub3RhdGlvbi4NCj4gICAgIHR1cm5pbmcgb2ZmIHRoZSBsb2NraW5nIGNvcnJl
Y3RuZXNzIHZhbGlkYXRvci4NCj4gICAgIENQVTogOSBQSUQ6IDM1OCBDb21tOiBrd29ya2VyL3U4
MDo1IFRhaW50ZWQ6DQo+IEcgICAgICAgICAgIE9FICAgICA1LjIuMC1yYzQrICMzMzgyDQo+ICAg
ICBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwg
QklPUyAwLjAuMA0KPiAwMi8wNi8yMDE1DQo+ICAgICBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5k
IGFzeW5jX3J1bl9lbnRyeV9mbg0KPiAgICAgQ2FsbCBUcmFjZToNCj4gICAgICBkdW1wX3N0YWNr
KzB4ODUvMHhjMA0KPiAgICAgcG1lbTEuMTI6IGRldGVjdGVkIGNhcGFjaXR5IGNoYW5nZSBmcm9t
IDAgdG8gODU4OTkzNDU5Mg0KPiAgICAgIHJlZ2lzdGVyX2xvY2tfY2xhc3MrMHg1NmEvMHg1NzAN
Cj4gICAgICA/IGNoZWNrX29iamVjdCsweDE0MC8weDI3MA0KPiAgICAgIF9fbG9ja19hY3F1aXJl
KzB4ODAvMHgxNzEwDQo+ICAgICAgPyBfX211dGV4X2xvY2srMHgzOWQvMHg5MTANCj4gICAgICBs
b2NrX2FjcXVpcmUrMHg5ZS8weDE4MA0KPiAgICAgID8gbmRfcGZuX3ZhbGlkYXRlKzB4MjhmLzB4
NDQwIFtsaWJudmRpbW1dDQo+ICAgICAgYmFkYmxvY2tzX2NoZWNrKzB4OTMvMHgxZjANCj4gICAg
ICA/IG5kX3Bmbl92YWxpZGF0ZSsweDI4Zi8weDQ0MCBbbGlibnZkaW1tXQ0KPiAgICAgIG5kX3Bm
bl92YWxpZGF0ZSsweDI4Zi8weDQ0MCBbbGlibnZkaW1tXQ0KPiAgICAgID8gbG9ja2RlcF9oYXJk
aXJxc19vbisweGYwLzB4MTgwDQo+ICAgICAgbmRfZGF4X3Byb2JlKzB4OWEvMHgxMjAgW2xpYm52
ZGltbV0NCj4gICAgICBuZF9wbWVtX3Byb2JlKzB4NmQvMHgxODAgW25kX3BtZW1dDQo+ICAgICAg
bnZkaW1tX2J1c19wcm9iZSsweDkwLzB4MmMwIFtsaWJudmRpbW1dDQo+IA0KPiBGaXhlczogNDhh
ZjJmN2U1MmY0ICgibGlibnZkaW1tLCBwZm46IGR1cmluZyBpbml0LCBjbGVhciBlcnJvcnMuLi4i
KQ0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IENjOiBWaXNoYWwgVmVybWEgPHZp
c2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9udmRpbW0vcmVnaW9u
LmMgfCAgIDIyICsrKysrKysrKysrLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMSBp
bnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCg0KVGhpcyBsb29rcyBnb29kIHRvIG1lLA0K
UmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udmRpbW0vcmVnaW9uLmMgYi9kcml2ZXJzL252ZGlt
bS9yZWdpb24uYw0KPiBpbmRleCBlZjQ2Y2MzYTcxYWUuLjQ4OGM0N2FjNGM0YSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9udmRpbW0vcmVnaW9uLmMNCj4gKysrIGIvZHJpdmVycy9udmRpbW0vcmVn
aW9uLmMNCj4gQEAgLTM0LDE3ICszNCw2IEBAIHN0YXRpYyBpbnQgbmRfcmVnaW9uX3Byb2JlKHN0
cnVjdCBkZXZpY2UgKmRldikNCj4gIAlpZiAocmMpDQo+ICAJCXJldHVybiByYzsNCj4gIA0KPiAt
CXJjID0gbmRfcmVnaW9uX3JlZ2lzdGVyX25hbWVzcGFjZXMobmRfcmVnaW9uLCAmZXJyKTsNCj4g
LQlpZiAocmMgPCAwKQ0KPiAtCQlyZXR1cm4gcmM7DQo+IC0NCj4gLQluZHJkID0gZGV2X2dldF9k
cnZkYXRhKGRldik7DQo+IC0JbmRyZC0+bnNfYWN0aXZlID0gcmM7DQo+IC0JbmRyZC0+bnNfY291
bnQgPSByYyArIGVycjsNCj4gLQ0KPiAtCWlmIChyYyAmJiBlcnIgJiYgcmMgPT0gZXJyKQ0KPiAt
CQlyZXR1cm4gLUVOT0RFVjsNCj4gLQ0KPiAgCWlmIChpc19uZF9wbWVtKCZuZF9yZWdpb24tPmRl
dikpIHsNCj4gIAkJc3RydWN0IHJlc291cmNlIG5kcl9yZXM7DQo+ICANCj4gQEAgLTYwLDYgKzQ5
LDE3IEBAIHN0YXRpYyBpbnQgbmRfcmVnaW9uX3Byb2JlKHN0cnVjdCBkZXZpY2UgKmRldikNCj4g
IAkJbnZkaW1tX2JhZGJsb2Nrc19wb3B1bGF0ZShuZF9yZWdpb24sICZuZF9yZWdpb24tPmJiLA0K
PiAmbmRyX3Jlcyk7DQo+ICAJfQ0KPiAgDQo+ICsJcmMgPSBuZF9yZWdpb25fcmVnaXN0ZXJfbmFt
ZXNwYWNlcyhuZF9yZWdpb24sICZlcnIpOw0KPiArCWlmIChyYyA8IDApDQo+ICsJCXJldHVybiBy
YzsNCj4gKw0KPiArCW5kcmQgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gKwluZHJkLT5uc19h
Y3RpdmUgPSByYzsNCj4gKwluZHJkLT5uc19jb3VudCA9IHJjICsgZXJyOw0KPiArDQo+ICsJaWYg
KHJjICYmIGVyciAmJiByYyA9PSBlcnIpDQo+ICsJCXJldHVybiAtRU5PREVWOw0KPiArDQo+ICAJ
bmRfcmVnaW9uLT5idHRfc2VlZCA9IG5kX2J0dF9jcmVhdGUobmRfcmVnaW9uKTsNCj4gIAluZF9y
ZWdpb24tPnBmbl9zZWVkID0gbmRfcGZuX2NyZWF0ZShuZF9yZWdpb24pOw0KPiAgCW5kX3JlZ2lv
bi0+ZGF4X3NlZWQgPSBuZF9kYXhfY3JlYXRlKG5kX3JlZ2lvbik7DQo+IA0KDQo=
