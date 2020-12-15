Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E030C2DAA2F
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgLOJhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:37:36 -0500
Received: from spam01.hygon.cn ([110.188.70.11]:18259 "EHLO spam2.hygon.cn"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727699AbgLOJh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 04:37:27 -0500
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam2.hygon.cn with ESMTP id 0BF9Zb9Q005328;
        Tue, 15 Dec 2020 17:35:37 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from cncheex02.Hygon.cn ([172.23.18.12])
        by MK-FE.hygon.cn with ESMTP id 0BF9ZbF0061133;
        Tue, 15 Dec 2020 17:35:37 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from cncheex01.Hygon.cn (172.23.18.10) by cncheex02.Hygon.cn
 (172.23.18.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Tue, 15 Dec
 2020 17:35:33 +0800
Received: from cncheex01.Hygon.cn ([172.23.18.10]) by cncheex01.Hygon.cn
 ([172.23.18.10]) with mapi id 15.01.1466.003; Tue, 15 Dec 2020 17:35:33 +0800
From:   Shan Chen <chenshan@hygon.cn>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "alikernel-developer@linux.alibaba.com" 
        <alikernel-developer@linux.alibaba.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Yuanchen Ma <mayuanchen@hygon.cn>, Hao Feng <fenghao@hygon.cn>,
        Zhiwei Ying <yingzhiwei@hygon.cn>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Shan Chen <chenshan@hygon.cn>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIEFsaU9TIDQuMTkgdjMgMTEvMTVdIEtFWVM6IHRydXN0?=
 =?gb2312?B?ZWQ6IGFsbG93IG1vZHVsZSBpbml0IGlmIFRQTSBpcyBpbmFjdGl2ZSBvciBk?=
 =?gb2312?Q?eactivated?=
Thread-Topic: [PATCH AliOS 4.19 v3 11/15] KEYS: trusted: allow module init if
 TPM is inactive or deactivated
Thread-Index: AQHW0rx6v7AcU4kPP0iNt+UcVbbCPqn3XIKAgACGRhA=
Date:   Tue, 15 Dec 2020 09:35:33 +0000
Message-ID: <8411d5fe0630417885e0d68dd30db7ad@hygon.cn>
References: <cover.1608019826.git.chenshan@hygon.cn>
 <a28cb67324fee8afabc7912f5045788e74e0aff9.1608019826.git.chenshan@hygon.cn>
 <X9iAuzeS1wJDPVLg@kroah.com>
In-Reply-To: <X9iAuzeS1wJDPVLg@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.44]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MAIL: spam2.hygon.cn 0BF9Zb9Q005328
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCg0KLVNoYW4NCg0KPiAtLS0tLdPKvP7Urbz+LS0tLS0NCj4gt6K8/sjLOiBHcmVnIEtIIFtt
YWlsdG86Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmddDQo+ILeiy83KsbzkOiAyMDIwxOoxMtTC
MTXI1SAxNzoyNA0KPiDK1bz+yMs6IFNoYW4gQ2hlbiA8Y2hlbnNoYW5AaHlnb24uY24+DQo+ILOt
y806IGFsaWtlcm5lbC1kZXZlbG9wZXJAbGludXguYWxpYmFiYS5jb207IFJvYmVydG8gU2Fzc3UN
Cj4gPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT47IFl1YW5jaGVuIE1hIDxtYXl1YW5jaGVuQGh5
Z29uLmNuPjsgSGFvDQo+IEZlbmcgPGZlbmdoYW9AaHlnb24uY24+OyBaaGl3ZWkgWWluZyA8eWlu
Z3poaXdlaUBoeWdvbi5jbj47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IEphcmtrbyBTYWtr
aW5lbiA8amFya2tvLnNha2tpbmVuQGxpbnV4LmludGVsLmNvbT4NCj4g1vfM4jogUmU6IFtQQVRD
SCBBbGlPUyA0LjE5IHYzIDExLzE1XSBLRVlTOiB0cnVzdGVkOiBhbGxvdyBtb2R1bGUgaW5pdCBp
ZiBUUE0NCj4gaXMgaW5hY3RpdmUgb3IgZGVhY3RpdmF0ZWQNCj4gDQo+IE9uIFR1ZSwgRGVjIDE1
LCAyMDIwIGF0IDA0OjI5OjE4UE0gKzA4MDAsIFNoYW4gd3JvdGU6DQo+ID4gRnJvbTogUm9iZXJ0
byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+DQo+ID4gY29tbWl0IDJkNmMy
NTIxNWFiMjZiYjAwOWRlMzU3NWZhYWI3YjY4NWYxMzhlOTIgdXBzdHJlYW0uDQo+ID4NCj4gPiBD
b21taXQgYzc4NzE5MjAzZmM2ICgiS0VZUzogdHJ1c3RlZDogYWxsb3cgdHJ1c3RlZC5rbyB0byBp
bml0aWFsaXplDQo+ID4gdy9vIGENCj4gPiBUUE0iKSBhbGxvd3MgdGhlIHRydXN0ZWQgbW9kdWxl
IHRvIGJlIGxvYWRlZCBldmVuIGlmIGEgVFBNIGlzIG5vdA0KPiA+IGZvdW5kLCB0byBhdm9pZCBt
b2R1bGUgZGVwZW5kZW5jeSBwcm9ibGVtcy4NCj4gPg0KPiA+IEhvd2V2ZXIsIHRydXN0ZWQgbW9k
dWxlIGluaXRpYWxpemF0aW9uIGNhbiBzdGlsbCBmYWlsIGlmIHRoZSBUUE0gaXMNCj4gPiBpbmFj
dGl2ZSBvciBkZWFjdGl2YXRlZC4gdHBtX2dldF9yYW5kb20oKSByZXR1cm5zIGFuIGVycm9yLg0K
PiA+DQo+ID4gVGhpcyBwYXRjaCByZW1vdmVzIHRoZSBjYWxsIHRvIHRwbV9nZXRfcmFuZG9tKCkg
YW5kIGluc3RlYWQgZXh0ZW5kcw0KPiA+IHRoZSBQQ1Igc3BlY2lmaWVkIGJ5IHRoZSB1c2VyIHdp
dGggemVyb3MuIFRoZSBzZWN1cml0eSBvZiB0aGlzDQo+ID4gYWx0ZXJuYXRpdmUgaXMgZXF1aXZh
bGVudCB0byB0aGUgcHJldmlvdXMgb25lLCBhcyBlaXRoZXIgb3B0aW9uDQo+ID4gcHJldmVudHMg
d2l0aCBhIFBDUiB1cGRhdGUgdW5zZWFsaW5nIGFuZCBtaXN1c2Ugb2Ygc2VhbGVkIGRhdGEgYnkg
YSB1c2VyDQo+IHNwYWNlIHByb2Nlc3MuDQo+ID4NCj4gPiBFdmVuIGlmIGEgUENSIGlzIGV4dGVu
ZGVkIHdpdGggemVyb3MsIGluc3RlYWQgb2YgcmFuZG9tIGRhdGEsIGl0IGlzDQo+ID4gc3RpbGwg
Y29tcHV0YXRpb25hbGx5IGluZmVhc2libGUgdG8gZmluZCBhIHZhbHVlIGFzIGlucHV0IGZvciBh
IG5ldw0KPiA+IFBDUiBleHRlbmQgb3BlcmF0aW9uLCB0byBvYnRhaW4gYWdhaW4gdGhlIFBDUiB2
YWx1ZSB0aGF0IHdvdWxkIGFsbG93DQo+IHVuc2VhbGluZy4NCj4gPg0KPiA+IENjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQo+ID4gRml4ZXM6IDI0MDczMDQzN2RlYiAoIktFWVM6IHRydXN0ZWQ6
IGV4cGxpY2l0bHkgdXNlIHRwbV9jaGlwDQo+ID4gc3RydWN0dXJlLi4uIikNCj4gPiBTaWduZWQt
b2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IFR5bGVyIEhpY2tzIDx0eWhpY2tzQGNhbm9uaWNhbC5jb20+DQo+ID4gU3VnZ2Vz
dGVkLWJ5OiBNaW1pIFpvaGFyIDx6b2hhckBsaW51eC5pYm0uY29tPg0KPiA+IFJldmlld2VkLWJ5
OiBKYXJra28gU2Fra2luZW4gPGphcmtrby5zYWtraW5lbkBsaW51eC5pbnRlbC5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogSmFya2tvIFNha2tpbmVuIDxqYXJra28uc2Fra2luZW5AbGludXguaW50
ZWwuY29tPg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogbWF5dWFuY2hlbiA8bWF5dWFuY2hlbkBo
eWdvbi5jbj4NCj4gPiBDaGFuZ2UtSWQ6IElhZGEwZTA1MmMyYWI0YTBmYmMyZGI0YWMyNjkwZGEz
MTE1ZDk4NWM2DQo+ID4gU2lnbmVkLW9mZi1ieTogU2hhbiA8Y2hlbnNoYW5AaHlnb24uY24+DQo+
ID4gLS0tDQo+ID4gIHNlY3VyaXR5L2tleXMvdHJ1c3RlZC5jIHwgMTMgLS0tLS0tLS0tLS0tLQ0K
PiA+ICAxIGZpbGUgY2hhbmdlZCwgMTMgZGVsZXRpb25zKC0pDQo+IA0KPiBXaHkgaXMgdGhpcyBi
ZWluZyBzZW50IHRvIHRoZSBzdGFibGUgbGlzdD8gIERvIHlvdSB3YW50IHRoaXMgYmFja3BvcnRl
ZCB0bw0KPiA0LjE5Lnk/ICBJZiBzbywgd2h5LCBhbmQgd2hhdCBpcyB0aGUgY2hhbmdlLWlkIHN0
dWZmIGluIHRoZXJlIGZvcj8NCj4gDQo+IGNvbmZ1c2VkLA0KPiANCj4gZ3JlZyBrLWgNCg0KU29y
cnkgZm9yIHRoZSBkaXN0dXJiaW5nLCBpdCdzIG5vdCBtZWFudCBmb3IgdGhlIGtlcm5lbCBjb21t
dW5pdHkuIFdlJ3JlIGJhY2twb3J0aW5nIHRoaXMgY29tbWl0IGZvciBzb21lIHByaXZhdGUgdXNh
Z2UsIGFuZCBjYXJlbGVzc2x5IHNlbnQgb3V0IHRoaXMgbWFpbCBhcyBnaXQgc2VuZC1lbWFpbCBh
dXRvbWF0aWNhbGx5IGNjJ2VkIHRoZSBzb2IgbGlzdGVkIGFkZHJlc3Nlcy4gSGF2ZSBoYWQgdGhl
IGNjIHN1cHByZXNzZWQuIHBscyBpZ25vcmUuIFRoYW5rcyENCg0KU2hhbg0K
