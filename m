Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50033CD0EE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhGSIwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:52:01 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11342 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbhGSIwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 04:52:01 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GSxN02dXVz7tC7;
        Mon, 19 Jul 2021 17:28:00 +0800 (CST)
Received: from dggemm752-chm.china.huawei.com (10.1.198.58) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:32:34 +0800
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemm752-chm.china.huawei.com (10.1.198.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:32:33 +0800
Received: from dggpeml500012.china.huawei.com ([7.185.36.15]) by
 dggpeml500012.china.huawei.com ([7.185.36.15]) with mapi id 15.01.2176.012;
 Mon, 19 Jul 2021 17:32:33 +0800
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
To:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        Zhangjinhao <zhangjinhao2@huawei.com>
Subject: Re: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with an
 RFC 1042 header
Thread-Topic: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with
 an RFC 1042 header
Thread-Index: Add8gNg9YxChjnyiaUybPD5ycvjjTw==
Date:   Mon, 19 Jul 2021 09:32:33 +0000
Message-ID: <dafba7c92a8b434fb5f1644d379af4fd@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.110.218]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNy8xNy8yMSAxOTo1NSwgTWF0aHkgVmFuaG9lZiB3cm90ZToNCj4gT24gNy8xNi8yMSAxMTox
MSBBTSwgWmhlbmcgWWVqaWFuIHdyb3RlOg0KPiA+IEluIHY0LjQsIGNvbW1pdCBlNzY1MTFhNmZi
YjUgKCJtYWM4MDIxMTogcHJvcGVybHkgaGFuZGxlIEEtTVNEVXMgdGhhdA0KPiA+IHN0YXJ0IHdp
dGggYW4gUkZDIDEwNDIgaGVhZGVyIikgbG9va3MgbGlrZSBhbiBpbmNvbXBsZXRlIGJhY2twb3J0
Lg0KPiA+DQo+ID4gVGhlcmUgaXMgbm8gZnVuY3Rpb25hbCBjaGFuZ2VzIGluIHRoZSBjb21taXQs
IHNpbmNlDQo+ID4gX19pZWVlODAyMTFfZGF0YV90b184MDIzKCkgd2hpY2ggZGVmaW5lZCBpbiBu
ZXQvd2lyZWxlc3MvdXRpbC5jIGlzDQo+ID4gb25seSBjYWxsZWQgYnkgaWVlZTgwMjExX2RhdGFf
dG9fODAyMygpIGFuZCBwYXJhbWV0ZXIgJ2lzX2Ftc2R1JyBpcw0KPiA+IGFsd2F5cyBpbnB1dCBh
cyBmYWxzZS4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhlcmUncyBhIHByb2JsZW0gaGVyZS4gVGhl
IGNvcmUgY29tbWl0IHRoYXQgcHJldmVudHMgdGhlDQo+IEEtTVNEVSBhdHRhY2sgaXMgIltQQVRD
SCAwNC8xOF0gY2ZnODAyMTE6IG1pdGlnYXRlIEEtTVNEVSBhZ2dyZWdhdGlvbg0KPiBhdHRhY2tz
IjoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtDQo+IHdpcmVsZXNzLzIwMjEwNTEx
MjAwMTEwLjI1ZDkzMTc2ZGRhZi5JOWUyNjViNTk3ZjJjZDIzZWI0NDU3M2YzNWI2MjU5NA0KPiA3
YjM4NmE5ZGVAY2hhbmdlaWQvDQo+IA0KPiBUaGF0IGNvbW1pdCBzdGF0ZXM6ICJmb3Iga2VybmVs
IDQuOSBhbmQgYWJvdmUgdGhpcyBwYXRjaCBkZXBlbmRzIG9uDQo+ICJtYWM4MDIxMTogcHJvcGVy
bHkgaGFuZGxlIEEtTVNEVXMgdGhhdCBzdGFydCB3aXRoIGEgcmZjMTA0MiBoZWFkZXIiLg0KPiBP
dGhlcndpc2UgdGhpcyBwYXRjaCBoYXMgbm8gaW1wYWN0IGFuZCBhdHRhY2tzIHdpbGwgcmVtYWlu
IHBvc3NpYmxlLiINCj4gDQo+IFB1dCBkaWZmZXJlbnRseSwgd2hlbiBwYXRjaGluZyB2NC40IHRo
ZXJlIHdhcyBpbiBmYWN0IG5vIG5lZWQgdG8NCj4gYmFja3BvcnQgdGhlIHBhdGNoIHRoYXQgd2Un
cmUgZGlzY3Vzc2luZyBoZXJlLiBTbyBpdCBtYWtlcyBzZW5zZSB0aGF0DQo+IHRoZSAiYmFja3Bv
cnRlZCIgcGF0Y2hlcyBjYXVzZXMgbm8gZnVuY3Rpb25hbCBjaGFuZ2VzLg0KPiANCj4gU2VjdGlv
biAzLjYgb2YgaHR0cHM6Ly9wYXBlcnMubWF0aHl2YW5ob2VmLmNvbS91c2VuaXgyMDIxLnBkZiBi
cmllZmx5DQo+IGRpc2N1c3NlcyB0aGUgd3JvbmcgYmVoYXZpb3Igb2YgTGludXggNC45KyB0aGF0
IHRoaXMgcGF0Y2ggdHJpZXMgdG8gZml4Og0KPiAiTGludXggNC45IGFuZCBhYm92ZSAuLiBzdHJp
cCBhd2F5IHRoZSBmaXJzdCA4IGJ5dGVzIG9mIGFuIEEtTVNEVSBmcmFtZQ0KPiBpZiB0aGVzZSBi
eXRlcyBsb29rIGxpa2UgYSB2YWxpZCBMTEMvU05BUCBoZWFkZXIsIGFuZCB0aGVuIGZ1cnRoZXIN
Cj4gcHJvY2VzcyB0aGUgZnJhbWUuIFRoaXMgYmVoYXZpb3IgaXMgbm90IGNvbXBsaWFudCB3aXRo
IHRoZSA4MDIuMTEgc3RhbmRhcmQuIg0KPiANCg0KSG93IGFib3V0IGxpbnV4IDQuOSBiZWxvdywg
YXJlIHRoZXkgY29tcGxpYW50ICB3aXRoIDgwMi4xMSBzdGFuZGFyZCBvciBub3Q/DQpXb3VsZCB0
aGV5IG5lZWQgYWRkaXRpb25hbCBwYXRjaGVzIHRvIG1pdGlnYXRlIHRoZSBhZ2dyZWdhdGlvbiBh
dHRhY2s/IA0KSSBrbm93IGxpdHRsZSBhYm91dCA4MDIuMTEgc3RhbmRhcmQsIHNvcnJ5IGZvciB0
aGF0IDogKA0KDQo+IFRoYXQgc2FpZCwgSSBkaWRuJ3QgeWV0IHJ1biB0aGUgdGVzdCB0b29sIGFn
YWluc3QgYSBwYXRjaGVkIDQuNCBrZXJuZWwsDQo+IHNvIEkgaG9wZSBteSB1bmRlcnN0YW5kaW5n
IG9mIHRoaXMgY29kZSBpbiB0aGlzIHZlcnNpb24gaXMgY29ycmVjdC4NCj4gDQo+IEJlc3QgcmVn
YXJkcywNCj4gTWF0aHkNCg0KVGhhbmtzLA0KWmhlbmcgWWVqaWFuDQo=
