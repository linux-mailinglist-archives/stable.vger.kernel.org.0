Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6F1B48E9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgDVPjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 11:39:21 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbgDVPjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 11:39:21 -0400
Received: from lhreml719-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id B66DEF958287947BB4C1;
        Wed, 22 Apr 2020 16:39:19 +0100 (IST)
Received: from fraeml705-chm.china.huawei.com (10.206.15.54) by
 lhreml719-chm.china.huawei.com (10.201.108.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Wed, 22 Apr 2020 16:39:19 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 22 Apr 2020 17:39:18 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Wed, 22 Apr 2020 17:39:18 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: RE: [PATCH 1/5] ima: Set file->f_mode instead of file->f_flags in
 ima_calc_file_hash()
Thread-Topic: [PATCH 1/5] ima: Set file->f_mode instead of file->f_flags in
 ima_calc_file_hash()
Thread-Index: AQHWAsBIfWLB8bRS20i6QFRA3R5usKiFFOmAgABdoMA=
Date:   Wed, 22 Apr 2020 15:39:18 +0000
Message-ID: <d20f3ea6f2fe425bb8234b1bd5a2f6a9@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
 <1587556981.5738.7.camel@linux.ibm.com>
In-Reply-To: <1587556981.5738.7.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.19.211]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1pbnRlZ3JpdHktb3du
ZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtaW50ZWdyaXR5LQ0KPiBvd25lckB2Z2Vy
Lmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBNaW1pIFpvaGFyDQo+IFNlbnQ6IFdlZG5lc2RheSwg
QXByaWwgMjIsIDIwMjAgMjowMyBQTQ0KPiBUbzogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNz
dUBodWF3ZWkuY29tPg0KPiBDYzogbGludXgtaW50ZWdyaXR5QHZnZXIua2VybmVsLm9yZzsgbGlu
dXgtc2VjdXJpdHktbW9kdWxlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsgS3J6eXN6dG9mIFN0cnVjenluc2tpDQo+IDxrcnp5c3p0b2Yuc3RydWN6eW5z
a2lAaHVhd2VpLmNvbT47IFNpbHZpdSBWbGFzY2VhbnUNCj4gPFNpbHZpdS5WbGFzY2VhbnVAaHVh
d2VpLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IEdvbGR3eW4NCj4gUm9kcmlndWVzIDxy
Z29sZHd5bkBzdXNlLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzVdIGltYTogU2V0IGZp
bGUtPmZfbW9kZSBpbnN0ZWFkIG9mIGZpbGUtPmZfZmxhZ3MgaW4NCj4gaW1hX2NhbGNfZmlsZV9o
YXNoKCkNCj4gDQo+IFtDQydpbmcgR29sZHd5biBSb2RyaWd1ZXNdDQo+IA0KPiBIaSBSb2JlcnRv
LA0KPiANCj4gT24gV2VkLCAyMDIwLTAzLTI1IGF0IDE3OjExICswMTAwLCBSb2JlcnRvIFNhc3N1
IHdyb3RlOg0KPiA+IENvbW1pdCBhNDA4ZTRhODZiMzYgKCJpbWE6IG9wZW4gYSBuZXcgZmlsZSBp
bnN0YW5jZSBpZiBubyByZWFkDQo+ID4gcGVybWlzc2lvbnMiKSB0cmllcyB0byBjcmVhdGUgYSBu
ZXcgZmlsZSBkZXNjcmlwdG9yIHRvIGNhbGN1bGF0ZSBhIGZpbGUNCj4gPiBkaWdlc3QgaWYgdGhl
IGZpbGUgaGFzIG5vdCBiZWVuIG9wZW5lZCB3aXRoIE9fUkRPTkxZIGZsYWcuIEhvd2V2ZXIsIGlm
IGENCj4gPiBuZXcgZmlsZSBkZXNjcmlwdG9yIGNhbm5vdCBiZSBvYnRhaW5lZCwgaXQgc2V0cyB0
aGUgRk1PREVfUkVBRCBmbGFnIHRvDQo+ID4gZmlsZS0+Zl9mbGFncyBpbnN0ZWFkIG9mIGZpbGUt
PmZfbW9kZS4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggZml4ZXMgdGhpcyBpc3N1ZSBieSByZXBsYWNp
bmcgZl9mbGFncyB3aXRoIGZfbW9kZSBhcyBpdCB3YXMNCj4gPiBiZWZvcmUgdGhhdCBjb21taXQu
DQo+ID4NCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDQuMjAueA0KPiA+IEZpeGVz
OiBhNDA4ZTRhODZiMzYgKCJpbWE6IG9wZW4gYSBuZXcgZmlsZSBpbnN0YW5jZSBpZiBubyByZWFk
DQo+IHBlcm1pc3Npb25zIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2Jl
cnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIHNlY3VyaXR5L2ludGVncml0eS9p
bWEvaW1hX2NyeXB0by5jIHwgNCArKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvaW50
ZWdyaXR5L2ltYS9pbWFfY3J5cHRvLmMNCj4gYi9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9j
cnlwdG8uYw0KPiA+IGluZGV4IDQyM2M4NGY5NWExNC4uOGFiMTdhYTg2N2RkIDEwMDY0NA0KPiA+
IC0tLSBhL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX2NyeXB0by5jDQo+ID4gKysrIGIvc2Vj
dXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfY3J5cHRvLmMNCj4gPiBAQCAtNDM2LDcgKzQzNiw3IEBA
IGludCBpbWFfY2FsY19maWxlX2hhc2goc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdA0KPiBpbWFf
ZGlnZXN0X2RhdGEgKmhhc2gpDQo+ID4gIAkJCSAqLw0KPiANCj4gVGhhbmtzLCBSb2JlcnRvLiDC
oFRoZSBjb21tZW50IGFib3ZlIGhlcmUgYW5kIHRoZSByZXN0IG9mIHRoZSBjb2RlDQo+IHJlZmVy
cyB0byBmbGFncy4gwqBCb3RoIHNob3VsZCBiZSB1cGRhdGVkIGFzIHdlbGwgdG8gcmVmbGVjdCB1
c2luZw0KPiBmX21vZGUuDQo+IA0KPiA+ICAJCQlwcl9pbmZvX3JhdGVsaW1pdGVkKCJVbmFibGUg
dG8gcmVvcGVuIGZpbGUgZm9yDQo+IHJlYWRpbmcuXG4iKTsNCj4gPiAgCQkJZiA9IGZpbGU7DQo+
ID4gLQkJCWYtPmZfZmxhZ3MgfD0gRk1PREVfUkVBRDsNCj4gPiArCQkJZi0+Zl9tb2RlIHw9IEZN
T0RFX1JFQUQ7DQo+ID4gIAkJCW1vZGlmaWVkX2ZsYWdzID0gdHJ1ZTsNCj4gDQo+IFRoZSB2YXJp
YWJsZSBzaG91bGQgYmUgY2hhbmdlZCB0byAibW9kaWZpZWRfbW9kZSIuDQoNCk9rLiBJIHdpbGwg
c2VuZCBhIG5ldyB2ZXJzaW9uIG9mIHRoZSBwYXRjaC4NCg0KVGhhbmtzDQoNClJvYmVydG8NCg0K
SFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5n
IERpcmVjdG9yOiBMaSBQZW5nLCBMaSBKaWFuLCBTaGkgWWFubGkNCg0KDQo+ID4gIAkJfSBlbHNl
IHsNCj4gPiAgCQkJbmV3X2ZpbGVfaW5zdGFuY2UgPSB0cnVlOw0KPiA+IEBAIC00NTYsNyArNDU2
LDcgQEAgaW50IGltYV9jYWxjX2ZpbGVfaGFzaChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0DQo+
IGltYV9kaWdlc3RfZGF0YSAqaGFzaCkNCj4gPiAgCWlmIChuZXdfZmlsZV9pbnN0YW5jZSkNCj4g
PiAgCQlmcHV0KGYpOw0KPiA+ICAJZWxzZSBpZiAobW9kaWZpZWRfZmxhZ3MpDQo+ID4gLQkJZi0+
Zl9mbGFncyAmPSB+Rk1PREVfUkVBRDsNCj4gPiArCQlmLT5mX21vZGUgJj0gfkZNT0RFX1JFQUQ7
DQo+ID4gIAlyZXR1cm4gcmM7DQo+ID4gIH0NCj4gPg0KDQo=
