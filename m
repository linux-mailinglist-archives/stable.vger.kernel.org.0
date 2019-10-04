Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D25CBCC9
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 16:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbfJDOOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 10:14:25 -0400
Received: from mx0a-00176a03.pphosted.com ([67.231.149.52]:37582 "EHLO
        mx0a-00176a03.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388270AbfJDOOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 10:14:25 -0400
X-Greylist: delayed 2835 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2019 10:14:24 EDT
Received: from pps.filterd (m0047961.ppops.net [127.0.0.1])
        by m0047961.ppops.net-00176a03. (8.16.0.42/8.16.0.42) with SMTP id x94DQiO1000518;
        Fri, 4 Oct 2019 09:27:09 -0400
From:   "Safford, David (GE Global Research, US)" <david.safford@ge.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Wiseman, Monty (GE Global Research, US)" <monty.wiseman@ge.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Thread-Topic: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Thread-Index: AQHVdI4g9L3xPAeMJki3mq4fpV79C6dHrWSAgAFrf4CAABaxAIAAUs4AgAAPVoCAAOxxAA==
Date:   Fri, 4 Oct 2019 13:26:58 +0000
Message-ID: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
         <1570024819.4999.119.camel@linux.ibm.com>
         <20191003114119.GF8933@linux.intel.com>
         <1570107752.4421.183.camel@linux.ibm.com>
         <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
In-Reply-To: <1570128827.5046.19.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?utf-8?B?UEcxbGRHRStQR0YwSUc1dFBTSmliMlI1TG5SNGRDSWdjRDBpWXpwY2RYTmxj?=
 =?utf-8?B?bk5jTWpFeU5EY3pPVFV3WEdGd2NHUmhkR0ZjY205aGJXbHVaMXd3T1dRNE5E?=
 =?utf-8?B?bGlOaTB6TW1RekxUUmhOREF0T0RWbFpTMDJZamcwWW1FeU9XVXpOV0pjYlhO?=
 =?utf-8?B?bmMxeHRjMmN0WVRKa05qTTFOV1l0WlRaaFlTMHhNV1U1TFRobE5XTXRZVFJq?=
 =?utf-8?B?TTJZd1lqVTVPR0UyWEdGdFpTMTBaWE4wWEdFeVpEWXpOVFl3TFdVMllXRXRN?=
 =?utf-8?B?VEZsT1MwNFpUVmpMV0UwWXpObU1HSTFPVGhoTm1KdlpIa3VkSGgwSWlCemVq?=
 =?utf-8?B?MGlNemN6TlNJZ2REMGlNVE15TVRRMk5qa3lNVGMxT0RVME9ESTRJaUJvUFNK?=
 =?utf-8?B?dloyZDVXalpCVldVelVFNWpNekZyYUdsak9YRmFOMU5vZVc4OUlpQnBaRDBp?=
 =?utf-8?B?SWlCaWJEMGlNQ0lnWW04OUlqRWlJR05wUFNKalFVRkJRVVZTU0ZVeFVsTlNW?=
 =?utf-8?B?VVpPUTJkVlFVRkZiME5CUVVSelprZEtiSFF6Y2xaQldqWTNlSHB6WmtwTWNV?=
 =?utf-8?B?bHVjblpJVDNnNGEzVnZaMFJCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJTRUZCUVVGRVlVRlJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlJVRkJVVUZDUVVGQlFVWjBSMlZSZDBGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VW8wUVVGQlFtNUJSMVZCV0hkQ2FrRkhPRUZpWjBKdFFVZHJRVnBCUW14QlJ6?=
 =?utf-8?B?UkJaRUZDY0VGSFJVRmlRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGRlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFXZEJRVUZCUVVGdVowRkJRVWRqUVZwUlFtWkJSMmRCWVZGQ2JrRkhaMEZp?=
 =?utf-8?B?UVVJMVFVZE5RV0ozUW5WQlIxbEJZVkZDYTBGSFZVRmlaMEl3UVVkclFWbFJR?=
 =?utf-8?B?bk5CUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJV?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVU5CUVVGQlFVRkRaVUZCUVVGYWQwSnNRVVk0UVdKblFu?=
 =?utf-8?B?WkJSelJCWTBGQ01VRkhTVUZpUVVKd1FVZE5RVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUWtGQlFVRkJRVUZCUVVGSlFVRkJRVUZCUVQwOUlpOCtQQzl0?=
 =?utf-8?B?WlhSaFBnPT0=?=
x-dg-rorf: 
x-originating-ip: [3.159.19.191]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Subject: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040125
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBNaW1pIFpvaGFyIDx6b2hhckBsaW51eC5pYm0uY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgT2N0b2JlciAzLCAyMDE5IDI6NTQgUE0NCj4gVG86IEphcmtrbyBTYWtraW5lbiA8amFya2tv
LnNha2tpbmVuQGxpbnV4LmludGVsLmNvbT47IFNhZmZvcmQsIERhdmlkIChHRQ0KPiBTdWJqZWN0
OiBFWFQ6IFJlOiBbUEFUQ0hdIEtFWVM6IGFzeW1fdHBtOiBTd2l0Y2ggdG8gZ2V0X3JhbmRvbV9i
eXRlcygpDQo+IA0KPiBbQ2MnaW5nIERhdmlkIFNhZmZvcmRdDQo+IA0KPiBPbiBUaHUsIDIwMTkt
MTAtMDMgYXQgMjA6NTggKzAzMDAsIEphcmtrbyBTYWtraW5lbiB3cm90ZToNCj4gPiBPbiBUaHUs
IE9jdCAwMywgMjAxOSBhdCAwOTowMjozMkFNIC0wNDAwLCBNaW1pIFpvaGFyIHdyb3RlOg0KPiA+
ID4gT24gVGh1LCAyMDE5LTEwLTAzIGF0IDE0OjQxICswMzAwLCBKYXJra28gU2Fra2luZW4gd3Jv
dGU6DQo+ID4gPiA+IE9uIFdlZCwgT2N0IDAyLCAyMDE5IGF0IDEwOjAwOjE5QU0gLTA0MDAsIE1p
bWkgWm9oYXIgd3JvdGU6DQo+ID4gPiA+ID4gT24gVGh1LCAyMDE5LTA5LTI2IGF0IDIwOjE2ICsw
MzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6DQo+ID4gPiA+ID4gPiBPbmx5IHRoZSBrZXJuZWwg
cmFuZG9tIHBvb2wgc2hvdWxkIGJlIHVzZWQgZm9yIGdlbmVyYXRpbmcgcmFuZG9tDQo+IG51bWJl
cnMuDQo+ID4gPiA+ID4gPiBUUE0gY29udHJpYnV0ZXMgdG8gdGhhdCBwb29sIGFtb25nIHRoZSBv
dGhlciBzb3VyY2VzIG9mDQo+ID4gPiA+ID4gPiBlbnRyb3B5LiBJbiBoZXJlIGl0IGlzIG5vdCwg
YWdyZWVkLCBhYnNvbHV0ZWx5IGNyaXRpY2FsDQo+ID4gPiA+ID4gPiBiZWNhdXNlIFRQTSBpcyB3
aGF0IGlzIHRydXN0ZWQgYW55d2F5IGJ1dCBpbiBvcmRlciB0byByZW1vdmUNCj4gPiA+ID4gPiA+
IHRwbV9nZXRfcmFuZG9tKCkgd2UgbmVlZCB0byBmaXJzdCByZW1vdmUgYWxsIHRoZSBjYWxsIHNp
dGVzLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQXQgd2hhdCBwb2ludCBkdXJpbmcgYm9vdCBpcyB0
aGUga2VybmVsIHJhbmRvbSBwb29sIGF2YWlsYWJsZT8NCj4gPiA+ID4gPiBEb2VzIHRoaXMgaW1w
bHkgdGhhdCB5b3UncmUgcGxhbm5pbmcgb24gY2hhbmdpbmcgdHJ1c3RlZCBrZXlzIGFzIHdlbGw/
DQo+ID4gPiA+DQo+ID4gPiA+IFdlbGwgdHJ1c3RlZCBrZXlzICptdXN0KiBiZSBjaGFuZ2VkIHRv
IHVzZSBpdC4gSXQgaXMgbm90IGEgY2hvaWNlDQo+ID4gPiA+IGJlY2F1c2UgdXNpbmcgYSBwcm9w
cmlldGFyeSByYW5kb20gbnVtYmVyIGdlbmVyYXRvciBpbnN0ZWFkIG9mDQo+ID4gPiA+IGRlZmFj
dG8gb25lIGluIHRoZSBrZXJuZWwgY2FuIGJlIGNhdGVnb3JpemVkIGFzIGEgKnJlZ3Jlc3Npb24q
Lg0KPiA+ID4NCj4gPiA+IEkgcmVhbGx5IGRvbid0IHNlZSBob3cgdXNpbmcgdGhlIFRQTSByYW5k
b20gbnVtYmVyIGZvciBUUE0gdHJ1c3RlZA0KPiA+ID4ga2V5cyB3b3VsZCBiZSBjb25zaWRlcmVk
IGEgcmVncmVzc2lvbi4gwqBUaGF0IGJ5IGRlZmluaXRpb24gaXMgYQ0KPiA+ID4gdHJ1c3RlZCBr
ZXkuIMKgSWYgYW55dGhpbmcsIGNoYW5naW5nIHdoYXQgaXMgY3VycmVudGx5IGJlaW5nIGRvbmUN
Cj4gPiA+IHdvdWxkIGJlIHRoZSByZWdyZXNzaW9uLg0KPiA+DQo+ID4gSXQgaXMgcmVhbGx5IG5v
dCBhIFRQTSB0cnVzdGVkIGtleS4gSXQgdHJ1c3RlZCBrZXkgdGhhdCBnZXRzIHNlYWxlZA0KPiA+
IHdpdGggdGhlIFRQTS4gVGhlIGtleSBpdHNlbGYgaXMgdXNlZCBpbiBjbGVhciBieSBrZXJuZWwu
IFRoZSByYW5kb20NCj4gPiBudW1iZXIgZ2VuZXJhdG9yIGV4aXN0cyBpbiB0aGUga2VybmVsIHRv
IGZvciBhIHJlYXNvbi4NCj4gPg0KPiA+IEl0IGlzIHdpdGhvdXQgZG91YnQgYSByZWdyZXNzaW9u
Lg0KPiANCj4gWW91J3JlIG1pc3VzaW5nIHRoZSB0ZXJtICJyZWdyZXNzaW9uIiBoZXJlLiDCoEEg
cmVncmVzc2lvbiBpcyBzb21ldGhpbmcgdGhhdA0KPiBwcmV2aW91c2x5IHdvcmtlZCBhbmQgaGFz
IHN0b3BwZWQgd29ya2luZy4gwqBJbiB0aGlzIGNhc2UsIHRydXN0ZWQga2V5cyBoYXMNCj4gYWx3
YXlzIGJlZW4gYmFzZWQgb24gdGhlIFRQTSByYW5kb20gbnVtYmVyIGdlbmVyYXRvci4gwqBCZWZv
cmUgY2hhbmdpbmcNCj4gdGhpcywgdGhlcmUgbmVlZHMgdG8gYmUgc29tZSBndWFyYW50ZWVzIHRo
YXQgdGhlIGtlcm5lbCByYW5kb20gbnVtYmVyDQo+IGdlbmVyYXRvciBoYXMgYSBwb29sIG9mIHJh
bmRvbSBudW1iZXJzIGVhcmx5LCBvbiBhbGwgc3lzdGVtcyBpbmNsdWRpbmcNCj4gZW1iZWRkZWQg
ZGV2aWNlcywgbm90IGp1c3Qgc2VydmVycy4NCj4gDQo+IE1pbWkNCg0KQXMgdGhlIG9yaWdpbmFs
IGF1dGhvciBvZiB0cnVzdGVkIGtleXMsIGxldCBtZSBtYWtlIGEgZmV3IGNvbW1lbnRzLg0KRmly
c3QsIHRydXN0ZWQga2V5cyB3ZXJlIHNwZWNpZmljYWxseSBpbXBsZW1lbnRlZCBhbmQgKmRvY3Vt
ZW50ZWQqIHRvDQp1c2UgdGhlIFRQTSB0byBib3RoIGdlbmVyYXRlIGFuZCBzZWFsIGtleXMuIEl0
cyBrZXJuZWwgZG9jdW1lbnRhdGlvbg0Kc3BlY2lmaWNhbGx5IHN0YXRlcyB0aGlzIGFzIGEgcHJv
bWlzZSB0byB1c2VyIHNwYWNlLiBJZiB5b3Ugd2FudCB0byBoYXZlIA0KYSBkaWZmZXJlbnQga2V5
IHN5c3RlbSB0aGF0IHVzZXMgdGhlIHJhbmRvbSBwb29sIHRvIGdlbmVyYXRlIHRoZSBrZXlzLA0K
ZmluZSwgYnV0IGRvbid0IGNoYW5nZSB0cnVzdGVkIGtleXMsIGFzIHRoYXQgY2hhbmdlcyB0aGUg
ZXhpc3RpbmcgcHJvbWlzZQ0KdG8gdXNlciBzcGFjZS4gDQoNClRoZXJlIGFyZSBtYW55IGdvb2Qg
cmVhc29ucyBmb3Igd2FudGluZyB0aGUga2V5cyB0byBiZSBiYXNlZCBvbiB0aGUNClRQTSBnZW5l
cmF0b3IuICBBcyB0aGUgc291cmNlIGZvciB0aGUga2VybmVsIHJhbmRvbSBudW1iZXIgZ2VuZXJh
dG9yDQppdHNlbGYgc2F5cywgc29tZSBzeXN0ZW1zIGxhY2sgZ29vZCByYW5kb21uZXNzIGF0IHN0
YXJ0dXAsIGFuZCBzeXN0ZW1zDQpzaG91bGQgcHJlc2VydmUgYW5kIHJlbG9hZCB0aGUgcG9vbCBh
Y3Jvc3Mgc2h1dGRvd24gYW5kIHN0YXJ0dXAuDQpUaGVyZSBhcmUgdXNlIGNhc2VzIGZvciB0cnVz
dGVkIGtleXMgd2hpY2ggbmVlZCB0byBnZW5lcmF0ZSBrZXlzIA0KYmVmb3JlIHN1Y2ggc2NyaXB0
cyBoYXZlIHJ1bi4gQWxzbywgaW4gc29tZSB1c2UgY2FzZXMsIHdlIG5lZWQgdG8gc2hvdw0KdGhh
dCB0cnVzdGVkIGtleXMgYXJlIEZJUFMgY29tcGxpYW50LCB3aGljaCBpcyBwb3NzaWJsZSB3aXRo
IFRQTQ0KZ2VuZXJhdGVkIGtleXMuDQoNClNlY29uZCwgdGhlIFRQTSBpcyBoYXJkbHkgYSAicHJv
cHJpZXRhcnkgcmFuZG9tIG51bWJlciBnZW5lcmF0b3IiLg0KSXQgaXMgYW4gb3BlbiBzdGFuZGFy
ZCB3aXRoIG11bHRpcGxlIGltcGxlbWVudGF0aW9ucywgbWFueSBvZiB3aGljaCBhcmUNCkZJUFMg
Y2VydGlmaWVkLg0KDQpUaGlyZCwgYXMgTWltaSBzdGF0ZXMsIHVzaW5nIGEgVFBNIGlzIG5vdCBh
ICJyZWdyZXNzaW9uIi4gSXQgd291bGQgYmUgYQ0KcmVncmVzc2lvbiB0byBjaGFuZ2UgdHJ1c3Rl
ZCBrZXlzIF9ub3RfIHRvIHVzZSB0aGUgVFBNLCBiZWNhdXNlIHRoYXQNCmlzIHdoYXQgdHJ1c3Rl
ZCBrZXlzIGFyZSBkb2N1bWVudGVkIHRvIHByb3ZpZGUgdG8gdXNlciBzcGFjZS4NCg0KZGF2ZQ0K
DQo=
