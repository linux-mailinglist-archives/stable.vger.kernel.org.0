Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4A2307D8
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 06:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfEaEln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 00:41:43 -0400
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:44738 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbfEaEln (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 00:41:43 -0400
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Fri, 31 May
 2019 12:41:37 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Fri, 31 May
 2019 12:41:37 +0800
Received: from zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d]) by
 zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d%16]) with mapi id
 15.01.1261.035; Fri, 31 May 2019 12:41:37 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
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
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        David Wang <DavidWang@zhaoxin.com>
Subject: =?gb2312?B?tPC4tDogtPC4tDogUmU6IFt0aXA6eDg2L3VyZ2VudF0geDg2L21jZTogRW5z?=
 =?gb2312?B?dXJlIG9mZmxpbmUgQ1BVcyBkb24nIHQgcGFydGljaXBhdGUgaW4gcmVuZGV6?=
 =?gb2312?Q?vous_process?=
Thread-Topic: =?gb2312?B?tPC4tDogUmU6IFt0aXA6eDg2L3VyZ2VudF0geDg2L21jZTogRW5zdXJlIG9m?=
 =?gb2312?B?ZmxpbmUgQ1BVcyBkb24nIHQgcGFydGljaXBhdGUgaW4gcmVuZGV6dm91cyBw?=
 =?gb2312?Q?rocess?=
Thread-Index: AdUWlGl+Ivql5y3zT0ybuVHbqcI6gAAJtEFgAAMVQgAAJq81AA==
Date:   Fri, 31 May 2019 04:41:37 +0000
Message-ID: <d6b75abaedd844eb87bfbe3f1f364795@zhaoxin.com>
References: <985acf114ab245fbab52caabf03bd280@zhaoxin.com>
 <20190530171044.GA18559@araj-mobl1.jf.intel.com>
In-Reply-To: <20190530171044.GA18559@araj-mobl1.jf.intel.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.64.23]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCBNYXkgMzEsIDIwMTksIFJhaiwgQXNob2sgd3JvdGU6DQo+IE9uIFRodSwgTWF5IDMw
LCAyMDE5IGF0IDA5OjEzOjM5QU0gKzAwMDAsIFRvbnkgVyBXYW5nLW9jIHdyb3RlOg0KPiA+IE9u
IFRodSwgTWF5IDMwLCAyMDE5LCBUb255IFcgV2FuZy1vYyB3cm90ZToNCj4gPiA+IEhpIEFzaG9r
LA0KPiA+ID4gSSBoYXZlIHR3byBxdWVzdGlvbnMgYWJvdXQgdGhpcyBwYXRjaCwgY291bGQgeW91
IGhlbHAgdG8gY2hlY2s6DQo+ID4gPg0KPiA+ID4gMSwgZm9yIGJyb2FkY2FzdCAjTUMgZXhjZXB0
aW9ucywgdGhpcyBwYXRjaCBzZWVtcyByZXF1aXJlICNNQyBleGNlcHRpb24NCj4gPiA+IGVycm9y
cw0KPiA+ID4gc2V0IE1DR19TVEFUVVNfUklQViA9IDEuDQo+ID4gPiBCdXQgZm9yIEludGVsIENQ
VSwgc29tZSAjTUMgZXhjZXB0aW9uIGVycm9ycyBzZXQgTUNHX1NUQVRVU19SSVBWID0gMA0KPiA+
ID4gKGxpa2UgIlJlY292ZXJhYmxlLW5vdC1jb250aW51YWJsZSBTUkFSIFR5cGUiIEVycm9ycyks
IGZvciB0aGVzZSBlcnJvcnMNCj4gPiA+IHRoZSBwYXRjaCBkb2Vzbid0IHNlZW0gdG8gd29yaywg
aXMgdGhhdCBva2F5Pw0KPiA+ID4NCj4gPiA+IDIsIGZvciBMTUNFIGV4Y2VwdGlvbnMsIHRoaXMg
cGF0Y2ggc2VlbXMgcmVxdWlyZSAjTUMgZXhjZXB0aW9uIGVycm9ycw0KPiA+ID4gc2V0IE1DR19T
VEFUVVNfUklQViA9IDAgdG8gbWFrZSBzdXJlIExNQ0UgYmUgaGFuZGxlZCBub3JtYWxseSBldmVu
DQo+ID4gPiBvbiBvZmZsaW5lIENQVS4NCj4gPiA+IEZvciBMTUNFIGVycm9ycyBzZXQgTUNHX1NU
QVVTX1JJUFYgPSAxLCB0aGUgcGF0Y2ggcHJldmVudHMgb2ZmbGluZSBDUFUNCj4gPiA+IGhhbmRs
ZSB0aGVzZSBMTUNFIGVycm9ycywgaXMgdGhhdCBva2F5Pw0KPiA+ID4NCj4gPg0KPiA+IE1vcmUg
c3BlY2lmaWNhbGx5LCB0aGlzIHBhdGNoIHNlZW1zIHJlcXVpcmUgI01DIGV4Y2VwdGlvbnMgbWVl
dCB0aGUNCj4gY29uZGl0aW9uDQo+ID4gIk1DR19TVEFUVVNfUklQViBeIE1DR19TVEFUVVNfTE1D
RVMgPT0gMSI7IEJ1dCBvbiBhIFhlb24gWDU2NTANCj4gbWFjaGluZSAoU01QKSwNCj4gDQo+IFRo
ZSBvZmZsaW5lIENQVSB3aWxsIG5ldmVyIGdldCBhIExNQ0U9MSwgc2luY2UgdGhvc2Ugb25seSBo
YXBwZW4gb24gdGhlIENQVQ0KPiB0aGF0J3MgZG9pbmcgYWN0aXZlIHdvcmsuIE9mZmxpbmUgQ1BV
cyBqdXN0IHNpdHRpbmcgaW4gaWRsZS4NCj4gDQo+IFRoZSBzcGVjaWZpYyBlcnJvciBoZXJlIGlz
IGEgUENDPTEsIHNvIGlycmVzcGVjdGl2ZSBvZiB3aGF0IGhhcHBlbnMNCj4gV2UgZG8gY2FwdHVy
ZSB0aGUgZXJyb3JzIGluIHRoZSBwZXItY3B1IGxvZywgYW5kIGtlcm5lbCB3b3VsZCBwYW5pYy4N
Cj4gDQo+IFdoYXQgc3BlY2lmaWNhbGx5IHRoaXMgcGF0Y2ggdHJpZXMgdG8gYWNoaWV2ZSBpcyB0
byBsZWF2ZSBhbiBlcnJvcg0KPiBzaXR0aW5nIHdpdGggTUNHLVNUQVRVUy5NQ0lQPTEgYW5kIGFu
b3RoZXIgcmVjb3ZlcmFibGUgZXJyb3Igd291bGQgc2h1dA0KPiB0aGUNCj4gc3lzdGVtIGRvd20u
DQpZZXMsIGFncmVlIHdpdGggeW91IGZvciB0aGlzIHBvaW50Lg0KDQpCdXQgZm9yIHF1ZXN0aW9u
IDEsIFdoZW4gc29tZSAjTUMgZXhjZXB0aW9uIGVycm9ycyBicm9hZGNhc3QgdG8gb2ZmbGluZSBD
UFUsDQpsaWtlICJSZWNvdmVyYWJsZS1ub3QtY29udGludWFibGUgU1JBUiBUeXBlIiBFcnJvcnMs
IHNldCBNQ0dfU1RBVFVTX1JJUFYgPSAwLCANClBDQyA9IDAsIGlzIHRoZXJlIGFsc28gdGhlIHBy
b2JsZW0gOiAiIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBUaW1lb3V0OiBOb3QgYWxsIENQ
VXMgDQplbnRlcmVkIGJyb2FkY2FzdCBleGNlcHRpb24gaGFuZGxlciI/DQoNClRoYW5rcw0KPiAN
Cj4gSSBkb24ndCBzZWUgYW55dGhpbmcgd3Jvbmcgd2l0aCB3aGF0IHRoaXMgcGF0Y2ggZG9lcy4u
DQo+IA0KPiA+ICJEYXRhIENBQ0hFIExldmVsLTIgR2VuZXJpYyBFcnJvciIgZG9lcyBub3QgbWVl
dCB0aGlzIGNvbmRpdGlvbi4NCj4gPg0KPiA+IEkgZ290IGJlbG93IG1lc3NhZ2UgZnJvbToNCj4g
aHR0cHM6Ly93d3cuY2VudG9zLm9yZy9mb3J1bXMvdmlld3RvcGljLnBocD9wPTI5Mjc0Mg0KPiA+
DQo+ID4gSGFyZHdhcmUgZXZlbnQuIFRoaXMgaXMgbm90IGEgc29mdHdhcmUgZXJyb3IuDQo+ID4g
TUNFIDANCj4gPiBDUFUgNCBCQU5LIDYgVFNDIGI3MDY1ZWVhYTE4YjANCj4gPiBUSU1FIDE1NDU2
NDM2MDMgTW9uIERlYyAyNCAxMDoyNjo0MyAyMDE4DQo+ID4gTUNHIHN0YXR1czpNQ0lQDQo+ID4g
TUNpIHN0YXR1czoNCj4gPiBVbmNvcnJlY3RlZCBlcnJvcg0KPiA+IEVycm9yIGVuYWJsZWQNCj4g
PiBQcm9jZXNzb3IgY29udGV4dCBjb3JydXB0DQo+ID4gTUNBOiBEYXRhIENBQ0hFIExldmVsLTIg
R2VuZXJpYyBFcnJvcg0KPiA+IFNUQVRVUyBiMjAwMDAwMDgwMDAwMTA2IE1DR1NUQVRVUyA0DQo+
ID4gTUNHQ0FQIDFjMDkgQVBJQ0lEIDQgU09DS0VUSUQgMA0KPiA+IENQVUlEIFZlbmRvciBJbnRl
bCBGYW1pbHkgNiBNb2RlbCA0NA0KPiA+DQo+ID4gPiBUaGFua3MNCj4gPiA+IFRvbnkgVyBXYW5n
LW9jDQo=
