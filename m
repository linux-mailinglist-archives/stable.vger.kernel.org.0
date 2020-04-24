Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E21B73B7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDXMSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:18:14 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbgDXMSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:18:14 -0400
Received: from lhreml740-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 3F53095920E6AD0816A0;
        Fri, 24 Apr 2020 13:18:12 +0100 (IST)
Received: from fraeml706-chm.china.huawei.com (10.206.15.55) by
 lhreml740-chm.china.huawei.com (10.201.108.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Fri, 24 Apr 2020 13:18:12 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 24 Apr 2020 14:18:11 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Fri, 24 Apr 2020 14:18:11 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 3/5] ima: Fix ima digest hash table key calculation
Thread-Topic: [PATCH 3/5] ima: Fix ima digest hash table key calculation
Thread-Index: AQHWAsCL0WxU1zQQXUO+TcKy4wW9saiFqfKAgAD8PeCAAFIUgIABYaXQ
Date:   Fri, 24 Apr 2020 12:18:11 +0000
Message-ID: <59a280b928db4c478f660d14c33cdd87@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-3-roberto.sassu@huawei.com>
         <1587588987.5165.20.camel@linux.ibm.com>
         <11984a05a5624f64aed1ec6b0d0b75ff@huawei.com>
 <1587660781.5610.15.camel@linux.ibm.com>
In-Reply-To: <1587660781.5610.15.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.14.239]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5h
Z2luZyBEaXJlY3RvcjogTGkgUGVuZywgTGkgSmlhbiwgU2hpIFlhbmxpDQoNCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaW1pIFpvaGFyIFttYWlsdG86em9oYXJAbGlu
dXguaWJtLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDIzLCAyMDIwIDY6NTMgUE0NCj4g
VG86IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4NCj4gQ2M6IGxpbnV4
LWludGVncml0eUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNlY3VyaXR5LW1vZHVsZUB2Z2VyLmtl
cm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEtyenlzenRvZiBTdHJ1
Y3p5bnNraQ0KPiA8a3J6eXN6dG9mLnN0cnVjenluc2tpQGh1YXdlaS5jb20+OyBTaWx2aXUgVmxh
c2NlYW51DQo+IDxTaWx2aXUuVmxhc2NlYW51QGh1YXdlaS5jb20+OyBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMy81XSBpbWE6IEZpeCBpbWEgZGlnZXN0IGhh
c2ggdGFibGUga2V5IGNhbGN1bGF0aW9uDQo+IA0KPiBPbiBUaHUsIDIwMjAtMDQtMjMgYXQgMTA6
MjEgKzAwMDAsIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4gPiBIaSBSb2JlcnRvLCBLcnN5c3p0
b2YsDQo+ID4gPg0KPiA+ID4gT24gV2VkLCAyMDIwLTAzLTI1IGF0IDE3OjExICswMTAwLCBSb2Jl
cnRvIFNhc3N1IHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBLcnp5c3p0b2YgU3RydWN6eW5za2kgPGty
enlzenRvZi5zdHJ1Y3p5bnNraUBodWF3ZWkuY29tPg0KPiA+ID4gPg0KPiA+ID4gPiBGdW5jdGlv
biBoYXNoX2xvbmcoKSBhY2NlcHRzIHVuc2lnbmVkIGxvbmcsIHdoaWxlIGN1cnJlbnRseSBvbmx5
IG9uZQ0KPiBieXRlDQo+ID4gPiA+IGlzIHBhc3NlZCBmcm9tIGltYV9oYXNoX2tleSgpLCB3aGlj
aCBjYWxjdWxhdGVzIGEga2V5IGZvciBpbWFfaHRhYmxlLg0KPiA+ID4gVXNlDQo+ID4gPiA+IG1v
cmUgYnl0ZXMgdG8gYXZvaWQgZnJlcXVlbnQgY29sbGlzaW9ucy4NCj4gPiA+ID4NCj4gPiA+ID4g
TGVuZ3RoIG9mIHRoZSBidWZmZXIgaXMgbm90IGV4cGxpY2l0bHkgcGFzc2VkIGFzIGEgZnVuY3Rp
b24gcGFyYW1ldGVyLA0KPiA+ID4gPiBiZWNhdXNlIHRoaXMgZnVuY3Rpb24gZXhwZWN0cyBhIGRp
Z2VzdCB3aG9zZSBsZW5ndGggaXMgZ3JlYXRlciB0aGFuDQo+IHRoZQ0KPiA+ID4gPiBzaXplIG9m
IHVuc2lnbmVkIGxvbmcuDQo+ID4gPg0KPiA+ID4gU29tZWhvdyBJIG1pc3NlZCB0aGUgb3JpZ2lu
YWwgcmVwb3J0IG9mIHRoaXMgcHJvYmxlbcKgaHR0cHM6Ly9sb3JlLmtlcm4NCj4gPiA+IGVsLm9y
Zy9wYXRjaHdvcmsvcGF0Y2gvNjc0Njg0Ly4gwqBUaGlzIHBhdGNoIGlzIGRlZmluaXRlbHkgYmV0
dGVyLCBidXQNCj4gPiA+IGhvdyBtYW55IHVuaXF1ZSBrZXlzIGFyZSBhY3R1YWxseSBiZWluZyB1
c2VkPyDCoElzIGl0IGFueXdoZXJlIG5lYXINCj4gPiA+IElNQV9NRUFTVVJFX0hUQUJMRV9TSVpF
KDUxMik/DQo+ID4NCj4gPiBJIGRpZCBhIHNtYWxsIHRlc3QgKHdpdGggMTA0MyBtZWFzdXJlbWVu
dHMpOg0KPiA+DQo+ID4gc2xvdHM6IDI1MCwgbWF4IGRlcHRoOiA5ICh3aXRob3V0IHRoZSBwYXRj
aCkNCj4gPiBzbG90czogNDQ4LCBtYXggZGVwdGg6IDcgKHdpdGggdGhlIHBhdGNoKQ0KPiANCj4g
NDQ4IG91dCBvZiA1MTIgc2xvdHMgYXJlIHVzZWQuDQo+IA0KPiA+DQo+ID4gVGhlbiwgSSBpbmNy
ZWFzZWQgdGhlIG51bWJlciBvZiBiaXRzIHRvIDEwOg0KPiA+DQo+ID4gc2xvdHM6IDI1MSwgbWF4
IGRlcHRoOiA5ICh3aXRob3V0IHRoZSBwYXRjaCkNCj4gPiBzbG90czogNjYwLCBtYXggZGVwdGg6
IDQgKHdpdGggdGhlIHBhdGNoKQ0KPiANCj4gNjYwIG91dCBvZiAxMDI0IHNsb3RzIGFyZSB1c2Vk
Lg0KPiANCj4gSSB3b25kZXIgaWYgdGhlcmUgaXMgYW55IGJlbmVmaXQgdG8gaGFzaGluZyBhIGRp
Z2VzdCwgaW5zdGVhZCBvZiBqdXN0DQo+IHVzaW5nIHRoZSBmaXJzdCBiaXRzLg0KDQpCZWZvcmUg
SSBjYWxjdWxhdGVkIG1heCBkZXB0aCB1bnRpbCB0aGVyZSBpcyBhIG1hdGNoLCBub3QgdGhlIGZ1
bGwgZGVwdGguDQoNCiMxDQpyZXR1cm4gaGFzaF9sb25nKCooKHVuc2lnbmVkIGxvbmcgKilkaWdl
c3QpLCBJTUFfSEFTSF9CSVRTKTsNCiNkZWZpbmUgSU1BX0hBU0hfQklUUyA5DQoNClJ1bnRpbWUg
bWVhc3VyZW1lbnRzOiAxNDg4DQpWaW9sYXRpb25zOiAwDQpTbG90cyAodXNlZC9hdmFpbGFibGUp
OiA0ODQvNTEyDQpNYXggZGVwdGggaGFzaCB0YWJsZTogMTANCg0KIzINCnJldHVybiAqKHVuc2ln
bmVkIGxvbmcgKilkaWdlc3QgJSBJTUFfTUVBU1VSRV9IVEFCTEVfU0laRTsNCiNkZWZpbmUgSU1B
X0hBU0hfQklUUyA5DQoNClJ1bnRpbWUgbWVhc3VyZW1lbnRzOiAxNDkxDQpWaW9sYXRpb25zOiAy
DQpTbG90cyAodXNlZC9hdmFpbGFibGUpOiA0ODkvNTEyDQpNYXggZGVwdGggaGFzaCB0YWJsZTog
MTANCg0KIzMNCnJldHVybiBoYXNoX2xvbmcoKigodW5zaWduZWQgbG9uZyAqKWRpZ2VzdCksIElN
QV9IQVNIX0JJVFMpOw0KI2RlZmluZSBJTUFfSEFTSF9CSVRTIDEwDQoNClJ1bnRpbWUgbWVhc3Vy
ZW1lbnRzOiAxNDg5DQpWaW9sYXRpb25zOiAwDQpTbG90cyAodXNlZC9hdmFpbGFibGUpOiA3ODAv
MTAyNA0KTWF4IGRlcHRoIGhhc2ggdGFibGU6IDYNCg0KIzQNCnJldHVybiAqKHVuc2lnbmVkIGxv
bmcgKilkaWdlc3QgJSBJTUFfTUVBU1VSRV9IVEFCTEVfU0laRTsNCiNkZWZpbmUgSU1BX0hBU0hf
QklUUyAxMA0KDQpSdW50aW1lIG1lYXN1cmVtZW50czogMTQ4OQ0KVmlvbGF0aW9uczogMA0KU2xv
dHMgKHVzZWQvYXZhaWxhYmxlKTogNzkzLzEwMjQNCk1heCBkZXB0aCBoYXNoIHRhYmxlOiA2DQoN
ClJvYmVydG8NCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYw
NjMNCk1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBMaSBKaWFuLCBTaGkgWWFubGkNCg0KDQo+
ID4gPiBEbyB3ZSBuZWVkIGEgbmV3IHNlY3VyaXR5ZnMgZW50cnkgdG8gZGlzcGxheSB0aGUgbnVt
YmVyIHVzZWQ/DQo+ID4NCj4gPiBQcm9iYWJseSBpdCBpcyB1c2VmdWwgb25seSBpZiB0aGUgYWRt
aW5pc3RyYXRvciBjYW4gZGVjaWRlIHRoZSBudW1iZXIgb2YNCj4gc2xvdHMuDQo+IA0KPiBUaGUg
c2VjdXJpdHlmcyBzdWdnZXN0aW9uIHdhcyBqdXN0IGEgbWVhbnMgZm9yIHRyaWdnZXJpbmcgdGhl
IGFib3ZlDQo+IGRlYnVnZ2luZyBpbmZvIHlvdSBwcm92aWRlZC4gwqBDb3VsZCB5b3UgcHJvdmlk
ZSBhbm90aGVyIHBhdGNoIHdpdGggdGhlDQo+IGRlYnVnZ2luZyBpbmZvPw0KPiANCj4gdGhhbmtz
LA0KPiANCj4gTWltaQ0KDQo=
