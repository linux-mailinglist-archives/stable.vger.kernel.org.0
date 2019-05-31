Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA13430702
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 05:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEaDcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 23:32:20 -0400
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:38650 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726487AbfEaDcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 23:32:20 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2019 23:32:18 EDT
Received: from zxbjmbx3.zhaoxin.com (10.29.252.165) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Fri, 31 May
 2019 11:17:09 +0800
Received: from zxbjmbx3.zhaoxin.com (10.29.252.165) by zxbjmbx3.zhaoxin.com
 (10.29.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Fri, 31 May
 2019 11:17:08 +0800
Received: from zxbjmbx3.zhaoxin.com ([fe80::57b:6f00:3193:d8a6]) by
 zxbjmbx3.zhaoxin.com ([fe80::57b:6f00:3193:d8a6%8]) with mapi id
 15.01.1261.035; Fri, 31 May 2019 11:17:08 +0800
From:   David Wang <DavidWang@zhaoxin.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
CC:     "tipbot@zytor.com" <tipbot@zytor.com>, "bp@suse.de" <bp@suse.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: =?gb2312?B?tPC4tDogtPC4tDogUmU6IFt0aXA6eDg2L3VyZ2VudF0geDg2L21jZTogRW5z?=
 =?gb2312?B?dXJlIG9mZmxpbmUgQ1BVcyBkb24nIHQgcGFydGljaXBhdGUgaW4gcmVuZGV6?=
 =?gb2312?Q?vous_process?=
Thread-Topic: =?gb2312?B?tPC4tDogUmU6IFt0aXA6eDg2L3VyZ2VudF0geDg2L21jZTogRW5zdXJlIG9m?=
 =?gb2312?B?ZmxpbmUgQ1BVcyBkb24nIHQgcGFydGljaXBhdGUgaW4gcmVuZGV6dm91cyBw?=
 =?gb2312?Q?rocess?=
Thread-Index: AdUWlGl+Ivql5y3zT0ybuVHbqcI6gAAJtEFgAAMVQgAAJY7k0A==
Date:   Fri, 31 May 2019 03:17:07 +0000
Message-ID: <9907ff256ff74f65aff89255bae3b92f@zhaoxin.com>
References: <985acf114ab245fbab52caabf03bd280@zhaoxin.com>
 <20190530171044.GA18559@araj-mobl1.jf.intel.com>
In-Reply-To: <20190530171044.GA18559@araj-mobl1.jf.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.29.24.48]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1haWwtLS0tLQ0KPiBTZW5kZXI6IFJhaiwgQXNob2sgPGFzaG9rLnJh
akBpbnRlbC5jb20+DQo+IFRpbWU6IDIwMTkuMDUuMzEgMToxMQ0KPiBUbyA6IFRvbnkgVyBXYW5n
LW9jIDxUb255V1dhbmctb2NAemhhb3hpbi5jb20+DQo+IENDOiB0aXBib3RAenl0b3IuY29tOyBi
cEBzdXNlLmRlOyBocGFAenl0b3IuY29tOw0KPiBsaW51eC1lZGFjQHZnZXIua2VybmVsLm9yZzsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtdGlwLWNvbW1pdHNAdmdlci5r
ZXJuZWwub3JnOyBtaW5nb0BrZXJuZWwub3JnOyBwZXRlcnpAaW5mcmFkZWFkLm9yZzsNCj4gc3Rh
YmxlQHZnZXIua2VybmVsLm9yZzsgdGdseEBsaW51dHJvbml4LmRlOyB0b255Lmx1Y2tAaW50ZWwu
Y29tOw0KPiB0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZzsgRGF2aWQgV2FuZyA8RGF2aWRX
YW5nQHpoYW94aW4uY29tPjsgQXNob2sNCj4gUmFqIDxhc2hvay5yYWpAaW50ZWwuY29tPg0KPiBU
b3BpYzogUmU6IFJlOiBSZTogW3RpcDp4ODYvdXJnZW50XSB4ODYvbWNlOiBFbnN1cmUgb2ZmbGlu
ZSBDUFVzIGRvbicgdA0KPiBwYXJ0aWNpcGF0ZSBpbiByZW5kZXp2b3VzIHByb2Nlc3MNCj4gDQo+
IE9uIFRodSwgTWF5IDMwLCAyMDE5IGF0IDA5OjEzOjM5QU0gKzAwMDAsIFRvbnkgVyBXYW5nLW9j
IHdyb3RlOg0KPiA+IE9uIFRodSwgTWF5IDMwLCAyMDE5LCBUb255IFcgV2FuZy1vYyB3cm90ZToN
Cj4gPiA+IEhpIEFzaG9rLA0KPiA+ID4gSSBoYXZlIHR3byBxdWVzdGlvbnMgYWJvdXQgdGhpcyBw
YXRjaCwgY291bGQgeW91IGhlbHAgdG8gY2hlY2s6DQo+ID4gPg0KPiA+ID4gMSwgZm9yIGJyb2Fk
Y2FzdCAjTUMgZXhjZXB0aW9ucywgdGhpcyBwYXRjaCBzZWVtcyByZXF1aXJlICNNQw0KPiA+ID4g
ZXhjZXB0aW9uIGVycm9ycyBzZXQgTUNHX1NUQVRVU19SSVBWID0gMS4NCj4gPiA+IEJ1dCBmb3Ig
SW50ZWwgQ1BVLCBzb21lICNNQyBleGNlcHRpb24gZXJyb3JzIHNldCBNQ0dfU1RBVFVTX1JJUFYg
PSAwDQo+ID4gPiAobGlrZSAiUmVjb3ZlcmFibGUtbm90LWNvbnRpbnVhYmxlIFNSQVIgVHlwZSIg
RXJyb3JzKSwgZm9yIHRoZXNlDQo+ID4gPiBlcnJvcnMgdGhlIHBhdGNoIGRvZXNuJ3Qgc2VlbSB0
byB3b3JrLCBpcyB0aGF0IG9rYXk/DQo+ID4gPg0KPiA+ID4gMiwgZm9yIExNQ0UgZXhjZXB0aW9u
cywgdGhpcyBwYXRjaCBzZWVtcyByZXF1aXJlICNNQyBleGNlcHRpb24NCj4gPiA+IGVycm9ycyBz
ZXQgTUNHX1NUQVRVU19SSVBWID0gMCB0byBtYWtlIHN1cmUgTE1DRSBiZSBoYW5kbGVkIG5vcm1h
bGx5DQo+ID4gPiBldmVuIG9uIG9mZmxpbmUgQ1BVLg0KPiA+ID4gRm9yIExNQ0UgZXJyb3JzIHNl
dCBNQ0dfU1RBVVNfUklQViA9IDEsIHRoZSBwYXRjaCBwcmV2ZW50cyBvZmZsaW5lDQo+ID4gPiBD
UFUgaGFuZGxlIHRoZXNlIExNQ0UgZXJyb3JzLCBpcyB0aGF0IG9rYXk/DQo+ID4gPg0KPiA+DQo+
ID4gTW9yZSBzcGVjaWZpY2FsbHksIHRoaXMgcGF0Y2ggc2VlbXMgcmVxdWlyZSAjTUMgZXhjZXB0
aW9ucyBtZWV0IHRoZQ0KPiA+IGNvbmRpdGlvbiAiTUNHX1NUQVRVU19SSVBWIF4gTUNHX1NUQVRV
U19MTUNFUyA9PSAxIjsgQnV0IG9uIGEgWGVvbg0KPiA+IFg1NjUwIG1hY2hpbmUgKFNNUCksDQo+
IA0KPiBUaGUgb2ZmbGluZSBDUFUgd2lsbCBuZXZlciBnZXQgYSBMTUNFPTEsIHNpbmNlIHRob3Nl
IG9ubHkgaGFwcGVuIG9uIHRoZSBDUFUNCj4gdGhhdCdzIGRvaW5nIGFjdGl2ZSB3b3JrLiBPZmZs
aW5lIENQVXMganVzdCBzaXR0aW5nIGluIGlkbGUuDQpTbywgZm9yIGludGVsIENQVSwgTE1DRSBp
cyBvbmx5IGZvciBUaHJlYWQgbGV2ZWwob3IgY29yZSBsZXZlbCkgZXJyb3I/IElmIG5vdCwgc3Vw
cG9zZSAyIHRocmVhZHMNCnNoYXJlIGxldmVsLTIgY2FjaGUuIEFuZCB0aHJlYWQgMCBpcyBhY3Rp
dmUsIHRocmVhZCAxIHdhcyBvZmZsaW5lZCBieSBTVy4gV2hlbiBNQ0UgZm9yIHRoaXMgbGV2ZWwt
Mg0KY2FjaGUgb2NjdXJyZWQsIHRocmVhZCAxIHdpbGwgYmUgYWN0aXZlLiBXaGVuIHRocmVhZCAx
IHJlYWQgbWNnc3RhdHVzLmxtY2UsIHRoZSByZXN1bHQgd2lsbCBiZSBhbHdheXMgMD8NCg0KVGhh
bmtzLg0KPiANCj4gVGhlIHNwZWNpZmljIGVycm9yIGhlcmUgaXMgYSBQQ0M9MSwgc28gaXJyZXNw
ZWN0aXZlIG9mIHdoYXQgaGFwcGVucyBXZSBkbyBjYXB0dXJlDQo+IHRoZSBlcnJvcnMgaW4gdGhl
IHBlci1jcHUgbG9nLCBhbmQga2VybmVsIHdvdWxkIHBhbmljLg0KPiANCj4gV2hhdCBzcGVjaWZp
Y2FsbHkgdGhpcyBwYXRjaCB0cmllcyB0byBhY2hpZXZlIGlzIHRvIGxlYXZlIGFuIGVycm9yIHNp
dHRpbmcgd2l0aA0KPiBNQ0ctU1RBVFVTLk1DSVA9MSBhbmQgYW5vdGhlciByZWNvdmVyYWJsZSBl
cnJvciB3b3VsZCBzaHV0IHRoZSBzeXN0ZW0NCj4gZG93bS4NCj4gDQo+IEkgZG9uJ3Qgc2VlIGFu
eXRoaW5nIHdyb25nIHdpdGggd2hhdCB0aGlzIHBhdGNoIGRvZXMuLg0KPiANCj4gPiAiRGF0YSBD
QUNIRSBMZXZlbC0yIEdlbmVyaWMgRXJyb3IiIGRvZXMgbm90IG1lZXQgdGhpcyBjb25kaXRpb24u
DQo+ID4NCj4gPiBJIGdvdCBiZWxvdyBtZXNzYWdlIGZyb206DQo+ID4gaHR0cHM6Ly93d3cuY2Vu
dG9zLm9yZy9mb3J1bXMvdmlld3RvcGljLnBocD9wPTI5Mjc0Mg0KPiA+DQo+ID4gSGFyZHdhcmUg
ZXZlbnQuIFRoaXMgaXMgbm90IGEgc29mdHdhcmUgZXJyb3IuDQo+ID4gTUNFIDANCj4gPiBDUFUg
NCBCQU5LIDYgVFNDIGI3MDY1ZWVhYTE4YjANCj4gPiBUSU1FIDE1NDU2NDM2MDMgTW9uIERlYyAy
NCAxMDoyNjo0MyAyMDE4IE1DRyBzdGF0dXM6TUNJUCBNQ2kgc3RhdHVzOg0KPiA+IFVuY29ycmVj
dGVkIGVycm9yDQo+ID4gRXJyb3IgZW5hYmxlZA0KPiA+IFByb2Nlc3NvciBjb250ZXh0IGNvcnJ1
cHQNCj4gPiBNQ0E6IERhdGEgQ0FDSEUgTGV2ZWwtMiBHZW5lcmljIEVycm9yDQo+ID4gU1RBVFVT
IGIyMDAwMDAwODAwMDAxMDYgTUNHU1RBVFVTIDQNCj4gPiBNQ0dDQVAgMWMwOSBBUElDSUQgNCBT
T0NLRVRJRCAwDQo+ID4gQ1BVSUQgVmVuZG9yIEludGVsIEZhbWlseSA2IE1vZGVsIDQ0DQo+ID4N
Cj4gPiA+IFRoYW5rcw0KPiA+ID4gVG9ueSBXIFdhbmctb2MNCg==
