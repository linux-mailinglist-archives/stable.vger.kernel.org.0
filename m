Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4B2FA05
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfE3KNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 06:13:09 -0400
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:15394 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726515AbfE3KNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 06:13:09 -0400
Received: from ZXBJCAS.zhaoxin.com (10.29.252.3) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 30 May
 2019 18:10:27 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXBJCAS.zhaoxin.com
 (10.29.252.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 30 May
 2019 17:13:39 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 30 May
 2019 17:13:39 +0800
Received: from zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d]) by
 zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d%16]) with mapi id
 15.01.1261.035; Thu, 30 May 2019 17:13:39 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     "tipbot@zytor.com" <tipbot@zytor.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>
CC:     "bp@suse.de" <bp@suse.de>, "hpa@zytor.com" <hpa@zytor.com>,
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
Subject: =?gb2312?B?tPC4tDogUmU6IFt0aXA6eDg2L3VyZ2VudF0geDg2L21jZTogRW5zdXJlIG9m?=
 =?gb2312?B?ZmxpbmUgQ1BVcyBkb24nIHQgcGFydGljaXBhdGUgaW4gcmVuZGV6dm91cyBw?=
 =?gb2312?Q?rocess?=
Thread-Topic: Re: [tip:x86/urgent] x86/mce: Ensure offline CPUs don' t
 participate in rendezvous process
Thread-Index: AdUWlGl+Ivql5y3zT0ybuVHbqcI6gAAJtEFg
Date:   Thu, 30 May 2019 09:13:39 +0000
Message-ID: <985acf114ab245fbab52caabf03bd280@zhaoxin.com>
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

T24gVGh1LCBNYXkgMzAsIDIwMTksIFRvbnkgVyBXYW5nLW9jIHdyb3RlOg0KPiBIaSBBc2hvaywN
Cj4gSSBoYXZlIHR3byBxdWVzdGlvbnMgYWJvdXQgdGhpcyBwYXRjaCwgY291bGQgeW91IGhlbHAg
dG8gY2hlY2s6DQo+IA0KPiAxLCBmb3IgYnJvYWRjYXN0ICNNQyBleGNlcHRpb25zLCB0aGlzIHBh
dGNoIHNlZW1zIHJlcXVpcmUgI01DIGV4Y2VwdGlvbg0KPiBlcnJvcnMNCj4gc2V0IE1DR19TVEFU
VVNfUklQViA9IDEuDQo+IEJ1dCBmb3IgSW50ZWwgQ1BVLCBzb21lICNNQyBleGNlcHRpb24gZXJy
b3JzIHNldCBNQ0dfU1RBVFVTX1JJUFYgPSAwDQo+IChsaWtlICJSZWNvdmVyYWJsZS1ub3QtY29u
dGludWFibGUgU1JBUiBUeXBlIiBFcnJvcnMpLCBmb3IgdGhlc2UgZXJyb3JzDQo+IHRoZSBwYXRj
aCBkb2Vzbid0IHNlZW0gdG8gd29yaywgaXMgdGhhdCBva2F5Pw0KPiANCj4gMiwgZm9yIExNQ0Ug
ZXhjZXB0aW9ucywgdGhpcyBwYXRjaCBzZWVtcyByZXF1aXJlICNNQyBleGNlcHRpb24gZXJyb3Jz
DQo+IHNldCBNQ0dfU1RBVFVTX1JJUFYgPSAwIHRvIG1ha2Ugc3VyZSBMTUNFIGJlIGhhbmRsZWQg
bm9ybWFsbHkgZXZlbg0KPiBvbiBvZmZsaW5lIENQVS4NCj4gRm9yIExNQ0UgZXJyb3JzIHNldCBN
Q0dfU1RBVVNfUklQViA9IDEsIHRoZSBwYXRjaCBwcmV2ZW50cyBvZmZsaW5lIENQVQ0KPiBoYW5k
bGUgdGhlc2UgTE1DRSBlcnJvcnMsIGlzIHRoYXQgb2theT8NCj4gDQoNCk1vcmUgc3BlY2lmaWNh
bGx5LCB0aGlzIHBhdGNoIHNlZW1zIHJlcXVpcmUgI01DIGV4Y2VwdGlvbnMgbWVldCB0aGUgY29u
ZGl0aW9uDQoiTUNHX1NUQVRVU19SSVBWIF4gTUNHX1NUQVRVU19MTUNFUyA9PSAxIjsgQnV0IG9u
IGEgWGVvbiBYNTY1MCBtYWNoaW5lIChTTVApLCANCiJEYXRhIENBQ0hFIExldmVsLTIgR2VuZXJp
YyBFcnJvciIgZG9lcyBub3QgbWVldCB0aGlzIGNvbmRpdGlvbi4NCg0KSSBnb3QgYmVsb3cgbWVz
c2FnZSBmcm9tOiBodHRwczovL3d3dy5jZW50b3Mub3JnL2ZvcnVtcy92aWV3dG9waWMucGhwP3A9
MjkyNzQyDQoNCkhhcmR3YXJlIGV2ZW50LiBUaGlzIGlzIG5vdCBhIHNvZnR3YXJlIGVycm9yLg0K
TUNFIDANCkNQVSA0IEJBTksgNiBUU0MgYjcwNjVlZWFhMThiMCANClRJTUUgMTU0NTY0MzYwMyBN
b24gRGVjIDI0IDEwOjI2OjQzIDIwMTgNCk1DRyBzdGF0dXM6TUNJUCANCk1DaSBzdGF0dXM6DQpV
bmNvcnJlY3RlZCBlcnJvcg0KRXJyb3IgZW5hYmxlZA0KUHJvY2Vzc29yIGNvbnRleHQgY29ycnVw
dA0KTUNBOiBEYXRhIENBQ0hFIExldmVsLTIgR2VuZXJpYyBFcnJvcg0KU1RBVFVTIGIyMDAwMDAw
ODAwMDAxMDYgTUNHU1RBVFVTIDQNCk1DR0NBUCAxYzA5IEFQSUNJRCA0IFNPQ0tFVElEIDAgDQpD
UFVJRCBWZW5kb3IgSW50ZWwgRmFtaWx5IDYgTW9kZWwgNDQNCg0KPiBUaGFua3MNCj4gVG9ueSBX
IFdhbmctb2MNCg==
