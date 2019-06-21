Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F684DE41
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfFUA40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 20:56:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:42259 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUA40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 20:56:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 17:56:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="168677239"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2019 17:56:25 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Jun 2019 17:56:25 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.157]) by
 fmsmsx116.amr.corp.intel.com ([169.254.2.126]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 17:56:24 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3/6] libnvdimm/region: Register badblocks before
 namespaces
Thread-Topic: [PATCH 3/6] libnvdimm/region: Register badblocks before
 namespaces
Thread-Index: AQHVIK8OAb/oFHOwOkmDOgZcKMJ7d6alzEWA
Date:   Fri, 21 Jun 2019 00:56:24 +0000
Message-ID: <76314eeafb50c74afbc77156f65cee2c0949478b.camel@intel.com>
References: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
         <156029555941.419799.6074744061405561526.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156029555941.419799.6074744061405561526.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.185]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA82E2E746DC7A479D2937AC738F90FA@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTExIGF0IDE2OjI1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE5hbWVzcGFjZSBhY3RpdmF0aW9uIGV4cGVjdHMgdG8gYmUgYWJsZSB0byByZWZlcmVuY2UgcmVn
aW9uIGJhZGJsb2Nrcy4NCj4gVGhlIGZvbGxvd2luZyB3YXJuaW5nIHNvbWV0aW1lcyB0cmlnZ2Vy
cyB3aGVuIGFzeW5jaHJvbm91cyBuYW1lc3BhY2UNCj4gYWN0aXZhdGlvbiByYWNlcyBpbiBmcm9u
dCBvZiB0aGUgY29tcGxldGlvbiBvZiBuYW1lc3BhY2UgcHJvYmluZy4gTW92ZQ0KPiBhbGwgcG9z
c2libGUgbmFtZXNwYWNlIHByb2JpbmcgYWZ0ZXIgcmVnaW9uIGJhZGJsb2NrcyBpbml0aWFsaXph
dGlvbi4NCj4gDQo+IE90aGVyd2lzZSwgbG9ja2RlcCBzb21ldGltZXMgY2F0Y2hlcyB0aGUgdW5p
bml0aWFsaXplZCBzdGF0ZSBvZiB0aGUNCj4gYmFkYmxvY2tzIHNlcWxvY2sgd2l0aCBzdGFjayB0
cmFjZSBzaWduYXR1cmVzIGxpa2U6DQo+IA0KPiAgICAgSU5GTzogdHJ5aW5nIHRvIHJlZ2lzdGVy
IG5vbi1zdGF0aWMga2V5Lg0KPiAgICAgcG1lbTI6IGRldGVjdGVkIGNhcGFjaXR5IGNoYW5nZSBm
cm9tIDAgdG8gMTM2MzY1MjExNjQ4DQo+ICAgICB0aGUgY29kZSBpcyBmaW5lIGJ1dCBuZWVkcyBs
b2NrZGVwIGFubm90YXRpb24uDQo+ICAgICB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0
bmVzcyB2YWxpZGF0b3IuDQo+ICAgICBDUFU6IDkgUElEOiAzNTggQ29tbToga3dvcmtlci91ODA6
NSBUYWludGVkOg0KPiBHICAgICAgICAgICBPRSAgICAgNS4yLjAtcmM0KyAjMzM4Mg0KPiAgICAg
SGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJ
T1MgMC4wLjANCj4gMDIvMDYvMjAxNQ0KPiAgICAgV29ya3F1ZXVlOiBldmVudHNfdW5ib3VuZCBh
c3luY19ydW5fZW50cnlfZm4NCj4gICAgIENhbGwgVHJhY2U6DQo+ICAgICAgZHVtcF9zdGFjaysw
eDg1LzB4YzANCj4gICAgIHBtZW0xLjEyOiBkZXRlY3RlZCBjYXBhY2l0eSBjaGFuZ2UgZnJvbSAw
IHRvIDg1ODk5MzQ1OTINCj4gICAgICByZWdpc3Rlcl9sb2NrX2NsYXNzKzB4NTZhLzB4NTcwDQo+
ICAgICAgPyBjaGVja19vYmplY3QrMHgxNDAvMHgyNzANCj4gICAgICBfX2xvY2tfYWNxdWlyZSsw
eDgwLzB4MTcxMA0KPiAgICAgID8gX19tdXRleF9sb2NrKzB4MzlkLzB4OTEwDQo+ICAgICAgbG9j
a19hY3F1aXJlKzB4OWUvMHgxODANCj4gICAgICA/IG5kX3Bmbl92YWxpZGF0ZSsweDI4Zi8weDQ0
MCBbbGlibnZkaW1tXQ0KPiAgICAgIGJhZGJsb2Nrc19jaGVjaysweDkzLzB4MWYwDQo+ICAgICAg
PyBuZF9wZm5fdmFsaWRhdGUrMHgyOGYvMHg0NDAgW2xpYm52ZGltbV0NCj4gICAgICBuZF9wZm5f
dmFsaWRhdGUrMHgyOGYvMHg0NDAgW2xpYm52ZGltbV0NCj4gICAgICA/IGxvY2tkZXBfaGFyZGly
cXNfb24rMHhmMC8weDE4MA0KPiAgICAgIG5kX2RheF9wcm9iZSsweDlhLzB4MTIwIFtsaWJudmRp
bW1dDQo+ICAgICAgbmRfcG1lbV9wcm9iZSsweDZkLzB4MTgwIFtuZF9wbWVtXQ0KPiAgICAgIG52
ZGltbV9idXNfcHJvYmUrMHg5MC8weDJjMCBbbGlibnZkaW1tXQ0KPiANCj4gRml4ZXM6IDQ4YWYy
ZjdlNTJmNCAoImxpYm52ZGltbSwgcGZuOiBkdXJpbmcgaW5pdCwgY2xlYXIgZXJyb3JzLi4uIikN
Cj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogVmlzaGFsIFZlcm1hIDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFu
Lmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbnZkaW1tL3JlZ2lvbi5j
IHwgICAyMiArKysrKysrKysrKy0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5z
ZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pDQoNClRoaXMgbG9va3MgZ29vZCB0byBtZSwNClJl
dmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCg0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3JlZ2lvbi5jIGIvZHJpdmVycy9udmRpbW0v
cmVnaW9uLmMNCj4gaW5kZXggZWY0NmNjM2E3MWFlLi40ODhjNDdhYzRjNGEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbnZkaW1tL3JlZ2lvbi5jDQo+ICsrKyBiL2RyaXZlcnMvbnZkaW1tL3JlZ2lv
bi5jDQo+IEBAIC0zNCwxNyArMzQsNiBAQCBzdGF0aWMgaW50IG5kX3JlZ2lvbl9wcm9iZShzdHJ1
Y3QgZGV2aWNlICpkZXYpDQo+ICAJaWYgKHJjKQ0KPiAgCQlyZXR1cm4gcmM7DQo+ICANCj4gLQly
YyA9IG5kX3JlZ2lvbl9yZWdpc3Rlcl9uYW1lc3BhY2VzKG5kX3JlZ2lvbiwgJmVycik7DQo+IC0J
aWYgKHJjIDwgMCkNCj4gLQkJcmV0dXJuIHJjOw0KPiAtDQo+IC0JbmRyZCA9IGRldl9nZXRfZHJ2
ZGF0YShkZXYpOw0KPiAtCW5kcmQtPm5zX2FjdGl2ZSA9IHJjOw0KPiAtCW5kcmQtPm5zX2NvdW50
ID0gcmMgKyBlcnI7DQo+IC0NCj4gLQlpZiAocmMgJiYgZXJyICYmIHJjID09IGVycikNCj4gLQkJ
cmV0dXJuIC1FTk9ERVY7DQo+IC0NCj4gIAlpZiAoaXNfbmRfcG1lbSgmbmRfcmVnaW9uLT5kZXYp
KSB7DQo+ICAJCXN0cnVjdCByZXNvdXJjZSBuZHJfcmVzOw0KPiAgDQo+IEBAIC02MCw2ICs0OSwx
NyBAQCBzdGF0aWMgaW50IG5kX3JlZ2lvbl9wcm9iZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICAJ
CW52ZGltbV9iYWRibG9ja3NfcG9wdWxhdGUobmRfcmVnaW9uLCAmbmRfcmVnaW9uLT5iYiwNCj4g
Jm5kcl9yZXMpOw0KPiAgCX0NCj4gIA0KPiArCXJjID0gbmRfcmVnaW9uX3JlZ2lzdGVyX25hbWVz
cGFjZXMobmRfcmVnaW9uLCAmZXJyKTsNCj4gKwlpZiAocmMgPCAwKQ0KPiArCQlyZXR1cm4gcmM7
DQo+ICsNCj4gKwluZHJkID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ICsJbmRyZC0+bnNfYWN0
aXZlID0gcmM7DQo+ICsJbmRyZC0+bnNfY291bnQgPSByYyArIGVycjsNCj4gKw0KPiArCWlmIChy
YyAmJiBlcnIgJiYgcmMgPT0gZXJyKQ0KPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gKw0KPiAgCW5k
X3JlZ2lvbi0+YnR0X3NlZWQgPSBuZF9idHRfY3JlYXRlKG5kX3JlZ2lvbik7DQo+ICAJbmRfcmVn
aW9uLT5wZm5fc2VlZCA9IG5kX3Bmbl9jcmVhdGUobmRfcmVnaW9uKTsNCj4gIAluZF9yZWdpb24t
PmRheF9zZWVkID0gbmRfZGF4X2NyZWF0ZShuZF9yZWdpb24pOw0KPiANCg0K
